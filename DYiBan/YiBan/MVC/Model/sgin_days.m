//
//  sgin_days.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-30.
//
//

#import "sgin_days.h"

@implementation sgin_days

@synthesize allday;
@synthesize realline;
@synthesize uid;

- (void)dealloc
{
    RELEASE(allday);
    RELEASE(realline);
    RELEASE(uid);
    [super dealloc];
}
@end
