//
//  user.m
//  Magic
//
//  Created by 周 哲 on 12-11-1.
//
//

#import "user.h"
//#import "Static.h"
@implementation user
//static user *singleUser = nil;
@synthesize userid;
@synthesize name,username,email;
@synthesize truename;
@synthesize desc;
@synthesize pic;
@synthesize pic_b,pic_s;
@synthesize verify;
@synthesize usertype;
@synthesize fullname;
@synthesize album;
@synthesize yiban_num;
@synthesize pic_num;
@synthesize visit_num;
@synthesize eclasses;
@synthesize use_classid;
@synthesize use_classname;
@synthesize new_comment;
@synthesize new_at;
@synthesize new_message;
@synthesize new_request;
@synthesize sync_tag;
@synthesize auth_sina;
@synthesize auth_tencent;
@synthesize auth_renren;
@synthesize auth_douban;
@synthesize yiban_sync;
@synthesize push_key;
@synthesize album_num;
@synthesize friend_num;
@synthesize info_rate,rsstag,canfriend,isfollow,isfriend,user_schoolname,phone,phone_private,birthday,birthday_private,hometown,sx,hometown_private,visit_private,community_sort,community_up,total_sort,total_up,register_time,college,user_schoolid,points,joinyear,sex,disturb_time,push_tag,background_pic,background_tag,userInfoPirvateString,is_moderator,distance,relation_desc,lat,lng,is_vip,id,user_college,avatarTopCount,avatarTreadCount,isFriend,isSameClass,isSameSchool;

- (void)dealloc
{
    /*
    RELEASE(user_college);
    RELEASE(is_moderator);
    RELEASE(userid);
    RELEASE(name);
    RELEASE(username);
    RELEASE(truename);
    RELEASE(desc);
    RELEASE(pic);
    RELEASE(pic_b);// 用户头像原图
    RELEASE(verify);// 认证类型 0 未认证 1 实名认证 2 学校认证
    RELEASE(usertype);//0 普通用户、学生 1辅导员 2 老师 3领导
    RELEASE(fullname);
    RELEASE(sex);//性别
    RELEASE(album);
    RELEASE(yiban_num);
    RELEASE(pic_num);
    RELEASE(visit_num);
    RELEASE(eclasses);
    RELEASE(use_classid);
    RELEASE(use_classname);
    RELEASE(new_comment);
    RELEASE(new_at);
    RELEASE(new_message);//新私信数
    RELEASE(new_request);// 新好友邀请
    RELEASE(sync_tag);//绑定的tag（已绑定过的）
    RELEASE(auth_sina);
    RELEASE(auth_tencent);
    RELEASE(auth_renren);
    RELEASE(auth_douban);
    RELEASE(yiban_sync);//可分享其它网站标示，1新浪2腾讯4人人8豆瓣，返回总和的一个值(可以同步的网站)
    RELEASE(push_key);
    RELEASE(album_num);// 相册数
    RELEASE(friend_num);//好友数
    RELEASE(info_rate);//信息完善率
    RELEASE(rsstag);//push 订阅标记1 push 0关闭
    RELEASE(canfriend);//是否能加好友0只能加关注1能加好友
    RELEASE(isfriend);//是否是好友0否1是2我发过好友请求3对方发过好友请求
    RELEASE(isfollow);//是否关注0否1是
    RELEASE(is_moderator);//是否是班级管理员 1 是 0 否
    RELEASE(user_schoolname);//学校名称
    RELEASE(phone);//手机
    RELEASE(phone_private);//手机权限 0：保密，1：公开，2：好友同学校友，3：好友
    RELEASE(birthday); //生日
    RELEASE(birthday_private);//生日星座权限0：保密，1：公开，2：显星座，3：显月日
    RELEASE(hometown);//家乡
    RELEASE(sx);//星座
    RELEASE(hometown_private);//家乡权限0：保密，1：公开，2：好友同学校友，3：好友
    RELEASE(visit_private);//个人主页权限 0 所以人可见 1仅好友可见 2 仅自己可见 3 好友 ，同学 ，校友可见
    RELEASE(community_sort);// 社区排行
    RELEASE(community_up);//社区排行升降
    RELEASE(total_sort);//综合实力
    RELEASE(total_up);// 综合实力升降
    RELEASE(register_time);// 注册时间
    RELEASE(college);//学院名称
    RELEASE(user_schoolid);// 学校id
    RELEASE(points);//贡献值
    RELEASE(joinyear);//入学年份
    RELEASE(disturb_time);//免打扰时间
    RELEASE(push_tag);//推送的tag标志
    RELEASE(background_tag);//个人主页背景本地的名字
    RELEASE(background_pic);//个人主页背景图片
    RELEASE(distance);
    RELEASE(relation_desc);
    RELEASE(lat);
    RELEASE(lng);
    RELEASE(userInfoPirvateString);*/
    
    [user_college release];
    [is_vip release];
//    [userid release];
    [name release];
    [username release];
    [truename release];
    [desc release];
    [pic release];
    [pic_b release];// 用户头像原图
    [pic_s release];
    [verify release];// 认证类型 0 未认证 1 实名认证 2 学校认证
    [usertype release];//0 普通用户、学生 1辅导员 2 老师 3领导
    [fullname release];
    [sex release];//性别
    [album release];
    [yiban_num release];
    [pic_num release];
    [visit_num release];
    [eclasses release];
    [use_classid release];
    [use_classname release];
    [new_comment release];
    [new_at release];
    [new_message release];//新私信数
    [new_request release];// 新好友邀请
    [sync_tag release];//绑定的tag（已绑定过的）
    [auth_sina release];
    [auth_tencent release];
    [auth_renren release];
    [auth_douban release];
    [yiban_sync release];//可分享其它网站标示，1新浪2腾讯4人人8豆瓣，返回总和的一个值(可以同步的网站)
    [push_key release];
    [album_num release];// 相册数
    [friend_num release];//好友数
    [info_rate release];//信息完善率
    [rsstag release];//push 订阅标记1 push 0关闭
    [canfriend release];//是否能加好友0只能加关注1能加好友
    [isfriend release];//是否是好友0否1是2我发过好友请求3对方发过好友请求
    [isfollow release];//是否关注0否1是
    [is_moderator release];//是否是班级管理员 1 是 0 否
    [user_schoolname release];//学校名称
    [phone release];//手机
    [phone_private release];//手机权限 0：保密，1：公开，2：好友同学校友，3：好友
    [birthday release]; //生日
    [birthday_private release];//生日星座权限0：保密，1：公开，2：显星座，3：显月日
    [hometown release];//家乡
    [sx release];//星座
    [hometown_private release];//家乡权限0：保密，1：公开，2：好友同学校友，3：好友
    [visit_private release];//个人主页权限 0 所以人可见 1仅好友可见 2 仅自己可见 3 好友 ，同学 ，校友可见
    [community_sort release];// 社区排行
    [community_up release];//社区排行升降
    [total_sort release];//综合实力
    [total_up release];// 综合实力升降
    [register_time release];// 注册时间
    [college release];//学院名称
    [user_schoolid release];// 学校id
    [points release];//贡献值
    [joinyear release];//入学年份
    [disturb_time release];//免打扰时间
    [push_tag release];//推送的tag标志
    [background_tag release];//个人主页背景本地的名字
    [background_pic release];//个人主页背景图片
    [distance release];
    [relation_desc release];
    [lat release];
    [lng release];
    [userInfoPirvateString release];
    [avatarTreadCount release];
    [avatarTopCount release];

    [isSameSchool release];
    [isSameClass release];
    [isFriend release];
    
    [super dealloc];
}
- (NSString *)visit_num{
    if (!visit_num || visit_num.length == 0) {
        self.visit_num = @"0";
    }
    return visit_num;
}

- (NSString *)info_rate{
    if (!info_rate || info_rate.length == 0) {
        self.info_rate = @"0%";
    }
    return info_rate;
}

- (NSString *)album_num{
    if (!album_num || album_num.length == 0) {
        self.album_num = @"0";
    }
    return album_num;
}
- (NSString *)friend_num{
    
    if (!friend_num || friend_num.length == 0) {
        self.friend_num = @"0";
    }
    return friend_num;
}

- (NSString *)hometown{
    if (!hometown || [hometown stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 || [hometown isEqualToString:@"请选择-请选择-请选择"]) {
        self.hometown = PRIVATESTRING;
    }
    return hometown;
}

- (NSString *)phone{
    if (!phone || [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        self.phone = PRIVATESTRING;
    }
    return phone;
}

- (NSString *)birthday{
    
    if (!birthday || ([birthday stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 || [birthday isEqualToString:@"0000-00-00"])) {
        self.birthday = PRIVATESTRING;

    }
    return birthday;
}

- (NSString *)user_schoolname{
    if (!user_schoolname && [user_schoolname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        self.user_schoolname = PRIVATESTRING;
    }
    return user_schoolname;
}

- (NSString *)joinyear{
    if (!joinyear && [joinyear stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        self.joinyear = PRIVATESTRING;
    }
    return joinyear;
}

- (NSString *)userInfoPirvateString{
    return PRIVATESTRING;
}

- (void)setPic_s:(NSString *)_pic_s
{
    if (pic_s == _pic_s) {
        return;
    }
    [pic_s release];
    if (_pic_s && _pic_s.length == 0)
    {
        _pic_s = @"";
    }
    pic_s = [_pic_s retain];
}

- (NSString *)pic_s
{
    if (!pic_s)
    {
        return @"";
    }
    return pic_s;
}

//+(Class)album_class{
//    return NSClassFromString(@"album");
//}
//+(Class)eclasses_class{
//    return NSClassFromString(@"eclasses");
//}
@end
