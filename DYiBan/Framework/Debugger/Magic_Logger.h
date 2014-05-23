//
//  Magic_Logger.h
//  MagicFramework
//
//  Created by NewM on 13-3-18.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DLogInfo(...) \
[MagicLogger logInfo:__func__ line:__LINE__ msg:__VA_ARGS__]
#define DLogError(...) \
[MagicLogger logError:__func__ line:__LINE__ msg:__VA_ARGS__]

@interface MagicLogger : NSObject


//log级别为info
+ (void)logInfo:(const char *)func line:(int)line msg:(NSString *)fmt,...;
//log级别为error
+ (void)logError:(const char *)func line:(int)line msg:(NSString *)fmt,...;

@end
