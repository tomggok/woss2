//
//  Magic_Sandbox.m
//  MagicFramework
//
//  Created by NewM on 13-4-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_Sandbox.h"
#import "UIImage+MagicCategory.h"

@implementation MagicSandbox

+ (NSString *)appPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)docPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)libPrefPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];

}

+ (NSString *)libCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

+ (NSString *)tmpPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
}

//文件路径下的全部文件
+ (NSArray *)pathSubFile:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    NSArray *file = [fileManager subpathsOfDirectoryAtPath:path error:nil];
    
    return file;
}

//获得文件的大小
+ (long)pathFileLength:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary* dictFile = [fileManager attributesOfItemAtPath:path error:nil];

    long nFileSize = [dictFile fileSize]; //得到文件大小

    return nFileSize;
}

//删除文件
+ (BOOL)deleteFile:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];  
    
    return [fileManager removeItemAtPath:fileName error:nil];
}

#pragma mark-在沙盒的document目录创建一个字典或者从此目录得到一个字典
+(NSMutableDictionary *)initAndSaveOrGetMudFromDocument:(NSString *)dicName/*字典名*/
{
//    NSLog(@"%@",[self documentsDirectoryWithTrailingSlash:YES]);

    NSString *documentsDirectory =
    [self documentsDirectoryWithTrailingSlash:YES];

        //路径
    NSString *cacheDictionaryPath =
    [documentsDirectory
     stringByAppendingFormat:@"%@.dic",dicName];

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSMutableDictionary *cacheDictionary=nil;

    if ([fileManager fileExistsAtPath:cacheDictionaryPath] == YES){//存在此字典
        NSMutableDictionary *dictionary =
        [[NSMutableDictionary alloc]
         initWithContentsOfFile:cacheDictionaryPath];

        cacheDictionary = [dictionary mutableCopy];

        [dictionary release];

    } else {

        NSMutableDictionary *dictionary =
        [[NSMutableDictionary alloc] init];

        cacheDictionary = [dictionary mutableCopy];

        NSMutableArray *muA=[[NSMutableArray alloc]initWithCapacity:10];
        [cacheDictionary setValue:muA forKey:dicName];
        [muA release];

        [dictionary release];

    }

    [fileManager release];

    if ([cacheDictionaryPath length] > 0 &&
        cacheDictionary != nil){
        NSLog(@"cacheDictionaryPath==%@",cacheDictionaryPath);
        NSLog(@"Successfully initialized the cached dictionary.");
        
    } else {
        NSLog(@"Failed to initialize the cached dictionary.");
    }
    
    return cacheDictionary;
}

#pragma mark-得到程序的documents目录路径
+ (NSString *) documentsDirectoryWithTrailingSlash:(BOOL)paramWithTrailingSlash{

    NSString *result = nil;

    NSArray *documents =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);

    if ([documents count] > 0){
        result = [documents objectAtIndex:0];

        if (paramWithTrailingSlash == YES){
            result = [result stringByAppendingString:@"/"];
        }

    }
    return(result);
}

#pragma mark-把muD存入Document目录
+ (BOOL) saveCacheDictionaryToDocument:(NSString *)dicName/*字典名*/ cacheDictionary:(NSMutableDictionary *)cacheDictionary
{
//    NSLog(@"%@",[self documentsDirectoryWithTrailingSlash:YES]);

    NSString *documentsDirectory =
    [self documentsDirectoryWithTrailingSlash:YES];

        //路径
    NSString *cacheDictionaryPath =
    [documentsDirectory
     stringByAppendingFormat:@"%@.dic",dicName];

    BOOL result = NO;

    if ([cacheDictionaryPath length] == 0 ||
        cacheDictionary == nil){
        return(NO);
    }
    result = [cacheDictionary
              writeToFile:cacheDictionaryPath
              atomically:YES];

    return(result);
    
}

#pragma mark-沙盒里的document文件夹里是否有某文件
+(NSString *)isHasFileInDocument:(NSString *)imgName imgSuffix:(NSString *)imgSuffix
{
    NSString *filePath=[self documentsDirectoryWithTrailingSlash:YES];

    imgName=[imgName stringByAppendingPathExtension:imgSuffix];
//    NSLog(@"imgName==%@",imgName);
    filePath=[filePath stringByAppendingPathComponent:imgName];
//    NSLog(@"filePath==%@",filePath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] && imgName) {
        return filePath;
    }
    return Nil;
}

#pragma mark-得到此程序沙箱的主目录
+(NSString *)getAppMainPath
{
    return [@"~" stringByExpandingTildeInPath];
//    return  NSHomeDirectory();//2个方法都可以
}

#pragma mark-得到项目文件夹(非沙盒)里某个文件的路径
+(NSString *)getFilePathByName:(NSString *)fileName fileType:(NSString *)fileType/*文件后缀*/
{
    return [[NSBundle mainBundle]pathForResource:fileName ofType:fileType];

}

#pragma mark-从info.plist获取项目名字及版本号
+(NSString *)getAppNameAndVersionFromInfoPlist
{
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return executableFile;
}

#pragma mark-把img对象写到沙盒的document(沙盒的.app文件里不能写入文件,document和tmp里可以)文件里
+(NSString *)writeImgDataToSandBoxAppPath:(UIImage *)img imgName:(NSString *)imgName imgSuffix:(NSString *)imgSuffix
{//写入文件

    NSData *imgData=/*8[self UIImageToNSData:img compressionQuality:1]*/ [img saveToNSDataByCompressionQuality:1];
    NSString *filePath=[self documentsDirectoryWithTrailingSlash:YES];

    imgName=[imgName stringByAppendingPathExtension:imgSuffix];
    NSLog(@"%@",imgName);
    filePath=[filePath stringByAppendingPathComponent:imgName];
    NSLog(@"%@",filePath);
        //    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath])
    {
    NSError *error=nil;
    [imgData writeToFile:filePath options:NSDataWritingAtomic error:&error];
    if (!error) {
        NSLog(@"写入文件成功");
        return filePath;
    }else {
        NSLog(@"写入文件失败!!!");
    }
    }

    return nil;
}

@end
