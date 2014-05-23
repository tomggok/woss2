//
//  Review.h
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import <Foundation/Foundation.h>
#import "mc.h"
//#import "Jastor.h"

//评论 at 提醒列表message_at
@interface Review : MagicJSONReflection
@property (assign,nonatomic) int havenext;//是否有下一页
@property (assign,nonatomic) int new_count;//新消息数量
@property (retain,nonatomic) NSArray *mc;// 评论提醒列表
//+(Class)mc_class;
@end
