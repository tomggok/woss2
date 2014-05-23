//
//  DYBSettingNotesViewController.m
//  DYiBan
//
//  Created by Song on 13-10-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSettingNotesViewController.h"
#import "DYBSetButton.h"
#import "UserSettingMode.h"
#import "NSObject+MagicDatabase.h"
#import "NSObject+MagicRequestResponder.h"
#import "DYBUseBootstrapViewController.h"
#import "Magic_Device.h"
@interface DYBSettingNotesViewController (){
    
    MagicUILabel *uselabel;
    MagicUILabel *reduelabel;
    MagicUILabel *datelabel;
    MagicUILabel *drislabel;
    DYBSwitchButton *btnWifi;
    
    int WifiIsOn;
}

@end

@implementation DYBSettingNotesViewController

DEF_SIGNAL(DATABASEBUTTON)



- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"笔记设置"];
        [self backImgType:0];
        WifiIsOn = 0;
        MagicRequest *request = [DYBHttpMethod notes_setting:YES receive:self];
        [request setTag:1];
        
        
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        MagicUIScrollView *scroll = [[MagicUIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [scroll setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:scroll];
        RELEASE(scroll);
        
        NSArray *textArray = [[NSArray alloc]initWithObjects:@"容量：已用             总量",@"最近同步时间：",@"仅在wifi下，上传下载",[@"" stringByAppendingFormat:@"清除本地缓存(%@)",[self stringFromFileSize:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)objectAtIndex:0]]],@"转存后删除原笔记",@"使用引导", nil];
        
        ;
        DYBSetButton *settingButton[[textArray count]];
        
        int offect = 20;
        
        for (int i = 0; i < [textArray count]; i++) {
            
            if (i == 0 || i == 1 || i == 3) {
                
                if (i == 0) {
                    settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i, BUTTONWIDTH, BUTTONHEIGHT+offect) labelText:[textArray objectAtIndex:i] isArrow:YES type:1];
                    [settingButton[i].textLabel setFrame:CGRectMake(15, 5, BUTTONWIDTH-15, BUTTONHEIGHT-10)];
                    settingButton[i].tag = i;
                }else {
                    
                    settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, offect+OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:1];
                    settingButton[i].tag = i;
                }
                
            }
            else if (i == 2 || i == 4) {
                
                settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, offect+OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:0];
                settingButton[i].switchButton.tag = i;
                
                if (i == 2) {
                    [settingButton[i] setStatus:SHARED.currentUserSetting.notesWifiForPush];
                }else {
                    [settingButton[i] setStatus:SHARED.currentUserSetting.notesSaveForPush];
                }
                
            }else {
                
                settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, offect+OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i+OFFSETFROM, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:NO type:0];
                settingButton[i].tag = i;
            }
            
            [settingButton[i] addSignal:[DYBSettingNotesViewController DATABASEBUTTON] forControlEvents:UIControlEventTouchUpInside];
            
            [scroll addSubview:settingButton[i]];
            RELEASE(settingButton[i]);
        }
        
        
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH, [settingButton[[textArray count]-1] getLowy]+30);
        
        //已用流量
        uselabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(115, 8, 65, BUTTONHEIGHT-10)];
        [self setLabel:uselabel setText:@"" setButton:settingButton[0] setColor:[UIColor redColor]];
        //剩余流量
        reduelabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(223, 8, BUTTONWIDTH-223, BUTTONHEIGHT-10)];
        [self setLabel:reduelabel setText:@"" setButton:settingButton[0] setColor:[UIColor greenColor]];
        //文字提示
        drislabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(15, BUTTONHEIGHT-10, BUTTONWIDTH-15, offect)];
        [self setLabel:drislabel setText:@"可将笔记转存到个人资料库，节省笔记空间" setButton:settingButton[0] setColor:[MagicCommentMethod colorWithHex:@"aaaaaa"]];
        drislabel.font = [DYBShareinstaceDelegate DYBFoutStyle:14];
        
        //最后同步时间
        datelabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(150, 8, BUTTONWIDTH-150, BUTTONHEIGHT-10)];
        [self setLabel:datelabel setText:@"" setButton:settingButton[1] setColor:[MagicCommentMethod colorWithHex:@"333333"]];
        datelabel.font = [DYBShareinstaceDelegate DYBFoutStyle:14];  //字体和大小设置
    }
}

//添加label
- (void)setLabel:(MagicUILabel *)label setText:(NSString *)string setButton:(DYBSetButton *)btn setColor:(UIColor *)color{
    
    label.textAlignment = UIControlContentVerticalAlignmentCenter;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [DYBShareinstaceDelegate DYBFoutStyle:15];  //字体和大小设置
    label.text = string;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    [btn addSubview:label];
    RELEASE(label);
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

- (void)requestString:(NSString *)tagHttp {
    
    if (SHARED.currentUserSetting.teacherPush) {
        if (tagHttp.length == 0) {
            tagHttp = @"11";
        }else{
            tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,11];
        }
    }
    
    if (SHARED.currentUserSetting.evaluatePush) {
        if (tagHttp.length == 0) {
            tagHttp = @"5";
        }else{
            tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,5];
        }
    }
    
    if (SHARED.currentUserSetting.privateMessagePush) {
        if (tagHttp.length == 0) {
            tagHttp = @"8";
        }else{
            tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,8];
        }
    }
    
    if (SHARED.currentUserSetting.atMePush) {
        if (tagHttp.length == 0) {
            tagHttp = @"6";
        }else{
            tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,6];
        }
    }
    
    if (SHARED.currentUserSetting.addMePush) {
        if (tagHttp.length == 0) {
            tagHttp = @"10";
        }else{
            tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,10];
        }
    }
    
    if (SHARED.currentUserSetting.jobPush) {
        if (tagHttp.length == 0) {
            tagHttp = @"12";
        }else{
            tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,12];
        }
    }
    
    if (SHARED.currentUserSetting.dataBasePush) {
        if (tagHttp.length == 0) {
            tagHttp = @"13";
        }else{
            tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,13];
        }
    }
    
    if (SHARED.currentUserSetting.wifiForPush) {
        if (tagHttp.length == 0) {
            tagHttp = @"14";
        }else{
            tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,14];
        }
    }

}

- (void)handleViewSignal_DYBSetButton:(MagicViewSignal *)signal {
    
    if (WifiIsOn == 1) {
        WifiIsOn = 0;
        return;
    }
    
    NSDictionary *dict = (NSDictionary *)[signal object];
    DYBSwitchButton *btn = [dict objectForKey:@"switchButton"];
    NSString *onOff = [dict objectForKey:@"isOn"];
    NSString *tagHttp = @"";
    NSString *time = @"";
    
    [self requestString:tagHttp];
        
    if (btn.tag == 2) {
        
        if (SHARED.currentUserSetting.notesWifiForPush == YES) {
            btnWifi = btn;
            [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"关闭仅在WIFI下同步笔记会消耗你的数据流量，是否继续？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
            return;
        }
        
        [btn setOn:[onOff boolValue] animated:YES];
        [SHARED.currentUserSetting setNotesWifiForPush:[onOff boolValue]];
    }
    
    //修改为删除笔记
    if (btn.tag == 4) {
        [btn setOn:[onOff boolValue] animated:YES];
        [SHARED.currentUserSetting setNotesSaveForPush:[onOff boolValue]];
    }
    
    
    for (int j = 0; j < 2; j++) {
        
        if (j == 0 && [SHARED.currentUserSetting notesWifiForPush]) {
            if (tagHttp.length == 0) {
                tagHttp = @"15";
            }else{
                tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,15];
            }
        }
        
        if (j == 1 && [SHARED.currentUserSetting notesSaveForPush]) {
            if (tagHttp.length == 0) {
                tagHttp = @"16";
            }else{
                tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,16];
            }
        }
    }
    
    
    //disturb_time: 免打扰时间，
    if ([SHARED.currentUserSetting timeForNoPush]) {
        time = @"22-8";
    }
    
    MagicRequest *request = [DYBHttpMethod user_setpush:tagHttp isDisturb:SHARED.currentUserSetting.timeForNoPush disturb_time:time isAlert:YES receive:self];
    [request setTag:2];
    
}

-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        WifiIsOn = 0;
        if (![MagicDevice hasInternetConnection]){
            DLogInfo(@"确定是否网络连接");
            return;
        }
        
        NSString *tagHttp = @"";
        NSString *time = @"";
        
        [self requestString:tagHttp];
        [btnWifi setOn:NO animated:YES];
        [SHARED.currentUserSetting setNotesWifiForPush:NO];
        
        for (int j = 0; j < 2; j++) {
            
            if (j == 0 && [SHARED.currentUserSetting notesWifiForPush]) {
                if (tagHttp.length == 0) {
                    tagHttp = @"15";
                }else{
                    tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,15];
                }
            }
            
            if (j == 1 && [SHARED.currentUserSetting notesSaveForPush]) {
                if (tagHttp.length == 0) {
                    tagHttp = @"16";
                }else{
                    tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,16];
                }
            }
        }
        
        
        //disturb_time: 免打扰时间，
        if ([SHARED.currentUserSetting timeForNoPush]) {
            time = @"22-8";
        }
        
        MagicRequest *request = [DYBHttpMethod user_setpush:tagHttp isDisturb:SHARED.currentUserSetting.timeForNoPush disturb_time:time isAlert:YES receive:self];
        [request setTag:2];

        
        
    }
    if ([signal is:[DYBDataBankShotView LEFT]]) {
        WifiIsOn = 1;
        [btnWifi setOn:YES animated:YES];
    }
    
    
}

#pragma mark- 按钮点击
- (void)handleViewSignal_DYBSettingNotesViewController:(MagicViewSignal *)signal
{
    DYBSetButton *btn = signal.source;
    
    //按钮点击
    if ([signal is:[DYBSettingNotesViewController DATABASEBUTTON]])
    {
        switch (btn.tag) {
                
            case 3:
                [self cleanCaches:btn atPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)objectAtIndex:0]];
                break;
            case 5:
            {
                DYBUseBootstrapViewController *vc = [[DYBUseBootstrapViewController alloc] init];
                [vc setType:2];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
                
                
            }
                
                break;
            default:
                break;
        }
        
    }
    
    
}



#pragma mark- 获取缓存 清除缓存
- (NSString *)stringFromFileSize:(NSString *)folderPath
{
    NSArray *contents;
    NSEnumerator *enumerator;
    NSString *path;
    contents = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    enumerator = [contents objectEnumerator];
    int fileSizeInt = 0;
    while (path = [enumerator nextObject]) {
        NSDictionary *fattrib = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:path] error:nil];
        fileSizeInt +=[fattrib fileSize];
    }
    
    float floatSize = fileSizeInt;
    if (fileSizeInt<1023)
        return([NSString stringWithFormat:@"%i bytes",fileSizeInt]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
    floatSize = floatSize / 1024;
    return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}




- (void)cleanCaches:(DYBSetButton *)btn atPath:(NSString *)cachPath {
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    for (NSString *p in files) {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    
    [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(clearCacheSuccess:) userInfo:btn repeats:NO];
    
}

-(void)clearCacheSuccess:(NSTimer *)timer
{
    DYBSetButton *btn = timer.userInfo;
    
    [btn.textLabel setText:[@"" stringByAppendingFormat:@"清除本地缓存(%d bytes)",0]];
    [DYBShareinstaceDelegate loadFinishAlertView:@"成功清除本地缓存" target:self];
}

//返回容量大小
- (NSString *)changGMKB:(long long)size {
    
    float floatSize = size;
    
    if (size<1023)
        return([NSString stringWithFormat:@"%lld bytes",size]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
    floatSize = floatSize / 1024;
    return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        
        //获取容量
        if (request.tag == 1) {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                
                DLogInfo(@"=====%@",[response data]);
                uselabel.text = [@"" stringByAppendingFormat:@"%@",[self changGMKB:[[[response data] objectForKey:@"usespace"] longLongValue]]];
                
                
                unsigned long long reduesize = [[[response data] objectForKey:@"maxspace"] longLongValue];
                
                DLogInfo(@"===%@",[[response data] objectForKey:@"last_update_time"]);
//                NSDate *date = [NSDate date];
                if (![[response data] objectForKey:@"last_update_time"]) {
                    NSDate *localeDate = [NSDate  dateWithTimeIntervalSince1970:[[[response data] objectForKey:@"last_update_time"] floatValue]];
                    
                    NSDateFormatter *dateFomat = [SHARED dateFormatter];
                    [dateFomat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *date = [dateFomat stringFromDate:localeDate];
                    DLogInfo(@"time === %@", date);
                    datelabel.text = date;

                }else {
                    datelabel.text = @"";
                }
                
                reduelabel.text = [@"" stringByAppendingFormat:@"%@",[self changGMKB:reduesize]];
                
            }
            if ([response response] ==khttpfailCode)
            {
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                
            }
        }
        
        //设置推送
        if (request.tag == 2 || request.tag == 4) {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            
            if ([response response] ==khttpsucceedCode)
            {
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                DLogInfo(@"打开成功");
                //                [SHARED.currentUserSetting setWifiForPush:YES];
                self.view.userInteractionEnabled = YES;
                
            }else if ([response response] ==khttpfailCode)
            {
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                DLogInfo(@"解除绑定失败");
                self.view.userInteractionEnabled = YES;
                
            }
        }
    }
    
}

@end
