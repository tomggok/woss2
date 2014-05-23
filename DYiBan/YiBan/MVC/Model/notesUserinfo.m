//
//  notesUserinfo.m
//  DYiBan
//
//  Created by Song on 13-10-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "notesUserinfo.h"

@implementation notesUserinfo
@synthesize id,name,nick,pic,sex,verify,kind,userkind,nature;

- (void)dealloc
{
    RELEASE(name);
    RELEASE(nick);
    RELEASE(pic);
    RELEASE(sex);
    RELEASE(verify);
    RELEASE(kind);
    RELEASE(userkind);
    RELEASE(nature);
    
    
    
    [super dealloc];
}

@end
