//
//  ProfessionalCell.m
//  FaDaMi
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ProfessionalCell.h"
#import "AdvantagesModel.h"

@implementation ProfessionalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _cellHeight = 44.f;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    
    return self;
}
- (void)initUI {
    
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.jiantouimg];

}
- (void)setDomainArrays:(NSMutableArray *)domainArrays {
    
    _domainArrays = [NSMutableArray array];
    _domainArrays = domainArrays;
    
    
    for (NSUInteger j =6000; j<6012; j++) {
        
        UILabel *lab = (UILabel *)[self.contentView viewWithTag:j];
        [lab removeFromSuperview];
    }
    float width = (SCREENWIDTH -75.f)/4.f;
    //擅长  40
    for (NSUInteger i = 0 ; i < [_domainArrays count];  i ++) {
        
        AdvantagesModel *model = _domainArrays[i];
        UILabel *goodLab = [[UILabel alloc] init];
        goodLab.frame = CGRectMake( 15*(i%4 + 1) + width * (i%4), 25 +15*(i/4 + 1) + 30 *(i/4) , width, 30);
        goodLab.backgroundColor = [UIColor whiteColor];
        goodLab.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
        goodLab.layer.borderWidth = .5f;
        goodLab.font = Font_13;
        goodLab.tag = 6000+i;
        goodLab.textAlignment = NSTextAlignmentCenter;
        goodLab.text = model.sname;
        [self.contentView addSubview:goodLab];
    }
    
    CGFloat height = 170.f;
    if ([_domainArrays count]  == 0) {
        height = 44.f;
    }else if ([_domainArrays count] <5){
        height = 80.f;
    }else if ([_domainArrays count] <9){
        height = 125.f;
    }

    self.cellHeight = height;
}

#pragma mark - setter and getter
- (UIImageView *)iconImgView {
    
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13.5f, 17, 17)];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.image = [UIImage imageNamed:@"mine_good"];
    }
    return _iconImgView;
}
- (UILabel *)nameLab {
    
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_iconImgView) +15, 12, 120, 20)];
        _nameLab.font = Font_15;
        [_nameLab setTextColor:hexColor(333333)];
        _nameLab.text = @"我的擅长";
    }
    return _nameLab;
}
- (UIImageView *)jiantouimg {
    
    if (!_jiantouimg) {
        _jiantouimg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 24, 14.5, 9, 15)];
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
