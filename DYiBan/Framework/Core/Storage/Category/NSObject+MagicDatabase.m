//
//  NSObject+MagicDatabase.m
//  MagicFramework
//
//  Created by NewM on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "NSObject+MagicDatabase.h"

@implementation NSObject (MagicDatabase)

+ (MagicDatabase *)DB
{
    MagicDatabase *db = [MagicDatabase sharedDatabase];
    
    if (!db) {
        NSBundle * bundle = [NSBundle mainBundle];
		NSString * bundleName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];//项目名
		if ( bundleName )
		{
			NSString * dbName = [NSString stringWithFormat:@"%@.db", bundleName];
			BOOL succeed = [MagicDatabase openSharedDatabase:dbName];
			if ( succeed )
			{
				db = [MagicDatabase sharedDatabase];
			}
		}
        
		if ( db )
		{
			[db clearState];
		}
    }
    return db;
}

- (MagicDatabase *)DB
{
    return [NSObject DB];
}

- (NSString *)tableName
{
    return [[self class] tableName];
}

+ (NSString *)tableName
{
    return [MagicDatabase tableNameForClass:self];
}
@end
