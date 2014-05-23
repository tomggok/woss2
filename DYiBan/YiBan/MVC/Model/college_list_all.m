//
//  college_list_all.m
//  Yiban
//
//  Created by NewM on 12-11-29.
//
//

#import "college_list_all.h"

@implementation college_list_all
@synthesize college_list;
//+(Class)college_list_class{
//    return NSClassFromString(@"college_list");
//}
- (void)dealloc
{
    RELEASE(college_list);
    [super dealloc];
}
@end
