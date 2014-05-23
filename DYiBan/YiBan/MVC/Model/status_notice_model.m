//
//  status_notice_model.m
//  Yiban
//
//  Created by tom zeng on 12-11-27.
//
//

#import "status_notice_model.h"

@implementation status_notice_model
@synthesize havenext;
@synthesize notice;
@synthesize notice_num;
@synthesize response_num;
@synthesize status;
@synthesize eclass_num;

//+(Class)notice_class{
//
//    return NSClassFromString(@"status_notice_userList");
//}

- (void)dealloc
{
    RELEASE(eclass_num);
    RELEASE(notice_num);
    RELEASE(havenext);
    RELEASE(response_num);
    RELEASE(status);
    RELEASE(notice);

    [super dealloc];
}
@end
