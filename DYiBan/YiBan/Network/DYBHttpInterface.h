//
//  DYBHttpInterface.h
//  DYiBan
//
//  Created by NewM on 13-8-1.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYBHttpInterface : NSObject


/**
 登陆data
 **/
+ (NSMutableDictionary *)login:(NSString *)name password:(NSString *)pwd;
/**
 动态
 **/
+ (NSMutableDictionary *) setstatus_list:(NSString *)since_id max_id:(NSString *)max_id last_id:(NSString *)last_id num:(NSString *)num page:(NSString *)page type:(NSString *)type userid:(NSString *)userid;
/**
 辅导员班级列表
 **/
+ (NSMutableDictionary *)eclass_list :(NSString *)last_id num:(NSString *)num page:(NSString *)page eclassid:(NSString *)eclassid;
/**
 评论提醒列表
 **/
+ (NSMutableDictionary *)review_list:(int)page pageNum:(int)num :(int)lastid;
/**
 AT我  评论 at 提醒列表
 **/
+ (NSMutableDictionary *)aboutmeMessage:(int)page pageNum:(int)num;
/**
 私信列表
 **/
+ (NSMutableDictionary *)message_contact_sixin:(int)page pageNum:(int)num;
/**
 辅导员通知
 **/
+ (NSMutableDictionary *)message_chat_sixin:(int)page pageNum:(int)num  type:(NSString *)type userid:(NSString *)userid maxid:(NSString *)maxid last_id:(NSString *)lastid;

/**
 *上传token
 **/
+ (NSMutableDictionary *)user_setting;

//系统消息
+ (NSMutableDictionary *)message_friendreqlist_yaoqing:(int)page pageNum:(int)num;
+ (NSMutableDictionary *)status_add_content:(NSString *)content add_notice:(NSString *)add_notice  sync_tag:(int)sync_tag refuse:(NSString *)refuse at_eclass:(NSString *)at_eclass address:(NSString *)address;
+ (NSMutableDictionary *)user_friendlist_userid:(NSString *)userid num:(NSString *)num  page:(int)page type:(NSString *)type;
+ (NSMutableDictionary *)user_myeclass_list:(NSString *)userid;
+ (NSMutableDictionary *)eclass_detail:(NSString *)class_id num:(int)num page:(int)page;
+ (NSMutableDictionary *)user_recommendlist_userid:(NSString *)num;
+ (NSMutableDictionary *)search_user:(NSString *)searchContent num:(NSString *)num  page:(int)page;
+ (NSMutableDictionary *)message_reqfriend:(NSString *)userid;
+ (NSMutableDictionary *)searchNearby:(NSString *)num latitude:(NSString *)StrLat longitude:(NSString *)StrLng page:(NSString *)page userid:(NSString *)userid;
+ (NSMutableDictionary *)user_recentcontact:(NSString *)userid;

/**
 动态评论列表接口
 **/
+ (NSMutableDictionary *)status_comments:(NSString *)_id type:(NSInteger)type since_id:(NSString *)since_id max_id:(NSString *)max_id num:(NSInteger)num page:(NSInteger)page;
+ (NSMutableDictionary *)status_actionlist:(NSString *)_id action:(NSInteger)action page:(NSInteger)page num:(NSInteger)num;
+ (NSMutableDictionary *)status_followlist:(NSString *)_id num:(NSInteger)num page:(NSInteger)page;

/**
 新华e讯
 **/
+ (NSMutableDictionary *)xinhunews_index:(NSString *)num;
+ (NSMutableDictionary *)xinhuanews_list:(NSString *)last_id num:(NSString *)num page:(NSString *)page category_id:(NSString *)category_id;
+ (NSMutableDictionary *)xinhuanews_detail:(NSString *)id category_id:(NSString *)category_id;

+ (NSMutableDictionary *)sendmessage:(NSString *)message userid:(NSString *)userid;

/**
 用户签到
 **/
+ (NSMutableDictionary *)user_sign_list:(NSString *)userid type:(NSString *)type;
+ (NSMutableDictionary *)user_sign_datelog;
+ (NSMutableDictionary *)user_sign_add:(NSString *)lng lat:(NSString *)lat address:(NSString *)address refulse:(NSString *)refulse;
+ (NSMutableDictionary *)user_sign_map:(NSString *)userid type:(NSString *)type;
+ (NSMutableDictionary *)user_sign_position:(NSString *)lng lat:(NSString *)lat address:(NSString *)address;

/**
 注销登陆
 **/
+ (NSMutableDictionary *)user_security_logout;

/**
 自动登陆
 **/
+ (NSMutableDictionary *)user_security_autologin;


/**
 *意见反馈
 */
+ (NSMutableDictionary *)sendInfomation:(NSString *)content;

/**
 *相册列表
 */
+ (NSMutableDictionary *)albumList:(NSString *)userId num:(NSInteger)num page:(NSInteger)page;
/**
 *相册图片列表
 */
+ (NSMutableDictionary *)albumList:(NSString *)userId albumId:(NSString *)albumId num:(NSInteger)num page:(NSInteger)page;
/**
 *订阅PUSH接口user_rss
 */
+ (NSMutableDictionary *)user_rss:(NSString *)userId op:(NSString *)op;
/**
 *同意被加为好友
 */
+ (NSMutableDictionary *)message_applyfriend:(NSString *)userid op:(NSString *)op;

/**
 *个人主页最近访客user_perguest
 */
+ (NSMutableDictionary *)user_perguest:(NSString *)userId;

/**
 *设置用户昵称接口user_setnick
 */
+ (NSMutableDictionary *)user_setnick:(NSString *)nick;

/**
 *用户详情接口user_detail
 */
+ (NSMutableDictionary *)user_detail:(NSString *)userId;

/**
 *学校学院列表
 */
+ (NSMutableDictionary *)school_collegelist:(NSString *)schoolId;

/**
 *设置用户基本资料  (1,生日2,家乡3,学院4,入学)
 */
+ (NSMutableDictionary *)user_setbase:(NSString *)value type:(NSInteger)type;

/**
 *设置个人隐私type(0,个人主页1,生日2,家乡3,手机)
 */
+ (NSMutableDictionary *)user_setdesc:(NSString *)value type:(NSInteger)type;

/**
 *获取验证码接口security_authcode  type: 验证码类型 0 修改密码 1 修改手机号
 */
+ (NSMutableDictionary *)security_authcode:(NSString *)phone type:(NSString *)type;

/**
 *验证码修改用户手机接口security_resetphone
 */
+ (NSMutableDictionary *)security_resetphone:(NSString *)authcode phone:(NSString *)phone password:(NSString *)password;

/**
 *排行榜一级列表接口 charts_total
 */
+ (NSMutableDictionary *)charts_total:(NSString *)num;

/**
 *排行榜二级级列表接口 charts_total
 */
+ (NSMutableDictionary *)charts_list:(NSString *)chartstype num:(NSString *)num page:(NSString *)page;


+ (NSMutableDictionary *)status_detail_id :(int)_id  type:(int)type since_id:(NSString *)since_id max_id:(NSString *)max_id num:(NSString *)num page:(NSString *)page message_id:(NSString *)message_id;
+ (NSMutableDictionary *)status_eclasslist:(NSString *)_id num:(NSString *)num page:(NSString *)page eclassid:(NSString *)eclassid;
+ (NSMutableDictionary *)status_feedaction_id:(NSString *)_id action:(NSString *)action type:(NSString *)type;
+ (NSMutableDictionary *)status_del_id:(NSString *)_id  type:(NSString *)type;
+ (NSMutableDictionary *)status_addcomment_id:(NSString *)_id  content:(NSString *)content;
/**
 解除sns绑定
 **/
+ (NSMutableDictionary *)user_delsync_m:(NSString *)tag;
+ (NSMutableDictionary *)status_notice_id:(NSString *)_id  type:(NSString *)type page:(NSString *)page num:(NSString *)num;
/**
 *用户上传近照接口user_uploadavatar
 */
+ (NSMutableDictionary *)user_uploadavatar;

/**
 *设置个人签名接口user_setdesc
 */
+ (NSMutableDictionary *)user_setdesc:(NSString *)text;

/**
 *用户设置头像接口user_setavatar
 */
+ (NSMutableDictionary *)user_setavatar:(NSString *)picId;

/**
 *新用户注册
 */
+ (NSMutableDictionary *)security_reg:(NSString *)username nickname:(NSString *)nickname password:(NSString *)password sex:(NSString *)sex;

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
+ (NSMutableDictionary *)security_cert:(NSString *)schoolId realName:(NSString *)realName certNum:(NSString *)certNum phone:(NSString *)phone cerCode:(NSString *)verCode certKey:(NSString *)certKey;

/**
 *校验验证码接口security_verifyauthcode
 */
+ (NSMutableDictionary *)security_verifyauthcode:(NSString *)phone acuthcode:(NSString *)acthcode;

/**
 *验证码重置密码接口security_resetpwd
 */
+ (NSMutableDictionary *)security_resetpwd:(NSString *)userid authcode:(NSString *)authcode password:(NSString *)password;
/**
 *用户解除好友关系user_delfriend
 */
+ (NSMutableDictionary *)user_delfriend:(NSArray *)arrayID oneId:(NSString *)oneid;
/**
 *学校班级列表 接口 school_list
 */
+ (NSMutableDictionary *)school_list:(NSString *)type;
/**
 *用户push设置接口 user_setpush
 */
+ (NSMutableDictionary *)user_setpush:(NSString *)pushTag isDisturb:(BOOL)isDisturb disturb_time:(NSString *)disturbTime;

/**
 *user_setbackground设置背景图片
 */
+ (NSMutableDictionary *)user_setbackground:(NSString *)index tag:(NSString *)tag;

/**
 未读消息数
 **/
+ (NSMutableDictionary *)messageCount;
//二维码
+ (NSMutableDictionary *)code_user_name:(NSString *)name password:(NSString *)password;
+ (NSMutableDictionary *)yiban_source_banner_pageid:(NSString *)pageid ;

/**
 删除评论消息
 **/
+ (NSMutableDictionary *)messageDelComment:(NSString *)CommentIDs;


/**
 删除@消息
 **/
+ (NSMutableDictionary *)messageDelAt:(NSString *)AtIDs;

/**
 删除某联系人所有消息
 **/
+ (NSMutableDictionary *)messageDelContact:(NSString *)userid ContactType:(NSString *)type;

/**
 删除某联系人所有消息
 **/
+ (NSMutableDictionary *)messageDelNotice:(NSString *)NoticeIDs MsgType:(NSString *)type;
/**
 班级公告
 **/
+ (NSMutableDictionary *)classNoticeList_id:(NSString *)_id;
+ (NSMutableDictionary *)eclass_topiclist:(NSString *)classID offset:(NSString *)offset limit:(NSString *)limit;
/**
 转发
 **/
+ (NSMutableDictionary *)status_follow_id:(NSString *)_id content:(NSString *)_content com_tag:(NSString *)tag;
+ (NSMutableDictionary *)user_mutualfriend:(NSString *)userid;
//就业列表
+ (NSMutableDictionary *)job_list_page:(NSInteger)_page num:(NSInteger)_num order:(NSString *)_order;

//就业详情
+ (NSMutableDictionary *)job_detail_id:(NSString *)_id;

//就业收索
+ (NSMutableDictionary *)job_search_page:(NSInteger)_page num:(NSInteger)_num keywork:(NSString *)_keywork type:(NSInteger)_type;

+ (NSMutableDictionary *)user_birthday:(NSString *)offset/*偏移(每页的最后一个数据的index)*/  limit:(NSString *)limit /*条数(每页获取几条)*/;

+ (NSMutableDictionary *)user_avatartop:(NSString *)userId ;
+ (NSMutableDictionary *)eclass_managelist:(NSString *)userid;

+ (NSMutableDictionary *)user_avatartread:(NSString *)userId ;
+ (NSMutableDictionary *)message_remind:(int)page pageNum:(int)num last_id:(NSString *)last_id;

//就业收藏列表
+ (NSMutableDictionary *)job_collectLsit_page:(NSInteger)_page num:(NSInteger)_num order:(NSString *)_order;

//删除就业收藏
+ (NSMutableDictionary *)job_decollect_id:(NSString *)_id;

+ (NSMutableDictionary *)user_avatardolist:(NSString *)userId type:(NSString *)type/*0:顶  1踩*/;


//添加就业收藏
+ (NSMutableDictionary *)job_addCollect_id:(NSString *)_id;

//版本检查
+ (NSMutableDictionary *)site_version;

//用户新信息接口
+ (NSMutableDictionary *)message_count;

//获取app应用接口
+ (NSMutableDictionary *)site_yibanapp;

// 数据库列表
+ (NSMutableDictionary *)dataBankList_navi_id:(NSString *)_id order:(NSString *)order asc:(NSString *)asc num:(NSString *)num page:(NSString *)page keyword:(NSString *)keyword;

//学校接口
+ (NSMutableDictionary *)source_schoollist;
//学校接口
+ (NSMutableDictionary *)source_schoolview;
//资料库搜索
+ (NSMutableDictionary *)search_disk_keyword:(NSString *)keywork page:(int)page num:(int)num type:(NSString *)type;

//资料库转存
+ (NSMutableDictionary *)document_changestore_from_id:(NSString *)from_id doc_from:(NSString *)doc_from doc_to:(NSString *)doc_to doc_type:(NSString *)type;
//新生通道
+ (NSMutableDictionary *)security_newchannel;


//资料或者分类重名名
+ (NSMutableDictionary *)document_rename_doc_id:(NSString *)doc_id name:(NSString *)name is_dir:(NSString *)is_dir indexDataBack:(NSString *)indexDataBack ;


//学校认证数据借口
+ (NSMutableDictionary *)school_cert:(NSString *)_id;


#pragma mark-设置活跃班级
+ (NSMutableDictionary *)eclass_active:(NSString *)classID;

//删除资料库文件
+ (NSMutableDictionary *)document_deldoc_doc:(NSString *)doc indexDataBack:(NSString *)indexDataBack;

//资料库文件共享
+ (NSMutableDictionary *)document_share_doc:(NSString *)doc target:(NSString *)target;
//发送图片 语音 位置
+ (NSMutableDictionary *)sendmessage2:(NSString *)userid content:(NSString *)content type:(NSString *)type lng:(NSString *)lon lat:(NSString *)lat address:(NSString *)address speech_length:(NSString *)speech_length;

//创建目录
+ (NSMutableDictionary *)document_createdir_name:(NSString *)name dir:(NSString *)dir;

//共享给我的资料列表
+(NSMutableDictionary *)share_formelist_target:(NSString *)target order:(NSString *)order num:(NSString *)num page:(NSString *)page keyword:(NSString *)keyword asc:(NSString *)asc;

//我共享的资料列表接口
+ (NSMutableDictionary *)share_frommelist:(NSString *)order num:(NSString *)num page:(NSString *)page keyword:(NSString *)keyword asc:(NSString *)asc;


//公共资源
+ (NSMutableDictionary *)document_public_order:(NSString *)order num:(NSString *)num page:(NSString *)page  keyword:(NSString *)keyword asc:(NSString *)asc;


//资料库容量
+ (NSMutableDictionary *)document_userspace;

//资料库好友列表
+ (NSMutableDictionary *)source_friendlist_doc:(NSString *)doc;

//获取我的班级列表接口
+ (NSMutableDictionary *)source_classlist_doc:(NSString *)doc;

//共享给学院
+ (NSMutableDictionary *)source_departmentlist;

//踩 顶
+ (NSMutableDictionary *)document_estimate_id:(NSString *)_id type:(NSString *)type;

//举报
+(NSMutableDictionary *)document_publicreport_oid:(NSString *)oid type:(NSString *)type reason:(NSString *)reason;

// 移动文件
+(NSMutableDictionary *)document_move_name:(NSString *)name old_dir:(NSString *)old_dir new_dir:(NSString *)new_dir;
// 活动接口
+(NSMutableDictionary *)active_detail:(NSString *)active_id;

//发活动动态
+(NSMutableDictionary *)active_addfeed:(NSString *)content active_id:(NSString *)active_id;

//活动动态列表接口
+(NSMutableDictionary *)active_feedlist:(NSString *)active_id last_id:(NSString *)last_id num:(NSString *)num page:(NSString *)page;

// 活动操作
+(NSMutableDictionary *)active_action:(NSString *)active_id action:(NSString*)action op:(NSString*)op;

+ (NSMutableDictionary *)notes_listByKeywords:(NSString *)keywords tagid:(NSString *)tagid/*标签ID*/ favorite:(NSString *)favorite/*1.搜索搜藏笔记 0 默认 全部*/ page:(NSString *)page num:(NSString *)num searchmonth:(NSString *)searchmonth delnum:(NSString *)delnum;

// 笔记标签列表
+ (NSMutableDictionary *)notes_taglist:(NSString *)keywords showcount:(NSString *)showcount page:(NSString *)page num:(NSString *)num;

+ (NSMutableDictionary *)notes_addfavorite:(NSString *)nid ;
+ (NSMutableDictionary *)notes_delfavorite:(NSString *)nid ;

// 笔记设置
+ (NSMutableDictionary *)notes_setting;
// 共享给我的
+ (NSMutableDictionary *)notes_sharenotelist:(NSString *)page num:(NSString *)num keywords:(NSString *)keywords;
// 我共享的
+ (NSMutableDictionary *)notes_mysharelist:(NSString *)page num:(NSString *)num keywords:(NSString *)keywords;
+ (NSMutableDictionary *)notes_delnote:(NSString *)nid ;
+ (NSMutableDictionary *)notes_sharenote:(NSString *)nid to_userid:(NSString *)to_userid/*1,2,3,4*/ ;
// 保存共享笔记
+ (NSMutableDictionary *)notes_savesharenote:(NSString *)shareid nid:(NSString *)nid;
+ (NSMutableDictionary *)notes_dumpnote:(NSString *)nid del:(NSString *)del ;
// 取消共享
+ (NSMutableDictionary *)notes_delsharenote:(NSString *)shareid;
//删除标签
+ (NSMutableDictionary *)notes_deltag:(NSString *)tag_id;
//新建标签
+ (NSMutableDictionary *)notes_addtag:(NSString *)tag;

+ (NSMutableDictionary *)notes_detail:(NSString *)nid;

//唯一标示符
+ (NSMutableDictionary *)security_authtag;

+ (NSMutableDictionary *)notes_addnoteBylng:(NSString *)lng lat:(NSString *)lat address:(NSString *)address title:(NSString *)title content:(NSString *)content tagid:(NSString *)tagid/*标签id:"1,2,3,4"*/;
+ (NSMutableDictionary *)notes_uploadfile:(NSString *)nid duration:(NSString *)duration/*音频文件时长*/ ;
+ (NSMutableDictionary *)notes_delfile:(NSString *)fid;
+ (NSMutableDictionary *)notes_editnote:(NSString *)nid content:(NSString *)content tagid:(NSString *)tagid/*标签id:"1,2,3,4"*/;

+ (NSMutableDictionary *)wosLogin_nickName:(NSString *)nickName passwd:(NSString *)passwd;

+ (NSMutableDictionary *)wosRegion_nickName:(NSString *)nickName passwd:(NSString *)passwd sex:(NSString *)sex;


+ (NSMutableDictionary *)wosgoodFood_typeIndex:(NSString *)typeIndex  orderBy:(NSString *)orderBy  page:(NSString *)page count:(NSString *)count orderType:(NSString *)orderType;

+ (NSMutableDictionary *)wosKitchenInfo_kitchenIndex :(NSString *)kitchenIndex   userIndex :(NSString *)userIndex   hotFoodCount :(NSString *)hotFoodCount;

+ (NSMutableDictionary *)wosKitchenInfo_kitchenComment_commentFor :(NSString *)commentFor    orderIndex :(NSString *)orderIndex    userIndex :(NSString *)userIndex commentType  :(NSString *)commentType     starLevel  :(NSString *)starLevel  comment  :(NSString *)comment ;
//favorite/add.do

+ (NSMutableDictionary *)wosKitchenInfo_favorite_userIndex:(NSString *)userIndex  kitchenIndex  :(NSString *)kitchenIndex;

///comment/kitchen/list.do

+ (NSMutableDictionary *)wosKitchenInfo_commentkitchenlist:(NSString *)kitchenIndex starLevel:(NSString *)starLevel page :(NSString *)page  count:(NSString *)count;


+ (NSMutableDictionary *)wosKitchenInfo_foodlist:(NSString *)kitchenIndex;

+ (NSMutableDictionary *)wosKitchenInfo_commentadd:(NSString *)commentFor orderIndex :(NSString *)orderIndex userIndex :(NSString *)userIndex commentType :(NSString *)commentType starLevel :(NSString *)starLevel comment:(NSString *)comment;
///search/kitchen.do
+ (NSMutableDictionary *)wosKitchenInfo_searchKitch_keywords :(NSString *)keywords  page  :(NSString *)page  count  :(NSString *)count ;

//me/deals.do
+ (NSMutableDictionary *)wosKitchenInfo_medeals_userIndex:(NSString *)userIndex kitchenIndex:(NSString *)kitchenIndex;


+ (NSMutableDictionary *)wosKitchenInfo_orderadd_userIndex:(NSString *)userIndex kitchenIndex:(NSString *)kitchenIndex userAddrIndex:(NSString *)userAddrIndex persons:(NSString *)persons remarks:(NSString *)remarks dealsIndexs:(NSString *)dealsIndexs foodIndexs:(NSString *)foodIndexs countIndexs:(NSString *)countIndexs;


//address/list.do
+ (NSMutableDictionary *)wosKitchenInfo_addrList_userIndex:(NSString *)userIndex page:(NSString *)page count:(NSString *)count;


//address/add.do
+ (NSMutableDictionary *)wosKitchenInfo_addrAdd_userIndex:(NSString *)userIndex receiverAddress:(NSString *)receiverAddress receiverName:(NSString *)receiverName receiverPhoneNo:(NSString *)receiverPhoneNo;

//favorite/list.do
+ (NSMutableDictionary *)wosKitchenInfo_favoriteList_userIndex:(NSString *)userIndex page:(NSString *)page count:(NSString *)count;

//activity/list.do
+ (NSMutableDictionary *)wosKitchenInfo_activityList_count:(NSString *)count;

//order/list.do
+ (NSMutableDictionary *)wosKitchenInfo_orderList_userIndex:(NSString *)userIndex page:(NSString *)page count:(NSString *)count status :(NSString *)status ;
///activity/info.do
+ (NSMutableDictionary *)wosKitchenInfo_activityInfo_Index:(NSString *)index ;

//map/list.do

+ (NSMutableDictionary *)wosMapList_userIndex:(NSString *)userIndex gps:(NSString *)gps radius :(NSString *)radius type :(NSString *)type ;
//food/info.do

+ (NSMutableDictionary *)wosFoodInfo_foodIndex:(NSString *)foodIndex   ;
//food/discount.do
+ (NSMutableDictionary *)wosFoodInfo_foodDiscount_kitchenIndex :(NSString *)kitchenIndex discountDay  :(NSString *)discountDay  page  :(NSString *)page  count  :(NSString *)count    ;


//guess/list.do

+ (NSMutableDictionary *)wosFoodInfo_guessList_userIndex :(NSString *)userIndex  page  :(NSString *)page  count  :(NSString *)count;

///me/allInfo.do
+ (NSMutableDictionary *)wosFoodInfo_allInfo_userIndex :(NSString *)userIndex ;


//address/del.do
+ (NSMutableDictionary *)wosFoodInfo_addressDel_userIndex :(NSString *)userIndex addrIndex :(NSString *)addrIndex ;

//order/info.do
+ (NSMutableDictionary *)wosFoodInfo_orderinfo_userIndex :(NSString *)userIndex orderIndex  :(NSString *)orderIndex  ;
@end
