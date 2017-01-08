//
//  SuspensionBtnView.h
//  GovermentTest
//
//  Created by apple on 16/12/19.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SuspensionBtnViewPro;

@interface SuspensionBtnView : UIView


@property (nonatomic, weak) id<SuspensionBtnViewPro>delegate;

- (instancetype)initWithFrame:(CGRect)frame
                withImageName:(NSString *)imageName;

- (void)setImageNameSelector:(NSString *)imageName;

@end

@protocol SuspensionBtnViewPro <NSObject>

- (void)clickSuspensionButtonEvent;

@end
