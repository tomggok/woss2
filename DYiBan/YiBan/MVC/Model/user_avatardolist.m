//
//  user_avatardolist.m
//  DYiBan
//
//  Created by zhangchao on 13-9-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "user_avatardolist.h"

@implementation user_avatardolist
@synthesize topCount,pics,username,treadCount,userid,lastTopTime,lastTreadTime;

- (void)dealloc
{
    RELEASE(topCount);
    RELEASE(pics);
    RELEASE(username);
    RELEASE(treadCount);
    RELEASE(userid);
    RELEASE(lastTreadTime);
    RELEASE(lastTopTime);

    [super dealloc];
}
@end
