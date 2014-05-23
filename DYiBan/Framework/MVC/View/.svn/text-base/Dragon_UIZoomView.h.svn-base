//
//  Dragon_ZoomView.h
//  DragonFramework
//
//  Created by NewM on 13-7-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dragon_ViewSignal.h"

@class DragonUIZoomView;
@class DragonUIZoomInnerView;

@protocol DragonUIZoomInnerViewDelegate <NSObject>

- (CGSize)zoomContentSize:(DragonUIZoomInnerView *)view;
- (UIView *)zoomContentView:(DragonUIZoomInnerView *)view;

- (void)zoomInnerViewChanged:(DragonUIZoomInnerView *)view;
- (void)zoomInnerViewSingleTapped:(DragonUIZoomInnerView *)view location:(CGPoint)location;
- (void)zoomInnerViewDoubleTapped:(DragonUIZoomInnerView *)view location:(CGPoint)location;

@end

@interface DragonUIZoomInnerView : UIScrollView
{
    id<DragonUIZoomInnerViewDelegate> _zoomDelegate;
}
@property (nonatomic, assign) id<DragonUIZoomInnerViewDelegate> zoomDelegate;

@end

@interface DragonUIZoomView : UIView<UIScrollViewDelegate, DragonUIZoomInnerViewDelegate>
{
    DragonUIZoomInnerView *_innerView;
    CGSize  _contentSize;
    UIView *_content;
}

AS_SIGNAL(ZOOMING)
AS_SIGNAL(ZOOMED)
AS_SIGNAL(SINGLE_TAPPED)
AS_SIGNAL(DOUBLE_TAPPED)

@property (nonatomic, retain)DragonUIZoomInnerView *innerView;
@property (nonatomic, assign)CGSize                 contentSize;
@property (nonatomic, retain)UIView                *content;

- (void)resetZoom;
- (void)layoutContent;
- (void)layoutContentRotated;
- (void)setContent:(UIView *)content animated:(BOOL)animated;

@end
