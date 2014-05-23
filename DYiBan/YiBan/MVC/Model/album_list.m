//
//  album_list.m
//  Yiban
//
//  Created by NewM on 12-11-22.
//
//

#import "album_list.h"

@implementation album_list
@synthesize pic,id,name,pic_num;

- (void)dealloc
{
    RELEASE(pic);
    RELEASE(name);
    RELEASE(pic_num);
    [super dealloc];
}
@end
