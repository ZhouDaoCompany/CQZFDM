//
//  MyGoodViewController.h
//  FaDaMi
//
//  Created by apple on 16/12/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MyGoodViewController : BaseViewController

@property (nonatomic, copy) ZDMutableArrayBlock  domainBlock;

- (instancetype)initWithCompareArrays:(NSMutableArray *)compareArr;
@end
