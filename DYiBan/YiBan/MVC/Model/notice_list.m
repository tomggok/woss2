//
//  notice_list.m
//  Magic
//
//  Created by 周 哲 on 12-11-6.
//
//

#import "notice_list.h"

@implementation notice_list
@synthesize havenext;
@synthesize chat;
//+(Class)chat_class{
//    return NSClassFromString(@"chat");
//}
- (void)dealloc
{
    RELEASE(chat);
    [super dealloc];
}
@end
