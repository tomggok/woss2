//
//  DYBShareinstaceDelegate.m
//  DYiBan
//
//  Created by NewM on 13-7-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBShareinstaceDelegate.h"
#import "user.h"
#import "DYBUITabbarViewController.h"
#import "NSObject+MagicDatabase.h"
#import "JSONKit.h"
#import "JSON.h"
#import "Magic_Device.h"

@interface DYBShareinstaceDelegate()
{
}
@property (nonatomic, retain)NSString *version;

@end

@implementation DYBShareinstaceDelegate
@synthesize sessionID = _sessionID,
token = _token,
version = _version,
httpUrl = _httpUrl,
messageHttpUrl = _messageHttpUrl,
curUser=_curUser,
currentUserSetting = _currentUserSetting,
registUserSetting = _registUserSetting,
isLoginMethod = _isLoginMethod;
@synthesize userId = _userId;
@synthesize isSessionTimeOut = _isSessionTimeOut;
@synthesize dateFormatter = _dateFormatter;
@synthesize imei=_imei;
@synthesize isLogined = _isLogined, isLogin = _isLogin;

static DYBShareinstaceDelegate *sharedInstace = nil;

+ (DYBShareinstaceDelegate *)sharedInstace
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstace)
        {
            sharedInstace = [[DYBShareinstaceDelegate alloc] init];
            sharedInstace.isLoginMethod = NO;
        }
    });
    return sharedInstace;
    
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [MagicCommentMethod reachForDefaultHost];
        [self observeNotification:@"kNetworkConnectTypeChange"];
    }
    return self;
}

- (void)setCurUser:(user *)curUser
{
    [_curUser release];
    _curUser = [curUser retain];
    
}

- (NSString *)imei
{
    if (_imei.length == 0)
    {
        _imei = [[NSUserDefaults standardUserDefaults] valueForKey:@"markup"];
        
    }
    
    return _imei;
}

//处理nsnotifaction
- (void)handleNotification:(NSNotification *)notification
{
    if (_isLogined && [MagicDevice hasInternetConnection])
    {
        if ([notification is:@"kNetworkConnectTypeChange"])
        {
            if (!_curUser)
            {
                //获得用户信息
                MagicRequest *request = [DYBHttpMethod user_detail:SHARED.userId isAlert:NO receive:self];
                [request setTag:1];
            }
            if (!_isLogin)
            {
                //自动登陆
                MagicRequest *request = [DYBHttpMethod user_security_autologin:YES receive:self];
                [request setTag:2];
            }
        }
    }
    
}

- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if (request.tag == 1)
    {
        JsonResponse *response = (JsonResponse *)receiveObj;
        if ([response response] ==khttpsucceedCode)
        {
            SHARED.curUser=[user JSONReflection:[response.data objectForKey:@"user"]];
        }
        //加载左视图
        [[DYBUITabbarViewController sharedInstace] initLeftView];
        
    }
}

//删除数据库
- (void)deleteSql
{
    self.DB.FROM(kYIBANUSERTABLE).WHERE(@"userid", SHARED.userId).DELETE();
    self.DB.FROM(kYIBANSTATUSLISTTABLE).WHERE(@"userid", SHARED.userId).DELETE();
    
    SHARED.isLogin = NO;
    [SHARED cleanValue];
    
    [[DYBUITabbarViewController sharedInstace] clearSelf];
    
}

//清楚sharedinstance
- (void)cleanValue
{
    //清除用户设置
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SignPrivacy"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocationPrivacy"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DynamicPrivacy"];
    
    //    RELEASEOBJ(SHARED.sessionID);
    SHARED.sessionID = @"";
    //    RELEASEOBJ(SHARED.token);
    
    //    RELEASEOBJ(SHARED.version);
    //    RELEASEOBJ(SHARED.httpUrl)
    //    RELEASEOBJ(SHARED.userId);
    SHARED.userId = @"";
    
    SHARED.isLogined = NO;
    SHARED.isLogin = NO;
    
    [self unobserveAllNotification];
    
    RELEASEOBJ(SHARED.currentUserSetting);
    RELEASEOBJ(SHARED.registUserSetting);
}

#pragma mark -
#pragma mark appMessage
- (NSString *)sessionID
{
    if (!_sessionID || _sessionID.length == 0)
    {
        _sessionID = @"";//要做改的
    }
    return _sessionID;
}

- (NSString *)version
{
    if (!_version || _version.length == 0)
    {
        NSBundle * bundle = [NSBundle mainBundle];
        _version = [NSString stringWithFormat:@"%@", [bundle objectForInfoDictionaryKey:@"CFBundleVersion"]];
    }
    
    return _version;
}

- (NSString *)token
{
    return _token ? _token : @"";
}

#pragma mark -
#pragma mark method
//一般字体统一    ,这种字体在 sizeFit()方法后,字体内容在其frame里偏高
+ (UIFont *)DYBFoutStyle:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize];
}

#pragma mark -获取user里的usertype
-(NSString *)getUsertype:(int)type
{
    switch (type) {
        case 0:
            return @"学生";
        case 1:
            return @"辅导员";
        case 2:
            return @"领导";
        case 3:
            return @"施政老师";
        default:
            break;
    }
    return @"";
}

+(void)opeartionTabBarShow:(BOOL)key animated:(BOOL)animated{
    
    DYBUITabbarViewController *tabBatC = [DYBUITabbarViewController sharedInstace];
    
    if (key) {
        
        [tabBatC hideTabBar:YES animated:animated];
    }else{
        
        [tabBatC hideTabBar:NO animated:animated];
    }
    
    
}

+(void)opeartionTabBarShow:(BOOL)key{
    
    DYBUITabbarViewController *tabBatC = [DYBUITabbarViewController sharedInstace];
    
    if (key) {
        
        [tabBatC hideTabBar:YES animated:YES];
    }else{
        
        [tabBatC hideTabBar:NO animated:YES];
    }
    
    
}

//更改动态数据库某个字段value
+ (void)handleSqlValue:(NSString *)upId valueKye:(NSString *)valueKye value:(id)value
{
    self.DB.FROM(kYIBANSTATUSLISTTABLE).WHERE(@"userid", SHARED.userId).GET();
    
    NSArray *sqlArr = self.DB.resultArray;
    
    for (int i = 0; i < [sqlArr count]; i++)
    {
        NSMutableDictionary *dicsql = [NSMutableDictionary dictionaryWithDictionary:[sqlArr objectAtIndex:i]];
        NSMutableDictionary *dictSql = [[dicsql objectForKey:@"content"] JSONValue];
        NSMutableArray *sqlStausList = [[dictSql objectForKey:@"data"] objectForKey:@"status"];
        
        for (int i = 0; i < [sqlStausList count]; i++)
        {
            NSMutableDictionary *sqlStatu = [sqlStausList objectAtIndex:i];
            NSString *statuId = [sqlStatu objectForKey:@"id"];
            
            if ([statuId isEqualToString:upId])
            {
                [sqlStatu setValue:value forKey:valueKye];
                NSString *saveString = [dictSql JSONFragment];
                if (saveString)
                {
                    self.DB.FROM(kYIBANSTATUSLISTTABLE).SET(@"content", saveString).UPDATE();
                }
                break;
            }
            
        }
    }
    
}

//初始化dateformatter
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

//获得sql的用户信息
+(NSDictionary *)userList
{
    self.DB.FROM(kYIBANUSERTABLE).WHERE(@"logintype", @"1").GET();
    
    NSDictionary *userDict = nil;
    if ([self.DB.resultArray count] > 0)
    {
        userDict = [self.DB.resultArray objectAtIndex:0];
    }
    return userDict;
}
//创建易班数据库
+ (void)creatTable
{
    //创建user表
    self.DB.TABLE(kYIBANUSERTABLE).FIELD(@"id", @"integer").PRIMARY_KEY().AUTO_INREMENT()
    .FIELD(@"username", @"TEXT")
    .FIELD(@"password", @"TEXT")
    .FIELD(@"userid", @"TEXT")
    .FIELD(@"sessionID", @"TEXT")
    .FIELD(@"logintime", @"TEXT")
    .FIELD(@"logintype", @"TEXT").CREATE_IF_NOT_EXISTS();
    
    //创建动态列表
    self.DB.TABLE(kYIBANSTATUSLISTTABLE).FIELD(@"id", @"integer").PRIMARY_KEY().AUTO_INREMENT()
    .FIELD(@"content", @"TEXT")
    .FIELD(@"type", @"TEXT")
    .FIELD(@"userid", @"TEXT")
    .CREATE_IF_NOT_EXISTS();
    
    //资料库文件列表
    self.DB.TABLE(KDATABANKDOWNLIST).FIELD(@"id", @"integer").PRIMARY_KEY().AUTO_INREMENT()
    .FIELD(@"url", @"TEXT")
    .FIELD(@"filename", @"TEXT")
    .FIELD(@"downprogress", @"TEXT")
    .FIELD(@"filelength", @"TEXT")
    .FIELD(@"strType", @"TEXT")
    .FIELD(@"deCodeUerl", @"TEXT") //没有转码的URL
    .FIELD(@"type", @"TEXT")//type：传送中的页面1，已经离线页面2
    .FIELD(@"show", @"TEXT")//show: 1为显示 0不显示
    .FIELD(@"stopDowning", @"TEXT") //stopDowning : 0 正在下载完成 1 暂停  2 下载完成
    .FIELD(@"userid", @"TEXT").CREATE_IF_NOT_EXISTS();
    
    self.DB.TABLE(kDATABANKDOWNDETAIL)//下载资料的详细资料
    .FIELD(@"author", @"TEXT")
    .FIELD(@"count", @"TEXT")
    .FIELD(@"create_time", @"TEXT")
    .FIELD(@"dir", @"TEXT")
    .FIELD(@"file_path", @"TEXT")
    .FIELD(@"file_url", @"TEXT")
    .FIELD(@"file_urlencode", @"TEXT")
    .FIELD(@"icon", @"TEXT")
    .FIELD(@"id", @"TEXT")
    .FIELD(@"is_dir", @"TEXT")
    .FIELD(@"is_sys_folder", @"TEXT")
    .FIELD(@"size", @"TEXT")
    .FIELD(@"title", @"TEXT")
    .FIELD(@"userid", @"TEXT")
    .FIELD(@"type", @"TEXT").CREATE_IF_NOT_EXISTS();
    
    
    self.DB.TABLE(kDATABANKOFFLINELISTTABLE)//离线列表
    .FIELD(@"userid", @"TEXT")
    .FIELD(@"file_urlencode", @"TEXT")
    .CREATE_IF_NOT_EXISTS();
    
    self.DB.TABLE(kDATABANKCACHE) //资料库缓存
    .FIELD(@"content",@"TEXT")
    .FIELD(@"navlist",@"TEXT")
    .FIELD(@"userid",@"TEXT")
    .FIELD(@"page",@"TEXT")
    .CREATE_IF_NOT_EXISTS();
    
    
    self.DB.TABLE(USERMODLE)
    .FIELD(@"userInfo",@"TEXT")
    .FIELD(@"userIndex",@"TEXT")
    .CREATE_IF_NOT_EXISTS();
    
}



//提示框
+ (DYBDataBankShotView *)addConfirmViewTitle:(NSString *)title MSG:(NSString *)strMSG targetView:(UIView *)view targetObj:(id)Obj btnType:(int)type
{
    DYBDataBankShotView *showView = [[DYBDataBankShotView alloc]initWithFrame:view.bounds type:type  title:title MSG:strMSG];
    showView.hidden = NO;
    [showView setReceive:Obj];
    [view addSubview:showView];
    RELEASE(showView);
    
    return showView;
}

#pragma mark- 带dic的提示框
+ (DYBDataBankShotView *)addConfirmViewTitle:(NSString *)title MSG:(NSString *)strMSG targetView:(UIView *)view targetObj:(id)Obj btnType:(int)type dic:(NSMutableDictionary *)dic
{
    DYBDataBankShotView *showView = [[DYBDataBankShotView alloc]initWithFrame:view.bounds type:type  title:title MSG:strMSG];
    showView.hidden = NO;
    [showView setReceive:Obj];
    [view addSubview:showView];
    showView.selectIndex = 1;
    showView.userInfo=dic;
    RELEASE(showView);
    
    return showView;
}

//需要传row 的提示框
+ (DYBDataBankShotView *)addConfirmViewTitle:(NSString *)title MSG:(NSString *)strMSG targetView:(UIView *)view targetObj:(id)Obj btnType:(int)type rowNum:(NSString *)row{
    
    DYBDataBankShotView *showView = [self addConfirmViewTitle:title MSG:strMSG targetView:view targetObj:Obj btnType:type ];
    showView.rowNum = [NSNumber numberWithInt:[row integerValue]];
    return showView;
}

//加载提示可以设置时间
+ (MagicUIPopAlertView *)loadFinishAlertView:(NSString *)text target:(id)target showTime:(CGFloat)time
{
    CGSize frame = MAINSIZE;
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    
    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
    [pop setDelegate:target];
    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
    [pop setNeedSelfY:YES];
    [pop setAlertViewY:(frame.height - 66)];
    
    [window addSubview:pop];
    [pop setText:text];
    
    [pop alertViewAutoHidden:time isRelease:YES];
    
    return pop;
}

//提示数据加载完毕
+ (MagicUIPopAlertView *)loadFinishAlertView:(NSString *)text target:(id)target
{
    return [DYBShareinstaceDelegate loadFinishAlertView:text target:target showTime:.5f];
}

+(void)popViewText:(NSString *)text target:(id)_target hideTime:(float)time isRelease:(BOOL)key mode:(MagicpopViewType )type{
    
    if (text.length == 0) {
        //        text = @"操作失败";
    }
    
    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
    [pop setDelegate:_target];
    [pop setMode:type];
    [pop setText:text];
    [pop alertViewAutoHidden:-0.3f isRelease:key];
    
}

+(BOOL)noShowTypeFileTarget:(id)_target type:(NSString *)type{
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"doc",@"docx",@"ppt",@"pptx",@"xls",@"xlsx",@"pdf",@"mp3",@"wma",@"mp4",@"html",@"gif", @"png",@"jpg",@"htm",@"acc",@"3gp",@"avi",@"avc",@"arm",@"bmp",@"txt",nil];
    if (![array containsObject:[type lowercaseString]]) {
        
        [self popViewText:@"暂不能预览该文件" target:_target hideTime:1.0f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        return NO;
    }
    
    return YES;
}
+ (BOOL)isOKName:(NSString *)str{
    
    NSString *rr = @"<>/\\|:：\"*?？＜＞／＼";
    
    for (int i = 0 ; i< rr.length ; i++ ) {
        
        NSString *ttt = [rr substringWithRange:NSMakeRange(i, 1)];
        NSRange range=[str rangeOfString:ttt];
        
        if(range.length==1){
            
            return NO;
        }
    }
    if (str.length == 0) {
        
        return NO;
    }
    return YES;
}

+ (int)getStringLenghtUTF8:(NSString *)strSMG{
    
    unsigned result = 0;
    const char *tchar = [strSMG UTF8String];
    if (NULL == tchar) {
        return result;
    }
    result  = strlen(tchar);
    return result;
    
}

+(NSString *)getPermType:(int)type{
    
    
    switch (type) {
        case 0:
            return @"不共享";
            break;
        case 1:
            return @"公开";
            break;
        case 2:
            return @"全部好友";
            break;
        case 3:
            return @"指定好友";
            break;
        case 4:
            return @"指定的班级";
            break;
            
        default:
            break;
    }
    return @"无";
}

+(NSString *)addIPImage:(NSString *)string{
    
    NSString *ip = @"http://118.244.202.47";
    return [ip stringByAppendingString:string];

}

@end
