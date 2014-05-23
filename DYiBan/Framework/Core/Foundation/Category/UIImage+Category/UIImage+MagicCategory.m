//
//  UIImage+MagicCategory.m
//  ShangJiaoYuXin
//
//  Created by NewM on 13-5-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIImage+MagicCategory.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@interface UIImage ()
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;
@end




@implementation UIImage (MagicCategory)

//根据颜色返回图片
+ (UIImage*)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//截取当前view为图片
+ (UIImage *)cutScreenImg:(UIView *)viewImg
{
    UIGraphicsBeginImageContextWithOptions(viewImg.bounds.size, viewImg.opaque, 0.f);
    [viewImg.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

//按照坐标截取Img
- (UIImage *)cutImgWithRect:(CGRect)rect
{
    CGImageRef imgRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    UIImage *subImg = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    return subImg;
    
}

//虚化当前image
- (UIImage *)boxblurImageWithBlur:(CGFloat)blur
{
    if (blur < .0f || blur >1.f)
    {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 40);
    boxSize -= ((boxSize % 2) + 1);
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if (!pixelBuffer)
    {
        NSLog(@"no Pixerbuffer");
    }
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error)
    {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    
    return returnImage;
    
}

+(UIImage *)imageNamed:(NSString *)name fileType:(NSString *)fileType/*文件后缀*/ isBigOrUnSameByOtherImg/*此图片是否是大图片或者 和数据源里的其他图片不一样 http://www.cnblogs.com/pengyingh/articles/2355033.html*/ :(BOOL)isBigOrUnSameByOtherImg
{
    if(isBigOrUnSameByOtherImg){
        return [self imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:fileType]];
    }else{
        return [self imageNamed:name];
    }
}

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

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality {
    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                         interpolationQuality:quality];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                                 round((resizedImage.size.height - thumbnailSize) / 2),
                                 thumbnailSize,
                                 thumbnailSize);
    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
    
    UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;
    
    return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", contentMode];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self resizedImage:newSize interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
		case UIImageOrientationUp:
		case UIImageOrientationUpMirrored:
			break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
		case UIImageOrientationUp:
		case UIImageOrientationLeft:
		case UIImageOrientationDown:
		case UIImageOrientationRight:
			break;
    }
    
    return transform;
}

@end
