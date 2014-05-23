//
//  DYBSettingViewController.m
//  DYiBan
//
//  Created by Song on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSettingViewController.h"
#import "DYBSettingMessageViewController.h"
#import "DYBSettingImageViewController.h"
#import "DYBDataBaseViewController.h"
#import "DYBSynchroViewController.h"
#import "Magic_UIAlertView.h"
#import "DYBSetButton.h"
#import "DYBScroller.h"
#import "DYBHelp-protocolViewController.h"
#import "version.h"
#import "Magic_Device.h"
#import "DYBSettingSendMessViewController.h"
#import "DYBDataBankShotView.h"
#import "DYBLoginViewController.h"

#import "DYBUITabbarViewController.h"
#import "DYBGifView.h"
#import "UserSettingMode.h"
#import "user.h"
#import "DYBSettingNotesViewController.h"

#import "NSObject+MagicDatabase.h"

@interface DYBSettingViewController () {
    
    version *ver;
    
    DYBDataBankShotView *showView;//推出按钮
    DYBSetButton *settingButton[10];
    DYBGifView *dataView;
}

@end

@implementation DYBSettingViewController
@synthesize showTag = _showTag;
DEF_SIGNAL(MUSICBUTTON)//音乐按钮
DEF_SIGNAL(LOGOUTBUTTON)//退出系统
DEF_SIGNAL(TOUCHBUTTON)//点击消息

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"设置"];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        
        MagicUIScrollView *scroll = [[MagicUIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [scroll setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:scroll];
        RELEASE(scroll);
        
        //版本号
        NSString *str = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        NSString *version = [@"" stringByAppendingFormat:@"版本检测(当前版本：%@)",str];
        NSArray *textArray = @[@"消息提醒",@"音效",@"图片",@"同步",@"资料库",@"笔记",@"意见反馈",@"帮助",@"用户协议",version];
//        NSArray *textArray = @[@"消息提醒",@"图片",@"同步",@"资料库",@"意见反馈",@"帮助",@"用户协议",version];
        
        for (int i = 0; i < 10; i++) {
            
            if (i < 4) {
                
                if (i == 1) {
                    
                    settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:0];
                    settingButton[i].switchButton.tag = 0;
                    
//                    [settingButton[i] setStatus:SHARED.currentUserSetting.sound];
                    [settingButton[i] setStatus:NO];
                    [settingButton[i] setUserInteractionEnabled:NO];
                    
                }else {
                    
                    settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:NO type:0];
                }
                
            }else if (i == 4 || i == 5) {
                
                settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i+OFFSETFROM, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:NO type:0];
//                if (i == 5) {
//                    //隐藏笔记
//                    settingButton[i].hidden = YES;
//                }
                
            }else if (i == 9){
                
                settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i+OFFSETFROM*3, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:1];
            }else {
                
                settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i+OFFSETFROM*2, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:NO type:0];
                
            }
            
            settingButton[i].tag = i;
            [settingButton[i] addSignal:[DYBSettingViewController TOUCHBUTTON] forControlEvents:UIControlEventTouchUpInside];
            
            [scroll addSubview:settingButton[i]];
            RELEASE(settingButton[i]);
            
        }
        
        
        if ([SHARED.curUser.verify isEqualToString:@"0"]) {
            
            settingButton[4].userInteractionEnabled = NO;
            
            
        }
        
        
        //退出系统
        MagicUIButton *logoutButton = [[MagicUIButton alloc] initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*10+60, BUTTONWIDTH, BUTTONHEIGHT)];
        [logoutButton addSignal:[DYBSettingViewController LOGOUTBUTTON] forControlEvents:UIControlEventTouchUpInside];
        logoutButton.titleLabel.font = [DYBShareinstaceDelegate DYBFoutStyle:20];
        [logoutButton setTitle:@"退出帐号" forState:UIControlStateNormal];
        logoutButton.backgroundColor = [UIColor redColor];
        [scroll addSubview:logoutButton];
        RELEASE(logoutButton);
        
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH, [settingButton[9] getLowy]+45+logoutButton.frame.size.height);
        
    }
}

#pragma makr -
#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        DYBUITabbarViewController *dync = [DYBUITabbarViewController sharedInstace];
        [dync scrollMainView:1];
    }
    
}

- (void)handleViewSignal_DYBSetButton:(MagicViewSignal *)signal {
    
    NSDictionary *dict = (NSDictionary *)[signal object];
    DYBSwitchButton *btn = [dict objectForKey:@"switchButton"];
    NSString *onOff = [dict objectForKey:@"isOn"];
    
    [btn setOn:[onOff boolValue] animated:YES];
    [SHARED.currentUserSetting setSound:[onOff boolValue]];
        
}


#pragma mark- 按钮点击
- (void)handleViewSignal_DYBSettingViewController:(MagicViewSignal *)signal
{
    MagicUIButton *btn = signal.source;
    
    if ([signal is:[DYBSettingViewController MUSICBUTTON]])
    {
        if (btn.tag == 0) {
            
            [btn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
            btn.tag = 1;
            
        }else {
            
            [btn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
            btn.tag = 0;
            
        }
    }
    if ([signal is:[DYBSettingViewController TOUCHBUTTON]])
    {
        switch (btn.tag) {
            case 0:{
                DYBSettingMessageViewController *vc = [[DYBSettingMessageViewController alloc] init];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);;
                }
                break;
            case 1:
                break;
            case 2:{
                DYBSettingImageViewController *vc = [[DYBSettingImageViewController alloc] init];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
            }
                break;
            case 3:{
                DYBSynchroViewController *vc = [[DYBSynchroViewController alloc] init];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
            }
                break;
            case 4:{
                DYBDataBaseViewController *vc = [[DYBDataBaseViewController alloc] init];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
            }
                break;
            case 5:{
                DYBSettingNotesViewController *vc = [[DYBSettingNotesViewController alloc] init];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
            }
                break;
            case 6: {
                DYBSettingSendMessViewController *vc = [[DYBSettingSendMessViewController alloc] init];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
            }
                break;
            case 7:
            case 8:{
                DYBHelp_protocolViewController *vc = [[DYBHelp_protocolViewController alloc] init];
                
                if (btn.tag == 7) {
                    
                    [vc setTag:0];
                    [vc setTle:@"帮助"];
                    
                }else {
                    
                    [vc setTag:1];
                    [vc setTle:@"用户协议"];
                    
                }
                
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
            
            }
                break;
            case 9:{
            
                self.view.userInteractionEnabled = NO;
                if (![MagicDevice hasInternetConnection]){
                    DLogInfo(@"确定是否网络连接");
                    self.view.userInteractionEnabled = YES;
                    return;
                }
                
                NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yb_loading_small" ofType:@"gif"]];
                
                dataView = [[DYBGifView alloc] initWithFrame:CGRectMake(([settingButton[9] getWidth]-30)/2,([settingButton[9] getHeight]-6)/2 , 60/2, 12/2) data:localData];
                settingButton[9].textLabel.hidden = YES;
                [settingButton[9] addSubview:dataView];
                RELEASE(dataView);
                
                [NSTimer scheduledTimerWithTimeInterval:1.1f target:self selector:@selector(site_version) userInfo:nil repeats:NO];
                
            }
                break;
            default:
                break;
        }
        
    }
    
    
    if ([signal is:[DYBSettingViewController LOGOUTBUTTON]])
    {
        [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要退出？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
        _showTag = 1;
    }
    
    
}

- (void)site_version {
    if (dataView) {
        [dataView removeFromSuperview];
        dataView = nil;
    }
    self.view.userInteractionEnabled = YES;
    settingButton[9].textLabel.hidden = NO;
    MagicRequest *request = [DYBHttpMethod site_version:YES receive:self];
    [request setTag:1];
}


-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    if (_showTag == 1) {
        if ([signal is:[DYBDataBankShotView RIGHT]]) {
            
            if (![MagicDevice hasInternetConnection]){
                DLogInfo(@"确定是否网络连接");
                return;
            }
            MagicRequest *request = [DYBHttpMethod user_security_logout:YES receive:self];
            [request setTag:2];
            
        }
    }
    
    if (_showTag == 2) {
        
        if ([signal is:[DYBDataBankShotView RIGHT]]) {
            
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[ver url]]];
            
        }
    }

//    if (_showTag == 3) {
//        
//        if ([signal is:[DYBDataBankShotView RIGHT]]) {
//            
//        }
//    }


}


#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        if (request.tag == 1) {
    
            JsonResponse *response = (JsonResponse *)receiveObj;
            
//            [version JSONReflection:[[response data] objectForKey:@"version"]];
            
            
            DLogInfo(@"=========版本号＝＝＝＝%@",[response data]);
            ver = [version JSONReflection:[response data]];
            
            
            DLogInfo(@"=========版本号＝＝＝＝%@",ver.version_code);
           
            
            
            
            if ([response response] ==khttpsucceedCode)
            {
                [DYBShareinstaceDelegate loadFinishAlertView:@"已经是最新版本!" target:self];
                
//                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"已经是最新版本!" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
//                _showTag = 3;
                
            }else if ([response response] ==khttpNeedUpdateCode)
            {
                [DYBShareinstaceDelegate addConfirmViewTitle:@"版本更新" MSG:[@"" stringByAppendingFormat:@"检测到新版本%@是否更新？",ver.version] targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
                _showTag = 2;
            }
        }
        
        if (request.tag == 2) {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            
            DLogInfo(@"%@",[response data]);
            [self.drNavigationController popToRootViewControllerAnimated:YES];
            
            self.DB.
            FROM(k_NoteListDateBase).
            DROP();
            
        }
        
    }
    
    self.view.userInteractionEnabled = YES;
    
}

@end