//
//  Dragon_ViewSignal.m
//  DragonFramework
//
//  Created by NewM on 13-3-5.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_ViewSignal.h"
#import "UIView+DragonCategory.h"

#import <objc/runtime.h>
#pragma mark -

@implementation NSObject(DragonViewSignalResponder)

+ (NSString *)SIGNAL
{
    return [self SIGNAL_TYPE];
}

+ (NSString *)SIGNAL_TYPE
{
    return [NSString stringWithFormat:@"signal.%@.", [self description]];
}

- (BOOL)isViewSignalResponder
{
    if ([self respondsToSelector:@selector(handleUISignal:)])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end

@interface DragonViewSignal(Private)
- (void)routes;
@end

@implementation DragonViewSignal
@synthesize isAutoTarget = _isAutoTarget;
@synthesize dead=_dead,
            reach=_reach,
            jump=_jump,
            source=_source,
            target=_target,
            name=_name,
            object=_object,
            returnValue=_returnValue;
@synthesize initTimeStamp=_initTimeStamp,
            sendTimeStamp=_sendTimeStamp,
            reachTimeStamp=_reachTimeStamp;
@synthesize timeElapsed,
            timeCostExcution,
            timeCostPending;

DEF_STATIC_PROPERTY(YES_VALUE);
DEF_STATIC_PROPERTY(NO_VALUE);

- (id)init
{
    self = [super init];
    if (self) {
        [self clear];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", _name];
}

- (BOOL)is:(NSString *)name
{
    return [_name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
    return [_name hasPrefix:prefix];
}

- (BOOL)isSentFrom:(id)source
{
    return (self.source == source) ? YES:NO;
}

- (BOOL)send
{
    if (_dead) {
        return NO;
    }
    
    _sendTimeStamp = [NSDate timeIntervalSinceReferenceDate];
    
    if ([_target isKindOfClass:[UIView class]] || [_target isKindOfClass:[UIViewController class]] || !_isAutoTarget) {
        _jump = 1;
        [self routes];
    }else
    {
        _reachTimeStamp = [NSDate timeIntervalSinceReferenceDate];
        _reach = YES;
    }
    return _reach;
}

- (BOOL)forward:(id)target
{
    if (_dead) {
        return NO;
    }
    
    if ([_target isKindOfClass:[UIViewController class]] || [_target isKindOfClass:[UIView class]])
    {
        _jump += 1;
        
        _target = target;
        
        [self routes];
    }else
    {
        _reachTimeStamp = [NSDate timeIntervalSinceReferenceDate];
        _reach = YES;
    }
    
    return _reach;
}
//可以用多种
- (void)routes
{
    
    DLogInfo(@"发送者 ：%@", _source);
    DLogInfo(@"接受者 ：%@", _target);
    //操作转发者的view（既被操作的）
    NSArray *array = [_name componentsSeparatedByString:@"."];
    DLogInfo(@"signal array === %@", array);
    if (array && array.count > 1)
    {
        NSString *clazz = (NSString *)[array objectAtIndex:1];
        NSString *method = (NSString *)[array objectAtIndex:2];
        
        NSObject *targetObject = _target;
        
        if ([_target isKindOfClass:[UIView class]]) {
            UIViewController *viewController = [(UIView *)_target viewController];
            if (viewController) {
                targetObject = viewController;
            }
        }
        
        NSString *selectorName;
        SEL selector;
        
        selectorName = [NSString stringWithFormat:@"handleViewSignal_%@_%@:", clazz, method];
        selector = NSSelectorFromString(selectorName);
        if ([targetObject respondsToSelector:selector]) {
            [targetObject performSelector:selector withObject:self];
            return;
        }
        
        selectorName = [NSString stringWithFormat:@"handleViewSignal_%@:", clazz];
        selector = NSSelectorFromString(selectorName);
        if ([targetObject respondsToSelector:selector]) {
            [targetObject performSelector:selector withObject:self];
            return;
        }
        
    }
    //操作发送者view
    Class rtti = [_source class];
    for (;;) {//无限循环
        if (!rtti) {
            break;
        }
        
        NSString *selectorName = [NSString stringWithFormat:@"handle%@:", [rtti description]];
        SEL selector = NSSelectorFromString(selectorName);
        if ([_target respondsToSelector:selector]) {
            [_target performSelector:selector withObject:self];
            break;
        }
        rtti = class_getSuperclass(rtti);
    }
    
    if (!rtti) {
        if ([_target respondsToSelector:@selector(handleViewSignal:)]) {
            [_target performSelector:@selector(handleViewSignal:) withObject:self];
        }
    }
}

- (NSTimeInterval)timeElapsed
{
    return _reachTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostPending
{
    return _sendTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostExcution
{
    return _reachTimeStamp - _sendTimeStamp;
}

- (void)clear
{
    self.dead = NO;
    self.reach = NO;
    self.jump = 0;
    self.source = nil;
    self.target = nil;
    self.name = @"signal.nil.nil";
    self.object = nil;
    self.returnValue = nil;
    
    self.isAutoTarget = YES;
    
    _initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
    _sendTimeStamp = _initTimeStamp;
    _reachTimeStamp = _initTimeStamp;
}

- (BOOL)boolValue
{
    if (self.returnValue == DragonViewSignal.YES_VALUE)
    {
        return YES;
    }else if (self.returnValue == DragonViewSignal.NO_VALUE)
    {
        return NO;
    }
    return NO;
}

- (void)returnYES
{
    self.returnValue = DragonViewSignal.YES_VALUE;
}

- (void)returnNO
{
    self.returnValue = DragonViewSignal.NO_VALUE;
}

- (void)dealloc
{
    [_name release];
//    [_object release];
//    [_returnValue release];
    [super dealloc];
}


@end
