//
//  Magic_ZoomView.h
//  MagicFramework
//
//  Created by NewM on 13-7-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Magic_ViewSignal.h"

@class MagicUIZoomView;
@class MagicUIZoomInnerView;

@protocol MagicUIZoomInnerViewDelegate <NSObject>

- (CGSize)zoomContentSize:(MagicUIZoomInnerView *)view;
- (UIView *)zoomContentView:(MagicUIZoomInnerView *)view;

- (void)zoomInnerViewChanged:(MagicUIZoomInnerView *)view;
- (void)zoomInnerViewSingleTapped:(MagicUIZoomInnerView *)view location:(CGPoint)location;
- (void)zoomInnerViewDoubleTapped:(MagicUIZoomInnerView *)view location:(CGPoint)location;

@end

@interface MagicUIZoomInnerView : UIScrollView
{
    id<MagicUIZoomInnerViewDelegate> _zoomDelegate;
}
@property (nonatomic, assign) id<MagicUIZoomInnerViewDelegate> zoomDelegate;

@end

@interface MagicUIZoomView : UIView<UIScrollViewDelegate, MagicUIZoomInnerViewDelegate>
{
    MagicUIZoomInnerView *_innerView;
    CGSize  _contentSize;
    UIView *_content;
}

AS_SIGNAL(ZOOMING)
AS_SIGNAL(ZOOMED)
AS_SIGNAL(SINGLE_TAPPED)
AS_SIGNAL(DOUBLE_TAPPED)

@property (nonatomic, retain)MagicUIZoomInnerView *innerView;
@property (nonatomic, assign)CGSize                 contentSize;
@property (nonatomic, retain)UIView                *content;

- (void)resetZoom;
- (void)layoutContent;
- (void)layoutContentRotated;
- (void)setContent:(UIView *)content animated:(BOOL)animated;
CGSize AspectFitSize(CGSize size, CGSize bound);

@end
