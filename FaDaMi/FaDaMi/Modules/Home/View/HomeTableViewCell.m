//
//  HomeTableViewCell.m
//  FaDaMi
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titlab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.headImgView];
    }
    return self;
}

- (void)settingUIWithHomeModel:(HomeModel *)homeModel {
    
    [_titlab setText:homeModel.title];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:homeModel.pic] placeholderImage:kGetImage(@"home_palcehold")];

}

#pragma mark - getters and setters
- (UILabel *)titlab {
    
    if (!_titlab) {
        _titlab = [[UILabel alloc] initWithFrame:CGRectMake(105, 25, SCREENWIDTH - 115.f, 45)];
        _titlab.numberOfLines = 0;
        _titlab.font  = Font_15;
        //        _titlab.lineBreakMode = NSLineBreakByTruncatingTail;
        _titlab.textColor = THIRDCOLOR;
    }
    return _titlab;
}
- (UIImageView *)headImgView {
    
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 65)];
        _headImgView.image = [UIImage imageNamed:@"home_palcehold"];
        _headImgView.contentMode = UIViewContentModeScaleToFill;
        _headImgView.userInteractionEnabled = YES;
    }
    return _headImgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
