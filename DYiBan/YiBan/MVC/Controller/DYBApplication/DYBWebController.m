//
//  DYBWebViewController.m
//  DYiBan
//
//  Created by Song on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBWebController.h"

@interface DYBWebController (){
    BOOL isAppStore;
}

@end

@implementation DYBWebController

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"易码通"];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        isAppStore = NO;
        NSRange range = [self.url rangeOfString:@"http://itunes.apple."];
        if (range.location == 0 && range.length == 20) {
            isAppStore = YES;
        }
        UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)] autorelease];
        [webView setDelegate:self];
        NSRange range1 = [self.url rangeOfString:@"http://"];
        if (range1.location == 0 && range1.length == 7) {
            
        }else{
            
            self.url = [NSString stringWithFormat:@"http://%@",self.url];
        }
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        [self.view addSubview:webView];

    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [Static removeAlertView:self.view];
    if (!isAppStore) {
//        [Static alertView:self.view msg:@"请求失败！"];
    }
    DLogInfo(@"info is %@",error.userInfo);
    [self performSelector:@selector(doBack) withObject:nil afterDelay:1];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    [Static removeAlertView:self.view];
//    [bar setTitleLabelString:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}



@end
