//
//  NSObject+Dragon_Notification.m
//  DragonFramework
//
//  Created by NewM on 13-3-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "NSObject+Dragon_Notification.h"

@implementation NSNotification (DragonNotification)

- (BOOL)is:(NSString *)name
{
    return [self.name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
    return [self.name hasPrefix:prefix];
}

@end

@implementation NSObject (DragonNotification)


+ (NSString *)NOTIFICATION
{
    return [self NOTIFICATION_TYPE];
}

+ (NSString *)NOTIFICATION_TYPE
{
    return [NSString stringWithFormat:@"notify.%@.",[self description]];
}

- (void)handleNotification:(NSNotification *)notification
{
}

- (void)observeNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleNotification:)
												 name:name
											   object:nil];
}

- (void)unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)unobserveAllNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)postNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:nil];
    return YES;
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:object];
    return YES;
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object userInfo:(NSDictionary *)userinfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:object
                                                      userInfo:userinfo];
    return YES;
}

@end
