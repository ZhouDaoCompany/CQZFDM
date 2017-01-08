//
//  CaseHeadView.m
//  GovermentTest
//
//  Created by apple on 16/12/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CaseHeadView.h"

@implementation CaseHeadView

- (instancetype)initWithCaseListHeadViewWithHeadName:(NSString *)headName {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45.f)];
    if (self) {
        
        self.backgroundColor = hexColor(F2F2F2);
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 160, 15)];
        titLabel.text = headName;
        titLabel.font = Font_14;
        titLabel.textColor = hexColor(666666);
        [self addSubview:titLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
