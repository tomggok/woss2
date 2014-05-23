//
//  reqlist.m
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import "reqlist.h"

@implementation reqlist
@synthesize id;
@synthesize time;
@synthesize content;
@synthesize kind;
@synthesize user_info;

- (void)dealloc
{
//    RELEASE(time);
    RELEASE(content);
    RELEASE(kind);
    RELEASE(user_info);
    [super dealloc];
}
@end
