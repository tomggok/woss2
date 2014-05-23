//
//  NSDictionary+JSON.m
//  Magic
//
//  Created by Zzl on 13-3-18.
//
//

#import "NSDictionary+JSON.h"
#import <objc/runtime.h>
#import "NSObject+JSON.h"
#import "NSArray+JSON.h"

@implementation NSDictionary (JSON)


- (id)initDictionaryTo:(Class)responseType
{
    id object = [[responseType alloc] init];

    u_int count;
    Ivar *ivars = class_copyIvarList(responseType, &count);//获取类的实例变量数量
    
    for (int i = 0; i < count; i++) {
        //获得 model 的名字和类型
        const char *ivarCName = ivar_getName(ivars[i]);
        const char *ivarCType = ivar_getTypeEncoding(ivars[i]);
        
        NSString *ivarName = [[[NSString alloc] initWithCString:ivarCName encoding:NSUTF8StringEncoding] autorelease];
        NSString *ivarType = [[[NSString alloc] initWithCString:ivarCType encoding:NSUTF8StringEncoding] autorelease];
        
        
        id value = [self valueForKey:ivarName];
        if ([value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSNumber class]] ||
            !value)
        {
            if (!value)
            {
                if (([ivarType isEqualToString:@"i"]))
                {
                    //处理int类型
                    value = @"0";
                }
                
            }   
        }else if ([value isKindOfClass:[NSNull class]])
        {
            //为null的格式
            value = nil;
            
        }else if([value isKindOfClass:[NSArray class]])
        {
            //是array类型
            Class genericClass = NSClassFromString(ivarName);
            value = [(NSArray *)value dictionaryArrayToArray:genericClass];
        }else if ([value isKindOfClass:[NSDictionary class]])
        {
            //是dict类型
            value = (NSDictionary *)value;
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
            //当类型不为nsdictionay时才会反序列化成对象
            if (![ivarType isEqualToString:@"NSDictionary"] &&
                ![ivarType isEqualToString:@"NSMutableDictionary"])
            {
                value = [value initDictionaryTo:NSClassFromString(ivarType)];
                
                [object setValue:value forKey:ivarName];
                [value release];
                value = nil;
                continue;
            }
            
        }else
        {
            NSLog(@"JSON unknown type : %@", NSStringFromClass([value class]));
        }


        [object setValue:value forKey:ivarName];
        ivarName = nil;
        ivarType = nil;

        
    }
    free(ivars);
    
    return object;
}

@end
