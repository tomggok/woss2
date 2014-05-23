//
//  MagicDatabase.h
//  MagicFramework
//
//  Created by NewM on 13-4-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+MagicProperty.h"

#import "FMDatabase.h"

@class MagicDatabase;

typedef MagicDatabase *(^MagicDataBaseBlock)(void);
typedef MagicDatabase *(^MagicDataBaseBlockN)(id key,...);
typedef MagicDatabase *(^MagicDataBaseBlockU)(NSUInteger val);


#undef DBPATH
#define DBPATH  @"Database"

@interface MagicDatabase : NSObject
{
    BOOL                    _autoOptimize;
    BOOL                    _batch;
    NSUInteger              _identifier;
    
    NSString                *_filePath;
    FMDatabase              *_database;
    
    NSMutableArray          *_select;
    BOOL                    _distinct;
    NSMutableArray          *_from;//保存数据库里所有的表名
    NSMutableArray          *_where;
    NSMutableArray          *_like;
    NSMutableArray          *_groupby;
    NSMutableArray          *_having;
    NSMutableArray          *_keys;
    NSUInteger              _limit;
    NSUInteger              _offset;
    NSMutableArray          *_orderby;
    NSMutableDictionary     *_set;//保存要插入的数据的键值
    
    NSMutableArray          *_resultArray;
    NSUInteger              _resultCount;
    NSUInteger              _lastInsertID;
    BOOL                    _lastSucceed;
    
    NSMutableArray          *_table;
    NSMutableArray          *_field;//保存每个表里的所有字段信息(字典)
    NSMutableArray          *_index;
    
    NSMutableArray          *_classType;
    NSMutableArray          *_associate;
    NSMutableArray          *_has;
}

@property (nonatomic, assign)BOOL                       autoOptimize;
@property (nonatomic, retain)NSString                   *filePath;
@property (nonatomic, readonly)NSUInteger               total;
@property (nonatomic, readonly)BOOL                     ready;
@property (nonatomic, readonly)NSUInteger               identifier;

@property (nonatomic, readonly)MagicDataBaseBlockN     TABLE;
@property (nonatomic, readonly)MagicDataBaseBlockN     FIELD;
@property (nonatomic, readonly)MagicDataBaseBlockN     FIELD_WITH_SIZE;
@property (nonatomic, readonly)MagicDataBaseBlock      UNSIGNED;
@property (nonatomic, readonly)MagicDataBaseBlock      NOT_NULL;
@property (nonatomic, readonly)MagicDataBaseBlock      PRIMARY_KEY;
@property (nonatomic, readonly)MagicDataBaseBlock      AUTO_INREMENT;
@property (nonatomic, readonly)MagicDataBaseBlock      DEFAULT_ZERO;
@property (nonatomic, readonly)MagicDataBaseBlock      DEFAULT_NULL;
@property (nonatomic, readonly)MagicDataBaseBlockN     DEFAULT;
@property (nonatomic, readonly)MagicDataBaseBlock      UNIQUE;
@property (nonatomic, readonly)MagicDataBaseBlock      CREATE_IF_NOT_EXISTS;

@property (nonatomic, readonly)MagicDataBaseBlockN     INDEX_ON;

@property (nonatomic, readonly)MagicDataBaseBlockN     SELECT;
@property (nonatomic, readonly)MagicDataBaseBlockN     SELECT_MAX;
@property (nonatomic, readonly)MagicDataBaseBlockN     SELECT_MAX_ALIAS;
@property (nonatomic, readonly)MagicDataBaseBlockN     SELECT_MIN;
@property (nonatomic, readonly)MagicDataBaseBlockN     SELECT_MIN_ALIAS;
@property (nonatomic, readonly)MagicDataBaseBlockN     SELECT_AVG;
@property (nonatomic, readonly)MagicDataBaseBlockN     SELECT_AVG_ALIAS;
@property (nonatomic, readonly)MagicDataBaseBlockN     SELECT_SUM;
@property (nonatomic, readonly)MagicDataBaseBlockN     SELECT_SUM_ALIAS;

@property (nonatomic, readonly)MagicDataBaseBlock      DISTINCT;
@property (nonatomic, readonly)MagicDataBaseBlockN     FROM;

@property (nonatomic, readonly)MagicDataBaseBlockN     WHERE;
@property (nonatomic, readonly)MagicDataBaseBlockN     OR_WHERE;

@property (nonatomic, readonly)MagicDataBaseBlockN     WHERE_IN;
@property (nonatomic, readonly)MagicDataBaseBlockN     OR_WHERE_IN;
@property (nonatomic, readonly)MagicDataBaseBlockN     WHERE_NOT_IN;
@property (nonatomic, readonly)MagicDataBaseBlockN     OR_WHERE_NOT_IN;

@property (nonatomic, readonly)MagicDataBaseBlockN     LIKE;
@property (nonatomic, readonly)MagicDataBaseBlockN     NOT_LIKE;
@property (nonatomic, readonly)MagicDataBaseBlockN     OR_LIKE;
@property (nonatomic, readonly)MagicDataBaseBlockN     OR_NOT_LIKE;

@property (nonatomic, readonly)MagicDataBaseBlockN     GROUP_BY;

@property (nonatomic, readonly)MagicDataBaseBlockN     HAVING;
@property (nonatomic, readonly)MagicDataBaseBlockN     OR_HAVING;

@property (nonatomic, readonly)MagicDataBaseBlockN     ORDER_ASC_BY;
@property (nonatomic, readonly)MagicDataBaseBlockN     ORDER_DESC_BY;
@property (nonatomic, readonly)MagicDataBaseBlockN     ORDER_RAND_BY;
@property (nonatomic, readonly)MagicDataBaseBlockN     ORDER_BY;

@property (nonatomic, readonly)MagicDataBaseBlockU     LIMIT;
@property (nonatomic, readonly)MagicDataBaseBlockU     OFFSET;

@property (nonatomic, readonly)MagicDataBaseBlockN     SET;
@property (nonatomic, readonly)MagicDataBaseBlockN     SET_NULL;

@property (nonatomic, readonly)MagicDataBaseBlock      GET;
@property (nonatomic, readonly)MagicDataBaseBlock      COUNT;

@property (nonatomic, readonly)MagicDataBaseBlock      INSERT;
@property (nonatomic, readonly)MagicDataBaseBlock      UPDATE;
@property (nonatomic, readonly)MagicDataBaseBlock      EMPTY;
@property (nonatomic, readonly)MagicDataBaseBlock      TRUNCATE;
@property (nonatomic, readonly)MagicDataBaseBlock      DELETE;
@property (nonatomic, readonly)MagicDataBaseBlock      DROP;

@property (nonatomic, readonly)MagicDataBaseBlock      BATCH_BEGIN;
@property (nonatomic, readonly)MagicDataBaseBlock      BATCH_END;

@property (nonatomic, readonly)MagicDataBaseBlockN     CLASS_TYPE;
@property (nonatomic, readonly)MagicDataBaseBlockN     ASSOCIATE;
@property (nonatomic, readonly)MagicDataBaseBlockN     HAS;

@property (nonatomic, readonly)NSArray                  *resultArray;
@property (nonatomic, readonly)NSUInteger               resultCount;
@property (nonatomic, readonly)NSInteger                inserID;
@property (nonatomic, readonly)BOOL                     succeed;

+ (BOOL)openSharedDatabase:(NSString *)path;
+ (BOOL)existsSharedDatabase:(NSString *)path;
+ (void)closeSharedDatabase;

+ (void)setSharedDatabase:(MagicDatabase *)db;
+ (MagicDatabase *)sharedDatabase;

- (id)initWithPath:(NSString *)path;

+ (BOOL)exists:(NSString *)path;
- (BOOL)open:(NSString *)path;
- (void)close;
- (void)clearState;

+ (NSString *)fieldNameForIdentifier:(NSString *)identifier;
+ (NSString *)tableNameForClass:(Class)clazz;

- (Class)classType;

- (NSArray *)associateObjects;
- (NSArray *)associateObjectsFor:(Class)clazz;

- (NSArray *)hasObjects;
- (NSArray *)hasObjectsFor:(Class)clazz;

- (void)__internalResetCreate;
- (void)__internalResetSelect;
- (void)__internalResetWrite;
- (void)__internalResetResult;


@end
