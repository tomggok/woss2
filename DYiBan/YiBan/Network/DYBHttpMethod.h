//
//  DYBHttpMethod.h
//  DYiBan
//
//  Created by NewM on 13-8-1.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYBRequest.h"
#import "DYBHttpInterface.h"

@interface DYBHttpMethod : NSObject

+ (MagicRequest *)user_avatartop:(NSString *)userId isAlert:(BOOL)isAlert receive:(id)receive ;
+ (MagicRequest *)user_birthday:(NSString *)offset/*偏移(每页的最后一个数据的index)*/  limit:(NSString *)limit /*条数(每页获取几条)*/ isAlert:(BOOL)isAlert receive:(id)receive ;
+ (MagicRequest *)user_mutualfriend:(NSString *)userid isAlert:(BOOL)isAlert receive:(id)receive ;
+ (MagicRequest *)eclass_topiclist:(NSString *)classID offset:(NSString *)offset limit:(NSString *)limit isAlert:(BOOL)isAlert receive:(id)receive ;
+ (MagicRequest *)message_remind:(int)page pageNum:(int)num last_id:(NSString *)last_id isAlert:(BOOL)isAlert receive:(id)receive ;
+ (MagicRequest *)eclass_managelist:(NSString *)userid isAlert:(BOOL)isAlert receive:(id)receive ;

//登陆接口
+ (MagicRequest *)login:(NSString *)name password:(NSString *)psd isAlert:(BOOL)isAlert isRemberPsd:(BOOL)isRember receive:(id)receive;
//动态接口
+ (MagicRequest *)setstatus_list:(NSString *)since_id max_id:(NSString *)max_id last_id:(NSString *)last_id num:(NSString *)num page:(NSString *)page type:(NSString *)type userid:(NSString *)userid isAlert:(BOOL)isAlert receive:(id)receive;
//没有cache的动态接口
+ (MagicRequest *)noCacheSetstatus_list:(NSString *)since_id max_id:(NSString *)max_id last_id:(NSString *)last_id num:(NSString *)num page:(NSString *)page type:(NSString *)type userid:(NSString *)userid isAlert:(BOOL)isAlert receive:(id)receive;
//辅导员班级列表接口
+ (MagicRequest *)eclass_list :(NSString *)last_id num:(NSString *)num page:(NSString *)page eclassid:(NSString *)eclassid isAlert:(BOOL)isAlert receive:(id)receive;
//评论提醒列表接口
+ (MagicRequest *)review_list:(int)page pageNum:(int)num :(int)lastid isAlert:(BOOL)isAlert receive:(id)receive;
//评论 at 提醒列表999
+ (MagicRequest *)aboutmeMessage:(int)page pageNum:(int)num isAlert:(BOOL)isAlert receive:(id)receive;
//私信列表999
+ (MagicRequest *)message_contact_sixin:(int)page pageNum:(int)num isAlert:(BOOL)isAlert receive:(id)receive;
//辅导员通知列表999
+ (MagicRequest *)message_chat_tongzhi:(int)page pageNum:(int)num isAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)user_avatartread:(NSString *)userId isAlert:(BOOL)isAlert receive:(id)receive ;

+ (MagicRequest *)user_avatardolist:(NSString *)userId type:(NSString *)type/*0:顶  1踩*/ isAlert:(BOOL)isAlert receive:(id)receive ;
+ (MagicRequest *)message_friendreqlist_yaoqing:(int)page pageNum:(int)num isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)status_add_content:(NSString *)content add_notice:(NSString *)add_notice  sync_tag:(int)sync_tag refuse:(NSString *)refuse at_eclass:(NSString *)at_eclass address:(NSString *)address isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)user_friendlist_userid:(NSString *)userid num:(NSString *)num  page:(int)page type:(NSString *)type isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)user_myeclass_list:(NSString *)userid isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)eclass_detail:(NSString *)class_id num:(int)num page:(int)page isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)user_recommendlist_userid:(NSString *)num isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)search_user:(NSString *)searchContent num:(NSString *)num  page:(int)page isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)message_reqfriend:(NSString *)userid isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)searchNearby:(NSString *)num latitude:(NSString *)StrLat longitude:(NSString *)StrLng page:(NSString *)page  userid:(NSString *)userid isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)user_recentcontact:(NSString *)userid isAlert:(BOOL)isAlert receive:(id)receive;

/**
 动态评论列表接口
 **/
+ (MagicRequest *)status_comments:(NSString *)_id type:(NSInteger)type since_id:(NSString *)since_id max_id:(NSString *)max_id num:(NSInteger)num page:(NSInteger)page isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)status_actionlist:(NSString *)_id action:(NSInteger)action page:(NSInteger)page num:(NSInteger)num isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)status_followlist:(NSString *)_id num:(NSInteger)num page:(NSInteger)page isAlert:(BOOL)isAlert receive:(id)receive;

/**
 新华e讯
 **/
+ (MagicRequest *)xinhunews_index:(NSString *)num isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)xinhuanews_list:(NSString *)last_id num:(NSString *)num page:(NSString *)page category_id:(NSString *)category_id isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)xinhuanews_detail:(NSString *)id category_id:(NSString *)category_id isAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)message_chat_sixin:(int)page pageNum:(int)num  type:(NSString *)type userid:(NSString *)userid maxid:(NSString *)maxid last_id:(NSString *)lastid isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)sendmessage:(NSString *)message userid:(NSString *)userid isAlert:(BOOL)isAlert receive:(id)receive;

/**
 用户签到
 **/
+ (MagicRequest *)user_sign_list:(NSString *)userid type:(NSString *)type isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)user_sign_datelog:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)user_sign_add:(NSString *)lng lat:(NSString *)lat address:(NSString *)address refulse:(NSString *)refulse isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)user_sign_map:(NSString *)userid type:(NSString *)type isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)user_sign_position:(NSString *)lng lat:(NSString *)lat address:(NSString *)address isAlert:(BOOL)isAlert receive:(id)receive;

/**
 注销登陆
 **/
+ (MagicRequest *)user_security_logout:(BOOL)isAlert receive:(id)receive;

/**
 自动登陆
 **/
+ (MagicRequest *)user_security_autologin:(BOOL)isAlert receive:(id)receive;

/**
 发送token
 **/
+ (MagicRequest *)user_setting:(BOOL)isAlert receive:(id)receive;

/**
 *意见反馈
 */
+ (MagicRequest *)sendInfomation:(NSString *)content isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *相册列表
 */
+ (MagicRequest *)albumList:(NSString *)userId num:(NSInteger)num page:(NSInteger)page isAlert:(BOOL)isAlert receive:(id)receive;
/**
 *相册图片列表
 */
+ (MagicRequest *)albumList:(NSString *)userId albumId:(NSString *)albumId num:(NSInteger)num page:(NSInteger)page isAlert:(BOOL)isAlert receive:(id)receive;
/**
 *订阅PUSH接口user_rss
 */
+ (MagicRequest *)user_rss:(NSString *)userId op:(NSString *)op isAlert:(BOOL)isAlert receive:(id)receive;
/**
 *同意被加为好友
 */
+ (MagicRequest *)message_applyfriend:(NSString *)userid op:(NSString *)op isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *个人主页最近访客user_perguest
 */
+ (MagicRequest *)user_perguest:(NSString *)userId isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *设置用户昵称接口user_setnick
 */
+ (MagicRequest *)user_setnick:(NSString *)nick isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *用户详情接口user_detail
 */
+ (MagicRequest *)user_detail:(NSString *)userId isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *学校学院列表
 */
+ (MagicRequest *)school_collegelist:(NSString *)schoolId isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *设置用户基本资料  (1,生日2,家乡3,学院4,入学)
 */
+ (MagicRequest *)user_setbase:(NSString *)value type:(NSInteger)type isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *设置个人隐私type(0,个人主页1,生日2,家乡3,手机)
 */
+ (MagicRequest *)user_setdesc:(NSString *)value type:(NSInteger)type isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *获取验证码接口security_authcode  type: 验证码类型 0 修改密码 1 修改手机号
 */
+ (MagicRequest *)security_authcode:(NSString *)phone type:(NSString *)type isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *验证码修改用户手机接口security_resetphone
 */
+ (MagicRequest *)security_resetphone:(NSString *)authcode phone:(NSString *)phone password:(NSString *)password isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *排行榜一级列表接口 charts_total
 */
+ (MagicRequest *)charts_total:(NSString *)num isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *排行榜二级级列表接口 charts_total
 */
+ (MagicRequest *)charts_list:(NSString *)chartstype num:(NSString *)num page:(NSString *)page isAlert:(BOOL)isAlert receive:(id)receive;


+ (MagicRequest *)status_detail_id :(int)_id  type:(int)type since_id:(NSString *)since_id max_id:(NSString *)max_id num:(NSString *)num page:(NSString *)page message_id:(NSString *)message_id isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)status_eclasslist:(NSString *)_id num:(NSString *)num page:(NSString *)page eclassid:(NSString *)eclassid isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)status_feedaction_id:(NSString *)_id action:(NSString *)action type:(NSString *)type isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)status_del_id:(NSString *)_id  type:(NSString *)type isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)status_addcomment_id:(NSString *)_id  content:(NSString *)content isAlert:(BOOL)isAlert receive:(id)receive;
/**
 解除sns绑定
 **/
+ (MagicRequest *)user_delsync_m:(NSString *)tag isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)status_notice_id:(NSString *)_id  type:(NSString *)type page:(NSString *)page num:(NSString *)num isAlert:(BOOL)isAlert receive:(id)receive;
/**
 *用户上传近照接口user_uploadavatar
 */
+ (MagicRequest *)user_uploadavatar:(BOOL)isAlert receive:(id)receive;

/**
 *设置个人签名接口user_setdesc
 */
+ (MagicRequest *)user_setdesc:(NSString *)text isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *用户设置头像接口user_setavatar
 */
+ (MagicRequest *)user_setavatar:(NSString *)picId isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *新用户注册
 */
+ (MagicRequest *)security_reg:(NSString *)username nickname:(NSString *)nickname password:(NSString *)password sex:(NSString *)sex isAlert:(BOOL)isAlert receive:(id)receive;

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
+ (MagicRequest *)security_cert:(NSString *)schoolId realName:(NSString *)realName certNum:(NSString *)certNum phone:(NSString *)phone cerCode:(NSString *)verCode certKey:(NSString *)certKey isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *校验验证码接口security_verifyauthcode
 */
+ (MagicRequest *)security_verifyauthcode:(NSString *)phone acuthcode:(NSString *)acthcode isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *验证码重置密码接口security_resetpwd
 */
+ (MagicRequest *)security_resetpwd:(NSString *)userid authcode:(NSString *)authcode password:(NSString *)password isAlert:(BOOL)isAlert receive:(id)receive;
/**
 *用户解除好友关系user_delfriend
 */
+ (MagicRequest *)user_delfriend:(NSArray *)arrayID oneId:(NSString *)oneid isAlert:(BOOL)isAlert receive:(id)receive;
/**
 *学校班级列表 接口 school_list
 */
+ (MagicRequest *)school_list:(NSString *)type isAlert:(BOOL)isAlert receive:(id)receive;
/**
 *用户push设置接口 user_setpush
 */
+ (MagicRequest *)user_setpush:(NSString *)pushTag isDisturb:(BOOL)isDisturb disturb_time:(NSString *)disturbTime isAlert:(BOOL)isAlert receive:(id)receive;

/**
 *user_setbackground设置背景图片
 */
+ (MagicRequest *)user_setbackground:(NSString *)index tag:(NSString *)tag isAlert:(BOOL)isAlert receive:(id)receive;

/**
 未读消息数
 **/
+ (MagicRequest *)messageCount:(BOOL)isAlert receive:(id)receive;
//二维码
+ (MagicRequest *)code_user_name:(NSString *)name password:(NSString *)password isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)yiban_source_banner_pageid:(NSString *)pageid  isAlert:(BOOL)isAlert receive:(id)receive;

/**
 删除评论消息
 **/
+ (MagicRequest *)messageDelComment:(NSString *)CommentIDs isAlert:(BOOL)isAlert receive:(id)receive;


/**
 删除@消息
 **/
+ (MagicRequest *)messageDelAt:(NSString *)AtIDs isAlert:(BOOL)isAlert receive:(id)receive;

/**
 删除某联系人所有消息
 **/
+ (MagicRequest *)messageDelContact:(NSString *)userid ContactType:(NSString *)type isAlert:(BOOL)isAlert receive:(id)receive;

/**
 删除某联系人所有消息
 **/
+ (MagicRequest *)messageDelNotice:(NSString *)NoticeIDs MsgType:(NSString *)type isAlert:(BOOL)isAlert receive:(id)receive;
/**
 班级公告
 **/
+ (MagicRequest *)classNoticeList_id:(NSString *)_id isAlert:(BOOL)isAlert receive:(id)receive;

/**
 转发
 **/
+ (MagicRequest *)status_follow_id:(NSString *)_id content:(NSString *)_content com_tag:(NSString *)tag isAlert:(BOOL)isAlert receive:(id)receive;

//就业列表
+ (MagicRequest *)job_list_page:(NSInteger)_page num:(NSInteger)_num order:(NSString *)_order isAlert:(BOOL)isAlert receive:(id)receive;

//就业详情
+ (MagicRequest *)job_detail_id:(NSString *)_id isAlert:(BOOL)isAlert receive:(id)receive;

//就业收索
+ (MagicRequest *)job_search_page:(NSInteger)_page num:(NSInteger)_num keywork:(NSString *)_keywork type:(NSInteger)_type isAlert:(BOOL)isAlert receive:(id)receive;

//就业收藏列表
+ (MagicRequest *)job_collectLsit_page:(NSInteger)_page num:(NSInteger)_num order:(NSString *)_order isAlert:(BOOL)isAlert receive:(id)receive;

//删除就业收藏
+ (MagicRequest *)job_decollect_id:(NSString *)_id isAlert:(BOOL)isAlert receive:(id)receive;


//添加就业收藏
+ (MagicRequest *)job_addCollect_id:(NSString *)_id isAlert:(BOOL)isAlert receive:(id)receive;
//版本检查
+ (MagicRequest *)site_version:(BOOL)isAlert receive:(id)receive;

//用户新信息接口
+ (MagicRequest *)message_count:(BOOL)isAlert receive:(id)receive;

//获取app应用接口
+ (MagicRequest *)site_yibanapp:(BOOL)isAlert receive:(id)receive;

//数据库列表
+ (MagicRequest *)dataBankList_navi_id:(NSString *)_id order:(NSString *)order asc:(NSString *)asc num:(NSString *)num page:(NSString *)page keyword:(NSString *)keyword sAlert:(BOOL)isAlert receive:(id)receive;

//学校接口
+ (MagicRequest *)source_schoollist:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)source_schoolview:(BOOL)isAlert receive:(id)receive;
//资料库搜索接口
+ (MagicRequest *)search_disk_keyword:(NSString *)keywork page:(int)page num:(int)num type:(NSString *)type sAlert:(BOOL)isAlert receive:(id)receive;


//资料活文件夹重命名
+ (MagicRequest *)document_rename_doc_id:(NSString *)doc_id name:(NSString *)name is_dir:(NSString *)is_dir indexDataBank:(NSString *)index sAlert:(BOOL)isAlert receive:(id)receive;


#pragma mark-设置活跃班级
+ (MagicRequest *)eclass_active:(NSString *)classID isAlert:(BOOL)isAlert receive:(id)receive;


//新生通道接口
+ (MagicRequest *)security_newchannel:(BOOL)isAlert receive:(id)receive;

//学校认证数据借口
+ (MagicRequest *)school_cert:(NSString *)_id isAlert:(BOOL)isAlert receive:(id)receive;

//删除资料库文件
+ (MagicRequest *)document_deldoc_doc:(NSString *)doc indexDataBack:(NSString *)indexDataBack isAlert:(BOOL)isAlert receive:(id)receive;

// 资料库文件共享
+ (MagicRequest *)document_share_doc:(NSString *)doc target:(NSString *)target isAlert:(BOOL)isAlert receive:(id)receive;

//创建目录
+(MagicRequest *)document_createdir_name:(NSString *)name dir:(NSString *)dir isAlert:(BOOL)isAlert receive:(id)receive;


/**
 发送消息 新增发送图片，位置，语音
 **/
+ (MagicRequest *)sendmessage2:(NSString *)userid content:(NSString *)content type:(NSString *)type lng:(NSString *)lon lat:(NSString *)lat address:(NSString *)address speech_length:(NSString *)speech_length isAlert:(BOOL)isAlert receive:(id)receive;


//共享给我的
+ (MagicRequest *)share_formelist_target:(NSString *)target order:(NSString *)order  num:(NSString *)num page:(NSString *)page keyword:(NSString *)keyword asc:(NSString *)asc  isAlert:(BOOL)isAlert receive:(id)receive;

//我的共享给别人的
+ (MagicRequest *)share_frommelist:(NSString *)doc num:(NSString *)num page:(NSString *)page keyword:(NSString *)keyword asc:(NSString *)asc  isAlert:(BOOL)isAlert receive:(id)receive;

//转存
+ (MagicRequest *)document_changestore_from_id:(NSString *)from_id doc_from:(NSString *)doc_from doc_to:(NSString *)doc_to type:(NSString *)type isAlert:(BOOL)isAlert receive:(id)receive;


//公共资源
+ (MagicRequest *)document_public_order:(NSString *)order num:(NSString *)num page:(NSString *)page  keyword:(NSString *)keyword asc:(NSString *)asc isAlert:(BOOL)isAlert receive:(id)receive;


//资料库容量
+ (MagicRequest *)document_userspace:(BOOL)isAlert receive:(id)receive;

//资料库好友列表
+ (MagicRequest *)source_friendlist_doc:(NSString *)doc isAlert:(BOOL)isAlert receive:(id)receive;


//资料库班级列表
+ (MagicRequest *)source_classlist_doc:(NSString *)doc isAlert:(BOOL)isAlert receive:(id)receive;

//共享给学院
+ (MagicRequest *)source_departmentlist_isAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)document_estimate_id:(NSString *)_id type:(NSString *)type isAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)document_publicreport_oid:(NSString *)oid type:(NSString *)type reason:(NSString *)reason
  isAlert:(BOOL)isAlert receive:(id)receive;


+ (MagicRequest *)document_move_name:(NSString *)name old_dir:(NSString *)old_dir new_dir:(NSString *)new_dir isAlert:(BOOL)isAlert receive:(id)receive;


// 活动接口
+ (MagicRequest *)active_detail:(NSString *)active_id isAlert:(BOOL)isAlert receive:(id)receive;


//发活动动态
+ (MagicRequest *)active_addfeed:(NSString *)content active_id:(NSString *)active_id isAlert:(BOOL)isAlert receive:(id)receive;

//活动动态列表接口
+ (MagicRequest *)active_feedlist:(NSString *)active_id last_id:(NSString *)last_id num:(NSString *)num page:(NSString *)page isAlert:(BOOL)isAlert receive:(id)receive;

// 活动操作
+ (MagicRequest *)active_action:(NSString *)active_id action:(NSString*)action op:(NSString*)op isAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)notes_listByKeywords:(NSString *)keywords tagid:(NSString *)tagid/*标签ID*/ favorite:(NSString *)favorite/*1.搜索|星标笔记 0 默认 全部*/ page:(NSString *)page num:(NSString *)num searchmonth:(NSString *)searchmonth delnum:(NSString *)delnum isAlert:(BOOL)isAlert receive:(id)receive ;

//笔记标签列表
+ (MagicRequest *)notes_taglist:(NSString *)keywords showcount:(NSString *)showcount page:(NSString *)page num:(NSString *)num isAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)notes_addfavorite:(NSString *)nid isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)notes_delfavorite:(NSString *)nid isAlert:(BOOL)isAlert receive:(id)receive;
// 笔记设置
+ (MagicRequest *)notes_setting:(BOOL)isAlert receive:(id)receive;
// 共享给我的
+ (MagicRequest *)notes_sharenotelist:(NSString *)page num:(NSString *)num keywords:(NSString *)keywords isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)notes_mysharelist:(NSString *)page num:(NSString *)num keywords:(NSString *)keywords isAlert:(BOOL)isAlert receive:(id)receive;
+ (MagicRequest *)notes_delnote:(NSString *)nid isAlert:(BOOL)isAlert receive:(id)receive ;
+ (MagicRequest *)notes_sharenote:(NSString *)nid to_userid:(NSString *)to_userid/*1,2,3,4*/ isAlert:(BOOL)isAlert receive:(id)receive ;
// 保存共享笔记
+ (MagicRequest *)notes_savesharenote:(NSString *)shareid nid:(NSString *)nid isAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)notes_dumpnote:(NSString *)nid del:(NSString *)del isAlert:(BOOL)isAlert receive:(id)receive;
// 取消共享
+ (MagicRequest *)notes_delsharenote:(NSString *)shareid isAlert:(BOOL)isAlert receive:(id)receive;
// 删除标签
+ (MagicRequest *)notes_deltag:(NSString *)tag_id isAlert:(BOOL)isAlert receive:(id)receive;
// 新建标签
+ (MagicRequest *)notes_addtag:(NSString *)tag isAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)notes_detail:(NSString *)nid isAlert:(BOOL)isAlert receive:(id)receive ;

//唯一标示符
+ (MagicRequest *)security_authtag:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)notes_addnoteBylng:(NSString *)lng lat:(NSString *)lat address:(NSString *)address title:(NSString *)title content:(NSString *)content tagid:(NSString *)tagid/*标签id:"1,2,3,4"*/ isAlert:(BOOL)isAlert receive:(id)receive ;
+ (MagicRequest *)notes_uploadfile:(NSString *)nid duration:(NSString *)duration/*音频文件时长*/ isAlert:(BOOL)isAlert receive:(id)receive ;
+ (MagicRequest *)notes_delfile:(NSString *)fid isAlert:(BOOL)isAlert receive:(id)receive ;
+ (MagicRequest *)notes_editnote:(NSString *)nid content:(NSString *)content tagid:(NSString *)tagid/*标签id:"1,2,3,4"*/ isAlert:(BOOL)isAlert receive:(id)receive ;

+ (MagicRequest *)wosLongin_nickName:(NSString *)nickname passwd:(NSString *)passwd sAlert:(BOOL)isAlert receive:(id)receive ;

+ (MagicRequest *)wosRegion_nickName:(NSString *)nickName passwd:(NSString *)passwd sex:(NSString *)sex sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosgoodFood_typeIndex:(NSString *)typeIndex  orderBy:(NSString *)orderBy  page:(NSString *)page count:(NSString *)count orderType:(NSString *)orderType sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosKitchenInfo_kitchenIndex :(NSString *)kitchenIndex   userIndex :(NSString *)userIndex   hotFoodCount :(NSString *)hotFoodCount sAlert:(BOOL)isAlert receive:(id)receive;


+ (MagicRequest *)wosKitchenInfo_favorite_userIndex:(NSString *)userIndex  kitchenIndex  :(NSString *)kitchenIndex sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosKitchenInfo_commentkitchenlist:(NSString *)kitchenIndex starLevel:(NSString *)starLevel page :(NSString *)page count:(NSString *)count sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosKitchenInfo_foodlist:(NSString *)kitchenIndex sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosKitchenInfo_commentadd:(NSString *)commentFor orderIndex :(NSString *)orderIndex userIndex :(NSString *)userIndex commentType :(NSString *)commentType starLevel :(NSString *)starLevel comment:(NSString *)comment sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosKitchenInfo_searchKitch_keywords :(NSString *)keywords  page  :(NSString *)page  count  :(NSString *)count sAlert:(BOOL)isAlert receive:(id)receive;


+ (MagicRequest *)wosKitchenInfo_medeals_userIndex:(NSString *)userIndex kitchenIndex:(NSString *)kitchenIndex sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosKitchenInfo_orderadd_userIndex:(NSString *)userIndex kitchenIndex:(NSString *)kitchenIndex userAddrIndex:(NSString *)userAddrIndex persons:(NSString *)persons remarks:(NSString *)remarks dealsIndexs:(NSString *)dealsIndexs foodIndexs:(NSString *)foodIndexs countIndexs:(NSString *)countIndexs sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosKitchenInfo_addrList_userIndex:(NSString *)userIndex page:(NSString *)page count:(NSString *)count sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosKitchenInfo_addrAdd_userIndex:(NSString *)userIndex receiverAddress:(NSString *)receiverAddress receiverName:(NSString *)receiverName receiverPhoneNo:(NSString *)receiverPhoneNo sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosKitchenInfo_favoriteList_userIndex:(NSString *)userIndex page:(NSString *)page count:(NSString *)count sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosKitchenInfo_activityList_count:(NSString *)count sAlert:(BOOL)isAlert receive:(id)receive;


+ (MagicRequest *)wosKitchenInfo_orderList_userIndex:(NSString *)userIndex page:(NSString *)page count:(NSString *)count status :(NSString *)status sAlert:(BOOL)isAlert receive:(id)receive;


+ (MagicRequest *)wosKitchenInfo_activityInfo_Index:(NSString *)index  sAlert:(BOOL)isAlert receive:(id)receive;


+ (MagicRequest *)wosMapList_userIndex:(NSString *)userIndex gps:(NSString *)gps radius :(NSString *)radius type :(NSString *)type sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosFoodInfo_foodIndex:(NSString *)foodIndex sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosFoodInfo_foodDiscount_kitchenIndex :(NSString *)kitchenIndex discountDay  :(NSString *)discountDay  page  :(NSString *)page  count  :(NSString *)count sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosFoodInfo_guessList_userIndex :(NSString *)userIndex  page  :(NSString *)page  count  :(NSString *)count sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosFoodInfo_allInfo_userIndex :(NSString *)userIndex sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosFoodInfo_addressDel_userIndex :(NSString *)userIndex addrIndex :(NSString *)addrIndex sAlert:(BOOL)isAlert receive:(id)receive;


+ (MagicRequest *)wosFoodInfo_orderinfo_userIndex :(NSString *)userIndex orderIndex  :(NSString *)orderIndex sAlert:(BOOL)isAlert receive:(id)receive;

+ (MagicRequest *)wosFoodInfo_calculate_userIndex:(NSString *)userIndex kitchenIndex:(NSString *)kitchenIndex foodIndexs:(NSString *)foodIndexs  countIndexs:(NSString *)countIndexs sAlert:(BOOL)isAlert receive:(id)receive;
@end
