//
//  NSObject+KVO.m
//  DragonFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>

@implementation NSObject (KVO)

@dynamic _array_observers,_observer,_target,_array_targets;

#pragma mark- KVO相关

#pragma mark-给被观察者对象的某个实例变量属性注册一个观察者
-(void)addObserverObj:(NSObject *)observer /*toTargetObj:(id)target*/ forKeyPath:(NSString *)keyPath/*被观察的实例变量名*/ options:(NSKeyValueObservingOptions)options/*观察方式,一般为NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld*/ context:(void *)context/*附加属性,一般为[Target class],被观察对象的class,已区分其它被观察者*/
{
    [self/*被观察者*/ addObserver:observer forKeyPath:keyPath options:options context:context];

//    {//保存观察者我的对象的信息
//        if (!self._array_observers) {//观察我的对象数组
//            //        self._array_observers=[[NSMutableArray alloc]initWithCapacity:10];
//            self._array_observers=[NSMutableArray arrayWithCapacity:10];
//        }
//        
//        NSMutableDictionary *muD=[NSMutableDictionary dictionaryWithObject:observer forKey:keyPath];
//
//        if (![ self._array_observers containsObject:muD]) {
//            [ self._array_observers addObject:muD];
//        }
//    }

//    {//
//        if (!observer._array_targets) {//观察我的对象观察的其他对象
//            //        self._array_observers=[[NSMutableArray alloc]initWithCapacity:10];
//            observer._array_targets=[NSMutableArray arrayWithCapacity:10];
//        }
//        //    observer._target=self;
//        NSMutableDictionary *muD=[NSMutableDictionary dictionaryWithObject:self forKey:keyPath];
//        if (![observer._array_targets containsObject:muD]) {
//            [observer._array_targets addObject:muD];
//        }
//    }


//    for (NSDictionary *d in observer._array_observers) {//观察我的人观察的KeyPath==我观察别人的的KeyPath时,观察我的人不观察我了,直接也观察我观察的人
//        UIViewController *o=[d objectForKey:keyPath];//观察我的对象
//        for (NSDictionary *dd in o._array_targets) {
//            if ([[[dd allKeys]objectAtIndex:0] isEqualToString:keyPath])
//                //                                [dd setValue:vc forKey:@"b_isAutoRefreshTbvInViewWillAppear"];
//                [o._array_targets removeObject:dd];
//            [observer removeObserver:o forKeyPath:keyPath];
//            
//            [self addObserverObj:o forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:[o class]];
//            dd=[NSDictionary dictionaryWithObjectsAndKeys:self,keyPath, nil];
//            [o._array_targets addObject:dd];
//        }
//    }
}

#pragma mark-被观察对象移除某个观察者对其某个实例变量的观察
-(void)removeObserverObj:(id)observer/*观察者*/ /*fromTarget:(id)fromTarget被观察者*/ forKeyPath:(NSString *)forKeyPath/*被观察的实例变量名*/
{
    [self removeObserver:observer forKeyPath:forKeyPath];
}

    //观察者要实现此响应方法
- (void) observeValueForKeyPath:(NSString *)keyPath
					   ofObject:(id)object/*被观察者*/
						 change:(NSDictionary *)change
						context:(void *)context/*观察者class*/{
//  Class class=(Class)context;
//  NSString *className=[NSString stringWithCString:object_getClassName(class) encoding:NSUTF8StringEncoding];
    
//    if ([className isEqualToString:[NSString stringWithCString:object_getClassName([UITableView class]) encoding:NSUTF8StringEncoding]]) {
//        self._b_canDragBack=[[change objectForKey:@"new"] boolValue];
//        
//    }else{//将不能处理的 key 转发给 super 的 observeValueForKeyPath 来处理
//        [super observeValueForKeyPath:keyPath
//                             ofObject:object
//                               change:change
//                              context:context];
//    }
    
}

static char _c_array_observers;
-(NSMutableArray *)_array_observers
{
    NSMutableArray *arr=objc_getAssociatedObject(self, &_c_array_observers);
//    if (!arr) {
//        self._array_targets=[[NSMutableArray alloc]initWithCapacity:10];
//        return self._array_targets;
//    }

    DLogInfo(@"%d",[arr retainCount]);

    return arr;

}

-(void)set_array_observers:(NSMutableArray *)_array_observers
{
    DLogInfo(@"%d",[_array_observers retainCount]);
    objc_setAssociatedObject(self, &_c_array_observers, _array_observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    DLogInfo(@"%d",[_array_observers retainCount]);
}

static char _c_array_targets;
-(NSMutableArray *)_array_targets
{
    NSMutableArray *arr=objc_getAssociatedObject(self, &_c_array_targets);
        //    if (!arr) {
        //        self._array_targets=[[NSMutableArray alloc]initWithCapacity:10];
        //        return self._array_targets;
        //    }

    DLogInfo(@"%d",[arr retainCount]);

    return arr;

}

-(void)set_array_targets:(NSMutableArray *)_array_targets
{
    DLogInfo(@"%d",[_array_targets retainCount]);
    objc_setAssociatedObject(self, &_c_array_targets, _array_targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    DLogInfo(@"%d",[_array_targets retainCount]);
}

static char _c_observer;
-(NSObject *)_observer
{
    id t=objc_getAssociatedObject(self, &_c_observer);
    DLogInfo(@"%d",[t retainCount]);

    return t;

}

-(void)set_observer:(NSObject *)t
{
    DLogInfo(@"%d",[t retainCount]);
    objc_setAssociatedObject(self, &_c_observer, t, OBJC_ASSOCIATION_ASSIGN);
    DLogInfo(@"%d",[t retainCount]);
}

static char _c_target;
-(NSObject *)_target
{
    id t=objc_getAssociatedObject(self, &_c_target);
    DLogInfo(@"%d",[t retainCount]);

    return t;

}

-(void)set_target:(NSObject *)t
{
    DLogInfo(@"%d",[t retainCount]);
    objc_setAssociatedObject(self, &_c_target, t, OBJC_ASSOCIATION_ASSIGN);
    DLogInfo(@"%d",[t retainCount]);
}

    //当自己作为观察者时释放被自己观察的对象&&释放观察自己的对象
-(void)dealloc_observer
{
    if (self._array_targets) {//释放被自己观察的对象
        
        for (NSMutableDictionary *muD in self._array_targets) {
            NSArray *arr_keys=[muD allKeys];
            NSArray *arr_values=[muD allValues];
            [[arr_values objectAtIndex:0] removeObserver:self forKeyPath:[arr_keys objectAtIndex:0]];
//            DLogInfo(@"%d",[muD retainCount]);
//            [muD release];
        }

        [self._array_targets removeAllObjects];
//        [self._array_targets release];
        self._array_targets=Nil;

    }

    if (self._array_observers) {//释放观察自己的对象
        for (NSMutableDictionary *muD in self._array_observers) {
            NSArray *arr_keys=[muD allKeys];
            NSArray *arr_values=[muD allValues];
            [self removeObserver:[arr_values objectAtIndex:0] forKeyPath:[arr_keys objectAtIndex:0]];
            RELEASE([arr_values objectAtIndex:0]);
            //            DLogInfo(@"%d",[muD retainCount]);
            //            [muD release];
        }
        [self._array_observers removeAllObjects];
        RELEASE(self._array_observers);
        
        RELEASE(self);
//        self._array_observers=Nil;
    }
//    [((NSObject *)self._target) removeObserver:self forKeyPath:@"text"];

}

@end
