//
//  AppDelegate.m
//  DYiBan
//
//  Created by NewM on 13-7-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "AppDelegate.h"

#import "DYBHttpMethod.h"
#import "DYBLoginViewController.h"
#import "Magic_NavigationController.h"
#import "Magic_NaviGroupViewController.h"
#import "DYBMapView.h"
#import "user.h"
#import "WOSLogInViewController.h"
#import "DYBSendPrivateLetterViewController.h"
#import "DYBSystemMsgViewController.h"
#import "DYBNoticeViewController.h"
#import "DYBMentionedMeViewController.h"
#import "DYBCommentMeViewController.h"
#import "DYBEmployInfoViewController.h"

@implementation AppDelegate
{
//    MagicNavigationController *navi;
    UIPageControl *pageCtrl;
    MagicUIImageView *backImv;
    UIScrollView *scroll;
    MagicUIButton *startBtn;
}
@synthesize window = _window;
@synthesize navi = _navi;
- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    /**IOS7
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window.clipsToBounds =YES;
    self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height);
    self.window.bounds = CGRectMake(0,0, self.window.frame.size.width, self.window.frame.size.height);
    [[NSUserDefaults standardUserDefaults] setFloat:self.window.frame.size.height forKey:@"windowHeight"];
    */
    
    //创建数据库
    [DYBShareinstaceDelegate creatTable];
    

    SHARED.httpUrl = WOSLOCALHOST;
    SHARED.messageHttpUrl = ShengchanMessage;
    
    if (SHARED.imei.length == 0) {
//        MagicRequest *request = [DYBHttpMethod security_authtag:NO receive:self];
//        [request setTag:3];
    }
    
    [MagicUIKeyboard sharedInstace];
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self initAppdelegate];
    [self loginMethod];
#if !TARGET_IPHONE_SIMULATOR
    //注册推送通知
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeSound |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeBadge];
#endif

    
    //*****************百度地图Marker******************
    //*******以下5行代码不要删，是百度地图注册！！！********
    //************************************************
//    _mapManager = [[BMKMapManager alloc]init];
//    BOOL ret = [_mapManager start:@"617FCCA9F13CB57FCCFB3AF4F4356367248A9BBA" generalDelegate:self];
//    if (!ret) {
//    	NSLog(@"manager start failed!");
//    }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
   
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//推送服务注册成功后回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *string = [[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
    SHARED.token = [NSString stringWithFormat:@"%@",string];

}

//推送注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSMutableDictionary *apsDict = [userInfo objectForKey:@"aps"];
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive)
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        if (SHARED.isLogin)
        {
            NSString *mtType = [[apsDict objectForKey:@"mt"] description];
            if ([mtType isEqualToString:@"8"])
            {//有私信
                MagicRequest *request = [DYBHttpMethod user_detail:[apsDict objectForKey:@"ui"] isAlert:YES receive:self];
                [request setTag:2];
            }else if([mtType isEqualToString:@"5"] )
            {//评价
                DYBCommentMeViewController *vc = [[DYBCommentMeViewController alloc] init];
                [_navi pushViewController:vc animated:YES];
                RELEASE(vc);
            }else if ([mtType isEqualToString:@"6"])
            {//@我
                DYBMentionedMeViewController *vc = [[DYBMentionedMeViewController alloc] init];
                [_navi pushViewController:vc animated:YES];
                RELEASE(vc);
            }else if ([mtType isEqualToString:@"11"])
            {//辅导员通知

                DYBNoticeViewController *vc = [[DYBNoticeViewController alloc] init];
                [_navi pushViewController:vc animated:YES];
                RELEASE(vc);
            }else if ([mtType isEqualToString:@"10"])
            {//加好友
                
                DYBSystemMsgViewController *vc = [[DYBSystemMsgViewController alloc] init];
                [_navi pushViewController:vc animated:YES];
                RELEASE(vc);
            }else if ([mtType isEqualToString:@"12"])
            {//就业信息
                DYBEmployInfoViewController *vc = [[DYBEmployInfoViewController alloc] init];
                [_navi pushViewController:vc animated:YES];
                RELEASE(vc);
            }
        }
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [self DYB_GetUserLocationInfo];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"backApp" object:nil];
}


#pragma mark - 
#pragma mark - method
- (void)loginMethod
{
//    MagicRequest *request = [DYBHttpMethod site_version:YES receive:self];
//    [request setTag:1];
    
    NSDictionary *userDict = [DYBShareinstaceDelegate userList];
    if (userDict)
    {
//        SHARED.sessionID = [userDict objectForKey:@"sessionID"];
        SHARED.userId = [userDict objectForKey:@"userid"];
        
//        MagicRequest *request = [DYBHttpMethod user_security_autologin:YES receive:self];
//        [request setTag:1];
        
        DYBUITabbarViewController *vc = [[DYBUITabbarViewController sharedInstace] init:[[_navi viewControllers] objectAtIndex:0]];
        
        [_navi pushViewController:vc animated:NO];
        
        SHARED.isLoginMethod = YES;
    }
}

- (void)initAppdelegate
{

    NSString *str = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSArray *a = [str componentsSeparatedByString:@"."];
    NSString *intStr = [@"" stringByAppendingFormat:@"%@%@%@",[a objectAtIndex:0],[a objectAtIndex:1],[a objectAtIndex:2]];
    int vers = [intStr intValue];
    
//    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"version"] intValue] < vers){
//        
//        [[NSUserDefaults standardUserDefaults] setValue:intStr forKey:@"version"];
//        
//        
//        UIImage *image;
//        NSArray *photoArray;
//        
//        if (CGRectGetHeight(self.window.frame) > 480) {
//            
//            photoArray = @[@"start_1_ip5",@"start_2_ip5",@"start_3_ip5",@"start_4_ip5"];
//            image = [UIImage imageNamed:@"bg_guide_ip5"];
//        }else {
//            photoArray = @[@"start_1",@"start_2",@"start_3",@"start_4"];
//            image = [UIImage imageNamed:@"bg_guide"];
//        }
//        
//        
//        
//        //蓝色背景
//        backImv = [[MagicUIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.window.frame), CGRectGetHeight(self.window.frame))];
//        backImv.userInteractionEnabled = YES;
//        [backImv setImage:image];
//        [self.window addSubview:backImv];
//        
//        //scroll
//        scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.window.frame), CGRectGetHeight(self.window.frame))];
//        scroll.backgroundColor = [UIColor clearColor];
//        scroll.pagingEnabled = YES;
//        scroll.delegate = self;
//        scroll.showsHorizontalScrollIndicator = NO;
//        [backImv addSubview:scroll];
//        
//        //page
//        pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.window.frame) - 30, CGRectGetWidth(self.window.frame), 30)];  //创建UIPageControl，位置在屏幕最下方。
//        pageCtrl.numberOfPages = [photoArray count];//总的图片页数
//        pageCtrl.currentPage = 0;//当前页
////        [pageCtrl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];  //用户点击UIPageControl的响应函数
//        [self.window addSubview:pageCtrl];  //将UIPageControl添加到主界面上。
//        
//        //创建开始按钮
//        UIImage *start_def = [UIImage imageNamed:@"btn_start_def"];
//        UIImage *start_press = [UIImage imageNamed:@"btn_start_press"];
//        startBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.window.frame)-start_def.size.height/2-50, start_def.size.width/2, start_def.size.height/2)];
//        [startBtn setImage:start_def forState:UIControlStateNormal];
//        [startBtn setImage:start_press forState:UIControlStateNormal];
//        [startBtn addTarget:self action:@selector(startBegin) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        for (int i = 0; i <[photoArray count] ; i++) {
//            
//            MagicUIImageView *imv = [[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.window.frame)*i, 0, CGRectGetWidth(self.window.frame), CGRectGetHeight(self.window.frame))];
//            imv.backgroundColor = [UIColor clearColor];
//            UIImage *image = [UIImage imageNamed:[photoArray objectAtIndex:i]];
//            [imv setImage:image];
//            imv.userInteractionEnabled = YES;
//            
//            if (i == [photoArray count]-1) {
//                
//                [imv addSubview:startBtn];
//            }
//            
//            
//            [scroll addSubview:imv];
//            RELEASE(imv);
//        }
//
//        [scroll setContentSize:CGSizeMake(CGRectGetWidth(self.window.bounds)*[photoArray count], CGRectGetHeight(self.window.bounds))];
//        
//        
//    }else{
        _navi = [MagicNavigationController stack:@"" firstViewClass:[WOSLogInViewController class]];
        [_navi setNavigationBarHidden:YES];
        
        MagicNaviGroupViewController *naviGroup = [MagicNaviGroupViewController naviStatckGroupWithFirstStack:_navi];
        
        [self.window setRootViewController:naviGroup];
//    }
    
}

- (void)startBegin {
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        backImv.alpha = 0;
        scroll.alpha = 0;
        startBtn.alpha = 0;
        pageCtrl.alpha = 0;
        
        
    }completion:^(BOOL b){//
        
        if (b) {
            
            RELEASEVIEW(backImv);
            RELEASEVIEW(scroll);
            RELEASEVIEW(startBtn);
            RELEASEVIEW(pageCtrl);
            
            _navi = [MagicNavigationController stack:@"" firstViewClass:[WOSLogInViewController class]];
            [_navi setNavigationBarHidden:YES];
            
            MagicNaviGroupViewController *naviGroup = [MagicNaviGroupViewController naviStatckGroupWithFirstStack:_navi];
            
            [self.window setRootViewController:naviGroup];
        }
        
        
    }];

    
    
    
    
}

#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageCtrl setCurrentPage:offset.x / bounds.size.width];
}


#pragma mark -
#pragma mark - http
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    JsonResponse *response = receiveObj;
    if (request.tag == 1)
    {//自动登陆
        
        if ([response response] == khttpfailCode || [response response] == khttpSessIDtimeoutCode)
        {//自动登陆失败
            
        }else if([response response] == khttpsucceedCode)
        {
            
        }
    }else if (request.tag == 2)
    {//获得私信用户资料
        if([response response] == khttpsucceedCode)
        {
            user *userDetail = [user JSONReflection:[[response data] objectForKey:@"user"]];
            
            DYBSendPrivateLetterViewController *vc = [[DYBSendPrivateLetterViewController alloc] init];
            vc.model=[NSDictionary dictionaryWithObjectsAndKeys:userDetail.userid,@"userid",userDetail.name,@"name",userDetail.pic,@"pic", nil];
            [_navi pushViewController:vc animated:YES];
        }
    }else if (request.tag == 3)//获取唯一标示嘛
    {
        if ([response response] == khttpsucceedCode)
        {
            [[NSUserDefaults standardUserDefaults] setValue:[[response data] objectForKey:@"tag"] forKey:@"markup"];
        }else if([response response] == khttpfailCode)
        {
            
        }
    }
}

#pragma mark -
#pragma mark - 返回易班时获取用户位置信息
- (void)DYB_GetUserLocationInfo{
    if (SHARED.isLogin)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            DYBMapView *_map = [[DYBMapView alloc] init];
        });
    }
    
}

#pragma mark - 
#pragma mark - DYBDataBankShotView
- (void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal
{
    DYBDataBankShotView *showView = [signal source];
    NSDictionary *dict = [showView userInfo];
    NSDictionary *data = [[dict objectForKey:@"dict"] objectForKey:@"data"];

    
    NSString *url = [[data objectForKey:@"version"] objectForKey:@"url"];
    if ([[showView type] isEqualToString:[NSString stringWithFormat:@"%d", BTNTAG_TEXTVIEW]])
    {
        if ([signal is:[DYBDataBankShotView RIGHT]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }else if ([[showView type] isEqualToString:[NSString stringWithFormat:@"%d", BTNTAG_TEXTVIEWSINGLE]])
    {
        if ([signal is:[DYBDataBankShotView RIGHT]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
    
}
@end
