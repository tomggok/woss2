//
//  DYBScrollerView.h
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_UIScrollView.h"

@class DYBBoxView;

@interface DYBScrollerView : MagicUIScrollView {
    
	NSMutableArray *views;
    
	CGSize coverSize,currentSize;
	float spaceFromCurrent;
	
	int  currentIndex, totalViews;
	
	UIView *currentTouch;
	
	// SPEED
	int pos;
	long velocity;
}
AS_SIGNAL(PICKERBEGIN); //开始滑动
AS_SIGNAL(PICKERDIDEND);//结束滑动
AS_SIGNAL(PICKERTOUCH);//点击cell

- (void) bringViewAtIndexToFront:(int)index animated:(BOOL)animated;
- (void) addUserView:(DYBBoxView *)userBoxView;
- (void) snapToAlbum:(BOOL)animated;
- (void) jumpToLast:(BOOL)animated;
@end