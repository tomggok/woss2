//
//  status_comments.h
//  Yiban
//
//  Created by tom zeng on 12-11-21.
//
//

//#import "Jastor.h"
#import "user.h"
@interface comment : MagicJSONReflection
@property (nonatomic,retain)NSString *username;// 动态产生昵称+真名字符串
@property(nonatomic,assign)int id; //评论id
@property (nonatomic,retain)NSString *content;//评论内容，如果没有返回为空
@property(nonatomic,retain)NSString* time;//评论产生时间
@property(nonatomic,retain)user *user;//评论产生人数据结构
@end
