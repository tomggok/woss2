//
//  UIView+Animations.m
//  DragonFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIView+Animations.h"
#import "NSObject+MathCount.h"
#import "NSTimer+Create.h"

@implementation UIView (Animations)

#pragma mark-动画移动view.rect
-(void)moveViewToFrame:(CGRect)toRect Duration:(float)duration target:(id)target/*动画开始之前或之中或结束后触发的事件的接收对象*/ AnimationsID:(NSString *)AnimationsID AnimationDidStopSelector:(SEL/*@selector()的返回值类型,C里的函数指针,取类方法的编号(函数地址)*/)selector
{
    [UIView beginAnimations:AnimationsID/*动画标识*/ context:(/*__bridge*/ void *)self/*上下文环境*/];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:target];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDidStopSelector:selector];//动画结束时调某方法
    [UIView setAnimationRepeatCount:1];
    self.frame=toRect;
    [UIView commitAnimations];//此句结束后才开始执行动画
}

//#pragma mark-用UIView渐变视图
//-(void)GradientByUIViewDuration:(float)duration target:(id)target/*动画开始之前或之中或结束后触发的事件的接收对象*/ AnimationsID:(NSString *)AnimationsID AnimationDidStopSelector:(SEL/*@selector()的返回值类型,C里的函数指针,取类方法的编号(函数地址)*/)selector alpha:(float)alpha/*要渐变到的alpha值(0-1之间)*/
//{
//    [UIView beginAnimations:AnimationsID/*动画标识*/ context:(/*__bridge*/ void *)self/*上下文环境*/];
//    [UIView setAnimationDuration:duration];
//    [UIView setAnimationDelegate:target];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDidStopSelector:selector];//动画结束时调某方法
//    [UIView setAnimationRepeatCount:1];
//    self.alpha=alpha;
//    [UIView commitAnimations];//此句结束后才开始执行动画
//}

#pragma mark-用UIView的动画缩放或旋转视图
-(void)scalOrRotationViewCenter:(CGPoint)center/*缩放中心位置*/ transform:(CGAffineTransform)transform/*CGAffineTransformMakeScale|CGAffineTransformMakeRotation*/ duration:(NSTimeInterval)duration Delay:(NSTimeInterval)Delay delegate:(id)delegate animationID:(NSString *)animationID AnimationDidStopSelector:(SEL/*@selector()的返回值类型,C里的函数指针,取类方法的编号(函数地址)*/)selector AnimationsEnabled:(bool)AnimationsEnabled/*是否使用动画*/
{
    self.center=center;//确保缩放后view的坐标不变
    self.transform=CGAffineTransformIdentity;//确保缩放前view没有被正在进行任何变换

    [UIView beginAnimations:animationID context:(void *)self/*上下文环境*/];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelay:Delay];
    [UIView setAnimationDelegate:delegate];
    [UIView setAnimationDidStopSelector:selector];
    [UIView setAnimationsEnabled:AnimationsEnabled];

    self.transform=transform;

    [UIView commitAnimations];
}

#pragma mark-水纹波浪等效果,效果完成后还可以执行某个函数
-(void)TheWaterLinesWaveEffect:(id)delegate duration:(float)duration /*view:(UIView *)view*/ selector:(SEL)selector userInfo:(id)userInfo type:(NSString *)type/*cube:立方体旋转;rippleEffect:水纹效果;suckEffect:从左上角抽出;pageCurl:上翻页;pageUnCurl:下翻页;cameraIrisHollowOpen:开相机效果?;cameraIrisHollowClose:关相机效果;kCATransitionMoveIn;*/ AnimationKey:(NSString *)AnimationKey/*animation*/ subtype:(NSString *)subtype/*kCATransitionFromLeft,kCATransitionFromBottom控制方向*/ exchangeSubviewAtIndex:(int)exchangeSubviewAtIndex withSubviewAtIndex:(int)withSubviewAtIndex//交换2个下标的视图
{
    CATransition *animation=[CATransition animation];
    animation.delegate=delegate;
    animation.duration=duration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress = 1;
    animation.removedOnCompletion = NO;
    if(!type){//没传具体效果,就随即一个
        NSArray *array=[NSArray arrayWithObjects:@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose", nil];
        animation.type = [array objectAtIndex:[NSObject creatAnRandomNumberFrom:0 to:[array count]-1]];
    }else {
        animation.type = type;
            //    if([type isEqualToString:@"cube"]){//设置立方体的旋转方向
            //    }
    }
    animation.subtype=subtype;

    [self.layer addAnimation:animation forKey:AnimationKey];
    if (exchangeSubviewAtIndex>=0&&withSubviewAtIndex>=0) {
        [self exchangeSubviewAtIndex:exchangeSubviewAtIndex withSubviewAtIndex:withSubviewAtIndex];//Just remove, not release or dealloc颠倒0和1号下标的子视图
    }

        //        for (id ob in view.subviews) {
        //            LogInt(__FUNCTION__, @"", ((UIImageView *)ob).tag, nil);
        //            LogClassType(__FUNCTION__, @"ob", [ob class]);
        //        }
    if(selector){
        [NSTimer CreatAnTimeToCallAnFunctionBySelector:selector AfterTimeInterval:duration target:delegate userInfo:userInfo repeats:NO isWantToHave:NO];

    }
}

@end
