//
//  version.m
//  Yiban
//
//  Created by NewM on 12-12-5.
//
//

#import "version.h"

@implementation version
@synthesize content,status,time,url,version,version_code;

- (void)dealloc
{
    RELEASE(content);
    RELEASE(status);
    RELEASE(time);
    RELEASE(url);
    RELEASE(version);
    RELEASE(version_code);
    [super dealloc];
}
@end
