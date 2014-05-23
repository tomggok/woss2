//
//  message_list.m
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import "message_list.h"

@implementation message_list
@synthesize havenext;
@synthesize contact;
//+(Class)contact_class{
//    return NSClassFromString(@"contact");
//}

- (void)dealloc
{
    RELEASE(contact);
    [super dealloc];
}
@end
