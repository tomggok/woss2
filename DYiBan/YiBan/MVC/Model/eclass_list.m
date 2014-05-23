//
//  eclass_list.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-21.
//
//

#import "eclass_list.h"

@implementation eclass_list
@synthesize eclass;

//+(Class)eclass_class{
//    return NSClassFromString(@"eclasses");
//}
- (void)dealloc
{
    RELEASE(eclass);
    [super dealloc];
}
@end
