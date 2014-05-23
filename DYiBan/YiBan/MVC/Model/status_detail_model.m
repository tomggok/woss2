//
//  status_detail_model.m
//  Yiban
//
//  Created by tom zeng on 12-11-21.
//
//

#import "status_detail_model.h"
@implementation status_detail_model 
@synthesize is_exit,havenext,comment,user_list,status;
//+(Class)comment_class{
//    return  NSClassFromString(@"status_comment");
//}
//+(Class)user_list_class{
//    return NSClassFromString(@"user");
//}

- (void)dealloc
{
    RELEASE(comment);
    RELEASE(is_exit);
    RELEASE(havenext);
    RELEASE(user_list);
    RELEASE(status);
    [super dealloc];
}
@end
