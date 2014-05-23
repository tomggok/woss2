//
//  Magic_Request.m
//  MagicFramework
//
//  Created by NewM on 13-4-1.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_Request.h"
#import "NSObject+MagicRequestResponder.h"
#import "NSObject+MagicTypeConversion.h"
@interface MagicRequest ()

- (void)updateSendProgress;
- (void)updateRecvProgress;
@end

@implementation MagicRequest

@dynamic BODY;
@dynamic PARAM,PARAMS;

@synthesize state = _state,
errorCode = _errorCode;
@synthesize dict_userInfo = _dict_userInfo,
            arr_responders = _arr_responders,
            userInfoObj = _userInfoObj;
@synthesize initTimeStamp = _initTimeStamp,
            sendTimeStamp = _sendTimeStamp,
            recvTimeStamp = _recvTimeStamp,
            doneTimeStamp = _doneTimeStamp;
@synthesize timeCostPending,timeCostOverDNS,timeCostRecving,timeCostOverAri;
@synthesize created,
            sending,
            recving,
            failed,
            succeed;
@synthesize sendProgressed = _sendProgressed,
            recvProgressed = _recvProgressed;
@synthesize uploadPercent,
            uploadBytes,
            uploadTotalBytes,
            downloadBytes,
            downloadPercent,
            downloadTotalBytes;
@synthesize downloadName = _downloadName;


- (id)initWithURL:(NSURL *)newURL
{
    self = [super initWithURL:newURL];
    if (self) {
        _state = STATE_CREATED;
        _errorCode = 0;
        
        _arr_responders = [[NSMutableArray alloc] init];
        _dict_userInfo = [[NSMutableDictionary alloc] init];
        
        _sendProgressed = NO;
        _recvProgressed = NO;
        
        _initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
        _sendTimeStamp = _initTimeStamp;
        _recvTimeStamp = _initTimeStamp;
        _doneTimeStamp = _initTimeStamp;
    }
    
    return self;
}


- (NSString *)responseString
{
    NSString *string = [super responseString];
    if (!string || string.length == 0)
    {
        NSData *sd = [self responseData];
        sd = [MagicCommentMethod ungzipData:sd];
        string = [[[NSString alloc] initWithData:sd encoding:NSUTF8StringEncoding] autorelease];
    }
    
    return string;
}
 
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ , state === %d, %d/%d",
            self.requestMethod, [self.url absoluteString],
            self.state,
            [self uploadBytes], [self downloadBytes]];
}

- (void)dealloc
{
    
    RELEASEDICTARRAYOBJ(_arr_responders);
    RELEASEDICTARRAYOBJ(_dict_userInfo);
    
    RELEASEOBJ(_userInfoObj);
    RELEASEOBJ(_downloadName);
    
    [super dealloc];
}

- (CGFloat)uploadPercent
{
    NSUInteger bytes1 = self.uploadBytes;
    NSUInteger bytes2 = self.uploadTotalBytes;
    
    return bytes2 ? (CGFloat)bytes1/(CGFloat)bytes2 : .0f;
}

- (NSUInteger)uploadBytes
{
    if ([self.requestMethod isEqualToString:@"GET"])
    {
        return 0;
    }else if ([self.requestMethod isEqualToString:@"POST"])
    {
        return self.postLength;
    }
    return 0;
}

- (NSUInteger)uploadTotalBytes
{
    if ([self.requestMethod isEqualToString:@"GET"])
    {
        return 0;
    }else if ([self.requestMethod isEqualToString:@"POST"])
    {
        return self.postLength;
    }
    return 0;
}

- (CGFloat)downloadPercent
{
    NSUInteger bytes1 = self.downloadBytes;
    NSUInteger bytes2 = self.downloadTotalBytes;
    
    return bytes2 ? (CGFloat)bytes1/(CGFloat)bytes2 : .0f;
}

- (NSUInteger)downloadBytes
{
    return [[self rawResponseData] length];
}

- (NSUInteger)downloadTotalBytes
{
    return self.contentLength;
}

- (BOOL)is:(NSString *)_url
{
    return [[self.url absoluteString] isEqualToString:_url];
}

- (void)callResponders
{
    NSArray *responds = [self.arr_responders copy];
    for (NSObject *responder in responds)
    {
        if ([responder isRequestResponder])
        {
            [responder handleRequest:self];
        }
    }
    RELEASEOBJ(responds);
}

- (void)forwardResponder:(NSObject *)obj
{
    if ([obj isRequestResponder])
    {
        [obj handleRequest:self];
    }
}

- (void)setProgress:(CGFloat)newProgress
{
    NSArray *responds = [self.arr_responders copy];
    for (NSObject *responder in responds)
    {
        if ([responder isRequestResponder])
        {
            [responder downloadProgress:newProgress request:self];
        }
    }
    RELEASEOBJ(responds);
}


-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    
    DLogInfo(@"fgggg %ld",bytes);
    
    NSDictionary *fileInfo=[request.userInfo objectForKey:@"File"];
    
     DLogInfo(@"dic  %@",fileInfo);
//    if(!fileInfo.isFistReceived)
//    {
//        fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%lld",[fileInfo.fileReceivedSize longLongValue]+bytes];
//    }
//    if([self.downloadDelegate respondsToSelector:@selector(updateCellProgress:)])
//    {
//        [self.downloadDelegate updateCellProgress:request];
//    }
//    fileInfo.isFistReceived=NO;
}

- (void)changeState:(NSUInteger)state
{
    if (state != _state)
    {
        _state = state;
        
        if (STATE_SENDING == _state)
        {
            _sendTimeStamp = [NSDate timeIntervalSinceReferenceDate];
        }else if (STATE_RECVING == _state)
        {
            _recvTimeStamp = [NSDate timeIntervalSinceReferenceDate];
        }else if (STATE_CANCELLED == _state)
        {
            _doneTimeStamp = [NSDate timeIntervalSinceReferenceDate];
        }
        
        [self callResponders];
        
    }
}

- (void)updateSendProgress
{
    _sendProgressed = YES;
    
    [self callResponders];
    
    _sendProgressed = NO;
}

- (void)updateRecvProgress
{
    if (_state == STATE_SUCCEED ||
        _state == STATE_FAILED ||
        _state == STATE_CANCELLED)
    {
        return;
    }
    
    if (self.didUseCachedResponse)
    {
        return;
    }
    
    _recvProgressed = YES;
    [self callResponders];
    
    _recvProgressed = NO;
}

- (NSTimeInterval)timeCostPending//排队等待耗时
{
    return _sendTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostOverDNS//网络连接耗时（DNS）
{
    return _recvTimeStamp - _sendTimeStamp;
}

- (NSTimeInterval)timeCostOverAri//网络收包耗时
{
    return _doneTimeStamp - _recvTimeStamp;
}

- (NSTimeInterval)timeCostRecving//网络整体耗时
{
    return _doneTimeStamp - _sendTimeStamp;
}

- (BOOL)created
{
    return STATE_CREATED == _state ? YES : NO;
}

- (BOOL)sending
{
    return STATE_SENDING == _state ? YES : NO;
}

- (BOOL)recving
{
    return STATE_RECVING == _state ? YES : NO;
}

- (BOOL)succeed
{
    return STATE_SUCCEED == _state ? YES : NO;
}

- (BOOL)failed
{
    return STATE_FAILED == _state ? YES : NO;
}

- (BOOL)cancelled
{
    return STATE_CANCELLED == _state ? YES : NO;
}

- (BOOL)hasResponder:(id)responder
{
    return [_arr_responders containsObject:responder];
}

- (void)addResponder:(id)responder
{
    [_arr_responders addObject:responder];
}

- (void)removeResponder:(id)responder
{
    [_arr_responders removeObject:responder];
}

- (void)removeAllResponders
{
    [_arr_responders removeAllObjects];
}

- (MagicRequestBlockN)HEADER
{
    MagicRequestBlockN block = ^ MagicRequest*(id first,...)
    {
        va_list args;
        va_start(args, first);
        
        NSString *key = [(NSObject *)first asNSString];
        NSString *value = [va_arg(args, NSObject *)asNSString];
        [self addRequestHeader:key value:value];
        va_end(args);
        return self;
    };
    return [[block copy] autorelease];
}

- (MagicRequestBlockN)BODY
{
    MagicRequestBlockN block = ^MagicRequest*(id first,...)
    {
        NSData *data = nil;
        
        if ([first isKindOfClass:[NSData class]])
        {
            data = (NSData *)first;
        }else if ([first isKindOfClass:[NSString class]])
        {
            data = [first dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        }
        
        if (data) {
            self.postBody = [NSMutableData dataWithData:data];
        }
        return self;
        
    };
    return [[block copy] autorelease];
    
}

- (MagicRequestBlockN)PARAMS
{
    MagicRequestBlockN block = ^MagicRequest*(id first,...)
    {
        NSArray *value = first;
        
        for (int i = 0; i < [value count]; i++)
        {
            NSString *kv = [value objectAtIndex:i];
            NSArray *kvArr = [kv componentsSeparatedByString:@"="];
            if ([kvArr count] != 2)
            {
                continue;
            }
            self.PARAM([kvArr objectAtIndex:0], [kvArr objectAtIndex:1]);
        }
        
        return self;
    };
    return [[block copy] autorelease];
}

- (MagicRequestBlockN)PARAM
{
    MagicRequestBlockN block = ^MagicRequest*(id first,...)
    {
        va_list args;
        va_start(args, first);
        
        NSString *key = [(NSString *)first asNSString];
        NSString *value = [va_arg(args, NSObject *)asNSString];
        
        if ([self.requestMethod isEqualToString:@"GET"])
        {
            
        }else
        {
            [self setPostValue:value forKey:key];
        }
        
        va_end(args);
        
        
        return self;
    };
    return [[block copy] autorelease];
}

- (MagicRequestBlockN)FILE
{
    MagicRequestBlockN block = ^MagicRequest*(id first,...)
    {
    
        return self;
    };
    
    return [[block copy] autorelease];
}

@end
