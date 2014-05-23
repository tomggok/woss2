//
//  tag_list.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"

@interface tag_list : MagicJSONReflection

@property (nonatomic, retain) NSString *allpages;
@property (nonatomic, retain) NSString *havenext;
@property (nonatomic, retain) NSArray *result;

@end
