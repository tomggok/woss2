//
//  UIViewController+MagicViewSignal.h
//  MagicFramework
//
//  Created by NewM on 13-3-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Magic_ViewSignal.h"
@class MagicViewSignal;

@interface UIViewController (MagicViewSignal)


+ (NSString *)SIGNAL;
+ (NSString *)SIGNAL_TYPE;

- (void)handleViewSignal:(MagicViewSignal *)signal;

- (MagicViewSignal *)sendViewSignal:(NSString *)name;
- (MagicViewSignal *)sendViewSignal:(NSString *)name withObject:(NSObject *)object;
- (MagicViewSignal *)sendViewSignal:(NSString *)name withObject:(NSObject *)object from:(id)source;
- (MagicViewSignal *)sendViewSignal:(NSString *)name withObject:(NSObject *)object from:(id)source target:(id)target;
@end
