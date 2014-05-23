//
//  MainViewController.h
//  Magic
//
//  Created by 周 哲 on 12-10-29.
//
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
//#import "HttpCon_delegate.h"
//#import "MainConrtrollerCell.h"
//#import "QuadCurveMenu.h"
//#import "two-dimension codeViewController.h"

//#import "YIBanAlertView.h"
//#import "Publish.h"
@class user;
@interface MainViewController : HomeViewController
{
    MainViewController *_mainViewController;
    UIScrollView *_rightcontent; 
    NSMutableArray *status; // 动态的数据
    BOOL bAutoLogin; // 是否自动登陆
    NSString *strName; // 用户姓名
    NSString *strPic; // 用户头像
//    MessageDynamicViewController *dynamic; // 动态页面

}
@property (nonatomic,retain) MainViewController *mainViewController;
@property (nonatomic,retain) NSMutableArray *status;
@property (nonatomic,assign) BOOL bAutoLogin;
@property(nonatomic,retain) NSString *strName;
@property(nonatomic,retain)  NSString *strPic;
//@property(nonatomic,retain)  MessageDynamicViewController *dynamic;


+(MainViewController *)share;
//+(MainViewController*)getMainViewController;
//+(MainViewController*)setMainViewController:(MainViewController*)_main;
-(void)addViewOne;
-(void)addViewTwo;
-(void)addViewFive;
-(void)addViewThree:(BOOL)isOtherPeople user:(user *)user;
-(void)addViewFour;
- (void)addViewSix;
-(void)addViewSeven;
-(void)addViewEight;
- (void)releaseShare; // 释放内存
-(void)addViewNine;
-(void)refresh_notification; //刷新，动态页面
-(void)stopTimer; // 停止定时器
-(void)removeSubViews:(BOOL)isSound;
-(void)doSomething;
-(void)addVIewTen;
-(void)del_reload;
-(void)dynamic_send_reflash;
-(void)home_del_reflash;
-(void)home_relaod;
@end
