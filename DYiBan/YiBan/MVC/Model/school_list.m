//
//  school_list.m
//  Yiban
//
//  Created by NewM on 12-12-10.
//
//

#import "school_list.h"

@implementation school_list
@synthesize cert_key,cert_name,eclasses,hasData,id,name;

- (void)dealloc
{
    RELEASE(cert_key);
    RELEASE(cert_name);
    RELEASE(hasData);
    RELEASE(name);
    RELEASE(eclasses);
    [super dealloc];
}
@end
