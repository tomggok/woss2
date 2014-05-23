//
//  Dragon_UITimeBlurView.m
//  DragonFramework
//
//  Created by NewM on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UITimeBlurView.h"
#import "UIImage+DragonCategory.h"

@interface DragonTimeBlurViewManager : NSObject

@property (nonatomic, retain)NSMutableArray *views;

+ (id)sharedManager;
- (void)registerView:(DragonUITimeBlurView *)view;
- (void)deregiststerView:(DragonUITimeBlurView *)view;

@end

@interface DragonUITimeBlurView ()
{
}
@property (nonatomic, retain)CALayer *tintLayer;

- (void)renderLayerWithView:(UIView *)superView;

@end


@implementation DragonTimeBlurViewManager

static DragonTimeBlurViewManager *shared = nil;
+ (id)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[DragonTimeBlurViewManager alloc] init];
    });
    
    return shared;
}

- (void)dealloc
{
    RELEASEDICTARRAYOBJ(_views);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _views = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)registerView:(DragonUITimeBlurView *)view
{
    if (![_views containsObject:view])
    {
        [_views addObject:view];
    }
    
    [self refresh];
}

- (void)deregiststerView:(DragonUITimeBlurView *)view
{
    [_views removeObject:view];
    [self refresh];
}


- (void)refresh
{
    if (!_views.count)
    {
        return;
    }
    
    for (DragonUITimeBlurView *view in _views)
    {
        [view renderLayerWithView:view.superview];
    }
    
    double delayInSeconds = self.views.count * (1 / kDTimeBlurViewRenderFps);
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self refresh];
    });
    
}
@end



@implementation DragonUITimeBlurView
@synthesize renderStatic = _renderStatic, tint = _tint;
@synthesize tintLayer = _tintLayer;

@synthesize blurLevel = _blurLevel,tintColorAlpha = _tintColorAlpha;

- (void)dealloc
{
    RELEASEOBJ(_tintLayer);
    RELEASEOBJ(_tint);
    
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tintColorAlpha = kDTimeBlurTintColorAlpha;
        _blurLevel = kDTimeBlurViewBlurLevel;
        
        
        _tintLayer = [[CALayer alloc] init];
        _tintLayer.frame = self.bounds;
        _tintLayer.opacity = _tintColorAlpha;
        
        //todo:use tintColor on IOS7//暂时不知道为啥
        self.tint = [UIColor clearColor];
        
        [self.layer addSublayer:_tintLayer];
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = kDTimeBlurViewDefaultCornerRadius;
        
    }
    return self;
}

- (void)setTintColorAlpha:(CGFloat)tintColorAlpha
{
    _tintColorAlpha = tintColorAlpha;
    _tintLayer.opacity = _tintColorAlpha;
    
}

- (void)setRenderStatic:(BOOL)renderStatic
{
    _renderStatic = renderStatic;
    if (renderStatic)
    {
        [[DragonTimeBlurViewManager sharedManager] deregiststerView:self];
    }else
    {
        [[DragonTimeBlurViewManager sharedManager] registerView:self];
    }
    
}

/* Set the tint color of the view. (default = [UIColor clearColor])
 * TODO: Use iOS7 tintColor *///暂时没有考虑为啥？
- (void)setTint:(UIColor*)tint
{
    _tint = tint;
    self.tintLayer.backgroundColor = _tint.CGColor;
    [self.tintLayer setNeedsDisplay];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self renderLayerWithView:newSuperview];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [[DragonTimeBlurViewManager sharedManager] deregiststerView:self];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview)
    {
        if (!self.renderStatic)
        {
            [[DragonTimeBlurViewManager sharedManager] registerView:self];
        }
    }else
    {
        [[DragonTimeBlurViewManager sharedManager] deregiststerView:self];
    }
    
}

- (void)renderLayerWithView:(UIView *)superView
{
    CGRect visibleRect = [superView convertRect:self.frame toView:self];
    visibleRect.origin.y += self.frame.origin.y;
    visibleRect.origin.x += self.frame.origin.x;
    
    CGFloat alpha = self.alpha;
    [self toggleBlurViewsInView:superView hidden:YES alpha:alpha];
    
    //在图像中渲染层
    UIGraphicsBeginImageContextWithOptions(visibleRect.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -visibleRect.origin.x, -visibleRect.origin.y);
    CALayer *layer = superView.layer;
    [layer renderInContext:context];
    
    //先截父类view在虚化
    [self toggleBlurViewsInView:superView hidden:NO alpha:alpha];
    
    __block UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [image retain];
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //让截取该范围的图片在当前屏幕虚化
        //调整图片的质量
        NSData *imageData = UIImageJPEGRepresentation(image, kDTimeBlurViewScreenshotCompression);
        RELEASEOBJ(image);
        image = [[UIImage imageWithData:imageData] boxblurImageWithBlur:_blurLevel];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //更新图层
            self.layer.contents = (id)image.CGImage;
        });
    });
    
    
    
}
//
- (void)toggleBlurViewsInView:(UIView*)view hidden:(BOOL)hidden alpha:(CGFloat)originalAlpha
{
    for (UIView *subView in view.subviews)
    {
        if ([subView isKindOfClass:[DragonUITimeBlurView class]])
        {
            subView.alpha = hidden ? .0f : originalAlpha;
        }
    }
}

@end
