//
//  CaseNotesVC.m
//  GovermentTest
//
//  Created by apple on 16/12/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CaseNotesVC.h"
#import "VoiceManager.h"

@interface CaseNotesVC ()<UITextViewDelegate, VoiceDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholdLabel;
@property (nonatomic, strong) UIButton *mcroPhoneButton;
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation CaseNotesVC

#pragma mark - life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //创建语音听写的对象
    [[VoiceManager shareInstance]setPropertysWithView:self.view];
    [VoiceManager shareInstance].delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

#pragma mark - methods
- (void)initUI {
    
    [self.view addSubview:self.bottomView];
    [_bottomView addSubview:self.textView];
    [_bottomView addSubview:self.placeholdLabel];
    [_bottomView addSubview:self.mcroPhoneButton];
    [self.view addSubview:self.commitButton];
}
#pragma mark - UIButton Event
- (void)commitButonEvent:(UIButton *)btn {
    
    DLog(@"提交");
}
- (void)mcroPhoneButtonEvent:(UIButton *)btn {
    
    [self openTheDictation];
}
#pragma mark - UITextViewDelegate
//通过委托来放弃第一响应者
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0){
        _placeholdLabel.text = @"  输入内容";
    }else{
        _placeholdLabel.text = @"";
    }
}

#pragma mark - setter and getter
- (UIView *)bottomView {
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREENWIDTH, 240.f)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (UITextView *)textView {
    
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 25, SCREENWIDTH - 30.f, 151.f)];
        _textView.delegate =self;
        _textView.font = Font_14;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.borderColor = hexColor(D7D7D7).CGColor;
        _textView.layer.borderWidth = 1.f;
    }
    return _textView;
}
- (UILabel *)placeholdLabel {
    
    if (!_placeholdLabel) {
        _placeholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 160, 30)];
        _placeholdLabel.backgroundColor = [UIColor clearColor];
        _placeholdLabel.font = Font_14;
        _placeholdLabel.textColor = hexColor(CCCCCC);
        _placeholdLabel.text = @"  输入内容";
    }
    return _placeholdLabel;
}
- (UIButton *)mcroPhoneButton {
    
    if (!_mcroPhoneButton) {
        _mcroPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mcroPhoneButton.backgroundColor = [UIColor clearColor];
        [_mcroPhoneButton setImage:kGetImage(@"Case_Mcrophone") forState:0];
        _mcroPhoneButton.frame = CGRectMake((SCREENWIDTH - 40)/2.f, 189, 40, 40);
        [_mcroPhoneButton addTarget:self action:@selector(mcroPhoneButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mcroPhoneButton;
}
- (UIButton *)commitButton {
    
    if (!_commitButton) {
        _commitButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.frame = CGRectMake(15, Orgin_y(_bottomView) + 22.f, SCREENWIDTH - 30.f, 40);
        _commitButton.backgroundColor = hexColor(00c8aa);
        [_commitButton addTarget:self action:@selector(commitButonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_commitButton setTitle:@"提交" forState:0];
        _commitButton.titleLabel.font = Font_15;
        _commitButton.layer.cornerRadius = 3.f;
    }
    return _commitButton;
}
#pragma mark -合成语音
- (void)openTheDictation {
    
    [self dismissKeyBoard];
    [[VoiceManager shareInstance]startListenning];
}
#pragma 语音输入回调
/** 识别结果回调方法
 @param resultArray 结果列表
 @param isLast YES 表示最后一个，NO表示后面还有结果
 */
-(void)sucessReturn:(NSArray *)resultArray isLast:(BOOL)isLast{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,result];
    _placeholdLabel.text = (_textView.text.length == 0) ? @"  输入内容" : @"";
    [[VoiceManager shareInstance]cancel];
}

/** 识别结束回调方法
 @param error 识别错误
 */
-(void)errorReturn:(IFlySpeechError *)error{
    DLog(@"errorCode:%@",[error errorDesc]);
}
-(void)popAction {
    
//        [super popAction];
    [VoiceManager shareInstance].delegate = nil;
    [[VoiceManager shareInstance]clearSelf];
}

#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
