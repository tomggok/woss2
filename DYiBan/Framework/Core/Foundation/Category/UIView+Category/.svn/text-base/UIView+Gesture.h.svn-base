//
//  UIView+Gesture.h
//  DragonFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

    //手势相关
@interface UIView (Gesture)

-(UIGestureRecognizer *)CreatTapGeture:(id)target/*响应方法所定义在的对象*/ selector:(SEL)selector /*addInView:(UIView *)addInView给那个视图对象添加此事件*/ numberOfTouchesRequired:(int)numberOfTouchesRequired/*每次点击需要检测几根手指同时按下*/ numberOfTapsRequired:(int)numberOfTapsRequired/*需要检测几次点击*/;

-(UIGestureRecognizer *)CreatPinchGeture:(id<UIGestureRecognizerDelegate>)target/*相应方法所定义在的对象*/ selector:(SEL)selector /*addInView:(UIView *)addInView给那个视图对象添加此事件*/;

-(UIGestureRecognizer *)CreatLongPressGestureRecognizer:(id)target action:(SEL)action minimumPressDuration:(CFTimeInterval)minimumPressDuration /*inView:(UIView *)inView*/;

-(UIGestureRecognizer *)CreatPanGestureRecognizer:(id)target action:(SEL)action;

@end
