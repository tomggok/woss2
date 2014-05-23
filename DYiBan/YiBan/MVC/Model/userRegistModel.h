//
//  userRegistModel.h
//  DYiBan
//
//  Created by Song on 13-8-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface userRegistModel : MagicJSONReflection
@property (nonatomic, retain)NSString *registMail;//注册邮箱
@property (nonatomic, retain)NSString *registName;//注册昵称
@property (nonatomic, retain)NSString *registSex;//注册性别
@property (nonatomic, retain)NSString *registSchool;//注册学校
@property (nonatomic, retain)NSString *registTureName;//注册真实姓名
@property (nonatomic, retain)NSString *registCodeNum;//注册有效编号
@property (nonatomic, retain)NSString *registPhoneNum;//注册学校
@property (nonatomic, retain)NSString *registPassword;//注册密码
@property (nonatomic, retain)NSString *registIsNew;//注册是否是新生通道 1是 0 不是
@property (nonatomic, retain)NSString *registcert_key;//注册key
@property (nonatomic, retain)NSString *registver_code;//注册code

@end
