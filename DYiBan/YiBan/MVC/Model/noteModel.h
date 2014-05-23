//
//  noteModel.h
//  DYiBan
//
//  Created by zhangchao on 13-10-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"
#import "notesUserinfo.h"
#import "file_list.h"
#import "tag_list_info.h"

@interface noteModel : MagicJSONReflection

@property (nonatomic, retain) NSString *nid;
@property (nonatomic, retain) NSString *lng;//经度
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *create_time;
@property (nonatomic, retain) NSString *update_time;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *favorite;//是否收藏  1收藏 0未收藏
@property (nonatomic, retain) NSString *file_type;//笔记中存在：1.图片 2.音频 3.文档 4.其他文件
@property (nonatomic, retain) NSArray *taglist;//标签数组
@property (nonatomic, retain) NSString *user_id;//绑定的用户ID
@property (nonatomic, assign) int type;//-1: 月份cell的model ;-2:以下是*月之前的所有笔记 cell; -3:完全未请求到日历数据 0 :noteModel的cell的model;1:noteShare的cell的model; -4:标签cell -5:笔记详情页的文本cell
@property (nonatomic, assign) int cellH;//默认Cell的高
@property (nonatomic, retain) NSString *str_CalendarContent;//无数据提示cell要显示的内容
@property (nonatomic, retain) NSArray *file_list;//文件数据
@property (nonatomic, assign) int _state;//0:默认非编辑  1:编辑状态
@property (nonatomic, retain) NSString *content;//
@property (nonatomic, retain) NSString *share_time;//共享时间
@property (nonatomic, retain) NSArray *share_user_list;//共享对象
@property (nonatomic, retain) notesUserinfo *user_info;//笔记来源
@property (nonatomic, retain) NSString * str_UserID;//绑定的用户ID

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *to_uid;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *shareid;
@property (nonatomic, retain) notesUserinfo *userinfo;
@end
