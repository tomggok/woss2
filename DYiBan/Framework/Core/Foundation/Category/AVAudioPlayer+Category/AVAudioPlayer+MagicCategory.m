//
//  AVAudioPlayer+MagicCategory.m
//  DYiBan
//
//  Created by zhangchao on 13-11-14.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "AVAudioPlayer+MagicCategory.h"
#import <objc/runtime.h>

@implementation AVAudioPlayer (MagicCategory)

@dynamic ob,b_isPlaying;

static char c_ob;
-(id)ob
{
    return objc_getAssociatedObject(self, &c_ob);
    
}

-(void)setOb:(id)__ob
{
    objc_setAssociatedObject(self, &c_ob, __ob, OBJC_ASSOCIATION_ASSIGN);
}

static char c_b_isPlaying;
-(BOOL)b_isPlaying
{
    return [objc_getAssociatedObject(self, &c_b_isPlaying) boolValue];
    
}

-(void)setB_isPlaying:(BOOL)b
{
    objc_setAssociatedObject(self, &c_b_isPlaying, [NSNumber numberWithBool:b], OBJC_ASSOCIATION_ASSIGN);
}

@end
