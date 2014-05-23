//
//  LLSplitViewController.m
//  splitViewTest
//
//  Created by zeng tom on 12-10-8
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
//#import "AnnotationDemoViewController.h"
#import "LLSplitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RightViewController.h"
//#import "PullDownView.h"
//#import "Msg_content_Controller.h"
#import "leftViewController.h"
#import "MainViewController.h"
//#import "UserGuideView.h"
//#import "Static.h"
#import "AppDelegate.h"
//#import "LoginController.h"
//#import "Debug.h"
#import "WOSGoodFoodViewController.h"

#define kOverlayWidth 44  //交叉不分的大小
#define kOverlayBufferWidth 10  //阻尼区间宽度

#define kGestureValideWidth 120 //拖动的时候判断显示的那个视图的 宽度

@implementation LLSplitViewController{

    UIImageView *shadow;
//    BOOL is
}
@synthesize controllerLeft = _controllerLeft;
@synthesize controllerRight = _controllerRight;
@synthesize controllerHome = _controllerHome;
@synthesize overlayView = _overlayView;
@synthesize viewStatu = _viewStatu;
@synthesize controllerShouldShow = _controllerShouldShow;


//将左中右三个viewcontroller赋值到本类中，实现控制，
/*
 leftController_  左边viewcontroller
 rigthController_ 右边viewcontroller
 homeController_  中间的viewcontroller
 */

- (id)initWithLeftController:(UIViewController *)leftController_ rigthController:(UIViewController *)rigthController_  homeController:(UIViewController *)homeController_
{
	if(self = [super init])
	{
        [self genHomeViewControllerFromController:homeController_];
      
		_viewStatu = KLLSplitViewStatu_Normal;
        self.controllerLeft = leftController_;
        self.controllerRight = rigthController_;
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.view.autoresizesSubviews = NO;
	self.view.autoresizingMask	= NO;
    
//    if(_viewStatu == KLLSplitViewStatu_Normal)
//	{
		[self.view addSubview:_controllerHome.view];
//        CGRect rect = [Static iphone5Frame];
		_controllerHome.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    
         // 添加阴影
         _controllerHome.view.layer.shadowPath =[UIBezierPath bezierPathWithRect:_controllerHome.view.bounds].CGPath;
        [[_controllerHome.view layer] setShadowOffset:CGSizeMake(2.5, 2.5)];
        [[_controllerHome.view layer] setShadowRadius:10];
        [[_controllerHome.view layer] setShadowOpacity:10];
        [[_controllerHome.view layer] setShadowColor:[UIColor blackColor].CGColor];

//	}
//    YBLogInfo(@"coming 22222");
	//将三个viewcontroller 的view add到主view中
	_controllerLeft.view.frame = self.view.bounds;
//    YBLogInfo(@"coming 33333");
	_controllerLeft.view.hidden = NO;
//    YBLogInfo(@"coming 444444");
	[self.view addSubview:_controllerLeft.view];
//    YBLogInfo(@"coming 55555");
	_controllerRight.view.frame = self.view.bounds;
//    YBLogInfo(@"coming 2222221321");
	_controllerRight.view.hidden = NO;
//    YBLogInfo(@"coming 4321u21");
	[self.view addSubview:_controllerRight.view];
//    YBLogInfo(@"coming 22222rjkl");
	[self.view bringSubviewToFront:_controllerHome.view];
//    YBLogInfo(@"coming 22222241njk");

    
      
}

-(void)reloadData:(NSString *)name{
    
    [self.headview setTitle:name];
    


}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[_controllerHome viewWillAppear:animated];
	[_controllerLeft viewWillAppear: animated];
	[_controllerRight viewWillAppear:animated];
    [[_controllerHome view] setAutoresizesSubviews:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    /*
	[_controllerHome viewDidAppear:animated];
	[_controllerLeft viewDidAppear:animated];
	[_controllerRight viewDidAppear:animated];*/
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    /*
	[_controllerHome viewWillDisappear:animated];
	[_controllerLeft viewWillDisappear:animated];
	[_controllerRight viewWillDisappear:animated];*/
}

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    /*
	[_controllerHome viewDidDisappear:animated];
	[_controllerLeft viewDidDisappear:animated];
	[_controllerRight viewDidDisappear:animated];*/
    
}


#pragma mark public methods
//手势滑动
-(void)pan:(UIPanGestureRecognizer *)pan_
{
//	YBLogInfo(@"UIPanGestureRecognizer");
	
	if([_controllerHome.viewControllers count] > 1)
		return;
	
	if(pan_.state == UIGestureRecognizerStateBegan)
	{
        //获得手势在主屏幕上的位置
		ptBegin = [pan_ translationInView:[[UIApplication sharedApplication] keyWindow]];
        
        NSLog(@"_controllerHome.view.center %f",_controllerHome.view.center.x);
//        if (_controllerHome.view.center.x < 160) {
            currentCenter = _controllerHome.view.center;
//        }
        
		
	}
	
	else if(pan_.state == UIGestureRecognizerStateChanged)
	{
		CGPoint ptEnd = [pan_ translationInView:[[UIApplication sharedApplication] keyWindow]];
		currentCenter.x = 160 + ptEnd.x - ptBegin.x;
		
        NSLog(@"_controllerHome.view.center.x %f",_controllerHome.view.center.x);
		if(_controllerHome.view.center.x < 160) // 中间页面滑到左边
		{
            return;
            _controllerLeft.view.hidden = YES;
			_controllerRight.view.hidden = NO;
            return;
		}
		else                                    //中间页面滑到右边
		{
            NSLog(@"currentCenter x %f",currentCenter.x);
            if (currentCenter.x >=160) {
                _controllerHome.view.center = currentCenter; //设置中间页面中心
                shadow.center = currentCenter; //设置阴影页面中心
                _controllerLeft.view.hidden = NO;
                _controllerRight.view.hidden = YES;
            }
		}
	}
	
	else if(pan_.state == UIGestureRecognizerStateEnded)
	{
		CGPoint ptEnter = _controllerHome.view.center;
		
		if(ptEnter.x > 320 - kGestureValideWidth)
		{
			[self showLeftView:YES];
		}
		
		//向左滑 不方便，
		else if(ptEnter.x < kGestureValideWidth - 160 + 20 + 80) 
		{
            return;
			[self showRightView:YES];
		}
        else{
			[self showHomeView:YES];
		}
	}
}

- (void)genHomeViewControllerFromController:(UIViewController *)controller_
{
////    if (!_controllerHome) {
////        UINavigationController *s = [[UINavigationController alloc] initWithRootViewController:controller_];
////        [s setNavigationBarHidden:YES];
////        self.controllerHome = s; //设置 navigation 可以使用push
//    
//        self.controllerHome = [[UINavigationController alloc] initWithRootViewController:controller_];
//        [_controllerHome release];
//        _controllerHome.delegate = self;
////        if (![AppDelegate sharedAppDelegate].nc) {
////            [AppDelegate sharedAppDelegate].nc = [[UINavigationController alloc] initWithRootViewController:self];
////            [[AppDelegate sharedAppDelegate].nc setNavigationBarHidden:YES animated:NO];
////            [[AppDelegate sharedAppDelegate].window setRootViewController:[AppDelegate sharedAppDelegate].nc];
////
////        }
////        [s release];         //拖放手势
//        UIPanGestureRecognizer *panG  = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//        [_controllerHome.view addGestureRecognizer:panG];
//        [panG release];
////    }
    
    
    if (!_controllerHome) {
        UINavigationController *s = [[UINavigationController alloc] initWithRootViewController:controller_];
        [s setNavigationBarHidden:YES];
        self.controllerHome = s; //设置 navigation 可以使用push
        //        if (![AppDelegate sharedAppDelegate].nc) {
        //            [AppDelegate sharedAppDelegate].nc = [[UINavigationController alloc] initWithRootViewController:self];
        //            [[AppDelegate sharedAppDelegate].nc setNavigationBarHidden:YES animated:NO];
        //            [[AppDelegate sharedAppDelegate].window setRootViewController:[AppDelegate sharedAppDelegate].nc];
        //
        //        }
        [s release];         //拖放手势
        UIPanGestureRecognizer *panG  = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [_controllerHome.view addGestureRecognizer:panG];
        [panG release];
    }    

    
}
static LLSplitViewController *shareStace=nil;
+ (LLSplitViewController*) getmainController{
//    YBLogInfo(@"coming");
    if (!shareStace) {
//        YBLogInfo(@"coming11");
        WOSGoodFoodViewController *conHome_ = [WOSGoodFoodViewController creatObj];
//        YBLogInfo(@"coming22");
        leftViewController *conLeft_ = [leftViewController share];
//        YBLogInfo(@"coming333");
        RightViewController *conRight_ = [RightViewController share];
//        YBLogInfo(@"coming444");
        shareStace = [[LLSplitViewController alloc] initWithLeftController:conLeft_
                                                      rigthController:conRight_
                                                       homeController:conHome_];
//        YBLogInfo(@"coming555");
    
    }
    return shareStace;
}
//清空 三屏
- (void)releaseShare{
    shareStace = nil;
}


- (void)showViewController:(UIViewController *)viewController_  animated:(BOOL)animated
{
	
	if(viewController_ == nil)
		return;
	self.controllerShouldShow = viewController_;
	[UIView beginAnimations:@"hide" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
//	CGRect rect = [Static iphone5Frame];
	CGRect frame_ = CGRectMake(0, -20, 320, self.view.frame.size.height);
	frame_.origin.x = 320;
	_controllerHome.view.frame = frame_; //设置中间页面位置
    shadow.frame =frame_; // 设置阴影页面位置
	[UIView commitAnimations];
    
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if([animationID isEqualToString:@"hide"])
	{
        
        [self.controllerHome.view removeFromSuperview];
//		YBLogInfo(@"contrerHome.view sub view %@",[self.controllerHome.view subviews]);
		[self genHomeViewControllerFromController:_controllerShouldShow];
		self.controllerHome.view.frame = CGRectMake(325, -20, 320, self.view.frame.size.height);
		[self.view addSubview:_controllerHome.view];
        
		[UIView beginAnimations:@"show" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelay:0.1];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		CGRect frame_ = _controllerHome.view.frame;
		frame_.origin.x = 0;
		_controllerHome.view.frame = frame_;
         shadow.frame =CGRectMake(-40, 0, 400, frame_.size.height);
		[UIView commitAnimations];
	}
}
- (void)showLeftView
{
//    [[CommonHelper shareInstance] playSound:5];

	[self showLeftView:YES];
    
}

//private
- (void)showLeftView:(BOOL)animated
{
//    [DeBug postNotification:nil Name:k_Notification_CloseKeyBoard userInfo:nil];


    
	
//	[self.view sendSubviewToBack:_controllerLeft.view];
    
	_controllerLeft.view.hidden = NO;// 显示左边页面
	_controllerRight.view.hidden = YES;
    
//    if (_controllerRight&&_controllerRight.view&&[_controllerRight isViewLoaded]) {
//        _controllerRight.view.hidden = YES;// 影藏右边页面
//    }else{
////        YBLogError(@"");
//    }
//	_controllerRight.view.hidden = YES;// 影藏右边页面
	
	if(animated)
	{

        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
		animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:_controllerHome.view.center.x], [NSNumber numberWithFloat:320 + 160 - kOverlayWidth + kOverlayBufferWidth],\
							[NSNumber numberWithFloat:320 + 160 - kOverlayWidth], nil];
		animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.7] , [NSNumber numberWithFloat:1.0], nil];
		animation.duration = 0.3;
        
//        [shadow.layer addAnimation:animation forKey:@"fja;f"];
		[_controllerHome.view.layer addAnimation:animation forKey:@"fja;f"];
		_controllerHome.view.layer.position = CGPointMake(320 + 160 - kOverlayWidth, _controllerHome.view.center.y);
//         shadow.center = CGPointMake(320 + 160 - kOverlayWidth, _controllerHome.view.center.y);
	}

	[self addOverlayView];
	_overlayView.frame = _controllerHome.view.frame;
	_viewStatu = KLLSplitViewStatu_Left; //设置view的状态 在左
	[self.view addSubview:_overlayView]; //添加 点击页面视图 接受点击事件
    if(_controllerLeft.view.superview == nil)
	{
		[_controllerLeft viewWillAppear:animated];
	}
	
	[_controllerLeft viewDidAppear:animated];
}

- (void)showRightView:(BOOL)animated
{
//    [DeBug postNotification:nil Name:k_Notification_CloseKeyBoard userInfo:nil];
    NSLog(@"------>");
    _controllerLeft.view.hidden = YES;
	_controllerRight.view.hidden = NO;
	if(_controllerRight.view.superview == nil)
	{
		[_controllerRight viewWillAppear:animated];
	}
	[_controllerRight viewDidAppear:animated];	
	[self.view sendSubviewToBack:_controllerRight.view];
		
	if(animated)
	{
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
		animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:_controllerHome.view.center.x], [NSNumber numberWithFloat:-160 + kOverlayWidth - kOverlayBufferWidth],\
							[NSNumber numberWithFloat:- 160 + kOverlayWidth], nil];
		animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.8] , [NSNumber numberWithFloat:1.0], nil];
		animation.duration = 0.3;
		[_controllerHome.view.layer addAnimation:animation forKey:@"fja;f"];
        [shadow.layer addAnimation:animation forKey:@"fja;f"];
         shadow.center = CGPointMake(- 160 + kOverlayWidth, _controllerHome.view.center.y);
        
		_controllerHome.view.layer.position = CGPointMake(- 160 + kOverlayWidth, _controllerHome.view.center.y);
	}

	[self addOverlayView];
	_overlayView.frame = _controllerHome.view.frame;
	_viewStatu = KLLSpiliViewStatu_Rigth; //设置view状态 为右
	[self.view addSubview:_overlayView];  //添加 点击页面视图 接受点击事件
}
// 添加接受点击事件的view 
-(void)addOverlayView{

    if(self.overlayView == nil)
	{
        LLOverlayView *ll = [[LLOverlayView alloc] initWithFrame:_controllerHome.view.frame];
		self.overlayView = ll;
        [ll setDelegate:self];
		[ll release];
    }

}
- (void)showHomeView:(BOOL)animated
{
	if(animated)
	{
//		YBLogInfo(@"HomeView controllerhome.position = %@", NSStringFromCGPoint(_controllerHome.view.layer.position));
//        [UIView beginAnimations:@"" context:@"" ];
//        [UIView setAnimationDuration:0.3];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//		_controllerHome.view.layer.position = CGPointMake(160, _controllerHome.view.center.y);
//        shadow.center = CGPointMake(160, _controllerHome.view.center.y);
//
//        [UIView commitAnimations];

        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
		animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:_controllerHome.view.center.x], [NSNumber numberWithFloat:160],\
                            nil];
		animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0] , [NSNumber numberWithFloat:1.0], nil];
		animation.duration = 0.3;
		[_controllerHome.view.layer addAnimation:animation forKey:@"fja;f"];
        [shadow.layer addAnimation:animation forKey:@"fja;f"];
        shadow.center = CGPointMake(160, _controllerHome.view.center.y);

		_controllerHome.view.layer.position = CGPointMake(160, _controllerHome.view.center.y);
	}
	
	if(self.overlayView && self.overlayView.superview)
	{
		[_overlayView removeFromSuperview]; //当homeview显示在中间的时候，移除点击view
	}
}

#pragma mark  -
#pragma mark  LLOverlayViewDelegate methods
- (void)overLayViewCenterChanged:(CGPoint)offset_
{
	CGPoint pt_ = _controllerHome.view.center;
//	YBLogInfo(@"pt = %@", NSStringFromCGPoint(pt_));
	
//	YBLogInfo(@"oofset = %@", NSStringFromCGPoint(offset_));
	
	CGPoint ptCurrent = CGPointMake(pt_.x + offset_.x, pt_.y);
	
//	YBLogInfo(@"ptcurrent = %@", NSStringFromCGPoint(ptCurrent));
	
	
	//最左边
	if(ptCurrent.x  < -320 + kOverlayWidth - kOverlayBufferWidth)
	{
		ptCurrent.x = -320 + kOverlayWidth - kOverlayBufferWidth;
	}
	
	//右边
	else  if(ptCurrent.x > 480 - kOverlayWidth + kOverlayBufferWidth)
	{
		ptCurrent.x = 480 - kOverlayWidth + kOverlayBufferWidth;
	}
    
	
	self.controllerHome.view.center = ptCurrent;
    shadow.center = ptCurrent;
}

- (void)overLayViewTouchEnd:(CGPoint)offset_
{
	CGPoint pt_ = _controllerHome.view.center;
	CGPoint ptCurrent = CGPointMake(pt_.x + offset_.x, pt_.y);

	if(ptCurrent.x < 320)
	{
		[self showHomeView:YES];
	}
	
	else {
		[self showLeftView:YES];
	}
    
	
}
// 点击
- (void)overLayViewTap:(LLOverlayView *)overlayView_
{
	[self showHomeView:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark- KVO
//观察者观察到某属性后回调的操作
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //    YBLogInfo(@"%@",((PersonalPageMessageViewController *)context));
    //    YBLogInfo(@"%@",self);
    if([keyPath isEqualToString:@"selected"]){
//        [[CommonHelper shareInstance]playSound:5];
        
//        [DeBug removeObserver:self fromTarget:[LLSplitViewController getmainController] forKeyPath:@"selected"];
    } else//将不能处理的 key 转发给 super 的 observeValueForKeyPath 来处理
    {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
    
}

-(void)backPop{

    [self.drNavigationController popViewControllerAnimated:YES];

}

- (void)dealloc {
    [super dealloc];
//    if (self.controllerRight) {
//        self.controllerRight = nil;
//    }
//    if (self.controllerHome) {
//        self.controllerHome = nil;
//    }
//    
//	if (self.controllerLeft) {
//        self.controllerLeft = nil;
//    }
//	
//    if (self.overlayView) {
//        self.overlayView = nil;
//    }
//	if (self.controllerShouldShow) {
//        self.controllerShouldShow = nil;
//    }
//	[shareStace release];
////    [shareStace release];
    shareStace = nil;
}

@end


