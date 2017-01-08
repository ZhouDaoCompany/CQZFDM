//
//  CaseInsideViewController.m
//  GovermentTest
//
//  Created by apple on 16/12/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CaseInsideViewController.h"
#import "CaseContentVC.h"
#import "CaseNotesVC.h"
#import "CaseRemindVC.h"
#import "CaseFinancialVC.h"
#import "CaseDetailVC.h"

#define BtnWidth [UIScreen mainScreen].bounds.size.width/5.f

@interface CaseMenuButton : UIButton

- (void)setUIWithImage:(NSString *)imageName;

@end

@implementation CaseMenuButton

- (void)layoutSubviews {
    
    self.titleLabel.font = [UIFont systemFontOfSize:10.f];
    self.titleLabel.textAlignment =  NSTextAlignmentCenter;
}
- (void)setUIWithImage:(NSString *)imageName {
    
    self.imageView.image = [UIImage imageNamed:imageName];
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    return CGRectMake(0, 30, BtnWidth, 20);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    return CGRectMake((BtnWidth - 20)/2.f, 10.f, 20, 20);
}

@end

#pragma mark -  案件内容管理
@interface CaseInsideViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation CaseInsideViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

#pragma mark - methods
- (void)initUI {
    
    [self setupNaviBarWithTitle:@"案件管理"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    [self addChildController];
    [self.view addSubview:self.bigScrollView];
    [self.view addSubview:self.bottomView];
    
    CaseContentVC *vc = [self.childViewControllers firstObject];
    vc.view.frame = _bigScrollView.bounds;
    [_bigScrollView addSubview:vc.view];

}
- (void)addChildController {
    
    //案件目录
    CaseContentVC *contentVC = [CaseContentVC new];
    [self addChildViewController:contentVC];
    
    //案件笔记
    CaseNotesVC *noteVC = [CaseNotesVC new];
    [self addChildViewController:noteVC];

    //案件提醒
    CaseRemindVC *remindVC = [CaseRemindVC new];
    [self addChildViewController:remindVC];

    //案件财务
    CaseFinancialVC *financialVC = [CaseFinancialVC new];
    [self addChildViewController:financialVC];

    //案件详情
    CaseDetailVC *detailtVC = [CaseDetailVC new];
    [self addChildViewController:detailtVC];
    
}
#pragma mark - UIButton Events
- (void)selectBottomMenuEvents:(CaseMenuButton *)btn {
    
    NSUInteger indexTag = btn.tag - 2000;
    
    CGFloat offsetX = indexTag * _bigScrollView.frame.size.width;
    CGFloat offsetY = _bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [_bigScrollView setContentOffset:offset animated:YES];

}
#pragma mark - ******************** scrollView代理方法
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 获得索引
    __block NSUInteger index = scrollView.contentOffset.x / _bigScrollView.frame.size.width;
    NSArray *arr1 = @[@"Case_contentUnSelect",@"Case_NoteUnSelect",@"Case_RemindUnSelect",@"Case_financialUnSelect",@"Case_NoteUnSelect"];
    __block NSArray *arr2 = @[@"Case_contentSelect",@"Case_NoteSelect",@"Case_RemindSelect",@"Case_financialSelect",@"Case_NoteSelect"];
    
    [arr1 enumerateObjectsUsingBlock:^(NSString *imgName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CaseMenuButton *menuBtn = (CaseMenuButton *)[_bottomView viewWithTag:2000 + idx];
        if (index ==  idx) {
            [menuBtn setTitleColor:hexColor(00c8aa) forState:0];
            [menuBtn setUIWithImage:arr2[index]];
        } else {
            [menuBtn setTitleColor:hexColor(333333) forState:0];
            [menuBtn setUIWithImage:imgName];
        }
    }];
    
    switch (index) {
        case 0: {
            [self setupNaviBarWithTitle:@"案件管理"];

            CaseContentVC *vc = self.childViewControllers[index];
            vc.view.frame = scrollView.bounds;
            [_bigScrollView addSubview:vc.view];

            break;
        }
        case 1: {
            [self setupNaviBarWithTitle:@"添加笔记"];
            CaseNotesVC *vc = self.childViewControllers[index];
            vc.view.frame = scrollView.bounds;
            [_bigScrollView addSubview:vc.view];

            break;
        }
        case 2: {
            [self setupNaviBarWithTitle:@"案件管理"];

            CaseRemindVC *vc = self.childViewControllers[index];
            vc.view.frame = scrollView.bounds;
            [_bigScrollView addSubview:vc.view];

            break;
        }
        case 3: {
            [self setupNaviBarWithTitle:@"案件管理"];

            CaseFinancialVC *vc = self.childViewControllers[index];
            vc.view.frame = scrollView.bounds;
            [_bigScrollView addSubview:vc.view];

            break;
        }
        case 4: {
            [self setupNaviBarWithTitle:@"案件管理"];

            CaseDetailVC *vc = self.childViewControllers[index];
            vc.view.frame = scrollView.bounds;
            [_bigScrollView addSubview:vc.view];

            break;
        }
        default:
            break;
    }

}
/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
#pragma mark - setter and getter
- (UIScrollView *)bigScrollView {
    if (!_bigScrollView) {
        _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64.f, SCREENWIDTH, SCREENHEIGHT - 114.f)];
        CGFloat contentX = (self.childViewControllers.count) * [UIScreen mainScreen].bounds.size.width;
        _bigScrollView.showsVerticalScrollIndicator = NO;
        _bigScrollView.contentSize = CGSizeMake(contentX, 0);
        _bigScrollView.pagingEnabled = YES;
        _bigScrollView.scrollEnabled = NO;
        _bigScrollView.delegate = self;
        _bigScrollView.scrollsToTop = NO;
    }
    return _bigScrollView;
}
- (UIView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 50.f, SCREENWIDTH, 50.f)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        NSArray *arr = @[@"Case_contentSelect",@"Case_NoteUnSelect",@"Case_RemindUnSelect",@"Case_financialUnSelect",@"Case_NoteUnSelect"];
        NSArray *titleArrays = @[@"案件目录",@"案件笔记",@"案件提醒",@"财务信息",@"案件详情"];
        for (NSUInteger i = 0; i < [arr count]; i++) {
            
            CaseMenuButton *btns = [CaseMenuButton buttonWithType:UIButtonTypeCustom];
            btns.backgroundColor = [UIColor clearColor];
            btns.frame = CGRectMake(BtnWidth*i, 0, BtnWidth, 50);
            [btns setUIWithImage:arr[i]];
            UIColor *color = (i == 0) ? hexColor(00c8aa) : hexColor(333333);
            [btns setTitleColor:color forState:0];
            btns.tag = 2000 + i;
            [btns setTitle:titleArrays[i] forState:0];
            [btns addTarget:self action:@selector(selectBottomMenuEvents:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:btns];
        }
    }
    return _bottomView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
