//
//  sign_datelog.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-29.
//
//

#import "sign_datelog.h"

@implementation sign_datelog
@synthesize result;
@synthesize sign_realline;
@synthesize sgin_allday;
@synthesize sign;


- (void)dealloc
{
    RELEASE(result);
    RELEASE(sign_realline);
    RELEASE(sgin_allday);
    RELEASE(sign);
    [super dealloc];
}
@end
