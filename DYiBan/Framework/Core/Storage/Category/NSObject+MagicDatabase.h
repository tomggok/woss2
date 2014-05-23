//
//  NSObject+MagicDatabase.h
//  MagicFramework
//
//  Created by NewM on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Magic_Database.h"
@interface NSObject (MagicDatabase)

@property (nonatomic, readonly)MagicDatabase *DB;

+ (MagicDatabase *)DB;

- (NSString *)tableName;
+ (NSString *)tableName;
@end
