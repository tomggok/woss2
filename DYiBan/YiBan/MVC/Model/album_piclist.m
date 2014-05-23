//
//  album_piclist.m
//  Yiban
//
//  Created by NewM on 12-11-22.
//
//

#import "album_piclist.h"

@implementation album_piclist
@synthesize albums,havenext;

//+(Class)albums_class{
//    return NSClassFromString(@"albums");
//}
- (void)dealloc
{
    RELEASE(albums);
    RELEASE(havenext);
    [super dealloc];
}
@end
