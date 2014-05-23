//
//  DYBSettingSendMessViewController.m
//  DYiBan
//
//  Created by Song on 13-8-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSettingSendMessViewController.h"

@interface DYBSettingSendMessViewController () {
    
    MagicUITextView *textView;
}


@end

@implementation DYBSettingSendMessViewController

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.leftButton setHidden:NO];
        [self.rightButton setHidden:NO];
        [self.headview setTitle:@"意见反馈"];
        [self sizeStatus];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        
        
        textView = [[MagicUITextView alloc] initWithFrame:CGRectMake(0, self.headHeight, SCREEN_WIDTH, 150)];
        [textView setBackgroundColor:[UIColor clearColor]];
        [textView becomeFirstResponder];
        textView.font = [DYBShareinstaceDelegate DYBFoutStyle:16];
        [textView setMaxLength:500];
        [self.view addSubview:textView];
        RELEASE(textView);
    }
}

#pragma mark- 
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [textView resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        if (textView.text.length < 1) {
            
            DLogInfo(@"不能为空");
        }else {
            
            MagicRequest *request = [DYBHttpMethod sendInfomation:textView.text isAlert:YES receive:self];
            [request setTag:1];
        }
        
        
    }
    
    
}


//字符位数
- (BOOL)sizeStatus {
    [self backImgType:0];
    [self setButtonImage:self.rightButton setImage:@"btn_ok_dis"];
    if (textView.text.length < 1) {
        
        return NO;
    }
    
    [self setButtonImage:self.rightButton setImage:@"btn_ok_def" setHighString:@"btn_ok_high"];
    return YES;
}

#pragma mark- 
- (void)handleViewSignal_MagicUITextView:(MagicViewSignal *)signal
{
    //正在输入
    if ([signal is:[MagicUITextView TEXT_OVERFLOW]])
    {
        [signal returnNO];
    }
    
    if ([signal is:[MagicUITextView TEXTVIEW]])
    {
        [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(sizeStatus) userInfo:nil repeats:NO];
    }
    
    
    
}


- (void)backToSetting {
    
    [textView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    
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
                [DYBShareinstaceDelegate loadFinishAlertView:@"提交成功，我们会尽快回复你" target:self];
                DLogInfo(@"提交成功，我们会尽快回复你");
                
                [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(backToSetting) userInfo:nil repeats:NO];
                
                
            }else if ([response response] ==khttpNeedUpdateCode)
            {
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
            }

            
        }
        
    }
    
}
@end
