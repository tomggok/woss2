//
//  eclass_notice.h
//  DYiBan
//
//  Created by zhangchao on 13-8-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"
#import "target.h"

//班级公告
@interface eclass_notice : MagicJSONReflection

@property (nonatomic, retain)NSString *id;//公告ID
@property (nonatomic, retain)NSString *areaid;//班级ID
@property (nonatomic, retain)NSString *title;
@property (nonatomic, retain)NSString *content;
@property (nonatomic, retain)NSString *time;
@property (nonatomic, retain)NSArray *target;

@end
