//
//  ScanViewController.m
//  ZhouDao
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ScanViewController.h"
#import "UIView+SDExtension.h"

#import <AVFoundation/AVFoundation.h>

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate> {
    
    CABasicAnimation *_scanNetAnimation;
}
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIImageView *scanNetImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation ScanViewController
#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES];
    if (_session) {
        [_scanNetImageView.layer addAnimation:_scanNetAnimation forKey:nil];
        [_session startRunning];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
#pragma mark - methods
- (void)initUI {
    
    self.fd_interactivePopDisabled = YES;//禁止滑回
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.view.clipsToBounds = YES;
    
    [self.view addSubview:self.maskView];
    [self setupScanWindowView];
    [self.view addSubview:self.backButton];
    [self beginScanning];
}
- (void)setupScanWindowView {
    
    CGFloat scanWindowH = SCREENWIDTH - 120;
    UIView *scanWindow = [[UIView alloc] initWithFrame:CGRectMake(60, 170, scanWindowH, scanWindowH)];
    scanWindow.clipsToBounds = YES;
    [self.view addSubview:scanWindow];
    
    [scanWindow addSubview:self.scanNetImageView];
   
    
    CGFloat buttonWH = 17;
    
    UIImageView *topLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    topLeft.image = kGetImage(@"scan_1");
    [scanWindow addSubview:topLeft];
    
    UIImageView *topRight = [[UIImageView alloc] initWithFrame:CGRectMake(scanWindowH - buttonWH, 0, buttonWH, buttonWH)];
    topRight.image = kGetImage(@"scan_2");
    [scanWindow addSubview:topRight];
    
    UIImageView *bottomLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, scanWindowH - buttonWH +2.5f, buttonWH, buttonWH)];
    bottomLeft.image = kGetImage(@"scan_3");
    [scanWindow addSubview:bottomLeft];

    
    UIImageView *bottomRight = [[UIImageView alloc] initWithFrame:CGRectMake(topRight.sd_x, bottomLeft.sd_y, buttonWH, buttonWH)];
    bottomRight.image = kGetImage(@"scan_4");
    [scanWindow addSubview:bottomRight];
}
- (void)beginScanning {
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    output.rectOfInterest = CGRectMake(0.1, 0, 0.9, 1);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count>0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:metadataObject.stringValue delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"再次扫描", nil];
        [alert show];
    }
}
- (void)scanDisMiss {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [self scanDisMiss];
    } else if (buttonIndex == 1) {
        
        [_session startRunning];
    }
}
#pragma mark - setter and getter
- (UIButton *)backButton {
    
    if (!_backButton) {
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(15, 20, 50, 50);
        [_backButton setImage:kGetImage(@"back_normal") forState:0];
        [_backButton addTarget:self action:@selector(scanDisMiss) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setBackgroundColor:[UIColor clearColor]];
    }
    return _backButton;
}
- (UIView *)maskView {
    
    if (!_maskView) {
        
        _maskView = [[UIView alloc] init];
        float borderW = ((SCREENHEIGHT -  SCREENWIDTH - 30.f) > 150.f) ? (SCREENHEIGHT -  SCREENWIDTH - 30.f) : 150.f;
        _maskView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
        _maskView.layer.borderWidth = borderW;
        _maskView.frame = CGRectMake(60 - borderW,170 - borderW, SCREENWIDTH + 2*(borderW - 60), SCREENHEIGHT+ (borderW -150));
    }
    return _maskView;
}
- (UIImageView *)scanNetImageView {
    
    if (!_scanNetImageView) {
        
        _scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
        _scanNetImageView.frame = CGRectMake(0, -241, SCREENWIDTH - 120, 241);
        _scanNetAnimation = [CABasicAnimation animation];
        _scanNetAnimation.keyPath = @"transform.translation.y";
        _scanNetAnimation.byValue = @(SCREENWIDTH - 120);
        _scanNetAnimation.duration = 2.0;
        _scanNetAnimation.repeatCount = MAXFLOAT;
        [self.scanNetImageView.layer addAnimation:_scanNetAnimation forKey:nil];
    }
    return _scanNetImageView;
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
