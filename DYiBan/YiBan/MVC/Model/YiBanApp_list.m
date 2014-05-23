//
//  YiBanApp_list.m
//  Yiban
//
//  Created by Hyde.Xu on 13-1-7.
//
//

#import "YiBanApp_list.h"

@implementation YiBanApp_list
@synthesize list;

- (void)dealloc
{
    RELEASE(list);
    [super dealloc];
}
@end
