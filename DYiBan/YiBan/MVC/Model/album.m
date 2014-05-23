//
//  album.m
//  Magic
//
//  Created by 周 哲 on 12-11-1.
//
//

#import "album.h"

@implementation album
@synthesize  _id;
@synthesize pic_s;
@synthesize pic_b;
@synthesize userid;

- (void)dealloc
{
    RELEASE(_id);
    RELEASE(pic_b);
    RELEASE(pic_s);
    RELEASE(userid);
    [super dealloc];
}
@end
