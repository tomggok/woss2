//
//  EmployInfo.m
//  DYiBan
//
//  Created by zhangchao on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "EmployInfo.h"

@implementation EmployInfo

@synthesize author,click_num,collect_flag,collect_num,id,pubtime,title,content;

- (void)dealloc
{
    RELEASE(author);
    RELEASE(click_num);
    RELEASE(collect_num);
    RELEASE(collect_flag);
    RELEASE(self.id);
    RELEASE(pubtime);
    RELEASE(title);
    RELEASE(content);

    [super dealloc];
}
@end
