//
//  status_detail_other.h
//  Yiban
//
//  Created by Hyde.Xu on 13-4-17.
//
//

#import <Foundation/Foundation.h>
#import "user_list.h"

@interface status_detail_other : MagicJSONReflection
@property(nonatomic,retain)NSString *havenext;//是否有更多评论 0否1是
@property(nonatomic,retain)NSArray *action_list;//数组 评论列表 数据结构
@property(nonatomic,retain)NSString *good_num;//动态赞数

@end
