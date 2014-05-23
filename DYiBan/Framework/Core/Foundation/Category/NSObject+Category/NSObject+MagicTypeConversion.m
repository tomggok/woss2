//
//  NSObject+MagicTypeConversion.m
//  MagicFramework
//
//  Created by NewM on 13-4-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "NSObject+MagicTypeConversion.h"

@implementation NSObject (MagicTypeConversion)

- (NSString *)asNSString
{
    if ([self isKindOfClass:[NSString class]])
    {
        return (NSString *)self;
    }else
    {
        return [NSString stringWithFormat:@"%@",self];
    }
}

@end
