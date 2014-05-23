//
//  Dragon_UITabBarController.h
//  DragonFramework
//
//  Created by NewM on 13-6-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dragon_UITabBar.h"

#define kTabBarHeight 50

@interface DragonUITabBarController : DragonViewController
{
    DragonUITabBarView *_containerView;
}

@property (nonatomic, readonly)DragonViewController *selectedVC;
@property (nonatomic, assign)NSUInteger selectedIndex;

@property (nonatomic, readonly)DragonUITabBar *tabBar;

@property (nonatomic, assign)BOOL tabBarTransparent;
@property (nonatomic, assign)BOOL tabBarHidden;

@property (nonatomic, readonly)DragonUITabBarView *containerView;//tabbar的view


- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr reduceHeight:(CGFloat)reduceHeight;

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr reduceHeight:(CGFloat)reduceHeight barHeight:(CGFloat)barHeight withClass:(Class)clazz;

- (void)hideTabBar:(BOOL)isHidden animated:(BOOL)animated;

- (void)removeViewControllerAtIndex:(NSUInteger)index;
- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;

//获得当前v上的vc
- (DragonViewController *)getFirstViewVC;
@end

