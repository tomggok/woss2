//
//  DYBDataBaseViewController.m
//  DYiBan
//
//  Created by Song on 13-8-20.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBaseViewController.h"
#import "DYBSetButton.h"
#import "UserSettingMode.h"
#import "NSObject+MagicDatabase.h"
#import "NSObject+MagicRequestResponder.h"
#import "DYBUseBootstrapViewController.h"
@interface DYBDataBaseViewController () {
    
    MagicUILabel *uselabel;
    MagicUILabel *reduelabel;
    MagicUILabel *datelabel;
    MagicUILabel *drislabel;
}

@end

@implementation DYBDataBaseViewController
DEF_SIGNAL(DATABASEBUTTON)



- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"资料库"];
        [self backImgType:0];
        
        MagicRequest *request = [DYBHttpMethod document_userspace:YES receive:self];
        [request setTag:1];
        
        
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        MagicUIScrollView *scroll = [[MagicUIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [scroll setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:scroll];
        RELEASE(scroll);
        
        NSArray *textArray = [[NSArray alloc]initWithObjects:@"容量：已用             总量",@"最近同步时间：",@"仅在wifi下，上传下载",[@"" stringByAppendingFormat:@"清除本地缓存(%@)",[self stringFromFileSize:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)objectAtIndex:0]]],[@"" stringByAppendingFormat:@"清除离线文件(%@)",[self stringFromFileSize:[MagicCommentMethod downloadPath]]],@"消息提醒推送",@"使用引导", nil];
        
        ;
        DYBSetButton *settingButton[[textArray count]];
        int offect = 20;
        for (int i = 0; i < [textArray count]; i++) {
            
            if (i == 1) {//隐藏同步时间
                settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*0, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:0];
                settingButton[i].hidden = YES;
                settingButton[i].tag = i;
            }else if (i == 0) {
                settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:1];
                settingButton[i].tag = i;
            }
            else if (i == 2 || i==5) {
                
                if (i == 2) {
                    settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*(i-1), BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:0];
                    [settingButton[i] setStatus:SHARED.currentUserSetting.wifiForPush];
                }else {
                    settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*(i-1)+offect, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:0];
                    [settingButton[i] setStatus:SHARED.currentUserSetting.dataBasePush];
                }
                settingButton[i].switchButton.tag = i;
                
            }else if (i == [textArray count]-1){
                
                settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*(i-1)+OFFSETFROM+offect, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:NO type:0];
                settingButton[i].tag = i;
            }else {
                
                if (i == 4) {
                    settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*(i-1), BUTTONWIDTH, BUTTONHEIGHT+offect) labelText:[textArray objectAtIndex:i] isArrow:YES type:1];
                    [settingButton[i].textLabel setFrame:CGRectMake(15, 5, BUTTONWIDTH-15, BUTTONHEIGHT-10)];
                }else if(i > 4) {
                    settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*(i-1)+offect, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:1];
                }else {
                    settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*(i-1), BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:1];
                }
                
                
                settingButton[i].tag = i;
            }
            
            [settingButton[i] addSignal:[DYBDataBaseViewController DATABASEBUTTON] forControlEvents:UIControlEventTouchUpInside];
            
            [scroll addSubview:settingButton[i]];
            RELEASE(settingButton[i]);
        }
        
        
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH, [settingButton[[textArray count]-1] getLowy]+30);
        
        //已用流量
        uselabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(115, 8, 65, BUTTONHEIGHT-10)];
        [self setLabel:uselabel setText:@"1002M" setButton:settingButton[0] setColor:[UIColor redColor]];
        //剩余流量
        reduelabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(223, 8, BUTTONWIDTH-223, BUTTONHEIGHT-10)];
        [self setLabel:reduelabel setText:@"4.1G" setButton:settingButton[0] setColor:[UIColor greenColor]];
        //最后同步时间
        datelabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(150, 8, BUTTONWIDTH-150, BUTTONHEIGHT-10)];
        [self setLabel:datelabel setText:@"2013-8-20" setButton:settingButton[1] setColor:[MagicCommentMethod colorWithHex:@"333333"]];
        datelabel.font = [DYBShareinstaceDelegate DYBFoutStyle:14];  //字体和大小设置
        
        //文字提示
        drislabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(15, BUTTONHEIGHT-10, BUTTONWIDTH-15, offect)];
        [self setLabel:drislabel setText:@"清除用于离线查看的文件可释放本地存储空间" setButton:settingButton[4] setColor:[MagicCommentMethod colorWithHex:@"aaaaaa"]];
        drislabel.font = [DYBShareinstaceDelegate DYBFoutStyle:12];
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

- (void)handleViewSignal_DYBSetButton:(MagicViewSignal *)signal {
    
    NSDictionary *dict = (NSDictionary *)[signal object];
    DYBSwitchButton *btn = [dict objectForKey:@"switchButton"];
    NSString *onOff = [dict objectForKey:@"isOn"];
    
    NSString *tagHttp = @"";
    NSString *time = @"";
    
    
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
    
    

    if (btn.tag == 2) {
        [btn setOn:[onOff boolValue] animated:YES];
        [SHARED.currentUserSetting setWifiForPush:[onOff boolValue]];
//        tagHttp = @"14";
    }
    
    if (btn.tag == 5) {
        [btn setOn:[onOff boolValue] animated:YES];
        [SHARED.currentUserSetting setDataBasePush:[onOff boolValue]];
//        tagHttp = @"13";
    }
    
    
    
    
    
    
    for (int j = 0; j < 2; j++) {
        
        if (j == 0 && [SHARED.currentUserSetting wifiForPush]) {
            if (tagHttp.length == 0) {
                tagHttp = @"14";
            }else{
                tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,14];
            }
        }
        
        if (j == 1 && [SHARED.currentUserSetting dataBasePush]) {
            if (tagHttp.length == 0) {
                tagHttp = @"13";
            }else{
                tagHttp = [NSString stringWithFormat:@"%@,%d",tagHttp,13];
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

#pragma mark- 按钮点击
- (void)handleViewSignal_DYBDataBaseViewController:(MagicViewSignal *)signal
{
    DYBSetButton *btn = signal.source;
    
    //按钮点击
    if ([signal is:[DYBDataBaseViewController DATABASEBUTTON]])
    {
        switch (btn.tag) {
                
            case 3:
                [self cleanCaches:btn atPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)objectAtIndex:0]];
                break;
            case 4:
            {
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    [self chearDataBase:@"1"];
                    [self chearDataBase:@"2"];
                    [self chearDataBase:@"3"];
                    
                }completion:^(BOOL b){
                    if (b) {
                        
                        [self cleanCaches:btn atPath:[MagicCommentMethod downloadPath]];
                        
                    }
                }];
                
                
            }
                break;
            case 6:
            {
                DYBUseBootstrapViewController *vc = [[DYBUseBootstrapViewController alloc] init];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
                
                
            }
                
                break;
            default:
                break;
        }
        
    }
    
    
}


- (void)chearDataBase:(NSString *)string {
    
    self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", string).WHERE(@"userid", SHARED.userId).GET();
    NSArray *sqlResutl = self.DB.resultArray;
    
    for (int i = 0; i < [sqlResutl count]; i++)
    {
        NSDictionary *dict = [sqlResutl objectAtIndex:i];
        NSString *url = [dict objectForKey:@"url"];
//        NSString *file_urlencode = [dict objectForKey:@"deCodeUerl"];
        
        self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", url).WHERE(@"userid", SHARED.userId).DELETE();
        self.DB.FROM(kDATABANKDOWNDETAIL).WHERE(@"file_urlencode", url).WHERE(@"userid", SHARED.userId).DELETE();
        NSString *downName = [self downPathFileNameWithUrl:url];
        [MagicSandbox deleteFile:downName];
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
    
    if (btn.tag == 4) {
        
        [btn.textLabel setText:[@"" stringByAppendingFormat:@"清除离线文件(%@)",[self stringFromFileSize:[MagicCommentMethod downloadPath]]]];
        [DYBShareinstaceDelegate loadFinishAlertView:@"离线文件清除成功" target:self];
        
    }else {
        
//        NSString *string;
//        if ([[self stringFromFileSize:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)objectAtIndex:0]] isEqualToString:@"102 bytes"]) {
//            
//            string =@"0 bytes";
//        }else {
//            string = [self stringFromFileSize:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)objectAtIndex:0]];
//        }
        
        [btn.textLabel setText:[@"" stringByAppendingFormat:@"清除本地缓存(%d bytes)",0]];
        [DYBShareinstaceDelegate loadFinishAlertView:@"成功清除本地缓存" target:self];
    }
    
    
    
    
    
    
    
//    caches = [NSString stringWithFormat:@"清除缓存(%@)", [self stringFromFileSize]];
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
                uselabel.text = [@"" stringByAppendingFormat:@"%@",[self changGMKB:[[[response data] objectForKey:@"used"] longLongValue]]];
                
                
                unsigned long long reduesize = [[[response data] objectForKey:@"all"] longLongValue];
                
                DLogInfo(@"===%@",[[response data] objectForKey:@"last_sync_time"]);
                
                datelabel.text = [[response data] objectForKey:@"last_sync_time"];
                reduelabel.text = [@"" stringByAppendingFormat:@"%@",[self changGMKB:reduesize]];
                
            }
            if ([response response] ==khttpfailCode)
            {
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                
            }
        }
        
        //设置推送
        if (request.tag == 2 || request.tag == 5) {
            
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
