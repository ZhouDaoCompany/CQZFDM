//
//  MineViewController.m
//  FaDaMi
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MineViewController.h"
#import "ScanViewController.h"
#import "AbuoutFDMViewController.h"
#import "FeedbackViewController.h"
#import "MyGoodViewController.h"
#import "PersonalSettingsVC.h"
#import "StickyNotesViewController.h"

#import "HeadTableViewCell.h"
#import "ProfessionalCell.h"
#import "CommonViewCell.h"

static NSString *const HeadCellIdentifier = @"MeCellIdentifier";
static NSString *const COMCellIdentifier = @"commenCellIdentifier";
static NSString *const ProCellIdentifier = @"ProfessionalCellIdentifier";

@interface MineViewController () <UITableViewDataSource,UITableViewDelegate,CommonViewCellPro>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *domainArrays;//擅长领域

@end

@implementation MineViewController

#pragma mark - life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - Methods
- (void)initUI {
    
    [self getTheUserArea];//选择用户擅长领域
    
    [self setupNaviBarWithTitle:@"我的"];
    [self setupNaviBarWithBtn:NaviRightBtn title:@"" img:@"mine_ScanLogo"];
    [self.view addSubview:self.tableView];
    
//    UIWindow *window = [QZManager getWindow];
//    UITabBarController *tab = (UITabBarController *)window.rootViewController;
//    
//    for (UIBarItem *item in tab.tabBar.items) {
//        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                      [UIFont fontWithName:@"Helvetica" size:14.0], NSFontAttributeName, nil]
//                            forState:UIControlStateNormal];
//        
//    }

}

- (void)getTheUserArea { WEAKSELF
    
    [NetWorkMangerTools getUserDomainRequestSuccess:^(NSArray *arr) {
        
        [weakSelf.domainArrays addObjectsFromArray:arr];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:2], nil] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
}

#pragma mark - UIButton Event
- (void)rightBtnAction {
    
    ScanViewController *scanVC = [ScanViewController new];
    [self.navigationController pushViewController:scanVC animated:YES];
}
#pragma mark - CommonViewCellPro
- (void)buttonClickEvent:(NSUInteger)index {
    
    switch (index) {
        case 0:{
            
            StickyNotesViewController *vc =[StickyNotesViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            
            break;
        }

        default:
            break;
    }
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = indexPath.section;
    
    if (section == 0) {
        
        [tableView registerClass:[HeadTableViewCell class] forCellReuseIdentifier:HeadCellIdentifier];
        HeadTableViewCell *cell = (HeadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HeadCellIdentifier];
        [cell settingUIreloadNameWithPhone];
        return cell;
    } else if (section == 2) {
        
        [tableView registerClass:[ProfessionalCell class] forCellReuseIdentifier:ProCellIdentifier];
        ProfessionalCell *cell = (ProfessionalCell *)[tableView dequeueReusableCellWithIdentifier:ProCellIdentifier];
        [cell setDomainArrays:self.domainArrays];
        return cell;
    }
    
    [tableView registerClass:[CommonViewCell class] forCellReuseIdentifier:COMCellIdentifier];
    CommonViewCell *cell = (CommonViewCell *)[tableView dequeueReusableCellWithIdentifier:COMCellIdentifier];
    (section == 1) ? [cell settingUIFourButtonUIwithDelegate:self] : [cell setingUICommonWithSection:section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { WEAKSELF
    
    NSUInteger section = indexPath.section;
    
    switch (section) {
        case 0: {
          
            PersonalSettingsVC *setvc = [PersonalSettingsVC new];
            setvc.exitBlock = ^{
                
                [UIView animateWithDuration:0.35f animations:^{
                    
                    weakSelf.tabBarController.selectedIndex = 0;
                }];
            };
            [self.navigationController pushViewController:setvc animated:YES];
            break;
        }
        case 2: {
            MyGoodViewController *vc = [[MyGoodViewController alloc] initWithCompareArrays:_domainArrays];
            vc.domainBlock = ^(NSMutableArray *arr){
                
                weakSelf.domainArrays = arr;
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:2], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
            }];
            
            break;
        }
        case 3: {
            
            self.tabBarController.selectedIndex = 2;

            break;
        }

        case 4: {
            FeedbackViewController *vc = [FeedbackViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 5: {
            
            AbuoutFDMViewController *vc = [AbuoutFDMViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }

        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return 80.f;
    } else if (indexPath.section == 1) {
       
        return 62.f;
    } else if (indexPath.section == 2) {
        
        ProfessionalCell *cell = (ProfessionalCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark - setter and getter

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREENWIDTH, THEPAGEHEIGHT)
                                                  style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    return _tableView;
}
- (NSMutableArray *)domainArrays {
    
    if (!_domainArrays) {
        _domainArrays = [NSMutableArray array];
    }
    return _domainArrays;
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
