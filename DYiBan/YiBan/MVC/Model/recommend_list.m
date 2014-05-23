//
//  recommend_list.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-25.
//
//

#import "recommend_list.h"

@implementation recommend_list
@synthesize user;
//+(Class)user_class{
//    return NSClassFromString(@"recommendfriend");
//}
- (void)dealloc
{
    RELEASE(user);
    [super dealloc];
}

@end
