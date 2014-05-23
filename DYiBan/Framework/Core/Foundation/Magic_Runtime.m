//
//  Magic_Runtime.m
//  MagicFramework
//
//  Created by NewM on 13-3-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_Runtime.h"

@implementation MagicRuntime
+ (id)allocByClass:(Class)clazz
{
    if (!clazz) {
        return nil;
    }
    return [clazz alloc];
}

+ (id)allocByClassName:(NSString *)clazzName
{
    Class clazz = [MagicRuntime returnClassByName:clazzName];
    return [clazz alloc];
}

+ (id)returnClassByName:(NSString *)clazzName
{
    if (!clazzName || 0 == [clazzName length]) {
        return nil;
    }
    
    Class clazz = NSClassFromString(clazzName);
    if (!clazz) {
        return nil;
    }
    return clazz;
}


@end
