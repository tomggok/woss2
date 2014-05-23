//
//  Magic_Runtime.h
//  MagicFramework
//
//  Created by NewM on 13-3-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MagicRuntime : NSObject

+ (id)allocByClass:(Class)clazz;
+ (id)allocByClassName:(NSString *)clazzName;
+ (id)returnClassByName:(NSString *)clazzName;

@end
