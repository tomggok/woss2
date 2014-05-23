//
//  bannerList.m
//  Yiban
//
//  Created by tom zeng on 13-1-14.
//
//

#import "bannerList.h"

@implementation bannerList
@synthesize banner;
//+(Class)banner_class{
//
//  return NSClassFromString(@"banner");
//}
- (void)dealloc
{
//    RELEASE(banner);
    RELEASE(banner);
    [super dealloc];
}
@end
