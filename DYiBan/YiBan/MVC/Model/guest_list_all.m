//
//  guest_list_all.m
//  Yiban
//
//  Created by NewM on 12-11-27.
//
//

#import "guest_list_all.h"

@implementation guest_list_all
@synthesize guest_list;

- (void)dealloc
{
    RELEASE(guest_list);
    [super dealloc];
}
@end
