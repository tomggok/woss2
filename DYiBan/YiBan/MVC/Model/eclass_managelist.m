//
//  MessageEclasses.m
//  Yiban
//
//  Created by tom zeng on 12-12-6.
//
//

#import "eclass_managelist.h"

@implementation eclass_managelist
@synthesize id;
@synthesize name;
- (void)dealloc
{
    RELEASE(name);
    [super dealloc];
}
@end
