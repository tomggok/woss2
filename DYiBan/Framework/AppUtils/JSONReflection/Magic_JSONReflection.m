//
//  Magic_JSONReflection.m
//  MagicFramework
//
//  Created by NewM on 13-3-18.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"
#import "NSDictionary+JSON.h"
#import "Magic_Runtime.h"
#import "JSON.h"
#import <objc/runtime.h>

@implementation MagicJSONReflection

//json反序列化
+ (id)JSONReflection:(id)data
{
    
    if ([data isKindOfClass:[NSString class]])
    {
        data = [data JSONFragmentValue];
    }
    id class = [(id)[data initDictionaryTo:[self class]] autorelease];
    
    return class;
}

- (id)OJBTOJSON
{
    NSDictionary *dict = [MagicJSONReflection OJBTOJSON:self];
    return [dict JSONFragment];
}

//json序列化
+ (id)OJBTOJSON:(id)clazz
{
    unsigned int methodCount_f = 0;
    
//    NSMutableDictionary *dictProperty = [[NSMutableDictionary alloc] initWithCapacity:2];
    //获得类中全部属性
    objc_property_t *properties = class_copyPropertyList([clazz class], &methodCount_f);

    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:methodCount_f] autorelease];
    
    for (int i = 0; i < methodCount_f; i++)
    {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        const char *char_a = property_getAttributes(property);
        NSString *proName = [NSString stringWithUTF8String:char_f];
        NSString *proAtt = [NSString stringWithUTF8String:char_a];

        SEL sel = NSSelectorFromString(proName);
        IMP img_f = [clazz methodForSelector:sel];
        
        
        id value = img_f(clazz, sel);
        
        if ([proName isEqualToString:@"comment_num_info"])
        {
            
        }
        
        NSArray *atts = [proAtt componentsSeparatedByString:@","];
        NSString *att = atts[0];
        if ([att isEqualToString:@"Ti"])
        {
            value = [NSString stringWithFormat:@"%d", (int)value];
        }else if ([att isEqualToString:@"T@\"NSArray\""])
        {
            NSArray *nValue = (NSArray *)value;
            NSMutableArray *arrValue = [[[NSMutableArray alloc] initWithCapacity:[nValue count]] autorelease];
            for (int i = 0 ; i < [nValue count]; i++)
            {
                id obj = [nValue objectAtIndex:i];
                DLogInfo(@"obj === %@", [obj class]);
                NSDictionary *result = nil;
                if ([obj isKindOfClass:[NSDictionary class]])
                {
                    result = obj;
                }else if ([obj isKindOfClass:[NSArray class]])
                {
                    result = obj;
                }else
                {
                    result = [MagicJSONReflection OJBTOJSON:obj];
                }
                
                [arrValue addObject:result];
            }
            value = arrValue;
        }else if ([att isEqualToString:@"T@\"NSString\""])
        {
            
        }else
        {
            if ([value isKindOfClass:[NSArray class]])
            {
                NSArray *nValue = (NSArray *)value;
                NSMutableArray *arrValue = [[[NSMutableArray alloc] initWithCapacity:[nValue count]] autorelease];
                for (int i = 0 ; i < [nValue count]; i++)
                {
                    id obj = [nValue objectAtIndex:i];
                    NSDictionary *result = [MagicJSONReflection OJBTOJSON:obj];
                    [arrValue addObject:result];
                }
                value = arrValue;
            }else
            {
                value = [MagicJSONReflection OJBTOJSON:value];
            }
//
        }
        if (!value)
        {//判断value是否存在不存在负NULL
            value = [NSNull null];
        }
        [dict setValue:value forKey:proName];
    }
    
    free(properties);
    return dict;
}

- (void)dealloc
{
    [super dealloc];
}

////遍历类中的方法
/*
 Method *methodList_f = class_copyMethodList([clazz class], &methodCount_f);
 NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
 for (int i = 0; i < methodCount_f; i++)
 {
 Method temp_f = methodList_f[i];
 IMP imp_f = method_getImplementation(temp_f);
 SEL name_f = method_getName(temp_f);
 const char *name_s = sel_getName(method_getName(temp_f));
 int arguments = method_getNumberOfArguments(temp_f);//获取参数个数
 const char *encoding = method_getTypeEncoding(temp_f);//方法编码
 const char *retunType = method_copyReturnType(temp_f);
 NSString *rType = [NSString stringWithUTF8String:retunType];//返回类型
 NSString *method = [NSString stringWithUTF8String:name_s];
 
 if (arguments == 2 && [dictProperty objectForKey:method] && ![rType isEqualToString:@"v"])
 {
 id s = imp_f(clazz, name_f);
 if ([rType isEqualToString:@"i"])
 {
 s = [NSString stringWithFormat:@"%d", i];
 }
 [dict setValue:s forKey:[NSString stringWithUTF8String:name_s]];
 
 if ([[dictProperty allKeys] count] == [[dict allKeys] count])
 {
 break;
 }
 }
 
 DLogInfo(@"retunType === %s", retunType);
 DLogInfo(@"method : %@", method);
 DLogInfo(@"method att count: %d", arguments);
 DLogInfo(@"method encod : %s", encoding);
 }
 //    NSString *json = [dict JSONFragment];
 
 free(methodList_f);
 
 RELEASEDICTARRAYOBJ(dictProperty);
 //    RELEASEDICTARRAYOBJ(dict);
 return dict;*/

@end
