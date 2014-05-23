//
//  target.m
//  Magic
//
//  Created by tom zeng on 12-11-10.
//
//

#import "target.h"

@implementation target

@synthesize type;
@synthesize targetid;
@synthesize targetlink;
@synthesize targetname;
@synthesize id;

- (void)dealloc
{
    RELEASE(type);
    RELEASE(targetid);
    RELEASE(targetlink);
    RELEASE(targetname);
    [super dealloc];
}
@end
