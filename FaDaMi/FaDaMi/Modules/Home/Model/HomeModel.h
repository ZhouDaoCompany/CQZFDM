//
//  HomeModel.h
//  FaDaMi
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"

@interface HomeModel : NSObject {
    
    //幻灯片 焦点图片
    NSString *_slide_id;
    NSString *_slide_name;
    NSString *_slide_pic;
    NSString *_slide_url;
    
    //实事热点、
    NSString *_id;
    NSString *_title;
    NSString *_pic;
    NSString *_content;
}

@property (nonatomic, copy) NSString *slide_id;
@property (nonatomic, copy) NSString *slide_name;
@property (nonatomic, copy) NSString *slide_pic;
@property (nonatomic, copy) NSString *slide_url;

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *content;


-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;

@end
