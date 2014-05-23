//
//  user.h
//  Magic
//
//  Created by 周 哲 on 12-11-1.
//
//
#define PRIVATESTRING   @"未填写"
#import <Foundation/Foundation.h>
//#import "Jastor.h"
#import "album.h"
@interface user : MagicJSONReflection
@property (retain, nonatomic) NSString *id;
@property (retain, nonatomic) NSString *userid;
@property (retain, nonatomic) NSString *name;/*昵称*/
@property (nonatomic,copy) NSString *username/*用户名*/,*email;//邮箱
@property (retain, nonatomic) NSString *truename;
@property (retain, nonatomic) NSString *desc;
@property (retain, nonatomic) NSString *pic;//头像小图
@property (retain, nonatomic) NSString *pic_b;// 用户头像原图
@property (retain, nonatomic) NSString *pic_s;// 用户头像上传时压缩好的大小接口
@property (retain, nonatomic) NSString *verify;// 认证类型 0 未认证 1 实名认证 2 学校认证
@property (retain, nonatomic) NSString *usertype;//0 普通用户、学生 1辅导员 2 老师 3领导
@property (retain, nonatomic) NSString *fullname;
@property (retain, nonatomic) NSString *sex;//性别
@property (retain, nonatomic) NSArray *album;
@property (retain, nonatomic) NSString *yiban_num;
@property (retain, nonatomic) NSString *pic_num;
@property (retain, nonatomic) NSString *visit_num;
@property (retain, nonatomic) NSArray *eclasses;
@property (retain, nonatomic) NSString *use_classid;
@property (retain, nonatomic) NSString *use_classname;
@property (retain, nonatomic) NSString *new_comment;
@property (retain, nonatomic) NSString *new_at;
@property (retain, nonatomic) NSString *new_message;//新私信数
@property (retain, nonatomic) NSString *new_request;// 新好友邀请
@property (retain, nonatomic) NSString *sync_tag;//绑定的tag（已绑定过的）
@property (retain, nonatomic) NSString *auth_sina;
@property (retain, nonatomic) NSString *auth_tencent;
@property (retain, nonatomic) NSString *auth_renren;
@property (retain, nonatomic) NSString *auth_douban;
@property (retain, nonatomic) NSString *yiban_sync;//可分享其它网站标示，1新浪2腾讯4人人8豆瓣，返回总和的一个值(可以同步的网站)
@property (retain, nonatomic) NSString *push_key;
@property (retain, nonatomic) NSString *album_num;// 相册数
@property (retain, nonatomic) NSString *friend_num;//好友数
@property (retain, nonatomic) NSString *info_rate;//信息完善率
@property (retain, nonatomic) NSString *rsstag;//push 订阅标记1 push 0关闭
@property (retain, nonatomic) NSString *canfriend;//是否能加好友0只能加关注1能加好友
@property (retain, nonatomic) NSString *isfriend;//是否是好友 0否 1是 2我发过好友请求 3对方发过好友请求
@property (retain, nonatomic) NSString *isfollow;//是否已关注 0否 1是
@property (retain, nonatomic) NSString *is_moderator;//是否是班级管理员 1 是 0 否
@property (retain, nonatomic) NSString *user_schoolname;//学校名称
@property (retain, nonatomic) NSString *phone;//手机
@property (retain, nonatomic) NSString *phone_private;//手机权限 0：保密，1：公开，2：好友同学校友，3：好友
@property (retain, nonatomic) NSString *birthday; //生日
@property (retain, nonatomic) NSString *birthday_private;//生日星座权限0：保密，1：公开，2：显星座，3：显月日
@property (retain, nonatomic) NSString *hometown;//家乡
@property (retain, nonatomic) NSString *sx;//星座
@property (retain, nonatomic) NSString *hometown_private;//家乡权限0：保密，1：公开，2：好友同学校友，3：好友
@property (retain, nonatomic) NSString *visit_private;//个人主页权限 0 所以人可见 1仅好友可见 2 仅自己可见 3 好友 ，同学 ，校友可见
@property (retain, nonatomic) NSString *community_sort;// 社区排行
@property (retain, nonatomic) NSString *community_up;//社区排行升降
@property (retain, nonatomic) NSString *total_sort;//综合实力
@property (retain, nonatomic) NSString *total_up;// 综合实力升降
@property (retain, nonatomic) NSString *register_time;// 注册时间
@property (retain, nonatomic) NSString *college;//学院名称
@property (retain, nonatomic) NSString *user_schoolid;// 学校id
@property (retain, nonatomic) NSString *points;//贡献值
@property (retain, nonatomic) NSString *joinyear;//入学年份
@property (retain, nonatomic) NSString *disturb_time;//免打扰时间
@property (retain, nonatomic) NSString *push_tag;//推送的tag标志
@property (retain, nonatomic) NSString *background_tag;//个人主页背景本地的名字
@property (retain, nonatomic) NSString *background_pic;//个人主页背景图片
@property (retain, nonatomic) NSString *distance;//当前登陆用户与此用户的距离 （只有当天签到的用户才返回此数据）
@property (retain, nonatomic) NSString *relation_desc; //关系描述，如： 与你有5个共同好友
@property (retain, nonatomic) NSString *lat; //当天签到维度
@property (retain, nonatomic) NSString *lng;// 当天签到经度
@property (retain, nonatomic) NSString *is_vip;//用户是否是VIP 用户
@property (retain, nonatomic) NSString *user_college; //学院名称
@property (retain, nonatomic) NSString *userInfoPirvateString;
@property (retain, nonatomic) NSString *avatarTopCount;//顶的次数
@property (retain, nonatomic) NSString *avatarTreadCount;//踩的次数
@property (assign, nonatomic) int i_playTop_stampTag;//是否播放 踩顶动画  0:NO 1:YES
@property (retain, nonatomic) NSString *isFriend;//和当前登录用户是否是  好友
@property (retain, nonatomic) NSString *isSameClass;//和当前登录用户是否是 同班同学
@property (retain, nonatomic) NSString *isSameSchool;//和当前登录用户是否是  校友


//+(Class)album_class;
//+(Class)eclasses_class;
@end