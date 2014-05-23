//
//  user_birthday.h
//  DYiBan
//
//  Created by zhangchao on 13-9-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户好友及同班同学生日提醒接口user_birthday 接口
@interface user_birthday : MagicJSONReflection

@property (nonatomic, retain)NSString *days;//
@property (nonatomic, retain)NSString *name;//
@property (nonatomic, retain)NSString *nick;
@property (nonatomic, retain)NSString *orderid;
@property (nonatomic, retain)NSString *userid;
@property (nonatomic, retain)NSString *username;
@property (nonatomic, retain)NSString *avatar;//头像
@property (nonatomic, retain)NSString *birtyday;//

@end
