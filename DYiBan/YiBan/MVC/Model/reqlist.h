//
//  reqlist.h
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import <Foundation/Foundation.h>
//#import "Jastor.h"
#import "user.h"
@interface reqlist : MagicJSONReflection
@property(assign,nonatomic)int id;
@property(assign,nonatomic)int time;
@property(retain,nonatomic)NSString * content;
@property(retain,nonatomic)NSString * kind;//消息类型 1 为加好友请求 2 已同意请求 118:显示content的内容
@property(retain,nonatomic)user * user_info; 
@end
