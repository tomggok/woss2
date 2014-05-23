//
//  eclass_detail_list.h
//  Yiban
//
//  Created by Hyde.Xu on 12-11-22.
//
//

//#import "Jastor.h"
#import "friends_list.h"
#import "eclasses.h"

@interface eclass_detail_list : MagicJSONReflection
@property (nonatomic, retain)eclasses *eclass;
@property (nonatomic, retain)NSString *havenext;
@property (nonatomic, retain)friends_list *user_list;

@end
