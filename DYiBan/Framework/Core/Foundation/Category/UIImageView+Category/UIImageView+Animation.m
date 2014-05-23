//
//  UIImageView+Animation.m
//  MagicFramework
//
//  Created by zhangchao on 13-4-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIImageView+Animation.h"

@implementation UIImageView (Animation)

#pragma mark-创建一个动画UIImageView播放几帧图片动画
-(void)creatAnAnimationImageViewByAnimationImages:(NSMutableArray *)animationImages/*动画数据源*/ animationRepeatCount:(int)animationRepeatCount/*播放次数(-1是无限循环)*/ animationDuration:(float)animationDuration/*播放一次的总时间*/
{
    self.animationImages=animationImages;
    self.animationRepeatCount=animationRepeatCount;//播放次数
    self.animationDuration=animationDuration;//动画播放完一次的总时间
    [self startAnimating];
}

@end
