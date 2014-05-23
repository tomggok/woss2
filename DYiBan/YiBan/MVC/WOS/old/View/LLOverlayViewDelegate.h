//
//  LLOverlayViewDelegate.h
//  Yiban
//
//  Created by tom zeng on 13-2-16.
//
//

#import <Foundation/Foundation.h>
@class LLOverlayView;
@protocol LLOverlayViewDelegate <NSObject>
- (void)overLayViewCenterChanged:(CGPoint)offset_; //滑动的时候
- (void)overLayViewTouchEnd:(CGPoint)offset_;//滑动结束
- (void)overLayViewTap:(LLOverlayView*)overlayView_;//滑动开始
@end

