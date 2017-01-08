//
//  HeadTableViewCell.m
//  FaDaMi
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HeadTableViewCell.h"

@implementation HeadTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    [self.contentView addSubview:self.headImgView];
    [self.contentView addSubview:self.VIPimgView];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.phoneLab];
    [self.contentView addSubview:self.jiantouimg];

}
- (void)settingUIreloadNameWithPhone {
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[PublicFunction ShareInstance].m_user.data.photo]
                    placeholderImage:kGetImage(@"mine_head")];
    if ([[PublicFunction ShareInstance].m_user.data.is_certification isEqualToString:@"1"]) {
        //        _VIPimgView.hidden = YES;
        _VIPimgView.image = [UIImage imageNamed:@"mine_noScer"];
    } else {
        //        _VIPimgView.hidden = NO;
        _VIPimgView.image = [UIImage imageNamed:@"mine_scer"];
    }
    
    if ([PublicFunction ShareInstance].m_user.data.name.length == 0) {
        _nameLab.text = @"慧法用户";
    } else {
        _nameLab.text = [PublicFunction ShareInstance].m_user.data.name;
    }
    
    if ([PublicFunction ShareInstance].m_bLogin == YES) {
        
        _phoneLab.text = [QZManager getTheHiddenMobile:[PublicFunction ShareInstance].m_user.data.mobile];
    }

}

#pragma mark - setter and getter
- (UIImageView *)headImgView {
    
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 56, 56)];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.image = kGetImage(@"mine_head");
        _headImgView.layer.cornerRadius = 28.f;
    }
    return _headImgView;
}
- (UIImageView *)VIPimgView {
    
    if (!_VIPimgView) {
        _VIPimgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 57, 15, 15)];
        _VIPimgView.image = [UIImage imageNamed:@"mine_scer"];
    }
    return _VIPimgView;
}
- (UILabel *)nameLab {
    
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_headImgView) +15, 20, 160, 20)];
        _nameLab.font = Font_16;
    }
    return _nameLab;
}
- (UILabel *)phoneLab {
    
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_headImgView)+15, 45, 160, 20)];
        _phoneLab.font = Font_14;
        _phoneLab.textColor = [UIColor lightGrayColor];
    }
    return _phoneLab;
}
- (UIImageView *)jiantouimg {
    
    if (!_jiantouimg) {
        _jiantouimg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 24, 32.5, 9, 15)];
        _jiantouimg.userInteractionEnabled = YES;
        _jiantouimg.image = [UIImage imageNamed:@"mine_jiantou"];
    }
    return _jiantouimg;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
