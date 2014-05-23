//
//  eclass_notice.m
//  DYiBan
//
//  Created by zhangchao on 13-8-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "eclass_notice.h"

//班级公告
@implementation eclass_notice

@synthesize id,areaid,title,content,time,target;

- (void)dealloc
{
    RELEASE(self.id);
    RELEASE(areaid);
    RELEASE(title);
    RELEASE(content);
    RELEASE(time);
    RELEASE(target);
    [super dealloc];
}

@end
