//
//  HomeTableViewCell.h
//  FaDaMi
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HomeTableViewCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *headImgView;
@property (strong, nonatomic)  UILabel *titlab;
@property (strong, nonatomic)  UILabel *contentLab;


- (void)settingUIWithHomeModel:(HomeModel *)homeModel;

@end
