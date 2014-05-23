//
//  DYBLocalDataManager.m
//  DYiBan
//
//  Created by Song on 13-8-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBLocalDataManager.h"

#import "user.h"
#import "Magic_Sandbox.h"
#import "UserSettingMode.h"
#import "UserLoginModel.h"
#import "NSObject+SBJSON.h"
#import "JSON.h"
#define FILENAMEUSERINFOFILE    @"userInfoFile"
#define FILENAMEUSERINFOPLIST   @"userInfo.plist"
@implementation DYBLocalDataManager
@synthesize currentUser=_currentUser;
@synthesize currentUserSetting = _currentUserSetting;
@synthesize currentLoginModel = _currentLoginModel;
@synthesize currentSessionId = _currentSessionId;
@synthesize resetSchoolSessionId = _resetSchoolSessionId;
@synthesize cacheSqlDataDict = _cacheSqlDataDict;
@synthesize exectSqlDict = _exectSqlDict;

@synthesize httpGetMethodData = _httpGetMethodData;
@synthesize cacheDataDict = _cacheDataDict;
@synthesize isLogin = _isLogin;//
@synthesize isOuthLogin;



- (void)dealloc
{
    _currentLoginModel = nil;
    _resetSchoolSessionId = nil;
    _currentSessionId = nil;
    [_httpGetMethodData release];
    [_currentUserSetting release];
    [_currentUser release];
    [_cacheDataDict release];
    [_cacheSqlDataDict release];
    [_exectSqlDict release];
    _exectSqlDict = nil;
    _cacheSqlDataDict = nil;
    _cacheDataDict = nil;
    _currentUserSetting = nil;
    _currentUser = nil;
    [super dealloc];
}

static DYBLocalDataManager *sharedInstance = nil;

+(DYBLocalDataManager *)sharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[DYBLocalDataManager alloc] init];
        
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        sharedInstance.httpGetMethodData = newDict;
        NSMutableDictionary *newDict2 = [[NSMutableDictionary alloc] init];
        sharedInstance.cacheDataDict = newDict2;
        NSMutableDictionary *newDict3 = [[NSMutableDictionary alloc] init];
        sharedInstance.cacheSqlDataDict = newDict3;
        NSMutableDictionary *newDict4 = [[NSMutableDictionary alloc] init];
        sharedInstance.exectSqlDict = newDict4;
        
        sharedInstance.isLogin = NO;
        RELEASE(newDict);
        RELEASE(newDict2);
        RELEASE(newDict3);
        RELEASE(newDict4);
    }
    return sharedInstance;
}

- (void)clearCurrentUser{
    RELEASEOBJ(sharedInstance);
}



#pragma mark - fileUserInfo
- (NSMutableDictionary *)userInfoFileManager:(NSString *)path{
    
    NSFileManager *file = [NSFileManager defaultManager];
    NSMutableDictionary *userInfoDict = nil;
    if ([file fileExistsAtPath:path]) {
        userInfoDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }else{
        userInfoDict = [[NSMutableDictionary alloc] init];
    }
    return userInfoDict;
}

//保存用户信息
- (void)saveUserLoginModel:(NSString *)userId username:(NSString *)username sessId:(NSString *)sessId autoLogin:(NSString *)autoLogin{
    //存用户为了
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [userDict setValue:userId forKey:@"userid"];
    [userDict setValue:sessId forKey:@"sessID"];
    [userDict setValue:autoLogin forKey:@"autoLogin"];
    [userDict setValue:username forKey:@"username"];
    [userDict setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"lasttime"];
    [self saveAllUserWithDict:userDict];
    
    [dateFormatter release];
    
    UserLoginModel *model = [[UserLoginModel alloc] initDict:userDict];
    [[DYBLocalDataManager sharedInstance] setCurrentLoginModel:model];
    RELEASE(model);
    RELEASE(userDict);
}

//保存和更新用户资料
- (void)saveAllUserWithDict:(NSMutableDictionary *)userInfo{
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",[MagicSandbox docPath], FILENAMEUSERINFOFILE, FILENAMEUSERINFOPLIST];
    NSMutableDictionary *userInfoDict = [self userInfoFileManager:path];
    if ([userInfo objectForKey:@"userid"] && userInfo) {
        [userInfoDict setValue:userInfo forKey:[userInfo objectForKey:@"userid"]];
        [userInfoDict writeToFile:path atomically:YES];
        RELEASE(userInfoDict);
    }
    
}

//删除用户资料
- (void)deleteUserInfo:(NSMutableArray *)userInfo{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",[MagicSandbox docPath], FILENAMEUSERINFOFILE, FILENAMEUSERINFOPLIST];
    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [userInfo count]; i++) {
        UserLoginModel *model = [userInfo objectAtIndex:i];
        [userInfoDict setValue:[model retunDict] forKey:model.userId];
    }
    
    [userInfoDict writeToFile:path atomically:YES];
    RELEASE(userInfoDict);
}

//获得特定用户资料
- (UserLoginModel *)getUserInfoMessage:(NSString *)userId{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",[MagicSandbox docPath], FILENAMEUSERINFOFILE, FILENAMEUSERINFOPLIST];
    NSMutableDictionary *userInfoDict = [self userInfoFileManager:path];
    UserLoginModel *u = [[[UserLoginModel alloc] initDict:[userInfoDict objectForKey:userId]] autorelease];
    RELEASE(userInfoDict);
    return u;
}

//获得全部用户资料
- (NSMutableArray *)getAllUserInfo{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",[MagicSandbox docPath], FILENAMEUSERINFOFILE, FILENAMEUSERINFOPLIST];
    NSMutableDictionary *userInfoDict = [self userInfoFileManager:path];
    
    NSMutableArray *userInfoArray = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];
    for (int i = 0; i < [[userInfoDict allValues] count]; i++) {
        UserLoginModel *u = [[UserLoginModel alloc] initDict:[[userInfoDict allValues] objectAtIndex:i]];
        [userInfoArray addObject:u];
        [u release];
    }
    RELEASE(userInfoDict);
    return userInfoArray;
}

//保存和更新当前用户的设置(不传或者穿null默认当前用户)
- (void)saveUserSetting:(id)userSetting key:(NSString *)key{
    if (!key || key.length == 0) {
        key = [[[DYBLocalDataManager sharedInstance] currentUser] userid];
    }
    if (key.length == 0) {
        return;
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@.plist",[MagicSandbox docPath], FILENAMEUSERINFOFILE, key];
    NSMutableDictionary *userInfoDict = [self userInfoFileManager:path];
    [userInfoDict setValue:userSetting forKey:key];
    [userInfoDict writeToFile:path atomically:YES];
    RELEASE(userInfoDict);
}

//获取用户设置（不传或者穿null默认当前用户）
- (NSDictionary *)getUserSetting:(NSString *)key{
    if (!key || key.length == 0) {
        key = [[[DYBLocalDataManager sharedInstance] currentUser] userid];
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@.plist",[MagicSandbox docPath], FILENAMEUSERINFOFILE, key];
    NSDictionary *userInfoDict = [self userInfoFileManager:path];
    NSDictionary *result = [[userInfoDict objectForKey:key] JSONValue];
    if (!result) {
        result = [[self initUserSetting:key] dict];
    }
    return result;
}

//删除用户设置
- (void)deleteUserSetting:(NSString *)key{
    NSFileManager *file = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@.plist",[MagicSandbox docPath], FILENAMEUSERINFOFILE, key];
    BOOL ifSu = [file removeItemAtPath:path error:nil];
    if (!ifSu) {
    }
}

//初始化UserSetting
- (UserSettingMode *)initUserSetting:(NSString *)key{
    UserSettingMode *settingMode = [[[UserSettingMode alloc] init] autorelease];
    [settingMode setUpSendImgType:@"自动"];
    [settingMode setUserId:key];
    [settingMode setUserPersonPageBg:@"homebg_default1.jpg"];
    
    [settingMode setTeacherPush:0];
    [settingMode setEvaluatePush:0];
    [settingMode setPrivateMessagePush:0];
    [settingMode setAtMePush:0];
    [settingMode setAddMePush:0];
    [settingMode setTimeForNoPush:0];
    [settingMode setJobPush:0];
    
    [settingMode setShake:1];
    [settingMode setSound:1];
    [[DYBLocalDataManager sharedInstance] saveUserSetting:[[settingMode dict] JSONFragment] key:@""];
    
    return settingMode;
}

@end
