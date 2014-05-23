//
//  DYBSynchroViewController.m
//  DYiBan
//
//  Created by Song on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSynchroViewController.h"
#import "DYBSetButton.h"
#import "SyncType.h"
#import "user.h"
#import "DYBSNS_Controller_webViewController.h"
@interface DYBSynchroViewController () {
    
    BOOL isSyncTenct;//是否同步腾讯
    BOOL isSyncRenren;//是否同步人人
    user *_userModel;//当前用户的model
    
    BOOL canSyncTenct;
    BOOL canSyncRenren;
    
    NSInteger canShowNum;//可以显示的行数
    
    int tagNow;
    DYBSetButton *settingButton[2];
}

@end

@implementation DYBSynchroViewController
DEF_SIGNAL(SYNCHROBUTTON)
@synthesize btnSelectR,btnSelectT,btnSelect;

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"同步设置"];
        [self backImgType:0];
        [self checkSyncType];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        
        canSyncTenct = NO;
        canSyncRenren = NO;
        
        _userModel = SHARED.curUser;
        [self checkSyncType];
        
        NSArray *textArray = [[NSArray alloc]initWithObjects:@"同步到腾讯微博",@"同步到人人网", nil];
        for (int i = 0; i < [textArray count]; i++) {
            
            settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:1];
            
            [settingButton[i] addSignal:[DYBSynchroViewController SYNCHROBUTTON] forControlEvents:UIControlEventTouchUpInside];
            settingButton[i].tag = i;
            [self.view addSubview:settingButton[i]];
            RELEASE(settingButton[i]);
        }
        
        //选择按钮图片质量
        
        UIImage *image = [UIImage imageNamed:@"btn_check_no"];
        UIImage *imageyes = [UIImage imageNamed:@"btn_check_yes"];
        btnSelectT = [[MagicUIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-image.size.width/2-40,(BUTTONHEIGHT-image.size.height/2)/2, image.size.width/2, image.size.height/2)];
        [btnSelectT setImage:image];
//        btnSelectT.hidden = YES;
        [settingButton[0] addSubview:btnSelectT];
        RELEASE(btnSelectT);
        
        btnSelectR = [[MagicUIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-image.size.width/2-40,(BUTTONHEIGHT-image.size.height/2)/2, image.size.width/2, image.size.height/2)];
        [btnSelectR setImage:image];
//         btnSelectR.hidden = YES;
        [settingButton[1] addSubview:btnSelectR];
        RELEASE(btnSelectR);
        
        
        if (isSyncTenct) {
            
            [btnSelectT setImage:imageyes];
            settingButton[0].arrowImv.hidden = YES;
        }
        
        if (isSyncRenren) {
            
            [btnSelectR setImage:imageyes];
            settingButton[1].arrowImv.hidden = YES;
        }
        
    }
}

- (void)checkSyncType{
    
    [self doSyncTag];//处理是否授权
    
    
}

- (void)doSyncTag{
    NSInteger sysTagCount = [[_userModel sync_tag] intValue];
    
    SyncType *sync = [[SyncType alloc] init:sysTagCount];
    isSyncTenct = sync.isSyncTenct;
    isSyncRenren = sync.isSyncRenren;
    
    NSInteger canSyncTagCount = [[_userModel yiban_sync] intValue];
    //    canSyncTagCount = 6;
    SyncType *canSync = [[SyncType alloc] init:canSyncTagCount];
    canSyncRenren = canSync.isSyncRenren;
    canSyncTenct = canSync.isSyncTenct;
    
    canShowNum = canSync.canShowNum;
    
    //Add by Hyde 20130220 #memoryleaks
    [sync release];
    [canSync release];
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


#pragma mark- 按钮点击
- (void)handleViewSignal_DYBSynchroViewController:(MagicViewSignal *)signal
{
    MagicUIButton *btn = signal.source;
    btnSelect = (DYBSetButton *)btn;
    NSString *dic = nil;
    if ([signal is:[DYBSynchroViewController SYNCHROBUTTON]])
    {
        
        if ((isSyncRenren && btn.tag == 1) || (isSyncTenct && btn.tag == 0)) {
            
            if (btn.tag == 0) {
                dic = [NSString stringWithFormat:@"%d",2];
                tagNow = 0;
                
            }else if (btn.tag == 1){
                dic = [NSString stringWithFormat:@"%d",4];
                tagNow = 1;
            }
            MagicRequest *request = [DYBHttpMethod user_delsync_m:dic isAlert:YES receive:self];
            [request setTag:1];
        }
        else {
            
            DYBSNS_Controller_webViewController *sns = [[DYBSNS_Controller_webViewController alloc] init];
            if (btn.tag == 0) {
                [sns setTag:1];
            }else if (btn.tag == 1){
                [sns setTag:2];
            }
            [sns setFather:self];
            [self presentModalViewController:sns animated:YES];
            [sns release];
        }
       
        
    }
}

- (void)setSynchYes:(int)tag{
    UIImage *imageyes = [UIImage imageNamed:@"btn_check_yes"];
    //腾讯绑定成功
    if (tag == 1) {
        
        [btnSelectT setImage:imageyes];
        settingButton[0].arrowImv.hidden = YES;
        
    }
    //人人绑定成功
    if (tag == 2) {
        
        [btnSelectR setImage:imageyes];
        settingButton[1].arrowImv.hidden = YES;
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
            UIImage *image = [UIImage imageNamed:@"btn_check_no"];
            
            if (tagNow == 0) {
                
                [btnSelectT setImage:image];
                //更新本地user 对象中的数据
                int count = [SHARED.curUser.sync_tag intValue]-2;
                SHARED.curUser.sync_tag =[NSString stringWithFormat:@"%d",count];
                
            }else if(tagNow == 1){
                
                [btnSelectR setImage:image];
                int count = [SHARED.curUser.sync_tag intValue]-4;
                SHARED.curUser.sync_tag =[NSString stringWithFormat:@"%d",count];
                
            }
            
            [self checkSyncType];
            
            
            btnSelect.arrowImv.hidden = NO;
            DLogInfo(@"解除绑定成功");
    
        }else if ([response response] ==khttpfailCode)
        {
            DLogInfo(@"解除绑定失败");
            
        }
        
    }
    
}


@end
