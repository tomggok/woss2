//
//  DYBClassNoticeDetailsViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-9-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBClassNoticeDetailsViewController.h"

@interface DYBClassNoticeDetailsViewController ()
{
    BOOL isAppStore;
}
@end

@implementation DYBClassNoticeDetailsViewController

@synthesize str_url=_str_url;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        NSRange range = [self.str_url rangeOfString:@"http://itunes.apple."];
        if (range.location == 0 && range.length == 20) {
            isAppStore = YES;
        }
        UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, self.headHeight, screenShows.size.width, self.view.frame.size.height-self.headHeight)] autorelease];
        [webView setDelegate:self];
        NSRange range1 = [self.str_url rangeOfString:@"http://"];
        if (range1.location == 0 && range1.length == 7) {
            
        }else{
            
            self.str_url = [NSString stringWithFormat:@"http://%@",self.str_url];
        }
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.str_url]]];
        [self.view addSubview:webView];
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
    
        [self backImgType:0];

    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (!isAppStore) {
        MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
        [pop setDelegate:self];
        [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
        [pop setText:@"请求失败"];
        [pop alertViewAutoHidden:.5f isRelease:YES];
    }
    
    [self performSelector:@selector(doBack) withObject:nil afterDelay:1];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    [bar setTitleLabelString:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    [self.headview setTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    
}

@end
