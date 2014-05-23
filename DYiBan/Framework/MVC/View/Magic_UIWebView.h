//
//  Magic_UIWebView.h
//  MagicFramework
//
//  Created by NewM on 13-8-27.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Magic_ViewSignal.h"

@interface MagicUIWebView : UIWebView<UIWebViewDelegate>

AS_SIGNAL(ACTIONCLICK) //连接点击
AS_SIGNAL(ACTIONSUBMIT)//表单提交
AS_SIGNAL(ACTIONRESUBIMT)//表单重新提交
AS_SIGNAL(ACTIONBACK)//回退
AS_SIGNAL(ACTIONRELOAD)//刷新
AS_SIGNAL(ACTIONGOFORWARD)//前进
AS_SIGNAL(ACTIONSTOPLOADING)//停止加载

AS_SIGNAL(WILLSTART)//准备加载
AS_SIGNAL(DIDSTART)//开始加载
AS_SIGNAL(DIDLOADFINISH)//加载成功
AS_SIGNAL(DIDLOADFAILED)//加载失败
AS_SIGNAL(DIDLOADCANCELLED)//加载取消

@property (nonatomic, assign)NSString *html;
@property (nonatomic, assign)NSString *file;
@property (nonatomic, assign)NSString *resource;
@property (nonatomic, assign)NSString *url;



@end
