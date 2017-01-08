//
//  QZAlbumHelperView.m
//  FaDaMi
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年 CQZ. All rights reserved.
//

#import "QZAlbumHelperView.h"
#import "QDMultipleImagePickerPreviewViewController.h"
#import "QDSingleImagePickerPreviewViewController.h"

static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeOnlyPhoto;
#define MultipleImagePickingTag 1047
#define SingleImagePickingTag 1048

@interface QZAlbumHelperView () <QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,QDMultipleImagePickerPreviewViewControllerDelegate,QDSingleImagePickerPreviewViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation QZAlbumHelperView

- (instancetype)initWithSelectTypePhotosWithSelectType:(ImageSelectType)type
                              withFatherViewController:(UIViewController *)fatherViewController {
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _type = type;
        _delegate = (id)fatherViewController;
        _fatherViewController = fatherViewController;
        [self initUI];
    }
    return self;
}
#pragma mark - methods
- (void)initUI {
    
    if (_type == CameraImageType) {
        
        [self initCameraStyle];
    } else {
        
        [self initAlbumStyle];
    }
}
#pragma mark - 相机
- (void)initCameraStyle { WEAKSELF
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            imagePickerController.showsCameraControls = YES;//是否显示照相机标准的控件库
            [imagePickerController setAllowsEditing:YES];//是否加入照相后预览时的编辑功能
            kDISPATCH_MAIN_THREAD(^{
                
                [weakSelf.fatherViewController presentViewController:imagePickerController animated:YES completion:nil];
            });
        });
    } else {
        SHOW_ALERT(@"模拟其中无法打开照相机,请在真机中使用");
        [self removeFromSuperview];
    }
}
#pragma mark - 相册选择
- (void)initAlbumStyle {
    
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = kAlbumContentType;
    
    if (_type == SingleImageType) {
        albumViewController.view.tag = SingleImagePickingTag;
    } else {
        albumViewController.view.tag = MultipleImagePickingTag;
    }
    albumViewController.albumTableViewCellHeight = 85;
    QMUINavigationController *navigationController = [[QMUINavigationController alloc] initWithRootViewController:albumViewController];

    /**
     *  requestAuthorization:(void(^)(QMUIAssetAuthorizationStatus status))handler 不在主线程执行，
     *  因此 UI 相关的操作强制放在主流程执行。
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.fatherViewController presentViewController:navigationController animated:YES completion:NULL];
    });
}
#pragma mark - <QMUIAlbumViewControllerDelegate>

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = _limitNum;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    if (albumViewController.view.tag == SingleImagePickingTag) {
        imagePickerViewController.allowsMultipleSelection = NO;
    }
        imagePickerViewController.minimumImageWidth = (SCREENWIDTH/4.f - 5.f);
    return imagePickerViewController;
}
- (void)albumViewControllerDidCancel:(QMUIAlbumViewController *)albumViewController {
    
    [self removeFromSuperview];
}
- (void)imagePickerViewControllerDidCancel:(QMUIImagePickerViewController *)imagePickerViewController {
    
    [self removeFromSuperview];
}
#pragma mark - <QMUIImagePickerViewControllerDelegate>
- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    
    if ([self.delegate respondsToSelector:@selector(sendMutipleImage:)]) {
        
        [self.delegate sendMutipleImage:imagesAssetArray];
    }
    
    [self removeFromSuperview];
}

- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
    if (imagePickerViewController.view.tag == MultipleImagePickingTag) {
        QDMultipleImagePickerPreviewViewController *imagePickerPreviewViewController = [[QDMultipleImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.maximumSelectImageCount = _limitNum;
        imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    } else {
        QDSingleImagePickerPreviewViewController *imagePickerPreviewViewController = [[QDSingleImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    }
}
#pragma mark - <QMUIImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(QMUIImagePickerPreviewViewController *)imagePickerPreviewViewController didCheckImageAtIndex:(NSInteger)index {
    if (imagePickerPreviewViewController.view.tag == MultipleImagePickingTag) {
        // 在预览界面选择图片时，控制显示当前所选的图片，并且展示动画
        QDMultipleImagePickerPreviewViewController *customImagePickerPreviewViewController = (QDMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController;
        NSUInteger selectedCount = [imagePickerPreviewViewController.selectedImageAssetArray count];
        if (selectedCount > 0) {
            customImagePickerPreviewViewController.imageCountLabel.text = [[NSString alloc] initWithFormat:@"%ld", (long)selectedCount];
            customImagePickerPreviewViewController.imageCountLabel.hidden = NO;
            [QMUIImagePickerHelper springAnimationOfImageSelectedCountChangeWithCountLabel:customImagePickerPreviewViewController.imageCountLabel];
        } else {
            customImagePickerPreviewViewController.imageCountLabel.hidden = YES;
        }
    }
}

#pragma mark - <QDMultipleImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(QDMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    
    if ([self.delegate respondsToSelector:@selector(sendMutipleImage:)]) {
        
        [self.delegate sendMutipleImage:imagesAssetArray];
    }

    [self removeFromSuperview];
}

#pragma mark - <QDSingleImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(QDSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset {
    
    if ([self.delegate respondsToSelector:@selector(sendSingleImage:)]) {
        
        [self.delegate sendSingleImage:imageAsset.originImage];
    }
    [self removeFromSuperview];
}

#pragma mark - cameraPhotoDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{ WEAKSELF
    
    [self.fatherViewController dismissViewControllerAnimated:YES completion:^{
        [weakSelf removeFromSuperview];
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info { WEAKSELF
    
    [self.fatherViewController dismissViewControllerAnimated:YES completion:^{
        //打印出字典中的内容
        //DMLog( info );
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:@"public.image"]) {//UIImagePickerControllerOriginalImage UIImagePickerControllerEditedImage
            UIImage* getImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"]; // 裁剪后的图片
            kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
                
                UIImageWriteToSavedPhotosAlbum(getImage, nil, nil, nil);//保存相册
            });
            
            if ([weakSelf.delegate respondsToSelector:@selector(sendCameraImage:)]) {
                
                [weakSelf.delegate sendCameraImage:getImage];
            }
            [weakSelf removeFromSuperview];
            
        }
    }];
}


@end
