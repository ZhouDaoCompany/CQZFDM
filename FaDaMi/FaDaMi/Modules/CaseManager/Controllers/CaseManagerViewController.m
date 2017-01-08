//
//  CaseManagerViewController.m
//  FaDaMi
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CaseManagerViewController.h"
#import "CaseListCell.h"
#import "SuspensionBtnView.h"
#import "CaseHeadView.h"
#import "JHHeaderFlowLayout.h"
#import "CaseInsideViewController.h"

static NSString *const TheCaseIdentifer = @"TheCaseIdentifer";
static NSString *const HEADVIEWIDENTIFER = @"headViewIdentifer";

@interface CaseManagerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SuspensionBtnViewPro>

@property (nonatomic, strong) UICollectionView *collectionView;//案件
@property (nonatomic, strong) NSMutableArray *dataSourceArr;//数据源
@property (nonatomic, assign) BOOL isCross;//横式列表
@property (nonatomic, strong) SuspensionBtnView *susButton;//悬浮按钮

@end

@implementation CaseManagerViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}
#pragma mark - Methods
- (void)initUI {
    
    [self setupNaviBarWithTitle:@"案件管理"];

    self.isCross = YES;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.susButton];
    [self.view bringSubviewToFront:self.susButton];

}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender { WEAKSELF
    
    // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
        
        // 结束刷新
        [weakSelf.collectionView.mj_header endRefreshing];
    });
}

#pragma mark - UIButton Event

#pragma mark - SuspensionBtnViewPro
- (void)clickSuspensionButtonEvent { WEAKSELF;
    
    DLog(@"改变样式");
    _isCross = !_isCross;
    [UIView animateWithDuration:.35f animations:^{
        
        [weakSelf.collectionView reloadData];
        NSString *imageName = (weakSelf.isCross) ?  @"case_SquareCase" : @"case_ListCase";
        [weakSelf.susButton setImageNameSelector:imageName];
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 9;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 12;//[self.dataSourceArr count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CaseListCell * cell = (CaseListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:TheCaseIdentifer forIndexPath:indexPath];
    [cell setIsCross:_isCross];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                UICollectionElementKindSectionHeader withReuseIdentifier:HEADVIEWIDENTIFER forIndexPath:indexPath];
        NSString *headString = [NSString stringWithFormat:@"%ld月",indexPath.section + 1];
        CaseHeadView *view = [[CaseHeadView alloc] initWithCaseListHeadViewWithHeadName:headString];
        [headerView addSubview:view];//头部广告栏
        return headerView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREENWIDTH, 45);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    CaseInsideViewController *vc = [CaseInsideViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UICollectionViewDelegateLeftAlignedLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return (_isCross) ?  CGSizeMake(SCREENWIDTH, 80) :  CGSizeMake((SCREENWIDTH- 120.f)/3.f, (SCREENWIDTH - 120.f) * 104/225.f + 60.f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return (_isCross) ? UIEdgeInsetsMake(0, 0.f, 0.f, 0.f) : UIEdgeInsetsMake(0, 20.f, 0.f, 20.f);
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return (_isCross) ? 0.f : 20.f;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return (_isCross) ? 0 : 10.f;
}

#pragma mark - setter and getter
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        JHHeaderFlowLayout *layout = [[JHHeaderFlowLayout alloc] init];
        //        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.f , SCREENWIDTH ,THEPAGEHEIGHT) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CaseListCell class] forCellWithReuseIdentifier:TheCaseIdentifer];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADVIEWIDENTIFER];
        _collectionView.mj_header = [FDMGifRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
        [_collectionView.mj_header beginRefreshing];
    }
    return _collectionView;
}
- (NSMutableArray *)dataSourceArr {
    
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}
- (SuspensionBtnView *)susButton {
    
    if (!_susButton) {
        _susButton = [[SuspensionBtnView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, SCREENHEIGHT - 120.f, 40, 40) withImageName:@"case_SquareCase"];
        _susButton.delegate = self;
    }
    return _susButton;
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
