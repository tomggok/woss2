//
//  friends.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-22.
//
//

#import "friends.h"

@implementation friends

@synthesize canfriend;
@synthesize desc;
@synthesize distance;
@synthesize id;
@synthesize is_vip;
@synthesize isfollow;
@synthesize isfriend;
@synthesize lng;
@synthesize lat;
@synthesize name;
@synthesize phone;
@synthesize pic;
@synthesize sex;
@synthesize truename;
@synthesize verify;
@synthesize relation_desc,is_shared;

- (void)dealloc
{
//    [userid release];
    RELEASE(is_shared);
    RELEASE(canfriend);
    RELEASE(desc);
    RELEASE(distance);
    RELEASE(is_vip);
    RELEASE(isfollow);
    RELEASE(isfriend);
    RELEASE(lng);
    RELEASE(lat);
    RELEASE(name);
    RELEASE(phone);
    RELEASE(pic);
    RELEASE(sex);
    RELEASE(truename);
    RELEASE(verify);
    RELEASE(relation_desc);
    
    [super dealloc];
}

@end
