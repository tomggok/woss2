//
//  msg_count.m
//  Magic
//
//  Created by tom zeng on 12-11-10.
//
//

#import "msg_count.h"

@implementation msg_count

@synthesize new_at;
@synthesize new_comment;
@synthesize new_message;
@synthesize new_notice;
@synthesize new_request;
- (void)dealloc
{
    RELEASE(new_at);
    RELEASE(new_comment);
    RELEASE(new_message);
    RELEASE(new_notice);
    RELEASE(new_request);
    
    [super dealloc];
}
@end
