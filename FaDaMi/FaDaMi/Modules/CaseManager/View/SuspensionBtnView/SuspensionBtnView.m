//
//  SuspensionBtnView.m
//  GovermentTest
//
//  Created by apple on 16/12/19.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SuspensionBtnView.h"

typedef enum : NSUInteger {
    
    left_suspension = 1,
    right_suspension,
    top_suspension,
    bottom_suspension,
} suspensionPoint;

@interface SuspensionBtnView() <UIDynamicAnimatorDelegate>

@property (nonatomic, strong) UIImageView *btnImageView;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, assign) CGPoint           startPoint;
@property (nonatomic, assign) CGPoint           endPoint;
@property (nonatomic, assign) CGPoint           subBtnstartPoint;
@property (nonatomic, assign) CGPoint           subBtnendPoint;
@property (nonatomic, assign) CGFloat           kNavHeight;
@property (nonatomic, assign) CGFloat           kBgWidth;
@property (nonatomic, assign) CGFloat           kImgWidth;
@property (nonatomic, assign) CGFloat           kOffSet;
@property (nonatomic, assign) suspensionPoint   btnPoint;


@end

@implementation SuspensionBtnView
- (instancetype)initWithFrame:(CGRect)frame
                withImageName:(NSString *)imageName {
    
    self  = [super initWithFrame:frame];
    
    if (self) {
        
        [self setDefaultData:frame];
        //初始化子视图
        [self initSubViewWithImageName:imageName];
        //        // 呼吸动画
        //        [self hightBgView];
    }
    return self;
}

- (void)setImageNameSelector:(NSString *)imageName {
    
    _btnImageView.image = kGetImage(imageName);
    
}
- (void)setDefaultData:(CGRect)frame {
    // 初始默认左边
    _btnPoint   = left_suspension;
    _kNavHeight = 84;//frame.origin.y;
    _kBgWidth   = frame.size.width;
    _kImgWidth  = frame.size.width - 10.0;
    _kOffSet    = _kBgWidth/2.0;
}

- (void)initSubViewWithImageName:(NSString *)imageName { WEAKSELF;
    
    [self addSubview:self.btnImageView];
    _btnImageView.image = [UIImage imageNamed:imageName];
    
    
    [self whenCancelTapped:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(clickSuspensionButtonEvent)]) {
            
            [weakSelf.delegate clickSuspensionButtonEvent];
        }
    }];
}
#pragma mark - DynamicAnimator
- (UIDynamicAnimator*)animator {
    if (!_animator) {
        
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
        
        _animator.delegate = self;
    }
    return _animator;
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    
}

#pragma mark - touch_breathe
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *startTouch = [touches anyObject];
    
    self.startPoint = [startTouch locationInView:self.superview];
    
    [self.animator removeAllBehaviors];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *moveTouch = [touches anyObject];
    
    self.center = [moveTouch locationInView:self.superview];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *endTouch = [touches anyObject];
    
    self.endPoint = [endTouch locationInView:self.superview];
    
    CGFloat permitRange = 6.0;
    
    CGFloat RangX = fabs(self.endPoint.x - self.startPoint.x);
    CGFloat RangY = fabs(self.endPoint.y - self.startPoint.y);
    
    if (!(RangX < permitRange && RangY < permitRange)) {
        
        self.center = self.endPoint;
        
        CGFloat superViewWidth = CGRectGetWidth(self.superview.frame);
        CGFloat superViewHeight= CGRectGetHeight(self.superview.frame);
        CGFloat endX = self.endPoint.x;
        CGFloat endY = self.endPoint.y;
        
        CGFloat topDistance     = endY;
        CGFloat bottomDistance  = superViewHeight - endY;
        CGFloat leftDistance    = endX;
        CGFloat rightDistance   = superViewWidth - endX;
        
        CGFloat verticalMinDistance    = MIN(topDistance, bottomDistance);
        CGFloat horizontalMinDistance  = MIN(leftDistance, rightDistance);
        CGFloat edgeMinDistance        = MIN(verticalMinDistance, horizontalMinDistance);
        
        CGPoint minPoint;
        
        if (edgeMinDistance == topDistance) {
            
            // 按钮边界超出左边缘时
            endX = MAX(_kOffSet, endX);
            
            // 按钮边界超出右边缘时
            endX = endX + _kOffSet > superViewWidth ? superViewWidth - _kOffSet : endX;
            
            minPoint = CGPointMake(endX , _kNavHeight + _kOffSet);
            
            _btnPoint = top_suspension;
            
        }else if (edgeMinDistance == bottomDistance) {
            
            // 按钮边界超出左边缘时
            endX = MAX(_kOffSet, endX);
            
            // 按钮边界超出右边缘时
            endX = endX + _kOffSet > superViewWidth ? superViewWidth - _kOffSet : endX;
            
            minPoint = CGPointMake(endX , superViewHeight - _kOffSet);
            
            _btnPoint = bottom_suspension;
            
        }else if (edgeMinDistance == leftDistance) {
            
            // 按钮边界超出上边缘时
            endY = MAX(endY, _kOffSet + _kNavHeight);
            
            // 按钮边界超出下边缘时
            endY = endY + _kOffSet > superViewHeight ? superViewHeight - _kOffSet : endY;
            
            minPoint = CGPointMake(_kOffSet , endY);
            
            _btnPoint = left_suspension;
            
        }else if (edgeMinDistance == rightDistance) {
            
            // 按钮边界超出上边缘时
            endY = MAX(endY, _kOffSet + _kNavHeight);
            
            // 按钮边界超出下边缘时
            endY = endY + _kOffSet > superViewHeight ? superViewHeight - _kOffSet : endY;
            
            minPoint = CGPointMake(superViewWidth - _kOffSet, endY);
            
            _btnPoint = right_suspension;
            
        }else {
            
            DLog(@"出错了");
        }
        
        //添加吸附物理行为
        
        UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self attachedToAnchor:minPoint];
        
        [attachmentBehavior setLength:0];
        
        [attachmentBehavior setDamping:0.3];
        
        [attachmentBehavior setFrequency:3];
        
        [self.animator addBehavior:attachmentBehavior];
    }
}

//#pragma mark - breatheAnimation
//- (void)hightBgView {
//    [UIView animateWithDuration:1 animations:^{
//
//        self.backgroundView.backgroundColor = [self.backgroundView.backgroundColor colorWithAlphaComponent:0.1f];
//
//    } completion:^(BOOL finished) {
//
//        [self darkBgView];
//    }];
//}
//
//- (void)darkBgView {
//    [UIView animateWithDuration:1 animations:^{
//
//        self.backgroundView.backgroundColor = [self.backgroundView.backgroundColor colorWithAlphaComponent:0.7f];
//
//    } completion:^(BOOL finished) {
//
//        [self hightBgView];
//    }];
//}

#pragma mark - setter and getter
- (UIImageView *)btnImageView {
    
    if (!_btnImageView) {
        
        _btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _kImgWidth, _kImgWidth)];
        _btnImageView.backgroundColor = [UIColor clearColor];
        _btnImageView.userInteractionEnabled = YES;
    }
    return _btnImageView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
