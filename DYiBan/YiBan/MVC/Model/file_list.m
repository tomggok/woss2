//
//  file_list.m
//  DYiBan
//
//  Created by zhangchao on 13-11-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "file_list.h"

@implementation file_list

@synthesize author,createdTime,file_type,location,nm,readerGroupId,size,type,state,duration,fid;

- (void)dealloc
{
    RELEASE(author);
    RELEASE(createdTime);
    RELEASE(file_type);
    RELEASE(location);
    RELEASE(nm);
    RELEASE(readerGroupId);
    RELEASE(size);
//    RELEASE(img);
    RELEASE(duration);
//    RELEASE(str_filePath);
    RELEASE(fid);
    [super dealloc];
}

@end
