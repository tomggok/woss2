//
//  tag_list_info.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "tag_list_info.h"

@implementation tag_list_info
@synthesize count;
@synthesize tag;
@synthesize tag_id;
@synthesize sys,nid;

-(void)dealloc{
    RELEASE(count);
    RELEASE(tag_id);
    RELEASE(tag);
    RELEASE(sys);
    RELEASE(nid);

    [super dealloc];
}

@end
