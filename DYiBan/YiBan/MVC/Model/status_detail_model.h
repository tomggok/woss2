//
//  status_detail_model.h
//  Yiban
//
//  Created by tom zeng on 12-11-21.
//
//

#import <Foundation/Foundation.h>
//#import "Jastor.h"
#import "status.h"
#import "comment.h"
#import "user_list.h"
@interface status_detail_model : MagicJSONReflection
@property(nonatomic,retain)NSString *is_exit;//动态是否存在 0 存在 1 不存在
@property(nonatomic,retain)status *status;// 数据字典 博客数据结构

@property(nonatomic,retain)NSString *havenext;//是否有更多评论 0否1是

@property(nonatomic,retain)NSMutableArray *comment;//数组 评论列表 数据结构

@property(nonatomic,retain)user_list *user_list;// 数组 赞用户列表 user 数据结构
//+(Class)comment_class;
//+(Class)user_list_class;
@end
