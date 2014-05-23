//
//  guest_list.h
//  Yiban
//
//  Created by NewM on 12-11-27.
//
//

//#import "Jastor.h"
//访客
@class user;
@interface guest_list : MagicJSONReflection
@property (nonatomic, retain)NSString *time;
@property (nonatomic, retain)user *user;
@end
