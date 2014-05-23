//
//  NSObject+Dragon_Notification.h
//  DragonFramework
//
//  Created by NewM on 13-3-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+DragonProperty.h"

#define AS_NOTIFICATION(_name) AS_STATIC_PROPERTY(_name)
#define DEF_NOTIFICATION(_name) DEF_STATIC_PROPERTY3(_name, @"notify", [self description])


@interface NSNotification (DragonNotification)

- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;
@end

@interface NSObject (DragonNotification)

+ (NSString *)NOTIFICATION;
+ (NSString *)NOTIFICATION_TYPE;

- (void)handleNotification:(NSNotification *)notification;
- (void)observeNotification:(NSString *)name;
- (void)unobserveNotification:(NSString *)name;
- (void)unobserveAllNotification;

- (BOOL)postNotification:(NSString *)name;
- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;
- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object userInfo:(NSDictionary *)userinfo;
@end
