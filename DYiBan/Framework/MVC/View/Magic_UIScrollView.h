//
//  Magic_UIScrollView.h
//  MagicFramework
//
//  Created by NewM on 13-3-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Magic_ViewSignal.h"
#import "UIView+MagicViewSignal.h"

enum scrollViewType {
    DIRECTION_HORIZONTAL = 0,
    DIRECTION_VERTICAL = 1
};

@interface MagicUIScrollView : UIScrollView<UIScrollViewDelegate>
{
}

AS_SIGNAL(SCROLLVIEWDIDSCROLL)// - (void)scrollViewDidScroll:(UIScrollView *)scrollView;
AS_SIGNAL(SCROLLVIEWDIDZOOM)//- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2);
AS_SIGNAL(SCROLLVIEWWILLBEGINDRAGGING)//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
AS_SIGNAL(SCROLLVIEWWILLENDDRAGGING)//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0);
AS_SIGNAL(SCROLLVIEWDIDENDDRAGGING)//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
AS_SIGNAL(SCROLLVIEWWILLBEGINDECELERATING)//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
AS_SIGNAL(SCROLLVIEWDIDENDDECELERATING)//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
AS_SIGNAL(SCROLLVIEWDIDENDSCROLLINGANIMATION)//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
AS_SIGNAL(VIEWFORZOOMINGINSCROLLVIEW)//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
AS_SIGNAL(SCROLLVIEWWILLBEGINZOOMING)//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2);
AS_SIGNAL(SCROLLVIEWDIDENDZOOMING)//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;
AS_SIGNAL(SCROLLVIEWSHOULDSCROLLTOTOP)//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
AS_SIGNAL(SCROLLVIEWDIDSCROLLTOTOP)//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;
@end
