//
//  user_avatardolist.h
//  DYiBan
//
//  Created by zhangchao on 13-9-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

//user_avatardolist接口返回的数据
@interface user_avatardolist : MagicJSONReflection

@property (nonatomic, retain)NSString *topCount;//顶的次数
@property (nonatomic, retain)NSString *pics;//
@property (nonatomic, retain)NSString *username;
@property (nonatomic, retain)NSString *treadCount;
@property (nonatomic, retain)NSString *userid;
@property (nonatomic, retain)NSString *lastTreadTime;
@property (nonatomic, retain)NSString *lastTopTime;

@end
