//
//  user_birthday.m
//  DYiBan
//
//  Created by zhangchao on 13-9-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "user_birthday.h"

@implementation user_birthday

@synthesize days,name,nick,orderid,userid,username,avatar,birtyday;

- (void)dealloc
{
    RELEASE(days);
    RELEASE(name);
    RELEASE(nick);
    RELEASE(orderid);
    RELEASE(userid);
    RELEASE(username);
    RELEASE(avatar);
    RELEASE(birtyday);

    [super dealloc];
}

@end
