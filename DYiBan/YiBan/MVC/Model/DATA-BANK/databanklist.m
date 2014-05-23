//
//  databanklist.m
//  DYiBan
//
//  Created by tom zeng on 13-8-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "databanklist.h"

@implementation databanklist
@synthesize title,count,type;

- (void)dealloc
{
    RELEASE(title);
    [super dealloc];
}
@end
