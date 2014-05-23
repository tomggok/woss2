//
//  DYBShareinstaceDelegate.h
//  DYiBan
//
//  Created by NewM on 13-7-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYBDataBankShotView.h"
@class user;
@class UserSettingMode;
@class userRegistModel;
@interface DYBShareinstaceDelegate : NSObject

//app message
@property (nonatomic, readonly)NSString *version;
@property (nonatomic, retain)NSString *token;
@property (nonatomic, retain)NSString           *sessionID;
@property (nonatomic, assign)BOOL               isLogin;//登陆成功
@property (nonatomic, assign)BOOL               isLogined;//登陆过但是失败
@property (nonatomic, retain)NSString           *httpUrl;
@property (nonatomic, retain)NSString           *messageHttpUrl;//资料库url
@property (nonatomic, retain)user               *curUser;//当前登录的用户数据
@property (nonatomic, retain)UserSettingMode *currentUserSetting;//当前登录的用户数据
@property (nonatomic, retain)userRegistModel *registUserSetting;//当前注册用户数据
@property (nonatomic, retain)NSString           *userId;//用户的userid
@property (nonatomic, assign)BOOL               isSessionTimeOut;//用户是否session过期
@property (nonatomic, assign)BOOL               isLoginMethod;//是否是登陆的方法
//初始化dateformatter
@property (nonatomic, readonly)NSDateFormatter *dateFormatter;
@property (nonatomic, readonly)NSString *imei;

+ (DYBShareinstaceDelegate *)sharedInstace;

//删除数据库
- (void)deleteSql;
//清楚sharedinstance
- (void)cleanValue;

//一般字体统一
+ (UIFont *)DYBFoutStyle:(CGFloat)fontSize;

-(NSString *)getUsertype:(int)type;

+(void)opeartionTabBarShow:(BOOL)key;
+(void)opeartionTabBarShow:(BOOL)key animated:(BOOL)animated;
//创建易班数据库
+ (void)creatTable;

//更改动态数据库某个字段value
+ (void)handleSqlValue:(NSString *)upId valueKye:(NSString *)valueKye value:(id)value;

//获得sql的用户信息
+(NSDictionary *)userList;
//提示框
+ (DYBDataBankShotView *)addConfirmViewTitle:(NSString *)title MSG:(NSString *)strMSG targetView:(UIView *)view targetObj:(id)Obj btnType:(int)type;
+ (DYBDataBankShotView *)addConfirmViewTitle:(NSString *)title MSG:(NSString *)strMSG targetView:(UIView *)view targetObj:(id)Obj btnType:(int)type dic:(NSMutableDictionary *)dic;

//提示数据加载完毕
+ (MagicUIPopAlertView *)loadFinishAlertView:(NSString *)text target:(id)target;
//加载提示可以设置时间
+ (MagicUIPopAlertView *)loadFinishAlertView:(NSString *)text target:(id)target showTime:(CGFloat)time;

+ (DYBDataBankShotView *)addConfirmViewTitle:(NSString *)title MSG:(NSString *)strMSG targetView:(UIView *)view targetObj:(id)Obj btnType:(int)type rowNum:(NSString *)row;


+(void)popViewText:(NSString *)text target:(id)_target hideTime:(float)time isRelease:(BOOL)key mode:(MagicpopViewType )type;

//不能预览文件
+(BOOL)noShowTypeFileTarget:(id)_target type:(NSString *)type;

//判断文件名
+ (BOOL)isOKName:(NSString *)str;

//得到UTF8字符串长度
+ (int)getStringLenghtUTF8:(NSString *)strSMG;

//设置共享类型
+(NSString *)getPermType:(int)type;
+(NSString *)addIPImage:(NSString *)string;
@end
