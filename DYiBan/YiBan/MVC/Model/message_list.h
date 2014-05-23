//
//  message_list.h
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import <Foundation/Foundation.h>
//#import "Jastor.h"

//私信列表message_contact

@interface message_list : MagicJSONReflection
@property(assign,nonatomic)int havenext;
@property(retain,nonatomic)NSArray * contact;
//+(Class)contact_class;
@end
