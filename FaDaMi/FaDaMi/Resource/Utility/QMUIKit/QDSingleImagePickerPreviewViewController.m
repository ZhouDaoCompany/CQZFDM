//
//  QDSingleImagePickerPreviewViewController.m
//  qmuidemo
//
//  Created by Kayo Lee on 15/5/17.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDSingleImagePickerPreviewViewController.h"

@implementation QDSingleImagePickerPreviewViewController {
    
    QMUIButton *_confirmButton;
    
}

@dynamic delegate;

- (void)initSubviews {
    [super initSubviews];
    
    
    _confirmButton = [[QMUIButton alloc] init];
    _confirmButton.qmui_outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
    [_confirmButton setTitleColor:self.toolBarTintColor forState:UIControlStateNormal];
    [_confirmButton setTitle:@"选取" forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(handleUserAvatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton sizeToFit];
    _confirmButton.titleLabel.font = Font_14;
    [self.topToolBarView addSubview:_confirmButton];
}

- (void)setDownloadStatus:(QMUIAssetDownloadStatus)downloadStatus {
    [super setDownloadStatus:downloadStatus];
    switch (downloadStatus) {
        case QMUIAssetDownloadStatusSucceed:
            _confirmButton.hidden = NO;
            break;
            
        case QMUIAssetDownloadStatusDownloading:
            _confirmButton.hidden = YES;
            break;
            
        case QMUIAssetDownloadStatusCanceled:
            _confirmButton.hidden = NO;
            break;
            
        case QMUIAssetDownloadStatusFailed:
            _confirmButton.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.topToolBarView setFrame:CGRectMake(0, SCREENHEIGHT - 64, SCREENWIDTH, 64)];
    _confirmButton.frame = CGRectSetXY(_confirmButton.frame, CGRectGetWidth(self.topToolBarView.frame) - CGRectGetWidth(_confirmButton.frame) - 10, CGRectGetMinY(self.backButton.frame) + CGFloatGetCenter(CGRectGetHeight(self.backButton.frame), CGRectGetHeight(_confirmButton.frame)));
    
    [self.backButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.backButton setTitle:@"取消" forState:UIControlStateHighlighted];

    [self.backButton setTitleColor:self.toolBarTintColor forState:UIControlStateNormal];
    [self.backButton setTitleColor:self.toolBarTintColor forState:UIControlStateHighlighted];
    [self.backButton setTitleColor:self.toolBarTintColor forState:UIControlStateSelected];
    self.backButton.titleLabel.font = Font_14;

    [self.backButton sizeToFit];

    [self.backButton setImage:nil forState:UIControlStateNormal];
    [self.backButton setImage:nil forState:UIControlStateHighlighted];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleUserAvatarButtonClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:didSelectImageWithImagesAsset:)]) {
            QMUIAsset *imageAsset = [self.imagesAssetArray objectAtIndex:self.imagePreviewView.currentImageIndex];
            [self.delegate imagePickerPreviewViewController:self didSelectImageWithImagesAsset:imageAsset];
        }
    }];
}

@end
