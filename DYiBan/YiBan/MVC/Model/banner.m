//
//  bannerMode.m
//  Yiban
//
//  Created by tom zeng on 13-1-14.
//
//

#import "banner.h"

@implementation banner
@synthesize type;//id,title,target_id,target_type,banner_img,end_time,url;
@synthesize id;
@synthesize target_id;
@synthesize target_type;
@synthesize banner_img;
@synthesize end_time;
@synthesize url;
@synthesize title;


- (void)dealloc
{
    RELEASE(type);
    RELEASE(title);
    RELEASE(target_id);
    RELEASE(target_type);
    RELEASE(url);
    RELEASE(banner_img);
    RELEASE(end_time);
    [super dealloc];
}
@end
