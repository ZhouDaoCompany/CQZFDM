//
//  LiXiViewCell.h
//  ZhouDao
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiXiViewCell : UITableViewCell

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *titleLab;

- (void)settingLiXiCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays;

@end