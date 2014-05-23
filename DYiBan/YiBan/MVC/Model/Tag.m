//
//  Tag.m
//  DYiBan
//
//  Created by zhangchao on 13-10-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Tag.h"

@implementation Tag

@synthesize nid,tag,tag_id;

- (void)dealloc
{
    RELEASE(nid);
    RELEASE(tag_id);
    RELEASE(tag);
        
    [super dealloc];
}

@end
