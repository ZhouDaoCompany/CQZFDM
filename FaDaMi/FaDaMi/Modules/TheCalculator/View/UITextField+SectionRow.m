//
//  UITextField+SectionRow.m
//  FaDaMi
//
//  Created by apple on 16/12/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "UITextField+SectionRow.h"
#import <objc/runtime.h>

@implementation UITextField (SectionRow)

- (NSInteger)row {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
-(NSInteger)section {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setRow:(NSInteger)row {
    objc_setAssociatedObject(self, @selector(row), @(row), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setSection:(NSInteger)section {
    objc_setAssociatedObject(self, @selector(section), @(section), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
