//
//  FDMTabBarControllerConfig.m
//  FaDaMi
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//




#import "FDMTabBarControllerConfig.h"

//@interface FDMBaseNavigationController : QMUINavigationController
//@end
//
//@implementation FDMBaseNavigationController
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (self.viewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//    [super pushViewController:viewController animated:animated];
//}
//
//@end

#import "HomeViewController.h"
#import "CaseManagerViewController.h"
#import "TheCalculatorVC.h"
#import "MineViewController.h"

@interface FDMTabBarControllerConfig ()

@property (nonatomic, readwrite, strong) QMUITabBarViewController *tabBarController;

@end

@implementation FDMTabBarControllerConfig

- (QMUITabBarViewController *)tabBarController {
    if (!_tabBarController) {
        _tabBarController = [[QMUITabBarViewController alloc] init];
        _tabBarController.viewControllers = [self viewControllers];
//        [[UITabBar appearance] setTintColor:hexColor(00c8aa)];
//        [[UITabBar appearance] setUnselectedItemTintColor:hexColor(666666)];
//        //设定Tabbar的颜色
//        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    }
    return _tabBarController;
}

- (NSArray *)viewControllers {
    HomeViewController *homeVC = [HomeViewController new];
    homeVC.hidesBottomBarWhenPushed = NO;
    UIViewController *homeNavigationController = [[QMUINavigationController alloc]
                                                   initWithRootViewController:homeVC];
    homeNavigationController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"首页" image:[UIImageMake(@"homeUnselect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"homeSelect") tag:0];
    
    TheCalculatorVC *calculatorVC = [TheCalculatorVC new];
    calculatorVC.hidesBottomBarWhenPushed = NO;
    UIViewController *calculatorNavigationController = [[QMUINavigationController alloc]
                                                  initWithRootViewController:calculatorVC];
    calculatorNavigationController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"计算器" image:[UIImageMake(@"ToolsUnSelect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"ToolsSelect") tag:1];


    CaseManagerViewController *caseVC = [CaseManagerViewController new];
    caseVC.hidesBottomBarWhenPushed = NO;
    UIViewController *caseNavigationController = [[QMUINavigationController alloc]
                                                        initWithRootViewController:caseVC];
    caseNavigationController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"案件管理" image:[UIImageMake(@"CaseManagerUnSelect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"CaseManagerSelect") tag:2];

    MineViewController *mineVC = [MineViewController new];
    mineVC.hidesBottomBarWhenPushed = NO;
    UIViewController *mineNavigationController = [[QMUINavigationController alloc]
                                                        initWithRootViewController:mineVC];
    mineNavigationController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"我的" image:[UIImageMake(@"mineUnSelect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"mineSelect") tag:3];


    /**
     * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
     * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
     * 更推荐后一种做法。
     */
    //tabBarController.imageInsets = UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    //tabBarController.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
    NSArray *viewControllers = @[
                                 homeNavigationController,
                                 calculatorNavigationController,
                                 caseNavigationController,
                                 mineNavigationController
                                 ];
    return viewControllers;
}

@end
