//
//  active.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"

@interface active : MagicJSONReflection

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *introduction;
@property (nonatomic, retain) NSString *topics;
@property (nonatomic, retain) NSString *begin_time;
@property (nonatomic, retain) NSString *end_time;
@property (nonatomic, retain) NSString *organizer;
@property (nonatomic, retain) NSString *co_organizer;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *enabled;
@end
