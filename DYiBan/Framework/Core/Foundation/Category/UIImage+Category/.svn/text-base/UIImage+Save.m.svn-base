//
//  UIImage+Save.m
//  DragonFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIImage+Save.h"

@implementation UIImage (Save)

#pragma mark-把UIImage转化压缩成NSData
-(NSData *)saveToNSDataByCompressionQuality:(CGFloat)compressionQuality/*传-1表示返回png;压缩系数,一般为1.0,如果对图片的清晰度要求不高,可减小压缩系数,从而大福降低图片数据量,此函数本身就比UIImagePNGRepresentation函数得到的图片数据量低*/
{
    return (compressionQuality!=-1)?(UIImageJPEGRepresentation(self, compressionQuality)):(UIImagePNGRepresentation(self));
}

#pragma mark-截图
+(UIImage *)imgShotWithView:(UIView *)view ClippingImageByRect:(CGRect)rect/*要裁剪的区间*/
{
        //extern CGImageRef UIGetScreenImage();//私有API,可能通不过审核
        //UIImage *img=[UIImage imageWithCGImage:UIGetScreenImage()];

        //LogSize(__FUNCTION__, [AppDelegate shareAppDelegate].window.frame.size);
//    UIGraphicsBeginImageContext([UIApplication sharedApplication].delegate.window.frame.size);
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

        //CGRect rect=CGRectMake(0,kStateBar+kH_UINavigationController,screenShows.size.width,screenShows.size.height-(kH_UINavigationController));//因为不清楚为何视图控制器在回调viewDidAppear时打印的view的高是416,没包括导航栏的高,故先截除了状态栏和导航栏的图

//    img=[UIImage imageWithCGImage:CGImageCreateWithImageInRect([img CGImage],rect)];

        //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);//把图片存入相册

    return img;
}

#pragma mark-裁剪UIImage
-(UIImage *)ClippingImageByRect:(CGRect)Rect/*裁剪区*/
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], Rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}

#pragma mark-把大于多少K的图片压缩
-(NSData *)CompressPicturesMoreThanKB:(CGFloat)k /*Img:(UIImage *)img*/ imgData:(NSData *)imgData
{
    NSUInteger sizeOrigin = [imgData length];
    NSUInteger sizesizeOriginKB = sizeOrigin / 1024;

    if (sizesizeOriginKB > k) {
        float a = k;
        float  b = (float)sizesizeOriginKB;
        float q = sqrt(a/b);
        CGSize sizeImage = [self size];
        CGFloat iwidthSmall = sizeImage.width * q;
        CGFloat iheightSmall = sizeImage.height * q;
        CGSize itemSizeSmall = CGSizeMake(iwidthSmall, iheightSmall);
        UIGraphicsBeginImageContext(itemSizeSmall);
        CGRect imageRectSmall = CGRectMake(0.0f, 0.0f, itemSizeSmall.width, itemSizeSmall.height);
        [self drawInRect:imageRectSmall];
        UIImage *SmallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *dataImageSend = UIImageJPEGRepresentation(SmallImage, 1.0);
        imgData = dataImageSend;
    }
    return imgData;
}

@end
