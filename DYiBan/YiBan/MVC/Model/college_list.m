//
//  college_list.m
//  Yiban
//
//  Created by NewM on 12-11-29.
//
//

#import "college_list.h"

@implementation college_list
@synthesize id,name;

- (void)dealloc
{
    RELEASE(name);
    [super dealloc];
}
@end
