//
//  Status_detail_follow.m
//  Yiban
//
//  Created by Hyde.Xu on 13-4-18.
//
//

#import "Status_detail_follow.h"

@implementation Status_detail_follow
@synthesize havenext;
@synthesize follow_list;
@synthesize comment_num;
@synthesize good_num;
@synthesize follow_num;


- (void)dealloc{
    RELEASE(follow_list);
    RELEASE(havenext);
    RELEASE(comment_num);
    RELEASE(good_num);
    RELEASE(follow_num);
    
    [super dealloc];
}
@end
