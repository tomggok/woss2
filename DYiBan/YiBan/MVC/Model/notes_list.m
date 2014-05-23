//
//  notes_list.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-11-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "notes_list.h"

@implementation notes_list
@synthesize totals;
@synthesize havenext;
@synthesize result;

-(void)dealloc{
    RELEASE(totals);
    RELEASE(havenext);
    RELEASE(result);
    
    
    [super dealloc];
}
@end
