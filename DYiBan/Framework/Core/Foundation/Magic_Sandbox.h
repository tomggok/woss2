//
//  Magic_Sandbox.h
//  MagicFramework
//
//  Created by NewM on 13-4-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MagicSandbox : NSObject


+ (NSString *)appPath;		// 程序目录，不能存任何东西
+ (NSString *)docPath;		// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)libPrefPath;	// 配置目录，配置文件存这里
+ (NSString *)libCachePath;	// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)tmpPath;		// 缓存目录，APP退出后，系统可能会删除这里的内容
//删除文件
+ (BOOL)deleteFile:(NSString *)fileName;
//文件路径下的全部文件
+ (NSArray *)pathSubFile:(NSString *)path;
//获得文件的大小
+ (long)pathFileLength:(NSString *)path;

+(NSMutableDictionary *)initAndSaveOrGetMudFromDocument:(NSString *)dicName/*字典名*/;
+ (NSString *) documentsDirectoryWithTrailingSlash:(BOOL)paramWithTrailingSlash;
+ (BOOL) saveCacheDictionaryToDocument:(NSString *)dicName/*字典名*/ cacheDictionary:(NSMutableDictionary *)cacheDictionar;
+(NSString *)isHasFileInDocument:(NSString *)imgName imgSuffix:(NSString *)imgSuffix;
+(NSString *)getAppMainPath;
+(NSString *)getFilePathByName:(NSString *)fileName fileType:(NSString *)fileType/*文件后缀*/;
+(NSString *)getAppNameAndVersionFromInfoPlist;
+(NSString *)writeImgDataToSandBoxAppPath:(UIImage *)img imgName:(NSString *)imgName imgSuffix:(NSString *)imgSuffix;

@end
