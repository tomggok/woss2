//
//  sign_user.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-29.
//
//

#import "sign_user.h"

@implementation sign_user

@synthesize desc;
@synthesize fullname;
@synthesize is_vip;
@synthesize name;
@synthesize pic;
@synthesize pic_b;
@synthesize sex;
@synthesize truename;
@synthesize userid;
@synthesize usertype;
@synthesize verify;
@synthesize user;


- (void)dealloc
{
    RELEASE(desc);
    RELEASE(fullname);
    RELEASE(is_vip);
    RELEASE(name);
    RELEASE(pic);
    RELEASE(pic_b);
    RELEASE(sex);
    RELEASE(truename);
    RELEASE(userid);
    RELEASE(usertype);
    RELEASE(verify);
    RELEASE(user);
    [super dealloc];
}

@end
