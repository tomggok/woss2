//
//  status_detail_comment.m
//  Yiban
//
//  Created by Hyde.Xu on 13-4-15.
//
//

#import "status_detail_comment.h"

@implementation status_detail_comment
@synthesize comment;
@synthesize havenext;
@synthesize is_exit;
@synthesize comment_num;
@synthesize follow_num;
@synthesize good_num;

- (void)dealloc{
    RELEASE(comment);
    RELEASE(havenext);
    RELEASE(is_exit);
    RELEASE(comment_num);
    RELEASE(follow_num);
    RELEASE(good_num);
        
    [super dealloc];
}

@end
