//
//  status_user_list.m
//  Yiban
//
//  Created by Hyde.Xu on 13-4-17.
//
//

#import "action_list.h"

@implementation action_list
@synthesize desc, fullname, is_vip, name, pic, pic_b, pic_s, sex, time, truename, userid, usertype, verify;

- (void)dealloc{
    
    RELEASE(desc);
    RELEASE(fullname);
    RELEASE(is_vip);
    RELEASE(name);
    RELEASE(desc);
    RELEASE(pic);
    RELEASE(pic_b);
    RELEASE(pic_s);
    RELEASE(sex);
    RELEASE(time);
    RELEASE(truename);
    RELEASE(userid);
    RELEASE(usertype);
    RELEASE(verify);
    
    [super dealloc];
}

@end
