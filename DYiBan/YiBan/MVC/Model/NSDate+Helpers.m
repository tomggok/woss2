//
//  NSDate+Helpers.m
//  DYiBan
//
//  Created by Song on 13-9-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "NSDate+Helpers.h"

@implementation NSDate (Helpers)

- (NSUInteger) numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                              inUnit:NSMonthCalendarUnit
                                             forDate:self].length;
}
@end
