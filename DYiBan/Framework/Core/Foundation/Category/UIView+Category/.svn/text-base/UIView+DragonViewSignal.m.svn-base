//
//  UIView+DragonViewSignal.m
//  DragonFramework
//
//  Created by NewM on 13-3-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIView+DragonViewSignal.h"
#import <objc/runtime.h>

@implementation UIView (DragonViewSignal)

+ (NSString *)SIGNAL
{
    return [self SIGNAL_TYPE];
}

+ (NSString *)SIGNAL_TYPE
{
    return [NSString stringWithFormat:@"signal.%@.", [self description]];
}

- (void)handleViewSignal:(DragonViewSignal *)signal
{
    if (self.subviews) {
        [signal forward:self.superview];
    }else
    {
        signal.reach = YES;
    }
}

- (DragonViewSignal *)sendViewSignal:(NSString *)name
{
    return [self sendViewSignal:name withObject:nil from:nil target:nil];
}

- (DragonViewSignal *)sendViewSignal:(NSString *)name withObject:(NSObject *)object
{
    return [self sendViewSignal:name withObject:object from:self target:nil];
}

- (DragonViewSignal *)sendViewSignal:(NSString *)name withObject:(NSObject *)object from:(id)source
{
    return [self sendViewSignal:name withObject:object from:source target:nil];
}

- (DragonViewSignal *)sendViewSignal:(NSString *)name withObject:(NSObject *)object from:(id)source target:(id)target
{
    DragonViewSignal *signal = [[[DragonViewSignal alloc] init] autorelease];
    
    if (signal) {
        signal.source = source ? source : self;
        signal.target = target ? target : self;
        signal.isAutoTarget = target ? NO : YES;
        signal.name = name;
        signal.object = object;
        [signal send];
    }
    return signal;
}

@end
