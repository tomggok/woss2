//
//  user_searchreasult_list.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-25.
//
//

#import "user_searchreasult_list.h"

@implementation user_searchreasult_list
@synthesize user_list;
@synthesize havenext;

- (void)dealloc
{
    RELEASE(user_list);
    RELEASE(havenext);
    [super dealloc];
}
@end
