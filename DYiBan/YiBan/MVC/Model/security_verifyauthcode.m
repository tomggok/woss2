//
//  security_verifyauthcode.m
//  Yiban
//
//  Created by NewM on 12-12-10.
//
//

#import "security_verifyauthcode.h"

@implementation security_verifyauthcode
@synthesize login_name,userid,verifyed;

- (void)dealloc
{
    RELEASE(login_name);
    RELEASE(userid);
    RELEASE(verifyed);
    [super dealloc];
}
@end
