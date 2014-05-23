//
//  UIView+Gesture.m
//  MagicFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIView+Gesture.h"

@implementation UIView (Gesture)

#pragma mark-创建一个单击事件
-(UIGestureRecognizer *)CreatTapGeture:(id)target/*响应方法所定义在的对象*/ selector:(SEL)selector /*addInView:(UIView *)addInView给那个视图对象添加此事件*/ numberOfTouchesRequired:(int)numberOfTouchesRequired/*每次点击需要检测几根手指同时按下*/ numberOfTapsRequired:(int)numberOfTapsRequired/*需要检测几次点击*/
{//单击事件
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGeture=[[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    tapGeture.numberOfTouchesRequired=numberOfTouchesRequired;//
    tapGeture.numberOfTapsRequired=numberOfTapsRequired;//
    [self addGestureRecognizer:tapGeture];
    [tapGeture release];
    
    return tapGeture;
}

#pragma mark-创建一个捏合手势检测
-(UIGestureRecognizer *)CreatPinchGeture:(id<UIGestureRecognizerDelegate>)target/*相应方法所定义在的对象*/ selector:(SEL)selector /*addInView:(UIView *)addInView给那个视图对象添加此事件*/
{
    self.userInteractionEnabled=YES;

    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:target action:selector];
    [pinchGesture setDelegate:target];
    [self addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    return pinchGesture;
}

#pragma mark-添加一个长按手势
-(UIGestureRecognizer *)CreatLongPressGestureRecognizer:(id)target action:(SEL)action minimumPressDuration:(CFTimeInterval)minimumPressDuration /*inView:(UIView *)inView*/
{
    self.userInteractionEnabled=YES;

    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:target action:action];
    longPress.minimumPressDuration=minimumPressDuration;
    [self addGestureRecognizer:longPress];
    [longPress release];
    return longPress;
}

#pragma mark-添加一个拖动手势
-(UIGestureRecognizer *)CreatPanGestureRecognizer:(id)target action:(SEL)action
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:/*@selector(handelPan:)*/ action];
    panRecognizer.delegate = target;
    [self addGestureRecognizer:panRecognizer];
    [panRecognizer release];
    return panRecognizer;
}

@end
