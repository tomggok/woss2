//
//  good_num_info.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-10.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "good_num_info.h"

@implementation good_num_info
@synthesize name;
@synthesize time;
@synthesize userid;

-(void)dealloc{
    RELEASE(userid);
    RELEASE(time);
    RELEASE(name);
    
    [super dealloc];
}

@end
