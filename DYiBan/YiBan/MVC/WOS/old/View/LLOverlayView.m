//
//  LLOverlayView.m
//  Yiban
//
//  Created by tom zeng on 13-2-16.
//
//

#import "LLOverlayView.h"

@implementation LLOverlayView
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	bTaped = YES;// 点击
	UITouch *touch = [touches anyObject];
	if(touch.view == self)
	{
		_pointStart = [touch locationInView:[[UIApplication sharedApplication] keyWindow]];
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	bTaped = NO;
	UITouch *touch = [touches anyObject];
	CGPoint ptPre_ = [touch previousLocationInView:[[UIApplication sharedApplication] keyWindow]];//得到手指触发前的，坐标
	CGPoint pt_ = [touch locationInView:[[UIApplication sharedApplication] keyWindow]];	
	if(_delegate  && [_delegate respondsToSelector:@selector(overLayViewCenterChanged:)])
	{        
		[_delegate overLayViewCenterChanged:CGPointMake(pt_.x -  ptPre_.x, pt_.y - ptPre_.y)];
	}
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	CGPoint pt_ = [touch locationInView:[[UIApplication sharedApplication] keyWindow]];
	if(_delegate  && [_delegate respondsToSelector:@selector(overLayViewTouchEnd:)])
	{
		[_delegate overLayViewTouchEnd:CGPointMake(pt_.x -  _pointStart.x, pt_.y - _pointStart.y)];
        
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint pt_ = [touch locationInView:[[UIApplication sharedApplication] keyWindow]];
//    YBLogInfo(@" touchesEnded  point = %@", NSStringFromCGPoint(pt_));
    //	bTaped = NO;
	if(!bTaped) //是否是点击还是拖动
	{
		if(_delegate  && [_delegate respondsToSelector:@selector(overLayViewTouchEnd:)])
		{
			[_delegate overLayViewTouchEnd:CGPointMake(pt_.x -  _pointStart.x, pt_.y - _pointStart.y)];
		}
	}
	else {
		if(_delegate  && [_delegate respondsToSelector:@selector(overLayViewTap:)])
		{
			[_delegate overLayViewTap:self];
		}
	}
}


- (void)dealloc
{
	[super dealloc];
}

@end
