//
//  Review.m
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import "Review.h"
#import "mc.h"
@implementation Review
@synthesize havenext;
@synthesize new_count;
@synthesize mc;
//+(Class)mc_class{
//    return NSClassFromString(@"mc");
//}

- (void)dealloc
{
    RELEASE(mc);
    [super dealloc];
}
@end
