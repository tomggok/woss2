//
//  addfriendReq.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-26.
//
//

#import "addfriendReq.h"

@implementation addfriendReq
@synthesize req;

- (void)dealloc
{
    RELEASE(req);
    [super dealloc];
}
@end
