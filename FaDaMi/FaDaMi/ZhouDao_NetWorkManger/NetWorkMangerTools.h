//
//  NetWorkMangerTools.h
//  FaDaMi
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkMangerTools : NSObject

//MARK: 第三方登录
/**
 *  1 第三方授权后判断是否已经绑定手机号
 */
+ (void)LoginWithThirdPlatformwithPlatform:(NSString *)platform
                                  withUsid:(NSString *)usid
                             withURLString:(NSString *)urlString
                            RequestSuccess:(void (^)(NSString *state, id obj))success;
/**
 *  2 单纯验证账号是否绑定过
 */
+ (void)whetherAccountBindingOnImmediatelyWithURLString:(NSString *)urlString
                                         RequestSuccess:(void (^)())success;
/**
 *  3 解绑账号
 */
+ (void)UnboundAccountwithURLString:(NSString *)urlString
                     RequestSuccess:(void (^)())success
                               fail:(void (^)())fail;

/**
 *  4 绑定账号
 */
+ (void)auBindingwithPlatform:(NSString *)platform
                     withUsid:(NSString *)usid
                withURLString:(NSString *)urlString
               RequestSuccess:(void (^)())success
                         fail:(void (^)())fail;
/**
 *  5 单纯绑定账号 不登录
 */

+ (void)pureAuBindingURLString:(NSString *)urlString
                RequestSuccess:(void (^)())success
                          fail:(void (^)())fail;


/**
 *  6 登录
 */
+ (void)loginEventURLString:(NSString *)urlString
             RequestSuccess:(void (^)())success;


/*
 *7 验证手机号是否注册
 */
+ (void)validationPhoneNumber:(NSString *)phone
               RequestSuccess:(void(^)())success
                         fail:(void (^)(NSString *msg))fail;
/*
 *8 更改手机号
 */
+ (void)resetPhoneNumber:(NSString *)phone
          RequestSuccess:(void (^)())success;
/*
 *9 意见反馈
 */
+ (void)feedBackWithImage:(UIImage *)image
                withPhone:(NSString *)phone
              withContent:(NSString *)contentStr
           RequestSuccess:(void(^)())success;
/*
 *10 获取上传图片的token
 */
+ (void)getQiNiuToken:(BOOL)isPrivate
       RequestSuccess:(void(^)())success;
/*
 *11 获取用户擅长领域
 */
+ (void)getUserDomainRequestSuccess:(void(^)(NSArray *arr))success;

/*
 *13 获取用户认证信息
 */
+ (void)getApplyInfoRequestSuccess:(void(^)())success;
/*
 *14 修改用户职业
 */
+ (void)resetUserJobInfo:(NSString *)type
          RequestSuccess:(void(^)())success;
/*
 *15 更改通讯地址
 */
+ (void)resetUserAddress:(NSString *)address
          RequestSuccess:(void(^)())success;
/*
 *16 上传用户头像
 */
+ (void)uploadUserHeadImg:(UIImage *)image
           RequestSuccess:(void(^)())success
                     fail:(void (^)())fail;

/**
 17 分享计算结果
 
 @param urlString urlString
 @param success   成功回调
 @param fail      失败回调
 */
+ (void)shareTheResultsWithDictionary:(NSDictionary *)dictionary
                       RequestSuccess:(void (^)(NSString *urlString,NSString *idString))success
                                 fail:(void (^)())fail;
/**
 * 18 首页全部
 */
+ (void)homeViewAllDataRequestSuccess:(void (^)(NSArray *hdArr,NSArray *hotArr))success fail:(void (^)())fail;
/**
 * 19 首页更多
 */
+ (void)loadMoreDataHomePage:(NSString *)url
              RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail;
/**
 * 20 便签 列表
 */
+ (void)loadNoteTheListWithURLString:(NSString *)urlString
              RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail;



//MARK: 自动登录
+ (void)theAutomaticLoginEvent;

//MARK: 通用get
+ (void)generalGetURLString:(NSString *)urlString
             RequestSuccess:(void (^)())success
                       fail:(void (^)())fail;

//MARK: 通用post
+ (void)generalPostURLString:(NSString *)urlString
              WithDictionary:(NSDictionary *)paraDict
             RequestSuccess:(void (^)())success
                       fail:(void (^)())fail;


//MARK: 通用判断
+ (void)getResponseObjectCommonMethods:(id)response
                           withsuccess:(void (^)())success                        fail:(void (^)())fail;

+ (void)getResponseObjectShowMsgCommonMethods:(id)response
                                  withsuccess:(void (^)())success                        fail:(void (^)())fail;

//判断铃音
+ (NSString *)getSoundName:(NSString *)bell;
//下载格式
+ (NSString *)getFileFormat:(NSString *)idString;
//沙盒文件是否
+ (NSString *)whetheFileExists:(NSString *)caseId;
//文件夹是否已经存在
+ (void)creatFilePathEvent:(NSString *)filePath;
@end
