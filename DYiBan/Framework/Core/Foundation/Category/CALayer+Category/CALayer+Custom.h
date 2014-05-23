//
//  CALayer+Custom.h
//  MagicFramework
//
//  Created by zhangchao on 13-4-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Custom)

-(void)AddShadowByShadowColor:(UIColor *)color shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity/*不透明度,越接近1,颜色越深*/ shadowRadius:(CGFloat)shadowRadius;
-(void)AddborderByIsMasksToBounds:(BOOL)isMasksToBounds/*是否圆角*/ cornerRadius:(CGFloat)cornerRadius/*圆角弧度*/ borderWidth:(CGFloat)borderWidth/*半框宽*/ borderColor:(CGColorRef)borderColor/*[[UIColor blackColor]CGColor]*/;
-(void)layerAnimationDuration:(CFTimeInterval)duration/*动画时间*/ curve:(NSString *)timingFunction/*动画计时函数(已不同速度呈现),速度默认是kCAMediaTimingFunctionEaseInEaseOut:开头和结尾慢*/ :(NSString *)type/*动画类型(定义转场的整体行为):默认kCATransitionFade*/ :(NSString *)subType/*动画子类型(定义方向等):kCATransitionFromTop等*/ selector:(SEL)selector userInfo:(id)userInfo target:(id)delegate;
-(void)randlayerAnimationDuration:(CFTimeInterval)duration/*动画时间*/;
-(void)transFormLayerByAnyAngleFromValue:(CATransform3D)fromValue/*CATransform3DIdentity*/ toValue:(CATransform3D)rotation/*CATransform3DMakeScale(1.1,1.1, 1.1)图层伸展;CATransform3DMakeRotation(3.1415, 0, 0, 1)图层旋转(绕Z轴顺时针转360度)*/ duration:(float)duration repeatCount:(int)repeatCount isScale:(bool)isScale/*是否是缩放,否则是旋转*/;

@end
