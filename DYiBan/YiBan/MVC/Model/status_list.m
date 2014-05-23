//
//  status_list.m
//  Magic
//
//  Created by tom zeng on 12-11-10.
//
//

#import "status_list.h"

@implementation status_list
@synthesize status;
@synthesize havenext;
@synthesize new_count;
//+(Class)status_class{
//    return NSClassFromString(@"status");
//}

- (void)dealloc
{
    RELEASE(status);
    RELEASE(new_count);
    [super dealloc];
}
@end
