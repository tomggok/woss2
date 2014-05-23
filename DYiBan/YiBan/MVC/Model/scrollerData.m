//
//  scrollerData.m
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "scrollerData.h"

@implementation scrollerData
@synthesize id,name;

- (void)dealloc {
    RELEASE(name);
    [super dealloc];
}

@end
