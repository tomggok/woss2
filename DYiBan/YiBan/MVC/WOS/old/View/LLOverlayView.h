//
//  LLOverlayView.h
//  Yiban
//
//  Created by tom zeng on 13-2-16.
//
//


//@class LLOverlayViewDelegate;
#import <UIKit/UIKit.h>
#import "LLOverlayViewDelegate.h"
@interface LLOverlayView : UIView{
    id<LLOverlayViewDelegate>delegate;
    BOOL bTaped; //是否是点击儿不是拖动
	CGPoint _pointStart;

}
@property(retain,nonatomic)id<LLOverlayViewDelegate>delegate;
@end



