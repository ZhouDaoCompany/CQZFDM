//
//  StickyNotesViewController.m
//  FaDaMi
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 CQZ. All rights reserved.
//

#import "StickyNotesViewController.h"
#import "StickyNotesDetialVC.h"
#import "StickyNotesTabViewCell.h"
#import "NotesFrameItems.h"
#import "UIScrollView+EmptyDataSet.h"

static NSString *const NOTESCELLIDENTIFER = @"notesCellIdentifer";

@interface StickyNotesViewController () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate,NotesDetialVCPro,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *notesFrames;

@end

@implementation StickyNotesViewController

- (void)dealloc {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,BIANQIANLIST,UID];
    [ZhouDao_NetWorkManger cancelRequestWithURL:urlString];
}
- (NSArray *)fianceFramesWithArrays:(NSArray *)arrays {
    
    _notesFrames = [NotesFrameItems notesFramesWithDataArr:arrays];
    return _notesFrames;
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary* dict = @{NSFontAttributeName:Font_18,NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

#pragma mark - methods
- (void)initUI {
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupNaviBarWithTitle:@"便签"];
    [self setupNaviBarWithBtn:NaviRightBtn title:@"" img:@"mine_addNZ"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    [self.view addSubview:self.tableView];

}
- (void)loadNewData { WEAKSELF
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,BIANQIANLIST,UID];
    [NetWorkMangerTools loadNoteTheListWithURLString:urlString
                                      RequestSuccess:^(NSArray *arr) {
                                 
                                          [weakSelf.tableView.mj_header endRefreshing];
                                          [weakSelf.notesFrames removeAllObjects];
                                          [weakSelf fianceFramesWithArrays:arr];
                                          [weakSelf.tableView reloadData];

                                      } fail:^{
                                          [weakSelf.tableView.mj_header endRefreshing];
                                      }];
}
#pragma mark - UIButton Event
- (void)rightBtnAction {
    
    StickyNotesDetialVC *vc = [[StickyNotesDetialVC alloc] initWithModel:nil withType:NotesCreateType withIndex:0 withNoteDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 
- (void)deleteSuccessThisNotes:(NSUInteger)index {
    
    [self.notesFrames removeObjectAtIndex:index];
    [self.tableView reloadData];
}
- (void)addOREditSuccessThisNotes {
    
    [self loadNewData];
}
#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.notesFrames count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    StickyNotesTabViewCell *cell = (StickyNotesTabViewCell *)[tableView dequeueReusableCellWithIdentifier:NOTESCELLIDENTIFER];
    cell.rightUtilityButtons = [self normalRightButtons];

    if ([self.notesFrames count] > 0) {
        [cell setNotesItem:self.notesFrames[indexPath.row] withDelegate:self];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotesFrameItems *notesItem = self.notesFrames[indexPath.row];
    StickyNotesDetialVC *vc = [[StickyNotesDetialVC alloc] initWithModel:notesItem.notesModel withType:NotesEditType withIndex:indexPath.row withNoteDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotesFrameItems *notesItem = self.notesFrames[indexPath.row];
    return notesItem.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}
- (NSArray *)normalRightButtons {
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:hexColor(00c8aa) icon:kGetImage(@"mine_deleteBQ")];
    return rightUtilityButtons;
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index { WEAKSELF
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSUInteger row = cellIndexPath.row;
    NotesFrameItems *notesItem = self.notesFrames[row];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@&id=%@",kProjectBaseUrl,BIANQIANDELETE,UID,notesItem.notesModel.id];
    [NetWorkMangerTools generalGetURLString:urlString
                             RequestSuccess:^{
                                 
                                 [JKPromptView showWithImageName:nil message:LOCBIANQIANDELETE];
                                 [weakSelf.notesFrames removeObjectAtIndex:row];
                                 [weakSelf.tableView reloadData];
                             } fail:^{
                                 
                             }];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    
    return YES;
}
- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    
    return YES;
}
#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
        
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc] initWithString:@"暂无便签，点击添加" attributes:@{NSFontAttributeName:Font_15}];
    NSRange range1=[[hintString string]rangeOfString:@"暂无便签，"];
    [hintString addAttribute:NSForegroundColorAttributeName value:hexColor(666666) range:range1];
    NSRange range2=[[hintString string]rangeOfString:@"点击添加"];
    [hintString addAttribute:NSForegroundColorAttributeName value:hexColor(00c8aa) range:range2];

    return hintString;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return kGetImage(@"PlaceholderLogo");
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return -64.0f;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    
    return 18.f;
}
#pragma mark - DZNEmptyDataSetDelegate Methods
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {

    [self rightBtnAction];
}
#pragma mark - setter and getter
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT - 64.f)
                                                  style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[StickyNotesTabViewCell class] forCellReuseIdentifier:NOTESCELLIDENTIFER];
        _tableView.mj_header = [FDMGifRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [_tableView.mj_header beginRefreshing];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}
- (NSMutableArray *)notesFrames {
    
    if (!_notesFrames) {
        _notesFrames = [NSMutableArray array];
    }
    return _notesFrames;
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
