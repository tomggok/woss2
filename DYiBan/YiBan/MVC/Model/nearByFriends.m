//
//  nearByFriends.m
//  Yiban
//
//  Created by zhangchao on 13-4-7.
//
//

#import "nearByFriends.h"

@implementation nearByFriends

@synthesize distance,lat,lng,name,pic,userid,usertype,address,time,sign_time,truename;

-(void)dealloc
{
    RELEASE(usertype);
    RELEASE(pic);
    RELEASE(name);
    RELEASE(lng);
    RELEASE(lat);
    RELEASE(distance);
    RELEASE(userid);
    RELEASE(address);
    RELEASE(time);
    RELEASE(sign_time);
    RELEASE(truename);
    
    
    [super dealloc];
}

@end
