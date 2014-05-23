//
//  recommendfriend.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-25.
//
//

#import "recommendfriend.h"

@implementation recommendfriend

@synthesize canfriend;
@synthesize distance;
@synthesize id;
@synthesize is_vip;
@synthesize isfollow;
@synthesize isfriend;
@synthesize lng;
@synthesize lat;
@synthesize name;
@synthesize pic;
@synthesize pic_b;
@synthesize sex;
@synthesize truename;
@synthesize relation_desc;
@synthesize fullname;
@synthesize user_college;
@synthesize user_schoolid;
@synthesize userid;
@synthesize user_schoolname;
@synthesize usertype;


- (void)dealloc
{
    RELEASE(canfriend);
    RELEASE(distance);
    RELEASE(is_vip);
    RELEASE(isfollow);
    RELEASE(isfriend);
    RELEASE(lng);
    RELEASE(lat);
    RELEASE(name);
    RELEASE(pic);
    RELEASE(pic_b);
    RELEASE(sex);
    RELEASE(truename);
    RELEASE(fullname);
    RELEASE(relation_desc);
    RELEASE(user_college);
    RELEASE(user_schoolid);
    RELEASE(user_schoolname);
    RELEASE(userid);
    RELEASE(usertype);
    
    
    [super dealloc];
}
@end
