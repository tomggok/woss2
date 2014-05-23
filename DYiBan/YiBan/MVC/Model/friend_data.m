//
//  friend_data.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-22.
//
//

#import "friend_data.h"

@implementation friend_data
@synthesize havenext;
@synthesize user_list;

- (void)dealloc
{
    RELEASE(havenext);
    RELEASE(user_list);
    [super dealloc];
}
@end
