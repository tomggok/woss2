//
//  UIPanGestureRecognizer+init.m
//  DragonFramework
//
//  Created by zhangchao on 13-4-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIPanGestureRecognizer+init.h"
#import <objc/runtime.h>

@implementation UIPanGestureRecognizer (init)

@dynamic _p_Origin;

- (id)initWithTarget:(id)target action:(SEL)action delegateView:(UIView *)delegateView cancelsTouchesInView:(BOOL)cancelsTouchesInView/*是否可以在委托视图里检测到松开*/ maximumNumberOfTouches:(int)maximumNumberOfTouches minimumNumberOfTouches:(int)minimumNumberOfTouches/*最多最少几根手指在委托视图内才能触发*/
{
    if (self=[self initWithTarget:target action:action]) {
        self.cancelsTouchesInView = cancelsTouchesInView;//YES
        self.delegate = target;
        self.maximumNumberOfTouches=maximumNumberOfTouches;
        self.minimumNumberOfTouches=minimumNumberOfTouches;
        [delegateView addGestureRecognizer:self];
    }
    return self;
}

static char _c_origin;
-(CGPoint)_p_Origin{
  return [objc_getAssociatedObject(self, &_c_origin) CGPointValue];
}

-(void)set_p_Origin:(CGPoint)Origin
{
    objc_setAssociatedObject(self, &_c_origin, [NSValue valueWithCGPoint:Origin], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
