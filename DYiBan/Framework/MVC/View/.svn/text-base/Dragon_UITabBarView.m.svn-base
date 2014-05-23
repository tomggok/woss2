//
//  Dragon_UITabBarView.m
//  DragonFramework
//
//  Created by NewM on 13-6-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UITabBarView.h"
#import "Dragon_Runtime.h"

#import "Dragon_ViewController.h"
#import "NSObject+Dragon_Notification.h"
#import "UIView+DragonCategory.h"

@interface DragonUITabBarView ()
{
    BOOL isFirst;//第一次近来
    
    CGFloat _barHeight;//bar的高度
    
//    DragonUITimeBlurView *timeBlur;//虚化view
}
@property (nonatomic, retain)UIView *transitionView;
@end

@implementation DragonUITabBarView
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize selectedVC = _selectedVC;
@synthesize tabBar = _tabBar;
@synthesize tabBarHidden = _tabBarHidden;
@synthesize tabBarTransparent = _tabBarTransparent;
@synthesize transitionView = _transitionView;
DEF_SIGNAL(TABBARSHOULDSELECT)//将要选中
DEF_SIGNAL(TABBARDIDSELCT)//选中

- (void)dealloc
{
    [self unobserveAllNotification];
    
    [self removeAllVCView];
    RELEASEOBJ(_tabBar)
    RELEASEVIEW(_transitionView)
    RELEASEDICTARRAYOBJ(_viewControllers);

    [super dealloc];
}


- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr reduceHeight:(CGFloat)reduceHeight
{
    
    return [self initWithViewControllers:vcs
                              imageArray:arr
                            reduceHeight:reduceHeight
                               barHeight:kTabBarHeight
                               withClass:[DragonUITabBar class]];
}

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr reduceHeight:(CGFloat)reduceHeight barHeight:(CGFloat)barHeight withClass:(Class)clazz
{
    _barHeight = barHeight;
    CGRect mainFrame = MAINFRAME;
    self = [super initWithFrame:mainFrame];
    if (self != nil)
    {
        _viewControllers = [[NSMutableArray arrayWithArray:vcs] retain];
        
        _transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.frame) - barHeight)];
        
        CGFloat tabBarY = CGRectGetHeight(self.frame) - barHeight;
        tabBarY -= reduceHeight;
        
        
        _tabBar = [(DragonUITabBar *)[DragonRuntime allocByClass:clazz] initWithFrame:CGRectMake(0, tabBarY, CGRectGetWidth(self.bounds), _barHeight) buttonImages:arr];
        [_tabBar setDelegate:self];
        
        
        [self addSubview:_transitionView];
        [self addSubview:_tabBar];
        
        
        isFirst = YES;
        
//        [self observeNotification:[DragonViewController NOTIFICATIONWILLAPPEAR]];
        
        
        
//        self.selectedIndex = 0;
    }
    return self;
}

- (void)setTabBarTransparent:(BOOL)tabBarTransparent
{
    if (tabBarTransparent)
    {
        _transitionView.frame = self.bounds;
    }else
    {
        _transitionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.frame) - _barHeight);
    }
}

- (void)hideTabBar:(BOOL)isHidden animated:(BOOL)animated
{
    if (isHidden)
    {
        if (self.tabBar.frame.origin.y == self.frame.size.height)
        {
            return;
        }
    }else
    {
        if (self.tabBar.frame.origin.y == self.frame.size.height - _barHeight)
        {
            return;
        }
    }
    
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3f];
        if (isHidden)
        {
            CHANGEFRAMEORIGIN(self.tabBar.frame, self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + _barHeight);
        }else
        {
            CHANGEFRAMEORIGIN(self.tabBar.frame, self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - _barHeight);
        }
        [UIView commitAnimations];
    }else
    {
        if (isHidden)
        {
            CHANGEFRAMEORIGIN(self.tabBar.frame, self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + _barHeight);
        }else
        {
            CHANGEFRAMEORIGIN(self.tabBar.frame, self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - _barHeight);
        }
    }
}

- (DragonViewController *)selectedVC
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self displayViewAtIndex:selectedIndex];
    [_tabBar selectTabAtIndex:selectedIndex];
}

//移除全部的view
- (void)removeAllVCView
{
    int count = [_viewControllers count];
    for (int i = 0; i < count; i++)
    {
        [self removeViewControllerAtIndex:0];
    }
}

//添加view
- (void)addVCView:(NSArray *)vcArr imgArr:(NSArray *)imgArr
{
    for (int i = 0; i < [vcArr count]; i++)
    {
        [self insertViewController:[vcArr objectAtIndex:i] withImageDic:[imgArr objectAtIndex:i] atIndex:i];
    }
}


- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    if (index >= [_viewControllers count])
    {
        return;
    }
    
    RELEASEALLSUBVIEW(_transitionView);
    
    [_viewControllers removeObjectAtIndex:index];
    
    [_tabBar removeTabAtIndex:index];
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    [_viewControllers insertObject:vc atIndex:index];
    [_tabBar insertTabWithImageDic:dict atIndex:index];
}


- (void)displayViewAtIndex:(NSUInteger)index
{
    DragonViewSignal *singal = [self sendViewSignal:[DragonUITabBarView TABBARSHOULDSELECT] withObject:[_viewControllers objectAtIndex:index]];
    
    if (!singal.boolValue && !isFirst)
    {
        return;
    }else if (isFirst)
    {
        isFirst = NO;
    }
    
//    if (_selectedIndex == index && [[_transitionView subviews] count] != 0)
//    {
//        return;
//    }
    
    _selectedIndex = index;
    
    DragonViewController *selectedVC = [_viewControllers objectAtIndex:index];
    
    selectedVC.view.frame = _transitionView.frame;
    [selectedVC.view setUserInteractionEnabled:YES];
    
    if ([selectedVC.view isDescendantOfView:_transitionView])
    {
        [_transitionView bringSubviewToFront:selectedVC.view];
        [selectedVC viewWillAppear:YES];
        [selectedVC viewDidAppear:YES];
    }else
    {
        [selectedVC.view setUserInteractionEnabled:YES];
        
        [_transitionView addSubview:selectedVC.view];
        [selectedVC viewWillAppear:YES];
        [selectedVC viewDidAppear:YES];
    }
    
    for (int i= 0; i < [_viewControllers count]; i++)
    {
        if (i == index)
        {
            continue;
        }
        [[(DragonViewController *)[_viewControllers objectAtIndex:i] view] setUserInteractionEnabled:NO];
    }
    
    [self sendViewSignal:[DragonUITabBarView TABBARDIDSELCT] withObject:selectedVC];
}

- (void)handleViewSignal_DragonUITabBar:(DragonViewSignal *)signal
{
    NSNumber *num = (NSNumber *)[signal object];
    if ([signal is:[DragonUITabBar TABBARBUTTON]])
    {
        if (_selectedIndex != [num intValue])
        {
            [self displayViewAtIndex:[num intValue]];
        }
    }
}

//////
#pragma mark -
#pragma mark notification
- (void)handleNotification:(NSNotification *)notification
{
    DragonViewController *vc = notification.object;
    if ([self.superview viewController] == vc)
    {
        [self setSelectedIndex:_selectedIndex];
    }
}

@end
