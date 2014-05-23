//
//  albums.m
//  Yiban
//
//  Created by NewM on 12-11-22.
//
//

#import "albums.h"

@implementation albums
@synthesize id,pic_b,pic_s,time,userid,username;

- (void)dealloc
{
    RELEASE(pic_b);
    RELEASE(pic_s);
    RELEASE(time);
    RELEASE(userid);
    RELEASE(username);
    [super dealloc];
}
@end
