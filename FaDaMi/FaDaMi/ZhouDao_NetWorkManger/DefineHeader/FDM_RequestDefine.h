//
//  FDM_RequestDefine.h
//  FaDaMi
//
//  Created by apple on 16/12/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#ifndef FDM_RequestDefine_h
#define FDM_RequestDefine_h


#endif /* FDM_RequestDefine_h */


//线上
#define kProjectBaseUrl         @"http://zapi.zhoudao.cc/pro/"
//测试地址
//#define kProjectBaseUrl         @"http://testapi.zhoudao.cc/pro/"


/*
 1 验证手机号
 */
#define  VerifyTheMobile        @"api_reg.php?c=vm&key=16248ef5&"
/*
 2 登录
 */
#define LoginUrlString          @"api_login.php?key=16248ef5&c=login&"
/*
 3 注册
 */
#define RegisterUrlString       @"api_reg.php?c=reg&key=16248ef5&"
/*
 4 忘记密码
 */
#define ForgetKey               @"api_login.php?key=16248ef5&c=forget&"

/**
 *  5 绑定账号
 */
#define AuBindingURLString      @"api_login.php?key=16248ef5&c=auBinding&"

/**
 *  6 解绑账号
 */
#define AuBindingOCURL          @"api_user.php?key=16248ef5&c=auBindingOc&"

/*
 7 意见反馈
 */
#define FeedBackAdd             @"api_user.php?key=16248ef5&c=feedbackAdd&"
/*
 8 上传头像
 */
#define UploadHeadPic           @"api_user.php?key=16248ef5&c=uploadPic&"

/*
 9 通讯地址
 */
#define UploadUserAddress       @"api_user.php?key=16248ef5&c=uploadAddress&"
/*
 10 律师职业
 */
#define UploadJob               @"api_user.php?key=16248ef5&c=uploadJob&"

/*
 11 获取上传图片的token
 */
#define UploadPicToken          @"api_user.php?key=16248ef5&c=tokenValue"
/*
 12 更改手机号
 */
#define ResetMobile             @"api_user.php?key=16248ef5&c=uploadMobile&"
/*
 13 领域列表
 */
#define DomainList              @"api_field.php?key=16248ef5&c=domainList"
/*
 14 修改领域
 */
#define DomainAdd               @"api_field.php?key=16248ef5&c=domainAdd&"
/*
 15 查询用户擅长领域
 */
#define DomainUser              @"api_field.php?key=16248ef5&c=domainUser&"

/**
 *  16 第三方授权后判断是否已经绑定手机号
 */
#define ThirdPartyLogin         @"api_login.php?key=16248ef5&c=otherLogin&au="

/**
 *  17 绑定账号
 */
#define AuBindingURLString      @"api_login.php?key=16248ef5&c=auBinding&"

/**
 *  18 解绑账号
 */
#define AuBindingOCURL          @"api_user.php?key=16248ef5&c=auBindingOc&"

/*
 19 认证信息
 */
#define ApplyInfo               @"api_certification.php?key=16248ef5&c=applyInfo&"

/*
 *  20 请求更新文件
 */
#define NEWVERSIONTXTURL        @"api_txt_new.php?key=16248ef5"
/**
 *  21 分享计算 post
 */
#define SHARECALCulate          @"api_tools.php?key=16248ef5&c=toolsShareNew"
#define TOOLSWORDSHAREURL       @"tools_word.php?id="

/**
 *  22 首页全部
 */
#define HomeViewIndexAll        @"api_recom.php?key=16248ef5&c=indexAll"

/**
 *  23 首页加载更多
 */
#define HOTSPOTALL              @"api_recom.php?key=16248ef5&c=hotspotAll&page="
/**
 *  24 便签 列表
 */
#define BIANQIANLIST            @"api_usersecond.php?c=noteList&key=16248ef5&uid="
/**
 *  25 便签 添加
 */
#define BIANQIANADD             @"api_usersecond.php?c=noteAdd&key=16248ef5"
/**
 *  26 便签 修改
 */
#define BIANQIANEDIT          @"api_usersecond.php?c=noteEdit&key=16248ef5"
/**
 *  27 便签 删除
 */
#define BIANQIANDELETE          @"api_usersecond.php?c=noteDel&key=16248ef5&uid="



#define FANGWUCulate            @"tools_fangwuhuandai.php"//房屋还贷
#define GSPCCulate              @"tools_gongshangpeichang.php"//工商赔偿
#define JJBCCulate              @"tools_jingjibuchangjin.php"//经济补偿
#define LHFCCulate              @"tools_lihunfangchan.php"//离婚房产
#define LIXICulate              @"tools_lixi.php"//利息
#define LVSFCulate              @"tools_lvshifei.php"//律师费
#define RSSHCulate              @"tools_renshensunhai.php"//人身损害
#define DAYSCulate              @"tools_riqi.php"//天数计算
#define DATESCulate             @"tools_riqi.php?id=1"//日期计算
#define SLFCulate               @"tools_shoulifei.php"//受理费
#define WYJCulate               @"tools_weiyuejin.php"// 违约金
#define YUQILXCulate            @"tools_yuqilixi.php"//逾期利息
#define SOCIALCulate            @"tools_gongzi.php"//社保计算器


/**************************分享的链接***************************/
//法律法规
#define LawShareUrl                    @"share_laws.php?id="
//赔偿标准
#define CompensationShareUrl           @"share_compensation.php?id="
//案例
#define CaseShareUrl                   @"share_case.php?id="
//合同模版
#define TheContractShareUrl            @"share_contract.php?id="

/*************************文章阅读和提示信息****************************/

/*
 *字体大小
 */
#define   ReadFont                     @"readFont"
/*
 *背景色
 */
#define   ReadColor                    @"ReadColor"
/*
 *字体颜色
 */
#define   ReadFontColor                @"ReadFontColor"

/*
 登录账号
 */
#define   StoragePhone                 @"storagePhone"
/*
 登录密码
 */
#define   StoragePassword              @"storageKey"
/*
 三方登录方式QQ 微信 新浪微博
 */
#define   StorageTYPE                  @"loginType"
/*
 三方登录uSid
 */
#define   StorageUSID                  @"otherLoginUSid"


