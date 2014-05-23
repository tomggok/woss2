//
//  album_list_one.m
//  Yiban
//
//  Created by NewM on 12-11-22.
//
//

#import "album_list_all.h"

@implementation album_list_all
@synthesize havenext,album_list;
- (void)dealloc
{
    RELEASE(havenext);
    RELEASE(album_list);
    [super dealloc];
}
@end
