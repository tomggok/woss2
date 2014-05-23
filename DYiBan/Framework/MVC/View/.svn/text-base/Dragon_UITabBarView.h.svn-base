//
//  Dragon_UITabBarView.h
//  DragonFramework
//
//  Created by NewM on 13-6-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragonUITabBarView : UIView
{
    DragonUITabBar *_tabBar;
    
    UIView *_transitionView;
    
    NSMutableArray *_viewControllers;
    NSUInteger _selectedIndex;
    
    BOOL _tabBarTransparent;
    BOOL _tabBarHidden;
    

}

AS_SIGNAL(TABBARSHOULDSELECT)//将要选中
AS_SIGNAL(TABBARDIDSELCT)//选中

@property (nonatomic, copy)NSMutableArray *viewControllers;

@property (nonatomic, readonly)UIView *transitionView;

@property (nonatomic, readonly)DragonViewController *selectedVC;
@property (nonatomic, assign)NSUInteger selectedIndex;

@property (nonatomic, readonly)DragonUITabBar *tabBar;

@property (nonatomic, assign)BOOL tabBarTransparent;
@property (nonatomic, assign)BOOL tabBarHidden;


- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr reduceHeight:(CGFloat)reduceHeight;

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr reduceHeight:(CGFloat)reduceHeight barHeight:(CGFloat)barHeight withClass:(Class)clazz;

- (void)hideTabBar:(BOOL)isHidden animated:(BOOL)animated;

- (void)removeViewControllerAtIndex:(NSUInteger)index;
- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;

//添加view
- (void)addVCView:(NSArray *)vcArr imgArr:(NSArray *)imgArr;
//移除全部的view
- (void)removeAllVCView;

@end
