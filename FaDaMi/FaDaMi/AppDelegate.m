//
//  AppDelegate.m
//  FaDaMi
//
//  Created by apple on 16/12/21.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "IQKeyboardManager.h"
#import "FDMTabBarControllerConfig.h"
#import <StoreKit/StoreKit.h>
//讯飞
#import <iflyMSC/IFlyMSC.h>
//检测更新
#import "Harpy.h"
#import "LoginViewController.h"
// 高德地图
#import "APIKey.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
// 友盟
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialSinaHandler.h"

#import "QMUIConfigurationTemplate.h"

#import "MobClick.h"
#import "UMessage.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif
/**
 *  掉帧测试
 */
//#import "KMCGeigerCounter.h"

@interface AppDelegate ()<UITabBarControllerDelegate,SKStoreProductViewControllerDelegate,UNUserNotificationCenterDelegate,HarpyDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    application.applicationIconBadgeNumber = 0;

    WEAKSELF
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        
        //键盘配置
        [[IQKeyboardManager sharedManager] setEnable:YES];
        [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        [self umengTrack];//友盟统计
        //高德地图
        [weakSelf setMapEvent];
        //友盟分享
        [weakSelf uMSocialEvent];
        [weakSelf setIFlyVoice];
        [NetWorkMangerTools theAutomaticLoginEvent];
    });

    //监测版本
    [self checkVersionUpdate];
    [self configurationQMUITemplate];
    FDMTabBarControllerConfig *tabBarControllerConfig = [[FDMTabBarControllerConfig alloc] init];
    tabBarControllerConfig.tabBarController.delegate = self;
    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    [self.window makeKeyAndVisible];

    return YES;
}
#pragma mark -UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
        if ([PublicFunction ShareInstance].m_bLogin == NO) {
            LoginViewController *loginVC = [LoginViewController new];
            [tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:loginVC] animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}
#pragma mark - 配置 QMUI
- (void)configurationQMUITemplate {
    
    // 启动QMUI的配置模板
    [QMUIConfigurationTemplate setupConfigurationTemplate];
    
    // 将全局的控件样式渲染出来
    [QMUIConfigurationManager renderGlobalAppearances];
    [QMUIHelper renderStatusBarStyleLight];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    //设置缓存
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];

}
#pragma mark -配置地图
- (void)setMapEvent {
    
    if ([APIKey length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"apiKey为空，请检查key是否正确设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}
#pragma mark - 讯飞
- (void)setIFlyVoice {
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    [IFlySetting showLogcat:YES];
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}
#pragma mark -监测版本
- (void)checkVersionUpdate {
    
    [CalculateManager detectionOfUpdatePlistFile];//更新plist文件
    [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];
    [[Harpy sharedInstance] setDelegate:self];
    [[Harpy sharedInstance] setAppID:@"1105833212"];
    [[Harpy sharedInstance] setAppName:@"周道慧法"];
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeSkip];
    [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageChineseSimplified];
    [[Harpy sharedInstance] setDebugEnabled:true];
    [[Harpy sharedInstance] checkVersion];
}

#pragma mark -友盟分享
- (void)uMSocialEvent {
    
    // 获取友盟social版本号
    DLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
    //打开调试log的开关
    [[UMSocialManager defaultManager] openLog:YES];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:ZDWXAPPKEY appSecret:ZDWXAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:ZDQQAPPKEY  appSecret:ZDQQAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    //    [UMSocialHandler setSupportWebView:YES];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:ZDWBAPPKEY  appSecret:ZDWBAppSecret redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}
#pragma mark -友盟统计
- (void)umengTrack {
    
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    NSString *version = [QZManager getBuildVersion];
    [MobClick setAppVersion:version];
    UMConfigInstance.appKey = UMENG_APPKEY;
    UMConfigInstance.ePolicy = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];
    /**
     *  UMConfigInstance.channelId =  默认会被被当作@"App Store"渠道
     *  [MobClick updateOnlineConfig];  //在线参数配置
     */
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    [[IFlySpeechUtility getUtility] handleOpenURL:url];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
