//
//  tags.m
//  Magic
//
//  Created by tom zeng on 12-11-10.
//
//

#import "tags.h"

@implementation tags
@synthesize id;
@synthesize color;
- (void)dealloc
{
    RELEASE(color);
    [super dealloc];
}
@end
