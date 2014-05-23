//
//  Dragon_UIThirdView.m
//  DragonFramework
//
//  Created by NewM on 13-7-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UIThirdView.h"

@interface DragonUIThirdView ()
{
    CGPoint     startTouch;//点击view初始值
    bool        isMoving;  //是否在移动第一个view
    CGFloat     noNum;     //第一个view偏差值
}

@property (nonatomic, assign)DragonUIThirdScrollState scrollState;
@end

@implementation DragonUIThirdView
@synthesize firstView= _firstView,
            secondView = _secondView,
            thirdView = _thirdView;
@synthesize leftWidth,
            rightWidth,
            viewDiffenceNum = _viewDiffenceNum;
@synthesize viewType = _viewType, scrollState = _scrollState;

- (void)dealloc
{
    RELEASEVIEW(_firstView)
    RELEASEVIEW(_secondView)
    RELEASEVIEW(_thirdView)
    
    [super dealloc];
}

- (void)initSelf:(CGRect)mainRect
{
    
    _viewDiffenceNum = 60.f;
    _viewType = DragonUINomalView;
    
    _firstView = [[UIView alloc] initWithFrame:mainRect];
    [_firstView setBackgroundColor:[UIColor clearColor]];
    
    _secondView = [[UIView alloc] initWithFrame:mainRect];
    [_secondView setBackgroundColor:[UIColor clearColor]];
    
    _thirdView = [[UIView alloc] initWithFrame:mainRect];
    [_thirdView setBackgroundColor:[UIColor clearColor]];
    
    
    [self addSubview:_thirdView];
    [self addSubview:_secondView];
    [self addSubview:_firstView];
    
    UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc] init];
    [swipe setDelegate:self];
    [_firstView addGestureRecognizer:swipe];
    [swipe addTarget:self action:@selector(oneViewSwipe:)];
    
    RELEASE(swipe)
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect mainRect = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:mainRect];
    if (self) {
        [self initSelf:mainRect];
    }
    return self;
}

- (void)setScrollState:(DragonUIThirdScrollState)scrollState
{
    _scrollState = scrollState;
    BOOL isTouch = YES;
    if (scrollState != DragonScrollNomal)
    {
        isTouch = NO;
    }else
    {
        isTouch = YES;
    }
    
    NSArray *suArr = [_firstView subviews];
    
    for (int i = 0; i < [suArr count]; i++)
    {
        UIView *view = [suArr objectAtIndex:i];
        [view setUserInteractionEnabled:isTouch];
    }
}

#pragma mark -
#pragma mark - gesturedelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    startTouch = [gestureRecognizer translationInView:self];
    isMoving = NO;
    
    if (_viewType == DragonUINoScroll)
    {
        return NO;
    }
    
    
    if (_viewType == DragonUILeftView)
    {
        if (startTouch.x + noNum < 0)
        {
            return NO;
        }
    }else if (_viewType == DragonUIRightView)
    {
        if (startTouch.x + noNum > 0)
        {
            return NO;
        }
        
    }
    
    return YES;
}

- (void)oneViewSwipe:(UIPanGestureRecognizer *)sender
{
    CGPoint currentPoint = [sender translationInView:self];
    
    CGFloat xOffset = currentPoint.x - startTouch.x + noNum;
    
    if (_viewType == DragonUILeftView)
    {
        if (xOffset < 0)
        {
            [self endMoveViewWithX:0];
            return;
        }
    }else if (_viewType == DragonUIRightView)
    {
        if (xOffset > 0)
        {
            [self endMoveViewWithX:0];
            return;
        }
        
    }
    
    DLogInfo(@"xOffset === %f", xOffset);
    
    BOOL isNum = xOffset > 10 ? YES : NO;
    
    if (sender.state != UIGestureRecognizerStateEnded)
    {
        if ((isNum && xOffset > 10) || (!isNum && xOffset < 10))
        {
            isMoving = YES;
            if (isNum)
            {
                _viewDiffenceNum = leftWidth/2;
                [_secondView setHidden:NO];
                [_thirdView setHidden:YES];
            }else
            {
                _viewDiffenceNum = rightWidth/2;
                [_secondView setHidden:YES];
                [_thirdView setHidden:NO];
            }
        }
        
        if (isMoving)
        {
            [self moveViewWithX:xOffset];
        }
        
    }else if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ((isNum && (xOffset) < _viewDiffenceNum) || (!isNum && (xOffset) > -_viewDiffenceNum))
        {
//            noNum = 0;
//            [UIView animateWithDuration:.3f
//                             animations:^{
//                                 [self moveViewWithX:0];
//                             } completion:^(BOOL finished) {
//                                 
//                             }];
            [self endMoveViewWithX:0];
        }else
        {
            if (isNum)
            {
//                [UIView animateWithDuration:.3f
//                                 animations:^{
//                                     [self moveViewWithX:leftWidth];
//                                 } completion:^(BOOL finished) {
//                                     
//                                 }];
//                noNum = leftWidth;
                [self endMoveViewWithX:leftWidth];
            }else
            {
//                [UIView animateWithDuration:.3f
//                                 animations:^{
//                                     [self moveViewWithX:-rightWidth];
//                                 } completion:^(BOOL finished) {
//                                     
//                                 }];
//                noNum = -rightWidth;
                [self endMoveViewWithX:-rightWidth];
            }
        }
    }
    
}

- (void)endMoveViewWithX:(CGFloat)xOffset
{
    
    if (xOffset == 0)
    {
        self.scrollState = DragonScrollNomal;
    }else if (xOffset >0)
    {
        [_secondView setHidden:NO];
        [_thirdView setHidden:YES];
        self.scrollState = DragonScrollLeft;
    }else if (xOffset < 0)
    {
        [_secondView setHidden:YES];
        [_thirdView setHidden:NO];
        self.scrollState = DragonScrollRight;
    }
    
    [UIView animateWithDuration:.3f
                     animations:^{
                         [self moveViewWithX:xOffset];
                     } completion:^(BOOL finished) {
                         
                     }];
    noNum = xOffset;
}

- (void)moveViewWithX:(CGFloat)xOffset
{
    CGRect frame = _firstView.frame;
    
    frame.origin.x = xOffset;
    
    _firstView.frame = frame;
}

#pragma mark - 
#pragma mark - touchDelegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_firstView];
    DLogInfo(@"point.x == %f", point.x);
    
    if (point.x >= 0)
    {
        [self endMoveViewWithX:0];
    }

}


@end
