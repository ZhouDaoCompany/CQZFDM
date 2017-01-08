//
//  QZAlbumHelperView.h
//  FaDaMi
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol QZAlbumHelperViewPro;

typedef NS_ENUM(NSUInteger, ImageSelectType){
    
    SingleImageType   = 0,//单张
    MultipleImageType = 1,//多张
    CameraImageType   = 2,//相机
};

@interface QZAlbumHelperView : UIView

@property (nonatomic, strong) UIViewController *fatherViewController;
@property (nonatomic, weak) id<QZAlbumHelperViewPro>delegate;
@property (nonatomic, assign) ImageSelectType type;
@property (nonatomic, assign) NSUInteger limitNum;//限制选择张数，不设置(<1)即不限制

- (instancetype)initWithSelectTypePhotosWithSelectType:(ImageSelectType)type
                              withFatherViewController:(UIViewController *)fatherViewController;

@end

@protocol QZAlbumHelperViewPro <NSObject>

@optional
- (void)sendCameraImage:(UIImage *)cameraImage;
- (void)sendSingleImage:(UIImage *)singleImage;
- (void)sendMutipleImage:(NSArray *)multipleImgArrays;
@end
