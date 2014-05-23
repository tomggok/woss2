//
//  Tag.h
//  DYiBan
//
//  Created by zhangchao on 13-10-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"

//笔记的标签
@interface Tag : MagicJSONReflection

@property (nonatomic, retain) NSString *nid;//所在笔记的ID
@property (nonatomic, retain) NSString *tag;//内容
@property (nonatomic, retain) NSString *tag_id;

@end
