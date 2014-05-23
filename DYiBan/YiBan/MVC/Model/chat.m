//
//  chat.m
//  Magic
//
//  Created by 周 哲 on 12-11-6.
//
//

#import "chat.h"

@implementation chat
@synthesize id;
@synthesize user_info;
@synthesize content;
@synthesize time;
@synthesize status_id;
@synthesize status_type;
@synthesize view;
@synthesize ext,str_time,photoImage,indexRow,SucessSend,target;


- (void)dealloc
{
    
    RELEASE(content);//消息内容
//    RELEASE(time);//消息产生时间
    RELEASE(status_id);//当TYPE为2时返回，辅导员通知动态id
    RELEASE(status_type);// 当TYPE为2时返回，辅导员通知动态id类型
    RELEASE(user_info);//发消息人数据结构
    RELEASE(photoImage);//发消息人数据结构
    if (str_time) {
        RELEASE(str_time);//
    }

    RELEASE(target);
    [ext release];
    

    [super dealloc];
}
@end
