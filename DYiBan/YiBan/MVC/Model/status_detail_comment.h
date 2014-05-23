//
//  status_detail_comment.h
//  Yiban
//
//  Created by Hyde.Xu on 13-4-15.
//
//

#import <Foundation/Foundation.h>

@interface status_detail_comment : MagicJSONReflection
@property(nonatomic,retain)NSString *is_exit;//动态是否存在 0 存在 1 不存在
@property(nonatomic,retain)NSString *havenext;//是否有更多评论 0否1是
@property(nonatomic,retain)NSMutableArray *comment;//数组 评论列表 数据结构
@property(nonatomic,retain)NSString *comment_num;//动态评论数
@property(nonatomic,retain)NSString *good_num;//动态赞数
@property(nonatomic,retain)NSString *follow_num;//动态转发数

@end
