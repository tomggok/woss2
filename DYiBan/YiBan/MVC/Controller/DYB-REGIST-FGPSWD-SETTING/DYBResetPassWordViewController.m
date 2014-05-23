//
//  DYBResetPassWordViewController.m
//  DYiBan
//
//  Created by Song on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBResetPassWordViewController.h"
#import "DYBLoginViewController.h"
#import "CALayer+Custom.h"
@interface DYBResetPassWordViewController ()

@end

@implementation DYBResetPassWordViewController
@synthesize passwordInput = _passwordInput,passwordInput2 = _passwordInput2,codeString = _codeString,loginName = _loginName,userId = _userId;
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.headview setTitle:@"重置密码"];
        [self sizeStatus];
        self.view.backgroundColor =ColorBackgroundGray;
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 20+self.headHeight, INPUTWIDTH, INPUTHEIGHT*2-1)];
        [bgView.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[MagicCommentMethod color:229 green:229 blue:229 alpha:1.0] CGColor]];
        [self.view addSubview:bgView];
        RELEASE(bgView)
        
        //输入密码
        _passwordInput = [[DYBInputView alloc]initWithFrame:CGRectMake(0, 0, INPUTWIDTH, INPUTHEIGHT) placeText:@"输入新密码:6-16位字符" textType:1];
        [bgView addSubview:_passwordInput];
        RELEASE(_passwordInput);
        
        //再次输入密码
        _passwordInput2 = [[DYBInputView alloc]initWithFrame:CGRectMake(0, [_passwordInput getLowy]-1, INPUTWIDTH, INPUTHEIGHT) placeText:@"再次输入" textType:1];
        [bgView addSubview:_passwordInput2];
        RELEASE(_passwordInput2);
        
        MagicUILabel *textLabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y+bgView.frame.size.height+12, INPUTWIDTH, 20)];
        textLabel.text = @"验证通过，本次重置密码的帐号是：";
        [self setLabel:textLabel sizeFont:18 setColor:[MagicCommentMethod colorWithHex:@"aaaaaa"]];
        
        //帐号名称
        MagicUILabel *userLabel = [[MagicUILabel alloc]initWithFrame:CGRectMake([_passwordInput2 getOrginx], textLabel.frame.origin.y+textLabel.frame.size.height+12, INPUTWIDTH, 20)];
        userLabel.text = _loginName;
        [self setLabel:userLabel sizeFont:15 setColor:[MagicCommentMethod colorWithHex:@"333333"]];
           
    }
}

//设置label属性
- (void)setLabel:(MagicUILabel*)label sizeFont:(int)size setColor:(UIColor *)color{
    
    label.font = [DYBShareinstaceDelegate DYBFoutStyle:size];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    RELEASE(label);
}


//字符位数
- (BOOL)sizeStatus {
    
    [self setButtonImage:self.leftButton setImage:@"btn_back_def" setHighString:@"btn_back_hlt"];
    [self setButtonImage:self.rightButton setImage:@"btn_ok_dis"];
    
    if (_passwordInput.nameField.text.length < 6 || _passwordInput.nameField.text.length > 16) {
        
        return NO;
    }
    
    if (_passwordInput2.nameField.text.length < 6 || _passwordInput2.nameField.text.length > 16) {
        
        return NO;
    }
    
    if (![_passwordInput.nameField.text isEqualToString:_passwordInput2.nameField.text]) {
        
        return NO;
    }
    
    
    [self setButtonImage:self.rightButton setImage:@"btn_ok_def" setHighString:@"btn_ok_high"];
    return YES;
}



#pragma mark- UITextField
- (void)handleViewSignal_MagicUITextField:(MagicViewSignal *)signal
{
    if ([signal.source isKindOfClass:[MagicUITextField class]])
    {
        MagicUITextField *textField = [signal source];
        
        if ([signal is:[MagicUITextField TEXTFIELDDIDENDEDITING]])
        {
            
        }else if ([signal is:[MagicUITextField TEXTFIELD]])
        {
            [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(sizeStatus) userInfo:nil repeats:NO];
            
        }else if ([signal is:[MagicUITextField TEXTFIELDSHOULDRETURN]])
        {
            [textField resignFirstResponder];
            
        } else if ([signal is:[MagicUITextField TEXTFIELDSHOULDCLEAR]])
        {
            [self setButtonImage:self.rightButton setImage:@"btn_ok_dis"];
        }
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
        if ([self sizeStatus]) {
            
            MagicRequest *request = [DYBHttpMethod security_resetpwd:_userId authcode:_codeString password:_passwordInput2.nameField.text isAlert:YES receive:self];
            [request setTag:1];
            
        }
        
        
        
    }
    
}

#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        //获取验证码
        if (request.tag == 1) {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                //重置成功
                if ([[response.data objectForKey:@"password"] isEqualToString:@"1"]) {
                    self.view.userInteractionEnabled = NO;
                    [DYBShareinstaceDelegate loadFinishAlertView:@"密码修改成功，请重新登录！" target:self];
                    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(loginAgain) userInfo:nil repeats:NO];
                    
                }
                
            }
            else if ([response response] ==khttpfailCode){
                
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                DLogInfo(@"========%@",response.message);
            }
        }
        
        
        
    }
    
}

- (void)loginAgain {
    
    DYBLoginViewController *vc = [[DYBLoginViewController alloc] init];
    [self.drNavigationController pushViewController:vc animated:YES];
    RELEASE(vc);
}


@end
