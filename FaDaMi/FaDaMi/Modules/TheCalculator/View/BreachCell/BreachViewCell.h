//
//  BreachViewCell.h
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreachViewCell : UITableViewCell

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *titleLab;

- (void)settingBreachCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays;

@end