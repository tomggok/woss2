//
//  friend_data.h
//  Yiban
//
//  Created by Hyde.Xu on 12-11-22.
//
//

//#import "Jastor.h"
#import "friends_list.h"

@interface friend_data : MagicJSONReflection
@property(nonatomic,retain)NSString* havenext;
@property(nonatomic,retain)friends_list* user_list;
@end
