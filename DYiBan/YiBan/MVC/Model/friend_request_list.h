//
//  friend_request_list.h
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import <Foundation/Foundation.h>
#import "reqlist.h"
//#import "Jastor.h"

@interface friend_request_list : MagicJSONReflection
@property(assign,nonatomic)int  havenext;
@property(retain,nonatomic) NSArray *reqlist;
//+(Class)reqlist_class;
@end
