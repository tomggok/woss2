//
//  UIImageView+Init.m
//  DragonFramework
//
//  Created by zhangchao on 13-4-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <objc/runtime.h>
#import "UIImageView+Init.h"
#import "UIView+DragonCategory.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Init)

@dynamic _originFrame,_Alignment;

- (id)initWithFrame:(CGRect)frame
    backgroundColor:(UIColor *)backgroundColor
              image:(UIImage *)image
isAdjustSizeByImgSize:(BOOL)isAdjustSizeByImgSize/*是否根据img的size改变自己的size*/
userInteractionEnabled:(BOOL)userInteractionEnabled
      masksToBounds:(BOOL)masksToBounds//是否圆角
       cornerRadius:(CGFloat)cornerRadius//圆角弧度
        borderWidth:(CGFloat)borderWidth//无边框填-1
        borderColor:(CGColorRef)borderColor//无边框颜色填-1
          superView:(UIView *)_superView/*传父视图,就在父视图里居中*/
          Alignment:(NSUInteger)Alignment/*在父视图的对齐格式(0:左右居中 1:上下居中 2:在父视图中心),不按此对齐方式可填-1*/
        contentMode:(UIViewContentMode)contentMode
stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth/*创建一个内容可拉伸，而边角不拉伸的图片的左边不拉伸区域的宽度,不拉伸可填-1*/
       topCapHeight:(NSInteger)topCapHeight/*上面不拉伸的高度*/
{
    self = [super initWithFrame:frame];
    if (self) {
        self._originFrame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        self.backgroundColor=backgroundColor;
        if(leftCapWidth>0&&topCapHeight>0){/*创建一个内容可拉伸，而边角不拉伸的图片http://www.cnblogs.com/bandy/archive/2012/04/25/2469369.html*/
            image=[image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        }

        self.image=image;
        if (isAdjustSizeByImgSize) {
            [self setBounds:CGRectMake(0, 0, image.size.width, image.size.height)];
        }
        self.userInteractionEnabled=userInteractionEnabled;
        self.contentMode=contentMode;

        if (_superView) {
            [_superView addSubview:self];
            self._Alignment=Alignment;
            switch (Alignment) {
                case 0://左右居中
                {
                [self setFrame:CGRectMake(_superView.frame.size.width/2-self.frame.size.width/2, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
                }
                    break;
                case 1://上下居中
                {
                [self setFrame:CGRectMake(self.frame.origin.x, _superView.frame.size.height/2-self.frame.size.height/2, self.frame.size.width, self.frame.size.height)];
                }
                    break;
                case 2://中心
                {
                [self setFrame:CGRectMake(_superView.frame.size.width/2-self.frame.size.width/2, _superView.frame.size.height/2-self.frame.size.height/2, self.frame.size.width, self.frame.size.height)];
                }
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}

static char _c_originFrame;
-(void)set_originFrame:(CGRect)_originFrame
{
    objc_setAssociatedObject(self, &_c_originFrame, [NSValue valueWithCGRect:_originFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGRect)_originFrame
{
    return [objc_getAssociatedObject(self, &_c_originFrame) CGRectValue];
}

static char _c_Alignment;
-(void)set_Alignment:(int)Alignment
{
    objc_setAssociatedObject(self, &_c_Alignment, [NSNumber numberWithFloat:Alignment], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(int)_Alignment
{
    return [objc_getAssociatedObject(self, &_c_Alignment) floatValue];
}

#pragma mark- 不定参数的扩展方法

-(UIImageView_OriginFrame)va_OriginFrame{
    UIImageView_OriginFrame block=^UIImageView *(id first,...){
        va_list args;
        va_start(args, first);
        CGRect rect=((NSValue *)first).CGRectValue;

        self._originFrame=rect;
        return self;
    };
    return [[block copy]autorelease];
}

/*创建一个内容可拉伸，而边角不拉伸的图片http://www.cnblogs.com/bandy/archive/2012/04/25/2469369.html*/
-(UIImageView_Strentch)va_stretchableImageWithLeftCapWidth{
    UIImageView_Strentch block=^UIImageView *(id first,...){
        va_list args;
        va_start(args, first);
        
        NSInteger leftCapWidth=(NSInteger)first;
        NSInteger topCapHeight=va_arg(args, NSInteger);
        if (leftCapWidth>0&&topCapHeight>0) {
            self.image=[self.image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        }

        return self;
    };
    return [[block copy]autorelease];
}

-(UIImageView_AdjustSizeByImgSize)va_isAdjustSizeByImgSize{
    UIImageView_AdjustSizeByImgSize block=^UIImageView *(id first,...){
        va_list args;
        va_start(args, first);

        if ([(NSNumber*)first boolValue]==YES) {
            [self setBounds:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
        }

        return self;
    };
    return [[block copy]autorelease];
}

//圆角相关参数
-(UIImageView_corner)va_corner{
    UIImageView_corner block=^UIImageView *(id first,...){
        va_list args;
        va_start(args, first);
        self.layer.masksToBounds=(BOOL)first;
        self.layer.cornerRadius=[(NSNumber *)va_arg(args, NSNumber *) floatValue];

        return self;
    };
    return [[block copy]autorelease];
}

//边框相关参数
-(UIImageView_corner)va_border{
     UIImageView_corner block=^UIImageView *(id first,...){
        va_list args;
        va_start(args, first);
        self.layer.borderWidth=[(NSNumber *)first floatValue];
        self.layer.borderColor=(CGColorRef)va_arg(args, CGColorRef);
        
        return self;
    };
    return [[block copy]autorelease];
}

//在父视图的对齐方式相关参数在父视图的对齐格式(0:左右居中 1:上下居中 2:在父视图中心),不按此对齐方式可填-1
-(UIImageView_superViewAligment)va_superViewAligment{
    
    UIImageView_superViewAligment block=^UIImageView *(id first,...){
        va_list args;
        va_start(args, first);
        UIView *superV=(UIView *)first;
        if (superV) {
//            [superV addSubview: self];
            NSUInteger Aligment=(NSUInteger)va_arg(args, NSUInteger);
            switch (Aligment) {
                case 0://左右居中
                {
                    [self setFrame:CGRectMake(superV.frame.size.width/2-self.frame.size.width/2, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
                }
                    break;
                case 1://上下居中
                {                    
                    [self setFrame:CGRectMake(self.frame.origin.x, superV.frame.size.height/2-self.frame.size.height/2, self.frame.size.width, self.frame.size.height)];
                }
                    break;
                case 2://中心
                {
                    DLogInfo(@"%f;%f;%f;%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
                    [self setFrame:CGRectMake(superV.frame.size.width/2-self.frame.size.width/2, superV.frame.size.height/2-self.frame.size.height/2, self.frame.size.width, self.frame.size.height)];
                    DLogInfo(@"%f;%f;%f;%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
                }
                    break;
                default:
                    break;
            }
        }
        
        return self;
    };
    return [[block copy]autorelease];
}

//接受图片通过网络请求成功消息
- (void)handleViewSignal_UIImageView:(DragonViewSignal *)signal
{
    if ([signal is:[UIImageView SDWEBIMGDOWNSUCCESS]]) {
        [self changePosInSuperViewWithAlignment:self._Alignment];
    }
}

#pragma mark- 自身的img大小大于最大宽高后,self.frame要和最大frame一样,此时self.img就被缩小了,返回的size是self.frame缩小后self.img的size相对于self.frame.size的宽高距离
-(CGSize)sizeToFitByImg
{
    //宽高比
    CGFloat rateW=self.image.size.width/(self.image.size.width+self.image.size.height);
    CGFloat rateH=self.image.size.height/(self.image.size.width+self.image.size.height);
    
    //与最大w.h对比后的w,h
    CGFloat w = ((self.image.size.width  >CGRectGetWidth(self.frame))?(CGRectGetWidth(self.frame)):(self.image.size.width ));
    CGFloat h = ((self.image.size.height  > CGRectGetHeight(self.frame)/*最大高度*/)?(CGRectGetHeight(self.frame)):(self.image.size.height ));
    
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), w,h)];
    
    if (w!=self.image.size.width / 2 || h!=self.image.size.height / 2) {
        //    rateH=h/(w+h);高占宽高的比例
        //    rateH*(w+h)=h;
        //    rateH*w+rateH*h=h;
        //    rateH*h=h-rateH*w;
        CGFloat h_final=(h-rateH*w)/rateH;
        
        //    rateW=w/(w+h);宽占宽高的比例
        //    rateW*(w+h)=w;
        //    rateW*w+rateW*h=w;
        //    rateW*w=w-rateW*h;
        CGFloat w_final=(w-rateW*h)/rateW;
        
//        [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), (w-w_final)/2,(h-h_final)/2)];
        return CGSizeMake(/*(w-w_final)/2*/ 0,(h-h_final)/2);
    }else{
//        [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), w,h)];
    }
}

@end
