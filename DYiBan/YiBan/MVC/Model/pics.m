//
//  pics.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-26.
//
//

#import "pics.h"

@implementation pics
@synthesize pic;
@synthesize pic_b;
@synthesize pic_s;

- (void)dealloc
{
    RELEASE(pic);
    RELEASE(pic_s);
    RELEASE(pic_b);
    [super dealloc];
}
@end
