//
//  Magic_Logger.m
//  MagicFramework
//
//  Created by NewM on 13-3-18.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_Logger.h"

//#define NSLog(format,...)

@interface MagicLogger ()

+ (void)logMessage:(const char *)func line:(int)line format:(NSString *)fmt valist:(va_list)args level:(NSString *)level;
@end

@implementation MagicLogger
+ (void)logInfo:(const char *)func line:(int)line msg:(NSString *)fmt, ...
{
    va_list args;
    va_start(args, fmt);
    [self logMessage:func line:line format:fmt valist:args level:@"INFO"];
    va_end(args);
}

+ (void)logError:(const char *)func line:(int)line msg:(NSString *)fmt, ...
{
    va_list args;
    va_start(args, fmt);
    [self logMessage:func line:line format:fmt valist:args level:@"ERROR"];
    va_end(args);
}

+ (void)logMessage:(const char *)func line:(int)line format:(NSString *)fmt valist:(va_list)args level:(NSString *)level
{
    NSString *message = [[NSString alloc] initWithFormat:fmt arguments:args];
    
    NSLog(@"[%@]%s[LINE:%d] %@", level, func, line, message);
    [message release];
}
@end
