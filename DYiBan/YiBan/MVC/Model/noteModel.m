//
//  noteModel.m
//  DYiBan
//
//  Created by zhangchao on 13-10-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "noteModel.h"

@implementation noteModel

@synthesize address,title,create_time,favorite,lat,lng,nid,update_time,user_id,taglist,type,cellH,id,to_uid,state,userinfo,shareid,str_CalendarContent,file_list,content,share_time,share_user_list,user_info,file_type;

- (void)dealloc
{
    RELEASE(address);
    RELEASE(title);
    RELEASE(create_time);
    RELEASE(favorite);
    RELEASE(lat);
    RELEASE(lng);
    RELEASE(nid);
    RELEASE(update_time);
    RELEASE(user_id);
    RELEASE(taglist);
    RELEASE(to_uid);
    RELEASE(state);
    RELEASE(userinfo);
    RELEASE(shareid);
    RELEASE(str_CalendarContent);
    RELEASE(file_list);
    RELEASE(content);
    RELEASE(share_time);
    RELEASE(share_user_list);
    RELEASE(user_info);
    RELEASE(file_type);

    [super dealloc];
}


@end
