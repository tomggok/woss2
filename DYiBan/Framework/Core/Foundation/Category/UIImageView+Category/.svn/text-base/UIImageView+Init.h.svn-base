//
//  UIImageView+Init.h
//  DragonFramework
//
//  Created by zhangchao on 13-4-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIImageView*(^UIImageView_OriginFrame)(id key,...);//初始化_OriginFrame的函数指针
typedef UIImageView*(^UIImageView_Strentch)(id key,...);
typedef UIImageView*(^UIImageView_AdjustSizeByImgSize)(id key,...);
typedef UIImageView*(^UIImageView_corner)(id key,...);
typedef UIImageView*(^UIImageView_superViewAligment)(id key,...);


@interface UIImageView (Init)

@property (nonatomic,assign)CGRect _originFrame;//原始frame
//@property (nonatomic,assign) CGFloat _scale;//当前的缩放比例
@property (nonatomic,assign) int _Alignment;/*在父视图的对齐格式(0:左右居中 1:上下居中 2:在父视图中心),不按此对齐方式可填-1*/


- (id)initWithFrame:(CGRect)frame
    backgroundColor:(UIColor *)backgroundColor
              image:(UIImage *)image
isAdjustSizeByImgSize:(BOOL)isAdjustSizeByImgSize
userInteractionEnabled:(BOOL)userInteractionEnabled
      masksToBounds:(BOOL)masksToBounds
       cornerRadius:(CGFloat)cornerRadius
        borderWidth:(CGFloat)borderWidth
        borderColor:(CGColorRef)borderColor
          superView:(UIView *)_superView/*传父视图,就在父视图里居中*/
          Alignment:(NSUInteger)Alignment/*在父视图的对齐格式(0:左右居中 1:上下居中 2:在父视图中心)*/
        contentMode:(UIViewContentMode)contentMode
/*创建一个内容可拉伸，而边角不拉伸的图片*/stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth/*左边不拉伸区域的宽度*/
       topCapHeight:(NSInteger)topCapHeight/*上面不拉伸的高度*/;

-(UIImageView_OriginFrame)va_OriginFrame;
-(UIImageView_Strentch)va_stretchableImageWithLeftCapWidth;
-(UIImageView_AdjustSizeByImgSize)va_isAdjustSizeByImgSize;
-(UIImageView_superViewAligment)va_superViewAligment;
-(UIImageView_corner)va_corner;
-(CGSize)sizeToFitByImg;
@end
