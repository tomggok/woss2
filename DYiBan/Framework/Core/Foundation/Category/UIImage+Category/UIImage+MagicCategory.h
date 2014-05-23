//
//  UIImage+MagicCategory.h
//  ShangJiaoYuXin
//
//  Created by NewM on 13-5-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MagicCategory)

//根据颜色返回图片
+(UIImage*)imageWithColor:(UIColor *)color;

//截取当前view为图片
+ (UIImage *)cutScreenImg:(UIView *)viewImg;

//按照坐标截取Img
- (UIImage *)cutImgWithRect:(CGRect)rect;

//虚化当前image
- (UIImage *)boxblurImageWithBlur:(CGFloat)blur;

+(UIImage *)imageNamed:(NSString *)name fileType:(NSString *)fileType/*文件后缀*/ isBigOrUnSameByOtherImg/*此图片是否是大图片或者 和数据源里的其他图片不一样 http://www.cnblogs.com/pengyingh/articles/2355033.html*/ :(BOOL)isBigOrUnSameByOtherImg;

-(NSData *)saveToNSDataByCompressionQuality:(CGFloat)compressionQuality/*传-1表示返回png;压缩系数,一般为1.0,如果对图片的清晰度要求不高,可减小压缩系数,从而大福降低图片数据量,此函数本身就比UIImagePNGRepresentation函数得到的图片数据量低*/;
+(UIImage *)imgShotWithView:(UIView *)view ClippingImageByRect:(CGRect)rect/*要裁剪的区间*/;
-(UIImage *)ClippingImageByRect:(CGRect)Rect/*裁剪区*/;
-(NSData *)CompressPicturesMoreThanKB:(CGFloat)k /*Img:(UIImage *)img*/ imgData:(NSData *)imgData;

- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;

@end
