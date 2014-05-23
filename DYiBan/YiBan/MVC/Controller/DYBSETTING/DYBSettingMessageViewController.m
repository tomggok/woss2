//
//  DYBSettingMessageViewController.m
//  DYiBan
//
//  Created by Song on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSettingMessageViewController.h"
#import "DYBSetButton.h"
#import "NSObject+SBJSON.h"
#import "UserSettingMode.h"
@interface DYBSettingMessageViewController () 

@end

@implementation DYBSettingMessageViewController

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"消息提醒"];
        [self backImgType:0];
        
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        
        MagicUIScrollView *scroll = [[MagicUIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [scroll setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:scroll];
        RELEASE(scroll);
        
        
        NSArray *textArray = [[NSArray alloc]initWithObjects:@"辅导员通知",@"有人评论我",@"有人私信我",@"有人@我",@"有人加好友",@"就业信息",@"免打扰(22:00-8:00)", nil];
        NSArray *statusArray = @[[@"" stringByAppendingFormat:@"%d",SHARED.currentUserSetting.teacherPush],[@"" stringByAppendingFormat:@"%d",SHARED.currentUserSetting.evaluatePush],[@"" stringByAppendingFormat:@"%d",SHARED.currentUserSetting.privateMessagePush],[@"" stringByAppendingFormat:@"%d",SHARED.currentUserSetting.atMePush],[@"" stringByAppendingFormat:@"%d",SHARED.currentUserSetting.addMePush],[@"" stringByAppendingFormat:@"%d",SHARED.currentUserSetting.jobPush],[@"" stringByAppendingFormat:@"%d",SHARED.currentUserSetting.timeForNoPush]];
        DYBSetButton *settingButton[[textArray count]];
        
        for (int i = 0; i < [textArray count]; i++) {
            
            
            DLogInfo(@"========%d",[[statusArray objectAtIndex:i] boolValue]);
            
            
            if (i < 5) {
                
                settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:0];
                
            }else if (i == 5) {
                
                settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i+OFFSETFROM, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:0];
                
            }else {
                
                settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i+OFFSETFROM*2, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:0];
                
            }
            
            settingButton[i].switchButton.tag = i+1;
            [settingButton[i] setStatus:[[statusArray objectAtIndex:i] boolValue]];
            
            [scroll addSubview:settingButton[i]];
            RELEASE(settingButton[i]);
            
        }
        //辅导员通知状态
        
        
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH, [settingButton[6] getLowy]+50);
    }
       
}

#pragma mark- 
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        //        DYBRegisterStep2ViewController *vc = [[DYBRegisterStep2ViewController alloc] init];
        //        [self.drNavigationController pushViewController:vc animated:YES];
        //        RELEASE(vc);
        
    }
    
}


- (void)handleViewSignal_DYBSetButton:(MagicViewSignal *)signal {
    
    self.view.userInteractionEnabled = NO;
    NSString *tagHttp = @"";
    NSString *time = @"";
    NSDictionary *dict = (NSDictionary *)[signal object];
    DYBSwitchButton *btn = [dict objectForKey:@"switchButton"];
    NSString *onOff = [dict objectForKey:@"isOn"];
    
    if ([signal is:[DYBSetButton SWITCHBTN]]) {
        
        if (btn.tag == 1) {
            
            [btn setOn:[onOff boolValue] animated:YES];
            [SHARED.currentUserSetting setTeacherPush:[onOff boolValue]];
        }
        
        if (btn.tag == 2) {
            
            [btn setOn:[onOff boolValue] animated:YES];
            [SHARED.currentUserSetting setEvaluatePush:[onOff boolValue]];
        }
        if (btn.tag == 3) {
            
            [btn setOn:[onOff boolValue] animated:YES];
            [SHARED.currentUserSetting setPrivateMessagePush:[onOff boolValue]];
        }
        if (btn.tag == 4) {
            
            [btn setOn:[onOff boolValue] animated:YES];
            [SHARED.currentUserSetting setAtMePush:[onOff boolValue]];
        }
        if (btn.tag == 5) {
            
            [btn setOn:[onOff boolValue] animated:YES];
            [SHARED.currentUserSetting setAddMePush:[onOff boolValue]];
        }
        if (btn.tag == 6) {
            
            [btn setOn:[onOff boolValue] animated:YES];
            [SHARED.currentUserSetting setJobPush:[onOff boolValue]];
        }
        if (btn.tag == 7) {
            
            [btn setOn:[onOff boolValue] animated:YES];
            [SHARED.currentUserSetting setTimeForNoPush:[onOff boolValue]];
        }
       
        
        for (int j = 0; j < 6; j++) {
            
            if (j == 0 && SHARED.currentUserSetting.teacherPush) {
                if (tagHttp.length == 0) {
                    tagHttp = @"11";
                }else{
                    tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,11];
                }
            }
            
            if (j == 1 && SHARED.currentUserSetting.evaluatePush) {
                if (tagHttp.length == 0) {
                    tagHttp = @"5";
                }else{
                    tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,5];
                }
            }
            
            if (j == 2 && SHARED.currentUserSetting.privateMessagePush) {
                if (tagHttp.length == 0) {
                    tagHttp = @"8";
                }else{
                    tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,8];
                }
            }
            
            if (j == 3 && SHARED.currentUserSetting.atMePush) {
                if (tagHttp.length == 0) {
                    tagHttp = @"6";
                }else{
                    tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,6];
                }
            }
            
            if (j == 4 && SHARED.currentUserSetting.addMePush) {
                if (tagHttp.length == 0) {
                    tagHttp = @"10";
                }else{
                    tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,10];
                }
            }
            
            if (j == 5 && SHARED.currentUserSetting.jobPush) {
                if (tagHttp.length == 0) {
                    tagHttp = @"12";
                }else{
                    tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,12];
                }
            }
            
        }
        
        if (SHARED.currentUserSetting.wifiForPush) {
            
            if (tagHttp.length == 0) {
                tagHttp = @"14";
            }else{
                tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,14];
            }
        }
        
        if (SHARED.currentUserSetting.dataBasePush) {
            
            if (tagHttp.length == 0) {
                tagHttp = @"13";
            }else{
                tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,13];
            }
        }
        
        if (SHARED.currentUserSetting.notesWifiForPush) {
            if (tagHttp.length == 0) {
                tagHttp = @"15";
            }else{
                tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,15];
            }
        }
        
        if (SHARED.currentUserSetting.notesSaveForPush) {
            if (tagHttp.length == 0) {
                tagHttp = @"16";
            }else{
                tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,16];
            }
        }
        
        

        //disturb_time: 免打扰时间，
        if ([SHARED.currentUserSetting timeForNoPush]) {
            time = @"22-8";
        }
        
        MagicRequest *request = [DYBHttpMethod user_setpush:tagHttp isDisturb:SHARED.currentUserSetting.timeForNoPush disturb_time:time isAlert:YES receive:self];
        [request setTag:1];
        
        
        
    }
    
}


#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        
        JsonResponse *response = (JsonResponse *)receiveObj;
        
        if ([response response] ==khttpsucceedCode)
        {
            [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
            DLogInfo(@"打开成功");
            self.view.userInteractionEnabled = YES;
            
        }else if ([response response] ==khttpfailCode)
        {
            [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
            DLogInfo(@"解除绑定失败");
            self.view.userInteractionEnabled = YES;
            
        }
        
    }
    self.view.userInteractionEnabled = YES;
}

@end
