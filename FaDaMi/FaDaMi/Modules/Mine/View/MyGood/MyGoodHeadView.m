//
//  MyGoodHeadView.m
//  FaDaMi
//
//  Created by apple on 16/12/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MyGoodHeadView.h"

@interface MyGoodHeadView()

@property (strong, nonatomic) UILabel *allTitLabel;


@end

@implementation MyGoodHeadView

//擅长领域全部
- (instancetype)initAllReusableViewWithLabelText:(NSString *)text {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 65)];
    if (self) {
        self.backgroundColor = LRRGBColor(242, 242, 242);

        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 160, 20)];
        lab.font = [UIFont systemFontOfSize:15.f];
        lab.text = @"擅长领域分类列表";
        [self addSubview:lab];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 100, 20)];
        titleLabel.font = Font_13;
        titleLabel.text = text;
        [titleLabel setTextColor:SIXCOLOR];
        [self addSubview:titleLabel];
    }
    return self;
}
//擅长领域分段
- (instancetype)initCommonReusableViewWithTitle:(NSString *)text {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    if (self) {
        
        self.backgroundColor = LRRGBColor(242, 242, 242);
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
        lab.font = Font_13;
        [lab setText:text];
        [lab setTextColor:SIXCOLOR];
        [self addSubview:lab];
    }
    return self;
}
- (instancetype)initSelectReusableViewWithState:(BOOL)isShake
                                   withDelegate:(id<MyGoodHeadViewPro>)delegate{
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    if (self) {
        
        _delegate = delegate;
        self.backgroundColor = LRRGBColor(242, 242, 242);
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
        titLab.font = [UIFont systemFontOfSize:15.f];
        titLab.text = @"您的擅长领域";
        [titLab setTextColor:[UIColor colorWithHexString:@"#333333"]];
        [self addSubview:titLab];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(titLab) +10, 10, 100, 20)];
        lab.font = [UIFont systemFontOfSize:12.f];
        [lab setTextColor:[UIColor colorWithHexString:@"#666666"]];
        lab.text = @" (最多选择12项)";
        [self addSubview:lab];
        
        NSString *stateString = (isShake == YES) ? @"完成" : @"编辑";
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setTitle:stateString forState:0];
        [editBtn setTitleColor:KNavigationBarColor forState:0];
        [editBtn setBackgroundImage:[UIImage imageNamed:@"mine_box"] forState:0];
        editBtn.titleLabel.font = Font_12;
        [editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
        editBtn.frame = CGRectMake(self.frame.size.width - 60, 5, 45, 20);
        [self addSubview:editBtn];
    }
    return self;
}
#pragma mark -UIButtonEvent
- (void)editClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(editStateShake)]) {
        
        [self.delegate editStateShake];
    }
    DLog(@"进入编辑状态－");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
