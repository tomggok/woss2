//
//  security_cert.m
//  DYiBan
//
//  Created by Song on 13-8-29.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "security_cert.h"

@implementation security_cert
@synthesize verified,authcode;

- (void)dealloc {
    
    RELEASE(verified);
    RELEASE(authcode);
    [super dealloc];
}
@end
