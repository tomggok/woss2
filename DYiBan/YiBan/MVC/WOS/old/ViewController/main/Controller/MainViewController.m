//
//  MainViewController.m
//  Magic
//
//  Created by 周 哲 on 12-10-29.
//
//

#import "MainViewController.h"
#import "ASIHTTPRequest.h"
//#import "Rrequest_Data.h"
//#import "Static.h"
//#import "HttpHelp.h"
#import "JsonResponse.h"
//#import "HttpHelp.h"
//#import "Rrequest_Data.h"
#import "user.h"
//#import "MessageForMeViewController.h"
#import "MessageDynamicViewController.h"
//#import "PullDownView.h"
//#import "Publish.h"
//#import "FriendsView.h"
//#import "SearchFriendsView.h"
//#import "SettingView.h"
//#import "UserClassView.h"
//#import "XinhuaNewsView.h"
//#import "CheckinMainViewController.h"
#import "CheckVersionModel.h"
//#import "PersonalPageViewController.h"
//#import "PersonalPageView.h"
//#import "YiBanLocalDataManager.h"
#import "leftViewController.h"
#import "RightViewController.h"
//#import "YiBanHeadBarView.h"
#import "UserLoginModel.h"
#import "UserSettingMode.h"
#import "LLSplitViewController.h"
#import "version.h"
//#import "CommonHelper.h"
#import "UIImageView+WebCache.h"
//#import "beforeScanView.h"
//#import "FindWorkView.h"

#import "WOSGoodFoodViewController.h"
@interface MainViewController ()
{
    NSString *updateUrl;//
//    YIBanAlertView *alertView;//弹出框
}
@end

@implementation MainViewController
@synthesize mainViewController;
@synthesize status;
@synthesize bAutoLogin;
@synthesize strName;
@synthesize strPic;
//@synthesize dynamic;

static MainViewController *main = nil;
+(MainViewController *)share{
    if (!main) {
        main = [[MainViewController alloc] init];

    }
    return main;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    [super viewWillAppear: YES];

}

-(void)stopTimer{

//    [dynamic stopTimer];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f]];
    [self.view setBackgroundColor:[UIColor redColor]];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, 100.0f, 60.0f, 40.0f)];
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn release];
}
-(void)test{
    WOSGoodFoodViewController *tt = [[WOSGoodFoodViewController alloc]init];
    [self.navigationController pushViewController:tt animated:YES];


}
// 锁屏
-(void)addForbidView{
    [[LLSplitViewController getmainController].view setUserInteractionEnabled:NO];
//    YBLogInfo(@"我要锁住了！！！！");
    UIView *tempView = [[LLSplitViewController getmainController].view viewWithTag:9];
    if (tempView) {
        return;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.window.bounds.size.height)];
    [view setTag:9];
    [[LLSplitViewController getmainController].view addSubview:view];
//    [view setBackgroundColor:[UIColor  redColor]];
    [view release];

}
//换user 图片,收到通知后获取小图
-(void)changeUserImage:(id)sender{
    
    NSString *imageStr = [sender object];
    leftViewController *conLeft_ = [leftViewController share];
    [conLeft_.imageViewUser setImageWithURL:[NSURL URLWithString:imageStr]placeholderImage:[UIImage imageNamed:@"noface_32.png"]];
    
//    [self getUserInfo];


}

@end
