//
//  NSObject+JSON.m
//  Magic
//
//  Created by Zzl on 13-3-18.
//
//

#import "NSObject+JSON.h"
#import "NSArray+JSON.h"
#import "NSDictionary+JSON.h"
#import <objc/runtime.h>

@implementation NSObject (JSON)
//将对象  转成  dict
- (NSMutableDictionary *)objectToDictionary
{
    Class clazz = [self class];
    u_int count;
    
    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    Ivar *ivars = class_copyIvarList(clazz, &count);
    for (int i = 0; i < count; i++) {
        //获得 model 的名字和类型
        const char *ivarCName = ivar_getName(ivars[i]);
        const char *ivarCType = ivar_getTypeEncoding(ivars[i]);
        
        NSString *ivarName = [NSString stringWithCString:ivarCName encoding:NSUTF8StringEncoding];
        NSString *ivarType = [NSString stringWithCString:ivarCType encoding:NSUTF8StringEncoding];
//        ivarType
        
        id value = nil;
        if ([ivarType compare:@"@\"NSArray\""] == NSOrderedSame) {
            value = [(NSArray *)[self valueForKey:ivarName] arrayToDictonaryArray];
        }else if ([ivarType compare:@"@\"NSString\""] == NSOrderedSame ||
                  [ivarType compare:@"@\"NSNumber\""] == NSOrderedSame ||
                  [ivarType compare:@"@\"NSDictionary\""] == NSOrderedSame)
        {
            value = [self valueForKey:ivarName];
            
        }else
        {
            value = [[self valueForKey:ivarName] objectToDictionary];
        }
        
        [dictionary setValue:value forKey:ivarName];

    }
    free(ivars);
    return dictionary;
}

@end
