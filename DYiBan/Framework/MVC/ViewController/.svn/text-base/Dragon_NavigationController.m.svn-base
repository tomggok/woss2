//
//  Dragon_NavigationController.m
//  DragonFramework
//
//  Created by NewM on 13-3-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_NavigationController.h"
#import "Dragon_ViewController.h"
#import "UIView+DragonCategory.h"
#import "Dragon_Runtime.h"
#import "UIImage+DragonCategory.h"

#pragma mark - view关于Navigation的分类
@implementation UIView(DragonViewNavigation)
- (DragonNavigationController *)stack
{
    UINavigationController *controller = [self navigationController];
    if (controller && [controller isKindOfClass:[DragonNavigationController class]]) {
        return (DragonNavigationController *)controller;
    }else
    {
        return nil;
    }
}

- (UINavigationController *)navigationController
{
    UIViewController *controller = [self viewController];
    if (controller) {
        return controller.navigationController;
    }else
    {
        return nil;
    }
}
@end

#pragma mark -
static UIImage *_defaultImage = nil;

@interface DragonNavigationBar : UINavigationBar
{
    UIImage *_backgroundImage;
}
@property (nonatomic, retain)UIImage *backgroundImage;

@end
@implementation DragonNavigationBar
@synthesize  backgroundImage = _backgroundImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    RELEASEOBJ(_backgroundImage);
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    if (_backgroundImage)
    {
        [_backgroundImage drawInRect:rect];
    }else if (_defaultImage)
    {
        [_defaultImage drawInRect:rect];
    }else
    {
        [super drawRect:rect];
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (backgroundImage == _backgroundImage) {
        return;
    }
    [backgroundImage retain];
    [_backgroundImage release];
    _backgroundImage = backgroundImage;

    [self setNeedsDisplay];//异步的告诉系统重新绘制
}

@end

@interface DragonNavigationController ()

@end
#import "Dragon_UINavigationBar.h"

@interface DragonNavigationController ()
{
    
    //backgesture
    UIPanGestureRecognizer *panGetsture;
    UISwipeGestureRecognizer *swipeLeftGesture;
    //backanimation
    CGPoint     startTouch;
    BOOL        isMoving;
    UIImageView *backView;
    UIView      *blackView;
}
//backanimation
@property (nonatomic, retain)NSMutableArray *allviewImg;

@property (nonatomic, assign)CGFloat navigationbarHeight;

@end

@implementation DragonNavigationController
@synthesize name=_name,
            baseViewController=_baseViewController,
            allviewControllers=_allviewControllers,
            allviewImg = _allviewImg,
            topStackViewController=_topStackViewController;
@synthesize dNavBarView = _dNavBarView;

@synthesize needSwipeBackIMGAnimation = _needSwipeBackIMGAnimation,
            needSwipeBackSCRAnimation = _needSwipeBackSCRAnimation,
            pageNumberCantBack = _pageNumberCantBack;
@synthesize navigationbarHeight = _navigationbarHeight;
+ (DragonNavigationController *)stack
{
    return [[[DragonNavigationController alloc] initWithName:nil andFirstBoardClass:nil] autorelease];
}

+ (DragonNavigationController *)stack:(NSString *)name
{
    return [[[DragonNavigationController alloc] initWithName:name andFirstviewController:nil] autorelease];
}

+ (DragonNavigationController *)stack:(NSString *)name firstViewClass:(Class)clazz
{
    DragonViewController *viewController = [[(DragonViewController *)[DragonRuntime allocByClass:clazz] init] autorelease];
    return [[DragonNavigationController alloc] initWithName:name andFirstviewController:viewController];
}

+ (DragonNavigationController *)stack:(NSString *)name firstviewController:(DragonViewController *)viewController
{
    return [[[DragonNavigationController alloc] initWithName:name andFirstviewController:viewController] autorelease];
}

+ (DragonNavigationController *)stackWithFirstViewControllerClass:(Class)clazz
{
    return [DragonNavigationController stack:nil firstViewClass:clazz];
}

+ (DragonNavigationController *)stackWithFirstViewController:(DragonViewController *)viewController
{
    return [DragonNavigationController stack:nil firstviewController:viewController];
}

- (DragonNavigationController *)initWithName:(NSString *)name andFirstBoardClass:(Class)clazz
{
    DragonViewController *viewController = [[(DragonViewController *)[DragonRuntime allocByClass:clazz] init] autorelease];
    self = [super initWithRootViewController:viewController];
    if (self) {
        self.name = name ? : [clazz description];
        self.navigationBarHidden = NO;
        self.navigationBar.barStyle = UIBarStyleBlackOpaque;
        
    }
    return self;
}

- (DragonNavigationController *)initWithName:(NSString *)name andFirstviewController:(DragonViewController *)viewController
{
    self = [super initWithRootViewController:viewController];
    if (self) {
        self.name = name ? name : [[viewController class] description];
        self.navigationBarHidden = NO;
        self.navigationBar.barStyle = UIBarStyleBlackOpaque;

    }
    return self;
}

- (void)dealloc
{
    RELEASEDICTARRAYOBJ(_allviewImg);
    
    RELEASEVIEW(_dNavBarView);
    
    RELEASEOBJ(_name);
    [super dealloc];
}

- (NSArray *)allviewControllers
{
    NSMutableArray *array = [NSMutableArray array];
    for (UIViewController *controller in self.viewControllers) {
        if ([controller isKindOfClass:[DragonViewController class]]) {
            [array addObject:controller];
        }
    }
    return array;
}

- (DragonViewController *)topStackViewController
{
    UIViewController *controller = self.topViewController;
    if (controller && [controller isKindOfClass:[UIViewController class]]) {
        DragonViewController *viewController = (DragonViewController *)controller;
        return viewController;
    }else
    {
        return nil;
    }
}


#pragma mark - jumpnextviewcontroller animation
#pragma mark -
- (void)pushViewController:(DragonViewController *)viewController animated:(BOOL)animated
{
    [self pushViewController:viewController animated:animated animationType:ANIMATION_TYPE_DEFAULT];
}

- (void)pushViewController:(DragonViewController *)viewController animated:(BOOL)animated animationType:(NSInteger)type
{
    //如果需要截图
    if (_needSwipeBackIMGAnimation)
    {
        //添加当前页面的view
        [self getCurrentSceenImg];
    }
    
    viewController.int_navi_animation_type = type;//设置push的类型，为了pop
    
    [self animationToNextPage:viewController animated:animated animationType:type jumpType:NAVIGATION_PUSHVIEW];
    
    //自定义bar
    if (_dNavBarView)
    {
        [_dNavBarView setIsTop:NO];
    }
    
    
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    for (int i = 1; i < [_allviewImg count]; i++)
    {
        [_allviewImg removeObjectAtIndex:i];
        i--;
    }

    return [super popToRootViewControllerAnimated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    //清除保存上一个页面的viewimg
    if ([_allviewImg count] > 0)
    {
        [_allviewImg removeLastObject];
    }
    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    //返回上一个页面成功通知
    NSInteger count = [self.viewControllers count] - 2;
    if (count > 0)
    {
        [self sendViewSignal:[DragonViewController VCBACKSUCCESS] withObject:nil from:nil target:[self.viewControllers objectAtIndex:count]];
    }
    
    return vc;
    
}

- (void)popVCAnimated:(BOOL)animated
{
    [self popVCAnimated:animated animationType:self.topStackViewController.int_navi_animation_type];
}

- (void)popVCAnimated:(BOOL)animated animationType:(NSInteger)type
{
    //自定义bar
    if ([self.viewControllers count] >= 2)
    {
        if (_dNavBarView)
        {
            [_dNavBarView setIsTop:YES];
        }
        
    }
    
    if (self.allviewControllers.count <= 1) {
        return;
    }
    
    [self animationPopView:nil animated:animated animationType:type jumpType:NAVIGATION_POPVIEW];
    

}

- (NSArray *)popToViewcontroller:(DragonViewController *)viewController animated:(BOOL)animated
{
    return [self popToViewcontroller:viewController animated:animated animationType:self.topStackViewController.int_navi_animation_type];
}

- (NSArray *)popToViewcontroller:(DragonViewController *)viewController animated:(BOOL)animated animationType:(NSInteger)type
{
    return [self animationPopView:viewController animated:animated animationType:type jumpType:NAVIGATION_POPTOVIEW];
}

- (NSArray *)popToFirstViewControllerAnimated:(BOOL)animated
{
    return [self popToFirstViewControllerAnimated:animated animationType:self.topStackViewController.int_navi_animation_type];
}

- (NSArray *)popToFirstViewControllerAnimated:(BOOL)animated animationType:(NSInteger)type
{
    NSArray *result = nil;
    result = [self animationPopView:nil animated:animated animationType:type jumpType:NAVIGATION_POPTOROOTVIEW];
    return result;
}

//跳转上一个页面的动画
- (NSArray *)animationPopView:(DragonViewController *)viewController animated:(BOOL)animated animationType:(NSInteger)type jumpType:(NSInteger)jumpType
{
    NSArray *result = nil;
    
    if (!animated) {
        result = [self naviPushOrPop:jumpType animated:animated popToViewController:viewController]
        ;
    }else
    {
        UIView *topView = nil;
        switch (type) {
            case ANIMATION_TYPE_DEFAULT:
                result = [self naviPushOrPop:jumpType animated:animated popToViewController:viewController]
                ;
                
                break;
            case ANIMATION_TYPE_CUBE:
                result = [self naviPushOrPop:jumpType animated:NO popToViewController:viewController]
                ;
                [self animationMethod:@"cube" subType:kCATransitionFromBottom timimgFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

                break;
            case ANIMATION_TYPE_FADE:
                result = [self naviPushOrPop:jumpType animated:NO popToViewController:viewController]
                ;
                [self animationMethod:@"fade" subType:kCATransitionFromLeft timimgFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
                
                
                break;
                
            case ANIMATION_TYPE_REVEAL:
                
                topView = [[[self topStackViewController] view] retain];
                result = [self naviPushOrPop:jumpType animated:NO popToViewController:viewController]
                ;
                
                UIView *bottomView = self.topStackViewController.view;
                [topView removeFromSuperview];
                [self.view addSubview:topView];
                
                bottomView.layer.transform = CATransform3DMakeTranslation(.0f, -bottomView.bounds.size.height, .0f);
                bottomView.alpha = 1.f;
                
                [UIView animateWithDuration:.4f animations:^{
                    bottomView.layer.transform = CATransform3DIdentity;
                    bottomView.alpha = 1.f;
                    
                    topView.layer.transform = CATransform3DMakeScale(.9f, .9f, 1.f);
                    topView.alpha = .0f;
                } completion:^(BOOL finished) {
                    topView.alpha = .0f;
                    topView.layer.transform = CATransform3DIdentity;
                    
                    [topView removeFromSuperview];
                    [topView release];
                }];
                break;
            case ANIMATION_TYPE_PUSH:
                result = [self naviPushOrPop:jumpType animated:NO popToViewController:viewController]
                ;
                [self animationMethod:@"push" subType:kCATransitionFromLeft timimgFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                
                
                break;
            default:
                break;
        }
    
    }
    
    return result;
}

//跳转下一个页面的动画效果
- (void)animationToNextPage:(DragonViewController *)viewController animated:(BOOL)animated animationType:(NSInteger)type jumpType:(NSInteger)jumpType
{
    
    if (!animated) {
        [self naviPushOrPop:jumpType animated:animated popToViewController:viewController]
        ;
    }else
    {
        
        switch (type) {
            case ANIMATION_TYPE_DEFAULT:
                [self naviPushOrPop:jumpType animated:animated popToViewController:viewController]
                ;
                
                break;
            case ANIMATION_TYPE_CUBE:
                
                [self animationMethod:@"cube" subType:kCATransitionFromTop timimgFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
                [self naviPushOrPop:jumpType animated:NO popToViewController:viewController]
                ;
                break;
            case ANIMATION_TYPE_FADE:
                [self animationMethod:@"fade" subType:kCATransitionFromRight timimgFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
                [self naviPushOrPop:jumpType animated:NO popToViewController:viewController]
                ;
                
                break;
                
            case ANIMATION_TYPE_REVEAL:
                [self animationMethod:@"reveal" subType:kCATransitionFromRight timimgFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                
                [self naviPushOrPop:jumpType animated:NO popToViewController:viewController]
                ;
                
                [self animationUIViewForShow:viewController];
                break;
            case ANIMATION_TYPE_PUSH:
                [self animationMethod:@"push" subType:kCATransitionFromRight timimgFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                
                [self naviPushOrPop:jumpType animated:NO popToViewController:viewController]
                ;
                break;
            default:
                break;
        }
        
    }
}

//是什么跳转方式
- (NSArray *)naviPushOrPop:(NSInteger)jumpType animated:(BOOL)animated popToViewController:(DragonViewController *)viewController
{
    switch (jumpType) {
        case NAVIGATION_PUSHVIEW:
            [super pushViewController:viewController animated:animated];
            break;
        case NAVIGATION_POPVIEW:
            [self popViewControllerAnimated:animated];
            break;
        case NAVIGATION_POPTOVIEW:
            return [super popToViewController:viewController animated:animated];
            break;
            
        case NAVIGATION_POPTOROOTVIEW:
            return [self popToRootViewControllerAnimated:animated];
            break;
        default:
            break;
    }
    return nil;
}

//CATransition动画的方法
- (void)animationMethod:(NSString *)type subType:(NSString *)subType timimgFunction:(CAMediaTimingFunction *)function{
    CATransition *animation = [CATransition animation];
    [animation setDuration:.6f];
    [animation setType:type];//设置动话得类型
    [animation setSubtype:subType];//设置动画进行得方向
    [animation setTimingFunction:function];//设置动画步调进行得类型
    [self.view.layer addAnimation:animation forKey:type];
    
}

//uiview动画淡显的方法
- (void)animationUIViewForShow:(UIViewController *)newViewController{
    newViewController.view.layer.transform = CATransform3DMakeScale(.9f, .9f, 1.f);
    newViewController.view.alpha = .0f;
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:.6f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:NO];
    
    newViewController.view.layer.transform = CATransform3DIdentity;
    newViewController.view.alpha = 1.f;
    
    [UIView commitAnimations];
}

#pragma mark - navigation属性方法
- (void)popAllViewControllers
{
    self.viewControllers = [NSArray array];
}

- (BOOL)existsViewController:(DragonViewController *)board
{
    for (UIViewController *controller in self.viewControllers)
    {
        if ([controller isKindOfClass:[DragonNavigationController class]] && (DragonViewController *)controller == board) {
            return YES;
        }
    }
    return NO;
}

- (DragonViewController *)getViewController:(Class)clazz
{
    for (UIViewController *controller in self.viewControllers) {
        if ([controller isKindOfClass:clazz]) {
            return (DragonViewController *)controller;
        }
    }
    return nil;
}

- (CGFloat)navigationbarHeight
{
    if (_dNavBarView)
    {
        return CGRectGetHeight(_dNavBarView.frame);
    }else
    {
        UINavigationBar *bar = [self navigationBar];
        return bar.frame.size.height;
    }
}


- (void)enterBackground
{
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:[DragonViewController class]]) {
            DragonViewController *vc = (DragonViewController *)viewController;
            [vc enterBackground];
        }
    }
}

- (void)enterForeground
{
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:[DragonViewController class]]) {
            DragonViewController *vc = (DragonViewController *)viewController;
            [vc enterForeground];
        }
    }
}

+ (void)setDefaultBarBackgroundImage:(UIImage *)image
{
    if (image == _defaultImage) {
        return;
    }
    [image retain];
    [_defaultImage release];
    _defaultImage = image;
}

- (void)setBarBackgroundImage:(UIImage *)image
{
    UINavigationBar *navBar = self.navigationBar;
    if (navBar && [navBar isKindOfClass:[DragonNavigationBar class]])
    {
        [(DragonNavigationBar *)navBar setBackgroundImage:image];
    }
}

- (void)setBarBackgroundColor:(UIColor *)color
{
    UINavigationBar *navBar = self.navigationBar;
    if (navBar && [navBar isKindOfClass:[DragonNavigationBar class]])
    {
        [(DragonNavigationBar *)navBar setBackgroundImage:[UIImage imageWithColor:color]];
    }
}

- (void)loadView
{
    [super loadView];
    DragonNavigationBar *bar = [[DragonNavigationBar alloc] init];
    [self setValue:bar forKey:@"navigationBar"];
    [bar release];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.topViewController && [self.topViewController isKindOfClass:[DragonViewController class]]) {
        DragonViewController *baseVC = (DragonViewController *)self.topViewController;
        [baseVC viewWillAppear:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.topViewController && [self.topViewController isKindOfClass:[DragonViewController class]]) {
        DragonViewController *baseVC = (DragonViewController *)self.topViewController;
        [baseVC viewDidAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.topViewController && [self.topViewController isKindOfClass:[DragonViewController class]]) {
        DragonViewController *baseVC = (DragonViewController *)self.topViewController;
        [baseVC viewWillDisappear:animated];
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.topViewController && [self.topStackViewController isKindOfClass:[DragonViewController class]]) {
        DragonViewController *baseVC = (DragonViewController *)self.topViewController;
        [baseVC viewDidDisappear:animated];
    }
}

#pragma mark - method
- (void)getCurrentSceenImg
{
    UIImage *img = [UIImage cutScreenImg:self.view];
    
    if (!_allviewImg) {
        _allviewImg = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    [_allviewImg addObject:img];
    
    
}

- (NSInteger)pageNumberCantBack
{
    if (_pageNumberCantBack < 1)
    {
        _pageNumberCantBack = 1;
    }
    return _pageNumberCantBack;
}

- (void)setPageNumberCantBack:(NSInteger)pageNumberCantBack
{
    _pageNumberCantBack = pageNumberCantBack;
}

#pragma mark - gestureDelegate

- (void)setNeedSwipeBackSCRAnimation:(BOOL)needSwipeBackSCRAnimation
{
    if (needSwipeBackSCRAnimation)
    {
        if (_needSwipeBackIMGAnimation)
        {
            [self.view removeGestureRecognizer:panGetsture];
        }
        _needSwipeBackIMGAnimation = NO;
        
        if (!swipeLeftGesture)
        {
            swipeLeftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwitchView:)];
            swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionRight;
            [self.view addGestureRecognizer:swipeLeftGesture];
            RELEASE(swipeLeftGesture);
        }
        
        
        
    }
    
    _needSwipeBackSCRAnimation = needSwipeBackSCRAnimation;
}


- (void)setNeedSwipeBackIMGAnimation:(BOOL)needSwipeBackIMGAnimation
{
    if (!needSwipeBackIMGAnimation)
    {
        [[[self view] superview] setBackgroundColor:[UIColor clearColor]];
    }else
    {
        if (_needSwipeBackSCRAnimation)
        {
            [self.view removeGestureRecognizer:swipeLeftGesture];
        }
        _needSwipeBackSCRAnimation = NO;
        
        if (!panGetsture)
        {
            panGetsture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwitchView:)];
            [panGetsture setDelegate:self];
            [self.view addGestureRecognizer:panGetsture];
            RELEASE(panGetsture);
        }
        
    }
    _needSwipeBackIMGAnimation = needSwipeBackIMGAnimation;
}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{

    if (([self.viewControllers count] < 1 || !_allviewImg || [_allviewImg count] == 0))
    {
        if (_needSwipeBackSCRAnimation == _needSwipeBackIMGAnimation) {
            return NO;
        }
        
    }
    
    if (_pageNumberCantBack == 0)
    {
        return NO;
    }
    
    isMoving = NO;
    startTouch = [gestureRecognizer translationInView:self.view];
    
    return YES;
}

- (void)handleSwitchView:(id)sender
{
    UIPanGestureRecognizer *panSender = nil;
    BOOL isSwipe = YES;
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]])
    {
        panSender = (UIPanGestureRecognizer *)sender;
        isSwipe = NO;
    }else if([sender isKindOfClass:[UISwipeGestureRecognizer class]])
    {
        isSwipe = YES;
        sender = (UISwipeGestureRecognizer *)sender;
    }
    
    if (self.viewControllers.count <= self.pageNumberCantBack)
    {
        return;
    }
    
    if (isSwipe)
    {
        if (_needSwipeBackSCRAnimation)
        {
            
            [self popVCAnimated:YES];
        }
    }else
    {
        if (_needSwipeBackIMGAnimation)
        {
            CGPoint currentPoint = [sender translationInView:self.view];
            CGFloat xOffset = currentPoint.x - startTouch.x;
            
            if ([self.viewControllers count] > 1)
            {
                if (panSender.state != (UIGestureRecognizerStateEnded))
                {
                    if (!isMoving)
                    {
                        if (xOffset > 10)
                        {
                            isMoving = YES;
                            
                            UIImage *img = [_allviewImg lastObject];
                            
                            if (backView)
                            {
                                RELEASEVIEW(backView);
                                RELEASEVIEW(blackView);
                            }
                            backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
                            [backView setImage:img];
                            
                            blackView = [[UIView alloc] initWithFrame:backView.frame];
                            [blackView setBackgroundColor:[UIColor blackColor]];
                            [self.view.superview addSubview:blackView];
                            [self.view.superview sendSubviewToBack:blackView];
                            [self.view.superview addSubview:backView];
                            [self.view.superview sendSubviewToBack:backView];
                            [self.view.superview setBackgroundColor:[UIColor blackColor]];
                        }
                    }
                    
                    if (isMoving)
                    {
                        [self moveViewWithX:xOffset];
                    }
                }
                if (panSender.state == (UIGestureRecognizerStateEnded))
                {
                    
                    if (self.view.frame.origin.x > 60)
                    {
                        [UIView animateWithDuration:.3 animations:^{
                            [self moveViewWithX:320];
                        } completion:^(BOOL finished) {
                            [self.view setCenter:CGPointMake(160, self.view.center.y)];
                            [self popVCAnimated:NO];
                            RELEASEVIEW(backView);
                            RELEASEVIEW(blackView);
                            [self.view.superview setBackgroundColor:[UIColor whiteColor]];
                            isMoving = NO;
                        }];
                        
                    }else
                    {
                        [UIView animateWithDuration:.3f
                                         animations:^{
                                             [self moveViewWithX:0];
                                         } completion:^(BOOL finished) {
                                             RELEASEVIEW(backView);
                                             RELEASEVIEW(blackView);
                                             [self.view.superview setBackgroundColor:[UIColor whiteColor]];
                                             isMoving = NO;
                                         }];
                        
                    }
                }
            }
        }
    
    }
    
    
}

- (void)moveViewWithX:(float)x
{
    
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/6400)+0.95;
    float alpha = 0.4 - (x/800);
    
    backView.transform = CGAffineTransformMakeScale(scale, scale);
    blackView.alpha = alpha;
    
}

@end
