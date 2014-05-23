//
//  user_list.m
//  Yiban
//
//  Created by tom zeng on 12-11-16.
//
//

#import "user_list.h"

@implementation user_list
@synthesize user;
//+(Class)user_class{
//    return NSClassFromString(@"user");
//}
- (void)dealloc
{
    RELEASE(user);
    [super dealloc];
}
@end
