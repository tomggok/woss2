//
//  Magic_UITabBarController.m
//  MagicFramework
//
//  Created by NewM on 13-6-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_UITabBarController.h"
#import "UIView+MagicCategory.h"

@interface MagicUITabBarController ()
{
}
@property (nonatomic, copy)NSMutableArray *viewControllers;
@end

@implementation MagicUITabBarController
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize selectedVC = _selectedVC;
@synthesize tabBar = _tabBar;
@synthesize tabBarHidden = _tabBarHidden;
@synthesize tabBarTransparent = _tabBarTransparent;
@synthesize containerView = _containerView;

- (void)dealloc
{
    RELEASEVIEW(_containerView)
    
    [super dealloc];
}

- (void)removeAllVCView
{
    for (int i = 0; i < [_viewControllers count]; i++)
    {
        [self removeViewControllerAtIndex:i];
    }
}

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr reduceHeight:(CGFloat)reduceHeight
{
    return [self initWithViewControllers:vcs imageArray:arr reduceHeight:reduceHeight barHeight:kTabBarHeight withClass:[MagicUITabBar class]];
}


- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr reduceHeight:(CGFloat)reduceHeight barHeight:(CGFloat)barHeight withClass:(Class)clazz
{
    self = [super init];
    if (self != nil)
    {
        
        _containerView = [[MagicUITabBarView alloc] initWithViewControllers:vcs imageArray:arr reduceHeight:reduceHeight barHeight:barHeight withClass:clazz];
        
        [_containerView.tabBar setBackgroundColor:[UIColor yellowColor]];
        [_containerView setTabBarTransparent:YES];

        
        [self.view addSubview:_containerView];
        
        self.selectedIndex = 0;
    }
    return self;
}

//获得当前v上的vc
- (MagicViewController *)getFirstViewVC
{
    return (MagicViewController *)[[[_containerView.transitionView subviews] lastObject] viewController];
}

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        MagicViewController *vc = [self selectedVC];
        [vc.view setUserInteractionEnabled:YES];
        
        [self sendViewSignal:[MagicViewController WILL_APPEAR] withObject:nil from:self target:vc];
    }else if ([signal is:[MagicViewController DID_APPEAR]])
    {
        MagicViewController *vc = [self selectedVC];
        [vc.view setUserInteractionEnabled:YES];
        
        [self sendViewSignal:[MagicViewController DID_APPEAR] withObject:nil from:self target:vc];
    }else if ([signal is:[MagicViewController VCBACKSUCCESS]])
    {
        MagicViewController *vc = [self selectedVC];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS] withObject:nil from:self target:vc];
    }
}

- (void)setTabBarTransparent:(BOOL)tabBarTransparent
{
    [_containerView setTabBarTransparent:tabBarTransparent];
}

- (void)hideTabBar:(BOOL)isHidden animated:(BOOL)animated
{
    [_containerView hideTabBar:isHidden animated:animated];
}

- (MagicViewController *)selectedVC
{
    return [_containerView selectedVC];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [_containerView setSelectedIndex:selectedIndex];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    [_containerView removeViewControllerAtIndex:index];
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    [_containerView insertViewController:vc withImageDic:dict atIndex:index];
}

- (void)handleViewSignal_MagicUITabBarView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITabBarView TABBARSHOULDSELECT]])
    {
        [signal setReturnValue:[MagicViewSignal YES_VALUE]];
    }
}

@end
