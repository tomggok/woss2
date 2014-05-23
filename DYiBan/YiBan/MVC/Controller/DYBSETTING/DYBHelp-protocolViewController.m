//
//  DYBHelp-protocolViewController.m
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBHelp-protocolViewController.h"

@interface DYBHelp_protocolViewController ()

@end

@implementation DYBHelp_protocolViewController
@synthesize tag = _tag,tle = _tle;
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.leftButton setHidden:NO];
        [self.rightButton setHidden:YES];
        [self.headview setTitle:_tle];
        [self backImgType:0];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        [self addWebView:_tag];
        
    }
}

//添加web
- (void)addWebView:(int)tag {
    
    UIWebView *web_view = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.headHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.headHeight)];
    [web_view setDelegate:self];
    [web_view setScalesPageToFit:YES];
    [self.view addSubview:web_view];
    [web_view setHidden:NO];
    RELEASE(web_view);
    
    
    if (_tag == 0) {
        [self loadDocument:@"help.txt" inView:web_view tag:_tag];
    }else{
        [self loadDocument:@"deal.txt" inView:web_view tag:_tag];
    }
}



-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView tag:(NSInteger)tag
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *url = nil;
    if (tag == 0) {
        url = [NSURL URLWithString:@"http://mobile.yiban.cn/api/pages/help.php"];
    }else{
        url = [NSURL URLWithString:@"http://mobile.yiban.cn/api/pages/clause.php"];
    }
    [webView loadHTMLString:content baseURL:url];
}


@end
