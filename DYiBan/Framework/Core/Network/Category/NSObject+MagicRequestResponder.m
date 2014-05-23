//
//  NSObject+MagicRequestResponder.m
//  MagicFramework
//
//  Created by NewM on 13-4-1.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "NSObject+MagicRequestResponder.h"

@implementation NSObject (MagicRequestResponder)
@dynamic HTTP_GET,HTTP_POST;

- (MagicRequest *)GET:(NSString *)url
{
    return [self HTTP_GET:url];
}

- (MagicRequest *)GET_SYNC:(NSString *)url
{
    return [self HTTP_GET_SYNC:url];
}

- (MagicRequest *)GETDOWN:(NSString *)url
{
    return [self HTTP_GET_DOWN:url];
}

- (MagicRequest *)POST:(NSString *)url
{
    return [self HTTP_POST:url];
}

- (MagicRequest *)HTTP_GET:(NSString *)url
{
    MagicRequest *req = [MagicRequestQueue GET:url];
    [req addResponder:self];
    return req;
}

- (MagicRequest *)HTTP_GET_SYNC:(NSString *)url
{
    MagicRequest *req = [MagicRequestQueue GET_SYNC:url];
    [req addResponder:self];
    return req;
}

- (MagicRequest *)HTTP_POST:(NSString *)url
{
    MagicRequest *req = [MagicRequestQueue POST:url];
    [req addResponder:self];
    return req;
}

- (MagicRequest *)HTTP_GET_DOWN:(NSString *)url
{
    MagicRequest *req = [MagicRequestQueue GET:url];
    [req addResponder:self];
    
    NSArray *typeArr = [url componentsSeparatedByString:@"."];
    NSString *type = [typeArr lastObject];
    
    NSString *downFileName = [NSString stringWithFormat:@"%@.%@", [MagicCommentMethod md5:url], type];
    [req setDownloadName:downFileName];
    NSString *downloadPath = [NSString stringWithFormat:@"%@%@", [MagicCommentMethod downloadPath], downFileName];
    
    [req setDownloadDestinationPath:downloadPath];
    [req setTemporaryFileDownloadPath:[NSString stringWithFormat:@"%@.download", downloadPath]];
    [req setAllowResumeForFileDownloads:YES];//是否支持断点续传
    [req setDownloadProgressDelegate:req];//设置下载的代理回调
    
    return req;
}

- (BOOL)isRequestResponder
{
    if ([self respondsToSelector:@selector(handleRequest:)])
    {
        return YES;
    }
    return NO;
}

- (MagicRequestBlockS)HTTP_GET
{
    MagicRequestBlockS block = ^ MagicRequest * (NSString *url)
    {
        MagicRequest *req = [MagicRequestQueue GET:url];
        [req addResponder:self];
        return req;
    };
    return [[block copy] autorelease];
}

- (MagicRequestBlockS)HTTP_GET_DOWN
{
    MagicRequestBlockS block = ^ MagicRequest * (NSString *url)
    {
        MagicRequest *req = [MagicRequestQueue GET:url];
        [req addResponder:self];
        
        NSString *downFileName = [self downFileName:url];
        [req setDownloadName:downFileName];
        NSString *downloadPath = [self downPathFileName:downFileName];
        
        [req setDownloadDestinationPath:downloadPath];
        [req setTemporaryFileDownloadPath:[NSString stringWithFormat:@"%@.download", downloadPath]];
        [req setAllowResumeForFileDownloads:YES];//是否支持断点续传
        [req setDownloadProgressDelegate:req];//设置下载的代理回调
        
        return req;
    };
    return [[block copy] autorelease];
}

- (NSString *)downFileName:(NSString *)url
{
    NSArray *typeArr = [url componentsSeparatedByString:@"."];
    NSString *type = [typeArr lastObject];
    
    NSString *downFileName = [NSString stringWithFormat:@"%@.%@", [MagicCommentMethod md5:url], type];

    return downFileName;
}

- (NSString *)downPathFileName:(NSString *)downFileName
{
    NSString *downloadPath = [NSString stringWithFormat:@"%@%@", [MagicCommentMethod downloadPath], downFileName];

    return downloadPath;
}

- (NSString *)downPathFileNameWithUrl:(NSString *)url
{
    NSString *name = [self downPathFileName:[self downFileName:url]];
    
    return name;
}

- (MagicRequestBlockS)HTTP_POST
{
    MagicRequestBlockS block = ^MagicRequest*(NSString *url)
    {
        MagicRequest *req = [MagicRequestQueue POST:url];
        [req addResponder:self];
        return req;
    };
    return [[block copy] autorelease];
}

- (BOOL)isRequestingURL
{
    if ([self isRequestResponder])
    {
        return [MagicRequestQueue requesting:nil byResponder:self];
    }else
    {
        return NO;
    }
}

- (BOOL)isRequestingURL:(NSString *)url
{
    if ([self isRequestResponder])
    {
        return [MagicRequestQueue requesting:url byResponder:self];
    }else
    {
        return NO;
    }
}

- (NSArray *)requests
{
    return [MagicRequestQueue requests:nil byResponder:self];
}

- (NSArray *)requests:(NSString *)url
{
    return [MagicRequestQueue requests:url byResponder:self];
}

- (void)cancelRequests
{
    if ([self isRequestResponder]) {
        [MagicRequestQueue cancelRequestByResponder:self];
    }
}

- (void)cancelAllRequest
{
    [MagicRequestQueue cancelAllRequests];
}

- (void)cancelRequestWithUrl:(NSString *)url
{
    NSArray *arr = [self requests:url];
    for (int i = 0; i < [arr count]; i++)
    {
        MagicRequest *request = [arr objectAtIndex:i];
        
        [self cancelRequest:request];
    }
}

- (void)cancelRequest:(MagicRequest *)request
{
    [MagicRequestQueue cancelRequest:request];
}

- (void)handleRequest:(MagicRequest *)request
{
//    [self handleRequest:request];
}

- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{   
}

- (void)downloadProgress:(CGFloat)newProgress request:(MagicRequest *)request
{
}

@end
