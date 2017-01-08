//
//  OverdueCell.h
//  ZhouDao
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverdueCell : UITableViewCell

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *titleLab;

- (void)settingOverdueCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays;

@end
