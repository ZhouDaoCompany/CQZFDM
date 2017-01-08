//
//  MyGoodHeadView.h
//  FaDaMi
//
//  Created by apple on 16/12/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyGoodHeadViewPro;

@interface MyGoodHeadView : UIView

@property (nonatomic, weak) id<MyGoodHeadViewPro> delegate;
//擅长领域全部
- (instancetype)initAllReusableViewWithLabelText:(NSString *)text;

//擅长领域分段
- (instancetype)initCommonReusableViewWithTitle:(NSString *)text;
//擅长领域选中
- (instancetype)initSelectReusableViewWithState:(BOOL)isShake
                                   withDelegate:(id<MyGoodHeadViewPro>)delegate;
@end

@protocol MyGoodHeadViewPro <NSObject>

- (void)editStateShake;

@end
