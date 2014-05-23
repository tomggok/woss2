//
//  status_comments.m
//  Yiban
//
//  Created by tom zeng on 12-11-21.
//
//

#import "comment.h"

@implementation comment
@synthesize id,username,content,time,user;

- (void)dealloc
{
    RELEASE(username);
    RELEASE(content);
    RELEASE(time);
    RELEASE(user);
    [super dealloc];
}
@end
