//
//  NSArray+MagicCategory.m
//  MagicFramework
//
//  Created by NewM on 13-5-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "NSArray+MagicCategory.h"

@implementation NSArray (MagicCategory)

@end

// No-ops for non-retaining objects.    array加入元素的时候，不要retainCount＋＋，array移出元素的时候不要retainCount－－
static const void *	__TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void			__TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) { }

#pragma mark -

@implementation NSMutableArray(MagicCategory)

//非retain型的NSMutableArray
+ (NSMutableArray *)nonRetainingArray	// copy from Three20
{
	CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;//CFArray的回调函数结构体
	callbacks.retain = __TTRetainNoOp;
	callbacks.release = __TTReleaseNoOp;
	return (NSMutableArray *)CFArrayCreateMutable( nil, 0, &callbacks );//生成自己定义的非retain型的NSMutableArray对象，函数的返回值是CFMutableArrayRef类型的，故进行强制类型转换
}
@end
