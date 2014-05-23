//
//  Dragon_UIScrollView.m
//  DragonFramework
//
//  Created by NewM on 13-3-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UIScrollView.h"
#import "UIView+DragonViewSignal.h"

@interface DragonUIScrollView ()

- (void)initSelf;
@end

@implementation DragonUIScrollView
DEF_SIGNAL(SCROLLVIEWDIDSCROLL)// - (void)scrollViewDidScroll:(UIScrollView *)scrollView;
DEF_SIGNAL(SCROLLVIEWDIDZOOM)//- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2);
DEF_SIGNAL(SCROLLVIEWWILLBEGINDRAGGING)//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
DEF_SIGNAL(SCROLLVIEWWILLENDDRAGGING)//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0);
DEF_SIGNAL(SCROLLVIEWDIDENDDRAGGING)//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
DEF_SIGNAL(SCROLLVIEWWILLBEGINDECELERATING)//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
DEF_SIGNAL(SCROLLVIEWDIDENDDECELERATING)//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
DEF_SIGNAL(SCROLLVIEWDIDENDSCROLLINGANIMATION)//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
DEF_SIGNAL(VIEWFORZOOMINGINSCROLLVIEW)//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
DEF_SIGNAL(SCROLLVIEWWILLBEGINZOOMING)//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2);
DEF_SIGNAL(SCROLLVIEWDIDENDZOOMING)//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;
DEF_SIGNAL(SCROLLVIEWSHOULDSCROLLTOTOP)//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
DEF_SIGNAL(SCROLLVIEWDIDSCROLLTOTOP)//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;

- (void)initSelf
{
    self.delegate = self;
    self.pagingEnabled = NO;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
    
}

#pragma mark - scrollviewdelete
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", nil];
    [self sendViewSignal:[DragonUIScrollView SCROLLVIEWDIDSCROLL] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2)
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", nil];
    [self sendViewSignal:[DragonUIScrollView SCROLLVIEWDIDZOOM] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", nil];
    [self sendViewSignal:[DragonUIScrollView SCROLLVIEWWILLBEGINDRAGGING] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    // velocity, @"velocity", targetContentOffset, @"targetContentOffset",暂时注释掉
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", nil];
    [self sendViewSignal:[DragonUIScrollView SCROLLVIEWWILLENDDRAGGING] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSNumber *nDecelerate = [NSNumber numberWithBool:decelerate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", nDecelerate, @"nDecelerate", nil];
    [self sendViewSignal:[DragonUIScrollView SCROLLVIEWDIDENDDRAGGING] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", nil];
    [self sendViewSignal:[DragonUIScrollView SCROLLVIEWWILLBEGINDECELERATING] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", nil];
    [self sendViewSignal:[DragonUIScrollView SCROLLVIEWDIDENDDECELERATING] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", nil];
    [self sendViewSignal:[DragonUIScrollView SCROLLVIEWDIDENDSCROLLINGANIMATION] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", nil];
    DragonViewSignal *viewSignal = [self sendViewSignal:[DragonUIScrollView VIEWFORZOOMINGINSCROLLVIEW] withObject:dict];
    UIView *returnView = (UIView *)[viewSignal returnValue];
    RELEASEDICTARRAYOBJ(dict);
    return returnView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2)
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", view, @"view", nil];
    [self sendViewSignal:[DragonUIScrollView SCROLLVIEWWILLBEGINZOOMING] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", view, @"view", scale, @"scale", nil];
    [self sendViewSignal:[DragonUIScrollView SCROLLVIEWDIDENDZOOMING] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", nil];
    DragonViewSignal *viewSignal = [self sendViewSignal:[DragonUIScrollView SCROLLVIEWSHOULDSCROLLTOTOP] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
    
    if (viewSignal && [viewSignal returnValue]) {
        return viewSignal.boolValue;
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:scrollView, @"scrollView", nil];
    [self sendViewSignal:[DragonUIScrollView SCROLLVIEWDIDSCROLLTOTOP] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
}

@end
