//
//  NetWorkMangerTools.m
//  FaDaMi
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "NetWorkMangerTools.h"
#import "UMessage.h"
#import "QiniuUploader.h"
//擅长领域
#import "AdvantagesModel.h"
#import "HomeModel.h"

@implementation NetWorkMangerTools

#pragma mark - 1 第三方授权后判断是否已经绑定手机号
+ (void)LoginWithThirdPlatformwithPlatform:(NSString *)platform
                                  withUsid:(NSString *)usid
                             withURLString:(NSString *)urlString
                            RequestSuccess:(void (^)(NSString *state, id obj))success {
    
    [MBProgressHUD showMBLoadingWithText:nil];
    [ZhouDao_NetWorkManger getWithUrl:urlString sg_cache:NO success:^(id response) {
        
        [MBProgressHUD hideHUD];
        NSDictionary *jsonDic = (NSDictionary *)response;
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *stateCode = [NSString stringWithFormat:@"%@",jsonDic[@"state"]];
        if (errorcode !=1) {
            success(stateCode,nil);
            return ;
        }
        UserModel *model =[[UserModel alloc] initWithDictionary:jsonDic];
        [PublicFunction ShareInstance].m_user = model;
        [PublicFunction ShareInstance].m_bLogin = YES;
        
        //存储登录方式
        [USER_D setObject:platform forKey:StorageTYPE];
        [USER_D setObject:usid forKey:StorageUSID];
        [USER_D synchronize];
        [UMessage setAlias:[NSString stringWithFormat:@"uid_%@",UID] type:@"ZDHF" response:^(id responseObject, NSError *error) {
            
            DLog(@"添加成功-----%@",responseObject);
        }];
        [UMessage addTag:[NSString stringWithFormat:@"type_%@",[PublicFunction ShareInstance].m_user.data.type]
                response:^(id responseObject, NSInteger remain, NSError *error) {
                    DLog(@"添加标签成功-----%@",responseObject);
                }];
        
        success(stateCode,model);
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}
#pragma mark -2 单纯验证账号是否绑定过
+ (void)whetherAccountBindingOnImmediatelyWithURLString:(NSString *)urlString
                                         RequestSuccess:(void (^)())success {
    
    [MBProgressHUD showMBLoadingWithText:nil];
    [ZhouDao_NetWorkManger getWithUrl:urlString sg_cache:NO success:^(id response) {
        
        [MBProgressHUD hideHUD];
        NSDictionary *jsonDic = (NSDictionary *)response;
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        if (errorcode !=1) {
            success();
            return ;
        }
        [JKPromptView showWithImageName:nil message:jsonDic[@"info"]];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}
#pragma mark - 3 解绑账号
+ (void)UnboundAccountwithURLString:(NSString *)urlString
                     RequestSuccess:(void (^)())success
                               fail:(void (^)())fail {
    
    [MBProgressHUD showMBLoadingWithText:nil];
    [ZhouDao_NetWorkManger getWithUrl:urlString sg_cache:NO success:^(id response) {
        
        [MBProgressHUD hideHUD];
        NSDictionary *jsonDic = (NSDictionary *)response;
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        [JKPromptView showWithImageName:nil message:jsonDic[@"info"]];
        if (errorcode !=1) {
            fail();
            return ;
        }
        [USER_D removeObjectForKey:StorageTYPE];
        [USER_D removeObjectForKey:StorageUSID];
        [USER_D synchronize];
        success();
    } fail:^(NSError *error) {
        fail();
        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}
#pragma mark -4 绑定账号
+ (void)auBindingwithPlatform:(NSString *)platform
                     withUsid:(NSString *)usid
                withURLString:(NSString *)urlString
               RequestSuccess:(void (^)())success
                         fail:(void (^)())fail {
    [MBProgressHUD showMBLoadingWithText:nil];
    [ZhouDao_NetWorkManger getWithUrl:urlString sg_cache:NO success:^(id response) {
        
        [MBProgressHUD hideHUD];
        NSDictionary *jsonDic = (NSDictionary *)response;
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        [JKPromptView showWithImageName:nil message:jsonDic[@"info"]];
        if (errorcode !=1) {
            fail();
            return ;
        }
        UserModel *model =[[UserModel alloc] initWithDictionary:jsonDic];
        [PublicFunction ShareInstance].m_user = model;
        [PublicFunction ShareInstance].m_bLogin = YES;
        
        //存储登录方式
        [USER_D setObject:platform forKey:StorageTYPE];
        [USER_D setObject:usid forKey:StorageUSID];
        //        [USER_D removeObjectForKey:StoragePhone];
        //        [USER_D removeObjectForKey:StoragePassword];
        
        [USER_D synchronize];
        
        [UMessage setAlias:[NSString stringWithFormat:@"uid_%@",UID] type:@"ZDHF" response:^(id responseObject, NSError *error) {
            
            DLog(@"添加成功-----%@",responseObject);
        }];
        [UMessage addTag:[NSString stringWithFormat:@"type_%@",[PublicFunction ShareInstance].m_user.data.type]
                response:^(id responseObject, NSInteger remain, NSError *error) {
                    DLog(@"添加标签成功-----%@",responseObject);
                }];
        
        success();
    } fail:^(NSError *error) {
        fail();
        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}
#pragma mark -5 单纯绑定账号 不登录
+ (void)pureAuBindingURLString:(NSString *)urlString
                RequestSuccess:(void (^)())success
                          fail:(void (^)())fail {
    [MBProgressHUD showMBLoadingWithText:nil];
    [ZhouDao_NetWorkManger getWithUrl:urlString sg_cache:NO success:^(id response) {
        
        [MBProgressHUD hideHUD];
        NSDictionary *jsonDic = (NSDictionary *)response;
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:jsonDic[@"info"]];
            fail();
            return ;
        }
        success();
    } fail:^(NSError *error) {
        fail();
        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}

//MARK: 登录
+ (void)loginEventURLString:(NSString *)urlString
             RequestSuccess:(void (^)())success {
    
    [MBProgressHUD showMBLoadingWithText:@"登录中..."];
    [ZhouDao_NetWorkManger getWithUrl:urlString sg_cache:NO success:^(id response) {
        
        [MBProgressHUD hideHUD];
        NSDictionary *jsonDic = (NSDictionary *)response;
        [[self class] getResponseObjectShowMsgCommonMethods:response withsuccess:^{
            
            UserModel *model =[[UserModel alloc] initWithDictionary:jsonDic];
            [PublicFunction ShareInstance].m_user = model;
            [PublicFunction ShareInstance].m_bLogin = YES;
            
            // 给设备打上标签 和别名
            //                [UMessage addAlias:@"22222" type:@"ZDHF" response:^(id responseObject, NSError *error) {
            //                    DLog(@"888-----%@",responseObject);
            //                }];
            
            [UMessage setAlias:[NSString stringWithFormat:@"uid_%@",UID] type:@"ZDHF" response:^(id responseObject, NSError *error) {
                
                DLog(@"添加成功-----%@",responseObject);
            }];
            [UMessage addTag:[NSString stringWithFormat:@"type_%@",[PublicFunction ShareInstance].m_user.data.type]
                    response:^(id responseObject, NSInteger remain, NSError *error) {
                        DLog(@"添加标签成功-----%@",responseObject);
                    }];
            
            //                [NetWorkMangerTools getaWekRemindsRequestSuccess:^{
            //
            //                }];
            
            success();
        } fail:^{
        }];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:LOCERROEMESSAGE];
    }];

}
//MARK: 验证手机号是否注册
+ (void)validationPhoneNumber:(NSString *)phone
               RequestSuccess:(void(^)())success
                         fail:(void (^)(NSString *msg))fail {
    //发个请求验证手机号码
    NSString *phoneUrl = [NSString stringWithFormat:@"%@%@mobile=%@",kProjectBaseUrl,VerifyTheMobile,phone];
    [ZhouDao_NetWorkManger getWithUrl:phoneUrl sg_cache:NO success:^(id response) {
        
        NSDictionary *jsonDic = (NSDictionary *)response;
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail(msg);
        }else {
            success();
        }
    } fail:^(NSError *error) {
    }];
}
#pragma mark -更改手机号
+ (void)resetPhoneNumber:(NSString *)phone RequestSuccess:(void (^)())success { WEAKSELF
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&oldMobile=%@&NewMobile=%@",kProjectBaseUrl,ResetMobile,UID,[PublicFunction ShareInstance].m_user.data.mobile,phone];
    
    [ZhouDao_NetWorkManger getWithUrl:url sg_cache:NO success:^(id response) {
        
        [[weakSelf class] getResponseObjectShowMsgCommonMethods:response withsuccess:^{
            [PublicFunction ShareInstance].m_user.data.mobile = phone;
            success();
        } fail:^{
        }];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark -意见反馈
+ (void)feedBackWithImage:(UIImage *)image withPhone:(NSString *)phone withContent:(NSString *)contentStr RequestSuccess:(void(^)())success { WEAKSELF
    [MBProgressHUD showMBLoadingWithText:nil];
    if (!image) {
        
        if (contentStr.length== 0) {
            [JKPromptView showWithImageName:nil message:@"请您填写内容，或者选择图片!"];
            return;
        }
        NSString *url = [NSString stringWithFormat:@"%@%@mobile=%@&content=%@",kProjectBaseUrl,FeedBackAdd,phone,contentStr];
        [ZhouDao_NetWorkManger getWithUrl:url sg_cache:NO success:^(id response) {
            
            [[weakSelf class] getResponseObjectShowMsgCommonMethods:response withsuccess:^{
                success();
            } fail:^{
            }];
        } fail:^(NSError *error) {
            
            [MBProgressHUD hideHUD];
            [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
        }];
        
    }else{
        
        if (contentStr.length == 0) {
            contentStr = @"用户未填写内容";
        }
        QiniuFile *file = [[QiniuFile alloc] initWithFileData:UIImageJPEGRepresentation(image, .5f)];
        QiniuUploader *uploader = [[QiniuUploader alloc] init];
        [uploader addFile:file];
        [uploader setUploadOneFileProgress:^(NSInteger index,NSProgress *process){
            
            [JKPromptView showWithImageName:nil message:@"图片上传失败"];
            [MBProgressHUD hideHUD];
        }];
        __block int index = 0;
        [uploader setUploadAllFilesComplete:^(void){
            DLog(@"complete");
            if (index == 0) {
                NSString *urls = [NSString stringWithFormat:@"%@%@mobile=%@&content=%@&file=%@",kProjectBaseUrl,FeedBackAdd,phone,contentStr,[PublicFunction ShareInstance].qiniuKey];
                [ZhouDao_NetWorkManger getWithUrl:urls sg_cache:NO success:^(id response) {
                    
                    [[weakSelf class] getResponseObjectShowMsgCommonMethods:response withsuccess:^{
                        success();
                    } fail:^{
                    }];
                } fail:^(NSError *error) {
                    
                    [MBProgressHUD hideHUD];
                    [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
                }];
            }
            index ++;
        }];
        
        [uploader setUploadOneFileSucceeded:^(NSInteger index, NSString *key, NSDictionary *info){
            
            DLog(@"index:%ld key:%@",(long)index,key);
            [PublicFunction ShareInstance].qiniuKey = key;
        }];
        [uploader startUploadWithAccessToken:[PublicFunction ShareInstance].picToken];
    }
}
#pragma mark -获取上传图片的token
+ (void)getQiNiuToken:(BOOL)isPrivate RequestSuccess:(void(^)())success { WEAKSELF
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *url = (isPrivate == YES) ? [NSString stringWithFormat:@"%@%@&t=2",kProjectBaseUrl,UploadPicToken] : [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,UploadPicToken];
    [ZhouDao_NetWorkManger getWithUrl:url sg_cache:NO success:^(id response) {
        
        [[weakSelf class] getResponseObjectCommonMethods:response withsuccess:^{
            
            NSDictionary *jsonDic = (NSDictionary *)response;
            [PublicFunction ShareInstance].picToken = jsonDic[@"data"];
            success();
        } fail:^{
        }];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}
#pragma mark -获取用户擅长领域 
+ (void)getUserDomainRequestSuccess:(void(^)(NSArray *arr))success {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *userUrl = [NSString  stringWithFormat:@"%@%@uid=%@",kProjectBaseUrl,DomainUser,UID];
        [ZhouDao_NetWorkManger getWithUrl:userUrl sg_cache:NO success:^(id response) {
            
            NSDictionary *jsonDic = (NSDictionary *)response;
            NSUInteger errorcode = [jsonDic[@"state"] integerValue];
            if (errorcode !=1) {
                return ;
            }
            NSDictionary *dataDic = jsonDic[@"data"];
            
            NSArray *ValuesArr  = [dataDic allValues];
            __block NSMutableArray *domainArrays = [NSMutableArray array];
            
            [ValuesArr enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (![obj isEqual:[NSNull null]]) {
                        AdvantagesModel *model = [[AdvantagesModel alloc] initWithDictionary:obj];
                        [domainArrays addObject:model];
                    }
                }];
            }];
            success(domainArrays);
            
        } fail:^(NSError *error) {
        }];
    });
}
#pragma mark -获取用户认证信息
+ (void)getApplyInfoRequestSuccess:(void(^)())success {
    /**
     *  0 未添加认证信息
     *  1 审核中
     *  2 认证成功
     *  3 认证失败
     */
    
    NSString *infoUrl = [NSString  stringWithFormat:@"%@%@uid=%@",kProjectBaseUrl,ApplyInfo,UID];
    [ZhouDao_NetWorkManger getWithUrl:infoUrl sg_cache:NO success:^(id response) {
        
        NSDictionary *jsonDic = (NSDictionary *)response;
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode == 1 || errorcode ==2 || errorcode ==0) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        success();
    } fail:^(NSError *error) {
    }];
}
#pragma mark -修改用户职业
+ (void)resetUserJobInfo:(NSString *)type RequestSuccess:(void(^)())success { WEAKSELF
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *Url = [NSString  stringWithFormat:@"%@%@uid=%@&type=%@",kProjectBaseUrl,UploadJob,UID,type];
    [ZhouDao_NetWorkManger getWithUrl:Url sg_cache:NO success:^(id response) {
        
        [[weakSelf class] getResponseObjectShowMsgCommonMethods:response withsuccess:^{
            [PublicFunction ShareInstance].m_user.data.type = type;
            success();
        } fail:^{
        }];
        
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}

#pragma mark -更改通讯地址
+ (void)resetUserAddress:(NSString *)address RequestSuccess:(void(^)())success { WEAKSELF
    
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *Url = [NSString  stringWithFormat:@"%@%@uid=%@&address=%@",kProjectBaseUrl,UploadUserAddress,UID,address];
    [ZhouDao_NetWorkManger getWithUrl:Url sg_cache:NO success:^(id response) {
        
        [[weakSelf class] getResponseObjectShowMsgCommonMethods:response withsuccess:^{
            [PublicFunction ShareInstance].m_user.data.address = address;
            success();
        } fail:^{
        }];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}
#pragma mark - 上传用户头像
+ (void)uploadUserHeadImg:(UIImage *)image RequestSuccess:(void(^)())success
                     fail:(void (^)())fail {
    
    QiniuFile *file = [[QiniuFile alloc] initWithFileData:UIImageJPEGRepresentation(image, .5f)];
    QiniuUploader *uploader = [[QiniuUploader alloc] init];
    [uploader addFile:file];
    
    [uploader setUploadOneFileFailed:^(NSInteger index, NSError * _Nullable error){
        
        [JKPromptView showWithImageName:nil message:@"上传失败"];
        [MBProgressHUD hideHUD];
    }];
    
    [uploader setUploadAllFilesComplete:^(void){
    }];
    __block int indexCount = 0;
    [uploader setUploadOneFileSucceeded:^(NSInteger index, NSString *key, NSDictionary *info){
        DLog(@"index:%ld key:%@",(long)index,key);
        if (indexCount == 0) {
            NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&pic=%@",kProjectBaseUrl,UploadHeadPic,UID,key];
            [ZhouDao_NetWorkManger getWithUrl:url sg_cache:NO success:^(id response) {
                
                [MBProgressHUD hideHUD];
                NSDictionary *jsonDic = (NSDictionary *)response;
                NSUInteger errorcode = [jsonDic[@"state"] integerValue];
                NSString *msg = jsonDic[@"info"];
                [JKPromptView showWithImageName:nil message:msg];
                if (errorcode !=1) {
                    fail();
                    return ;
                }
                [PublicFunction ShareInstance].m_user.data.photo = jsonDic[@"data"];
                success();
            } fail:^(NSError *error) {
                fail();
                [MBProgressHUD hideHUD];
                [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
            }];
        }
        indexCount ++;
    }];
    
    [uploader startUploadWithAccessToken:[PublicFunction ShareInstance].picToken];
}

#pragma mark - 分享计算结果
+ (void)shareTheResultsWithDictionary:(NSDictionary *)dictionary
                       RequestSuccess:(void (^)(NSString *urlString,NSString *idString))success
                                 fail:(void (^)())fail { WEAKSELF;
    
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,SHARECALCulate];
    [ZhouDao_NetWorkManger postWithUrl:url params:dictionary success:^(id response) {
        
        [[weakSelf class] getResponseObjectCommonMethods:response withsuccess:^{
            
            NSDictionary *jsonDic = (NSDictionary *)response;
            NSString *dataUrlString = jsonDic[@"data"];
            NSString *idString = jsonDic[@"id"];
            success(dataUrlString,idString);
        } fail:^{
        }];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}

#pragma mark - 首页全部
+ (void)homeViewAllDataRequestSuccess:(void (^)(NSArray *hdArr,NSArray *hotArr))success fail:(void (^)())fail {
    
//    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,HomeViewIndexAll];
    [ZhouDao_NetWorkManger getWithUrl:url sg_cache:YES success:^(id response) {
        
//        [MBProgressHUD hideHUD];
        NSDictionary *jsonDic = (NSDictionary *)response;
        NSArray *dataArr = jsonDic[@"data"];
        __block NSMutableArray *arr1 = [NSMutableArray array];
        __block NSMutableArray *arr2 = [NSMutableArray array];
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *objDic, NSUInteger idx, BOOL * _Nonnull stop) {
            [QZManager wrongInformationWithDic:objDic Success:^{
                NSArray *twoDataArr = objDic[@"data"];
                if (idx == 0) {
                    [twoDataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        HomeModel *model = [[HomeModel alloc] initWithDictionary:obj];
                        [arr1 addObject:model];
                    }];
                }else{
                    [twoDataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        HomeModel *model = [[HomeModel alloc] initWithDictionary:obj];
                        [arr2 addObject:model];
                    }];
                }
            }];
        }];
        success(arr1,arr2);
    } fail:^(NSError *error) {
       
        fail();
//        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}

#pragma mark -首页更多
+ (void)loadMoreDataHomePage:(NSString *)url RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail {
//    [MBProgressHUD showMBLoadingWithText:nil];
    [ZhouDao_NetWorkManger getWithUrl:url sg_cache:NO success:^(id response) {
        
//        [MBProgressHUD hideHUD];
        NSDictionary *jsonDic = (NSDictionary *)response;
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *dataArr = jsonDic[@"data"];
        __block NSMutableArray *arr = [NSMutableArray array];
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HomeModel *model = [[HomeModel alloc] initWithDictionary:obj];
            [arr addObject:model];
        }];
        success(arr);
    } fail:^(NSError *error) {
//        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}
#pragma mark - 便签 列表

+ (void)loadNoteTheListWithURLString:(NSString *)urlString
                      RequestSuccess:(void (^)(NSArray *arr))success
                                fail:(void (^)())fail { WEAKSELF

    [ZhouDao_NetWorkManger getWithUrl:urlString sg_cache:NO success:^(id response) {
        
        [[weakSelf class] getResponseObjectCommonMethods:response withsuccess:^{
           
            NSDictionary *jsonDic = (NSDictionary *)response;
            NSMutableArray *dataArrays = jsonDic[@"data"];
            __block NSMutableArray *blockArrays = [NSMutableArray array];
            [dataArrays enumerateObjectsUsingBlock:^(NSDictionary *objDict, NSUInteger idx, BOOL * _Nonnull stop) {
                
                AdvantagesModel *model = [[AdvantagesModel alloc] initWithDictionary:objDict];
                [blockArrays addObject:model];
            }];
            success(blockArrays);
        } fail:^{
            fail();
        }];
    } fail:^(NSError *error) {
        fail();
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}
//MARK: 自动登录
+ (void)theAutomaticLoginEvent { WEAKSELF
    
    NSString *nameString = [USER_D objectForKey:StoragePhone];
    NSString *passWord   = [USER_D objectForKey:StoragePassword];
    NSString *loginType  = [USER_D objectForKey:StorageTYPE];
    NSString *loginUsid  = [USER_D objectForKey:StorageUSID];
    if (nameString.length>0)
    {
        NSString *loginurl = [NSString stringWithFormat:@"%@%@mobile=%@&pw=%@",kProjectBaseUrl,LoginUrlString,nameString,passWord];
        [ZhouDao_NetWorkManger getWithUrl:loginurl sg_cache:NO success:^(id response) {
            
            NSDictionary *jsonDic = (NSDictionary *)response;
            NSUInteger errorcode = [jsonDic[@"state"] integerValue];
            if (errorcode !=1) {
                [USER_D removeObjectForKey:StoragePhone];
                [USER_D removeObjectForKey:StoragePassword];
                [USER_D synchronize];
            } else {
                UserModel *model =[[UserModel alloc] initWithDictionary:jsonDic];
                [[self class] parsingUserModel:model];
            }
        } fail:^(NSError *error) {
        }];
    } else if (loginType.length >0){
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@&s=%@",kProjectBaseUrl,ThirdPartyLogin,loginUsid,loginType];
        [ZhouDao_NetWorkManger getWithUrl:urlString sg_cache:NO success:^(id response) {
            
            NSDictionary *jsonDic = (NSDictionary *)response;
            NSUInteger errorcode = [jsonDic[@"state"] integerValue];
            if (errorcode !=1) {
                [USER_D removeObjectForKey:StorageTYPE];
                [USER_D removeObjectForKey:StorageUSID];
                return ;
            }
            UserModel *model =[[UserModel alloc] initWithDictionary:jsonDic];
            [[weakSelf class] parsingUserModel:model];
        } fail:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
        }];
    }
}
+ (void)parsingUserModel:(UserModel *)model {
    
    [PublicFunction ShareInstance].m_user = model;
    [PublicFunction ShareInstance].m_bLogin = YES;
    
    [UMessage setAlias:[NSString stringWithFormat:@"uid_%@",UID] type:@"ZDHF" response:^(id responseObject, NSError *error) {
        DLog(@"添加成功-----%@",responseObject);
    }];
    [UMessage addTag:[NSString stringWithFormat:@"type_%@",[PublicFunction ShareInstance].m_user.data.type]
            response:^(id responseObject, NSInteger remain, NSError *error) {
                DLog(@"添加标签成功-----%@",responseObject);
            }];
}
//MARK: 通用get
+ (void)generalGetURLString:(NSString *)urlString
             RequestSuccess:(void (^)())success
                       fail:(void (^)())fail { WEAKSELF
    
    [MBProgressHUD showMBLoadingWithText:nil];
    [ZhouDao_NetWorkManger getWithUrl:urlString sg_cache:NO success:^(id response) {
        
        [MBProgressHUD hideHUD];
        [[weakSelf class] getResponseObjectCommonMethods:response withsuccess:^{
            success();
        } fail:^{
            fail();
        }];
    } fail:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        fail();
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
    
}

//MARK: 通用post
+ (void)generalPostURLString:(NSString *)urlString
              WithDictionary:(NSDictionary *)paraDict
              RequestSuccess:(void (^)())success
                        fail:(void (^)())fail { WEAKSELF
    
    [MBProgressHUD showMBLoadingWithText:nil];
    [ZhouDao_NetWorkManger postWithUrl:urlString params:paraDict success:^(id response) {
        
        [MBProgressHUD hideHUD];
        [[weakSelf class] getResponseObjectCommonMethods:response withsuccess:^{
            success();
        } fail:^{
            fail();
        }];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        fail();
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}
#pragma mark - 通用判断 ##############
+ (void)getResponseObjectCommonMethods:(id)response
                           withsuccess:(void (^)())success                        fail:(void (^)())fail {
    [MBProgressHUD hideHUD];
    NSDictionary *jsonDic = (NSDictionary *)response;
    NSUInteger errorcode = [jsonDic[@"state"] integerValue];
    NSString *msg = jsonDic[@"info"];
    if (errorcode !=1) {
        [JKPromptView showWithImageName:nil message:msg];
        fail();
        return;
    }
    success();
}
+ (void)getResponseObjectShowMsgCommonMethods:(id)response
                                  withsuccess:(void (^)())success                        fail:(void (^)())fail{
    [MBProgressHUD hideHUD];
    NSDictionary *jsonDic = (NSDictionary *)response;
    NSUInteger errorcode = [jsonDic[@"state"] integerValue];
    NSString *msg = jsonDic[@"info"];
    [JKPromptView showWithImageName:nil message:msg];
    if (errorcode !=1) {
        fail();
        return ;
    }
    success();
}
#pragma mark - 判断铃音
+ (NSString *)getSoundName:(NSString *)bell {
    NSDictionary *bellDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"defaultSound",@"1",@"woman_contract",@"2",@"woman_meeting",@"3",@"woman_court",@"4",@"man_contract",@"5",@"man_meeting",@"6",@"man_court",@"7", nil];
    NSString *bellName = bellDictionary[bell];;
    
    return bellName;
}
#pragma mark - 下载格式
+ (NSString *)getFileFormat:(NSString *)idString {// 1 word ,2 pdf,3 txt,4 photo
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"word",@"1",@"pdf",@"2",@"txt",@"3",@"jpg",@"4", nil];
    return dict[idString];
}
#pragma mark- 沙盒文件是否
+ (NSString *)whetheFileExists:(NSString *)caseId {
    NSString *path = DownLoadCachePath;
    if (![FILE_M fileExistsAtPath:path]) {
        [FILE_M createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *casePath = [NSString stringWithFormat:@"%@/%@",path,caseId];
    if (![FILE_M fileExistsAtPath:casePath]) {
        [FILE_M createDirectoryAtPath:casePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return casePath;
}
//文件夹是否已经存在
+ (void)creatFilePathEvent:(NSString *)filePath {
    if (![FILE_M fileExistsAtPath:filePath]) {
        [FILE_M createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

@end
