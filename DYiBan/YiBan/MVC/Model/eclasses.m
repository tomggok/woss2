//
//  eclasses.m
//  Magic
//
//  Created by 周 哲 on 12-11-1.
//
//

#import "eclasses.h"

@implementation eclasses
@synthesize userid;
@synthesize name;
@synthesize active;
@synthesize id;


- (void)dealloc
{
    RELEASE(userid);
    RELEASE(name);
    RELEASE(active);
    [super dealloc];
}
@end
