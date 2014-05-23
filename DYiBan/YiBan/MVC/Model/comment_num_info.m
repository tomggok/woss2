//
//  comment_num_info.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-10.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "comment_num_info.h"

@implementation comment_num_info
@synthesize dateline;
@synthesize pic;
@synthesize id;
@synthesize kind;
@synthesize name;
@synthesize target;
@synthesize tocontent;
@synthesize totid;
@synthesize touid;
@synthesize tousername;
@synthesize uid;
@synthesize comment;

-(void)dealloc{
    RELEASE(dateline);
    RELEASE(pic);
    RELEASE(kind);
    RELEASE(name);
    RELEASE(target);
    RELEASE(totid);
    RELEASE(touid);
    RELEASE(tousername);
    RELEASE(uid);
    RELEASE(comment);
    
    [super dealloc];
}

@end
