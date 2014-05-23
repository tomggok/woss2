//
//  contact.m
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import "contact.h"

@implementation contact
@synthesize new_message;
@synthesize title;
@synthesize content;
@synthesize time;
@synthesize can_send;
@synthesize type;
@synthesize view;
@synthesize user_info;

- (void)dealloc
{
    RELEASE(new_message);
    RELEASE(title);
    RELEASE(content);
    RELEASE(time);
    RELEASE(can_send);
    RELEASE(type);
    RELEASE(user_info);
    [super dealloc];
}
@end
