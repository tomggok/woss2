//
//  status_notice.h
//  Yiban
//
//  Created by tom zeng on 12-11-27.
//
//

//#import "Jastor.h"
#import "user.h"
@interface notice : MagicJSONReflection
@property(assign,nonatomic)int id;
@property(nonatomic,retain)NSString* time;
@property(retain,nonatomic)user *user;
@end


