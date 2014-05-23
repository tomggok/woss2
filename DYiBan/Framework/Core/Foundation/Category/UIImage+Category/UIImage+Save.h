//
//  UIImage+Save.h
//  MagicFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Save)

-(NSData *)saveToNSDataByCompressionQuality:(CGFloat)compressionQuality/*传-1表示返回png;压缩系数,一般为1.0,如果对图片的清晰度要求不高,可减小压缩系数,从而大福降低图片数据量,此函数本身就比UIImagePNGRepresentation函数得到的图片数据量低*/;
+(UIImage *)imgShotWithView:(UIView *)view ClippingImageByRect:(CGRect)rect/*要裁剪的区间*/;
-(UIImage *)ClippingImageByRect:(CGRect)Rect/*裁剪区*/;
-(NSData *)CompressPicturesMoreThanKB:(CGFloat)k /*Img:(UIImage *)img*/ imgData:(NSData *)imgData;

@end
