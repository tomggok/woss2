//
//  NSTimer+Creat.h
//  MagicFramework
//
//  Created by zhangchao on 13-4-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Create)

+(NSTimer *)CreatAnTimeToCallAnFunctionBySelector:(SEL)Selector AfterTimeInterval:(NSTimeInterval)ti target :(id)target userInfo:(id)userInfo repeats:(BOOL)repeats isWantToHave:(BOOL)isWantToHave/*target是否想拥有返回值*/;

@end
