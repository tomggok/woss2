//
//  UINavigationBar+DragonNavigationBar.m
//  DragonFramework
//
//  Created by NewM on 13-3-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UINavigationBar+DragonNavigationBar.h"
#import "UIViewController+DragonViewSignal.h"

@implementation UINavigationBar (UINavigationBar)

DEF_SIGNAL(BACK_BUTTON_TOUCHED)
DEF_SIGNAL(DONE_BUTTON_TOUCHED)

DEF_INT(BARBUTTON_LEFT, 0)
DEF_INT(BARBUTTON_RIGHT, 1)

#pragma mark-改变导航栏背景图片和透明度
-(void)changeNavigationBarBackImgByimgV:(UIImageView *)imgV alpha:(CGFloat)alpha tintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor
{

        //    UINavigationBar *navBar=viewCon.navigationController.navigationBar;

    self.tintColor=tintColor;
    self.backgroundColor=backgroundColor;

    if([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){//ios5.0以后支持
        [self setBackgroundImage:imgV.image forBarMetrics:UIBarMetricsDefault];
    }else {
            //        LogClassType(__FUNCTION__, nil, [navBar viewWithTag:0]);
            //        UIImageView *imgV=(UIImageView *)[navBar viewWithTag:0];

        if(![[self viewWithTag:0] isKindOfClass:[UIImageView class]]){//导航栏没有背景图
                                                                        //            UIImageView *imgV=[[UIImageView alloc]initWithImage:img];
            [imgV setTag:0];
            [self insertSubview:imgV atIndex:imgV.tag];
                //            [imgV release];
        }
    }
        //    imgV.alpha=alpha;
    UIImageView *navBackImg=(UIImageView *)[self viewWithTag:0];
    navBackImg.alpha=alpha;
}

@end

@interface UIViewController (UINavigationBarPrivate)
- (void)didLeftBarButtonTouched;
- (void)didRightBarButtonTouched;

@end

#pragma mark -
@implementation UIViewController(UINavigationBar)

- (void)showNavigationBarAnimated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)hideNavigationBarAnimated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didLeftBarButtonTouched
{
    [self sendViewSignal:[UINavigationBar BACK_BUTTON_TOUCHED]];
}

- (void)didRightBarButtonTouched
{
    [self sendViewSignal:[UINavigationBar DONE_BUTTON_TOUCHED]];
}

- (void)showBarButton:(NSInteger)position title:(NSString *)name
{
    if ([UINavigationBar BARBUTTON_LEFT] == position) {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:name
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(didLeftBarButtonTouched)] autorelease];
    }else
    {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:name
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector(didRightBarButtonTouched)] autorelease];
    }
}

- (void)showBarButton:(NSInteger)position image:(UIImage *)image
{
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)] autorelease];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:image forState:UIControlStateNormal];
    
    if ([UINavigationBar BARBUTTON_LEFT] == position) {
        [button addTarget:self action:@selector(didLeftBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    }else
    {
        [button addTarget:self action:@selector(didRightBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    }
}

- (void)showBarButton:(NSInteger)position system:(UIBarButtonSystemItem)index
{
    if ([UINavigationBar BARBUTTON_LEFT] == position) {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:index target:self action:@selector(didLeftBarButtonTouched)] autorelease];
    }else
    {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
																								target:self
																								action:@selector(didRightBarButtonTouched)] autorelease];
    }
}

- (void)showBarButton:(NSInteger)position custom:(UIView *)view
{
	if ( UINavigationBar.BARBUTTON_LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
	}
	else
	{
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
	}
}

- (void)hideBarButton:(NSInteger)position
{
    if ([UINavigationBar BARBUTTON_LEFT] == position) {
        self.navigationItem.leftBarButtonItem = nil;
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}


@end


