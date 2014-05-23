//
//  friends_list.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-22.
//
//

#import "friends_list.h"

@implementation friends_list
@synthesize user;
//+(Class)user_class{
//    return NSClassFromString(@"friends");
//}

- (void)dealloc
{
    RELEASE(user);
    [super dealloc];
}
@end
