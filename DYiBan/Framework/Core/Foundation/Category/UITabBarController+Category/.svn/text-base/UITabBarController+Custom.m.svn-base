//
//  UITabBarController+Custom.m
//  DragonFramework
//
//  Created by zhangchao on 13-4-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UITabBarController+Custom.h"

@implementation UITabBarController (Custom)

#pragma mark-改变UITabBarController背景以及选中背景图片的方法
-(void)changeUITabBarControllersBackgroundImageAndSelectionIndicatorImage:(UIImage *)backimg
{
    if([[[UIDevice currentDevice].systemVersion substringToIndex:1] intValue]>=5){//5.0以上
        [self.tabBar setBackgroundImage:backimg];
            //    tabBarCon.tabBar.selectionIndicatorImage=[UIImage imageNamed:@"HomePage_select.png"];
    }else {
        NSArray *array = [self.view subviews];
        UITabBar *tabBar = [array objectAtIndex:1];
        tabBar.layer.contents = (id)backimg.CGImage;
    }
}

@end
