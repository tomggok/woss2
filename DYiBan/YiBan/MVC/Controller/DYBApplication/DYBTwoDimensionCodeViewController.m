//
//  DYBTwoDimensionCodeViewController.m
//  DYiBan
//
//  Created by Song on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBTwoDimensionCodeViewController.h"
#import "RegexKitLite.h"
#import <AVFoundation/AVFoundation.h>
#import "DYBLoginWebViewController.h"
#import "DYBWebController.h"
#import "active.h"
#import "DYBActivityViewController.h"
#import "Magic_Device.h"

@interface DYBTwoDimensionCodeViewController (){
    
    UIButton *btnTap;
    AVCaptureSession 	*AVSession ;
    ZBarReaderViewController *readerZbar;
    UIImageView* laser;
    NSThread *thread;
    BOOL stopAnimation;
    BOOL isPush ;
    
    MagicUILabel *labeText;
    MagicUIButton *selectbtn[2];
    int selectIndex;
}

@end

@implementation DYBTwoDimensionCodeViewController
DEF_SIGNAL(ACTIVITYBUTTON)//登陆
DEF_SIGNAL(WEBBUTTON) //注册按钮

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        
        
        [self.rightButton setHidden:YES];
        
        [self.headview setTitle:@"易码通"];
        [self backImgType:0];
        [self addWillAppear];
        [self.view bringSubviewToFront:self.headview];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        selectIndex = 0;
        
        stopAnimation = NO;
        
        
    }
    else if ([signal is:[MagicViewController WILL_DISAPPEAR]])
    {
        isPush = YES;
        [readerZbar.readerView stop];
        stopAnimation = YES;
        
        Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
        if (captureDeviceClass != nil) {
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            if ([device hasTorch] && [device hasFlash]){
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                [device unlockForConfiguration];
            }
        }

    }
}

- (void)addWillAppear {
    
    if (readerZbar) {
        [readerZbar.readerView.captureReader removeObserver: readerZbar.readerView
                                                 forKeyPath: @"framesPerSecond"];
        readerZbar.readerDelegate = nil;
        [readerZbar release];
        readerZbar = nil;
    }
    
    stopAnimation = NO;
    isPush = NO;
    readerZbar = [ZBarReaderViewController new];
    readerZbar.supportedOrientationsMask = ZBarOrientationMaskAll;
    [readerZbar setVideoQuality:UIImagePickerControllerQualityTypeHigh];
    [readerZbar.readerView setShowsFPS:YES];
    [readerZbar setTracksSymbols:YES];
    [readerZbar.tabBarController setHidesBottomBarWhenPushed:YES];
    readerZbar.readerDelegate = self;
    ZBarImageScanner *scanner = readerZbar.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    readerZbar.showsZBarControls = NO;
    readerZbar.enableCache = YES;
    for (UIView *temp in [readerZbar.view subviews]) {
        
        for (UIButton *button in [temp subviews]) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button removeFromSuperview];
            }
        }
        //去除toolbar
        for (UIToolbar *toolbar in [temp subviews]) {
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                [toolbar setHidden:YES];
            }
        }
    }
    readerZbar.showsZBarControls = NO;
    [readerZbar.readerView start];
    [readerZbar.readerView setFrame:CGRectMake(0.0f, self.headHeight, 320.0f, self.view.frame.size.height)];
    [self.view addSubview:readerZbar.readerView];
    
//    [self.view setFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height)];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    UIImageView *iamge = [[UIImageView alloc]init];
    if (self.view.frame.size.height > 480) {
        
        [iamge setImage:[UIImage imageNamed:@"qrcode_bg5.png"]];
    }else{
        [iamge setImage:[UIImage imageNamed:@"qrcode_bg.png"]];
    }
    iamge.contentMode = UIViewContentModeScaleAspectFit;
    [iamge setFrame:CGRectMake(0.0f, 0, 320.0f, self.view.frame.size.height)];
    [self.view addSubview:iamge];
    [iamge release];
    
    if (laser) {
        RELEASEVIEW(laser);
    }
    
    laser = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"laser.png"]];
    if (self.view.frame.size.height == 480) {
        [laser setFrame:CGRectMake(41.0f, 75.0f, 235.0f, 13.0f)];
    }else{
        [laser setFrame:CGRectMake(41.0f, 124.0f, 235.0f, 13.0f)];
    }
    
    [self.view addSubview:laser];
    [self repeatAnuimation];
    
    //现实是二维码扫描 还是网页扫描
    if (labeText) {
        RELEASEVIEW(labeText);
    }
    labeText = [[MagicUILabel alloc]initWithFrame:CGRectMake(30, self.view.frame.size.height-88-20-44, self.view.frame.size.width-60, 54)];
    labeText.backgroundColor = [UIColor clearColor];
    labeText.textAlignment = UITextAlignmentCenter;
    labeText.numberOfLines = 2;
    labeText.font = [DYBShareinstaceDelegate DYBFoutStyle:15];
    labeText.textColor = [MagicCommentMethod colorWithHex:@"aaaaaa"];
    [labeText setText:@"活动二维码"];
    [self.view addSubview:labeText];
    
    
    if (selectbtn[0]) {
        
        for (int i = 0; i < 2; i++) {
            REMOVEFROMSUPERVIEW(selectbtn[i]);
        }
    }
    
    UIImage *imageSize = [UIImage imageNamed:@"tab_huodong_sel"];
    for (int i = 0; i < 2; i++) {
        selectbtn[i] = [[MagicUIButton alloc]initWithFrame:CGRectMake(imageSize.size.width/2*i, self.view.frame.size.height-imageSize.size.height/2, imageSize.size.width/2, imageSize.size.height/2)];
        if (i == 0) {
            [self setButtonImage:selectbtn[i] setImage:@"tab_huodong" setHighString:@"tab_huodong_sel"];
            [selectbtn[i] addSignal:[DYBTwoDimensionCodeViewController ACTIVITYBUTTON] forControlEvents:UIControlEventTouchUpInside];
        }else {
            [self setButtonImage:selectbtn[i] setImage:@"tab_weblogin" setHighString:@"tab_weblogin_sel"];
            [selectbtn[i] addSignal:[DYBTwoDimensionCodeViewController WEBBUTTON] forControlEvents:UIControlEventTouchUpInside];
        }
        [selectbtn[i] setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:selectbtn[i]];
        RELEASE(selectbtn[i]);
    }
    
    
    
    [self sendViewSignal:[DYBTwoDimensionCodeViewController ACTIVITYBUTTON]];
}


#pragma mark- 点击按钮
- (void)handleViewSignal_DYBTwoDimensionCodeViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBTwoDimensionCodeViewController ACTIVITYBUTTON]])
    {
        selectIndex = 0;
        [labeText setText:@"活动二维码"];
        [self setButtonImage:selectbtn[0] setImage:@"tab_huodong_sel" setHighString:@"tab_huodong_sel"];
        [self setButtonImage:selectbtn[1] setImage:@"tab_weblogin" setHighString:@"tab_weblogin_sel"];
    }
    
    if ([signal is:[DYBTwoDimensionCodeViewController WEBBUTTON]])
    {
        selectIndex = 1;
        [labeText setText:@"在电脑浏览器上打开qrcode.yiban.cn扫瞄二维码直接登陆易班网站"];
        [self setButtonImage:selectbtn[0] setImage:@"tab_huodong" setHighString:@"tab_huodong_sel"];
        [self setButtonImage:selectbtn[1] setImage:@"tab_weblogin_sel" setHighString:@"tab_weblogin_sel"];
    }
}



-(void)repeatAnuimation{
    
    
    if (self.view.frame.size.height == 460) {
        
        [laser setFrame:CGRectMake(41.0f, self.view.frame.size.height-405+10+5, 235.0f, 13.0f)];
        
    }else{
        if ([MagicDevice sysVersion] - 6.14 > 0) {
            
            [laser setFrame:CGRectMake(41.0f, self.view.frame.size.height-305+20-150+9, 235.0f, 13.0f)];
            
        }else {
            
            [laser setFrame:CGRectMake(41.0f, self.view.frame.size.height-305+20-150+5, 235.0f, 13.0f)];
            
        }
        
    }
    [UIView beginAnimations:@"show" context:nil];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:100000.04];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:2.5];
    if (self.view.frame.size.height == 460) {
        
        [laser setFrame:CGRectMake(41.0f, self.view.frame.size.height-169+10, 235.0f, 13.0f)];
        
    }else{
        if ([MagicDevice sysVersion] - 6.14 > 0) {
            
            [laser setFrame:CGRectMake(41.0f, self.view.frame.size.height-169+10-50+20-23+12, 235.0f, 13.0f)];
            
        }else {
            
            [laser setFrame:CGRectMake(41.0f, self.view.frame.size.height-169+10-50+20-13, 235.0f, 13.0f)];
            
        }
    }
    [UIView setAnimationsEnabled:YES];
    [UIView commitAnimations];
    
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if([finished boolValue] == YES)//一定要判断这句话，要不在程序中当多个View刷新的时候，就可能出现动画异常的现象
    {
        //执行想要的动作
        
        
    }else{
        
    }
    if (!stopAnimation) {
        [self repeatAnuimation];
    }
    
    
}

- (void) imagePickerController: (UIImagePickerController*) reader

 didFinishPickingMediaWithInfo: (NSDictionary*) info

{
    id<NSFastEnumeration> results =[info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    self.strData = symbol.data;
    
    if ([self.strData isMatchedByRegex:@"[a-zA-z]+://[^s]*"] &&selectIndex == 1) {
        NSRange range = [self.strData rangeOfString:@"http://qrcode.yiban.cn"];
        
        if (range.length == 22 && range.location == 0) {
            //         [readerZbar.readerView stop];
            [self performSelector:@selector(pushView) withObject:nil afterDelay:0.5];
        }else{
            
            if (self != nil) {
                
                UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"是否打开下面链接%@",symbol.data] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alerView.tag = 102;
                [alerView show];
                [alerView release];
            }
            
        }
        
    }else if ([self isPureInt:self.strData]>0 &&selectIndex == 0) {
        
        MagicRequest *request = [DYBHttpMethod active_detail:self.strData isAlert:NO receive:self];
        [request setTag:1];
        
        if (!request) {//无网路
            [DYBShareinstaceDelegate loadFinishAlertView:@"检查网络是否连接！" target:self];
        }
        
        
    }else {
        
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"扫描到非链接二维码"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alerView.tag = 103;
        [alerView show];
        [alerView release];
    }
    
}

//判断是不是为整数型
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

-(void)pushView{
    if (!isPush) {
        
        DYBLoginWebViewController *web= [[DYBLoginWebViewController alloc]init];
        web.yibanURL  = self.strData;
        //            [self.view addSubview:web.view];
        [self.drNavigationController pushViewController:web animated:YES];
        [web release];
    }
    isPush = YES;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 102) {
        
        if (buttonIndex == 0) {
            
            
            
        }else{
            
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.strData]];
//            DYBWebController* web = [[DYBWebController alloc]init];
//            web.url = self.strData;
//            [self.drNavigationController pushViewController:web animated:YES];
//            [web release];
        }
    }
}

-(void)tapOrNot{
    
    if (btnTap.tag == 2 ) {
        [btnTap setSelected:NO];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"tapOrNot"];
    }else{
        [btnTap setSelected:YES];
        btnTap.tag = 3;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"tapOrNot"];
    }
}

#pragma makr -
#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        if (readerZbar) {
            [readerZbar.readerView.captureReader removeObserver: readerZbar.readerView
                                                     forKeyPath: @"framesPerSecond"];
            readerZbar.readerDelegate = nil;
            [readerZbar release];
            readerZbar = nil;
        }
        
        [self.drNavigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        
        if (request.tag == 1) {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                active *ac = [active JSONReflection:[[response data] objectForKey:@"active"]];
                
                if ([ac.enabled isEqualToString:@"1"]) {
                    MagicRequest *request = [DYBHttpMethod active_action:ac.id action:@"1" op:@"1" isAlert:NO receive:self];
                    [request setTag:2];
                }
                
                DYBActivityViewController *vc = [[DYBActivityViewController alloc] init:ac];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
                
            }
            if ([response response] ==khttpfailCode)
            {
                
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
            }
            if ([response response] ==khttpWrongfulCode) {
                
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
            }
            
            
            
        }
        if (request.tag == 2) {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                
            }
            if ([response response] ==khttpfailCode)
            {
                
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
            }
            
            
        }
    }
    
    
}



@end
