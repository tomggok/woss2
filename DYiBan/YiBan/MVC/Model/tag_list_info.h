//
//  tag_list_info.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"

@interface tag_list_info : MagicJSONReflection

@property (nonatomic, retain) NSString *count;
@property (nonatomic, retain) NSString *tag;
@property (nonatomic, retain) NSString *tag_id;
@property (nonatomic, retain) NSString *sys;
@property (nonatomic, retain) NSString *nid;//和笔记详情页的标签用一个model

@end
