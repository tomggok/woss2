//
//  UIView+DragonViewSignal.h
//  DragonFramework
//
//  Created by NewM on 13-3-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dragon_ViewSignal.h"

@interface UIView (DragonViewSignal)

+ (NSString *)SIGNAL;
+ (NSString *)SIGNAL_TYPE;

- (void)handleViewSignal:(DragonViewSignal *)signal;

- (DragonViewSignal *)sendViewSignal:(NSString *)name;
- (DragonViewSignal *)sendViewSignal:(NSString *)name withObject:(NSObject *)object;
- (DragonViewSignal *)sendViewSignal:(NSString *)name withObject:(NSObject *)object from:(id)source;
- (DragonViewSignal *)sendViewSignal:(NSString *)name withObject:(NSObject *)object from:(id)source target:(id)target;

@end
