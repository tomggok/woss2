//
//  Dragon_ZoomView.m
//  DragonFramework
//
//  Created by NewM on 13-7-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UIZoomView.h"

@implementation DragonUIZoomInnerView
@synthesize zoomDelegate = _zoomDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.numberOfTouchesRequired = 1;
        singleTapGesture.cancelsTouchesInView = YES;
        singleTapGesture.delaysTouchesBegan = YES;
        singleTapGesture.delaysTouchesEnded = YES;
        [self addGestureRecognizer:singleTapGesture];
        RELEASE(singleTapGesture);
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        doubleTapGesture.numberOfTouchesRequired = 1;
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.cancelsTouchesInView = YES;
        [self addGestureRecognizer:doubleTapGesture];
//        [doubleTapGesture release];
        RELEASE(doubleTapGesture);
        
    }
    return self;
    
}

- (void)setContentSize:(CGSize)size
{
    CGPoint middlePos;
    CGSize selfSize = self.frame.size;
    CGSize contSize = CGSizeZero;
    UIView *contView = nil;
    
    if (_zoomDelegate && [_zoomDelegate respondsToSelector:@selector(zoomContentSize:)])
    {
        contView = [_zoomDelegate zoomContentView:self];
    }
    
    if (_zoomDelegate && [_zoomDelegate respondsToSelector:@selector(zoomContentSize:)])
    {
        contSize = [_zoomDelegate zoomContentSize:self];
    }
    
    if (!contView)
    {
        return;
    }
    
    if (self.zoomScale >= self.minimumZoomScale)
    {
        float newHeight = contSize.height * self.zoomScale;
        float newWidth = contSize.width * self.zoomScale;
        
        if (newHeight < selfSize.height)
        {
            newHeight = selfSize.height;
        }
        
        if (newWidth < selfSize.width)
        {
            newWidth = selfSize.width;
        }
        
        size.height = newHeight;
        size.width = newWidth;
        
        middlePos = CGPointMake(size.width / 2.f, size.height / 2.f);
    }else
    {
        middlePos = CGPointMake(selfSize.width / 2.f, selfSize.height / 2.f);
    }
    
    contView.center = middlePos;
    [super setContentSize:size];
    
    if (_zoomDelegate)
    {
        [_zoomDelegate zoomInnerViewChanged:self];
    }
}

- (void)onSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (UIGestureRecognizerStateEnded == recognizer.state)
    {
        CGPoint location = [recognizer locationInView:self];
        if (_zoomDelegate)
        {
            [_zoomDelegate zoomInnerViewSingleTapped:self location:location];
        }
    }
}

- (void)onDoubleTap:(UITapGestureRecognizer *)recognizer
{
    if (UIGestureRecognizerStateEnded == recognizer.state)
    {
        CGPoint location = [recognizer locationInView:self];
        if (_zoomDelegate)
        {
            [_zoomDelegate zoomInnerViewDoubleTapped:self location:location];
        }
    }
}


@end

@interface DragonUIZoomView ()

- (void)initSelf:(CGRect)frame;
- (void)whenScalingAnimationStopped;
//- (void)onSingleTap:(UITapGestureRecognizer *)recognizer;
//- (void)onDoubleTap:(UITapGestureRecognizer *)recognizer;

@end

@implementation DragonUIZoomView
DEF_SIGNAL(ZOOMING)
DEF_SIGNAL(ZOOMED)
DEF_SIGNAL(SINGLE_TAPPED)
DEF_SIGNAL(DOUBLE_TAPPED)

@synthesize innerView = _innerView;
@synthesize content = _content;
@synthesize contentSize = _contentSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf:frame];
    }
    return self;
}

- (void)initSelf:(CGRect)frame
{
    self.alpha = 1.f;
    self.backgroundColor = [UIColor clearColor];
    
    [_innerView release];
	_innerView = [[DragonUIZoomInnerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
	_innerView.backgroundColor = [UIColor clearColor];
	_innerView.zoomScale = 1.0f;
	_innerView.minimumZoomScale = 0.8f;
	_innerView.maximumZoomScale = 4.0f;
	_innerView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	_innerView.contentMode = UIViewContentModeScaleAspectFit;
	_innerView.contentOffset = CGPointZero;
	_innerView.contentSize = CGSizeMake( frame.size.width, frame.size.height );
	_innerView.clipsToBounds = YES;
	_innerView.bouncesZoom = YES;
	_innerView.scrollEnabled = YES;
	_innerView.bouncesZoom = YES;
	_innerView.bounces = YES;
	_innerView.decelerationRate = _innerView.decelerationRate * 0.75f;
	_innerView.showsVerticalScrollIndicator = NO;
	_innerView.showsHorizontalScrollIndicator = NO;
	_innerView.multipleTouchEnabled = YES;
	_innerView.delegate = self;
	_innerView.zoomDelegate = self;
	[self addSubview:_innerView];
}

- (void)handleViewSignal_DragonUIImageView:(DragonViewSignal *)signal
{
    UIImage *img = (UIImage *)[signal object];

    [self setPhotoSize:img.size];    
}

- (void)setPhotoSize:(CGSize)size
{
    
    CGFloat imgY = (self.frame.size.height - size.height/2)/2;
    
    _content.frame = CGRectMake(0, imgY, size.width/2, size.height/2);
    
    CGSize photo = CGSizeMake(size.width/2, size.height/2);
    
    [self setContentSize:photo];
    [self layoutContent];
}

- (void)resetZoom
{
	_innerView.zoomScale = 1.0f;
}

- (void)layoutContent
{
	_content.frame = AspectFitRect( CGRectMake(0, 0, _contentSize.width, _contentSize.height), self.bounds );
	_innerView.frame = self.bounds;
	_innerView.contentSize = _contentSize;
    
	[self layoutSubviews];
}

- (void)layoutContentRotated
{
	CGRect bound;
	bound.origin = self.bounds.origin;
	bound.size.width = self.bounds.size.height;
	bound.size.height = self.bounds.size.width;
	
	_content.frame = AspectFitRect( CGRectMake(0, 0, _contentSize.height, _contentSize.width), bound );
	_innerView.frame = bound;
	
	CGSize contSize;
	contSize.width = _contentSize.height;
	contSize.height = _contentSize.width;
    
	_innerView.contentSize = contSize;
	
	[self layoutSubviews];
}

- (void)setContentSize:(CGSize)size
{
	_contentSize = AspectFitSize( size, self.bounds.size );
}

- (void)setContent:(UIView *)contentView animated:(BOOL)animated
{
	if ( nil == contentView )
		return;
	
	if ( contentView == _content )
		return;
	
	if ( _content )
	{
		[_content removeFromSuperview];
	}
    
	self.content = contentView;
    
	if ( _content )
	{
		[_innerView addSubview:_content];
        
        [self setPhotoSize:_content.frame.size];
        
        
		if ( animated )
		{
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.3f];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(whenScalingAnimationStopped)];
		}
        
		[self layoutSubviews];
        
		if ( animated )
		{
			[UIView commitAnimations];
		}
		else
		{
			[self whenScalingAnimationStopped];
		}
	}
}

- (void)whenScalingAnimationStopped
{
}

- (void)dealloc
{
    RELEASEVIEW(_content);
    RELEASEVIEW(_innerView);
    [super dealloc];
}

#pragma mark - 
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self sendViewSignal:[DragonUIZoomView ZOOMING]];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self sendViewSignal:[DragonUIZoomView ZOOMED]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self sendViewSignal:[DragonUIZoomView ZOOMING]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self sendViewSignal:[DragonUIZoomView ZOOMING]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self sendViewSignal:[DragonUIZoomView ZOOMING]];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _content;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [self sendViewSignal:[DragonUIZoomView ZOOMED]];
    
    if (_innerView.zoomScale < 1.f)
    {
        [_innerView setZoomScale:1.f animated:YES];
    }
}

#pragma mark - 
#pragma mark ZoomInnerViewDelegate
- (CGSize)zoomContentSize:(DragonUIZoomInnerView *)view
{
    return _contentSize;
}

- (UIView *)zoomContentView:(DragonUIZoomInnerView *)view
{
    return _content;
}

- (void)zoomInnerViewChanged:(DragonUIZoomInnerView *)view
{
    [self sendViewSignal:[DragonUIZoomView ZOOMING]];
}

- (void)zoomInnerViewSingleTapped:(DragonUIZoomInnerView *)view location:(CGPoint)location
{
    NSNumber *x = [NSNumber numberWithFloat:location.x];
    NSNumber *y = [NSNumber numberWithFloat:location.y];

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil];
    [self sendViewSignal:[DragonUIZoomView SINGLE_TAPPED] withObject:dict];
}

- (void)zoomInnerViewDoubleTapped:(DragonUIZoomInnerView *)view location:(CGPoint)location
{
    CGRect	zoomRect;
    float	zoomScale = 0.0f;
	
	if ( _innerView.zoomScale < 1.0f )
	{
		zoomScale = 1.0f;
	}
	else if ( _innerView.zoomScale == 1.0f )
	{
		zoomScale = _innerView.maximumZoomScale;
	}
	else if ( _innerView.zoomScale > 1.0f && _innerView.zoomScale < _innerView.maximumZoomScale )
	{
		zoomScale = _innerView.maximumZoomScale;
	}
	else
	{
		zoomScale = 1.0f; // _innerView.minimumZoomScale;
	}
	
	zoomRect.size.width  = _innerView.frame.size.width  / zoomScale;
	zoomRect.size.height = _innerView.frame.size.height / zoomScale;
    zoomRect.origin.x = (self.bounds.size.width - zoomRect.size.width) / 2.0f;
    zoomRect.origin.y = (self.bounds.size.height - zoomRect.size.height) / 2.0f;
	
	[_innerView zoomToRect:zoomRect animated:YES];
    
    [self sendViewSignal:[DragonUIZoomView DOUBLE_TAPPED]];
    
}


CGRect AspectFitRect(CGRect rect, CGRect bound)
{
    CGSize newSize = AspectFitSize( rect.size, bound.size );
	newSize.width = floorf( newSize.width );
	newSize.height = floorf( newSize.height );
	
	CGRect newRect;
	newRect.origin.x = (bound.size.width - newSize.width) / 2;
	newRect.origin.y = (bound.size.height - newSize.height) / 2;
	newRect.size.width = newSize.width;
	newRect.size.height = newSize.height;
    
    
    return newRect;
}

CGSize AspectFitSize(CGSize size, CGSize bound)
{
    CGSize newSize = size;
	CGFloat newScale = 1.0f;
	
	float scaleX = bound.width / newSize.width;
	float scaleY = bound.height / newSize.height;
    
	newScale = fminf( scaleX, scaleY );
	
	newSize.width *= newScale;
	newSize.height *= newScale;
	
	newSize.width = floorf( newSize.width );
	newSize.height = floorf( newSize.height );
    
    return newSize;
}

@end
