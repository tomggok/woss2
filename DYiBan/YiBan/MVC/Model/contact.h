//
//  contact.h
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import <Foundation/Foundation.h>
//#import "Jastor.h"
#import "user.h"
@interface contact : MagicJSONReflection
@property(retain,nonatomic)NSString * new_message;
@property(retain,nonatomic)NSString * title;
@property(retain,nonatomic)NSString * content;
@property(retain,nonatomic)NSString * time;
@property(retain,nonatomic)NSString * can_send;
@property(retain,nonatomic)NSString * type;
@property(assign,nonatomic)int view;//是否已读 1 已读 0未读
@property(retain,nonatomic)user * user_info;
@end
