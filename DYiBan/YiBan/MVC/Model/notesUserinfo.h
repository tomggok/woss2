//
//  notesUserinfo.h
//  DYiBan
//
//  Created by Song on 13-10-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"

@interface notesUserinfo : MagicJSONReflection
@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *nick;
@property (nonatomic, retain) NSString *pic;
@property (nonatomic, retain) NSString *sex;
@property (nonatomic, retain) NSString *verify;
@property (nonatomic, retain) NSString *kind;
@property (nonatomic, retain) NSString *userkind;
@property (nonatomic, retain) NSString *nature;
@end
