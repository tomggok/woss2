//
//  Magic_UIUpdateView.m
//  DYiBan
//
//  Created by NewM on 13-8-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_UIUpdateView.h"
#import <QuartzCore/QuartzCore.h>

#ifndef DSlimeRefresh_SRDefine_h
#define DSlimeRefresh_SRDefine_h

#define kStartTo    .7f
#define kEndTo      .15f

#define kRefreshImageWidth  17.f
#define kAnimationInterval  (1.f/50.f)
#endif

NS_INLINE CGPoint pointLineToArc(CGPoint center, CGPoint p2, float angle, CGFloat radius)
{
    float angleS = atan2f(p2.y - center.y, p2.x - center.x);
    float angleT = angleS + angle;
    float x = radius * cosf(angleT);
    float y = radius * sinf(angleT);
    return CGPointMake(x + center.x, y + center.y);
}

@implementation DSlimeView
{
    __unsafe_unretained id _target;
    SEL _action;
}
@synthesize viscous = _viscous,toPoint = _toPoint;
@synthesize startPoint = _startPoint, skinColor = _skinColor;
@synthesize bodyColor = _bodyColor, radius = _radius;
@synthesize missWhenApart = _missWhenApart, state = _state;

@synthesize refreshHeight = _refreshHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        _toPoint = _startPoint = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        
        _viscous = 55.f;
        _radius = 15.f;
        _refreshHeight = .0f;
        self.bodyColor = [UIColor blackColor];
        self.skinColor = [UIColor colorWithWhite:.8f alpha:.9f];
        
        _missWhenApart = YES;
        _lineWith = 2;
    }
    return self;
}

- (void)setLineWith:(CGFloat)lineWith
{
    _lineWith = lineWith;
    [self setNeedsDisplay];
}

- (void)setStartPoint:(CGPoint)startPoint
{
    if (CGPointEqualToPoint(_startPoint, startPoint))
    {
        return;
    }
    if (_state == DSlimeStateNormal)
    {
        _startPoint = startPoint;
        [self setNeedsDisplay];
    }
}

- (void)setToPoint:(CGPoint)toPoint
{
    if (CGPointEqualToPoint(_toPoint, toPoint))
    {
        return;
    }
    
    if (_state == DSlimeStateNormal)
    {
        _toPoint = toPoint;
        [self setNeedsDisplay];
    }
}

- (UIBezierPath *)bodyPath:(CGFloat)startRadius end:(CGFloat)endRadius percent:(CGFloat)percent
{
    UIBezierPath *path = AUTORELEASE([[UIBezierPath alloc] init]);
    float angle1 = M_PI / 3 + (M_PI / 6) * percent;
    
    CGPoint sp1 = pointLineToArc(_startPoint, _toPoint, angle1, startRadius),
            sp2 = pointLineToArc(_startPoint, _toPoint, -angle1, startRadius),
            ep1 = pointLineToArc(_toPoint, _startPoint, M_PI/2, endRadius),
            ep2 = pointLineToArc(_toPoint, _startPoint, -M_PI/2, endRadius);
    
#define kMiddleP    .6f
    CGPoint mp1 = CGPointMake(sp2.x * kMiddleP + ep1.x * (1 - kMiddleP), sp2.y * kMiddleP + ep1.y * (1 - kMiddleP)),
            mp2 = CGPointMake(sp1.x * kMiddleP + ep2.x * (1 - kMiddleP), sp1.y * kMiddleP + ep2.y * (1 - kMiddleP)),
            mm = CGPointMake((mp1.x + mp2.x) / 2, (mp1.y + mp2.y)/2);
    
    float p = distansBetween(mp1, mp2) / 2 / endRadius * (.9f + percent / 10);
    mp1 = CGPointMake((mp1.x - mm.x) / p + mm.x, (mp1.y - mm.y) / p + mm.y);
    mp2 = CGPointMake((mp2.x - mm.x) / p + mm.x, (mp2.y - mm.y) / p + mm.y);
    
    [path moveToPoint:sp1];
    float angleS = atan2f(_toPoint.y - _startPoint.y, _toPoint.x - _startPoint.x);
    [path addArcWithCenter:_startPoint radius:startRadius startAngle:angleS + angle1 endAngle:angleS + M_PI*2 - angle1 clockwise:YES];
    [path addQuadCurveToPoint:ep1 controlPoint:mp1];
    
    angleS = atan2f(_startPoint.y - _toPoint.y, _startPoint.x - _toPoint.x);
    [path addArcWithCenter:_toPoint radius:endRadius startAngle:angleS + M_PI/2 endAngle:angleS+M_PI*3/2 clockwise:YES];
    [path addQuadCurveToPoint:sp1 controlPoint:mp2];
    return path;
}

- (void)drawRect:(CGRect)rect
{
    switch (_state)
    {
        case DSlimeStateNormal:
        {
            float percent = 1 - distansBetween(_startPoint, _toPoint) / _viscous;
            if (percent == 1)
            {
                CGContextRef context = UIGraphicsGetCurrentContext();
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(_startPoint.x - _radius, _startPoint.y - _radius, 2 * _radius, 2 * _radius) cornerRadius:_radius];
                
                [self setContext:context path:path];
                CGContextDrawPath(context, kCGPathFillStroke);
            }else
            {
                CGFloat startRadius = _radius * (kStartTo + (1 - kStartTo) * percent);
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                CGFloat endRadius = _radius * (kEndTo + (1 - kEndTo) * percent);
                UIBezierPath *path = [self bodyPath:startRadius end:endRadius percent:percent];
                [self setContext:context path:path];
                CGContextDrawPath(context, kCGPathFillStroke);
                if (percent <= _refreshHeight)
                {
                    _state = DSlimeStateShortening;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
                    [self performSelector:@selector(scaling) withObject:nil afterDelay:kAnimationInterval inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                }
            }
            
        }
            break;
        case DSlimeStateShortening:
        {
            _toPoint = CGPointMake((_toPoint.x - _startPoint.x) * .8f + _startPoint.x, (_toPoint.y - _startPoint.y) * .8f + _startPoint.y);
            
            float p = distansBetween(_startPoint, _toPoint) / _viscous;
            float percent = 1 - p;
            float r = _radius * p;
            
            if (p > 0.01)
            {
                CGFloat startRadius = r * (kStartTo + (1 - kStartTo) * percent);
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                CGFloat endRadius = r * (kEndTo + (1 - kEndTo) * percent) * (1 + percent / 2);
                UIBezierPath *path = [self bodyPath:startRadius end:endRadius percent:percent];
                [self setContext:context path:path];
                CGContextDrawPath(context, kCGPathFillStroke);
                
            }else
            {
                self.hidden = YES;
                _state = DSlimeStateMiss;
            }
        
        }
            break;
        default:
            break;
    }
}

- (void)setContext:(CGContextRef)context path:(UIBezierPath *)path
{
    if (self.shadowColor)
    {
        switch (self.shadowType)
        {
            case DSlimeBlurShadow:
                CGContextSetShadowWithColor(context, CGSizeZero, self.shadowBlur, self.shadowColor.CGColor);
                break;
            case DSlimeFillShadow:
                CGContextAddPath(context, path.CGPath);
                CGContextSetLineWidth(context, self.shadowBlur);
                CGContextSetStrokeColorWithColor(context, self.shadowColor.CGColor);
                CGContextDrawPath(context, kCGPathFillStroke);
                break;
                
            default:
                break;
        }
        
    }
    CGContextSetFillColorWithColor(context, self.bodyColor.CGColor);
    CGContextSetLineWidth(context, self.lineWith);
    CGContextSetStrokeColorWithColor(context, self.skinColor.CGColor);
    CGContextAddPath(context, path.CGPath);
}

- (void)scaling
{
    if (_state == DSlimeStateShortening)
    {
        [self setNeedsDisplay];
        [self performSelector:@selector(scaling) withObject:nil afterDelay:kAnimationInterval inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)setPullApartTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (!hidden)
    {
        self.layer.transform = CATransform3DIdentity;
        [self setNeedsDisplay];
    }
}

- (void)setState:(DSlimeState)state
{
    _state = state;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scaling) object:nil];
}
@end


@interface MagicUIUpdateView ()
@property (nonatomic, assign)BOOL broken;
@property (nonatomic, retain)MagicUIScrollView *scrollView;

@end

@implementation MagicUIUpdateView
{
    UIActivityIndicatorView *_activityIndicatorView;
    CGFloat _oldLength;
    BOOL _unmissSlime;
    CGFloat _dragingHeight;
}
@synthesize delegate = _delegate, broken = _broken;
@synthesize loading = _loading, scrollView = _scrollView;
@synthesize slime = _slime, refleshView = _refleshView;
@synthesize block = _block, upInset = _upInset;
@synthesize slimeMissWhenGoingBack = _slimeMissWhenGoingBack;
@synthesize activityIndicationView = _activityIndicatorView;
@synthesize updateState = _updateState;

- (void)setUpdateState:(DUpdateState)updateState
{
    _updateState = updateState;
    if (_updateState == DUpdateStateUpLoad)
    {
        [self setHidden:YES];
    }else
    {
        [self setHidden:NO];
    }
}

- (void)dealloc
{
    RELEASEVIEW(_activityIndicatorView)
    RELEASEVIEW(_slime)
    RELEASEVIEW(_refleshView)
//    RELEASEVIEW(_scrollView);
    [super dealloc];
}

- (id)init
{
    self = [self initWithHeight:32 + 10];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithHeight:32 + 10];
    
    return self;
}

- (id)initWithHeight:(CGFloat)height
{
    CGRect frame = MAINFRAME;
    frame.size.height = height;
    self = [super initWithFrame:frame];
    if (self)
    {
        _slime = [[DSlimeView alloc] initWithFrame:CGRectMake(.0f, .0f, frame.size.width, frame.size.height)];
        _slime.startPoint = CGPointMake(frame.size.width / 2, height / 2 + 5);
        [self addSubview:_slime];
        
        _refleshView = [[MagicUIImageView alloc] initWithImage:[UIImage imageNamed:@"sr_refresh"]];
        _refleshView.center = _slime.startPoint;
        _refleshView.bounds = CGRectMake(.0f, .0f, kRefreshImageWidth, kRefreshImageWidth);
        [self addSubview:_refleshView];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicatorView stopAnimating];
        _activityIndicatorView.center = _slime.startPoint;
        [self addSubview:_activityIndicatorView];
        
        [_slime setPullApartTarget:self action:@selector(pullApart:)];
        _dragingHeight = height;
        
        _updateState = DUpdateStateNomal;
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_slime.state == DSlimeStateNormal)
    {
        _slime.frame = CGRectMake(.0f, .0f, frame.size.width, frame.size.height);
        _slime.startPoint = CGPointMake(frame.size.width / 2, _dragingHeight / 2 + 5);
    }
    _refleshView.center = _slime.startPoint;
    _activityIndicatorView.center = _slime.startPoint;
}

- (void)setUpInset:(CGFloat)upInset
{
    _upInset = upInset;
    UIEdgeInsets inset = _scrollView.contentInset;
    inset.top = _upInset;
    _scrollView.contentInset = inset;
}

- (void)setSlimeMissWhenGoingBack:(BOOL)slimeMissWhenGoingBack
{
    _slimeMissWhenGoingBack = slimeMissWhenGoingBack;
    if (!slimeMissWhenGoingBack)
    {
        _slime.alpha = 1.f;
    }else
    {
        CGPoint p = _scrollView.contentOffset;
        self.alpha = - (p.y + _upInset) / _dragingHeight;
    }
}

- (void)setLoading:(BOOL)loading
{
    if (_loading == loading) {
        return;
    }
    _loading = loading;
    if (_loading) {
        [_activityIndicatorView startAnimating];
        CAKeyframeAnimation *aniamtion = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        
        aniamtion.values = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:
                             CATransform3DRotate(CATransform3DMakeScale(0.01, 0.01, 0.1),
                                                 -M_PI, 0, 0, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.6, 1.6, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity],nil];
        aniamtion.keyTimes = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:0.6],
                              [NSNumber numberWithFloat:1], nil];
        aniamtion.timingFunctions = [NSArray arrayWithObjects:
                                     [CAMediaTimingFunction functionWithName:
                                      kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:
                                      kCAMediaTimingFunctionEaseInEaseOut],
                                     nil];
        aniamtion.duration = 0.7;
        _activityIndicatorView.layer.transform = CATransform3DIdentity;
        [_activityIndicatorView.layer addAnimation:aniamtion
                                            forKey:@""];
        //_slime.hidden = YES;
        _refleshView.hidden = YES;
        if (!_scrollView.isDragging) {
            UIEdgeInsets inset = _scrollView.contentInset;
            inset.top = _upInset + _dragingHeight;
            _scrollView.contentInset = inset;
        }
        if (!_unmissSlime){
            _slime.state = DSlimeStateMiss;
        }else {
            _unmissSlime = NO;
        }
    }else {
        
        [_activityIndicatorView stopAnimating];
        _slime.hidden = NO;
        _refleshView.hidden = NO;
        _refleshView.layer.transform = CATransform3DIdentity;
        [UIView transitionWithView:_scrollView
                          duration:0.3f
                           options:UIViewAnimationCurveEaseOut
                        animations:^{
                            UIEdgeInsets inset = _scrollView.contentInset;
                            inset.top = _upInset;
                            _scrollView.contentInset = inset;
                            if (_scrollView.contentOffset.y == -_upInset &&
                                _slimeMissWhenGoingBack) {
                                self.alpha = 0.0f;
                            }
                        } completion:^(BOOL finished) {
                            //_notSetFrame = NO;
                        }];
        
    }
}

- (void)setLoadingWithexpansion
{
    self.loading = YES;
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, -_scrollView.contentInset.top) animated:YES];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if ([self.superview isKindOfClass:[UIScrollView class]])
    {
//        MagicUITableView *tableView = ;
        _scrollView = (MagicUIScrollView *)[self superview];
        CGRect rect = self.frame;
        rect.origin.y = rect.size.height ? -rect.size.height : -_dragingHeight;
        rect.size.width = _scrollView.frame.size.width;
        self.frame = rect;
        self.slime.toPoint = self.slime.startPoint;
        
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = _upInset;
        self.scrollView.contentInset = inset;
    }else if (!self.superview)
    {
        self.scrollView = nil;
    }
}

#pragma mark -
#pragma mark action
- (void)pullApart:(MagicUIUpdateView *)refreshView
{
    self.broken = YES;
    _unmissSlime = YES;
    self.loading = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(slimeRefreshStart:)])
    {
        [(id)_delegate performSelector:@selector(slimeRefreshStart:) withObject:self afterDelay:0.0];
    }
    if (_block)
    {
        _block(self);
    }
}

- (void)scrollViewDidScroll
{
    if (_updateState == DUpdateStateNomal || _updateState ==DUpdateStateUpLoadEnd)
    {
        CGPoint p = _scrollView.contentOffset;
        CGRect rect = self.frame;
        if (p.y <= -_dragingHeight - _upInset)
        {
            rect.origin.y = p.y + _upInset;
            rect.size.height = -p.y;
            rect.size.height = ceilf(rect.size.height);
            self.frame = rect;
            if (!self.loading)
            {
                [_slime setNeedsDisplay];
            }
            if (!_broken)
            {
                float l = -(p.y + _dragingHeight + _upInset);
                if (l <= _oldLength)
                {
                    l = MIN(distansBetween(_slime.startPoint, _slime.toPoint), l);
                    CGPoint ssp = _slime.startPoint;
                    _slime.toPoint = CGPointMake(ssp.x, ssp.y + l);
                    CGFloat pf = (1.f - l / _slime.viscous) * (1.f - kStartTo) + kStartTo;
                    _refleshView.layer.transform = CATransform3DMakeScale(pf, pf, 1);
                }else if (self.scrollView.isDragging){
                    CGPoint ssp = _slime.startPoint;
                    _slime.toPoint = CGPointMake(ssp.x, ssp.y + l);
                    CGFloat pf = (1.f - l/_slime.viscous) * (1.f - kStartTo) + kStartTo;
                    _refleshView.layer.transform = CATransform3DMakeScale(pf, pf, 1);
                }
                _oldLength = l;
            }
            if (self.alpha != 1.f)
            {
                self.alpha = 1.f;
            }
        }else if (p.y < -_upInset)
        {
            rect.origin.y = -_dragingHeight;
            rect.size.height = _dragingHeight;
            self.frame = rect;
            [_slime setNeedsDisplay];
            _slime.toPoint = _slime.startPoint;
            if (_slimeMissWhenGoingBack)
            {
                self.alpha = - (p.y + _upInset) / _dragingHeight;
            }
        }

    }
}

- (void)scrollViewDidEndDraging
{
    if (_broken)
    {
        if (self.loading)
        {
            [UIView transitionWithView:_scrollView
                              duration:.2f
                               options:UIViewAnimationCurveEaseOut
                            animations:^{
                                   UIEdgeInsets inset = _scrollView.contentInset;
                                   inset.top = _upInset + _dragingHeight;
                                   _scrollView.contentInset = inset;
                               } completion:^(BOOL finished) {
                                   self.broken = NO;
                               }];
        }else
        {
            [self performSelector:@selector(setBroken:) withObject:nil afterDelay:.2f];
            self.loading = NO;
        }
    }
}

- (void)endRefresh
{
    if (self.loading)
    {
        [self performSelector:@selector(restore) withObject:nil afterDelay:0.f];
    }
    _oldLength = 0;
}

- (void)restore
{
    _slime.toPoint = _slime.startPoint;
    [UIView transitionWithView:_activityIndicatorView
                      duration:.3f
                       options:UIViewAnimationCurveEaseIn
                    animations:^{
                        _activityIndicatorView.layer.transform = CATransform3DRotate(CATransform3DMakeScale(0.01f, 0.01f, 0.1f), -M_PI, 0, 0, 1);
                    } completion:^(BOOL finished) {
                        self.loading = NO;
                        _slime.state = DSlimeStateNormal;
                    }];
}


@end
