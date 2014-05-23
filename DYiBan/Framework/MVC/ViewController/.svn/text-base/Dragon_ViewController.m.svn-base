//
//  Dragon_ViewController.m
//  DragonFramework
//
//  Created by NewM on 13-3-5.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_ViewController.h"
#import "UIView+DragonCategory.h"
#import "Dragon_Runtime.h"
#import "NSObject+DragonRequestResponder.h"
#import "Dragon_Device.h"


#pragma mark - view
@interface DragonView : UIView
{
    DragonViewController *_owner;
}
@property (nonatomic, assign)DragonViewController *owner;

@end


@implementation DragonView
@synthesize owner=_owner;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_owner) {
        [_owner sendViewSignal:DragonViewController.LAYOUT_VIEWS];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_owner) {
        [_owner sendViewSignal:DragonViewController.LAYOUT_VIEWS];
    }
}

- (UIViewController *)viewController
{
    return _owner ? _owner : [super viewController];
}

- (void)handleViewSignal:(DragonViewSignal *)signal
{
    if (_owner) {
        [signal forward:_owner];
    }else
    {
        [super handleViewSignal:signal];
    }
}

- (void)dealloc
{

    [super dealloc];
}

@end

#pragma mark - viewControllerCategory
@implementation UIView(DragonViewController)
- (DragonViewController *)board
{
    UIView *topView = self;
    
    while (topView.superview) {
        topView = topView.superview;
        if ([topView isKindOfClass:[UIWindow class]]) {
            break;
        }else if ([topView isKindOfClass:[DragonView class]])
        {
            break;
        }
    }
    
    UIViewController *controller = [topView viewController];
    
    if (controller && [controller isKindOfClass:[DragonViewController class]]) {
        return (DragonViewController *)controller;
    }else
    {
        return nil;
    }
}
@end

#pragma mark - viewcontroller
@interface DragonViewController ()


- (void)createViews;
- (void)deleteViews;
- (void)loadDatas;
- (void)freeDatas;
- (void)enableUserInteraction;
- (void)disableUserInteraction;

- (void)changeStateDisAppeared;
- (void)changeStateDisAppearing;
- (void)changeStateAppeared;
- (void)changeStateAppearing;
@end


@implementation DragonViewController
@synthesize int_state=_int_state,
            bool_dataLoaded=_bool_dataLoaded,
            bool_firstEnter=_bool_firstEnter,
            bool_presenting=_bool_presenting,
            bool_viewBuilt=_bool_viewBuilt,
            int_navi_animation_type=_int_navi_animation_type;


////////////////
DEF_SIGNAL(CREATE_VIEWS)         //创建视图
DEF_SIGNAL(DELETE_VIEWS)         //释放视图(内存警告后释放所有子视图和所有数据)
DEF_SIGNAL(LAYOUT_VIEWS)         //布局视图
DEF_SIGNAL(LOAD_DATAS)           //加载数据
DEF_SIGNAL(FREE_DATAS)           //释放数据
DEF_SIGNAL(WILL_APPEAR)          //将要显示视图
DEF_SIGNAL(DID_APPEAR)           //已经显示视图
DEF_SIGNAL(WILL_DISAPPEAR)       //将要消失视图
DEF_SIGNAL(DID_DISAPPEAR)        //已经消失视图
DEF_SIGNAL(ORIENTATION_CHANGED)  //方向改变

DEF_SIGNAL(ENTERBACKGROUND)      //进入后台
DEF_SIGNAL(ENTERFOREGROUND)      //从后台回来

DEF_SIGNAL(VCBACKSUCCESS)        //页面回退成功

DEF_NOTIFICATION(NOTIFICATIONWILLAPPEAR)
////////////////
/*
static NSMutableArray *_arr_allViewController;
+ (NSArray *)allViewController
{
    return _arr_allViewController;
}*/

+ (DragonViewController *)vcalloc
{
    return [[(DragonViewController *)[DragonRuntime allocByClass:[self class]] init] autorelease];
}
- (id)init
{
    self = [super init];
    if (self) {
        /*
        if (!_arr_allViewController) {
            _arr_allViewController = [[NSMutableArray alloc] init];
        }
        [_arr_allViewController insertObject:self atIndex:0];*/
        
        _bool_firstEnter = YES;
        _bool_presenting = NO;
        _bool_viewBuilt = NO;
        _bool_dataLoaded = NO;
        _int_state = STATE_VIEW_DISAPPEARED;
        
        [self load];
    }
    return self;
}

- (void)load
{
    
}
- (void)unload
{
    
}

- (void)dealloc
{

    [self unload];
    
    [self freeDatas];
	[self deleteViews];
    [super dealloc];
}

- (void)changeStateDisAppeared
{
    if (STATE_VIEW_DISAPPEARED != _int_state) {
        _int_state = STATE_VIEW_DISAPPEARED;
        [self sendViewSignal:DragonViewController.DID_DISAPPEAR];
    }
    
}

- (void)changeStateDisAppearing
{
    if (STATE_VIEW_DISAPPEARING != _int_state) {
        _int_state = STATE_VIEW_DISAPPEARING;
        
        [self sendViewSignal:DragonViewController.WILL_DISAPPEAR];
    }
    
}

- (void)changeStateAppeared
{
    if (STATE_VIEW_APPEARED != _int_state) {
        _int_state = STATE_VIEW_APPEARED;
        
        [self sendViewSignal:DragonViewController.DID_APPEAR];
    }
}

- (void)changeStateAppearing
{
    if (STATE_VIEW_APPEARING != _int_state) {
        _int_state = STATE_VIEW_APPEARING;
        
        [self postNotification:[DragonViewController NOTIFICATIONWILLAPPEAR] withObject:self];
        [self sendViewSignal:DragonViewController.WILL_APPEAR];
    }
}

#pragma mark - viewDelegate
- (void)viewWillAppear:(BOOL)animated
{
    if (!_bool_viewBuilt) {
        return;
    }
    
    _bool_presenting = YES;//页面呈现
    [super viewWillAppear:animated];
    
    [self createViews];
    [self loadDatas];
    
    [self disableUserInteraction];
    [self changeStateAppearing];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!_bool_viewBuilt) {
        return;
    }
    [super viewDidAppear:animated];
    
    [self enableUserInteraction];
    [self changeStateAppeared];
    
    _bool_firstEnter = NO;
    /**IOS7
    CGRect frame=self.view.frame;
    if (frame.size.height==[[NSUserDefaults standardUserDefaults] floatForKey:@"windowHeight"])
    {
        frame.size.height-=20;
    }
    self.view.frame=frame;
    */
}

/**IOS7
 - (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; } - (BOOL)prefersStatusBarHidden { return NO; }
 */

- (void)viewWillDisappear:(BOOL)animated
{
    if (!_bool_viewBuilt) {
        return;
    }
    [super viewWillDisappear:animated];
    
    [self disableUserInteraction];
    [self changeStateDisAppearing];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (!_bool_viewBuilt) {
        return;
    }
    
    [super viewDidDisappear:animated];
    _bool_presenting = NO;
    
    [self disableUserInteraction];
    [self changeStateDisAppeared];
}

- (void)loadView
{
    [super loadView];
    
    CGRect boardViewBound = [UIScreen mainScreen].bounds;
    DragonView *boardView = [[DragonView alloc] initWithFrame:boardViewBound];
    boardView.owner = self;

    self.view = boardView;
//    self.view.userInteractionEnabled = NO;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [boardView release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self createViews];
    [self loadDatas];
}

#pragma mark - changeViewStateAndViewHandle
- (void)createViews
{
    
    if (!_bool_viewBuilt) {
        [self sendViewSignal:DragonViewController.CREATE_VIEWS];
        [self sendViewSignal:DragonViewController.LAYOUT_VIEWS];
        
        _bool_viewBuilt = YES;
    }
}
- (void)deleteViews
{
    if (_bool_viewBuilt) {
        [self sendViewSignal:DragonViewController.DELETE_VIEWS];
        
        _bool_viewBuilt = NO;
    }
}
- (void)loadDatas
{
    if (!_bool_dataLoaded) {
        [self sendViewSignal:DragonViewController.LOAD_DATAS];
        
        _bool_dataLoaded = YES;
    }
}
- (void)freeDatas
{
    if (_bool_dataLoaded) {
        [self sendViewSignal:DragonViewController.FREE_DATAS];
        _bool_dataLoaded = NO;
    }
}
- (void)reloadViewControllerDatas
{
    [self freeDatas];
    [self loadDatas];
}
- (void)enableUserInteraction
{
    if (_bool_viewBuilt) {
        self.view.userInteractionEnabled = YES;
    }
}
- (void)disableUserInteraction
{
    if (_bool_viewBuilt) {
        self.view.userInteractionEnabled = NO;
    }
}

- (void)enterBackground
{
    [self sendViewSignal:DragonViewController.ENTERBACKGROUND];
}
- (void)enterForeground
{
    [self sendViewSignal:DragonViewController.ENTERFOREGROUND];
}
//////////////////
- (DragonNavigationController *)drNavigationController
{
    if (self.navigationController) {
        return (DragonNavigationController *)self.navigationController;
    }else
    {
        return nil;
    }
}

- (void)didReceiveMemoryWarning
{
    if (YES == _bool_viewBuilt)
	{
		[super didReceiveMemoryWarning];
	}
    
    float sysVer = [DragonDevice sysVersion];
    
    if (sysVer >= 6.0f)
    {
        if (![self.view window])// 是否是正在使用的视图
        {
//            [self deleteViews];
        }
    
    }
}

#pragma mark - method


- (void)setVCBackAnimation:(DragonVCBackType)animationType canBackPageNumber:(NSInteger)number
{
    if (animationType == NORAMLBACKTYPE)
    {
        self.drNavigationController.needSwipeBackSCRAnimation = NO;
        self.drNavigationController.needSwipeBackIMGAnimation = NO;
    }else if (animationType == SWIPESCROLLERBACKTYPE)
    {
        self.drNavigationController.needSwipeBackSCRAnimation = YES;
        self.drNavigationController.needSwipeBackIMGAnimation = NO;
    }else if (animationType == SWIPELASTIMAGEBACKTYPE)
    {
        self.drNavigationController.needSwipeBackSCRAnimation = NO;
        self.drNavigationController.needSwipeBackIMGAnimation = YES;
    }
    
    [[self drNavigationController] setPageNumberCantBack:number];
}

@end
