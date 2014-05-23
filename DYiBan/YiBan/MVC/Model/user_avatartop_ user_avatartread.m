//
//  user_avatartop_ user_avatartread.m
//  DYiBan
//
//  Created by zhangchao on 13-9-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "user_avatartop_ user_avatartread.h"

@implementation user_avatartop__user_avatartread

@synthesize content,foot,message,name,news,type,foot2,content4c;

- (void)dealloc
{
    RELEASE(content);
    RELEASE(foot);
    RELEASE(message);
    RELEASE(name);
    RELEASE(news);
    RELEASE(type);
    RELEASE(foot2);
    RELEASE(content4c);

    [super dealloc];
}

@end
