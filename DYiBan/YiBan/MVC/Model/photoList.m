//
//  photoList.m
//  DYiBan
//
//  Created by Song on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "photoList.h"

@implementation photoList
@synthesize havenext,album_list,id,name,pic,pic_num,access;
- (void)dealloc
{
    RELEASE(havenext);
    RELEASE(album_list);
    RELEASE(name);
    RELEASE(pic_num);
    RELEASE(pic);
    RELEASE(access);
    [super dealloc];
}
@end
