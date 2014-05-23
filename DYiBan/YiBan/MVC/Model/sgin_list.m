//
//  sign_list.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-29.
//
//

#import "sgin_list.h"

@implementation sgin_list
@synthesize address;
@synthesize from;
@synthesize id;
@synthesize lat;
@synthesize lng;
@synthesize time;
@synthesize user;

- (void)dealloc
{
    RELEASE(address);
    RELEASE(from);
    RELEASE(lat);
    RELEASE(lng);
    RELEASE(time);
    RELEASE(user);
    [super dealloc];
}
@end
