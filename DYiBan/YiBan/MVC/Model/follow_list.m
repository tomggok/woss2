//
//  follow_list.m
//  Yiban
//
//  Created by Hyde.Xu on 13-4-18.
//
//

#import "follow_list.h"

@implementation follow_list
@synthesize content;
@synthesize from;
@synthesize id;
@synthesize time;
@synthesize user;
@synthesize username,target;

- (void)dealloc{
    
    RELEASE(content);
    RELEASE(from);
    RELEASE(time);
    RELEASE(user);
    RELEASE(username);
    RELEASE(target);
    
    [super dealloc];
}

@end
