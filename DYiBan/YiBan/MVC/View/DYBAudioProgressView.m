//
//  DYBProgressView.m
//  DYiBan
//
//  Created by zhangchao on 13-11-14.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBAudioProgressView.h"

@implementation DYBAudioProgressView

DEF_SIGNAL(LoadDown)//完毕


@synthesize FillRect=_FillRect,A_color=_A_color,MaxTime=_MaxTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _FillRect=CGRectZero;
    }
    return self;
}

//自动计算每秒加宽多少
-(void)changeRect
{
    CGFloat addW=(CGFloat) CGRectGetWidth(self.frame)/_MaxTime;
    
    _FillRect=CGRectMake(0, 0, CGRectGetWidth(_FillRect)+addW, CGRectGetHeight(self.frame));
    [self setNeedsDisplay];
    
    if (CGRectGetWidth(_FillRect)>CGRectGetWidth(self.frame)) {//读取完毕
        [self sendViewSignal:[DYBAudioProgressView LoadDown] withObject:nil from:self target:nil];
    }

}

- (void)drawRect:(CGRect)rect
{
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();//获取画笔
    CGContextSetRGBFillColor(context,[[_A_color objectAtIndex:0] floatValue] ,[[_A_color objectAtIndex:1] floatValue], [[_A_color objectAtIndex:2] floatValue], [[_A_color objectAtIndex:3] floatValue]);//填充颜色
    CGContextFillRect(context, _FillRect);//填充矩形
    
//    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);//设置画笔颜色
//    CGContextSetLineWidth(context, 1.0);//设置画笔线条粗细
//    CGContextAddRect(context,rect);//画矩形边框

    CGContextStrokePath(context);//执行绘画

}


@end
