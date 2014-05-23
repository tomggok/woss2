//
//  DYBSNSSyncViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-10.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSNSSyncViewController.h"
#import "user.h"
#import "DYBPublishViewController.h"

@interface DYBSNSSyncViewController ()

@end

@implementation DYBSNSSyncViewController

- (id)init:(NSInteger)snsType{
    self = [super init];
    if (self) {
        _snsType = snsType;
    }
    return self;
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.headview setTitle:@"连接中..."];
        [self backImgType:0];
        
    }else if ([signal is:[MagicViewController CREATE_VIEWS]]){
        
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        MagicUIWebView *webView = [[MagicUIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - self.headHeight)];
        
        if (_snsType == 1) {
            _strURL = [SHARED.curUser.auth_tencent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }else{
            _strURL = [SHARED.curUser.auth_renren stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        _strURL = [_strURL stringByAppendingString:SHARED.curUser.userid];
        
        [webView setUrl:_strURL];
        [self.view addSubview:webView];
        RELEASE(webView);
    }
}

- (void)handleViewSignal_MagicUIWebView:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIWebView DIDLOADFINISH]]){
        MagicUIWebView *webView = (MagicUIWebView *)[signal source];
        [self.headview setTitle: [webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    }else if ([signal is:[MagicUIWebView WILLSTART]]){        
        NSString *linkStr = (NSString *)[signal object];
        
        if ([linkStr length] <= 0) {
            return;
        }
        
        if ([linkStr rangeOfString:@"tag=yiban_sync"].location != NSNotFound){
            if ([linkStr rangeOfString:@"tag=yiban_sync_ok"].location != NSNotFound){
                MagicUIWebView *webView = (MagicUIWebView *)[signal source];
                [webView setHidden:YES];
                
                [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"绑定成功!" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",3]];
                
                int nAdd = 0;
                
                if (_snsType == 1) {
                    nAdd = 2;
                }else{
                    nAdd = 4;
                }
                
                SHARED.curUser.sync_tag = [NSString stringWithFormat:@"%d", [SHARED.curUser.sync_tag intValue] + nAdd];
                
                NSDictionary *dicResult = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"result", [NSString stringWithFormat:@"%d", _snsType], @"type", nil];  
                if ([[self.drNavigationController allviewControllers] objectAtIndex:2] != nil) {
                    [self sendViewSignal:[DYBPublishViewController SYNCRESULT] withObject:dicResult from:self target:[[self.drNavigationController allviewControllers] objectAtIndex:2]];
                }              
                RELEASE(dicResult);
                
            }else{
                [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"绑定失败!" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
                
                NSDictionary *dicResult = [[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"result", [NSString stringWithFormat:@"%d", _snsType], @"type", nil];
                if ([[self.drNavigationController allviewControllers] objectAtIndex:2] != nil) {
                    [self sendViewSignal:[DYBPublishViewController SYNCRESULT] withObject:dicResult from:self target:[[self.drNavigationController allviewControllers] objectAtIndex:2]];
                }
                RELEASE(dicResult);
                
                [self.drNavigationController popVCAnimated:YES];
                [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
            }
        }
    }
    
}

-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        NSDictionary *dicType = (NSDictionary *)[signal object];
        NSString *strType = [dicType objectForKey:@"type"];
        int row = [[dicType objectForKey:@"rowNum"] intValue];
        
        if ([strType intValue] == BTNTAG_SINGLE) {
            if (row == 3) {
                [self.drNavigationController popVCAnimated:YES];
                [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
            }
        }
    }
}

@end
