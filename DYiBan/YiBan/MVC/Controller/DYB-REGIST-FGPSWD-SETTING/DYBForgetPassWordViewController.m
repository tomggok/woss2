//
//  DYBForgetPassWordViewController.m
//  DYiBan
//
//  Created by Song on 13-8-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBForgetPassWordViewController.h"
#import "DYBResetPassWordViewController.h"
#import "security_verifyauthcode.h"
#import "CALayer+Custom.h"
#import "user.h"
#import "DYBPersonalProfileViewController.h"
@interface DYBForgetPassWordViewController ()

@property(nonatomic,retain)NSString *stringCode;
@end

@implementation DYBForgetPassWordViewController
@synthesize phoneInput = _phoneInput,codeInput = _codeInput,codeButton = _codeButton,type = _type,loginPassInput= _loginPassInput,father = _father;
DEF_SIGNAL(GETCODEBUTTON)//验证码

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        if (_type == 1) {
            [self.headview setTitle:@"重置手机"];
            
        }else {
            
            [self.headview setTitle:@"重置密码"];
        }
        
        
        [self sizeStatus];
        self.view.backgroundColor =ColorBackgroundGray;
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        
        //输入手机号
        _phoneInput = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 20+self.headHeight, INPUTWIDTH, INPUTHEIGHT) placeText:@"输入手机号" textType:0];
        [_phoneInput.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[MagicCommentMethod color:229 green:229 blue:229 alpha:1.0] CGColor]];
        [self.view addSubview:_phoneInput];
        RELEASE(_phoneInput);
        
        //验证码按钮
        _codeButton = [[MagicUIButton alloc]initWithFrame:CGRectMake([_phoneInput getOrginx], [_phoneInput getLowy]+10, 110, 41)];
        [_codeButton.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:0 borderColor:nil];
        [_codeButton addSignal:[DYBForgetPassWordViewController GETCODEBUTTON] forControlEvents:UIControlEventTouchUpInside];
        _codeButton.tag = 0;
        _codeButton.titleLabel.font = [DYBShareinstaceDelegate DYBFoutStyle:18];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeButton.backgroundColor = [MagicCommentMethod color:229 green:229 blue:229 alpha:1.0];
        [self.view addSubview:_codeButton];
        RELEASE(_codeButton);
        
        MagicUILabel *textLabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(_codeButton.frame.size.width+_codeButton.frame.origin.x+15, [_phoneInput getLowy]+10, INPUTWIDTH-(_codeButton.frame.size.width+15), 41)];
        textLabel.numberOfLines = 2;
        textLabel.font = [DYBShareinstaceDelegate DYBFoutStyle:15];
        textLabel.textColor = [MagicCommentMethod colorWithHex:@"aaaaaa"];
        if (_type == 1) {
            textLabel.text = @"通过手机短信重置手机号码每天上限3次。";
        }else {
            textLabel.text = @"通过手机短信重置密码每天上限3次。";
        }
        
        textLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:textLabel];
        RELEASE(textLabel);
        
        _codeInput = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, _codeButton.frame.size.height+_codeButton.frame.origin.y+10, INPUTWIDTH, INPUTHEIGHT) placeText:@"输入验证码" textType:0];
        [_codeInput.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[MagicCommentMethod color:229 green:229 blue:229 alpha:1.0] CGColor]];
        [self.view addSubview:_codeInput];
        RELEASE(_codeInput);
        
        //个人资料里面的输入
        if (_type == 1) {
            
            _loginPassInput = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, [_codeInput getLowy]+10, INPUTWIDTH, INPUTHEIGHT) placeText:@"输入易班登陆密码" textType:1];
            [self.view addSubview:_loginPassInput];
            RELEASE(_loginPassInput);
        }
         
    }
}

#pragma mark- RegExp
- (BOOL)phoneNumRegExp:(NSString *)phoneNum
{
    NSString *numRegex = @"(13[0-9]|14[0-9]|15[0-9]|18[0-9])[0-9]{8}";
    NSPredicate *pred = [self predicateRegExp:numRegex];
    BOOL isMatch = [pred evaluateWithObject:phoneNum];
    return isMatch;
}

- (NSPredicate *)predicateRegExp:(NSString *)regexp
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp];
    return pred;
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
            
            if (_type == 1) {
                
                
                MagicRequest *request = [DYBHttpMethod security_resetphone:_codeInput.nameField.text phone:_phoneInput.nameField.text password:_loginPassInput.nameField.text isAlert:YES receive:self];
                [request setTag:2];
                
            }else {
                
                MagicRequest *request = [DYBHttpMethod security_verifyauthcode:_phoneInput.nameField.text acuthcode:_codeInput.nameField.text isAlert:YES receive:self];
                [request setTag:2];
            }
            
            
            

        }
    }
}



#pragma mark- 点击按钮
- (void)handleViewSignal_DYBForgetPassWordViewController:(MagicViewSignal *)signal
{
    MagicUIButton *btn = signal.source;
    
    if ([signal is:[DYBForgetPassWordViewController GETCODEBUTTON]]) {
        
        if (btn.tag == 1) {
            
            if (_type == 1) {
                //1是修改手机
                MagicRequest *request = [DYBHttpMethod security_authcode:_phoneInput.nameField.text type:@"1" isAlert:YES receive:self];
                [request setTag:1];
            }else {
                MagicRequest *request = [DYBHttpMethod security_authcode:_phoneInput.nameField.text type:@"0" isAlert:YES receive:self];
                [request setTag:1];
            }
            
            
            
        }
        
    }
    
}

//字符位数
- (BOOL)sizeStatus {
    
    [self setButtonImage:self.leftButton setImage:@"btn_back_def" setHighString:@"btn_back_hlt"];
    [self setButtonImage:self.rightButton setImage:@"btn_next_dis"];
    
    if ([self phoneNumRegExp:_phoneInput.nameField.text] == YES) {
        
        _codeButton.backgroundColor = ColorBlue;
        _codeButton.tag = 1;
        
    }else {
        
        _codeButton.backgroundColor = [MagicCommentMethod color:229 green:229 blue:229 alpha:1.0];
        _codeButton.tag = 0;
        
        return NO;
    }
    
    if (_codeInput.nameField.text.length < 1) {
        
        return NO;
    }
    
    if (_type == 1) {
        
        if (_loginPassInput.nameField.text.length < 1) {
            
            return NO;
        }
        
    }
    
    
    [self setButtonImage:self.rightButton setImage:@"btn_next_def" setHighString:@"btn_next_hlt"];
    
    return YES;
    
}



//判断格式是否正确
- (void)phoneRegExp:(NSTimer *)timer {
    
    MagicUIButton *statusButton = (MagicUIButton *)timer.userInfo;
    
    if ([self phoneNumRegExp:_phoneInput.nameField.text] == YES) {
        
        statusButton.backgroundColor = ColorBlue;
        statusButton.tag = 1;
        
    }else {
        
        statusButton.backgroundColor = [MagicCommentMethod color:229 green:229 blue:229 alpha:1.0];
        statusButton.tag = 0;
    }
    
}


#pragma mark- UITextField
- (void)handleViewSignal_MagicUITextField:(MagicViewSignal *)signal
{
    if ([signal.source isKindOfClass:[MagicUITextField class]])
    {
        MagicUITextField *textField = [signal source];
        
        if ([signal is:[MagicUITextField TEXTFIELDDIDENDEDITING]])
        {
            [self animateTextField:[textField superview] up:NO getContrl:self];
        }else if ([signal is:[MagicUITextField TEXTFIELD]])
        {
            
            [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(sizeStatus) userInfo:nil repeats:NO];
            
            
        }else if ([signal is:[MagicUITextField TEXTFIELDSHOULDRETURN]])
        {
            [textField resignFirstResponder];
            
        }
        else if ([signal is:[MagicUITextField TEXTFIELDSHOULDCLEAR]])
        {
            if ([self phoneNumRegExp:_phoneInput.nameField.text] == YES) {
                
                _codeButton.backgroundColor = ColorBlue;
                _codeButton.tag = 1;
                
            }else {
                
                _codeButton.backgroundColor = [MagicCommentMethod color:229 green:229 blue:229 alpha:1.0];
                _codeButton.tag = 0;
            }
            
            [self setButtonImage:self.rightButton setImage:@"btn_next_dis"];
        }else if ([signal is:[MagicUITextField TEXTFIELDDIDBEGINEDITING]]) //开始编辑
        {
            [self animateTextField:[textField superview] up:YES getContrl:self];
            
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
                
//                DLogInfo(@"========%@",[response.data objectForKey:@"security_authcode"]);
                //            NSArray *list=[response.data objectForKey:@"security_authcode"];
                _stringCode = [response.data objectForKey:@"send"];
                
                DLogInfo(@"=======%@",_stringCode);
            }
            else if ([response response] ==khttpfailCode){
                
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                
                DLogInfo(@"=======%@",response.message);
                
            }
        }
        
        //校验验证码接口
        if (request.tag == 2) {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                
                if (_type == 1) {
                    
                    [_father changPhone:_phoneInput.nameField.text];
                    
                    [self.drNavigationController popViewControllerAnimated:YES];
                    
                }else {
                    
                    
                    security_verifyauthcode *verifyauthcode = [[security_verifyauthcode alloc]init];
                    
                    verifyauthcode.verifyed = [response.data objectForKey:@"verifyed"];
                    verifyauthcode.userid = [response.data objectForKey:@"userid"];
                    verifyauthcode.login_name = [response.data objectForKey:@"login_name"];
                    
                    
                    DYBResetPassWordViewController *vc = [[DYBResetPassWordViewController alloc] init];
                    [vc setCodeString:_codeInput.nameField.text];
                    [vc setLoginName:verifyauthcode.login_name];
                    [vc setUserId:verifyauthcode.userid];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                
                
                
                
                
            }
            else if ([response response] ==khttpfailCode){
                
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                
            }
        }
        
        
        
    }
    
}


@end
