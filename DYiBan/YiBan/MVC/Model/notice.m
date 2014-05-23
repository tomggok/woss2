//
//  status_notice.m
//  Yiban
//
//  Created by tom zeng on 12-11-27.
//
//

#import "notice.h"

@implementation notice
@synthesize id;
@synthesize user;
@synthesize time;

- (void)dealloc
{
   
    RELEASE(time);
    RELEASE(user);
    [super dealloc];
}
@end
