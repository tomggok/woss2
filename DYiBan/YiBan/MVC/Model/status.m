//
//  status.m
//  Magic
//
//  Created by tom zeng on 12-11-10.
//
//

#import "status.h"

@implementation status
@synthesize id;
@synthesize type;//0:status cell  -1:月份cell  -2:生日提醒cell  -3:动态列表无数据提示的cell
@synthesize userid;
@synthesize user_info;
@synthesize user_content;
@synthesize username;
@synthesize comment_num;
@synthesize content;
@synthesize pic;
@synthesize pic_b;
@synthesize pic_id;
@synthesize pic_num;
@synthesize pic_s;
@synthesize good_num;
@synthesize rss_num;
@synthesize from;
@synthesize tags;
@synthesize target;
@synthesize time;
@synthesize isnotice;
@synthesize isrec;
@synthesize isrss;
@synthesize msg_count;
@synthesize album_id;
@synthesize album_pics;
@synthesize repeat_count,isfollow,canfollow,follow_num,status;
@synthesize pic_array;
@synthesize comment_num_info;
@synthesize good_num_info;
@synthesize address;
//+(Class)target_class{
//    return NSClassFromString(@"target");
//}
//+(Class)tags_class{
//    return NSClassFromString(@"tags");
//}
- (void)dealloc
{
    RELEASE(username);// 动态产生昵称+真名字符串
    RELEASE(content);// 动态内容，如果没有返回为空，包含#tar_id#字符串，追加返回target数据结构
    RELEASE(user_content);//用户产生的内容字段，保留字段，一期先不使用
    RELEASE(pic_id);//图片ID
    RELEASE(pic_s);//动态缩略图
    RELEASE(pic_b);//动态大缩略图
    RELEASE(pic);//原图
    RELEASE(pic_num);// 图片数
    RELEASE(good_num);//赞数
    RELEASE(comment_num);//评论数
    
    RELEASE(rss_num);//订阅数
    RELEASE(from);//来源
    RELEASE(time);// 动态产生时间
    RELEASE(isrss);//当前用户是否订阅 1是0否
    RELEASE(isrec);//当前用户是否赞 1 是 0否
    
    RELEASE(isnotice);//当前用户是否知道 1是0否
    RELEASE(user_info);//动态产生人数据结构
    RELEASE(target);//内容替换数据结构，
    RELEASE(album_id);// 动态类型为4的时候 返回 相册id
    RELEASE(album_pics);// 动态类型为4的时候 返回 相册图片数
    RELEASE(tags);// 标签数据结构，
    RELEASE(msg_count);//消息数数据结构
    RELEASE(repeat_count); //防止刷频数
    
    RELEASE(isfollow);
    RELEASE(canfollow);
    RELEASE(follow_num);
    
    RELEASE(status);
    RELEASE(pic_array);
    RELEASE(comment_num_info);
    RELEASE(good_num_info);
    RELEASE(address);
    [super dealloc];
}
@end
