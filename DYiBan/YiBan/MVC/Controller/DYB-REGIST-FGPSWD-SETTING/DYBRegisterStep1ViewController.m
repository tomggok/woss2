//
//  DYBRegisterStep1ViewController.m
//  DYiBan
//
//  Created by Song on 13-8-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBRegisterStep1ViewController.h"
#import "DYBRegisterStep2ViewController.h"
#import "NSString+Count.h"
#import "userRegistModel.h"
#import "CALayer+Custom.h"
@interface DYBRegisterStep1ViewController ()

@end

@implementation DYBRegisterStep1ViewController

DEF_SIGNAL(BOYBUTTON)
DEF_SIGNAL(GIRLTBUTTON)

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.headview setTitle:@"注册"];
        [self sizeStatus];
        self.view.backgroundColor =ColorBackgroundGray;
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        selectSex = -1;
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 20+self.headHeight, INPUTWIDTH, INPUTHEIGHT*3-3)];
        [bgView.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[MagicCommentMethod color:229 green:229 blue:229 alpha:1.0] CGColor]];
        [self.view addSubview:bgView];
        RELEASE(bgView)
        
        NSArray *namArr = [[NSArray alloc]initWithObjects:@"帐号：常用邮箱",@"密码：6-16位字符",@"昵称：4-16位字符", nil];
        
        for (int i = 0; i < 3; i++) {
            
            //输入用户名
            if (i == 1) {
                
                textInput[i] = [[DYBInputView alloc]initWithFrame:CGRectMake(0, (INPUTHEIGHT-1)*i, INPUTWIDTH, INPUTHEIGHT) placeText:[namArr objectAtIndex:i] textType:1];
            }else {
                
                textInput[i] = [[DYBInputView alloc]initWithFrame:CGRectMake(0, (INPUTHEIGHT-1)*i, INPUTWIDTH, INPUTHEIGHT) placeText:[namArr objectAtIndex:i] textType:0];
            }
            
            [bgView addSubview:textInput[i]];
            RELEASE(textInput[i]);
            
        }
        
        
        UIImage *sexImage = [UIImage imageNamed:@"female_off"];
        //性别选择按钮
        for (int i = 0; i < 2; i++) {
            
            btnSex[i] = [[MagicUIButton alloc] initWithFrame:CGRectMake(bgView.frame.origin.x+(sexImage.size.width/2+40)*i, bgView.frame.origin.y+bgView.frame.size.height, sexImage.size.width/2, sexImage.size.height/2)];
            
            if (i == 1) {
                
                [self setMagicUIButton:btnSex[i] setImageNorm:[UIImage imageNamed:@"female_off"] setImageHigh:[UIImage imageNamed:@"female_off"]  signal:[DYBRegisterStep1ViewController GIRLTBUTTON] setControl:self];
                
            }else {
                
                [self setMagicUIButton:btnSex[i] setImageNorm:[UIImage imageNamed:@"male_off"] setImageHigh:[UIImage imageNamed:@"male_off"]  signal:[DYBRegisterStep1ViewController BOYBUTTON] setControl:self];
                
            }
            
            [self.view addSubview:btnSex[i]];
            
        }
        
    }
}

#pragma mark- 点击按钮
- (void)handleViewSignal_DYBRegisterStep1ViewController:(MagicViewSignal *)signal
{
    
    if ([signal is:[DYBRegisterStep1ViewController BOYBUTTON]]) {
        
        [btnSex[0] setImage:[UIImage imageNamed:@"male_on"] forState:UIControlStateNormal];
        [btnSex[0] setImage:[UIImage imageNamed:@"male_on"] forState:UIControlStateHighlighted];
        
        [btnSex[1] setImage:[UIImage imageNamed:@"female_off"] forState:UIControlStateNormal];
        [btnSex[1] setImage:[UIImage imageNamed:@"female_off"] forState:UIControlStateHighlighted];
        
        selectSex = 0;
    }
    
    if ([signal is:[DYBRegisterStep1ViewController GIRLTBUTTON]]) {
        
        [btnSex[0] setImage:[UIImage imageNamed:@"male_off"] forState:UIControlStateNormal];
        [btnSex[0] setImage:[UIImage imageNamed:@"male_off"] forState:UIControlStateHighlighted];
        
        [btnSex[1] setImage:[UIImage imageNamed:@"female_on"] forState:UIControlStateNormal];
        [btnSex[1] setImage:[UIImage imageNamed:@"female_on"] forState:UIControlStateHighlighted];
        
        selectSex = 1;
        
    }
    [self sizeStatus];
    
    
}

//判断邮箱格式
-(BOOL)isValidateEmail:(NSString *)email

{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}


//判断昵称格式
-(BOOL)isValidateName:(NSString *)name

{
    NSString *nameRegex = @"^[A-Z0-9a-z\u4e00-\u9fa5]+$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",nameRegex];
    return [nameTest evaluateWithObject:name];
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
            
            SHARED.registUserSetting.registMail = textInput[0].nameField.text;
            SHARED.registUserSetting.registPassword = textInput[1].nameField.text;
            SHARED.registUserSetting.registName = textInput[2].nameField.text;
            SHARED.registUserSetting.registSex = [@"" stringByAppendingFormat:@"%d",selectSex];
            
            MagicRequest *request = [DYBHttpMethod security_reg:textInput[0].nameField.text nickname:textInput[2].nameField.text password:textInput[1].nameField.text sex:[@"" stringByAppendingFormat:@"%d",selectSex] isAlert:YES receive:self];
            [request setTag:1];
            
        }
    }
    
}

//字符位数
- (BOOL)sizeStatus {
    
    [self setButtonImage:self.leftButton setImage:@"btn_back_def" setHighString:@"btn_back_hlt"];
    [self setButtonImage:self.rightButton setImage:@"btn_next_dis"];
    
    

    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    if ([self isValidateEmail:textInput[0].nameField.text] == NO) {
        
        return NO;
        
    }
    
    if ([textInput[1].nameField.text lengthOfBytesUsingEncoding:enc] < 6 || [textInput[1].nameField.text lengthOfBytesUsingEncoding:enc] > 16) {
        
        return NO;
    }
    
    if ([textInput[2].nameField.text lengthOfBytesUsingEncoding:enc] < 4 || [textInput[2].nameField.text lengthOfBytesUsingEncoding:enc] > 16 || [self isValidateName:textInput[2].nameField.text] == NO) {
        
        return NO;
    }
    
    if (selectSex < 0) {
        
        return NO;
    }
    [self setButtonImage:self.rightButton setImage:@"btn_next_def" setHighString:@"btn_next_hlt"];
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
            [self animateTextField:[textField superview] up:NO getContrl:self];
            
        }else if ([signal is:[MagicUITextField TEXTFIELD]])
        {
            [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(sizeStatus) userInfo:nil repeats:NO];
            
        }else if ([signal is:[MagicUITextField TEXTFIELDSHOULDRETURN]])
        {
            [textField resignFirstResponder];
            
        }else if ([signal is:[MagicUITextField TEXTFIELDDIDBEGINEDITING]]) //开始编辑
        {
            [self animateTextField:[textField superview] up:YES getContrl:self];
            
        }else if ([signal is:[MagicUITextField TEXTFIELDSHOULDCLEAR]])
        {
            [self setButtonImage:self.rightButton setImage:@"btn_next_dis"];
        }
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
            NSArray *list = [response.data objectForKey:@"school_list"];
            
            DLogInfo(@"=======%@",list);
            
            DYBRegisterStep2ViewController *vc = [[DYBRegisterStep2ViewController alloc] init];
            [vc setBack:YES];
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
            
        }
        
        if ([response response] ==khttpfailCode)
        {
            [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
            DLogInfo(@"=======%@",response.message);
        }
        

    }
    
}

@end
