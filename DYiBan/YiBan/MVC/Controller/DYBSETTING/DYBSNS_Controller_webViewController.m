//
//  DYBSNS_Controller_webViewController.m
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSNS_Controller_webViewController.h"
#import "user.h"
#import "DYBParameter.h"
#import "DYBSynchroViewController.h"
@interface DYBSNS_Controller_webViewController ()

@end

@implementation DYBSNS_Controller_webViewController
@synthesize father = _father;

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.leftButton setHidden:NO];
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"同步"];
        [self setButtonImage:self.leftButton setImage:@"btn_back_def"];
        
        
        NSString *url =@"";
        if (self.tag==1) {
            
            url = [SHARED.curUser.auth_tencent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }else {
            url = [SHARED.curUser.auth_renren stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, self.headHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.headHeight)] autorelease];
        [webView setDelegate:self];
        url = [url stringByAppendingString:[NSString stringWithFormat:@"%@",SHARED.curUser.userid]];
        NSURL *nsurl = [NSURL URLWithString:url];
        [webView loadRequest:[NSURLRequest requestWithURL:nsurl]];
        
        
        [self.view addSubview:webView];
        
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *linkStr = [[request URL] absoluteString];
    
    if ([linkStr length] <= 0) {
        return NO;
    }
    if ([linkStr rangeOfString:@"tag=yiban_sync"].location != NSNotFound)
    {
        if ([linkStr rangeOfString:@"tag=yiban_sync_ok"].location != NSNotFound)
        {
            DLogInfo(@"绑定成功");
            int count = 0;
            if (self.tag==1) {
                count = 2;
            }else if(self.tag==2){
                count = 4;
            }
            
            [_father setSynchYes:self.tag];
            SHARED.curUser.sync_tag =[NSString stringWithFormat:@"%d",[SHARED.curUser.sync_tag intValue]+count];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"update_sns" object:[NSString stringWithFormat:@"%d",self.tag]];
        }
        else if([linkStr rangeOfString:@"tag=yiban_sync_failure"].location != NSNotFound)
        {
            DLogInfo(@"绑定失败");
        }
        [self dismissModalViewControllerAnimated:true];
        return NO;
    }
    return YES;
}

#pragma mark- 
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self dismissModalViewControllerAnimated:true];
        
    }
    
    
    
}




@end
