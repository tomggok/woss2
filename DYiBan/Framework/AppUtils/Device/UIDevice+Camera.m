//
//  UIDevice+Camera.m
//  MagicFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIDevice+Camera.h"

@implementation UIDevice (Camera)

#pragma mark-设备是否支持照相机或图片库
+(BOOL)isAdviceSuppertCameraOrPhotoLibrary:(UIImagePickerControllerSourceType)SourceType
{
    return [UIImagePickerController isSourceTypeAvailable:SourceType];
}

#pragma mark-设备的摄像头是否支持拍照或摄像功能
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType/*拍照功能:(__bridge NSString *)kUTTypeImage; 摄像功能:(__bridge NSString *)kUTTypeMovie*/sourceType:(UIImagePickerControllerSourceType)paramSourceType/*拍照功能:UIImagePickerControllerSourceTypeCamera; 摄像功能:UIImagePickerControllerSourceTypeCamera; */
{

    __block BOOL result = NO;

    if ([paramMediaType length] == 0){
        NSLog(@"Media type is empty.");
        return NO;
    }

        //此设备支持的媒体类型
    NSArray *availableMediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];

        //闭包形式遍历数组
    [availableMediaTypes enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop) {

         NSString *mediaType = (NSString *)obj;
         if ([mediaType isEqualToString:paramMediaType]){
             result = YES;
             *stop= YES;
         }

     }];

    return result;

}

#pragma mark-设备是否支持摄像
+ (BOOL) doesCameraSupportShootingVideos
{

    return [self cameraSupportsMedia:(NSString *)kUTTypeMovie
                          sourceType:UIImagePickerControllerSourceTypeCamera];

}

#pragma mark-设备是否支持拍照
+ (BOOL) doesCameraSupportTakingPhotos
{

    return [self cameraSupportsMedia:( NSString *)kUTTypeImage
                          sourceType:UIImagePickerControllerSourceTypeCamera];

}

#pragma mark-前置摄像头是否可用
+ (BOOL) isFrontCameraAvailable
{
    return [UIImagePickerController
            isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];

}

#pragma mark-后摄像头是否可用
+ (BOOL) isRearCameraAvailable
{
    return [UIImagePickerController
            isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];

}

#pragma mark-前置闪光灯是否可用
+ (BOOL) isFlashAvailableOnFrontCamera
{
    return [UIImagePickerController isFlashAvailableForCameraDevice:
            UIImagePickerControllerCameraDeviceFront];

}

#pragma mark-后置闪光灯是否可用
+ (BOOL) isFlashAvailableOnRearCamera
{
    return [UIImagePickerController isFlashAvailableForCameraDevice:
            UIImagePickerControllerCameraDeviceRear];

}

#pragma mark-得到摄像头捕获的 原始|裁剪 图片
+(UIImage *)getOriginalOrEditedImgFromCamera:(NSString *)imgType/*UIImagePickerControllerOriginalImage|UIImagePickerControllerEditedImage|UIImagePickerControllerCropRect:当打开编辑模式的时候,这个对象,将会包含裁剪剩余的图像部分,返回的貌似是个NSValue (CGRect)*/ d:(NSDictionary *)d
{
    return [d objectForKey:imgType];
}

#pragma mark-是否能从图片库获取图片
+ (BOOL) canUserPickPhotosFromPhotoLibrary
{

    return [self
            cameraSupportsMedia:( NSString *)kUTTypeImage
            sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark-是否能从图片库获取视频
+(BOOL) canUserPickVideosFromPhotoLibrary
{

    return [self
            cameraSupportsMedia:(  NSString *)kUTTypeMovie
            sourceType:UIImagePickerControllerSourceTypePhotoLibrary];

}


@end
