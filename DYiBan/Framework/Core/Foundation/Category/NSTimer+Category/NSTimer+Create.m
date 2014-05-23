//
//  NSTimer+Creat.m
//  MagicFramework
//
//  Created by zhangchao on 13-4-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "NSTimer+Create.h"

@implementation NSTimer (Create)


#pragma mark-创建一个计时器,在ti秒后或每隔ti秒回调Selector函数,函数一定要在target类里
+(NSTimer *)CreatAnTimeToCallAnFunctionBySelector:(SEL)Selector AfterTimeInterval:(NSTimeInterval)ti target :(id)target userInfo:(id)userInfo repeats:(BOOL)repeats isWantToHave:(BOOL)isWantToHave/*target是否想拥有返回值*/
{
    if(isWantToHave){
        return [[NSTimer scheduledTimerWithTimeInterval:ti target:target selector:Selector userInfo:userInfo repeats:repeats]retain/*timer未通过alloc创建,是个自动释放对象,故target想拥有它,要retain他,target用完它就可以先invalidate再release再=nil*/];
    }else {
        return [NSTimer scheduledTimerWithTimeInterval:ti target:target selector:Selector userInfo:userInfo repeats:repeats];
    }
}

@end
