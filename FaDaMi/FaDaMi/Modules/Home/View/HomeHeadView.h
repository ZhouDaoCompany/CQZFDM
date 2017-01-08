//
//  HomeHeadView.h
//  FaDaMi
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomeHeadViewPro;

@interface HomeHeadView : UIView

@property (nonatomic, weak) id<HomeHeadViewPro>delegate;
@property (nonatomic, strong) NSArray *slideArrays;

- (instancetype)initWithDelegate:(id<HomeHeadViewPro>)delegate;
@end

@protocol HomeHeadViewPro <NSObject>

@optional
//幻灯片
- (void)getSlideWithCount:(NSUInteger)count;
//按钮
- (void)clickOnTheButtonModuleWithButtonTag:(NSUInteger)btnTag;
@end
