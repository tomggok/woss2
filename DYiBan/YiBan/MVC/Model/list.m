//
//  YiBanApp.m
//  Yiban
//
//  Created by Hyde.Xu on 13-1-7.
//
//

#import "list.h"

@implementation list

@synthesize app_icon;
@synthesize app_type;
@synthesize name;
@synthesize installed_count;
@synthesize schemes_url;
@synthesize store_url;
@synthesize tip_type;
@synthesize app_category;


- (void)dealloc
{
    RELEASE(store_url);
    RELEASE(schemes_url);
    RELEASE(name);
    RELEASE(app_icon);
    [super dealloc];
}

@end
