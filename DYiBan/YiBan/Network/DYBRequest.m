//
//  DYBRequest.m
//  DYiBan
//
//  Created by NewM on 13-7-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBRequest.h"

#import "Magic_Device.h"
#import "Magic_CommentMethod.h"
#import "JSONKit.h"
#import "JSON.h"
#import "UIView+MagicViewSignal.h"
#import "NSObject+MagicRequestResponder.h"
#import "Magic_Device.h"
#import "NSObject+MagicDatabase.h"

#import "user.h"
#import "UserSettingMode.h"
#import "status_list.h"
#import "status.h"

#import "DYBBaseViewController.h"
#import "DYBLoadingView.h"

#import "DYBMapView.h"
#import "UIView+MagicCategory.h"
#import "DYBDataBankShotView.h"

#import "DYBLocalDataManager.h"



@interface DYBRequest ()
{
    id                   receiver;   //http响应接受者
    NSMutableDictionary *requestDict;//http请求参数
    
    
    DYBLoadingView *popView;//提示框
}
@property (nonatomic, retain)NSMutableArray *cacheArr;
@property (nonatomic, copy)NSMutableDictionary *requestDict;
@end

@implementation DYBRequest
@synthesize cacheArr = _cacheArr;
@synthesize requestDict = _requestDict;

- (void)dealloc
{
    if (popView)
    {
        RELEASEVIEW(popView);
    }
    //    RELEASEDICTARRAYOBJ(_requestDict);
    RELEASEOBJ(_requestDict);
    RELEASEOBJ(receiver);
    if (_cacheArr)
    {
        RELEASEOBJ(_cacheArr);
    }
    
    [super dealloc];
}

- (MagicRequest *)POSTORGET:(NSMutableDictionary *)params
                     isAlert:(BOOL)isAlert
                     receive:(id)_receive
                    fileData:(NSDictionary *)fileDatas
                      isPost:(BOOL)isPost
                     noCache:(BOOL)noCache
                    postType:(HTTPPOSTTYPE)postType
{
    
    _requestDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    if (SHARED.isSessionTimeOut)
    {
        return nil;
    }
    
    if (isAlert)
    {//增加弹出框
        if (!popView) {
            popView = [[DYBLoadingView alloc] init];
            
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            [window addSubview:popView];
            /*[popView setDelegate:receiver];
             [popView setIndicatorMode:INDICATORHEADTYPE];
             [popView setText:@"加载中..."];
             [popView alertViewShown];*/
        }
        
    }
    
    receiver = [_receive retain];
    
    if (!noCache) {
        _cacheArr = [[NSMutableArray alloc] initWithArray:[self handleCache:params]];
    }
    
    //    _cacheArr = nil;
    if (_cacheArr && [_cacheArr count] > 0)
    {
        MagicRequest *request = [self GET:@""];
        
        return request;
    }else
    {
        RELEASEDICTARRAYOBJ(_cacheArr);
    }
    
    
    if ([MagicDevice hasInternetConnection] == NO) {
        
        MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
        [pop setDelegate:receiver];
        [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
        [pop setText:@"检测不到网络连接！"];
        [pop alertViewAutoHidden:.5f isRelease:YES];
        
        [self postNotification:[DYBBaseViewController NoInternetConnection] withObject:nil];
        
        [self handleSpecialInterface:params];
        
        return nil;
    }
    
    
    
    
    NSString *url = [self encodeUrl:params];
    MagicRequest *request = nil;
    if (isPost)
    {
        request = self.HTTP_POST(url);
        
        for (int i = 0; i < [[fileDatas allKeys] count]/*只有一个key*/; i++)
        {
            NSString *fileKey = [[fileDatas allKeys] objectAtIndex:i];
            NSArray *file = [fileDatas objectForKey:fileKey];
            //            for (int i = 0; i < [file count]; i++)//存放文件
            //            {
            if (postType == POSTIMGTYPE) {
                for (NSData *imageData in file)
                {
                    if ([file count] == 1)
                    {
                        [request addData:imageData withFileName:@"anykey.jpg" andContentType:@"image/jpeg" forKey:@"image"];
                    }else
                    {
                        [request addData:imageData withFileName:@"anykey.jpg" andContentType:@"image/jpeg" forKey:@"image[]"];
                    }
                }
            }else
            {
                for (int j = 0; j < [file count]; j++)//数组每个元素是个保存被上传的数据的muD
                {
                    NSDictionary *dict = [file objectAtIndex:j];
                    NSString *fileName = [dict objectForKey:POSTDATAFILENAME];
                    NSString *fileType = [dict objectForKey:POSTDATAFILETYPE];
                    
                    if ([fileType isEqualToString:POSTIMG])
                    {//图片
                        
                        [request addData:[dict objectForKey:POSTDFILEDATA] withFileName:fileName andContentType:@"image/jpeg" forKey:@"files[]"];
                        
                        
                    }else if([fileType isEqualToString:POSTSPX])
                    {//文件
                        [request addData:[dict objectForKey:POSTDFILEDATA] withFileName:fileName andContentType:@"application/octet-stream" forKey:@"files[]"];
                        
                    }
                    
                }
            }
            
        }
    }else
    {
        //        NSString *getMethod = [requestDict objectForKey:@"do"];
        
        //        if ([getMethod isEqualToString:kSecurityLogin] ||
        //            [getMethod isEqualToString:kSecurityAutologin])
        //        {
        //            request = [self GET_SYNC:url];
        //        }else
        {
            request = [self GET:url];
        }
        
    }
    
    if ([MagicDevice sysVersion] == 5.0)
    {
        [request setValidatesSecureCertificate:NO];
    }
    
    return request;
    
}

//网络POST请求上传文件
- (MagicRequest *)DYBPOSTFILE:(NSMutableDictionary *)params isAlert:(BOOL)isAlert receive:(id)_receive fileData:(NSDictionary *)fileDatas
{
    MagicRequest *request = [self POSTORGET:params isAlert:isAlert receive:_receive fileData:fileDatas isPost:YES noCache:NO postType:POSTFILETYPE];
    
    return request;
}

//网络POST请求为上传图片
- (MagicRequest *)DYBPOSTIMG:(NSMutableDictionary *)params isAlert:(BOOL)isAlert receive:(id)_receive imageData:(NSArray *)imageDatas
{
    NSDictionary *dictArr = [NSDictionary dictionaryWithObjectsAndKeys:imageDatas, POSTIMG, nil];
    MagicRequest *request = [self POSTORGET:params isAlert:isAlert receive:_receive fileData:dictArr isPost:YES noCache:NO postType:POSTIMGTYPE];
    
    return request;
}

//网络POST请求
- (MagicRequest *)DYBPOST:(NSMutableDictionary *)params isAlert:(BOOL)isAlert receive:(id)_receive
{
    
    MagicRequest *request = [self POSTORGET:params isAlert:isAlert receive:_receive fileData:nil isPost:YES noCache:NO postType:POSTIMGTYPE];
    
    return request;
}

//网络请求GET请求
- (MagicRequest *)DYBGET:(NSMutableDictionary *)params isAlert:(BOOL)isAlert receive:(id)_receive
{
    MagicRequest *request = [self POSTORGET:params isAlert:isAlert receive:_receive fileData:nil isPost:NO noCache:NO postType:POSTIMGTYPE];
    
    return request;
}

//网络请求GET请求不需要缓存
- (MagicRequest *)DYBGETNOCACHE:(NSMutableDictionary *)params isAlert:(BOOL)isAlert receive:(id)_receive
{
    MagicRequest *request = [self POSTORGET:params isAlert:isAlert receive:_receive fileData:nil isPost:NO noCache:YES postType:POSTIMGTYPE];
    
    return request;
}

//网络请求协议
- (NSString *)encodeUrl:(NSMutableDictionary *)dict
{
    
    NSString *strDataBank = [dict objectForKey:@"isDataBank"]; //判断来自资料库的接口
    NSString *sendURL = nil;
    if ([strDataBank isEqualToString:@"YES"]) {
        
        [dict removeObjectForKey:@"isDataBank"];
        sendURL = SHARED.messageHttpUrl;
    }else{
        
        sendURL = SHARED.httpUrl;
    }
    
    
    NSString *apn = [MagicDevice networkType];
    NSString *platom = [NSString stringWithFormat:@"ios%.f",[MagicDevice sysVersion]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[dict objectForKey:INTERFACEDOACTION] forKey:@"do"];
    
    [dict removeObjectForKey:INTERFACEDOACTION];
    
    [params setValue:dict forKey:@"data"];
//    
//    [params setValue:SHARED.imei forKey:@"identify"];//等待有效的解决方案
//    
//    [params setValue:SHARED.token forKey:@"token"];
//    [params setValue:SHARED.sessionID forKey:@"sessID"];
//    DLogInfo(@"sessionID -- %@",SHARED.sessionID);
//    [params setValue:@"1" forKey:@"ct"];
//    [params setValue:SHARED.version forKey:@"v"];
//    [params setValue:@"AppStore" forKey:@"rv"];
//    [params setValue:apn forKey:@"apn"];
//    [params setValue:platom forKey:@"device"];
    
    
    DLogInfo(@"parms -- > %@",params);
    
    self.requestDict = params;
    
    NSString *strParam = [self getUrlParams:[params objectForKey:@"data"]];
    NSString *jsonStr = [MagicCommentMethod encodeURL:strParam];
    
    NSString *url = [NSString stringWithFormat:@"%@%@?%@",sendURL, [params objectForKey:@"do"], jsonStr];
    DLogInfo(@"%@ 接口的 url === %@",[params objectForKey:@"do"],url);
    return url;
}
-(NSString *)getUrlParams:(NSDictionary *)dict{
    NSArray *arrallKey = [dict allKeys];
    NSMutableArray *arrayStr = [[[NSMutableArray alloc]init] autorelease];
    
    for (int i = 0; i<dict.count; i++) {
        NSString *key = [arrallKey objectAtIndex:i];
       NSString *url = [NSString stringWithFormat:@"%@=%@",key, [dict objectForKey:key]];
        [arrayStr addObject:url];
    }

    NSString* url = [arrayStr componentsJoinedByString:@"&"];
    DLogInfo(@"url -- %@",url);
    return url;
}

//处理锁住的Button
- (void)handleNetworkeback
{
    if (popView)
    {
        //            [popView alertViewHiddenAndRelease];
        //            popView = nil;
        RELEASEVIEW(popView);
    }
    if ([receiver isKindOfClass:[UIView class]] || [receiver isKindOfClass:[UIViewController class]])
    {
        if ([receiver isKindOfClass:[UIViewController class]])
        {
            [[[receiver view] viewWithTag:BTVIEWCLICKONETAG] setUserInteractionEnabled:YES];
        }else
        {
            [[receiver viewWithTag:BTVIEWCLICKONETAG] setUserInteractionEnabled:YES];
        }
    }
}
//网络响应处理
- (void)handleRequest:(MagicRequest *)request
{
    
    DLogInfo(@"request.responseString ----- %@",request.responseString);
    if (request.succeed)
    {
        
        [self handleNetworkeback];
        NSDictionary *dict;
        
        @try{
            dict = [request.responseString JSONValue];
            
        }@catch(NSException *e){
            DLogInfo(@"request === %@", request);
        }
        if (!dict && [_cacheArr count] > 0)
        {
            dict = [NSMutableDictionary dictionaryWithDictionary:[_cacheArr objectAtIndex:0]];
            dict = [dict objectForKey:@"content"];
        }
        DLogInfo(@"request.responseString ----- %@",request.responseString);
        JsonResponse *respose = [JsonResponse JSONReflection:dict];
        
        
        [receiver handleRequest:request receiveObj:respose];
        
        return;
        
        switch (respose.response)
        
        
        {
            case khttpsucceedCode /*| khttpfailCode*/:
            case khttpfailCode:
                if (receiver && [receiver respondsToSelector:@selector(handleRequest:receiveObj:)])
                {
                    
                    if (respose.response == khttpsucceedCode)
                    {
                        [self handleSql:request response:respose];
                    }else
                    {
                        if (SHARED.isLogin || [[_requestDict objectForKey:@"do"] isEqualToString:kSecurityLogin])
                        {
                            [DYBShareinstaceDelegate loadFinishAlertView:respose.message target:receiver showTime:1.f];
                        }
                        
                    }
                    
                    [receiver handleRequest:request receiveObj:respose];
                    
                }
                
                break;
                
            case khttpWrongfulCode:
            {
                [receiver handleRequest:request receiveObj:respose];
            }
                break;
            case khttpJSONError://json解析失败
            case khttpSessIDtimeoutCode:
            {
                SHARED.isSessionTimeOut = YES;
                [request cancelAllRequest];
                if (receiver && [receiver respondsToSelector:@selector(handleRequest:receiveObj:)])
                {
                    [DYBShareinstaceDelegate loadFinishAlertView:@"未操作时间过长，请重新登陆" target:receiver showTime:.8f];
                    [receiver handleRequest:request receiveObj:respose];
                    
                    [SHARED deleteSql];
                    
                    double delayInSeconds = 0.5;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        AppDelegate *delegate = APPDELEGATE;
                        [[delegate navi] popToFirstViewControllerAnimated:YES];
                    });
                }
                
                
            }
                break;
            case khttpSecurityCode:
                
                break;
            case khttpWrongfulAppCode:
            {
                
            }
                break;
            case khttpNeedUpdateCode:
            {
                NSDictionary *data = [dict objectForKey:@"data"];
                NSString *content = [[data objectForKey:@"version"] objectForKey:@"content"];
                DYBDataBankShotView *showView  = [DYBShareinstaceDelegate addConfirmViewTitle:@"版本更新" MSG:content targetView:APPDELEGATE.window targetObj:APPDELEGATE btnType:BTNTAG_TEXTVIEW];
                [showView setUserInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:dict, @"dict", nil]];
            }
                
                
                break;
            case khttpUpdateCode:
            {
                NSDictionary *data = [dict objectForKey:@"data"];
                NSString *content = [[data objectForKey:@"version"] objectForKey:@"content"];
                DYBDataBankShotView *showView  = [DYBShareinstaceDelegate addConfirmViewTitle:@"版本更新" MSG:content targetView:APPDELEGATE.window targetObj:APPDELEGATE btnType:BTNTAG_TEXTVIEWSINGLE];
                [showView setUserInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:dict, @"dict", nil]];
                [showView setNoNeedRemove:YES];
            }
                break;
            case khttpWrongfulVersionCode:
                
                break;
                
            default:
                break;
        }
    }else if (request.failed)
    {
        
        [self handleNetworkeback];        
        if (_cacheArr && [_cacheArr count] > 0)
        {//为了读取缓存
            [request changeState:STATE_SUCCEED];
            
        }else
        {//网络请求失败
            [DYBShareinstaceDelegate loadFinishAlertView:@"网络异常，请重试" target:receiver showTime:.8f];
            if (receiver && [receiver respondsToSelector:@selector(handleRequest:receiveObj:)])
            {
                NSDictionary *dict = [request.responseString JSONValue];
                JsonResponse *respose = [JsonResponse JSONReflection:dict];
                
                [receiver handleRequest:request receiveObj:respose];
            }
        }
    }else if (request.created)
    {
        DLogInfo(@"1");
    }else if (request.sending)
    {
        DLogInfo(@"2");
    }else if (request.recving)
    {
        DLogInfo(@"3");
        [self handleSpecialInterface:nil];
    }
}

//处理接口特殊处理
- (void)handleSpecialInterface:(NSDictionary *)params
{
    NSString *getMethod = nil;
    if (params)
    {
        getMethod = [params objectForKey:INTERFACEDOACTION];
    }else
    {
        getMethod = [_requestDict objectForKey:@"do"];
    }
    
    
    //登陆接口
    if ([getMethod isEqualToString:kSecurityLogin] ||
        [getMethod isEqualToString:kSecurityAutologin] ||
        [getMethod isEqualToString:kSecurityReg])
    {
        SHARED.isLogined = YES;
    }
}

//数据库处理
- (void)handleSql:(MagicRequest *)request response:(id)_response
{
    JsonResponse *response = (JsonResponse *)_response;
    
    NSString *getMethod = [_requestDict objectForKey:@"do"];
    
    //登陆接口
    if ([getMethod isEqualToString:kSecurityLogin] ||
        [getMethod isEqualToString:kSecurityAutologin] ||
        [getMethod isEqualToString:kSecurityReg])
    {
        
        if (![getMethod isEqualToString:kSecurityAutologin])
        {
            SHARED.isLoginMethod = YES;
        }
        
        SHARED.isLogin = YES;
        SHARED.curUser = [user JSONReflection:[[response data] objectForKey:@"user"]];
        SHARED.sessionID = response.sessID;
        SHARED.currentUserSetting = [[UserSettingMode alloc]init];
        DLogInfo(@"SHARED.curUser === %@", SHARED.curUser.pic_s);
        DLogInfo(@"SHARED.curUser.userid === %@", SHARED.curUser.userid);
        [self insertUser:SHARED.curUser];
        SHARED.userId = SHARED.curUser.userid;
        
        //        SHARED.curUser = [user JSONReflection:[[response data] objectForKey:@"user"]];
        
        SHARED.currentUserSetting = [[UserSettingMode alloc] init:[[DYBLocalDataManager sharedInstance] getUserSetting:SHARED.curUser.userid]];
        NSArray *pushTag = [SHARED.curUser.push_tag componentsSeparatedByString:@","];
        
        BOOL isPushEvaluate = NO;
        BOOL isPushAtMe = NO;
        BOOL isPushPrivate = NO;
        BOOL isPushAddMe = NO;
        BOOL isPushTeacher = NO;
        BOOL isJOBpUSH = NO;
        BOOL isdatabase = NO;
        BOOL isWifi = NO;
        BOOL isNotesWifi = NO;
        BOOL isNotesSave = NO;
        for (int i = 0; i < [pushTag count]; i++) {
            if ([[pushTag objectAtIndex:i] isEqualToString:@"5"]) {
                isPushEvaluate = YES;
            }else if ([[pushTag objectAtIndex:i] isEqualToString:@"6"]){
                isPushAtMe = YES;
            }else if ([[pushTag objectAtIndex:i] isEqualToString:@"8"]){
                isPushPrivate = YES;
            }else if ([[pushTag objectAtIndex:i] isEqualToString:@"10"]){
                isPushAddMe = YES;
            }else if ([[pushTag objectAtIndex:i] isEqualToString:@"11"]){
                isPushTeacher = YES;
            }else if ([[pushTag objectAtIndex:i] isEqualToString:@"12"]){
                isJOBpUSH = YES;
            }else if ([[pushTag objectAtIndex:i] isEqualToString:@"13"]){
                isdatabase = YES;
            }else if ([[pushTag objectAtIndex:i] isEqualToString:@"14"]){
                isWifi = YES;
            }else if ([[pushTag objectAtIndex:i] isEqualToString:@"15"]){
                isNotesWifi = YES;
            }else if ([[pushTag objectAtIndex:i] isEqualToString:@"16"]){
                isNotesSave = YES;
            }
        }
        [SHARED.currentUserSetting setEvaluatePush:isPushEvaluate];
        [SHARED.currentUserSetting setAtMePush:isPushAtMe];
        [SHARED.currentUserSetting setPrivateMessagePush:isPushPrivate];
        [SHARED.currentUserSetting setAddMePush:isPushAddMe];
        [SHARED.currentUserSetting setTeacherPush:isPushTeacher];
        [SHARED.currentUserSetting setJobPush:isJOBpUSH];
        [SHARED.currentUserSetting setDataBasePush:isdatabase];
        [SHARED.currentUserSetting setWifiForPush:isWifi];
        [SHARED.currentUserSetting setNotesWifiForPush:isNotesWifi];
        [SHARED.currentUserSetting setNotesSaveForPush:isNotesSave];
        
        if (SHARED.curUser.disturb_time && SHARED.curUser.disturb_time.length > 0) {
            [SHARED.currentUserSetting setTimeForNoPush:YES];
        }
        
        [[DYBLocalDataManager sharedInstance] saveUserSetting:[[SHARED.currentUserSetting dict] JSONFragment] key:@""];
        [[DYBLocalDataManager sharedInstance] setCurrentUserSetting:SHARED.currentUserSetting];
        
        
        //加载左视图
        [[DYBUITabbarViewController sharedInstace] initLeftView];
        
        [DYBHttpMethod user_setting:NO receive:self];
    }else if ([getMethod isEqualToString:kSecurityLogout])
    {//退出接口
        [SHARED deleteSql];
        
    }else if ([getMethod isEqualToString:kStatusList])
    {//动态列表
        NSDictionary *data = [_requestDict objectForKey:@"data"];
        NSString *type = [data objectForKey:@"type"];
        
        if ([type isEqualToString:@"1"])
        {//个人动态
            [self insertStatusList:_response request:request type:1];
        }else if ([type isEqualToString:@"2"])
        {//好友动态
            [self insertStatusList:_response request:request type:2];
        }
        
        
    }else if ([getMethod isEqualToString:kStatusDel])
    {//删除动态
        NSDictionary *data = [_requestDict objectForKey:@"data"];
        NSString *delId = [data objectForKey:@"id"];
        
        //删除好友动态
        self.DB.FROM(kYIBANSTATUSLISTTABLE).WHERE(@"type", @"2").GET();
        NSArray *sqlArr = self.DB.resultArray;
        //获得数据库中的动态列
        [self deleteStatuWithId:sqlArr delId:delId];
        
        //删除个人动态
        self.DB.FROM(kYIBANSTATUSLISTTABLE).WHERE(@"type", @"1").GET();
        sqlArr = self.DB.resultArray;
        //获得数据库中的动态列
        [self deleteStatuWithId:sqlArr delId:delId];
        
        
        
    }else if ([getMethod isEqualToString:@"navigate_list"]){
        
        NSDictionary *data = [_requestDict objectForKey:@"data"];
        NSString *nav_id = [data objectForKey:@"navigate"];
        NSString *page = [data objectForKey:@"page"];
        //        [self insertStatusList:_response request:request type:3];
        //        [self insertDatabankList:_response request:nav_id];
        
        self.DB.FROM(kDATABANKCACHE)
        .SET(@"content", request.responseString)
        .SET(@"navlist", nav_id)
        .SET(@"page",page)
        .SET(@"userid", SHARED.userId)
        .INSERT();
    }
    
    
}

//处理缓存方法
- (NSArray *)handleCache:(NSDictionary *)dict
{
    NSString *method = [dict objectForKey:INTERFACEDOACTION];
    if ([method isEqualToString:kStatusList])
    {
        NSString *type = [dict objectForKey:@"type"];
        
        NSString *maxid = [dict objectForKey:@"max_id"];
        NSString *lastId = [dict objectForKey:@"last_id"];
        NSString *page = [dict objectForKey:@"page"];
        NSString *num = [dict objectForKey:@"num"];
        NSString *userid = [dict objectForKey:@"userid"];
        NSString *sinceId = [dict objectForKey:@"since_id"];
        
        NSInteger delIndex = [page integerValue];
        NSInteger numNum = [num integerValue];
        
        if (([type intValue] == 2 && !maxid && [lastId isEqualToString:@"0"]) ||
            ([type intValue] == 1 && [sinceId isEqualToString:@"0"]))//第一次请求
        {
            self.DB.FROM(kYIBANSTATUSLISTTABLE).WHERE(@"type", type).WHERE(@"userid", userid).GET();
            
            NSArray *result = [self deleteStatuWithNum:self.DB.resultArray delIndex:delIndex getNum:numNum];
            DLogInfo(@"result == %d", [result count]);
            
            return result;
        }else if(lastId && [maxid isEqualToString:@"0"])
        {//加载更多
            
            
            self.DB.FROM(kYIBANSTATUSLISTTABLE).WHERE(@"type", type).WHERE(@"userid", userid).GET();
            
            NSArray *result = [self deleteStatuWithNum:self.DB.resultArray delIndex:delIndex getNum:numNum];
            
            return result;
            
        }else if([lastId isEqualToString:@"0"] && maxid)
        {//更新
            self.DB.FROM(kYIBANSTATUSLISTTABLE).WHERE(@"type", type).WHERE(@"userid", userid).DELETE();
        }
    }else  if ([method isEqualToString:@"navigate_list"])
    {
        
        
        NSString *navigate  = [dict objectForKey:@"navigate"];
        NSString *page = [dict objectForKey:@"page"];
        [self haveNETdelDataBank:navigate page:page];
        
        self.DB.FROM(kDATABANKCACHE).WHERE(@"navlist", navigate).WHERE(@"userid",SHARED.userId).WHERE(@"page",page).GET();
        
        NSArray *result = self.DB.resultArray ;
        return result;
        
    }
    
    return nil;
}

//有网删除databank数据
-(void)haveNETdelDataBank:(NSString *)strNav  page:(NSString *)page{
    
    if ([MagicDevice hasInternetConnection] == YES) {
        
        self.DB.FROM(kDATABANKCACHE).WHERE(@"userid", SHARED.userId).WHERE(@"navlist", strNav).WHERE(@"page",page).DELETE();
        
    }
    
}

//分页返回动态列表
- (NSArray *)deleteStatuWithNum:(NSArray *)sqlArr delIndex:(NSInteger)delIndex getNum:(NSInteger)getNum
{
    if ([sqlArr count] > 0) {
        NSMutableDictionary *dictsql = [NSMutableDictionary dictionaryWithDictionary:[sqlArr objectAtIndex:0]];
        
        NSMutableDictionary *dictContentSql = [[dictsql objectForKey:@"content"] JSONValue];
        NSMutableArray *sqlStausList = [[dictContentSql objectForKey:@"data"] objectForKey:@"status"];
        
        NSInteger deleNum = (delIndex * getNum);
        NSInteger sqlNum = [sqlStausList count];
        if (sqlNum >= deleNum)
        {
            [sqlStausList removeObjectsInRange:NSMakeRange(deleNum, (sqlNum - deleNum))];
            
            if (delIndex > 1)
            {
                [sqlStausList removeObjectsInRange:NSMakeRange(0, ((delIndex-1) * getNum))];
            }
        }else
        {
            return nil;
        }
        NSString *content = [dictContentSql JSONString];
        [dictsql setValue:content forKey:@"content"];
        NSArray *result = [NSArray arrayWithObject:dictsql];
        return result;
    }
    
    return nil;
}

//删除动态数据
- (void)deleteStatuWithId:(NSArray *)sqlArr delId:(NSString *)delId
{
    if ([sqlArr count] > 0) {
        NSMutableDictionary *dicsql = [NSMutableDictionary dictionaryWithDictionary:[sqlArr objectAtIndex:0]];
        JsonResponse *sqlRespose = [JsonResponse JSONReflection:[dicsql objectForKey:@"content"]];
        status_list *sqlStatusList = [status_list JSONReflection:[sqlRespose data]];
        NSMutableDictionary *dictSql = [[dicsql objectForKey:@"content"] JSONValue];
        NSMutableArray *sqlStausList = [[dictSql objectForKey:@"data"] objectForKey:@"status"];
        NSMutableArray *sqlStatusArr = [NSMutableArray arrayWithArray:[sqlStatusList status]];
        
        for (int i = 0; i < [sqlStausList count]; i++)
        {
            status *sqlStatu = [sqlStatusArr objectAtIndex:i];
            NSString *statuId = [NSString stringWithFormat:@"%d", [sqlStatu id]];
            
            if ([statuId isEqualToString:delId])
            {
                [sqlStausList removeObjectAtIndex:i];
                break;
            }
            
        }
        
        if ([sqlStausList count ] < [[sqlStatusList status] count])
        {
            NSString *saveString = [dictSql JSONFragment];
            if (saveString)
            {
                self.DB.FROM(kYIBANSTATUSLISTTABLE).SET(@"content", saveString).UPDATE();
            }
        }
    }
}

//保存个人动态和好友动态
- (void)saveStatus:(NSString *)type request:(MagicRequest *)request statusList:(status_list *)statusList firstStatu:(status *)firstStatu
{
    self.DB.FROM(kYIBANSTATUSLISTTABLE).WHERE(@"type", type).WHERE(@"userid",SHARED.userId).GET();
    
    if ([self.DB.resultArray count] > 0)
    {
        NSDictionary *d = [self.DB.resultArray objectAtIndex:0];
        //获得数据库中的动态列表
        NSMutableDictionary *dicsql = [[NSMutableDictionary alloc] initWithDictionary:d];
        
        NSString *strContent = [dicsql objectForKey:@"content"];
        
        NSMutableDictionary *dictContent = [strContent JSONValue];
        DLogInfo(@"dict === %@", [dictContent objectForKey:@"data"]);
        
        JsonResponse *sqlRespose = [JsonResponse JSONReflection:dictContent];
        status_list *sqlStatusList = [status_list JSONReflection:[sqlRespose data]];
        status *firstSqlStatu = [[sqlStatusList status] objectAtIndex:0];
        
        NSMutableArray *sqlStausList = [[dictContent objectForKey:@"data"] objectForKey:@"status"];
        
        if (firstSqlStatu.id > firstStatu.id)
        {
            NSString *requstString = [request responseString];
            NSDictionary *reqestDict = [requstString JSONValue];
            NSDictionary *requestdictData = [reqestDict objectForKey:@"data"];
            NSMutableArray *requestDataArr = [requestdictData objectForKey:@"status"];
            [sqlStausList addObjectsFromArray:requestDataArr];
            [[dictContent objectForKey:@"data"] setValue:sqlStausList forKey:@"status"];
            
            NSString *saveString = [dictContent JSONFragment];
            if (saveString)
            {
                self.DB.FROM(kYIBANSTATUSLISTTABLE)
                .SET(@"content", saveString)
                .WHERE(@"type", type)
                .WHERE(@"userid", SHARED.userId)
                .UPDATE();
            }
            
        }else if (firstSqlStatu.id == firstStatu.id)
        {
            //我啥都不去做
            
        }else
        {
            self.DB.FROM(kYIBANSTATUSLISTTABLE)
            .WHERE(@"type", type)
            .WHERE(@"userid", SHARED.userId)
            .DELETE();
            self.DB.FROM(kYIBANSTATUSLISTTABLE)
            .SET(@"content", request.responseString)
            .SET(@"type", type)
            .SET(@"userid", SHARED.userId)
            .INSERT();
        }
        
        RELEASEDICTARRAYOBJ(dicsql);
        
    }else
    {
        
        DLogInfo(@"SHARED.curUser.useri === %@", SHARED.userId);
        self.DB.FROM(kYIBANSTATUSLISTTABLE)
        .SET(@"content", request.responseString)
        .SET(@"type", type)
        .SET(@"userid", SHARED.userId)
        .INSERT();
    }
}

//保存动态
- (void)insertStatusList:(id)_response request:(MagicRequest *)request type:(NSInteger)type
{
    JsonResponse *response = (JsonResponse *)_response;
    status_list *statusList = [status_list JSONReflection:[response data]];
    if (![[statusList status] count] > 0)
    {
        return;
    }
    
    status *firstStatu = [[statusList status] objectAtIndex:0];
    
    if (type == 1)
    {
        [self saveStatus:@"1" request:request statusList:statusList firstStatu:firstStatu];
        
    }else if(type == 2)
    {
        [self saveStatus:@"2" request:request statusList:statusList firstStatu:firstStatu];
    }
    
}

//保存user表
- (void)insertUser:(user *)userModel
{
    NSString *username = [[_requestDict objectForKey:@"data"] objectForKey:@"username"];
    NSString *password = [[_requestDict objectForKey:@"data"] objectForKey:@"password"];
    NSString *userid = [userModel userid];
    NSString *sessionId = SHARED.sessionID;
    NSString *logintype = @"1";
    
    NSDateFormatter *formatter = [SHARED dateFormatter];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate new];
    NSString *logintime = [formatter stringFromDate:date];;
    
    self.DB.FROM(kYIBANUSERTABLE).WHERE(@"userid", userid).GET();
    DLogInfo(@"self.DB.resultArray === %@", self.DB.resultArray);
    if ([self.DB.resultArray count] > 0)
    {
        self.DB.FROM(kYIBANUSERTABLE).SET(@"sessionID", sessionId).SET(@"logintime", logintime).SET(@"logintype", logintype).UPDATE();
    }else
    {
        self.DB.FROM(kYIBANUSERTABLE).SET(@"username", username).SET(@"password", password).SET(@"userid", userid).SET(@"sessionID", sessionId).SET(@"logintime", logintime).SET(@"logintype", logintype).INSERT();
    }
}

@end
