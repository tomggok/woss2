//
//  Magic_UIWebView.m
//  MagicFramework
//
//  Created by NewM on 13-8-27.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_UIWebView.h"

@implementation MagicUIWebView
@synthesize html, file, resource, url;
DEF_SIGNAL(ACTIONCLICK) //连接点击
DEF_SIGNAL(ACTIONSUBMIT)//表单提交
DEF_SIGNAL(ACTIONRESUBIMT)//表单重新提交
DEF_SIGNAL(ACTIONBACK)//回退
DEF_SIGNAL(ACTIONRELOAD)//刷新
DEF_SIGNAL(ACTIONGOFORWARD)//前进
DEF_SIGNAL(ACTIONSTOPLOADING)//停止加载

DEF_SIGNAL(WILLSTART)//准备加载
DEF_SIGNAL(DIDSTART)//开始加载
DEF_SIGNAL(DIDLOADFINISH)//加载成功
DEF_SIGNAL(DIDLOADFAILED)//加载失败
DEF_SIGNAL(DIDLOADCANCELLED)//加载取消

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    
}

- (void)setHtml:(NSString *)string
{
    [self loadHTMLString:string baseURL:nil];
}

- (void)setFile:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data)
    {
        [self loadData:data MIMEType:@"text/html" textEncodingName:@"UTF" baseURL:nil];
    }
}


- (void)setResource:(NSString *)path
{
    NSString *exentsion = [path pathExtension];
    NSString *fullName = [path substringToIndex:path.length - exentsion.length - 1];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:fullName ofType:exentsion];
    NSData *data = [NSData dataWithContentsOfFile:path2];
    
    if (data)
    {
        [self loadData:data MIMEType:@"text/html" textEncodingName:@"UTF8" baseURL:nil];
    }
}

- (void)reload
{
    [super reload];
    [self sendViewSignal:[MagicUIWebView ACTIONRELOAD] withObject:nil];
}
- (void)stopLoading
{
    [super stopLoading];
    [self sendViewSignal:[MagicUIWebView ACTIONSTOPLOADING] withObject:nil];
}

- (void)goBack
{
    [super goBack];
    [self sendViewSignal:[MagicUIWebView ACTIONBACK] withObject:nil];
}

- (void)goForward
{
    [super goForward];
    [self sendViewSignal:[MagicUIWebView ACTIONGOFORWARD] withObject:nil];
}

- (void)setUrl:(NSString *)_url
{
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

#pragma mark -
#pragma mark - webDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSObject *result = nil;
    
    [self sendViewSignal:[MagicUIWebView WILLSTART] withObject:request.URL.absoluteString];
    
    if (UIWebViewNavigationTypeLinkClicked == navigationType)
    {
        result = [self sendViewSignal:[MagicUIWebView ACTIONCLICK] withObject:request.URL.absoluteString].returnValue;
    }else if (UIWebViewNavigationTypeFormSubmitted == navigationType)
    {
        result = [self sendViewSignal:[MagicUIWebView ACTIONSUBMIT] withObject:request.URL.absoluteString].returnValue;
    }else if (UIWebViewNavigationTypeFormResubmitted == navigationType)
    {
        result = [self sendViewSignal:[MagicUIWebView ACTIONRESUBIMT] withObject:request.URL.absoluteString].returnValue;
    }
    
    if (result == [MagicViewSignal NO_VALUE])
    {
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self sendViewSignal:[MagicUIWebView DIDSTART] withObject:webView.request.URL.absoluteString];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self sendViewSignal:[MagicUIWebView DIDLOADFINISH] withObject:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([[error domain] isEqualToString:NSURLErrorDomain])
    {
        if (NSURLErrorCancelled == [error code])
        {
            [self sendViewSignal:[MagicUIWebView DIDLOADCANCELLED] withObject:nil];
            return;
        }
    }
    
    if ([[error domain] isEqual:@"WebKitErrorDomain"] && [error code] == 102)
    {
        //这个错误可以忽略
    }else
    {
        DLogInfo(@"MagicWebView error == %@", error);
        
        [self sendViewSignal:[MagicUIWebView DIDLOADFAILED] withObject:error];
    }
}

@end
