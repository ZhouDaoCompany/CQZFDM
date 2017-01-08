//
//  LoginViewController.m
//  ZhouDao
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"
#import "RegisterViewController.h"
#import "FindKeyViewController.h"
#import "ThirdPartyLoginView.h"
#import "BindingViewController.h"
#import "NSString+MHCommon.h"

@interface LoginViewController ()<UITextFieldDelegate,ThirdPartyLoginPro>

@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *keyText;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic, strong) ThirdPartyLoginView * loginView;

- (IBAction)forgetAndLoginEvent:(id)sender;
@end

@implementation LoginViewController
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}
#pragma mark - methods
- (void)initUI { WEAKSELF
    
    [self setupNaviBarWithTitle:@"登录"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Count_close_normal_"];
//    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    
    LRViewBorderRadius(_bottomView, 5.f, .5f, hexColor(D7D7D7));
    LRViewBorderRadius(_loginBtn, 5.f, 0.f, [UIColor clearColor]);
//    _forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 44, SCREENWIDTH-50.f, .5);
    lineView.backgroundColor = hexColor(D7D7D7);
    [_bottomView addSubview:lineView];
    
    
    _nameText.delegate = self;
    _keyText.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.nameText];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.keyText];

    
    [self.view addSubview:self.loginView];
    _loginView.frameBlock = ^(NSInteger index){
        
        CGRect frame = (index == 1) ? CGRectMake(0, SCREENHEIGHT - 130, SCREENWIDTH, 130) : CGRectMake(0, SCREENHEIGHT - 40, SCREENWIDTH, 40);
        
        [UIView animateWithDuration:0.25f animations:^{
            weakSelf.loginView.frame = frame;
        }];
    };
}
#pragma mark -getters and seters
#pragma mark -第三方登录
- (ThirdPartyLoginView *)loginView {
    
    if (!_loginView) {
        CGRect frame = (SCREENHEIGHT >= 568) ? CGRectMake(0, SCREENHEIGHT - 130, SCREENWIDTH, 130) : CGRectMake(0, SCREENHEIGHT - 40, SCREENWIDTH, 40);
        _loginView = [[ThirdPartyLoginView alloc] initWithFrame:frame withPresentVC:self];
        _loginView.isLook = (SCREENHEIGHT >= 568) ? YES : NO;
        _loginView.delegate = self;
    }
    return _loginView;
}
#pragma mark -ThirdPartyLoginPro
- (void)isBoundToLoginSuccessfully {
    
    [self rightBtnAction];
}
- (void)unboundedAccountToBindwithUsid:(NSString *)usid withs:(NSString *)sString {
    
    BindingViewController *bindVC = [BindingViewController new];
    bindVC.sString = sString;
    bindVC.usid = usid;
    [self.navigationController pushViewController:bindVC animated:YES];
}
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        //SHOW_ALERT(@"不能输入表情!");
        textField.text = [NSString disable_emoji:textField.text];
    }
    
    if (textField.tag == 3000) {
        if (textField.text.length >11) {
            textField.text = [textField.text substringToIndex:11 ];
        }
    }
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self dismissKeyBoard];
    return true;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}
#pragma mark -UIButtonEvent
- (void)rightBtnAction {
    
    if (self.closeBlock) {
        self.closeBlock();
    }
    [self dismissViewControllerAnimated:YES completion:^{
  }];
}
- (IBAction)gotoRegister:(id)sender { WEAKSELF
    
    RegisterViewController *registerVC  = [RegisterViewController new];
    registerVC.successRegisterBlock = ^(NSString *nameS,NSString *pawS){
        
        weakSelf.nameText.text = nameS;
        weakSelf.keyText.text = pawS;
    };
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)forgetAndLoginEvent:(id)sender {WEAKSELF;
    UIButton *button = (UIButton *)sender;
    NSUInteger index = button.tag;
    
    switch (index) {
        case 1001: {//忘记密码
            FindKeyViewController *findVC = [FindKeyViewController new];
            findVC.navTitle = @"找回密码";
            findVC.findBlock = ^(NSString *phone){
                weakSelf.nameText.text = phone;
            };
            [self.navigationController  pushViewController:findVC animated:YES];
        }
            break;
        case 1002: {//登录
            if (self.nameText.text.length <=0 && self.keyText.text.length<=0) {
                SHOW_ALERT(@"请您填写账号和密码");
                return;
            } else if ([QZManager isIncludeSpecialCharact:self.nameText.text] ==YES || [QZManager isIncludeSpecialCharact:self.keyText.text] == YES) {
                
                [JKPromptView showWithImageName:nil message:@"账号或密码包含非法字符，请您仔细检查"];
                return;
            }
            
            if (![QZManager isValidatePassword:_keyText.text]) {
                
                [JKPromptView showWithImageName:nil message:LOCPASSWORDLIMIT];
                return;
            }

            NSString *loginurl = [NSString stringWithFormat:@"%@%@mobile=%@&pw=%@",kProjectBaseUrl,LoginUrlString,_nameText.text,[_keyText.text md5]];
            [NetWorkMangerTools loginEventURLString:loginurl RequestSuccess:^{
                
                [USER_D setObject:_nameText.text forKey:StoragePhone];
                [USER_D setObject:[_keyText.text md5] forKey:StoragePassword];
                //                [USER_D removeObjectForKey:StorageTYPE];
                //                [USER_D removeObjectForKey:StorageUSID];
                
                [USER_D synchronize];
                [weakSelf rightBtnAction];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyBoard];
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
