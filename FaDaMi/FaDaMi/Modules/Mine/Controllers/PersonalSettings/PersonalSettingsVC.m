//
//  PersonalSettingsVC.m
//  FaDaMi
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "PersonalSettingsVC.h"
#import "SettingTabCell.h"
#import "LCActionSheet.h"
#import "MyPickView.h"
#import "QHCommonUtil.h"
#import "ZHPickView.h"
#import "FindKeyViewController.h"
#import "ReplacePhoneVC.h"
#import "UMessage.h"
#import "ConsultantHeadView.h"

static NSString *const SettingIdentifer = @"SettingIdentifer";

@interface PersonalSettingsVC () <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *msgArrays;
@property (nonatomic, strong) NSArray *titArrays;
@property (nonatomic, strong) UIImage *headImage;//头像
@property (nonatomic, strong) UIImageView *mainBackgroundIV;
@property (nonatomic, strong) NSArray *imageArrays;
@property (nonatomic, strong) UIView *footView;

@end

@implementation PersonalSettingsVC

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - Methods
- (void)initUI {
    
    [self setupNaviBarWithTitle:@"我"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    

    [self.view addSubview:self.tableView];
    [_tableView setTableFooterView:self.footView];

}
#pragma mark - UIButton Event
- (void)exitBtnEvent:(UIButton *)btn {
    
    
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (section == 0)?[self.titArrays count] : 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    SettingTabCell *cell = (SettingTabCell *)[tableView dequeueReusableCellWithIdentifier:SettingIdentifer];
    
    if (indexPath.section == 0) {
        cell.nameLab.text = self.titArrays[indexPath.row];
        cell.addresslab.text = self.msgArrays[indexPath.row];
        if (_headImage) {
            cell.headImg.image = _headImage;
        } else {
            [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[PublicFunction ShareInstance].m_user.data.photo] placeholderImage:[UIImage imageNamed:@"mine_head"]];
        }
    }else {
        cell.ParentView = self;
    }
    [cell settingUIWithSection:indexPath.section withRow:indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 80.f;
    }
    return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { WEAKSELF
    
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            
            [self addActionSheet];
        }else if (indexPath.row == 1){
            
            ReplacePhoneVC *VC = [ReplacePhoneVC new];
            [self.navigationController pushViewController:VC animated:YES];
            
        }else if (indexPath.row == 2){
            
            FindKeyViewController *findVC = [FindKeyViewController new];
            findVC.navTitle = @"修改密码";
            [self.navigationController pushViewController:findVC animated:YES];
            
        }else if (indexPath.row == 3){
            
            //[self configureViewBlurWith:self.view.frame.size.width scale:0.8];
            UIWindow *windows = [UIApplication sharedApplication].windows[0];
            MyPickView *pickView = [[MyPickView  alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            pickView.pickBlock = ^(NSString *provice,NSString *city,NSString *area){
                DLog(@"地区是－－－%@:%@,%@",provice,city,area);
                NSString *tempStr = [NSString stringWithFormat:@"%@-%@-%@",provice,city,area];
                [NetWorkMangerTools resetUserAddress:tempStr RequestSuccess:^{
                    
                    [_msgArrays replaceObjectAtIndex:3 withObject:tempStr];
                    [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
            };
            [windows addSubview:pickView];
            
        }else if (indexPath.row == 4){
            [NetWorkMangerTools getApplyInfoRequestSuccess:^{
                
                [weakSelf requestMyCertification];
            }];
        }else if (indexPath.row == 5){
            
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"确定"] redButtonIndex:0 clicked:^(NSInteger buttonIndex) {
                
                DLog(@"> Block way -> Clicked Index: %ld", (long)buttonIndex);
                if (buttonIndex == 0) {
                    [weakSelf clearApplicationCaChe];
                }
            }];
            [sheet show];
        }
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    }
    ConsultantHeadView *headView = [[ConsultantHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45.f) withSection:section];
    headView.delBtn.hidden = YES;
    [headView setLabelText:@"账号绑定"];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return (section == 0) ? 15.f : 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}
#pragma mark -
#pragma mark - 解除 绑定 和绑定

#pragma mark -查询认证审核
- (void)requestMyCertification { WEAKSELF
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:@[@"执业律师",@"实习律师",@"公司法务",@"法律专业学生",@"公务员",@"其他"] title:@"选择职业"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr,NSString *type) {
        
        [NetWorkMangerTools resetUserJobInfo:type RequestSuccess:^{
            
            [weakSelf.msgArrays replaceObjectAtIndex:4 withObject:selectedStr];
            [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:4 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            [PublicFunction ShareInstance].m_user.data.type = type;
        }];
    };
}
- (void)addActionSheet { WEAKSELF
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        DLog(@"> Block way -> Clicked Index: %ld", (long)buttonIndex);
        [weakSelf selectCameraOrPhotoList:buttonIndex];
    }];
    [sheet show];
}
#pragma mark -选择相机
- (void)selectCameraOrPhotoList:(NSUInteger)index { WEAKSELF
    
    switch (index) {
        case 0: {//从相机选择
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                SHOW_ALERT(@"亲，您的设备没有摄像头-_-!!");
            }else{
                kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
                    
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
                    imagePickerController.delegate = self;
                    imagePickerController.showsCameraControls = YES;//是否显示照相机标准的控件库
                    [imagePickerController setAllowsEditing:YES];//是否加入照相后预览时的编辑功能
                    kDISPATCH_MAIN_THREAD(^{
                        
                        [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
                    });
                });
            }
        }
            break;
        case 1: {//从相册选择一张
            kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.allowsEditing = YES;
                kDISPATCH_MAIN_THREAD(^{
                    
                    [weakSelf presentViewController:picker animated:YES completion:^{
                        //                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    }];
                });
            });
        }
            break;
        default:
            break;
    }
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    // 当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {//UIImagePickerControllerOriginalImage
        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"]; // 裁剪后的图片
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存相册
        });
        _headImage = image;
    }
    
    [self uploadHeaderImageItemClick];
}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
//    [picker dismissViewControllerAnimated:YES completion:^{
//    }];
//    _headImage = image;
//    [self uploadHeaderImageItemClick];
//}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary && [navigationController.viewControllers count] <=2) {
        //        navigationController.navigationBar.translucent = NO;
        navigationController.navigationBarHidden = NO;
        navigationController.navigationBar.barStyle = UIBarStyleBlack;
        navigationController.navigationBar.tintColor = [UIColor whiteColor];
        navigationController.navigationBar.backgroundColor = hexColor(353535);
        //        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }else {
        navigationController.navigationBarHidden = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}
- (void)uploadHeaderImageItemClick { WEAKSELF
    if (_headImage >0) {
        //        CGSize imgSize = CGSizeMake(80, 80);
        //        _headImage = [QZManager compressOriginalImage:photoArr[0] toSize:imgSize];
        
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            
            [NetWorkMangerTools getQiNiuToken:NO RequestSuccess:^{
                
                [NetWorkMangerTools uploadUserHeadImg:_headImage RequestSuccess:^{
                    
                    kDISPATCH_MAIN_THREAD((^{
                        
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                    }));
                    
                } fail:^{
                    weakSelf.headImage = nil;
                }];
            }];
            
        });
        
    }
}

#pragma mark - 查询文件
-(float )folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/(1024.0*1024.0);
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (void)clearApplicationCaChe{ WEAKSELF
    [MBProgressHUD showMBLoadingWithText:@"清理中..."];
    [[SDImageCache sharedImageCache] cleanDisk];
    //    [ZhouDao_NetWorkManger clearCaches]; //很少不用清除
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        DLog(@"files :%lu",(unsigned long)[files count]);
        [files enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:obj];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path])
            {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf clearCacheSuccess];
        });
    });
    
}
- (void)clearCacheSuccess {
    
    [MBProgressHUD hideHUD];
    [JKPromptView showWithImageName:nil message:LOCCLEARCACHE];
    [_msgArrays replaceObjectAtIndex:5 withObject:@"0M"];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - setter and getter
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT - 64.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView  registerClass:[SettingTabCell class] forCellReuseIdentifier:SettingIdentifer];
    }
    return _tableView;
}
- (UIView *)footView {
    
    if (!_footView) {
        
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 75.f)];
        _footView.backgroundColor = [UIColor clearColor];
        UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exitBtn.frame = CGRectMake(26, 20, SCREENWIDTH - 52, 45);
        exitBtn.layer.masksToBounds = YES;
        exitBtn.layer.cornerRadius = 5.f;
        exitBtn.backgroundColor  = KNavigationBarColor;
        [exitBtn setTitleColor:[UIColor whiteColor] forState:0];
        [exitBtn setTitle:@"退出当前帐号" forState:0];
        exitBtn.titleLabel.font = Font_14;
        [exitBtn addTarget:self action:@selector(exitBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:exitBtn];
    }
    return _footView;
}
- (NSArray *)imageArrays {
    
    if (!_imageArrays) {
      _imageArrays = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",nil];
    }
    return _imageArrays;
}

- (NSArray *)titArrays {
    
    if (!_titArrays) {
      _titArrays = [NSArray arrayWithObjects:@"我的头像",@"我的账号",@"密码",@"通讯地址",@"我的职业",@"清理缓存", nil];
    }
    return _titArrays;
}
- (NSMutableArray *)msgArrays {
    
    if (!_msgArrays) {
        
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
        float folderSize = [self folderSizeAtPath:path];
        NSString *cacheString = @"";
        (folderSize <=0.01f)?(cacheString = @"0M"):(cacheString =[NSString stringWithFormat:@"%.2fM", folderSize]);

        NSString *pString = [PublicFunction ShareInstance].m_user.data.type;
        NSDictionary *typeDict = [NSDictionary dictionaryWithObjectsAndKeys:@"执业律师",@"1",@"实习律师",@"2",@"公司法务",@"3",@"法律专业学生",@"4",@"公务员",@"5",@"其他",@"9", nil];
        NSString *typeString = typeDict[pString];
        
        NSString *address = @"请您选择地址";
        if (![[PublicFunction ShareInstance].m_user.data.address isEqualToString:@"--"]) {
            
            address = [PublicFunction ShareInstance].m_user.data.address;
        }
        
        _msgArrays = [NSMutableArray arrayWithObjects:@"",[PublicFunction ShareInstance].m_user.data.mobile,@"修改",address, typeString,cacheString,nil];
    }
    return _msgArrays;
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
