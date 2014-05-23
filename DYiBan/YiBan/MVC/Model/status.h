//
//  status.h
//  Magic
//
//  Created by tom zeng on 12-11-10.
//
//

#import <Foundation/Foundation.h>
//#import "Jastor.h"
#import "user.h"
#import "target.h"
#import "tags.h"
#import "msg_count.h"

//每个用户的属性
@interface status : MagicJSONReflection

@property(nonatomic,assign)int id;
//动态类型 1 发易班 2 修改头像 3 修改签名 4 上传相册 5 成为好友 6 分享 7 加班级 8 辅导员通知 9 发帖子 10发博文 11上传近照 -1:只显示年月
@property(nonatomic,assign)int type;//-1:月份cell  -2:生日提醒cell  0:status cell
@property(nonatomic,assign)int userid;// 用户ID
@property(nonatomic,retain)NSString *username;// 动态产生昵称+真名字符串
@property(nonatomic,retain)NSString* content;// 动态内容，如果没有返回为空，包含#tar_id#字符串，追加返回target数据结构
@property(nonatomic,retain)NSString*  user_content;//用户产生的内容字段，保留字段，一期先不使用
@property(nonatomic,retain)NSString*  pic_id;//图片ID
@property(nonatomic,retain)NSString*  pic_s;//动态缩略图

@property(nonatomic,retain)NSString *pic_b;//动态大缩略图
@property(nonatomic,retain)NSString* pic;//原图
@property(nonatomic,retain)NSString*  pic_num;// 图片数
@property(nonatomic,retain)NSString*  good_num;//赞数
@property(nonatomic,retain)NSString*  comment_num;//评论数

@property(nonatomic,retain)NSString *rss_num;//订阅数
@property(nonatomic,retain)NSString* from;//来源
@property(nonatomic,retain)NSString*  time;// 动态产生时间
@property(nonatomic,retain)NSString*  isrss;//当前用户是否订阅 1是0否
@property(nonatomic,retain)NSString*  isrec;//当前用户是否赞 1 是 0否

@property(nonatomic,retain)NSString *isnotice;//当前用户是否知道 1是0否
@property(nonatomic,retain)user  * user_info;//动态产生人数据结构
@property(nonatomic,retain)target*  target;//内容替换数据结构， 
@property(nonatomic,retain)NSString*  album_id;// 动态类型为4的时候 返回 相册id
@property(nonatomic,retain)NSString*  album_pics;// 动态类型为4的时候 返回 相册图片数
@property(nonatomic,retain)tags*  tags;// 标签数据结构，
@property(nonatomic,retain)msg_count*  msg_count;//消息数数据结构
@property(retain,nonatomic)NSString * repeat_count; //防止刷频数
@property(retain,nonatomic)NSString * isfollow; //是否是转发微博 1是0否  默认为 0
@property(retain,nonatomic)NSString * canfollow;// 是否能转发 1是0否  默认为 00
@property(retain,nonatomic)NSString * follow_num;// 转发的个数
@property(retain,nonatomic)status *status;
@property(nonatomic,retain)NSArray *pic_array;//多图
@property(nonatomic,retain)NSArray *comment_num_info;//评论
@property(nonatomic,retain)NSArray *good_num_info;//赞
@property(nonatomic,retain)NSString *address;
//+(Class)target_class;
//+(Class)tags_class;
@end
