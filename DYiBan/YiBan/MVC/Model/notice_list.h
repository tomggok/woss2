//
//  notice_list.h
//  Magic
//
//  Created by 周 哲 on 12-11-6.
//
//

#import <Foundation/Foundation.h>
//#import "Jastor.h"
@interface notice_list : MagicJSONReflection
@property(assign,nonatomic)int havenext;
@property(retain,nonatomic)NSMutableArray * chat;
//+(Class)chat_class;
@end
