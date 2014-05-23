//
//  Magic_UITabBarController.h
//  MagicFramework
//
//  Created by NewM on 13-6-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Magic_UITabBar.h"

#define kTabBarHeight 50

@interface MagicUITabBarController : MagicViewController
{
    MagicUITabBarView *_containerView;
}

@property (nonatomic, readonly)MagicViewController *selectedVC;
@property (nonatomic, assign)NSUInteger selectedIndex;

@property (nonatomic, readonly)MagicUITabBar *tabBar;

@property (nonatomic, assign)BOOL tabBarTransparent;
@property (nonatomic, assign)BOOL tabBarHidden;

@property (nonatomic, readonly)MagicUITabBarView *containerView;//tabbar的view


- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr reduceHeight:(CGFloat)reduceHeight;

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr reduceHeight:(CGFloat)reduceHeight barHeight:(CGFloat)barHeight withClass:(Class)clazz;

- (void)hideTabBar:(BOOL)isHidden animated:(BOOL)animated;

- (void)removeViewControllerAtIndex:(NSUInteger)index;
- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;

//获得当前v上的vc
- (MagicViewController *)getFirstViewVC;
@end

