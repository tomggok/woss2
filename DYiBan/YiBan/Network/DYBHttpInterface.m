//
//  DYBHttpInterface.m
//  DYiBan
//
//  Created by NewM on 13-8-1.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBHttpInterface.h"

@implementation DYBHttpInterface
/**
 登陆data
 **/
+ (NSMutableDictionary *)login:(NSString *)name password:(NSString *)pwd
{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc]init]);
    [dict setValue:name forKey:@"username"];
    [dict setValue:pwd forKey:@"password"];
    [dict setValue:kSecurityLogin forKey:INTERFACEDOACTION];
    return dict;
}

/**
 动态
 **/
+ (NSMutableDictionary *) setstatus_list:(NSString *)since_id max_id:(NSString *)max_id last_id:(NSString *)last_id num:(NSString *)num page:(NSString *)page type:(NSString *)type userid:(NSString *)userid
{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:since_id forKey:@"since_id"];
    [dict setValue:max_id forKey:@"max_id"];
    [dict setValue:last_id forKey:@"last_id"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:kStatusList forKey:INTERFACEDOACTION];
    return dict;
}

/**
 辅导员班级列表
 **/
+ (NSMutableDictionary *)eclass_list :(NSString *)last_id num:(NSString *)num page:(NSString *)page eclassid:(NSString *)eclassid{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:last_id forKey:@"last_id"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:eclassid forKey:@"eclassid"];
    [dict setValue:@"eclass_managelist" forKey:INTERFACEDOACTION];
    
    return dict;
    
}

/**
 评论提醒列表
 **/
+ (NSMutableDictionary *)review_list:(int)page pageNum:(int)num :(int)lastid{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    NSString * num_ = [NSString stringWithFormat:@"%d",num];
    NSString * page_ = [NSString stringWithFormat:@"%d",page];
    NSString * lastid_ = [NSString stringWithFormat:@"%d",lastid];
    [dict setValue:num_ forKey:@"num"];
    [dict setValue:page_ forKey:@"page"];
    [dict setValue:lastid_ forKey:@"last_id"];
    [dict setValue:@"message_comment" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 AT我  评论 at 提醒列表
 **/
+ (NSMutableDictionary *)aboutmeMessage:(int)page pageNum:(int)num{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    NSString * num_ = [NSString stringWithFormat:@"%d",num];
    NSString * page_ = [NSString stringWithFormat:@"%d",page];
    [dict setValue:num_ forKey:@"num"];
    [dict setValue:page_ forKey:@"page"];
    [dict setValue:@"message_at" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 评论 remind 提醒列表
  **/
+ (NSMutableDictionary *)message_remind:(int)page pageNum:(int)num last_id:(NSString *)last_id{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    NSString * num_ = [NSString stringWithFormat:@"%d",num];
    NSString * page_ = [NSString stringWithFormat:@"%d",page];
    [dict setValue:num_ forKey:@"num"];
    [dict setValue:page_ forKey:@"page"];
    [dict setValue:last_id forKey:@"last_id"];

    [dict setValue:@"message_remind" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 私信列表
 **/
+ (NSMutableDictionary *)message_contact_sixin:(int)page pageNum:(int)num{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    NSString * num_ = [NSString stringWithFormat:@"%d",num];
    NSString * page_ = [NSString stringWithFormat:@"%d",page];
    [dict setValue:num_ forKey:@"num"];
    [dict setValue:page_ forKey:@"page"];
    [dict setValue:@"message_contact" forKey:INTERFACEDOACTION];
    
    return dict;
}


/**
 系统消息
 **/
+ (NSMutableDictionary *)message_friendreqlist_yaoqing:(int)page pageNum:(int)num{
    NSString * num_ = [NSString stringWithFormat:@"%d",num];
    NSString * page_ = [NSString stringWithFormat:@"%d",page];
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:num_ forKey:@"num"];
    [dict setValue:page_ forKey:@"page"];
    [dict setValue:@"message_friendreqlist" forKey:INTERFACEDOACTION];
    
    return dict;
}
/**
 我想说
 **/
+ (NSMutableDictionary *)status_add_content:(NSString *)content add_notice:(NSString *)add_notice  sync_tag:(int)sync_tag refuse:(NSString *)refuse at_eclass:(NSString *)at_eclass address:(NSString *)address{
    NSString * sync_tag_ = [NSString stringWithFormat:@"%d",sync_tag];
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:add_notice forKey:@"add_notice"];
    [dict setValue:refuse forKey:@"refuse"];
    [dict setValue:sync_tag_ forKey:@"sync_tag"];
    [dict setValue:content forKey:@"content"];
    [dict setValue:at_eclass forKey:@"at_eclass"];
    [dict setValue:address forKey:@"address"];
    [dict setValue:@"status_add" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 所有好友列表
 **/
+ (NSMutableDictionary *)user_friendlist_userid:(NSString *)userid num:(NSString *)num  page:(int)page type:(NSString *)type{
    NSString * _page = [NSString stringWithFormat:@"%d",page];
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:_page forKey:@"page"];
    [dict setValue:@"user_friendlist" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 最近联系人列表
 **/
+ (NSMutableDictionary *)user_recentcontact:(NSString *)userid{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:@"user_recentcontacts" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 用户关键字检索接口
 **/
+ (NSMutableDictionary *)search_user:(NSString *)searchContent num:(NSString *)num  page:(int)page{
    
    NSString * _page = [NSString stringWithFormat:@"%d",page];
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:searchContent forKey:@"content"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:_page forKey:@"page"];
    [dict setValue:@"search_user" forKey:INTERFACEDOACTION];
    
    return dict;
}


/**
 用户的私信|系统消息 内容详情
 **/
+ (NSMutableDictionary *)message_chat_sixin:(int)page pageNum:(int)num  type:(NSString *)type userid:(NSString *)userid maxid:(NSString *)maxid last_id:(NSString *)lastid{
    
    NSString * num_ = [NSString stringWithFormat:@"%d",num];
    NSString * page_ = [NSString stringWithFormat:@"%d",page];
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:num_ forKey:@"num"];
    [dict setValue:page_ forKey:@"page"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:userid forKey:@"userid"];
    
    if ([type isEqualToString:@"0"]) {
        
        if (![maxid isEqualToString:@"0"]) {
            [dict setValue:maxid forKey:@"max_id"];
        }
        if (![lastid isEqualToString:@"0"]) {
            [dict setValue:lastid forKey:@"last_id"];
        }
    }
    
    
    [dict setValue:@"message_chat" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 发送消息
 **/
+ (NSMutableDictionary *)sendmessage:(NSString *)message userid:(NSString *)userid{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:message forKey:@"content"];
    [dict setValue:@"message_send" forKey:INTERFACEDOACTION];
    
    return dict;
}


/**
 发送消息 新增发送图片，位置，语音
 **/
+ (NSMutableDictionary *)sendmessage2:(NSString *)userid content:(NSString *)content type:(NSString *)type lng:(NSString *)lon lat:(NSString *)lat address:(NSString *)address speech_length:(NSString *)speech_length {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:content forKey:@"content"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:lon forKey:@"lon"];
    [dict setValue:lat forKey:@"lat"];
    [dict setValue:address forKey:@"address"];
    [dict setValue:speech_length forKey:@"speech_length"];
    
    [dict setValue:@"message_send" forKey:INTERFACEDOACTION];
    return dict;
}

/**
 用户可能认识的人列表
 **/
+ (NSMutableDictionary *)user_recommendlist_userid:(NSString *)num{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:num forKey:@"num"];
    [dict setValue:@"user_recommendlist" forKey:INTERFACEDOACTION];
    
    return dict;
}

#pragma mark-共同好友列表
+ (NSMutableDictionary *)user_mutualfriend:(NSString *)userid{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:@"user_mutualfriend" forKey:INTERFACEDOACTION];
    
    return dict;
}


/**
 添加好友或关注
 **/
+ (NSMutableDictionary *)message_reqfriend:(NSString *)userid{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userid forKey:@"ids"];
    [dict setValue:@"message_reqfriend" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *同意被加为好友
 */
+ (NSMutableDictionary *)message_applyfriend:(NSString *)userid op:(NSString *)op{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:2]);
    [dict setValue:userid forKey:@"ids"];
    [dict setValue:op forKey:@"op"];
    [dict setValue:@"message_applyfriend" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 易班班级列
 **/
+ (NSMutableDictionary *)user_myeclass_list:(NSString *)userid{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:@"eclass_list" forKey:INTERFACEDOACTION];
    
    return dict;
}

#pragma mark-辅导员管理的班级列表接口eclass_managelist
+ (NSMutableDictionary *)eclass_managelist:(NSString *)userid{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:@"eclass_managelist" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 易班主页详情
 **/
+ (NSMutableDictionary *)eclass_detail:(NSString *)class_id num:(int)num page:(int)page {
    
    NSString * _num = [NSString stringWithFormat:@"%d",num];
    NSString * _page = [NSString stringWithFormat:@"%d",page];
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:class_id forKey:@"id"];
    [dict setValue:_num forKey:@"num"];
    [dict setValue:_page forKey:@"page"];
    [dict setValue:@"eclass_detail" forKey:INTERFACEDOACTION];

    return dict;
}

/**
 *意见反馈
 */
+ (NSMutableDictionary *)sendInfomation:(NSString *)content{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:content forKey:@"content"];
    [dict setValue:@"help_addsuggestion" forKey:INTERFACEDOACTION];
    
    return dict;
}
/**
 动态详情
 */
+ (NSMutableDictionary *)status_detail_id :(int)_id  type:(int)type since_id:(NSString *)since_id max_id:(NSString *)max_id num:(NSString *)num page:(NSString *)page message_id:(NSString *)message_id{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:[NSString stringWithFormat:@"%d",_id] forKey:@"id"];
    [dict setValue:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    [dict setValue:since_id forKey:@"since_id"];
    [dict setValue:max_id forKey:@"max_id"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:message_id forKey:@"message_id"];
    [dict setValue:@"status_detail" forKey:INTERFACEDOACTION];
    
    return dict;
}
/**
 班级列表
 */
+ (NSMutableDictionary *)status_eclasslist:(NSString *)_id num:(NSString *)num page:(NSString *)page eclassid:(NSString *)eclassid{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:_id forKey:@"last_id"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:eclassid forKey:@"eclassid"];
    [dict setValue:@"status_eclasslist" forKey:INTERFACEDOACTION];
    
    return dict;
    
}
/**
 赞
 */

+ (NSMutableDictionary *)status_feedaction_id:(NSString *)_id action:(NSString *)action type:(NSString *)type{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:action forKey:@"action"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:@"status_feedaction" forKey:INTERFACEDOACTION];
    
    return dict;
    
}


/**
 *相册列表
 */
+ (NSMutableDictionary *)albumList:(NSString *)userId num:(NSInteger)num page:(NSInteger)page{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userId forKey:@"userid"];
    [dict setValue:[NSString stringWithFormat:@"%d",num] forKey:@"num"];
    [dict setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [dict setValue:@"album_list"  forKey:INTERFACEDOACTION];
    
    return dict;
}
/**
 *相册图片列表
 */
+ (NSMutableDictionary *)albumList:(NSString *)userId albumId:(NSString *)albumId num:(NSInteger)num page:(NSInteger)page{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userId forKey:@"userid"];
    [dict setValue:albumId forKey:@"id"];
    [dict setValue:[NSString stringWithFormat:@"%d",num] forKey:@"num"];
    [dict setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [dict setValue:@"album_piclist" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 动态删除
 */

+ (NSMutableDictionary *)status_del_id:(NSString *)_id  type:(NSString *)type{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:kStatusDel forKey:INTERFACEDOACTION];
    
    return dict;
    
}

/**
 新华社新闻首页
 **/
+ (NSMutableDictionary *)xinhunews_index:(NSString *)num{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:num forKey:@"num"];
    [dict setValue:@"news_index" forKey:INTERFACEDOACTION];
    
    return dict;
    
}

/**
 新华社新闻列表
 **/
+ (NSMutableDictionary *)xinhuanews_list:(NSString *)last_id num:(NSString *)num page:(NSString *)page category_id:(NSString *)category_id{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:last_id forKey:@"last_id"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:category_id forKey:@"category_id"];
    [dict setValue:@"news_list" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 新华社新闻详情
 **/
+ (NSMutableDictionary *)xinhuanews_detail:(NSString *)id category_id:(NSString *)category_id{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:id forKey:@"id"];
    [dict setValue:category_id forKey:@"category_id"];
    [dict setValue:@"news_detail" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 评论动态
 */

+ (NSMutableDictionary *)status_addcomment_id:(NSString *)_id  content:(NSString *)content{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:content forKey:@"content"];
    [dict setValue:@"status_addcomment" forKey:INTERFACEDOACTION];
    return dict;
    
}

/**
 解除sns绑定
 **/
+ (NSMutableDictionary *)user_delsync_m:(NSString *)tag{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:tag forKey:@"sync_tag"];
    [dict setValue:@"user_delsync" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 辅导员通知详情
 */
+ (NSMutableDictionary *)status_notice_id:(NSString *)_id  type:(NSString *)type page:(NSString *)page num:(NSString *)num{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:@"status_notice" forKey:INTERFACEDOACTION];
    
    return dict;
}
/**
 *订阅PUSH接口user_rss
 */
+ (NSMutableDictionary *)user_rss:(NSString *)userId op:(NSString *)op {
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:2]);
    [dict setValue:userId forKey:@"userid"];
    [dict setValue:op forKey:@"op"];
    [dict setValue:@"user_rss" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *个人主页最近访客user_perguest
 */
+ (NSMutableDictionary *)user_perguest:(NSString *)userId {
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:userId forKey:@"userid"];
    [dict setValue:@"user_perguest" forKey:INTERFACEDOACTION];
    
    return dict;
}

#pragma mark- 用户好友及同班同学生日提醒接口user_birthday
+ (NSMutableDictionary *)user_birthday:(NSString *)offset/*偏移(每页的最后一个数据的index)*/  limit:(NSString *)limit /*条数(每页获取几条)*/{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:offset forKey:@"offset"];
    [dict setValue:limit forKey:@"limit"];

    [dict setValue:@"user_birthday" forKey:INTERFACEDOACTION];
    
    return dict;
}


/**
 *用户详情接口user_detail
 */
+ (NSMutableDictionary *)user_detail:(NSString *)userId {
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:userId forKey:@"userid"];
    [dict setValue:kUserDetail forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark- 用户头像的顶踩记录列表user_avatardolist
+ (NSMutableDictionary *)user_avatardolist:(NSString *)userId type:(NSString *)type/*0:顶  1踩*/{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:userId forKey:@"userid"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:@"user_avatardolist" forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark- 用户头像的顶
+ (NSMutableDictionary *)user_avatartop:(NSString *)userId {
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:userId forKey:@"userid"];
    [dict setValue:@"user_avatartop" forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark- 用户头像的踩
+ (NSMutableDictionary *)user_avatartread:(NSString *)userId {
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:userId forKey:@"userid"];
    [dict setValue:@"user_avatartread" forKey:INTERFACEDOACTION];
    return dict;
}

/**
 *设置用户昵称接口user_setnick
 */
+ (NSMutableDictionary *)user_setnick:(NSString *)nick {
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:nick forKey:@"nick"];
    [dict setValue:@"user_setnick" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *学校学院列表
 */
+ (NSMutableDictionary *)school_collegelist:(NSString *)schoolId {
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:schoolId forKey:@"school_id"];
    [dict setValue:@"school_collegelist" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *设置用户基本资料  type:(0,生日1,家乡2,学院3,入学)
 */
+ (NSMutableDictionary *)user_setbase:(NSString *)value type:(NSInteger)type
{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    
    switch (type) {
        case 0:
            [dict setValue:value forKey:@"birthday"];
            break;
        case 1:
            [dict setValue:value forKey:@"hometown"];
            break;
        case 2:
            [dict setValue:value forKey:@"college"];
            break;
        case 3:
            [dict setValue:value forKey:@"joinyear"];
            break;
            
        default:
            break;
    }
    
    [dict setValue:@"user_setbase" forKey:INTERFACEDOACTION];
    return dict;
}
/**
 *设置个人隐私type(0,个人主页1,生日2,家乡3,手机)
 */
+ (NSMutableDictionary *)user_setdesc:(NSString *)value type:(NSInteger)type{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    
    switch (type) {
        case 0:
            [dict setValue:value forKey:@"visit_private"];
            break;
        case 1:
            [dict setValue:value forKey:@"birthday_private"];
            break;
        case 2:
            [dict setValue:value forKey:@"hometown_private"];
            break;
        case 3:
            [dict setValue:value forKey:@"phone_private"];
            break;
            
        default:
            break;
    }
    
    [dict setValue:@"user_setprivate" forKey:INTERFACEDOACTION];
    return dict;
}


/**
 用户签到记录接口
 **/
+ (NSMutableDictionary *)user_sign_list:(NSString *)userid type:(NSString *)type{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:@"sign_list" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 用户签到
 **/
+ (NSMutableDictionary *)user_sign_add:(NSString *)lng lat:(NSString *)lat address:(NSString *)address refulse:(NSString *)refulse{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:lng forKey:@"lng"];
    [dict setValue:lat forKey:@"lat"];
    [dict setValue:address forKey:@"address"];
    [dict setValue:refulse forKey:@"refuse"];
    [dict setValue:@"sign_add"  forKey:INTERFACEDOACTION];
    
    return dict;
}
/**
 用户当天是否签
 **/
+ (NSMutableDictionary *)user_sign_datelog{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"sign_datelog" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 用户地图签到记录
 **/
+ (NSMutableDictionary *)user_sign_map:(NSString *)userid type:(NSString *)type{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:@"sign_maps" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 用户上传定位坐标
 **/
+ (NSMutableDictionary *)user_sign_position:(NSString *)lng lat:(NSString *)lat address:(NSString *)address{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:lng forKey:@"lng"];
    [dict setValue:lat forKey:@"lat"];
    [dict setValue:address forKey:@"address"];
    [dict setValue:@"sign_position" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *获取验证码接口security_authcode  type: 验证码类型 0 修改密码 1 修改手机号
 */
+ (NSMutableDictionary *)security_authcode:(NSString *)phone type:(NSString *)type{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:2]);
    [dict setValue:phone forKey:@"phone"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:@"security_authcode" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *验证码修改用户手机接口security_resetphone
 */
+ (NSMutableDictionary *)security_resetphone:(NSString *)authcode phone:(NSString *)phone password:(NSString *)password{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:3]);
    [dict setValue:authcode forKey:@"authcode"];
    [dict setValue:phone forKey:@"phone_num"];
    [dict setValue:password forKey:@"password"];
    [dict setValue:@"security_resetphone" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *排行榜一级列表接口 charts_total
 */
+ (NSMutableDictionary *)charts_total:(NSString *)num{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:num forKey:@"num"];
    [dict setValue:@"charts_total" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *排行榜二级级列表接口 charts_total
 */
+ (NSMutableDictionary *)charts_list:(NSString *)chartstype num:(NSString *)num page:(NSString *)page{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:3]);
    [dict setValue:chartstype forKey:@"chartstype"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:@"charts_list" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *用户上传近照接口user_uploadavatar
 */
+ (NSMutableDictionary *)user_uploadavatar{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:@"1" forKey:@"index"];
    [dict setValue:@"user_uploadavatar" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *用户设置头像接口user_setavatar
 */
+ (NSMutableDictionary *)user_setavatar:(NSString *)picId{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:picId forKey:@"pic_id"];
    [dict setValue:@"user_setavatar" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *设置个人签名接口user_setdesc
 */
+ (NSMutableDictionary *)user_setdesc:(NSString *)text{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:text forKey:@"desc"];
    [dict setValue:@"user_setdesc" forKey:INTERFACEDOACTION];
    
    return dict;
}


/**
 *新用户注册
 */
+ (NSMutableDictionary *)security_reg:(NSString *)username nickname:(NSString *)nickname password:(NSString *)password sex:(NSString *)sex{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:3]);
    [dict setValue:nickname forKey:@"nickname"];
    [dict setValue:username forKey:@"username"];
    [dict setValue:password forKey:@"password"];
    [dict setValue:sex forKey:@"sex"];
    [dict setValue:kSecurityReg forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *校园认证接口security_cert
 
 schoolid : 学校id
 realname : 真实名字
 cert_key : 验证字段  sid 学号/工号,cid 身份证号,tid 准考证号,phone 手机号码,aid 录取通知书编号,bid 报名号
 cert_num : 学号/工号/高考号
 phone ： 电话号码
 ver_code : 认证码
 
 学号参数和验证码参数优先判断学号参数，如果学号参数没有才去用认证码参数
 */
+ (NSMutableDictionary *)security_cert:(NSString *)schoolId realName:(NSString *)realName certNum:(NSString *)certNum phone:(NSString *)phone cerCode:(NSString *)verCode certKey:(NSString *)certKey{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:6]);
    [dict setValue:schoolId forKey:@"schoolid"];
    [dict setValue:realName forKey:@"realname"];
    [dict setValue:certNum forKey:@"cert_num"];
    [dict setValue:phone forKey:@"phone"];
    [dict setValue:verCode forKey:@"ver_code"];
    [dict setValue:certKey forKey:@"cert_key"];
    [dict setValue:@"security_cert" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *学校班级列表 接口 school_list
 */
+ (NSMutableDictionary *)school_list:(NSString *)type {
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:type forKey:@"type"];
    [dict setValue:@"school_list" forKey:INTERFACEDOACTION];
    
    return dict;
}

#pragma mark-设置活跃班级
+ (NSMutableDictionary *)eclass_active:(NSString *)classID
{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:classID forKey:@"id"];
    [dict setValue:@"eclass_active" forKey:INTERFACEDOACTION];
    
    return dict;
}


/**
 *设置个人签名接口user_setdesc
 */
+ (NSMutableDictionary *)messageCount{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:@"user_setdesc" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *校验验证码接口security_verifyauthcode
 */
+ (NSMutableDictionary *)security_verifyauthcode:(NSString *)phone acuthcode:(NSString *)acthcode{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:2]);
    [dict setValue:phone forKey:@"phone"];
    [dict setValue:acthcode forKey:@"authcode"];
    [dict setValue:@"security_verifyauthcode" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *验证码重置密码接口security_resetpwd
 */
+ (NSMutableDictionary *)security_resetpwd:(NSString *)userid authcode:(NSString *)authcode password:(NSString *)password{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:3]);
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:authcode forKey:@"authcode"];
    [dict setValue:password forKey:@"password"];
    [dict setValue:@"security_resetpwd" forKey:INTERFACEDOACTION];
    
    return dict;
}
/**
 *用户注销登陆
 **/
+ (NSMutableDictionary *)user_security_logout{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:kSecurityLogout forKey:INTERFACEDOACTION];
    
    return dict;
}
/**
 *用户解除好友关系user_delfriend
 */
+ (NSMutableDictionary *)user_delfriend:(NSArray *)arrayID oneId:(NSString *)oneid{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    NSMutableString *ids = [[NSMutableString alloc] init];
    if (arrayID) {
        ids = [[NSMutableString alloc] init];
        for (int i = 0; i < [arrayID count]; i++) {
            if (i == ([arrayID count]-1)) {
                [ids stringByAppendingFormat:@"%@",[arrayID objectAtIndex:i]];
            }else{
                [ids stringByAppendingFormat:@"%@,",[arrayID objectAtIndex:i]];
            }
        }
    }else{
        ids = [[NSMutableString alloc] initWithString:oneid];
    }
    
    [dict setValue:ids forKey:@"ids"];
    [ids release];
    [dict setValue:@"user_delfriend" forKey:INTERFACEDOACTION];
    
    return dict;
}
/**
 *用户push设置接口 user_setpush
 */
+ (NSMutableDictionary *)user_setpush:(NSString *)pushTag isDisturb:(BOOL)isDisturb disturb_time:(NSString *)disturbTime{
    //    disturbTime = @"22-8";
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:3]);
    [dict setValue:pushTag forKey:@"push_tag"];
    [dict setValue:[NSString stringWithFormat:@"%d",isDisturb] forKey:@"is_disturb"];
    [dict setValue:disturbTime forKey:@"disturb_time"];
    [dict setValue:@"user_setpush" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *user_setbackground设置背景图片
 */
+ (NSMutableDictionary *)user_setbackground:(NSString *)index tag:(NSString *)tag{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:2]);
    [dict setValue:index forKey:@"index"];
    [dict setValue:tag forKey:@"tag"];
    [dict setValue:@"user_setbackground" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *用户自动登陆
 **/
+ (NSMutableDictionary *)user_security_autologin{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:kSecurityAutologin forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *二维码
 */
+ (NSMutableDictionary *)code_user_name:(NSString *)name password:(NSString *)password{
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:2]);
    [dict setValue:name forKey:@"_u"];
    [dict setValue:password forKey:@"_s"];
    [dict setValue:kSecurityLogin forKey:INTERFACEDOACTION];
    return dict;
}
/**
 *广告
 */
+ (NSMutableDictionary *)yiban_source_banner_pageid:(NSString *)pageid {
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:pageid forKey:@"pageid"];
    [dict setValue:@"source_banner" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *删除评论
 **/
+ (NSMutableDictionary *)messageDelComment:(NSString *)CommentIDs{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:CommentIDs forKey:@"ids"];
    [dict setValue:@"message_delcomment" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *删除@
 **/
+ (NSMutableDictionary *)messageDelAt:(NSString *)AtIDs{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:AtIDs forKey:@"ids"];
    [dict setValue:@"message_delat" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *删除私信
 **/
+ (NSMutableDictionary *)messageDelContact:(NSString *)userid ContactType:(NSString *)type;{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:2]);
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:@"message_delcontact" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 *删除通知
 **/
+ (NSMutableDictionary *)messageDelNotice:(NSString *)NoticeIDs MsgType:(NSString *)type{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:2]);
    [dict setValue:NoticeIDs forKey:@"ids"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:@"message_del" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 查询附近的人列表
 **/
+ (NSMutableDictionary *)searchNearby:(NSString *)num latitude:(NSString *)StrLat longitude:(NSString *)StrLng page:(NSString *)page userid:(NSString *)userid{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:num forKey:@"num"];
    [dict setValue:((!StrLat)?(@"0"):(StrLat)) forKey:@"lat"];
    [dict setValue:((!StrLng)?(@"0"):(StrLng)) forKey:@"lng"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:@"1" forKey:@"range"];//查询范围（默认1KM）
    [dict setValue:userid forKey:@"userid"];
    [dict setValue:@"search_nearby" forKey:INTERFACEDOACTION];
    
    return dict;
}


/**
 *班级公告
 **/
+ (NSMutableDictionary *)classNoticeList_id:(NSString *)_id{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:@"eclass_notice" forKey:INTERFACEDOACTION];
    
    return dict;
}

#pragma mark- 班级话题
+ (NSMutableDictionary *)eclass_topiclist:(NSString *)classID offset:(NSString *)offset limit:(NSString *)limit{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:classID forKey:@"classid"];
    [dict setValue:offset forKey:@"offset"];
    [dict setValue:limit forKey:@"limit"];

    [dict setValue:@"eclass_topiclist" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 转发
 **/
+ (NSMutableDictionary *)status_follow_id:(NSString *)_id content:(NSString *)_content com_tag:(NSString *)tag{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:3]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:_content forKey:@"content"];
    [dict setValue:tag forKey:@"com_tag"];
    [dict setValue:@"status_follow" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 动态评论列表接口
 **/
+ (NSMutableDictionary *)status_comments:(NSString *)_id type:(NSInteger)type since_id:(NSString *)since_id max_id:(NSString *)max_id num:(NSInteger)num page:(NSInteger)page{
    
    NSString * _type = [NSString stringWithFormat:@"%d",type];
    NSString * _num = [NSString stringWithFormat:@"%d",num];
    NSString * _page = [NSString stringWithFormat:@"%d",page];
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:6]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:_type forKey:@"type"];
    [dict setValue:since_id forKey:@"since_id"];
    [dict setValue:max_id forKey:@"max_id"];
    [dict setValue:_num forKey:@"num"];
    [dict setValue:_page forKey:@"page"];
    [dict setValue:@"status_comments" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 动态操作用户列表
 **/
+ (NSMutableDictionary *)status_actionlist:(NSString *)_id action:(NSInteger)action page:(NSInteger)page num:(NSInteger)num{
    
    NSString * _action = [NSString stringWithFormat:@"%d",action];
    NSString * _num = [NSString stringWithFormat:@"%d",num];
    NSString * _page = [NSString stringWithFormat:@"%d",page];
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:4]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:_action forKey:@"action"];
    [dict setValue:_num forKey:@"num"];
    [dict setValue:_page forKey:@"page"];
    [dict setValue:@"status_actionlist" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 动态转发列表接口
 **/
+ (NSMutableDictionary *)status_followlist:(NSString *)_id num:(NSInteger)num page:(NSInteger)page{
    
    NSString * _num = [NSString stringWithFormat:@"%d",num];
    NSString * _page = [NSString stringWithFormat:@"%d",page];
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:4]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:_num forKey:@"num"];
    [dict setValue:_page forKey:@"page"];
    [dict setValue:@"status_followlist" forKey:INTERFACEDOACTION];
    
    return dict;
}
/**
 就业列表
 **/
+ (NSMutableDictionary *)job_list_page:(NSInteger)_page num:(NSInteger)_num order:(NSString *)_order{
    
    NSString *page  = [NSString stringWithFormat:@"%d",_page];
    NSString *num   = [NSString stringWithFormat:@"%d",_num];
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:2]);
    [dict setValue:page forKey:@"page"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:_order forKey:@"order"];
    [dict setValue:@"Job_List" forKey:INTERFACEDOACTION];
    
    return dict;
    
}

/**
 就业详情
 **/
+ (NSMutableDictionary *)job_detail_id:(NSString *)_id{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:@"Job_Detail" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 就业信息添加收藏
 **/
+ (NSMutableDictionary *)job_addCollect_id:(NSString *)_id{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:@"Job_Addcollect" forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 删除收藏
 **/
+ (NSMutableDictionary *)job_decollect_id:(NSString *)_id{
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:@"Job_Delcollect" forKey:INTERFACEDOACTION];
    
    return dict;
    
}

/**
 就业收藏列表
 **/
+ (NSMutableDictionary *)job_collectLsit_page:(NSInteger)_page num:(NSInteger)_num order:(NSString *)_order{
    
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    NSString *num = [NSString stringWithFormat:@"%d",_num];
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:2]);
    [dict setValue:page forKey:@"page"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:_order forKey:@"order"];
    [dict setValue:@"Job_Collectlist"  forKey:INTERFACEDOACTION];
    
    return dict;
}

/**
 就业信息查询
 **/
+ (NSMutableDictionary *)job_search_page:(NSInteger)_page num:(NSInteger)_num keywork:(NSString *)_keywork type:(NSInteger)_type
{
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    NSString *num = [NSString stringWithFormat:@"%d",_num];
    NSString *type = [NSString stringWithFormat:@"%d",_type];
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:4]);
    [dict setValue:page forKey:@"page"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:_keywork forKey:@"keywork"];
    [dict setValue:@"Job_Search" forKey:INTERFACEDOACTION];
    
    return dict;
}

//版本检查
+ (NSMutableDictionary *)site_version {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"site_version" forKey:INTERFACEDOACTION];
    
    return dict;
}

//用户新信息接口
+ (NSMutableDictionary *)message_count {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"message_count" forKey:INTERFACEDOACTION];
    
    return dict;
    
}

/**
 *上传token
 **/
+ (NSMutableDictionary *)user_setting{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:kUserSetting forKey:INTERFACEDOACTION];
    
    return dict;
}

//获取app应用接口
+ (NSMutableDictionary *)site_yibanapp {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"site_yibanapp" forKey:INTERFACEDOACTION];
    
    return dict;
}

//数据库列表
+ (NSMutableDictionary *)dataBankList_navi_id:(NSString *)_id order:(NSString *)order asc:(NSString *)asc num:(NSString *)num page:(NSString *)page keyword :(NSString *)keyword{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:_id forKey:@"navigate"];
    [dict setValue:order forKey:@"order"];
    [dict setValue:asc forKey:@"asc"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:keyword forKey:@"keyword"];
    [dict setValue:@"navigate_list" forKey:INTERFACEDOACTION];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    return dict;
}

//学校接口
+ (NSMutableDictionary *)source_schoollist {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"source_schoollist" forKey:INTERFACEDOACTION];
    return dict;
}

//databank学校接口
+ (NSMutableDictionary *)source_schoolview {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"source_schoolview" forKey:INTERFACEDOACTION];
    return dict;
}

//资料库搜索接口
+ (NSMutableDictionary *)search_disk_keyword:(NSString *)keyword page:(int)page num:(int)num type:(NSString *)type{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:keyword forKey:@"keyword"];
    [dict setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [dict setValue:[NSString stringWithFormat:@"%d",num] forKey:@"num"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:@"" forKey:@"path"]; //无指定路劲
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"search_disk" forKey:INTERFACEDOACTION];
    return dict;
}

//资料库转存
+ (NSMutableDictionary *)document_changestore_from_id:(NSString *)from_id doc_from:(NSString *)doc_from doc_to:(NSString *)doc_to doc_type:(NSString *)type{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:from_id forKey:@"from_id"];
    [dict setValue:doc_from forKey:@"doc_from"];
    [dict setValue:doc_to forKey:@"doc_to"];
    [dict setValue:type forKey:@"doc_type"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"document_changestore" forKey:INTERFACEDOACTION];
    return dict;

}


// 资料或分类重命名接口 
+ (NSMutableDictionary *)document_rename_doc_id:(NSString *)doc_id name:(NSString *)name is_dir:(NSString *)is_dir indexDataBack:(NSString *)indexDataBack{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:doc_id forKey:@"old_name"];
    [dict setValue:is_dir forKey:@"dir"];
    [dict setValue:indexDataBack forKey:@"indexDataBack"];
    [dict setValue:name forKey:@"new_name"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"document_rename" forKey:INTERFACEDOACTION];
    return dict;

}


//新生通道
+ (NSMutableDictionary *)security_newchannel {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"security_newchannel" forKey:INTERFACEDOACTION];
    return dict;
    
}


//学校认证数据借口
+ (NSMutableDictionary *)school_cert:(NSString *)_id {
    
    NSMutableDictionary *dict = AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:1]);
    [dict setValue:_id forKey:@"id"];
    [dict setValue:@"school_cert" forKey:INTERFACEDOACTION];
    
    return dict;
}

//删除资料库文件
+ (NSMutableDictionary *)document_deldoc_doc:(NSString *)doc indexDataBack:(NSString *)indexDataBack{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:doc forKey:@"doc"];
    [dict setValue:indexDataBack forKey:@"indexDataBack"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"document_deldoc" forKey:INTERFACEDOACTION];
    return dict;

}

//资料库文件共享
+ (NSMutableDictionary *)document_share_doc:(NSString *)doc target:(NSString *)target{


    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:doc forKey:@"doc"];
    [dict setValue:target forKey:@"target"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"document_share" forKey:INTERFACEDOACTION];
    return dict;


}

//创建目录
+ (NSMutableDictionary *)document_createdir_name:(NSString *)name dir:(NSString *)dir{


    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:name forKey:@"name"];
    [dict setValue:dir forKey:@"dir"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"document_createdir" forKey:INTERFACEDOACTION];
    return dict;

}

//共享给我
+(NSMutableDictionary *)share_formelist_target:(NSString *)target order:(NSString *)order num:(NSString *)num page:(NSString *)page keyword:(NSString *)keyword asc:(NSString *)asc{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:target forKey:@"target"];
    [dict setValue:order forKey:@"order"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:keyword forKey:@"keyword"];
    [dict setValue:asc forKey:@"asc"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"share_formelist" forKey:INTERFACEDOACTION];
    return dict;

}

//我共享的资料列表接口
+ (NSMutableDictionary *)share_frommelist:(NSString *)order num:(NSString *)num page:(NSString *)page keyword:(NSString *)keyword asc:(NSString *)asc{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:order forKey:@"order"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:keyword forKey:@"keyword"];
    [dict setValue:asc forKey:@"asc"];
    [dict setValue:@"share_frommelist" forKey:INTERFACEDOACTION];
    return dict;

}

//公共资源
+ (NSMutableDictionary *)document_public_order:(NSString *)order num:(NSString *)num page:(NSString *)page  keyword:(NSString *)keyword asc:(NSString *)asc{


    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:page forKey:@"page"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:order forKey:@"order"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:keyword forKey:@"keyword"];
    [dict setValue:asc forKey:@"asc"];
    [dict setValue:@"document_public" forKey:INTERFACEDOACTION];
    return dict;

}

//资料库容量
+ (NSMutableDictionary *)document_userspace {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"document_userspace" forKey:INTERFACEDOACTION];
    return dict;
}

//资料库好友列表
+ (NSMutableDictionary *)source_friendlist_doc:(NSString *)doc{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:doc forKey:@"doc"];
    [dict setValue:@"source_friendlist" forKey:INTERFACEDOACTION];
    return dict;

}

//获取我的班级列表接口
+ (NSMutableDictionary *)source_classlist_doc:(NSString *)doc{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:doc forKey:@"doc"];
    [dict setValue:@"source_classlist" forKey:INTERFACEDOACTION];
    return dict;

}


//共享给学院
+ (NSMutableDictionary *)source_departmentlist{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"source_departmentlist" forKey:INTERFACEDOACTION];
    return dict;

}

//顶踩
+ (NSMutableDictionary *)document_estimate_id:(NSString *)_id type:(NSString *)type{


    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:_id forKey:@"oid"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:@"document_estimate" forKey:INTERFACEDOACTION];
    return dict;

}

//举报
+(NSMutableDictionary *)document_publicreport_oid:(NSString *)oid type:(NSString *)type reason:(NSString *)reason{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:oid forKey:@"oid"];
    [dict setValue:type forKey:@"type"];
    [dict setValue:reason forKey:@"reason"];
    [dict setValue:@"document_publicreport" forKey:INTERFACEDOACTION];
    return dict;

}

// 移动文件
+(NSMutableDictionary *)document_move_name:(NSString *)name old_dir:(NSString *)old_dir new_dir:(NSString *)new_dir{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"YES" forKey:@"isDataBank"];
//    [dict setValue:name forKey:@"name"];
    [dict setValue:old_dir forKey:@"old_doc"];
    [dict setValue:new_dir forKey:@"new_dir"];
    [dict setValue:@"document_move" forKey:INTERFACEDOACTION];
    return dict;


}

// 活动接口
+(NSMutableDictionary *)active_detail:(NSString *)active_id {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:active_id forKey:@"active_id"];
    [dict setValue:@"active_detail" forKey:INTERFACEDOACTION];
    return dict;
    
}



//发活动动态
+(NSMutableDictionary *)active_addfeed:(NSString *)content active_id:(NSString *)active_id{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:content forKey:@"content"];
    [dict setValue:active_id forKey:@"active_id"];
    [dict setValue:@"active_addfeed" forKey:INTERFACEDOACTION];
    return dict;
}

//活动动态列表接口
+(NSMutableDictionary *)active_feedlist:(NSString *)active_id last_id:(NSString *)last_id num:(NSString *)num page:(NSString *)page{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:active_id forKey:@"active_id"];
    [dict setValue:last_id forKey:@"last_id"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:@"active_feedlist" forKey:INTERFACEDOACTION];
    return dict;
}


// 活动操作
+(NSMutableDictionary *)active_action:(NSString *)active_id action:(NSString*)action op:(NSString*)op {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:active_id forKey:@"active_id"];
    [dict setValue:action forKey:@"action"];
    [dict setValue:op forKey:@"op"];
    [dict setValue:@"active_action" forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark-笔记列表|标签列表|收藏列表
+ (NSMutableDictionary *)notes_listByKeywords:(NSString *)keywords tagid:(NSString *)tagid/*标签ID*/ favorite:(NSString *)favorite/*1.搜索搜藏笔记 0 默认 全部*/ page:(NSString *)page num:(NSString *)num searchmonth:(NSString *)searchmonth delnum:(NSString *)delnum{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:keywords forKey:@"keywords"];
    [dict setValue:tagid forKey:@"tagid"];
    [dict setValue:favorite forKey:@"favorite"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:searchmonth forKey:@"searchmonth"];
    [dict setValue:delnum forKey:@"delnum"];

    [dict setValue:@"YES" forKey:@"isDataBank"];

    [dict setValue:@"notes_list" forKey:INTERFACEDOACTION];
    return dict;
}


#pragma mark-笔记详情
+ (NSMutableDictionary *)notes_detail:(NSString *)nid{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:nid forKey:@"nid"];
    
    [dict setValue:@"YES" forKey:@"isDataBank"];
    
    [dict setValue:@"notes_detail" forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark-文件删除
+ (NSMutableDictionary *)notes_delfile:(NSString *)fid{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:fid forKey:@"fid"];
    
    [dict setValue:@"YES" forKey:@"isDataBank"];
    
    [dict setValue:@"notes_delfile" forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark-文件上传
+ (NSMutableDictionary *)notes_uploadfile:(NSString *)nid duration:(NSString *)duration/*音频文件时长*/ {
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:nid forKey:@"nid"];
    [dict setValue:duration forKey:@"duration"];

    [dict setValue:@"YES" forKey:@"isDataBank"];
    
    [dict setValue:@"notes_uploadfile" forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark-添加笔记接口notes_addnote
+ (NSMutableDictionary *)notes_addnoteBylng:(NSString *)lng lat:(NSString *)lat address:(NSString *)address title:(NSString *)title content:(NSString *)content tagid:(NSString *)tagid/*标签id:"1,2,3,4"*/{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:lng forKey:@"lng"];
    [dict setValue:lat forKey:@"lat"];
    [dict setValue:address forKey:@"address"];
    [dict setValue:title forKey:@"title"];
    [dict setValue:content forKey:@"content"];
    [dict setValue:tagid forKey:@"tagid"];

    [dict setValue:@"YES" forKey:@"isDataBank"];
    
    [dict setValue:@"notes_addnote" forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark-修改笔记
+ (NSMutableDictionary *)notes_editnote:(NSString *)nid content:(NSString *)content tagid:(NSString *)tagid/*标签id:"1,2,3,4"*/{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:nid forKey:@"nid"];
    [dict setValue:content forKey:@"content"];
    [dict setValue:tagid forKey:@"tagid"];
    
    [dict setValue:@"YES" forKey:@"isDataBank"];
    
    [dict setValue:@"notes_editnote" forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark-收藏笔记
+ (NSMutableDictionary *)notes_addfavorite:(NSString *)nid {
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:nid forKey:@"nid"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    
    [dict setValue:@"notes_addfavorite" forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark-取消收藏笔记
+ (NSMutableDictionary *)notes_delfavorite:(NSString *)nid {
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:nid forKey:@"nid"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    
    [dict setValue:@"notes_delfavorite" forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark-删除笔记
+ (NSMutableDictionary *)notes_delnote:(NSString *)nid {
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:nid forKey:@"nid"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    
    [dict setValue:@"notes_delnote" forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark-笔记转存到资料库
+ (NSMutableDictionary *)notes_dumpnote:(NSString *)nid del:(NSString *)del {
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:nid forKey:@"nid"];
    [dict setValue:del forKey:@"del"];

    [dict setValue:@"YES" forKey:@"isDataBank"];
    
    [dict setValue:@"notes_dumpnote" forKey:INTERFACEDOACTION];
    return dict;
}

#pragma mark-共享笔记
+ (NSMutableDictionary *)notes_sharenote:(NSString *)nid to_userid:(NSString *)to_userid/*1,2,3,4*/ {
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:nid forKey:@"nid"];
    [dict setValue:to_userid forKey:@"to_userid"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    
    [dict setValue:@"notes_sharenote" forKey:INTERFACEDOACTION];
    return dict;
}

//标签列表
+ (NSMutableDictionary *)notes_taglist:(NSString *)keywords showcount:(NSString *)showcount page:(NSString *)page num:(NSString *)num{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:keywords forKey:@"keywords"];
    [dict setValue:showcount forKey:@"showcount"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    
    [dict setValue:@"notes_taglist" forKey:INTERFACEDOACTION];
    return dict;
}

// 笔记设置
+ (NSMutableDictionary *)notes_setting {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:kNoteSetting forKey:INTERFACEDOACTION];
    return dict;

}

// 共享给我的
+ (NSMutableDictionary *)notes_sharenotelist:(NSString *)page num:(NSString *)num keywords:(NSString *)keywords{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:page forKey:@"page"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:keywords forKey:@"keywords"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"notes_sharenotelist" forKey:INTERFACEDOACTION];
    return dict;
}

+ (NSMutableDictionary *)notes_mysharelist:(NSString *)page num:(NSString *)num keywords:(NSString *)keywords{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:page forKey:@"page"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:keywords forKey:@"keywords"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"notes_mysharelist" forKey:INTERFACEDOACTION];
    return dict;
}

// 保存共享笔记
+ (NSMutableDictionary *)notes_savesharenote:(NSString *)shareid nid:(NSString *)nid {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:shareid forKey:@"shareid"];
    [dict setValue:nid forKey:@"nid"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"notes_savesharenote" forKey:INTERFACEDOACTION];
    return dict;
    
}

// 取消共享
+ (NSMutableDictionary *)notes_delsharenote:(NSString *)shareid{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:shareid forKey:@"shareid"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"notes_delsharenote" forKey:INTERFACEDOACTION];
    return dict;
}

//删除标签
+ (NSMutableDictionary *)notes_deltag:(NSString *)tag_id{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:tag_id forKey:@"tag_id"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"notes_deltag" forKey:INTERFACEDOACTION];
    return dict;
}

//新建标签
+ (NSMutableDictionary *)notes_addtag:(NSString *)tag{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:tag forKey:@"tag"];
    [dict setValue:@"YES" forKey:@"isDataBank"];
    [dict setValue:@"notes_addtag" forKey:INTERFACEDOACTION];
    return dict;
}
//唯一标示符
+ (NSMutableDictionary *)security_authtag {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:@"security_authtag" forKey:INTERFACEDOACTION];
    return dict;
}
/*
 *notes_systemtime
 */

+ (NSMutableDictionary *)wosLogin_nickName:(NSString *)nickName passwd:(NSString *)passwd{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:nickName forKey:@"loginName"];
    [dict setValue:passwd forKey:@"passwd"];
    [dict setValue:@"me/login.do" forKey:INTERFACEDOACTION];
    return dict;

}


+ (NSMutableDictionary *)wosRegion_nickName:(NSString *)nickName passwd:(NSString *)passwd sex:(NSString *)sex{
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:nickName forKey:@"nickName"];
    [dict setValue:passwd forKey:@"passwd"];
    [dict setValue:sex  forKey:@"sex"];
    [dict setValue:@"me/add.do" forKey:INTERFACEDOACTION];
    return dict;

}

+ (NSMutableDictionary *)wosgoodFood_typeIndex:(NSString *)typeIndex  orderBy:(NSString *)orderBy  page:(NSString *)page count:(NSString *)count orderType:(NSString *)orderType{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:typeIndex forKey:@"typeIndex"];
    [dict setValue:orderBy forKey:@"orderBy"];
    [dict setValue:orderType forKey:@"orderType"];
    [dict setValue:page  forKey:@"page"];
    [dict setValue:count forKey:@"count"];
    [dict setValue:@"kitchen/list.do" forKey:INTERFACEDOACTION];
    return dict;

}
//kitchen/info.do

+ (NSMutableDictionary *)wosKitchenInfo_kitchenIndex :(NSString *)kitchenIndex   userIndex :(NSString *)userIndex   hotFoodCount :(NSString *)hotFoodCount  {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:kitchenIndex forKey:@"kitchenIndex"];
    [dict setValue:userIndex forKey:@"userIndex"];
    [dict setValue:hotFoodCount forKey:@"hotFoodCount"];
    [dict setValue:@"kitchen/info.do" forKey:INTERFACEDOACTION];
    return dict;
    
}




+ (NSMutableDictionary *)wosKitchenInfo_favorite_userIndex:(NSString *)userIndex  kitchenIndex  :(NSString *)kitchenIndex{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userIndex forKey:@"userIndex"];
    [dict setValue:kitchenIndex forKey:@"kitchenIndex"];
    [dict setValue:@"favorite/add.do" forKey:INTERFACEDOACTION];
    return dict;

}


+ (NSMutableDictionary *)wosKitchenInfo_commentkitchenlist:(NSString *)kitchenIndex starLevel:(NSString *)starLevel page :(NSString *)page count:(NSString *)count{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    
    if (![starLevel isEqualToString:@"0"]) {
        [dict setValue:starLevel forKey:@"starLevel"];
    }
    
    [dict setValue:kitchenIndex forKey:@"kitchenIndex"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:count forKey:@"count"];
    [dict setValue:@"comment/kitchen/list.do" forKey:INTERFACEDOACTION];
    return dict;

}
//food/list.do
+ (NSMutableDictionary *)wosKitchenInfo_foodlist:(NSString *)kitchenIndex{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:kitchenIndex  forKey:@"kitchenIndex"];

    [dict setValue:@"food/list.do" forKey:INTERFACEDOACTION];
    return dict;

}


+ (NSMutableDictionary *)wosKitchenInfo_commentadd:(NSString *)commentFor orderIndex :(NSString *)orderIndex userIndex :(NSString *)userIndex commentType :(NSString *)commentType starLevel :(NSString *)starLevel comment:(NSString *)comment{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    
    [dict setValue:commentFor  forKey:@"commentFor"];
    
//    if (![commentType isEqualToString:@"1"]) {
    
        [dict setValue:orderIndex  forKey:@"orderIndex"];
//    }
    
    [dict setValue:userIndex  forKey:@"userIndex"];
    [dict setValue:commentType  forKey:@"commentType"];
    [dict setValue:starLevel  forKey:@"starLevel"];
    [dict setValue:comment  forKey:@"comment"];
    
    [dict setValue:@"comment/kitchen/add.do" forKey:INTERFACEDOACTION];
    return dict;
    
}


+ (NSMutableDictionary *)wosKitchenInfo_searchKitch_keywords :(NSString *)keywords  page  :(NSString *)page  count  :(NSString *)count {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:keywords  forKey:@"keywords"];
    [dict setValue:page  forKey:@"page"];
    [dict setValue:count  forKey:@"count"];
    [dict setValue:@"search/kitchen.do" forKey:INTERFACEDOACTION];
    return dict;

}

+ (NSMutableDictionary *)wosKitchenInfo_medeals_userIndex:(NSString *)userIndex kitchenIndex:(NSString *)kitchenIndex{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userIndex  forKey:@"userIndex"];
    [dict setValue:kitchenIndex  forKey:@"kitchenIndex"];
    [dict setValue:@"me/deals.do" forKey:INTERFACEDOACTION];
    return dict;
}

//order/add.do
+ (NSMutableDictionary *)wosKitchenInfo_orderadd_userIndex:(NSString *)userIndex kitchenIndex:(NSString *)kitchenIndex userAddrIndex:(NSString *)userAddrIndex persons:(NSString *)persons remarks:(NSString *)remarks dealsIndexs:(NSString *)dealsIndexs foodIndexs:(NSString *)foodIndexs countIndexs:(NSString *)countIndexs{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userIndex  forKey:@"userIndex"];
    [dict setValue:kitchenIndex  forKey:@"kitchenIndex"];
    [dict setValue:userIndex  forKey:@"userAddrIndex"];
    [dict setValue:persons  forKey:@"persons"];
    [dict setValue:remarks  forKey:@"remarks"];
    [dict setValue:dealsIndexs  forKey:@"dealsIndexs"];
    [dict setValue:foodIndexs  forKey:@"foodIndexs"];
    [dict setValue:countIndexs  forKey:@"countIndexs"];
    [dict setValue:@"order/add.do" forKey:INTERFACEDOACTION];
    return dict;
}

+ (NSMutableDictionary *)wosKitchenInfo_addrList_userIndex:(NSString *)userIndex page:(NSString *)page count:(NSString *)count{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:page   forKey:@"page"];
    [dict setValue:userIndex  forKey:@"userIndex"];
    [dict setValue:count   forKey:@"count"];
    [dict setValue:@"address/list.do" forKey:INTERFACEDOACTION];
    return dict;

}

+ (NSMutableDictionary *)wosKitchenInfo_addrAdd_userIndex:(NSString *)userIndex receiverAddress:(NSString *)receiverAddress receiverName:(NSString *)receiverName receiverPhoneNo:(NSString *)receiverPhoneNo{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:receiverAddress   forKey:@"receiverAddress"];
    [dict setValue:userIndex  forKey:@"userIndex"];
    [dict setValue:receiverPhoneNo   forKey:@"receiverPhoneNo"];
    [dict setValue:receiverName   forKey:@"receiverName"];
    [dict setValue:@"address/add.do" forKey:INTERFACEDOACTION];
    return dict;
    
}

+ (NSMutableDictionary *)wosKitchenInfo_favoriteList_userIndex:(NSString *)userIndex page:(NSString *)page count:(NSString *)count{
   
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:page   forKey:@"page"];
    [dict setValue:userIndex  forKey:@"userIndex"];
    [dict setValue:count   forKey:@"count"];
    [dict setValue:@"favorite/list.do" forKey:INTERFACEDOACTION];
    return dict;
}

+ (NSMutableDictionary *)wosKitchenInfo_activityList_count:(NSString *)count{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:count forKey:@"count"];
    [dict setValue:@"activity/list.do" forKey:INTERFACEDOACTION];
    return dict;
    
}


+ (NSMutableDictionary *)wosKitchenInfo_orderList_userIndex:(NSString *)userIndex page:(NSString *)page count:(NSString *)count status :(NSString *)status{


    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:page   forKey:@"page"];
    [dict setValue:userIndex  forKey:@"userIndex"];
    [dict setValue:count   forKey:@"count"];
    [dict setValue:status   forKey:@"status"];
    [dict setValue:@"order/list.do" forKey:INTERFACEDOACTION];
    return dict;


}
+ (NSMutableDictionary *)wosKitchenInfo_activityInfo_Index:(NSString *)index{
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:index   forKey:@"activityIndex"];
    [dict setValue:@"activity/info.do" forKey:INTERFACEDOACTION];
    return dict;


}

+ (NSMutableDictionary *)wosMapList_userIndex:(NSString *)userIndex gps:(NSString *)gps radius :(NSString *)radius type :(NSString *)type{


    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userIndex   forKey:@"userIndex"];
    [dict setValue:gps   forKey:@"gps"];
    [dict setValue:radius   forKey:@"radius"];
    [dict setValue:type   forKey:@"type"];
    [dict setValue:@"map/list.do" forKey:INTERFACEDOACTION];
    return dict;

}


+ (NSMutableDictionary *)wosFoodInfo_foodIndex:(NSString *)foodIndex {

    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
   
    [dict setValue:foodIndex   forKey:@"foodIndex"];
    [dict setValue:@"food/info.do" forKey:INTERFACEDOACTION];
    return dict;
}


+ (NSMutableDictionary *)wosFoodInfo_foodDiscount_kitchenIndex :(NSString *)kitchenIndex discountDay  :(NSString *)discountDay  page  :(NSString *)page  count  :(NSString *)count {

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:kitchenIndex        forKey:@"kitchenIndex"];
    [dict setValue:discountDay         forKey:@"discountDay"];
    [dict setValue:page                forKey:@"page"];
    [dict setValue:count               forKey:@"count"];
    [dict setValue:@"food/discount.do" forKey:INTERFACEDOACTION];
    return dict;


}


+ (NSMutableDictionary *)wosFoodInfo_guessList_userIndex :(NSString *)userIndex  page  :(NSString *)page  count  :(NSString *)count{

    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userIndex        forKey:@"userIndex"];
    [dict setValue:page                forKey:@"page"];
    [dict setValue:count               forKey:@"count"];
    [dict setValue:@"guess/list.do" forKey:INTERFACEDOACTION];
    return dict;

}

+ (NSMutableDictionary *)wosFoodInfo_allInfo_userIndex :(NSString *)userIndex{

    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userIndex        forKey:@"userIndex"];
    [dict setValue:@"me/more.do" forKey:INTERFACEDOACTION];
    return dict;

}

+ (NSMutableDictionary *)wosFoodInfo_addressDel_userIndex :(NSString *)userIndex addrIndex :(NSString *)addrIndex {
    
    NSMutableDictionary * dict = AUTORELEASE([[NSMutableDictionary alloc] init]);
    [dict setValue:userIndex        forKey:@"userIndex"];
    [dict setValue:addrIndex        forKey:@"addrIndex"];
    [dict setValue:@"address/del.do" forKey:INTERFACEDOACTION];
    return dict;

}
@end
