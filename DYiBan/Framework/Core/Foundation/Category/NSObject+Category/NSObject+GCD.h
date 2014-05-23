//
//  NSObject+GCD.h
//  MagicFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

    //多线程/并发/闭包(Block Objects)
@interface NSObject (GCD)

@property (nonatomic,strong) NSString *stringProperty;//用于独立闭包获取类的全局变量时使用

+(void)dispatchAsyncOnGlobal:(dispatch_block_t)block;

#pragma mark-某个方法在某一段时间后在某线程上执行
void dispatch_afterByAnyQueue(double delayInSeconds,dispatch_queue_t queue/*全局队列:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)*/,dispatch_block_t block /*^(void){NSLog(@"Output GCD !");}*/);

@end
