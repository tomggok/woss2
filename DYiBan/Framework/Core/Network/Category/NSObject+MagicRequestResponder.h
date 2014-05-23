//
//  NSObject+MagicRequestResponder.h
//  MagicFramework
//
//  Created by NewM on 13-4-1.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Magic_Request.h"
#import "Magic_RequestQueue.h"

@interface NSObject (MagicRequestResponder)


@property (nonatomic, readonly) MagicRequestBlockS  HTTP_GET;
@property (nonatomic, readonly) MagicRequestBlockS  HTTP_GET_DOWN;
@property (nonatomic, readonly) MagicRequestBlockS  HTTP_POST;

//请求网络方式
- (MagicRequest *)GET:(NSString *)url;//异步请求
- (MagicRequest *)GET_SYNC:(NSString *)url;//同步
- (MagicRequest *)GETDOWN:(NSString *)url;//
- (MagicRequest *)POST:(NSString *)url;//
- (MagicRequest *)HTTP_GET:(NSString *)url;//
- (MagicRequest *)HTTP_GET_DOWN:(NSString *)url;//
- (MagicRequest *)HTTP_POST:(NSString *)url;//

- (BOOL)isRequestResponder;//判断是否请求的响应者
- (BOOL)isRequestingURL;//判断是否在请求
- (BOOL)isRequestingURL:(NSString *)url;//判断当前url是否在请求网络
- (NSArray *)requests;//获得请求网络的全部链接请求对象
- (NSArray *)requests:(NSString *)url;//获得当前url的请求对象
- (void)cancelRequests;//取消当前全部请求
- (void)cancelAllRequest;//取消这个应用的网络请求
- (void)cancelRequestWithUrl:(NSString *)url;//取消这个url全部的请求
- (void)cancelRequest:(MagicRequest *)request;//取消单个请求
- (NSString *)downFileName:(NSString *)url;//下载文件的名字
- (NSString *)downPathFileNameWithUrl:(NSString *)url;//下载文件的路径和名字

- (void)handleRequest:(MagicRequest *)request;

- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj;

- (void)downloadProgress:(CGFloat)newProgress request:(MagicRequest *)request;



@end
