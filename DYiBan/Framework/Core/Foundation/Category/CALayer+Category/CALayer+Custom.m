//
//  CALayer+Custom.m
//  MagicFramework
//
//  Created by zhangchao on 13-4-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "CALayer+Custom.h"
#import "NSTimer+Create.h"
#import "NSObject+MathCount.h"

@implementation CALayer (Custom)

#pragma mark-给视图的图层添加阴影
-(void)AddShadowByShadowColor:(UIColor *)color shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity/*不透明度,越接近1,颜色越深*/ shadowRadius:(CGFloat)shadowRadius
{
    self.shadowColor=color.CGColor;
    self.shadowOffset=shadowOffset;
    self.shadowOpacity=shadowOpacity;//不透明度,越接近1,颜色越深
    self.shadowRadius=shadowRadius;
}

#pragma mark-给视图的图层添加(圆角)边框
-(void)AddborderByIsMasksToBounds:(BOOL)isMasksToBounds/*是否圆角*/ cornerRadius:(CGFloat)cornerRadius/*圆角弧度*/ borderWidth:(CGFloat)borderWidth/*半框宽*/ borderColor:(CGColorRef)borderColor/*[[UIColor blackColor]CGColor]*/
{
    self.masksToBounds = isMasksToBounds;
    self.cornerRadius = cornerRadius;
    self.borderWidth  =borderWidth;
    self.borderColor= borderColor;
    
}

#pragma mark-图层(渐变效果有时不适合此方法,可用下边的UIView渐变)转场动画
-(void)layerAnimationDuration:(CFTimeInterval)duration/*动画时间*/ curve:(NSString *)timingFunction/*动画计时函数(已不同速度呈现),速度默认是kCAMediaTimingFunctionEaseInEaseOut:开头和结尾慢*/ :(NSString *)type/*动画类型(定义转场的整体行为):默认kCATransitionFade*/ :(NSString *)subType/*动画子类型(定义方向等):kCATransitionFromTop等*/ selector:(SEL)selector userInfo:(id)userInfo target:(id)delegate
{
    CATransition *myTransition=[CATransition animation];
    myTransition.duration=duration;
    myTransition.timingFunction=[CAMediaTimingFunction functionWithName:timingFunction];
    myTransition.type=type;
    myTransition.subtype=subType;
    myTransition.fillMode = kCAFillModeForwards;

    [self addAnimation:myTransition forKey:@"animation"];

    if(selector){
        [NSTimer CreatAnTimeToCallAnFunctionBySelector:selector AfterTimeInterval:duration target:delegate userInfo:userInfo repeats:NO isWantToHave:NO];
    }
    
}

#pragma mark-随即(渐变)转场动画
-(void)randlayerAnimationDuration:(CFTimeInterval)duration/*动画时间*/
{
    NSArray *_ar_CommonTransitionTypes=[[NSArray alloc]initWithObjects:kCATransitionFade,kCATransitionMoveIn,kCATransitionPush,kCATransitionReveal, nil];
    NSArray *_ar_CommonTransitionSubtypes=[[NSArray alloc]initWithObjects:kCATransitionFromRight,kCATransitionFromLeft,kCATransitionFromTop,kCATransitionFromBottom, nil];
    NSArray *_ar_TimingFunctionNames=[[NSArray alloc]initWithObjects:kCAMediaTimingFunctionEaseInEaseOut,kCAMediaTimingFunctionLinear,kCAMediaTimingFunctionEaseIn,kCAMediaTimingFunctionEaseOut, nil];

    [self layerAnimationDuration:duration curve:[_ar_TimingFunctionNames objectAtIndex:[NSObject creatAnRandomNumberFrom:0 to:[_ar_TimingFunctionNames count]-1]] :[_ar_CommonTransitionTypes objectAtIndex:[NSObject creatAnRandomNumberFrom:0 to:[_ar_CommonTransitionTypes count]-1]] :[_ar_CommonTransitionSubtypes objectAtIndex:[NSObject creatAnRandomNumberFrom:0 to:[_ar_CommonTransitionSubtypes count]-1]] selector:nil userInfo:nil target:nil];

    [_ar_CommonTransitionTypes release];
    [_ar_CommonTransitionSubtypes release];
    [_ar_TimingFunctionNames release];
}

#pragma mark-图层旋转或缩放任何角度
-(void)transFormLayerByAnyAngleFromValue:(CATransform3D)fromValue/*CATransform3DIdentity*/ toValue:(CATransform3D)rotation/*CATransform3DMakeScale(1.1,1.1, 1.1)图层伸展;CATransform3DMakeRotation(3.1415, 0, 0, 1)图层旋转(绕Z轴顺时针转360度)*/ duration:(float)duration repeatCount:(int)repeatCount isScale:(bool)isScale/*是否是缩放,否则是旋转*/
{
    NSString *KeyPath=((isScale)?(@"transform"):(@"transform"));
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:KeyPath];
    animation.fromValue=[NSValue valueWithCATransform3D:fromValue];
    animation.toValue=[NSValue valueWithCATransform3D:/*CATransform3DMakeRotation(3.1415, 0, 0, 1)*/ rotation];
    animation.duration=duration;
    animation.cumulative=YES;//渐变?
    animation.repeatCount=repeatCount;
    animation.removedOnCompletion=YES;

    [self addAnimation:animation forKey:KeyPath];

        //    CABasicAnimation *opacityAnim=[CABasicAnimation animationWithKeyPath:@"alpha"];
        //    opacityAnim.fromValue=[NSNumber numberWithFloat:1];
        //    opacityAnim.toValue=[NSNumber numberWithFloat:0.1];
        //    opacityAnim.removedOnCompletion=YES;
        //    [layer addAnimation:opacityAnim forKey:@"alpha"];

        //    CFSocketContext localCTX;
        //    CFSocketGetContext(nil, &localCTX);
    
}


@end
