//
//  source_schoollist.m
//  DYiBan
//
//  Created by Song on 13-8-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "source_schoollist.h"

@implementation source_schoollist
@synthesize schoolId,schoolName;

- (void)dealloc {
    
    RELEASE(schoolName);
    RELEASE(schoolId);
    [super dealloc];
}
@end
