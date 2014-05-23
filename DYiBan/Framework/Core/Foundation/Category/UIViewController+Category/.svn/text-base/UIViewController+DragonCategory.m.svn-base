//
//  UIViewController+DragonCategory.m
//  DYiBan
//
//  Created by zhangchao on 13-10-17.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIViewController+DragonCategory.h"
#import <objc/runtime.h>

@implementation UIViewController (DragonCategory)

@dynamic tbv,b_isAutoRefreshTbvInViewWillAppear;

DEF_SIGNAL(AutoRefreshTbvInViewWillAppear) //在 viewWillAppear时自动刷新tbv数据源

static char c_tbv;
-(UITableView *)tbv
{
    return objc_getAssociatedObject(self, &c_tbv);
    
}
-(void)setTbv:(UITableView *)p_tbv
{
    objc_setAssociatedObject(self, &c_tbv, p_tbv, OBJC_ASSOCIATION_ASSIGN);
}

static char c_b_isAutoRefreshTbvInViewWillAppear;
-(BOOL)b_isAutoRefreshTbvInViewWillAppear
{
    return [objc_getAssociatedObject(self, &c_b_isAutoRefreshTbvInViewWillAppear) boolValue];
    
}
-(void)setB_isAutoRefreshTbvInViewWillAppear:(BOOL)b
{
    objc_setAssociatedObject(self, &c_b_isAutoRefreshTbvInViewWillAppear, [NSNumber numberWithBool:b], OBJC_ASSOCIATION_ASSIGN);
}

@end
