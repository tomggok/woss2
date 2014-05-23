//
//  comment_num_info.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-10.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"
#import "target.h"

@interface comment_num_info : MagicJSONReflection

@property (nonatomic,retain) NSString *id;
@property (nonatomic,retain) NSString *uid;
@property (nonatomic,retain) NSString *totid;
@property (nonatomic,retain) NSString *touid;
@property (nonatomic,retain) NSString *tousername;
@property (nonatomic,retain) NSString *tocontent;
@property (nonatomic,retain) target *target;
@property (nonatomic,retain) NSString *dateline;
@property (nonatomic,retain) NSString *kind;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *pic;
@property (nonatomic,retain) NSString *comment;

@end
