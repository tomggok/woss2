//
//  userRegistModel.m
//  DYiBan
//
//  Created by Song on 13-8-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "userRegistModel.h"

@interface userRegistModel ()

@end

@implementation userRegistModel

@synthesize registCodeNum,registMail,registName,registPhoneNum,registSchool,registSex,registTureName,registPassword,registIsNew,registcert_key,registver_code;

- (void)dealloc
{
    RELEASE(registCodeNum);
    RELEASE(registMail);
    RELEASE(registPassword);
    RELEASE(registSex);
    RELEASE(registName);
    RELEASE(registPhoneNum);
    RELEASE(registSchool);
    RELEASE(registTureName);
    RELEASE(registIsNew);
    RELEASE(registcert_key);
    RELEASE(registver_code);
    [super dealloc];
}


@end
