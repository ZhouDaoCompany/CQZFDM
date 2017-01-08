//
//  HomeHeadView.m
//  FaDaMi
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HomeHeadView.h"
#import "SDCycleScrollView.h"
#import "HomeModel.h"
#import "MobClick.h"
#import "CustomButton.h"

#define MENUWIDTH         [UIScreen mainScreen].bounds.size.width/4.f
#define HomeMenuButtonTag  6800


@interface HomeHeadView()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *imageArrays;
@property (nonatomic, strong) NSMutableArray *titleArrays;

@end

@implementation HomeHeadView

- (instancetype)initWithDelegate:(id<HomeHeadViewPro>)delegate {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 315.f)];
    
    if (self) {
        
        [self initUI];
    }
    return self;
}
#pragma mark - methods
- (void)initUI {

    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self addSubview:self.cycleScrollView];
    NSArray *menuLabelArrays = @[[MenuLabel CreatelabelIconName:@"home_fagui" Title:@"法律法规"],[MenuLabel CreatelabelIconName:@"tabbar_judicial" Title:@"司法机关"],[MenuLabel CreatelabelIconName:@"tabbar_CaseQuery" Title:@"案例查询"],[MenuLabel CreatelabelIconName:@"tabbar_template" Title:@"合同模版"]];
    NSUInteger index = 0;

#pragma mark -添加按钮
    for (MenuLabel *Obj in menuLabelArrays) {

        CustomButton *button = [self allockButtonIndex:index];
        button.MenuData = Obj;
        index ++;
    }

    UIView *sectionView = [[UIView alloc] initWithFrame: CGRectMake(0, self.frame.size.height - 55, SCREENWIDTH, 10)];
    sectionView.backgroundColor = hexColor(F2F2F2);
    [self addSubview:sectionView];
    
    CGFloat height = self.frame.size.height;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15,height - 32.5, 104/7.f, 20)];
    imgView.image = [UIImage imageNamed:@"home_hot"];
    [self addSubview:imgView];
    
    UILabel *hotLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(imgView) +10, height - 32.5, 100, 20)];
    hotLab.text = @"时事热点";
    hotLab.font = Font_15;
    hotLab.textColor = KNavigationBarColor;
    [self addSubview:hotLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, height - .6f, SCREENWIDTH - 15, .6f)];
    lineView.backgroundColor = LINECOLOR;
    [self addSubview:lineView];
}
#pragma mark - UIButtonEvent
- (void)menuButtonSelectd:(CustomButton *)btn {
    
//    [btn SelectdAnimation];
    NSUInteger indexTag = btn.tag - HomeMenuButtonTag;
    if ([self.delegate respondsToSelector:@selector(clickOnTheButtonModuleWithButtonTag:)]) {
        
        [self.delegate clickOnTheButtonModuleWithButtonTag:indexTag];
    }
//    [btn CancelAnimation];
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    DLog(@"---点击了第%ld张图片", (long)index);
    if ([self.delegate respondsToSelector:@selector(getSlideWithCount:)]) {
        
        [self.delegate getSlideWithCount:index];
    }
}

#pragma mark - setter and getter
- (void)setSlideArrays:(NSArray *)slideArrays {
    
    if (slideArrays.count == 0)
        return;

    _slideArrays = nil;
    _slideArrays = slideArrays;
    __block  NSMutableArray *picArr   = [NSMutableArray array];
    __block  NSMutableArray *titleArr = [NSMutableArray array];
    [_slideArrays enumerateObjectsUsingBlock:^(HomeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [picArr addObject:obj.slide_pic];
        [titleArr addObject:obj.slide_name];
    }];
    _cycleScrollView.imageURLStringsGroup = picArr;
}
-(CustomButton *)allockButtonIndex:(NSInteger)index {
    
    CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
    [button setTag:(index + 1) + HomeMenuButtonTag];
    [button setTitleColor:[UIColor darkGrayColor] forState:0];
    [button setFrame:CGRectMake(index * MENUWIDTH, Orgin_y(_cycleScrollView), MENUWIDTH, 105.f)];
    [button addTarget:self action:@selector(menuButtonSelectd:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150) delegate:self placeholderImage:kGetImage(@"home_Shuff")];
        //    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.autoScroll = YES;
        _cycleScrollView.titleLabelHeight = 25.f;
        _cycleScrollView.titleLabelTextFont = Font_14;
//        _cycleScrollView.autoScrollTimeInterval = 3.f;
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.currentPageDotColor = KNavigationBarColor;
        //    _cycleScrollView.pageControlDotSize = CGSizeMake(4, 4);
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoresizingMask = YES;
    }
    return _cycleScrollView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
