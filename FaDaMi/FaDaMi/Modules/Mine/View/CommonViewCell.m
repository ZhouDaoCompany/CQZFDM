//
//  CommonViewCell.m
//  FaDaMi
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CommonViewCell.h"

#define BtnWidth [UIScreen mainScreen].bounds.size.width /4.f
#define leftX    (BtnWidth-20.f)/2.f
#define TopY     13.f

@interface CustomMenuBtn : UIButton

@end

@implementation CustomMenuBtn
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.font = [UIFont systemFontOfSize:10.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
                                     
    [self setTitleColor:hexColor(666666) forState:0];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

//文字相对按钮的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    return CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 12);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    return CGRectMake(leftX, 15, 20, 20);
}

@end

@interface CommonViewCell()

@property (nonatomic, strong) CustomMenuBtn *btn1;
@property (nonatomic, strong) CustomMenuBtn *btn2;
@property (nonatomic, strong) CustomMenuBtn *btn3;
@property (nonatomic, strong) CustomMenuBtn *btn4;

@end

@implementation CommonViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.alertLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.jiantouimg];

        [self.contentView addSubview:self.btn1];
        [self.contentView addSubview:self.btn2];
        [self.contentView addSubview:self.btn3];
        [self.contentView addSubview:self.btn4];

    }
    
    return self;
}

- (void)settingUIFourButtonUIwithDelegate:(id<CommonViewCellPro>)delegate {
    
    _delegate = delegate;
    _iconImgView.hidden = YES;
    _alertLab.hidden = YES;
    _nameLab.hidden = YES;
    _jiantouimg.hidden = YES;
    _btn4.hidden = NO;
    _btn3.hidden = NO;
    _btn2.hidden = NO;
    _btn1.hidden = NO;


}

- (void)setingUICommonWithSection:(NSUInteger)section {
    
    _btn4.hidden = YES;
    _btn3.hidden = YES;
    _btn2.hidden = YES;
    _btn1.hidden = YES;
    _iconImgView.hidden = NO;
    _alertLab.hidden = NO;
    _nameLab.hidden = NO;
    _jiantouimg.hidden = NO;
    
    if (section == 3) {
        
        [_iconImgView setImage:kGetImage(@"mine_manager")];
        [_nameLab setText:@"案件整理"];
    } else if (section == 4) {
        
        [_iconImgView setImage:kGetImage(@"mine_recommend")];
        [_nameLab setText:@"意见反馈"];
    } else if (section ==  5) {
        
        [_iconImgView setImage:kGetImage(@"mine_about")];
        [_nameLab setText:@"关于周道"];
    }
}

- (void)menuButtonEvent:(CustomMenuBtn *)btn {
    
    NSUInteger index = btn.tag - 2000;
    if ([self.delegate respondsToSelector:@selector(buttonClickEvent:)]) {
        
        [self.delegate buttonClickEvent:index];
    }
}
#pragma mark - setter and getter
- (UIImageView *)iconImgView {
    
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13.5f, 17, 17)];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.userInteractionEnabled = YES;
    }
    return _iconImgView;
}
- (UILabel *)nameLab {
    
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_iconImgView) +15, 12, 120, 20)];
        _nameLab.font = Font_16;
    }
    return _nameLab;
}
- (UILabel *)alertLab {
    
    if (!_alertLab) {
        _alertLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 105, 12, 70, 20)];
        _alertLab.font = Font_12;
        _alertLab.textColor = [UIColor lightGrayColor];
        _alertLab.textAlignment = NSTextAlignmentRight;
    }
    return _alertLab;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LINECOLOR;
    }
    return _lineView;
}
- (UIImageView *)jiantouimg {
    
    if (!_jiantouimg) {
        _jiantouimg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 24, 14.5, 9, 15)];
        _jiantouimg.userInteractionEnabled = YES;
        _jiantouimg.image = [UIImage imageNamed:@"mine_jiantou"];
    }
    return _jiantouimg;
}

- (CustomMenuBtn *)btn1 {
    
    if (!_btn1) {
        _btn1 = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
        _btn1.frame = CGRectMake(0, 0, BtnWidth, 62);
        [_btn1 addTarget:self action:@selector(menuButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _btn1.backgroundColor = [UIColor whiteColor];
        [_btn1 setTag:2000];
        [_btn1 setImage:kGetImage(@"mine_CaseBj") forState:0];
        [_btn1 setTitle:@"便签" forState:0];
    }
    return _btn1;
}
- (CustomMenuBtn *)btn2 {
    
    if (!_btn2) {
        _btn2 = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
        _btn2.frame = CGRectMake(BtnWidth, 0, BtnWidth, 62);
        [_btn2 addTarget:self action:@selector(menuButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _btn2.backgroundColor = [UIColor whiteColor];
        [_btn2 setImage:kGetImage(@"mine_collection") forState:0];
        [_btn2 setTag:2001];
        [_btn2 setTitle:@"我的收藏" forState:0];
    }
    return _btn2;
}
- (CustomMenuBtn *)btn3 {
    
    if (!_btn3) {
        _btn3 = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
        _btn3.frame = CGRectMake(BtnWidth * 2, 0, BtnWidth, 62);
        [_btn3 addTarget:self action:@selector(menuButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _btn3.backgroundColor = [UIColor whiteColor];
        [_btn3 setImage:kGetImage(@"mine_calendar") forState:0];
        [_btn3 setTag:2002];
        [_btn3 setTitle:@"我的日程" forState:0];
    }
    return _btn3;
}
- (CustomMenuBtn *)btn4 {
    
    if (!_btn4) {
        _btn4 = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
        _btn4.frame = CGRectMake(BtnWidth * 3, 0, BtnWidth, 62);
        [_btn4 addTarget:self action:@selector(menuButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _btn4.backgroundColor = [UIColor whiteColor];
        [_btn4 setImage:kGetImage(@"mine_Contribute") forState:0];
        [_btn4 setTag:2003];
        [_btn4 setTitle:@"我的贡献" forState:0];
    }
    return _btn4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
