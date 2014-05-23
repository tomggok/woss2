//
//  DYBLoginWebViewController.m
//  DYiBan
//
//  Created by Song on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBLoginWebViewController.h"
#import "GTMBase64.h"

@interface DYBLoginWebViewController ()

@end

@implementation DYBLoginWebViewController
DEF_SIGNAL(LOGINWEBBUTTON); //登陆web
DEF_SIGNAL(CANCELBUTTON);//取消
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self setVCBackAnimation:SWIPELASTIMAGEBACKTYPE canBackPageNumber:0];
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"易码通"];
        [self backImgType:0];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        [self.view setBackgroundColor:[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f]];
        MagicUIImageView *imageview = [[MagicUIImageView alloc]initWithImage:[UIImage imageNamed:@"scanconf.png"]];
        [imageview setFrame:CGRectMake(60.0f, 120,121 , 151)];
        [imageview setCenter:CGPointMake(160.0f, 180.0f)];
        [imageview setUserInteractionEnabled:YES];
        [self.view addSubview:imageview];
        RELEASE(imageview)
        
        MagicUIButton *btn = [[MagicUIButton alloc]initWithFrame:CGRectMake(20.0f, 120.0f, 132.0f, 42.0f)];
        [self setMagicUIButton:btn setImageNorm:[UIImage imageNamed:@"btn_blank2_a"] setImageHigh:[UIImage imageNamed:@"btn_blank2_b"]  signal:[DYBLoginWebViewController LOGINWEBBUTTON] setControl:self];
        [btn setTag:101];
        [btn setCenter:CGPointMake(160.0f, 320.0f)];
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        [self.view addSubview:btn];
        RELEASE(btn);
        
        MagicUIButton *cancelbtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(20.0f, 170.0f, 132.0f, 42.0f)];
        [self setMagicUIButton:cancelbtn setImageNorm:[UIImage imageNamed:@"btn_blank2_d"] setImageHigh:[UIImage imageNamed:@"btn_blank2_d"]  signal:[DYBLoginWebViewController CANCELBUTTON] setControl:self];
        [cancelbtn setTag:101];
        [cancelbtn setCenter:CGPointMake(160.0f, 400.0f)];
        [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.view addSubview:cancelbtn];
        RELEASE(cancelbtn);
    }
}

#pragma mark-
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popToViewcontroller:[[self.drNavigationController allviewControllers] objectAtIndex:1] animated:YES];
        
    }
    
    
}


- (NSString *) utf2gbk:(NSString *)string

{
    NSStringEncoding gbkENC = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    string = [string stringByAddingPercentEscapesUsingEncoding:gbkENC];
    return  string;
}

#pragma mark- 点击按钮
- (void)handleViewSignal_DYBLoginWebViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBLoginWebViewController CANCELBUTTON]])
    {
//        for (int i = 0; i < [[self.drNavigationController allviewControllers] count]; i++)
//        {
//            MagicViewController *vc = [[self.drNavigationController allviewControllers] objectAtIndex:i];
//            
//            DLogInfo(@"vc == %@", vc);
//        }

//        [self.drNavigationController popToViewController:<#(UIViewController *)#> animated:<#(BOOL)#>:YES];
        
//        NSInteger count = [[self.drNavigationController allviewControllers] count] - 2;
        [self.drNavigationController popToViewcontroller:[[self.drNavigationController allviewControllers] objectAtIndex:1] animated:YES];
//        [self.drNavigationController popViewControllerAnimated:YES];
    }
    if ([signal is:[DYBLoginWebViewController LOGINWEBBUTTON]])
    {
        
        
        // 设置按钮不可按
        MagicUIButton *btn1 = (MagicUIButton *)[self.view viewWithTag:101];
        [btn1 setUserInteractionEnabled:NO];
        MagicUIButton *btn2 = (MagicUIButton *)[self.view viewWithTag:102];
        [btn2 setUserInteractionEnabled:NO];
        NSString *name = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
        NSString *temp1 = [self utf2gbk:name];
        NSString *psw = [[NSUserDefaults standardUserDefaults]valueForKey:@"password"];
        
        if (name == nil || psw == nil) {
            return;
        }
//        [Static addAlertView:self.view message:@"正在加载！"];
        NSString *temp = [[[@"_u=" stringByAppendingString:temp1] stringByAppendingString:@"&_s="] stringByAppendingString:psw];
        NSData *data = [temp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString* encoded = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DLogInfo(@"encoded:%@", encoded);
        NSString *url = [self.yibanURL stringByAppendingString:encoded];
        DLogInfo(@"url is ---->%@",url);
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [request setTimeOutSeconds:60];
        [request setDelegate:self];
        [request setTag:1];
        [request setDidFailSelector:@selector(fail:)];
        [request setDidFinishSelector:@selector(finish:)];
        [request startAsynchronous];
        

    }
}

-(void)fail:(ASIHTTPRequest*)sender{
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
    [btn1 setUserInteractionEnabled:YES];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:102];
    [btn2 setUserInteractionEnabled:YES];
//    [self performSelector:@selector(removeAlert) withObject:nil afterDelay:2];
//    NSString* str = [sender responseString];
//    [Static alertView:self.view msg:str];
    //  NSDictionary *dic = [str JSONValue];
    
}

-(void)finish:(ASIHTTPRequest*)sender{
    [DYBShareinstaceDelegate loadFinishAlertView:@"登陆成功" target:self];
    [self.drNavigationController popToViewcontroller:[[self.drNavigationController allviewControllers] objectAtIndex:1] animated:YES];
    return;
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
    [btn1 setUserInteractionEnabled:YES];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:102];
    [btn2 setUserInteractionEnabled:YES];
//    [self performSelector:@selector(removeAlert) withObject:nil afterDelay:2];
    NSString* str = [sender responseString];
    if ([str isEqualToString:@"ok"]) {
//        [Static addAlertView:self.view message:@"web登陆成功"];
        
        [self.drNavigationController popToRootViewControllerAnimated:YES];
    }else{
//        [Static addAlertView:self.view message:str];
    }
    //  NSDictionary *dic = [str JSONValue];
    
}


@end
