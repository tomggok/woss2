//
//  eclass_detail_list.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-22.
//
//

#import "eclass_detail_list.h"

@implementation eclass_detail_list
@synthesize havenext;
@synthesize user_list;
@synthesize eclass;

- (void)dealloc
{
    RELEASE(eclass);
    RELEASE(havenext);
    RELEASE(user_list);
    [super dealloc];
}
@end
