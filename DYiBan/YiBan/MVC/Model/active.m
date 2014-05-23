//
//  active.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "active.h"

@implementation active
@synthesize address;
@synthesize begin_time;
@synthesize co_organizer;
@synthesize end_time;
@synthesize id;
@synthesize introduction;
@synthesize organizer;
@synthesize title;
@synthesize topics;
@synthesize type;
@synthesize enabled;

-(void)dealloc{
    RELEASE(address);
    RELEASE(begin_time);
    RELEASE(co_organizer);
    RELEASE(end_time);
    RELEASE(introduction);
    RELEASE(organizer);
    RELEASE(title);
    RELEASE(topics);
    RELEASE(type);
    RELEASE(enabled);
    
    [super dealloc];
}


@end
