//
//  Magic_RequestQueue.m
//  MagicFramework
//
//  Created by NewM on 13-4-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_RequestQueue.h"

@implementation MagicRequestQueue
@synthesize merge = _merge,
online = _online;

@synthesize bytesDownload = _bytesDownload,
bytesUpload = _bytesUpload;
@synthesize delay = _delay,
arr_requests = _arr_requests;
+ (BOOL)isReachableViaWIFI
{
    return YES;
}

+ (BOOL)isReachableViaWLAN
{
    return YES;
}

+ (BOOL)isNetworkInUse
{
    return ([[MagicRequestQueue sharedInstance].arr_requests count] > 0) ? YES : NO;
}

+ (NSUInteger)bandwidthUsedPerSecond
{
	return [ASIHTTPRequest averageBandwidthUsedPerSecond];
}

+ (MagicRequestQueue *)sharedInstance
{
    static MagicRequestQueue *_sharedInstance = nil;
    @synchronized(self)
    {
        if (!_sharedInstance) {
            _sharedInstance = [[MagicRequestQueue alloc] init];
            [ASIHTTPRequest setDefaultUserAgentString:@"Magic"];
            [[ASIHTTPRequest sharedQueue] setMaxConcurrentOperationCount:10];
        }
    }
    return _sharedInstance;

}

- (id)init
{
    self = [super init];
    if (self) {
        _delay = .1f;
        _merge = YES;
        _online = YES;
        _arr_requests = [[NSMutableArray alloc] init];
        
        
        
    }
    return self;
}

- (void)setOnline:(BOOL)online
{
    _online = online;
    if (!_online) {
        [self cancelAllRequests];
    }
}

- (void)dealloc
{
    [self cancelAllRequests];
    
    RELEASEDICTARRAYOBJ(_arr_requests);
    
    //    self.whenCreate = nil;
    //    self.whenUpdate = nil;
    
    [super dealloc];
}

+ (MagicRequest *)GET:(NSString *)url
{
    return [[MagicRequestQueue sharedInstance] GET:url sync:NO];
}

+ (MagicRequest *)GET_SYNC:(NSString *)url
{
    return [[MagicRequestQueue sharedInstance] GET:url sync:YES];
}

- (MagicRequest *)GET:(NSString *)url sync:(BOOL)sync
{
    if (!_online)
    {
        return nil;
    }
    
    MagicRequest *request = nil;
    if (!sync && _merge)
    {//为了处理多次点击
        for (MagicRequest *req in _arr_requests)
        {
            if ([req.url.absoluteString isEqualToString:url])
            {
                return req;
            }
        }
    }
    
    request = [[MagicRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.timeOutSeconds = DEFAULT_GET_TIMEOUT;
    request.requestMethod = @"GET";
    request.postBody = nil;
    [request setDelegate:self];
    [request setDownloadProgressDelegate:self];
    [request setUploadProgressDelegate:self];
    
    //设置请求超时时，设置重试的次数
    [request setNumberOfTimesToRetryOnTimeout:1];
    request.shouldAttemptPersistentConnection = NO;//防止多次提交
    
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [request setShouldContinueWhenAppEntersBackground:YES];
    //iOS4中，当应用后台运行时仍然请求数据
#endif
    
    [_arr_requests addObject:request];
    
    if (sync)
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(.1f);
            dispatch_async(dispatch_get_main_queue(), ^{
                [request startSynchronous];
            });
        });
        
    }else
    {
        if (_delay)
        {
            [request performSelector:@selector(startAsynchronous)
                          withObject:nil
                          afterDelay:_delay];
        }else
        {
            [request startAsynchronous];
        }
    }
    
    return [request autorelease];
    
    
}

+ (MagicRequest *)POST:(NSString *)url
{
    return [[MagicRequestQueue sharedInstance] POST:url sync:NO];
}

- (MagicRequest *)POST:(NSString *)url sync:(BOOL)sync
{
    if (!_online)
    {
        return nil;
    }
    
    MagicRequest *request = [[MagicRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.timeOutSeconds = DEFAULT_POST_TIMEOUT;
    request.requestMethod = @"POST";
//    request.postFormat = ASIMultipartFormDataPostFormat;
    [request setDelegate:self];
    [request setUploadProgressDelegate:self];
    [request setNumberOfTimesToRetryOnTimeout:1];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif	// #if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    
    [_arr_requests addObject:request];
    
    if (sync)
    {
        [request startSynchronous];
    }else
    {
        if (_delay) {
            [request performSelector:@selector(startAsynchronous)
                          withObject:nil
                          afterDelay:_delay];
        }else
        {
            [request startAsynchronous];
        }
    }
    return [request autorelease];
    
}

+ (BOOL)requesting:(NSString *)url
{
    return [[MagicRequestQueue sharedInstance] requesting:url];
}

- (BOOL)requesting:(NSString *)url
{
    for (MagicRequest *request in _arr_requests)
    {
        if ([[request.url absoluteString] isEqualToString:url])
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)requesting:(NSString *)url byResponder:(id)responder
{
    return [[MagicRequestQueue sharedInstance] requesting:url byResponder:responder];
}

- (BOOL)requesting:(NSString *)url byResponder:(id)responder
{
    for (MagicRequest *request in _arr_requests) {
        //        if (responder && ![request hasResponder:responder]) {
        //            continue;
        //        }
        
        if (!url || [[request.url absoluteString] isEqualToString:url]) {
            return YES;
        }
    }
    return NO;
}

+ (NSArray *)requests:(NSString *)url
{
    return [[MagicRequestQueue sharedInstance] requests:url];
}

- (NSArray *)requests:(NSString *)url
{
    NSMutableArray *array = [NSMutableArray array];
    for (MagicRequest *request in _arr_requests) {
        [array addObject:request];
    }
    
    return array;
}

+ (NSArray *)requests:(NSString *)url byResponder:(id)responder
{
	return [[MagicRequestQueue sharedInstance] requests:url byResponder:responder];
}

- (NSArray *)requests:(NSString *)url byResponder:(id)responder
{
	NSMutableArray * array = [NSMutableArray array];
    
	for ( MagicRequest * request in _arr_requests )
	{
        //		if ( responder && NO == [request hasResponder:responder] /* request.responder != responder */ )
        //			continue;
		
		if ( nil == url || [[request.url absoluteString] isEqualToString:url] )
		{
			[array addObject:request];
		}
	}
    
	return array;
}

+ (void)cancelRequest:(MagicRequest *)request
{
    [[MagicRequestQueue sharedInstance] cancelRequest:request];
}

- (void)cancelRequest:(MagicRequest *)request ifRemove:(BOOL)ifRemove
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAsynchronous) object:nil];
    
    if ([_arr_requests containsObject:request])
    {
        if (request.created || request.sending || request.recving)
        {
            [request changeState:STATE_CANCELLED];
        }
        
        [request clearDelegatesAndCancel];
        [request removeAllResponders];
        
        if (ifRemove)
        {
            [_arr_requests removeObject:request];
        }
    }
}

- (void)cancelRequest:(MagicRequest *)request
{
    [self cancelRequest:request ifRemove:YES];
}

+ (void)cancelRequestByResponder:(id)responder
{
    [[MagicRequestQueue sharedInstance] cancelRequestByResponder:responder];
}

- (void)cancelRequestByResponder:(id)responder
{
    if (!responder)
    {
        [self cancelAllRequests];
    }else
    {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (MagicRequest *request in _arr_requests)
        {
            if ([request hasResponder:responder]) {
                [tempArray addObject:request];
            }
        }
        
        for (MagicRequest *request in tempArray)
        {
            [self cancelRequest:request];
        }
        
    }
}

+ (void)cancelAllRequests
{
    [[MagicRequestQueue sharedInstance] cancelAllRequests];
}

- (void)cancelAllRequests
{
    for (MagicRequest *request in _arr_requests)
    {
        [self cancelRequest:request ifRemove:NO];
    }
    [_arr_requests removeAllObjects];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    if (![request isKindOfClass:[MagicRequest class]]) {
        return;
    }
    
    MagicRequest *newWorkRequest = (MagicRequest *)request;
    [newWorkRequest changeState:STATE_SENDING];
    _bytesUpload += request.postLength;
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    if (![request isKindOfClass:[MagicRequest class]]) {
        return;
    }
    
    MagicRequest *newWorkRequest = (MagicRequest *)request;
    [newWorkRequest changeState:STATE_RECVING];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    _bytesDownload += [[request rawResponseData] length];
    
    if (![request isKindOfClass:[MagicRequest class]]) {
        return;
    }
    
    MagicRequest *newWorkRequest = (MagicRequest *)request;
    
    //断点续传下载用的state == 206的状态
    if (request.responseStatusCode == 200 || (request.responseStatusCode == 206 && request.allowResumeForFileDownloads))
    {
        [newWorkRequest changeState:STATE_SUCCEED];
    }else
    {
        [newWorkRequest changeState:STATE_FAILED];
    }
    
    
    
    [newWorkRequest clearDelegatesAndCancel];
    [newWorkRequest removeAllResponders];
    
    [_arr_requests removeObject:newWorkRequest];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (![request isKindOfClass:[MagicRequest class]]) {
        return;
    }
    
    MagicRequest *newWorkRequest = (MagicRequest *)request;
    [newWorkRequest setErrorCode:-1];
    [newWorkRequest changeState:STATE_FAILED];
    
    [newWorkRequest clearDelegatesAndCancel];
    [newWorkRequest removeAllResponders];
    
    [_arr_requests removeObject:newWorkRequest];
}

@end
