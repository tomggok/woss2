//
//  status_detail_other.m
//  Yiban
//
//  Created by Hyde.Xu on 13-4-17.
//
//

#import "status_detail_other.h"

@implementation status_detail_other
@synthesize havenext;
@synthesize action_list;
@synthesize good_num;

- (void)dealloc{
    RELEASE(havenext);
    RELEASE(user_list);
    RELEASE(good_num);
    
    [super dealloc];
}
@end
