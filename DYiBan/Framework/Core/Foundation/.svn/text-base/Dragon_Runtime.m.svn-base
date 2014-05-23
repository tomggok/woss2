//
//  Dragon_Runtime.m
//  DragonFramework
//
//  Created by NewM on 13-3-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_Runtime.h"

@implementation DragonRuntime
+ (id)allocByClass:(Class)clazz
{
    if (!clazz) {
        return nil;
    }
    return [clazz alloc];
}

+ (id)allocByClassName:(NSString *)clazzName
{
    Class clazz = [DragonRuntime returnClassByName:clazzName];
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
