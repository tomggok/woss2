//
//  NSArray+JSON.m
//  Magic
//
//  Created by Zzl on 13-3-18.
//
//

#import "NSArray+JSON.h"
#import "NSObject+JSON.h"
#import "NSDictionary+JSON.h"
#import <objc/runtime.h>

@implementation NSArray (JSON)


//将字 dictionary 中的 array对象 转换成 array
- (NSMutableArray *)arrayToDictonaryArray
{
    NSInteger count = [self count];
    NSMutableArray *mutableArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < count; i++) {
        id obj = [self objectAtIndex:i];
        
        if ([obj isKindOfClass:[NSString class]] ||
            [obj isKindOfClass:[NSNumber class]]) {
            [mutableArray addObject:obj];
        }else
        {
            [mutableArray addObject:[obj objectToDictionary]];
        }
    }
    return mutableArray;

}

//将在dictionary中的arry 转行成 arry对象（包括自定义对象）
- (NSMutableArray *)dictionaryArrayToArray:(Class)genericType
{
    NSInteger count = [self count];
    NSMutableArray *mutableArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < count; i++) {
        id obj = [self objectAtIndex:i];
        
        if ([obj isKindOfClass:[NSString class]] ||
            [obj isKindOfClass:[NSNumber class]]) {
            //什么也不做
        }else
        {
            if (genericType) {
                obj = [[(NSDictionary *)obj initDictionaryTo:genericType] autorelease];
            }
        }
        [mutableArray addObject:obj];
        
    }
    return mutableArray;

}
@end
