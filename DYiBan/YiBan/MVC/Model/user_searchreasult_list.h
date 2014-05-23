//
//  user_searchreasult_list.h
//  Yiban
//
//  Created by Hyde.Xu on 12-11-25.
//
//

//#import "Jastor.h"
#import "recommend_list.h"

@interface user_searchreasult_list : MagicJSONReflection
@property(nonatomic,retain)NSString *havenext;
@property(nonatomic,retain)recommend_list* user_list;

@end
