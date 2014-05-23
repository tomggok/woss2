//
//  NQDevice.h
//  Test
//
//  Created by nearmobile on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MagicDevice : NSObject
{    
    
}

//是否越狱
+(BOOL)isJailBroken;

//UUID替代方案
+(NSString *)UUID;
//替代2
+ (NSString *)IMEI;

//平台类型，固定为iPhone
+(NSString *)platform;

//os 版本
+(float)sysVersion;

//OS类型
+(NSString *)mPlatform;

//运营商名称
+(NSString *)carrierName;

//是否连接网络
+(BOOL)hasInternetConnection;

//网络连接方式
+(NSString *)networkType;

//获取可用存储空间
+(NSString *)freeDiskSpace;
//判断屏幕1，iphone5；0，iphone4，4s，touch
+ (NSInteger)boundSizeType;

+(UIUserInterfaceIdiom)getCurUserInterfaceIdiom;
+(BOOL)isMutitaskingSupported;
+(void)openTorch:(AVCaptureTorchMode)AVCaptureTorchMode;

@end
