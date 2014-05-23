//
//  NQDevice.m
//  Test
//
//  Created by nearmobile on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Magic_Device.h"

#import "CTCarrier.h"
#import "CTTelephonyNetworkInfo.h"
#import "Reachability.h"

#import "UIDevice+Hardware.h"
#import "UIDevice+IdentifierAddition.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation MagicDevice

static const char* jailbreak_apps[]=
{
    "/Applications/Cydia.app", 
    "/Applications/limera1n.app", 
    "/Applications/greenpois0n.app", 
    "/Applications/blackra1n.app",
    "/Applications/blacksn0w.app",
    "/Applications/redsn0w.app",
    NULL,
};


//是否越狱
+(BOOL)isJailBroken
{
    // Now check for known jailbreak apps. If we encounter one, the device is jailbroken.
    for(int i = 0; jailbreak_apps[i]!=NULL; ++i)
    {
        if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_apps[i]]])
        {
            //YBLogInfo(@"isjailbroken: %s", jailbreak_apps[i]);
            return YES;
        }
    }
    // TODO: Add more checks? This is an arms-race we're bound to lose.
    return NO;
}
#define IM_DEVICE_UUID                   @"deviceUUID"

+(NSString *)UUID
{    
    NSString *uuid=[[NSUserDefaults standardUserDefaults] objectForKey:IM_DEVICE_UUID];
    
    if (!uuid || uuid.length<1) 
    {
        CFUUIDRef deviceId = CFUUIDCreate (NULL);
        
        CFStringRef deviceIdStringRef = CFUUIDCreateString(NULL,deviceId);
        
        CFRelease(deviceId);
        
        NSString *deviceIdString = (NSString *)deviceIdStringRef;
        
        deviceIdString = [deviceIdString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
//        [[NSUserDefaults standardUserDefaults] setObject:deviceIdString forKey:IM_DEVICE_UUID];
//        
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        uuid=deviceIdString;
    }
    
    return uuid;
}
+ (NSString *)IMEI
{
    NSString *imei = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    return imei;
}


//平台类型
+(NSString *)platform{
    
    return @"iphone";
}

//os 版本
+(float)sysVersion
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return version;
}

//OS类型
+(NSString *)mPlatform{

    NSString *phoneOS=[NSString stringWithFormat:@"%@%@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
    phoneOS=[phoneOS stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return phoneOS;
}

//判断屏幕  1，iphone5；0，iphone4，4s，touch
+ (NSInteger)boundSizeType
{
    CGSize mainSize = MAINSIZE;
    if (mainSize.height > 480)
    {
        return 1;
    }else
    {
        return 0;
    }
}


//运营商名称
+(NSString *)carrierName{
    
#if TARGET_IPHONE_SIMULATOR

    return @"-1";
    
#else
    
    NSString *ret=nil;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
        
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = info.subscriberCellularProvider;
        
        //YBLogInfo(@"carrier:%@", [carrier description]);
        ret=carrier.carrierName;
    }
    
    if (!ret || ret.length==0 || [ret isEqualToString:@"Carrier"]) {
        
        ret=@"-1";
    }

    return ret;
    
#endif
}



//是否连接网络
+(BOOL)hasInternetConnection{
	
	Reachability* curReach = [[Reachability reachabilityForInternetConnection] retain];
	
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
	BOOL isReachable=NO;
	
    switch (netStatus)
    {
        case NotReachable:
        {
			isReachable=NO;
			//YBLogInfo(@"InternetConnection ----------------->>>  Access Not Available");
            break;
        }
            
        case ReachableViaWWAN:
        {
			isReachable=YES;
			//YBLogInfo(@"InternetConnection ----------------->>>  ReachableViaWWAN");
            break;
        }
        case ReachableViaWiFi:
        {
			isReachable=YES;
			//YBLogInfo(@"InternetConnection ----------------->>>  ReachableViaWiFi");
            break;
		}
    }
    
	return isReachable;
}

Reachability* curReach;
//网络连接方式
+(NSString *)networkType{
	
    //1-3G,2-2G,3-WiFi
    
    NSString *ret=@"2g";
    
    if (!curReach)
    {
        curReach = [[Reachability reachabilityForInternetConnection] retain];
    }
	
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
        
    switch (netStatus)
    {
        case NotReachable:
        {
			ret=@"-1";
            break;
        }
            
        case ReachableViaWWAN:
        {
			ret=@"2g";
            break;
        }
        case ReachableViaWiFi:
        {
			ret=@"wifi";
            break;
		}
    }
    
    return ret;
}


//获取可用存储空间
+(NSString *)freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    float floatValue=[[fattributes objectForKey:NSFileSystemFreeSize] doubleValue]/1024.0;
    NSString *ret=[NSString stringWithFormat:@"%.0f",floatValue];
    
    return ret;
}

#pragma mark-得到当前设备是iphone还是ipad
+(UIUserInterfaceIdiom)getCurUserInterfaceIdiom
{
    return [[UIDevice currentDevice] userInterfaceIdiom];
}

#pragma mark-判断正运行的设备是否支持多任务
+(BOOL)isMutitaskingSupported
{
    if ([[UIDevice currentDevice]respondsToSelector:@selector(isMutitaskingSupported)]) {
        return [[UIDevice currentDevice]isMultitaskingSupported];
    }
    return NO;
}

#pragma mark-手电筒开关
+(void)openTorch:(AVCaptureTorchMode)AVCaptureTorchMode
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchMode];  // 手电筒开关
        [device unlockForConfiguration];
    }
}

@end
