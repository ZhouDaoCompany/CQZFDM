//
//  HomeModel.m
//  FaDaMi
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
@synthesize id = _id;
@synthesize title = _title;
@synthesize slide_id = _slide_id;
@synthesize slide_name = _slide_name;
@synthesize slide_pic = _slide_pic;
@synthesize slide_url = _slide_url;
@synthesize pic = _pic;
@synthesize content = _content;



-(id)initWithDictionary:(NSDictionary*)dict {
    
    if (self = [super init]) {
        
        DTAPI_DICT_ASSIGN_STRING(id, @"");
        DTAPI_DICT_ASSIGN_STRING(title, @"");
        DTAPI_DICT_ASSIGN_STRING(pic, @"");
        DTAPI_DICT_ASSIGN_STRING(content, @"");

        
        DTAPI_DICT_ASSIGN_STRING(slide_id, @"");
        DTAPI_DICT_ASSIGN_STRING(slide_name, @"");
        DTAPI_DICT_ASSIGN_STRING(slide_pic, @"");
        DTAPI_DICT_ASSIGN_STRING(slide_url, @"");
        
    }
    return self;
}

-(NSDictionary*)dictionaryValue {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    DTAPI_DICT_EXPORT_BASICTYPE(id);
    DTAPI_DICT_EXPORT_BASICTYPE(title);
    DTAPI_DICT_EXPORT_BASICTYPE(pic);
    DTAPI_DICT_EXPORT_BASICTYPE(content);

    DTAPI_DICT_EXPORT_BASICTYPE(slide_id);
    DTAPI_DICT_EXPORT_BASICTYPE(slide_name);
    DTAPI_DICT_EXPORT_BASICTYPE(slide_pic);
    DTAPI_DICT_EXPORT_BASICTYPE(slide_url);
    
    return md;
}

@end
