//
//  security_cert.h
//  DYiBan
//
//  Created by Song on 13-8-29.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"

@interface security_cert : MagicJSONReflection
@property (nonatomic, retain)NSString *verified;//通过认证标示
@property (nonatomic, retain)NSString *authcode;//是否需要出现认证码认证 0是1否
@end
