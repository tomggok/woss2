//
//  NSObject+KVO.h
//  MagicFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO)

@property (nonatomic,retain) NSMutableArray *_array_observers;//保存观察我的对象的信息(每个信息是个dic,键为keyPath,值为观察我的对象的指针)
@property (nonatomic,retain) NSMutableArray *_array_targets;//保存被我观察对象的信息(每个信息是个dic,键为keyPath,值为被我观察的对象指针),

@property (nonatomic,assign) NSObject *_observer/*观察我的对象*/, *_target/*被我观察者的对象*/;


-(void)addObserverObj:(id)observer /*toTargetObj:(id)target*/ forKeyPath:(NSString *)keyPath/*被观察的实例变量名*/ options:(NSKeyValueObservingOptions)options/*观察方式,一般为NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld*/ context:(void *)context/*附加属性,一般为[Target class],被观察对象的class*/;

-(void)removeObserverObj:(id)observer/*观察者*/ /*fromTarget:(id)fromTarget被观察者*/ forKeyPath:(NSString *)forKeyPath/*被观察的实例变量名*/;

- (void) observeValueForKeyPath:(NSString *)keyPath
					   ofObject:(id)object
						 change:(NSDictionary *)change
						context:(void *)context;

-(void)dealloc_observer;

@end
