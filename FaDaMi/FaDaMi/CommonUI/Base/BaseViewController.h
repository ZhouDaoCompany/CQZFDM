//
//  BaseViewController.h
//  ZhouDao
//
//  Created by apple on 16/12/21.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+FDFullscreenPopGesture.h"

typedef NS_ENUM(NSInteger, NaviBarBtn) {
    
    NaviLeftBtn = 101,//自定义NavBar左侧的按钮tag值
    NaviRightBtn = 102,//自定义NavBar右侧的按钮tag值
};

@interface BaseViewController : QMUICommonViewController

//设置导航标题颜色
- (void)setShowNavTitleColor:(UIColor *)color;

//设置左右按钮图片和标题颜色
- (void)setNavBarButtonImageAndTitleColor:(UIColor *)color;

//设置导航背景颜色
- (void)setupNaviBarWithColor:(UIColor *)barColor;

//设置NavBar中间的title显示文字，
- (void)setupNaviBarWithTitle:(NSString *)title;

//设置导航左右按钮
- (void)setupNaviBarWithBtn:(NaviBarBtn)btnTag
                      title:(NSString *)title
                        img:(NSString *)imgName;
//自定义导航的 左右按钮
- (void)setBtnItem:(NaviBarBtn)btnTag
    withCustomView:(UIView *)customView;

//子类继承实现右侧按钮
- (void)rightBtnAction;
- (void)leftBtnAction;

@end
