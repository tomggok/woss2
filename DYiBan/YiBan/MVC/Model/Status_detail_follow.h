//
//  Status_detail_follow.h
//  Yiban
//
//  Created by Hyde.Xu on 13-4-18.
//
//

#import <Foundation/Foundation.h>

@interface Status_detail_follow : MagicJSONReflection
@property(nonatomic,retain)NSString *havenext;//是否有更多评论 0否1是
@property(nonatomic,retain)NSArray *follow_list;//数组 评论列表 数据结构
@property(nonatomic,retain)NSString *comment_num;//动态评论数
@property(nonatomic,retain)NSString *good_num;//动态赞数
@property(nonatomic,retain)NSString *follow_num;//动态转发数

@end
