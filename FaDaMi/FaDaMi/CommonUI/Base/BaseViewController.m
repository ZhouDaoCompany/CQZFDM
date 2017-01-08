//
//  BaseViewController.m
//  ZhouDao
//
//  Created by apple on 16/12/21.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "BaseViewController.h"
//#import "CompensationVC.h"
//#import "GcNoticeUtil.h"
//#import "PushAlertWindow.h"
//#import "ToolsWedViewVC.h"

@interface BaseViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSDictionary *notiDic;

@end

@implementation BaseViewController

- (void)dealloc {
    [GcNoticeUtil removeNotification:@"presentView"
                            Observer:self
                              Object:nil];
}
#pragma mark - life cycle
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [GcNoticeUtil handleNotification:@"presentView"
//                            Selector:@selector(presentview:)
//                            Observer:self];
//}
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [GcNoticeUtil removeNotification:@"presentView"
//                            Observer:self
//                              Object:nil];
//}
- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)initSubviews {
   [super initSubviews];
   [self setAutomaticallyAdjustsScrollViewInsets:NO];
   //    [self setEdgesForExtendedLayout:UIRectEdgeNone];
   //    [self.view setBackgroundColor:ViewBackColor];
   //    [self setupNaviBarWithColor:hexColor(00c8aa)];
   //    [self setNavBarButtonImageAndTitleColor:[UIColor whiteColor]];

}
#pragma mark - methods
//设置导航标题颜色
- (void)setShowNavTitleColor:(UIColor *)color {
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
}
//设置左右按钮图片和标题颜色
- (void)setNavBarButtonImageAndTitleColor:(UIColor *)color {
    
    [self.navigationController.navigationBar setTintColor:color];
}
//设置导航背景颜色
- (void)setupNaviBarWithColor:(UIColor *)barColor {
    
    [self.navigationController.navigationBar setBarTintColor:barColor];
}
//设置NavBar中间的title显示文字，
- (void)setupNaviBarWithTitle:(NSString *)title {

    [self setTitle:title];
   NSDictionary* dict = @{NSFontAttributeName:Font_18,NSForegroundColorAttributeName:[UIColor whiteColor]};
   [self.navigationController.navigationBar setTitleTextAttributes:dict];

}
//设置导航左右按钮
- (void)setupNaviBarWithBtn:(NaviBarBtn)btnTag
                      title:(NSString *)title
                        img:(NSString *)imgName{
    
    SEL selectorName = (btnTag == NaviLeftBtn) ? @selector(leftBtnAction) : @selector(rightBtnAction);

    if (title.length > 0) {
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:selectorName];

        [self accordingWithNaviBarBtn:btnTag withBarButtonItem:btnItem];
        
    } else if (imgName.length > 0) {
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithImage:kGetImage(imgName) style:UIBarButtonItemStyleDone target:self action:selectorName];
        [self accordingWithNaviBarBtn:btnTag withBarButtonItem:btnItem];
    }
    
    //去除导航栏返回按钮中的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}
- (void)accordingWithNaviBarBtn:(NaviBarBtn)btnTag withBarButtonItem:(UIBarButtonItem *)btnItem {
    
    if (btnTag == NaviLeftBtn) {
        
        [self.navigationItem setLeftBarButtonItem:btnItem];
    } else {
        [self.navigationItem setRightBarButtonItem:btnItem];
    }
}
//自定义导航的 左右按钮
- (void)setBtnItem:(NaviBarBtn)btnTag
    withCustomView:(UIView *)customView {
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    [self accordingWithNaviBarBtn:btnTag withBarButtonItem:btnItem];
}
- (void)rightBtnAction {
    
}
- (void)leftBtnAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}
//#pragma mark -  推送
//- (void)presentview:(NSNotification *)notification {//WEAKSELF;
//    /*
//     {
//     aps =     {
//     alert = ffff;
//     sound = default;
//     };
//     d = uu44403147597970306611;
//     p = 0;
//     }
//     
//     {
//     aps =     {
//     alert = "\U6d4b\U8bd5\U5185\U5bb9";
//     badge = 0;
//     sound = chime;
//     };
//     bell = 1;
//     d = uu05286146614599613601;
//     id = 12;
//     p = 0;
//     type = 2;
//     }
//     1、时事热点
//     2、日程
//     3、每日轮播
//     4、自定义消息
//     */
//    NSDictionary *notiDic = (NSDictionary *)notification.object;
//    _notiDic = notiDic;
//    NSString *type = notiDic[@"type"];
//    NSString *alertString = @"";
//    if ([notiDic[@"aps"][@"alert"] isKindOfClass:[NSString class]]) {
//        alertString = notiDic[@"aps"][@"alert"];
//    }else if ([notiDic[@"aps"][@"alert"] isKindOfClass:[NSDictionary class]]){
//        
//        NSDictionary *alertDict = notiDic[@"aps"][@"alert"];
//        alertString = alertDict[@"body"];
//    }
//    NSString *tit = @"温馨提示";//notiDic[@"title"];
//    //    NSUInteger indexType = [type integerValue] -1;
//    NSDictionary *typeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"周道慧法-日程",@"2",@"周道慧法-时事热点",@"1",@"周道慧法-每日轮播",@"3",@"周道慧法-消息提醒",@"4", nil];
//    tit = typeDictionary[type];
//    if ([type isEqualToString:@"2"]){
//        NSString *bellName = [NetWorkMangerTools getSoundName:notiDic[@"bell"]];
//        [[SoundManager sharedSoundManager] musicPlayByName:bellName];
//    }
//    
//    if ([PublicFunction ShareInstance].openApp ==  YES) {
//        
//        [PublicFunction ShareInstance].openApp =  NO;
//        [self pushWithUserInfo:notiDic];
//        if ([type isEqualToString:@"2"] || [type isEqualToString:@"4"]){
//            
//            UIAlertView *alarmView = [[UIAlertView alloc] initWithTitle:tit message:alertString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            alarmView.tag = 9543;
//            [alarmView show];
//            
//        }
//        
//    }else {
//        
//        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//            if ([type isEqualToString:@"2"] || [type isEqualToString:@"4"]){
//                
//                UIAlertView *alarmView = [[UIAlertView alloc] initWithTitle:tit message:alertString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                alarmView.tag = 9543;
//                [alarmView show];
//            }else {
//                UIAlertView *normalView = [[UIAlertView alloc] initWithTitle:tit message:alertString delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"立即查看", nil];
//                normalView.tag = 9544;
//                [normalView show];
//            }
//            
//        }else {
//            [self pushWithUserInfo:notiDic];
//            
//            if ([type isEqualToString:@"2"] || [type isEqualToString:@"4"]){
//                
//                UIAlertView *alarmView = [[UIAlertView alloc] initWithTitle:tit message:alertString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                alarmView.tag = 9543;
//                [alarmView show];
//            }
//        }
//    }
//}
//
/***
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUInteger index = alertView.tag;
    
    if (index == 9543) {
        [[SoundManager sharedSoundManager] musicStop];
    }else if (index == 9544){
        [[SoundManager sharedSoundManager] musicStop];
        
        if (buttonIndex == 1) {
            
            [self pushWithUserInfo:_notiDic];
        }
    }
}
#pragma mark - 分析跳转 显示
- (void)pushWithUserInfo:(NSDictionary *)notiDic {
    NSString *type = notiDic[@"type"];
    NSString *alertString = notiDic[@"aps"][@"alert"];
    
    NSString *idstr = notiDic[@"id"];
    if ([type isEqualToString:@"1"]) {
        
        [self CurrentEventHotSpot:idstr withTit:alertString];
        
    }else if ([type isEqualToString:@"2"]){
        
        //        PushAlertWindow *alertWindow = [[PushAlertWindow alloc] initWithFrame:kMainScreenFrameRect WithTitle:tit WithContent:alertString withType:indexType];
        //        alertWindow.pushBlock = ^(){
        //
        //            [[SoundManager sharedSoundManager] musicStop];
        //        };
        //        [self.view addSubview:alertWindow];
        
    }else if ([type isEqualToString:@"3"]){
        
        [self TheDailyRoundOfPlay:idstr withTit:alertString];
        
    }else {
        
    }
}
#pragma amrk -每日轮播
- (void)TheDailyRoundOfPlay:(NSString *)idStr withTit:(NSString *)tit {
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,dailyInfo,idStr];
    ToolsWedViewVC *vc = [ToolsWedViewVC new];
    vc.url = url;
    vc.tType = FromHotType;
    vc.shareContent =tit;
    vc.format = @"Noti";
    vc.navTitle = @"";//model.title;
    [self.navigationController  pushViewController:vc animated:YES];
}
#pragma amrk -时事热点
- (void)CurrentEventHotSpot:(NSString *)idStr withTit:(NSString *)tit {
   
    NSString *url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,DetailsEventHotSpot,idStr];
    ToolsWedViewVC *vc = [ToolsWedViewVC new];
    vc.url = url;
    vc.tType = FromHotType;
    vc.shareContent = tit;//model.title;
    vc.navTitle = @"";//model.title;
    vc.format = @"Noti";
    [self presentViewController:vc animated:YES completion:^{
    }];
}
****/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
