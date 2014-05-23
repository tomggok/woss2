//
//  eclass_topiclist.m
//  DYiBan
//
//  Created by zhangchao on 13-9-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "eclass_topiclist.h"

@implementation eclass_topiclist

@synthesize areaid,classify,click,content,delid,display,egg,face,flower,id,ip,kind,parameter,pubtime,realname,reply,replytime,replyuser,smart,title,userid,username,usernick;

- (void)dealloc
{
    RELEASE(areaid);
    RELEASE(classify);
    RELEASE(click);
    RELEASE(content);
    RELEASE(delid);
    RELEASE(display);
    RELEASE(egg);
    RELEASE(face);
    RELEASE(flower);
    RELEASE(self.id);
    RELEASE(ip);
    RELEASE(kind);
    RELEASE(parameter);
    RELEASE(pubtime);
    RELEASE(realname);
    RELEASE(reply);
    RELEASE(replytime);
    RELEASE(replyuser);
    RELEASE(smart);
    RELEASE(title);
    RELEASE(userid);
    RELEASE(username);
    RELEASE(usernick);

    [super dealloc];
}

@end
