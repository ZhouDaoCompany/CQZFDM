//
//  ProfessionalCell.h
//  FaDaMi
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfessionalCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) NSMutableArray *domainArrays;//擅长领域
@property (nonatomic, strong) UIImageView *jiantouimg;
@property (nonatomic, assign) CGFloat cellHeight;//cell高度

@end
