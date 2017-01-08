//
//  HomeViewController.m
//  FaDaMi
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "HomeHeadView.h"


#import <AMapSearchKit/AMapSearchKit.h>
#import "AMapLocationKit.h"
#import "MobClick.h"

static NSString *const HomeCellIdentifier = @"HomeCellIdentifier";

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate,HomeHeadViewPro,AMapSearchDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArrays;
@property (nonatomic, strong) HomeHeadView *headView;
@property (nonatomic, strong) UIButton *topButton;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapLocationManager *locationService;//定位服务
@property (nonatomic, strong) CLLocation *userLocation;  //我的位置
@property (nonatomic, assign) NSUInteger page;//分页
@end

@implementation HomeViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self userLocationService];//开始定位
}
#pragma mark - Methods
- (void)initUI {
    
    [self setupNaviBarWithTitle:@"首页"];
    
    [self.view addSubview:self.tableView];

    [_tableView setTableHeaderView:self.headView];
    [self.view addSubview:self.topButton];
    [self.view bringSubviewToFront:self.topButton];
    _page = 0;

    [self loadNewData];
}
#pragma mark - UIButton Event
- (void)goToTableViewTop:(UIButton *)btn {
    
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark ------ 下拉刷新
- (void)loadNewData { WEAKSELF
    
    [NetWorkMangerTools homeViewAllDataRequestSuccess:^(NSArray *hdArr, NSArray *hotArr) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.dataSourceArrays removeAllObjects];
        [weakSelf.dataSourceArrays addObjectsFromArray:hotArr];
        [weakSelf.headView setSlideArrays:hdArr];
        [weakSelf.tableView reloadData];
    } fail:^{
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender { WEAKSELF
    
    NSString *url = [NSString stringWithFormat:@"%@%@&page=%ld",kProjectBaseUrl,HOTSPOTALL,(unsigned long)_page];
    [NetWorkMangerTools loadMoreDataHomePage:url RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.dataSourceArrays addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
        weakSelf.page ++;
    } fail:^{
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _topButton.hidden = (scrollView.contentOffset.y > THEPAGEHEIGHT) ? NO : YES;
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HomeCellIdentifier];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeCellIdentifier];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[HomeTableViewCell class]]) {
        HomeTableViewCell *homeCell = (HomeTableViewCell *)cell;
        if (self.dataSourceArrays.count >0) {
            [homeCell settingUIWithHomeModel:_dataSourceArrays[indexPath.row]];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_dataSourceArrays.count >0) {
        
        [MobClick event:@"SYreDian" label:@"首页"];
        
//        HomeModel *model = _dataSourceArrays[indexPath.row];
//        NSString *url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,DetailsEventHotSpot,model.id];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95.f;
}

#pragma mark - HomeHeadViewPro
- (void)getSlideWithCount:(NSUInteger)count {
    
}
- (void)clickOnTheButtonModuleWithButtonTag:(NSUInteger)btnTag {
    
}
#pragma mark - setter and getter
- (HomeHeadView *)headView{
    
    if (!_headView) {
        _headView = [[HomeHeadView alloc] initWithDelegate:self];
    }
    return _headView;
}
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREENWIDTH, THEPAGEHEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setBackgroundColor:[UIColor clearColor]];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:HomeCellIdentifier];
        _tableView.mj_header = [FDMGifRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
    }
    return _tableView;
}
- (UIButton *)topButton {
    
    if (!_topButton) {
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.frame =CGRectMake(SCREENWIDTH - 50.f, SCREENHEIGHT - 120.f, 40.f, 40.f);
        [_topButton setBackgroundColor:[UIColor clearColor]];
        [_topButton setImage:kGetImage(@"home_back_top") forState:0];
        [_topButton setHidden:YES];
        [_topButton addTarget:self action:@selector(goToTableViewTop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topButton;
}
- (NSMutableArray *)dataSourceArrays {
    
    if (!_dataSourceArrays) {
        _dataSourceArrays = [NSMutableArray array];
    }
    return _dataSourceArrays;
}
#pragma mark -获取地理位置信息
- (void)userLocationService {
    
    _locationService = [[AMapLocationManager alloc] init];
    _locationService.delegate = self;
    [_locationService startUpdatingLocation];//开启定位
}
#pragma mark - MapView Delegate 更新地理位置
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    
    if (location) {
        _userLocation = location;
        [_locationService stopUpdatingLocation];//停止定位
        //初始化检索对象
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        //regeo.radius = 10000;
        regeo.requireExtension = YES;
        //发起逆地理编码
        [_search AMapReGoecodeSearch: regeo];
    }
    
    DLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    
    if(response.regeocode != nil) {
        
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        __block NSString *provience = response.regeocode.addressComponent.province;
        __block NSString *city = response.regeocode.addressComponent.city;
        __block NSDictionary *cityDict = [NSDictionary dictionaryWithObjectsAndKeys:@"北京市",@"北京",@"上海市",@"上海",@"重庆市",@"重庆",@"天津市",@"天津", nil];
        
        NSArray *keysArrays = [cityDict allKeys];
        
        [keysArrays enumerateObjectsUsingBlock:^(NSString *objString, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([QZManager isString:provience withContainsStr:objString]) {
                
                provience = objString;
                city = cityDict[objString];
                *stop = YES;
            }
        }];
        [PublicFunction ShareInstance].locProv = provience;
        [PublicFunction ShareInstance].locCity = city;
        [PublicFunction ShareInstance].locDistrict = response.regeocode.addressComponent.district;
        [PublicFunction ShareInstance].formatAddress = response.regeocode.formattedAddress;
        DLog(@"%@-----%@-----%@",[PublicFunction ShareInstance].locProv, [PublicFunction ShareInstance].locCity,[PublicFunction ShareInstance].locDistrict);
    }
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
