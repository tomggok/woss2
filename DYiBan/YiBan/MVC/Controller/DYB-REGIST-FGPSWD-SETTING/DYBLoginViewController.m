 //
//  DYBLoginViewController.m
//  DYiBan
//
//  Created by NewM on 13-8-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBLoginViewController.h"
#import "DYBDynamicViewController.h"
#import "DYBRegisterStep1ViewController.h"
#import "DYBForgetPassWordViewController.h"
#import "DYBSettingViewController.h"
#import "user.h"
#import "DYBDataBankListController.h"
#import "Magic_Sandbox.h"
#import "userRegistModel.h"

#import "DYBUITabbarViewController.h"
#import "CALayer+Custom.h"

#import "NSObject+MagicRequestResponder.h"
#import "UserSettingMode.h"
#import "DYBLocalDataManager.h"
#import "NSObject+SBJSON.h"
#import "SBJsonWriter.h"

@interface DYBLoginViewController ()


@end

@implementation DYBLoginViewController
@synthesize imLog = _imLog;
@synthesize nameInput = _nameInput;
@synthesize passInput = _passInput;
@synthesize loginButton = _loginButton;

DEF_SIGNAL(LOGINBUTTON)//登陆
DEF_SIGNAL(REGISTBUTTON) //注册按钮
DEF_SIGNAL(FORGETBUTTON) //忘记密码
DEF_SIGNAL(ENTERDATABANK)

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.leftButton setHidden:YES];
        [self.rightButton setHidden:YES];
        self.headview.hidden = YES;
        [self.headview setTitle:@"登陆"];
        self.view.backgroundColor =ColorBackgroundGray;
        [self setButtonStatus];
        SHARED.isSessionTimeOut = NO;
        
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {

//        MagicRequest *request = [DYBHttpMethod security_newchannel:YES receive:self];
//        [request setTag:2];

        
        //新生通道
//        MagicRequest *request = [DYBHttpMethod security_newchannel:YES receive:self];
//        [request setTag:2];

        
//        self.HTTP_GET_DOWN(@"");
//        [self cancelRequestWithUrl:<#(NSString *)#>]
        SHARED.registUserSetting = [[userRegistModel alloc]init]; //注册用户数据
        
        //logo图标
        if (SCREEN_HEIGHT  > 480) {
            
            _imLog = [[MagicUIImageView alloc] initWithFrame:CGRectMake((320-115)/2, 100, 115, 50)];
        }else {
            _imLog = [[MagicUIImageView alloc] initWithFrame:CGRectMake((320-115)/2, 60, 115, 50)];
            
        }
        
        
        
        [_imLog setImage:[UIImage imageNamed:@"logo"]];
        _imLog.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_imLog];
        RELEASE(_imLog);
        
        //注册按钮
        UIImage *registImage = [UIImage imageNamed:@"btn_reg_def"];
        MagicUIButton *btnRegist = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-registImage.size.height/2-20, registImage.size.width/2, registImage.size.height/2)];
        [self setMagicUIButton:btnRegist setImageNorm:[UIImage imageNamed:@"btn_reg_def"] setImageHigh:[UIImage imageNamed:@"btn_reg_high"] signal:[DYBLoginViewController REGISTBUTTON] setControl:self];
        
        //忘记密码按钮
        MagicUIButton *btnForget = [[MagicUIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-registImage.size.width/2, btnRegist.frame.origin.y, registImage.size.width/2, registImage.size.height/2)];
        [self setMagicUIButton:btnForget setImageNorm:[UIImage imageNamed:@"btn_forgetpass_def"] setImageHigh:[UIImage imageNamed:@"btn_forgetpass_high"] signal:[DYBLoginViewController FORGETBUTTON] setControl:self];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 20+_imLog.frame.origin.y+_imLog.frame.size.height, INPUTWIDTH, INPUTHEIGHT*2-1)];
        [bgView.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[MagicCommentMethod color:229 green:229 blue:229 alpha:1.0] CGColor]];
        [self.view addSubview:bgView];
        RELEASE(bgView)
        
        //输入用户名
        _nameInput = [[DYBInputView alloc]initWithFrame:CGRectMake(0, 0, INPUTWIDTH, INPUTHEIGHT) placeText:@"用户名/手机/邮箱" textType:0];
        [_nameInput.nameField setText:@"1"];
        [bgView addSubview:_nameInput];
        RELEASE(_nameInput);
        
        //输入用户密码
        _passInput = [[DYBInputView alloc]initWithFrame:CGRectMake(0, [_nameInput getLowy]-1, INPUTWIDTH, INPUTHEIGHT) placeText:@"密码" textType:1];
        [_passInput.nameField setText:@"1"];
        [bgView addSubview:_passInput];
        RELEASE(_passInput);
        
        //登陆按钮
        _loginButton = [[MagicUIButton alloc] initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 15+bgView.frame.size.height+bgView.frame.origin.y, INPUTWIDTH, 44)];
        [_loginButton.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:0 borderColor:nil];
        
        
        if (_nameInput.nameField.text.length >0 &&_passInput.nameField.text.length) {
            
            [self setMagicUIButton:_loginButton setImageNorm:[UIImage imageNamed:@"btn_login_def"] setImageHigh:[UIImage imageNamed:@"btn_login_high"]  signal:[DYBLoginViewController LOGINBUTTON] setControl:self];
        }else {
            
            [self setMagicUIButton:_loginButton setImageNorm:[UIImage imageNamed:@"btn_login_dis"] setImageHigh:[UIImage imageNamed:@"btn_login_dis"]  signal:[DYBLoginViewController LOGINBUTTON] setControl:self];
        }
        
        [_loginButton retain];
        
//      MagicUIButton*  enter = [[MagicUIButton alloc] initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 15+[_passInput getLowy] +100, INPUTWIDTH, 44)];
//        [enter setBackgroundColor:[UIColor redColor]];
//       [self setMagicUIButton:enter setImageNorm:[UIImage imageNamed:@"btn_login_def"] setImageHigh:[UIImage imageNamed:@"btn_login_high"]  signal:[DYBLoginViewController ENTERDATABANK] setControl:self];
        
    }
}
- (void)downloadProgress:(CGFloat)newProgress request:(MagicRequest *)request
{

}
//监听textfeild字符变化 改变按钮状态
- (void)setButtonStatus{
    
    
    if (_nameInput.nameField.text.length > 0 && _passInput.nameField.text.length > 0) {
        
        
        [_loginButton setImage:[UIImage imageNamed:@"btn_login_def"] forState:UIControlStateNormal];
        [_loginButton setImage:[UIImage imageNamed:@"btn_login_high"] forState:UIControlStateHighlighted];
        [_loginButton addSignal:[DYBLoginViewController LOGINBUTTON] forControlEvents:UIControlEventTouchUpInside];
    }else {
        
        [_loginButton setImage:[UIImage imageNamed:@"btn_login_dis"] forState:UIControlStateNormal];
        [_loginButton setImage:[UIImage imageNamed:@"btn_login_dis"] forState:UIControlStateHighlighted];
        [_loginButton addSignal:[DYBLoginViewController LOGINBUTTON] forControlEvents:UIControlEventTouchUpInside];
    }
    
}

#pragma mark- UITextField
- (void)handleViewSignal_MagicUITextField:(MagicViewSignal *)signal
{
    if ([signal.source isKindOfClass:[MagicUITextField class]])//完成编辑
    {
        MagicUITextField *textField = [signal source];
    
        if ([signal is:[MagicUITextField TEXTFIELDDIDENDEDITING]])
        {
            [self animateTextField:[textField superview] up:NO getContrl:self];
        }else if ([signal is:[MagicUITextField TEXTFIELD]])
        {
            
            [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(setButtonStatus) userInfo:nil repeats:NO];

            
        }else if ([signal is:[MagicUITextField TEXTFIELDSHOULDRETURN]])
        {
            [textField resignFirstResponder];
            
        }
        else if ([signal is:[MagicUITextField TEXTFIELDSHOULDCLEAR]])
        {
            
            [_loginButton setImage:[UIImage imageNamed:@"btn_login_dis"] forState:UIControlStateNormal];
            [_loginButton setImage:[UIImage imageNamed:@"btn_login_dis"] forState:UIControlStateHighlighted];
            [_loginButton addSignal:[DYBLoginViewController LOGINBUTTON] forControlEvents:UIControlEventTouchUpInside];
            
        }else if ([signal is:[MagicUITextField TEXTFIELDDIDBEGINEDITING]]) //开始编辑
        {
            
            
            [self animateTextField:[textField superview] up:YES getContrl:self];
            
        }
        
    }
    
    
}


#pragma mark- 点击按钮
- (void)handleViewSignal_DYBLoginViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBLoginViewController LOGINBUTTON]])
    {
        [_nameInput.nameField resignFirstResponder];
        [_passInput.nameField resignFirstResponder];
        
        
        if (_nameInput.nameField.text.length > 0 && _passInput.nameField.text.length > 0) {

            
            MagicRequest *request = [DYBHttpMethod login:_nameInput.nameField.text password:_passInput.nameField.text isAlert:YES isRemberPsd:NO receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
                
            }
        }

    }
    //regist page
    if ([signal is:[DYBLoginViewController REGISTBUTTON]]) {
    
        SHARED.registUserSetting = [[userRegistModel alloc]init]; //注册用户数据
        DYBRegisterStep1ViewController *vc = [[DYBRegisterStep1ViewController alloc] init];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }
    //forget password page
    if ([signal is:[DYBLoginViewController FORGETBUTTON]]) {
        
        DYBForgetPassWordViewController *vc = [[DYBForgetPassWordViewController alloc] init];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBLoginViewController ENTERDATABANK]]){
    
    
//        DYBDataBankBarViewController *databank = [[DYBDataBankBarViewController alloc]init];
//        [self.drNavigationController pushViewController:databank animated:YES];
//        RELEASE(databank);
    
    }
}


#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {

//        //获取是否 是新生通道 1是 0 不是
//        if (request.tag == 2) {
//            JsonResponse *response = (JsonResponse *)receiveObj;
//            
//            SHARED.registUserSetting.registIsNew = [[response data] objectForKey:@"result"];
//        }
        
        //登陆
        if (request.tag == 1) {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                SHARED.curUser = [user JSONReflection:[[response data] objectForKey:@"user"]];
//                SHARED.currentUserSetting = [[UserSettingMode alloc] init];
//                SHARED.currentUserSetting = [[UserSettingMode alloc] init:[[DYBLocalDataManager sharedInstance] getUserSetting:SHARED.curUser.userid]];
//                NSArray *pushTag = [SHARED.curUser.push_tag componentsSeparatedByString:@","];
//                
//                BOOL isPushEvaluate = NO;
//                BOOL isPushAtMe = NO;
//                BOOL isPushPrivate = NO;
//                BOOL isPushAddMe = NO;
//                BOOL isPushTeacher = NO;
//                BOOL isJOBpUSH = NO;
//                BOOL isdatabase = NO;
//                BOOL isWifi = NO;
//                for (int i = 0; i < [pushTag count]; i++) {
//                    if ([[pushTag objectAtIndex:i] isEqualToString:@"5"]) {
//                        isPushEvaluate = YES;
//                    }else if ([[pushTag objectAtIndex:i] isEqualToString:@"6"]){
//                        isPushAtMe = YES;
//                    }else if ([[pushTag objectAtIndex:i] isEqualToString:@"8"]){
//                        isPushPrivate = YES;
//                    }else if ([[pushTag objectAtIndex:i] isEqualToString:@"10"]){
//                        isPushAddMe = YES;
//                    }else if ([[pushTag objectAtIndex:i] isEqualToString:@"11"]){
//                        isPushTeacher = YES;
//                    }else if ([[pushTag objectAtIndex:i] isEqualToString:@"12"]){
//                        isJOBpUSH = YES;
//                    }else if ([[pushTag objectAtIndex:i] isEqualToString:@"13"]){
//                        isdatabase = YES;
//                    }else if ([[pushTag objectAtIndex:i] isEqualToString:@"14"]){
//                        isWifi = YES;
//                    }
//                }
//                [SHARED.currentUserSetting setEvaluatePush:isPushEvaluate];
//                [SHARED.currentUserSetting setAtMePush:isPushAtMe];
//                [SHARED.currentUserSetting setPrivateMessagePush:isPushPrivate];
//                [SHARED.currentUserSetting setAddMePush:isPushAddMe];
//                [SHARED.currentUserSetting setTeacherPush:isPushTeacher];
//                [SHARED.currentUserSetting setJobPush:isJOBpUSH];
//                [SHARED.currentUserSetting setDataBasePush:isdatabase];
//                [SHARED.currentUserSetting setWifiForPush:isWifi];
//                
//                if (SHARED.curUser.disturb_time && SHARED.curUser.disturb_time.length > 0) {
//                    [SHARED.currentUserSetting setTimeForNoPush:YES];
//                }
//                
//                [[DYBLocalDataManager sharedInstance] saveUserSetting:[[SHARED.currentUserSetting dict] JSONFragment] key:@""];
//                [[DYBLocalDataManager sharedInstance] setCurrentUserSetting:SHARED.currentUserSetting];
                
                [[NSUserDefaults standardUserDefaults] setValue:_nameInput.nameField.text forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setValue:_passInput.nameField.text forKey:@"password"];
                
                DYBUITabbarViewController *vc = [[DYBUITabbarViewController sharedInstace] init:self];
                //加载左视图
                [[DYBUITabbarViewController sharedInstace] initLeftView];
                
                [self.drNavigationController pushViewController:vc animated:YES];
       

                _nameInput.nameField.text = @"";

                
                
            }
            if ([response response] ==khttpfailCode)
            {
                
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
            }
            
            
            
        }
    }
    
    
}

@end
