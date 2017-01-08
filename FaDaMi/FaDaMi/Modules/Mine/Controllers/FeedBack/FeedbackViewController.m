//
//  FeedbackViewController.m
//  FaDaMi
//
//  Created by apple on 16/12/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "FeedbackViewController.h"
#import "LCActionSheet.h"

#import "QZAlbumHelperView.h"


@interface FeedbackViewController () <QMUITextViewDelegate,QZAlbumHelperViewPro>

@property (nonatomic, strong) QMUITextView *msgText;
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UIScrollView *picScrolView;//图片
@property (nonatomic, strong) NSMutableArray *imgArrays;//图片数组
@property (nonatomic, strong) UILabel *thankLab;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation FeedbackViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
#pragma mark - methods
- (void)initUI {
    [self setupNaviBarWithTitle:@"意见反馈"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:@"" img:@"backVC"];

    [self.view addSubview:self.thankLab];
    [self.view addSubview:self.msgText];
    [self.view addSubview:self.phoneTextF];
    [self.view addSubview:self.picScrolView];
    [self.view addSubview:self.submitBtn];

    [self selectPhotoMethod];

}
- (void)selectPhotoMethod {
    
    CGSize sizeWidth = _picScrolView.frame.size;
    
    for (UIView *v in _picScrolView.subviews) {
        
        if ([v isKindOfClass:[UIImageView class]]) {
            
            [v removeFromSuperview];
        } else if ([v isKindOfClass:[UIButton class]]) {
           
            [v removeFromSuperview];
        }
    }
    
    for (NSUInteger i = 0; i < [_imgArrays count]; i++) {
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(80.0f*i + 10*i,5,80.f,80.f)];
        iv.backgroundColor = [UIColor clearColor];
        iv.tag = i+3000;
        iv.userInteractionEnabled = YES;
        [iv setImage:_imgArrays[i]];
        UIButton *buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonClose.frame = CGRectMake(60, -5, 25, 25);
        buttonClose.tag = 3000 + i;
        [buttonClose setBackgroundImage:[UIImage imageNamed:@"close_icon_highlight"] forState:UIControlStateNormal];
        [buttonClose addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [iv addSubview:buttonClose];
        
        [_picScrolView addSubview:iv];
        iv = nil;
    }
    
    UIButton  *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSUInteger count = _imgArrays.count;
    if ([_imgArrays count] < 1) {
        
        addButton.frame = CGRectMake(_imgArrays.count *80.f+ 10*_imgArrays.count, 5, 80, 80);
        [addButton setBackgroundImage:[UIImage imageNamed:@"compose_pic_add"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(goToPhotoAlbum:) forControlEvents:UIControlEventTouchUpInside];
        [_picScrolView addSubview:addButton];
        count += 1;
    }
    [_picScrolView setContentSize:CGSizeMake(80.0f * count + 10*count, sizeWidth.height)];
}
#pragma mark - UITextViewDelegate
//通过委托来放弃第一响应者
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark -UIButtonEvent
- (void)submitBtnEvent:(id)sender { WEAKSELF
    
    DLog(@"提交资料");
    if (_msgText.text.length == 0) {
        [JKPromptView showWithImageName:nil message:LOCFILLCONTENE];
        return;
    }
    NSString *phoneS = [PublicFunction ShareInstance].m_user.data.mobile;
    
    if (_phoneTextF.text.length > 0) {
        if (_phoneTextF.text.length != 11  || [QZManager isPureInt:_phoneTextF.text] == NO) {
            [JKPromptView showWithImageName:nil message:LOCRIGHTPHONE];
            return;
        }
        phoneS = _phoneTextF.text;
    }
    
    if (_imgArrays.count == 0) {
        
        [NetWorkMangerTools feedBackWithImage:nil withPhone:phoneS withContent:_msgText.text RequestSuccess:^{
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            
            [NetWorkMangerTools getQiNiuToken:NO RequestSuccess:^{
                
                [NetWorkMangerTools feedBackWithImage:_imgArrays[0] withPhone:phoneS withContent:_msgText.text RequestSuccess:^{
                    
                    kDISPATCH_MAIN_THREAD((^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }));
                }];
            }];
        });
    }
}
#pragma mark -提交
#pragma mark -选取照片
- (void)goToPhotoAlbum:(id)sender { WEAKSELF
    
    [self dismissKeyBoard];
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        DLog(@"> Block way -> Clicked Index: %ld", (long)buttonIndex);
        
        [weakSelf selectCameraOrPhotoList:buttonIndex];
    }];

    [sheet show];
}
//删除图片
- (void) deletePhoto:(id)sender { WEAKSELF
    
    [self dismissKeyBoard];
    NSInteger deletedPhoto = ((UIButton *)sender).tag;
    
    for (UIImageView *currentSubView in _picScrolView.subviews) {
        
        if (deletedPhoto == currentSubView.tag) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.imgArrays removeObjectAtIndex:deletedPhoto-3000];
                for (UIImageView *imgView in _picScrolView.subviews) {
                    
                    [imgView removeFromSuperview];
                }
                [self selectPhotoMethod];
            });
        }
    }
}

#pragma mark -选择相机
- (void)selectCameraOrPhotoList:(NSUInteger)index {
    
    ImageSelectType type = (index == 0) ? CameraImageType : SingleImageType;
    QZAlbumHelperView *view = [[QZAlbumHelperView alloc] initWithSelectTypePhotosWithSelectType:type withFatherViewController:self];
    [self.view addSubview:view];
}
#pragma mark - QZAlbumHelperViewPro
- (void)sendCameraImage:(UIImage *)cameraImage {
    
    [self.imgArrays addObject:cameraImage];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self selectPhotoMethod];
    });
}
- (void)sendSingleImage:(UIImage *)singleImage {
    
    [self.imgArrays addObject:singleImage];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self selectPhotoMethod];
    });
}

#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissKeyBoard];
}

#pragma mark - setter and getter
- (NSMutableArray *)imgArrays {
    
    if (!_imgArrays) {
        _imgArrays = [NSMutableArray array];
    }
    return _imgArrays;
}
- (UILabel *)thankLab {
    
    if (!_thankLab) {
        _thankLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 84, SCREENWIDTH - 30.f, 50)];
        _thankLab.text = @"欢迎您提出宝贵的建议，您留下来的每个字都将用来改善我们的软件。我们由衷的对您表示感谢！";
        _thankLab.numberOfLines = 0;
        _thankLab.font = Font_14;
        _thankLab.textColor = LRRGBColor(49, 50, 51);
    }
    return _thankLab;
}
- (QMUITextView *)msgText {
    
    if (!_msgText) {
        _msgText = [[QMUITextView alloc] initWithFrame:CGRectMake(15, Orgin_y(_thankLab) +15, SCREENWIDTH - 30, 120)];
        _msgText.delegate =self;
        _msgText.font = Font_14;
        _msgText.placeholder = @" 请输入您的意见";
//        _msgText.placeholderColor = [UIColor lightGrayColor];
        _msgText.backgroundColor = [UIColor whiteColor];
        _msgText.layer.borderColor = LRRGBColor(214, 215, 216).CGColor;
        _msgText.layer.borderWidth = 1.f;
    }
    return _msgText;
}

- (UITextField *)phoneTextF {
    
    if (!_phoneTextF) {
        _phoneTextF = [[UITextField alloc] initWithFrame:CGRectMake(15, Orgin_y(_msgText) +15 , SCREENWIDTH - 30.f, 40)];
        _phoneTextF.backgroundColor = [UIColor whiteColor];
        _phoneTextF.borderStyle = UITextBorderStyleNone;
        _phoneTextF.layer.borderColor = LRRGBColor(214, 215, 216).CGColor;
        _phoneTextF.layer.borderWidth = 1.f;
        _phoneTextF.font = Font_14;
        [_phoneTextF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [_phoneTextF setValue:Font_14 forKeyPath:@"_placeholderLabel.font"];
        _phoneTextF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextF.placeholder = @"  请输入手机号";
    }
    return _phoneTextF;
}
- (UIScrollView *)picScrolView {
    
    if (!_picScrolView) {
        _picScrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, Orgin_y(_phoneTextF) + 15, SCREENWIDTH - 30, 90.f)];
        _picScrolView.backgroundColor = [UIColor clearColor];
    }
    return _picScrolView;
}
- (UIButton *)submitBtn {
    
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_submitBtn setTitle:@"提交" forState:0];
        _submitBtn.frame = CGRectMake(15, Orgin_y(_picScrolView) + 15, SCREENWIDTH - 30, 40);
        _submitBtn.backgroundColor = KNavigationBarColor;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 5.f;
        [_submitBtn addTarget:self action:@selector(submitBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
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
