//
//  guest_list.m
//  Yiban
//
//  Created by NewM on 12-11-27.
//
//

#import "guest_list.h"
#import "user.h"
@implementation guest_list
@synthesize time,user;

- (void)dealloc
{
//    RELEASE(user);
    RELEASE(user);
    RELEASE(time);
    
    [super dealloc];
}
@end
