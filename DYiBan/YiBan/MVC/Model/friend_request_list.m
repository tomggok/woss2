//
//  friend_request_list.m
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import "friend_request_list.h"

@implementation friend_request_list
@synthesize havenext;
@synthesize reqlist;

//+(Class)reqlist_class{
//    return NSClassFromString(@"reqlist");
//}
- (void)dealloc
{
    RELEASE(reqlist);
    [super dealloc];
}
@end

