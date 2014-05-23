//
//  UIViewController+DragonViewSignal.m
//  DragonFramework
//
//  Created by NewM on 13-3-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIViewController+DragonViewSignal.h"
#import "Dragon_ViewSignal.h"
@implementation UIViewController (DragonViewSignal)

+ (NSString *)SIGNAL
{
    return [self SIGNAL_TYPE];
}

+ (NSString *)SIGNAL_TYPE
{
    return [NSString stringWithFormat:@"signal.%@.",[self description]];
}

- (void)handleViewSignal:(DragonViewSignal *)signal
{
    signal.reach = YES;
}

- (DragonViewSignal *)sendViewSignal:(NSString *)name
{
    return [self sendViewSignal:name withObject:nil from:self];
}

- (DragonViewSignal *)sendViewSignal:(NSString *)name withObject:(NSObject *)object
{
    return [self sendViewSignal:name withObject:object from:self];
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
