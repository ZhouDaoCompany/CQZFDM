//
//  CommonViewCell.h
//  FaDaMi
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommonViewCellPro;
@interface CommonViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *alertLab;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *jiantouimg;

@property (nonatomic, weak) id<CommonViewCellPro>delegate;

- (void)settingUIFourButtonUIwithDelegate:(id<CommonViewCellPro>)delegate;

- (void)setingUICommonWithSection:(NSUInteger)section;
@end

@protocol CommonViewCellPro <NSObject>

@optional
- (void)buttonClickEvent:(NSUInteger)index;

@end
