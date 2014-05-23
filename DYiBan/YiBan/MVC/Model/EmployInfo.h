//
//  EmployInfo.h
//  DYiBan
//
//  Created by zhangchao on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"

//就业信息
@interface EmployInfo : MagicJSONReflection
@property (nonatomic, retain)NSString *author;
@property (nonatomic, retain)NSString *click_num;//浏览量
@property (nonatomic, retain)NSString *collect_flag;//是否已被收藏 0:否 1:是
@property (nonatomic, retain)NSString *collect_num;//收藏量
@property (nonatomic, retain)NSString *id;
@property (nonatomic, retain)NSString *pubtime;
@property (nonatomic, retain)NSString *title;
@property (nonatomic, retain)NSString *content;

@end
