//
//  user_recommendlist_data.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-20.
//
//

#import "user_recommendlist_data.h"

@implementation user_recommendlist_data
@synthesize user_list;

- (void)dealloc
{
    RELEASE(user_list);
    [super dealloc];
}
@end
