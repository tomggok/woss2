//
//  UINavigationBar+DragonNavigationBar.h
//  DragonFramework
//
//  Created by NewM on 13-3-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dragon_NavigationController.h"
#import "NSObject+DragonProperty.h"


@interface UINavigationBar (UINavigationBar)

AS_INT(BARBUTTON_LEFT)//左按钮
AS_INT(BARBUTTON_RIGHT)// 有按钮

AS_SIGNAL(BACK_BUTTON_TOUCHED)//navigationbar左按钮
AS_SIGNAL(DONE_BUTTON_TOUCHED)//navigationbar有按钮

-(void)changeNavigationBarBackImgByimgV:(UIImageView *)imgV alpha:(CGFloat)alpha tintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor;

@end


@interface UIViewController (UINavigationBar)
- (void)showNavigationBarAnimated:(BOOL)animated;
- (void)hideNavigationBarAnimated:(BOOL)animated;

- (void)showBarButton:(NSInteger)position title:(NSString *)name;
- (void)showBarButton:(NSInteger)position image:(UIImage *)image;
- (void)showBarButton:(NSInteger)position system:(UIBarButtonSystemItem)index;
- (void)showBarButton:(NSInteger)position custom:(UIView *)view;
- (void)hideBarButton:(NSInteger)position;
@end
