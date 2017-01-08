//
//  CaseListCell.m
//  GovermentTest
//
//  Created by apple on 16/12/19.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CaseListCell.h"

//#define PictureName  [UIScreen mainScreen].bounds.size.height>667?@"case_juanzong6p":([UIScreen mainScreen].bounds.size.height >568?@"case_juanzong":@"case_juanzong4s")

@interface CaseListCell ()

@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation CaseListCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = LRRandomColor;
        
        [self.contentView addSubview:self.picView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.lineView];
        _titleLabel.text = @"中南集团案件";
        _dateLabel.text = @"2016-12-06  14:12";
    }
    return self;
}

- (void)setCollectionViewCellUIWith {
    

    
}
- (void)setIsCross:(BOOL)isCross {
    
    _isCross = isCross;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_isCross) {
        //一行一个
        _dateLabel.hidden = NO;
        _lineView.hidden = NO;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _picView.frame = CGRectMake(15,14.f ,37, 52);
        _picView.image = kGetImage(@"case_caseList");
        _titleLabel.frame = CGRectMake(Orgin_x(_picView) + 10.f, 15.f , SCREENWIDTH - 90.f, 20.f);
        _dateLabel.frame = CGRectMake(Orgin_x(_picView) + 10.f, 45.f, SCREENWIDTH - 90.f, 20.f);
    } else {
        //一行多个
        _dateLabel.hidden = YES;
        _lineView.hidden = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        float y =self.contentView.bounds.size.height-60.f;
        _picView.frame = CGRectMake(0,20.f ,self.contentView.bounds.size.width, y);
        _picView.image = [UIImage imageNamed:@"case_Group"];
        _titleLabel.frame = CGRectMake(0.f,Orgin_y(_picView)+3.5f , self.contentView.bounds.size.width, 40.f);
    }

}
#pragma mark - setter and getter

- (UIImageView *)picView {
    
    if (!_picView) {
        
        _picView = [[UIImageView alloc] init];
        _picView.contentMode =UIViewContentModeScaleAspectFill;
        _picView.clipsToBounds = YES;
    }
    return _picView;
}
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = THIRDCOLOR;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _titleLabel;
}
- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = SIXCOLOR;
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.numberOfLines = 0;
        _dateLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _dateLabel;
}
- (UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 79.4f, SCREENWIDTH - 15.f, .6f)];
        _lineView.backgroundColor = LINECOLOR;
    }
    return _lineView;
}
@end
