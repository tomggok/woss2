//
//  Magic_JSONReflection.h
//  MagicFramework
//
//  Created by NewM on 13-3-18.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MagicProperty.h"
@interface MagicJSONReflection : NSObject
+ (id)JSONReflection:(id)data;
- (id)OJBTOJSON;
@end
