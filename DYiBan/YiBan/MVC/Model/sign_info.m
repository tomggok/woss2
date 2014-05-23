//
//  sign_info.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-29.
//
//

#import "sign_info.h"


@implementation sign_info
@synthesize is_sgin;
@synthesize sgin_list;

//+(Class)sgin_list_class{
//    return NSClassFromString(@"sign_info");
//}
- (void)dealloc
{
    RELEASE(sgin_list);
    RELEASE(is_sgin);
    [super dealloc];
}


@end
