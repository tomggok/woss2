//
//  Dragon_ViewSignal.h
//  DragonFramework
//
//  Created by NewM on 13-3-5.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+DragonProperty.h"


#define AS_SIGNAL(_name)   AS_STATIC_PROPERTY(_name)
#define DEF_SIGNAL(_name)  DEF_STATIC_PROPERTY3(_name, @"signal", [self description])


@interface DragonViewSignal : NSObject
{
    BOOL        _dead;     //是否废弃
    BOOL        _reach;    //是否触达顶级
    NSUInteger  _jump;          //转发次数
    id          _source;        //发送来源
    id          _target;        //转发目标
    NSString    *_name;         //signal的名字
    NSObject    *_object;       //附带参数
    NSObject    *_returnValue;  //返回值，默认为空
    
    BOOL        _isAutoTarget;//手动写了一个target
    
    NSTimeInterval  _initTimeStamp;
    NSTimeInterval  _sendTimeStamp;
    NSTimeInterval  _reachTimeStamp;
    

}

@property (nonatomic, assign)BOOL           isAutoTarget;//手动写了一个target

@property (nonatomic, assign)BOOL           dead;           //是否废弃
@property (nonatomic, assign)BOOL           reach;          //是否触达顶级
@property (nonatomic, assign)NSUInteger     jump;           //转发次数
@property (nonatomic, assign)id             source;         //发送来源
@property (nonatomic, assign)id             target;         //转发目标
@property (nonatomic, retain)NSString       *name;          //signal的名字
@property (nonatomic, /*retain*/ assign/*避免例如DragonUITableView.m的cellForRowAtIndexPath函数的dict变量在RELEASEDICTARRAYOBJ()宏后未释放干净*/)NSObject       *object;        //附带参数
@property (nonatomic, /*retain*/ assign/*同上*/)NSObject       *returnValue;   //返回值，默认为空

@property (nonatomic, assign)NSTimeInterval     initTimeStamp;
@property (nonatomic, assign)NSTimeInterval     sendTimeStamp;
@property (nonatomic, assign)NSTimeInterval     reachTimeStamp;

@property (nonatomic, readonly)NSTimeInterval   timeElapsed;        //整体耗时
@property (nonatomic, readonly)NSTimeInterval   timeCostPending;    //等待耗时
@property (nonatomic, readonly)NSTimeInterval   timeCostExcution;   //处理耗时

AS_STATIC_PROPERTY(YES_VALUE);
AS_STATIC_PROPERTY(NO_VALUE);

- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;
- (BOOL)isSentFrom:(id)source;

- (BOOL)send;
- (BOOL)forward:(id)target;

//只有某些特殊的signal需要加传真假值，如webview
- (BOOL)boolValue;
- (void)returnYES;
- (void)returnNO;
@end
