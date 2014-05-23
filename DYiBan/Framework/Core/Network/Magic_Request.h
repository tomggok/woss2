//
//  Magic_Request.h
//  MagicFramework
//
//  Created by NewM on 13-4-1.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "NSObject+MagicProperty.h"

enum  requestType{
    STATE_CREATED = 1,
    STATE_SENDING = 2,
    STATE_RECVING = 3,
    STATE_FAILED = 4,
    STATE_SUCCEED = 5,
    STATE_CANCELLED = 6
    };
@class MagicRequest;
typedef void(^MagicRequestBlock)(MagicRequest *req);
typedef MagicRequest*(^MagicRequestBlcokV)(void);
typedef MagicRequest*(^MagicRequestBlockN)(id key,...);
typedef MagicRequest*(^MagicRequestBlockS)(NSString *string);

@interface MagicRequest : ASIFormDataRequest
{
    NSUInteger          _state;
    NSMutableArray      *_arr_responders;
    
    NSInteger           _errorCode;
    NSMutableDictionary *_dict_userInfo;
    
    BOOL                _sendProgressed;
    BOOL                _recvProgressed;

    
    NSTimeInterval      _initTimeStamp;
    NSTimeInterval      _sendTimeStamp;
    NSTimeInterval      _recvTimeStamp;
    NSTimeInterval      _doneTimeStamp;

}

@property (nonatomic, readonly)MagicRequestBlockN  HEADER;//请求带头文件
@property (nonatomic, readonly)MagicRequestBlockN  FILE;//上传文件
@property (nonatomic, readonly)MagicRequestBlockN  PARAMS;//get请求url带参数post参数(传入的值为array)
@property (nonatomic, readonly)MagicRequestBlockN  PARAM;//get请求url带参数post参数
@property (nonatomic, readonly)MagicRequestBlockN  BODY;//post请求带body


@property (nonatomic, assign)NSUInteger             state;//请求网络的状态
@property (nonatomic, retain)NSMutableArray         *arr_responders;//全部请求

@property (nonatomic, assign)NSInteger              errorCode;//错误代卖
@property (nonatomic, retain)NSMutableDictionary    *dict_userInfo;//传参用
@property (nonatomic, retain)id                     userInfoObj;//传对象用



@property (nonatomic, assign)NSTimeInterval         initTimeStamp;
@property (nonatomic, assign)NSTimeInterval         sendTimeStamp;
@property (nonatomic, assign)NSTimeInterval         recvTimeStamp;
@property (nonatomic, assign)NSTimeInterval         doneTimeStamp;

@property (nonatomic, readonly)NSTimeInterval       timeCostPending;//排队等待耗时
@property (nonatomic, readonly)NSTimeInterval       timeCostOverDNS;//网络连接耗时（DNS）
@property (nonatomic, readonly)NSTimeInterval       timeCostRecving;//网络收包耗时
@property (nonatomic, readonly)NSTimeInterval       timeCostOverAri;//网络整体耗时

//请求网络的一些状态
@property (nonatomic, readonly)BOOL                 created;//创建
@property (nonatomic, readonly)BOOL                 sending;//发送中
@property (nonatomic, readonly)BOOL                 recving;//接收中
@property (nonatomic, readonly)BOOL                 failed;//失败
@property (nonatomic, readonly)BOOL                 succeed;//成功
@property (nonatomic, readonly)BOOL                 cancelled;//取消
@property (nonatomic, readonly)BOOL                 sendProgressed;//发送的进度
@property (nonatomic, readonly)BOOL                 recvProgressed;//接收的进度

@property (nonatomic, readonly)CGFloat              uploadPercent;//上传的百分比
@property (nonatomic, readonly)NSUInteger           uploadBytes;//上传的大小
@property (nonatomic, readonly)NSUInteger           uploadTotalBytes;//上传的总大小

@property (nonatomic, readonly)CGFloat              downloadPercent;//下载的百分比
@property (nonatomic, readonly)NSUInteger           downloadBytes;//下载的大小
@property (nonatomic, readonly)NSUInteger           downloadTotalBytes;//下载的总大小
@property (nonatomic, retain)  NSString             *downloadName;//下载完成的名字

- (BOOL)is:(NSString *)url;//判断是否有当前对象的url请求了（get请求）
- (void)changeState:(NSUInteger)state;//切换请求状态

- (BOOL)hasResponder:(id)responder;
- (void)addResponder:(id)responder;
- (void)removeResponder:(id)responder;
- (void)removeAllResponders;

- (void)callResponders;
- (void)forwardResponder:(NSObject *)obj;

- (void)updateSendProgress;
- (void)updateRecvProgress;

@end
