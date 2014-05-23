//
//  UIImageView+Animation.h
//  MagicFramework
//
//  Created by zhangchao on 13-4-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

    //动画方面
@interface UIImageView (Animation)

-(void)creatAnAnimationImageViewByAnimationImages:(NSMutableArray *)animationImages/*动画数据源*/ animationRepeatCount:(int)animationRepeatCount/*播放次数(-1是无限循环)*/ animationDuration:(float)animationDuration/*播放一次的总时间*/;

@end
