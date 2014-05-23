//
//  DYBScrollerView.m
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBScrollerView.h"
#import "DYBScrollerView.h"
#import "DYBBoxView.h"

#define USERBOX_WIDTH 320
#define USERBOX_HEIGHT 50
@implementation DYBScrollerView
DEF_SIGNAL(PICKERDIDEND);
DEF_SIGNAL(PICKERBEGIN);
DEF_SIGNAL(PICKERTOUCH);

- (void)dealloc {
    RELEASEOBJ(views);
    RELEASE(currentTouch);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self load];
		currentSize = frame.size;
		
		super.delegate = self;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
        [self setBounces:NO];
		
    }
    return self;
}

- (void) load {
	
	views = [[NSMutableArray alloc] init];
	
	currentIndex = -1;
	coverSize = CGSizeMake(224, 200);
	spaceFromCurrent = coverSize.height/2.4;
	[self setup];
}

- (void) setup {
	
	for(UIView *v in views) [v removeFromSuperview];
	[views removeAllObjects];
	
	currentSize = self.frame.size;
	currentIndex = -1;
	self.contentOffset = CGPointZero;
	
}


- (void) animateToIndex:(int)index animated:(BOOL)animated {
	
	NSString *string = @"";
	if(velocity> 200) animated = NO;
	
	if(animated){
		float speed = 0.21;
		if(velocity>80)speed=0.05;
		[UIView beginAnimations:string context:nil];
		[UIView setAnimationDuration:speed];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationBeginsFromCurrentState:YES];
	}
    
    int currentViewIndex = 0;
	for(UIView *v in views){
		v.alpha = 1;
		if (currentViewIndex == index) {
			[v setBackgroundColor:[UIColor clearColor]];
			v.layer.transform = CATransform3DMakeTranslation(0, 0, -300);
		}else {
			[v setBackgroundColor:[UIColor clearColor]];
			if (currentViewIndex == index-1 || currentViewIndex == index + 1) {
				v.alpha = 0.9;
				v.layer.transform = CATransform3DConcat(CATransform3DMakeScale(0.8, 0.8, 1),CATransform3DMakeTranslation(0, 0, -300));
			}else if (currentViewIndex == index-2 || currentViewIndex == index + 2) {
				v.alpha = 0.7;
				v.layer.transform = CATransform3DConcat(CATransform3DMakeScale(0.7, 0.7, 1),CATransform3DMakeTranslation(0, (currentViewIndex > index? -8:8), -300));
			}else if (currentViewIndex == index-3 || currentViewIndex == index + 3) {
				v.alpha = 0.5;
				v.layer.transform = CATransform3DConcat(CATransform3DMakeScale(0.6, 0.6, 1),CATransform3DMakeTranslation(0, (currentViewIndex > index? -22:22), -300));
			}else{
				v.alpha = 0;
				v.layer.transform = CATransform3DConcat(CATransform3DMakeScale(0.6, 0.6, 1),CATransform3DMakeTranslation(0, (currentViewIndex > index? -8:8), -300));
			}
		}
        currentViewIndex++;
	}
	if(animated) [UIView commitAnimations];
    
	
}

#pragma mark UIScrollView Delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
	float yOffset = scrollView.contentOffset.y;
    
	velocity = abs(pos - yOffset);
	pos = yOffset;
	
	CGFloat num = totalViews;
	CGFloat per = (scrollView.contentOffset.y) / (self.contentSize.height - currentSize.height);
	CGFloat ind = num * per;
	CGFloat mi = ind / (totalViews/2);
	
	mi = 1 - mi;
	mi = mi / 2;
	int index = (int)(ind+mi);
    
	index = MIN(MAX(0,index),totalViews-1);
	
	if(index == currentIndex) return;
    
	currentIndex = index;
	
	if(velocity < 180)
		[self animateToIndex:index animated:YES];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self sendViewSignal:[DYBScrollerView PICKERBEGIN] withObject:nil from:self target:[self superview]];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
	if(!scrollView.tracking && !scrollView.decelerating){
		[self snapToAlbum:YES];
	}
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if(!scrollView.decelerating && !decelerate){
		[self snapToAlbum:YES];
	}
}

- (void) snapToAlbum:(BOOL)animated{
	
	if (currentIndex < totalViews) {
		UIView *v = [views objectAtIndex:currentIndex];
        currentTouch = v;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:(DYBBoxView*)currentTouch, @"boxview", nil];
        [self sendViewSignal:[DYBScrollerView PICKERDIDEND] withObject:dict from:self target:[self superview]];
        RELEASEDICTARRAYOBJ(dict);
        
		if((NSObject*)v!=[NSNull null]) {
			[self setContentOffset:CGPointMake(0, (v.center.y  - (currentSize.height/2.2))) animated:animated];
		}
	}
    
    
	
}

#pragma mark Touch Events
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	if(touch.view != self &&  [touch locationInView:touch.view].y < coverSize.height){
		currentTouch = touch.view;
	}
	
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if(touch.view == currentTouch){
		if(touch.tapCount == 1 && currentIndex == [views indexOfObject:currentTouch]){
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:(DYBBoxView*)currentTouch, @"boxview", nil];
            [self sendViewSignal:[DYBScrollerView PICKERTOUCH] withObject:dict from:self target:[self superview]];
            
		}
	}
	
	currentTouch = nil;
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	if(currentTouch!= nil) currentTouch = nil;
}

////////////////////////////////////////////////////////////////
// public method
////////////////////////////////////////////////////////////////

- (void) bringViewAtIndexToFront:(int)index animated:(BOOL)animated{
    if(index == currentIndex) return;
    
	if (index < totalViews) {
        
		currentIndex = index;
		
		[self snapToAlbum:animated];
		[self animateToIndex:index animated:animated];
	}else {
		return;
	}
	
}

- (void) addUserView:(DYBBoxView *)userBoxView {
	float ypos = 0;
	
	ypos = currentSize.height /2.4;
	
	if (totalViews > 0) {
		ypos  += totalViews * 50 ;
	}
    
    
    [userBoxView setFrame:CGRectMake(0, ypos, 320, USERBOX_HEIGHT)];
    [userBoxView arrangeViews];
    
	[views addObject:userBoxView];
	
	[self addSubview:userBoxView];
	ypos  = ypos + 50 + (currentSize.height/2.2);
    
	totalViews = [views count];
	self.contentSize = CGSizeMake(currentSize.width, ypos);
    
}


-(void)jumpToLast:(BOOL)animated {
    int lastIndex = totalViews - 1 ;
    [self bringViewAtIndexToFront:lastIndex animated:animated];
}

@end
