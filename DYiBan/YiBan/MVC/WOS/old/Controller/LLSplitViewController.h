//
//  LLSplitViewController.h
//  splitViewTest
//
//  Created by zeng tom on 12-10-8
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


//#define kCGRectLeftView  CGRectMake(0, 0, 320, 460)
#import "LLOverlayView.h"
#import "LLOverlayViewDelegate.h"
#import "DYBBaseViewController.h"
#define k_Notification_CloseKeyBoard  @"Notification_CloseKeyBoard"//关闭键盘通知

typedef enum
{
	KLLSplitViewStatu_Normal = 1,
	KLLSplitViewStatu_Left , //左边的视图出来  
	KLLSpiliViewStatu_Rigth  //右边的试图出来
}LLSplitViewStatu;

@interface LLSplitViewController : DYBBaseViewController
<LLOverlayViewDelegate,UINavigationControllerDelegate>
{
    UIViewController *_controllerLeft;//左边的视图
	UIViewController *_controllerRight;//右边的视图
	UINavigationController *_controllerHome;//中间的视图
	
	LLOverlayView *_overlayView; //触发点击事件的view
	LLSplitViewStatu _viewStatu; //view的状态
	
	UIViewController *_controllerShouldShow;
	CGPoint ptBegin; //拖动的时候的最开始的位置
	CGPoint currentCenter; //home当前的中心
}

@property (nonatomic, retain) UIViewController *controllerLeft;
@property (nonatomic, retain) UIViewController *controllerRight;
@property (nonatomic, retain) UINavigationController *controllerHome;
@property (nonatomic, retain) LLOverlayView *overlayView;
@property (nonatomic, assign) LLSplitViewStatu viewStatu;

@property (nonatomic, retain) UIViewController *controllerShouldShow;
// 单例
+(LLSplitViewController*) getmainController;
// 初始化 view ，将三屏的controller 联系起来
- (id)initWithLeftController:(UIViewController *)leftController_ rigthController:(UIViewController *)rigthController_  homeController:(UIViewController *)homeController_;
// 设置home navigation 控制 push 
- (void)genHomeViewControllerFromController:(UIViewController *)controller_;
// 添加view 到homecontroller的 view 中
- (void)showViewController:(UIViewController *)viewController_  animated:(BOOL)animated;
// 动画结束时调用 
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)showLeftView; //显示左边view

- (void)showLeftView:(BOOL)animated;//显示左边view 并有动画效果

- (void)showRightView:(BOOL)animated; // 显示右边，并有动画效果

- (void)showHomeView:(BOOL)animated;// 显示中间，并有动画效果

- (void)releaseShare; // 释放内存
-(void)backPop;
-(void)reloadData:(NSString *)name;
@end




