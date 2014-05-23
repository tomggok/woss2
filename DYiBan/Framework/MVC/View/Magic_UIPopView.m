//
//  Magic_UIPopView.m
//  MagicFramework
//
//  Created by NewM on 13-6-3.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_UIPopView.h"

@interface MagicUIPopView ()
{
    //阴影背景
    UIView *_shadowView;
    
    //别添加的view
    UIView *_childView;
    
}
@end

@implementation MagicUIPopView
@synthesize needShadow = _needShadow;

DEF_SIGNAL(POPHIDDEN)
DEF_SIGNAL(POPTOUCHEDOTHER)

- (id)initWithFrame:(CGRect)frame
{
    CGRect mainFrame = MAINFRAME;
    self = [super initWithFrame:mainFrame];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    CGRect mainFrame = MAINFRAME;
    [self setFrame:mainFrame];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    if (!_shadowView)
    {
        _shadowView = [[UIView alloc] initWithFrame:mainFrame];
    }

    [self setBackgroundColor:[UIColor clearColor]];
    [_shadowView setFrame:mainFrame];
    [self addSubview:_shadowView];
    [_shadowView release];
     
}

- (void)setShadowColor:(UIColor *)backColor alpha:(CGFloat)alpha
{
    [_shadowView setAlpha:alpha];
    [_shadowView setBackgroundColor:backColor];
    [self setNeedShadow:YES];
}

- (void)setNeedShadow:(BOOL)needShadow
{
    if (needShadow)
    {
        [_shadowView setHidden:NO];
        [_shadowView setBackgroundColor:[UIColor blackColor]];
        [_shadowView setAlpha:.9f];
    }else
    {
        [_shadowView setHidden:YES];
    }
}

- (void)setChildView:(UIView *)childView
{
    CGRect mainFrame = MAINFRAME;
    if (_childView)
    {
        RELEASEVIEW(_childView);
    }
    _childView = childView;
    
    CGFloat childX = (CGRectGetWidth(mainFrame) - CGRectGetWidth(_childView.frame))/2;
    CGFloat childY = (CGRectGetHeight(mainFrame) - CGRectGetHeight(_childView.frame))/2;
    
    CHANGEFRAMEORIGIN(_childView.frame,
                      childX,
                      childY);
    [_childView setHidden:YES];
    [self addSubview:_childView];

}

- (void)alertView
{
    [_childView setHidden:NO];
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_childView.layer addAnimation:animation forKey:nil];
}
//隐藏
- (void)hideView
{
    [self setHidden:YES];
}

//释放
- (void)releaseSelf
{
    RELEASEALLSUBVIEW(self);
    [self removeFromSuperview];
    [self sendViewSignal:[MagicUIPopView POPHIDDEN]];
}
//隐藏并释放
- (void)autoHidenRelease
{
    [self hideView];
    [self releaseSelf];
}

#pragma mark touch delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    if ([self pointInside:touchPoint withEvent:nil])
    {
        [self sendViewSignal:[MagicUIPopView POPTOUCHEDOTHER]];
    }
    
}

- (void)dealloc
{
    
    [super dealloc];
}

@end
