//
//  DYBLocalDataManager.h
//  DYiBan
//
//  Created by Song on 13-8-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class user;
@class UserLoginModel;
@class UserSettingMode;
@interface DYBLocalDataManager : NSObject

{
    user *_currentUser;
    UserSettingMode *_currentUserSetting;
    
}
@property (nonatomic, retain)user *currentUser;//当前用户信息
@property (nonatomic, retain)UserSettingMode *currentUserSetting;//当前用户设者
@property (nonatomic, retain)UserLoginModel *currentLoginModel;//当前登陆用户信息
@property (nonatomic, retain)NSString *currentSessionId;//当前用户的sessionid
@property (nonatomic, retain)NSString *resetSchoolSessionId;//认证学校的sessionid

@property (nonatomic, retain)NSMutableDictionary *httpGetMethodData;//请求参数

@property (nonatomic, retain)NSMutableDictionary *cacheDataDict;//找人，朋友，班级，新华e讯(key:CACHEDATAKEYFINDFRIEND,CACHEDATAKEYFRIEND,CACHEDATAKEYCLASS,CACHEDATAKEYXINHUA)
@property (nonatomic, retain)NSMutableDictionary *cacheSqlDataDict;//缓存数据库中的数据（key：好友动态(CACHESQLFRIENDSTUTUSKEY)，我的动态(CACHESQLMYSTUTSKEY)，更多里面的动态(CACHESQLMORESTUTUSKEY)（是一个个字典对象（key是id）,valus是muA））
@property (nonatomic, retain)NSMutableDictionary *exectSqlDict;//要执行的创建或插入的sql语句｛key:动态：（好友，我的，更多），左屏，自己的｝

@property (nonatomic, assign)BOOL isOuthLogin;//是否是自动登陆
@property (nonatomic, assign)BOOL isLogin;//是否是登陆成功
//清除当前用户信息
- (void)clearCurrentUser;

+(DYBLocalDataManager *)sharedInstance;

//保存用户信息
- (void)saveUserLoginModel:(NSString *)userId username:(NSString *)username sessId:(NSString *)sessId autoLogin:(NSString *)autoLogin;

//保存用户资料
- (void)saveAllUserWithDict:(id)userInfo;

//删除用户资料
- (void)deleteUserInfo:(NSMutableArray *)userInfo;

//保存和更新用户的设置(不传或者穿null默认当前用户)
- (void)saveUserSetting:(id)userSetting key:(NSString *)key;

//获得特定用户资料
- (UserLoginModel *)getUserInfoMessage:(NSString *)userId;

//获得全部用户资料
- (NSMutableArray *)getAllUserInfo;

//获取用户设置（不传或者穿null默认当前用户）
- (NSDictionary *)getUserSetting:(NSString *)key;

//删除用户设置
- (void)deleteUserSetting:(NSString *)key;


@end
