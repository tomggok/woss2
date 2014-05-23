//
//  DYBRequest.h
//  DYiBan
//
//  Created by NewM on 13-7-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Magic_Request.h"
#import "Magic_RequestQueue.h"

#define POSTDATAFILETYPE    @"FILETYPE"
#define POSTDFILEDATA       @"DATA"
#define POSTDATAFILENAME    @"FILENAME"

#define POSTSPX             @"POSTSPX"

#define POSTIMG             @"POSTIMG"
#define POSTFILE            @"POSTFILE"
typedef enum HTTPPOSTTYPE{
    POSTIMGTYPE = 1,
    POSTFILETYPE = 2
}HTTPPOSTTYPE;

/*
 code	描述
 100	成功
 101	失败
 105	请求参数不合法
 106	sessID过期
 140	被防刷的提示
 180	非法客户端类型
 201	提示用户下载新的客户端
 202	强制用户需要更新客户端版本，否则无法使用
 203	非法的客户端版本号
 */
#define khttpsucceedCode         100
#define khttpfailCode            101
#define khttpWrongfulCode        105
#define khttpSessIDtimeoutCode   106
#define khttpSecurityCode        140
#define khttpWrongfulAppCode     180
#define khttpNeedUpdateCode      201
#define khttpUpdateCode          202
#define khttpWrongfulVersionCode 203
#define khttpJSONError           0

@interface DYBRequest : NSObject
{
}


//get请求
- (MagicRequest *)DYBGET:(NSMutableDictionary *)params isAlert:(BOOL)isAlert receive:(id)_receive;

//网络请求GET请求不需要缓存
- (MagicRequest *)DYBGETNOCACHE:(NSMutableDictionary *)params isAlert:(BOOL)isAlert receive:(id)_receive;

//网络POST请求
- (MagicRequest *)DYBPOST:(NSMutableDictionary *)params isAlert:(BOOL)isAlert receive:(id)_receive;

//post请求上传图片
- (MagicRequest *)DYBPOSTIMG:(NSMutableDictionary *)params isAlert:(BOOL)isAlert receive:(id)_receive imageData:(NSArray *)imageDatas;

//网络POST请求上传文件
- (MagicRequest *)DYBPOSTFILE:(NSMutableDictionary *)params isAlert:(BOOL)isAlert receive:(id)_receive fileData:(NSArray *)fileDatas;

@end
