//
//  msg_count.h
//  Magic
//
//  Created by tom zeng on 12-11-10.
//
//

#import <Foundation/Foundation.h>
//#import "Jastor.h"

//用户新信息数接口 message_count 数据模型
@interface msg_count : MagicJSONReflection

@property(nonatomic,retain)NSString *new_comment;
@property(nonatomic,retain)NSString *new_at;
@property(nonatomic,retain)NSString *new_message;
@property(nonatomic,retain)NSString *new_request;
@property(nonatomic,retain)NSString *new_notice;

@end
