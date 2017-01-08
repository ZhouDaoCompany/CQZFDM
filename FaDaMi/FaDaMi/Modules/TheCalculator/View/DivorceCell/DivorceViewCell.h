//
//  DivorceViewCell.h
//  ZhouDao
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DivorceViewCell : UITableViewCell

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *titleLab;

- (void)settingOverdueCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays;

@end
