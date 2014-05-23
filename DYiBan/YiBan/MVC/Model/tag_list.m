//
//  tag_list.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "tag_list.h"

@implementation tag_list
@synthesize allpages;
@synthesize havenext;
@synthesize result;

-(void)dealloc{
    RELEASE(allpages);
    RELEASE(havenext);
    RELEASE(result);
    
    
    [super dealloc];
}

@end
