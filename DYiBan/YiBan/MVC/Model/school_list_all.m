//
//  school_list_all.m
//  Yiban
//
//  Created by NewM on 12-12-10.
//
//

#import "school_list_all.h"

@implementation school_list_all
@synthesize school_list;

//+ (Class)school_list_class{
//    return NSClassFromString(@"school_list");
//}

- (void)dealloc
{
    RELEASE(school_list);
    [super dealloc];
}
@end
