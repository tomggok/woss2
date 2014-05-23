//
//  DYBRegisterStep2ViewController.m
//  DYiBan
//
//  Created by Song on 13-8-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBRegisterStep2ViewController.h"
#import "DYBRegisterStep3ViewController.h"
#import "source_schoollist.h"
#import "DYBScroller.h"
#import "DYBBoxView.h"
#import "scrollerData.h"
#import "userRegistModel.h"
#import "school_list.h"
#import "security_cert.h"
#import "DYBSelectSchoolController.h"
#import "CALayer+Custom.h"
#import "user.h"
@interface DYBRegisterStep2ViewController () {
    
    DYBScroller *db;
}

@end

@implementation DYBRegisterStep2ViewController
DEF_SIGNAL(CODEBUTTON) // 验证码
DEF_SIGNAL(JUMPBUTTON)//跳过
DEF_SIGNAL(SCHOOLBUTTON) //选择学校
@synthesize back = _back;
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        self.view.userInteractionEnabled= YES;
        [self.headview setTitle:@"校方认证"];
        
        [self.leftButton setHidden:YES];
        
        if (_back) {
            [self.leftButton setHidden:NO];
        }
        
        
        [self setTextString];
        [self sizeStatus];
        self.view.backgroundColor =ColorBackgroundGray;

    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        
        _schoollist_data = [[NSMutableArray alloc]init];
        NSArray *namArr = [[NSArray alloc]initWithObjects:@"学校",@"姓名",@"有效证件号(请先选择学校)",@"手机", nil];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 20+self.headHeight, INPUTWIDTH, INPUTHEIGHT*4-4)];
        [bgView.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[MagicCommentMethod color:229 green:229 blue:229 alpha:1.0] CGColor]];
        [self.view addSubview:bgView];
        RELEASE(bgView)
        
        for (int i = 0; i < 4; i++) {
            
            //输入用户名
            textInput[i] = [[DYBInputView alloc]initWithFrame:CGRectMake(0, (INPUTHEIGHT-1)*i, INPUTWIDTH, INPUTHEIGHT) placeText:[namArr objectAtIndex:i] textType:0];
            [bgView addSubview:textInput[i]];
            RELEASE(textInput[i]);
            
        }
        
        textInput[2].nameField.userInteractionEnabled = NO;
        
        [self setTextString];
        
        
        MagicUIButton *schoolBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(5, 5, INPUTWIDTH-10, INPUTHEIGHT-10)];
        schoolBtn.backgroundColor = [UIColor clearColor];
        [schoolBtn addSignal:[DYBRegisterStep2ViewController SCHOOLBUTTON] forControlEvents:UIControlEventTouchUpInside];
        textInput[0].userInteractionEnabled = YES;
        [textInput[0] addSubview:schoolBtn];
        RELEASE(schoolBtn);
        
        //验证码按钮
        UIImage *registImage = [UIImage imageNamed:@"btn_passcode_def"];
        MagicUIButton *btnCode = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-registImage.size.height/2-10, registImage.size.width/2, registImage.size.height/2)];
        [self setMagicUIButton:btnCode setImageNorm:[UIImage imageNamed:@"btn_passcode_def"] setImageHigh:[UIImage imageNamed:@"btn_passcode_high"] signal:[DYBRegisterStep2ViewController CODEBUTTON] setControl:self];
        
        //跳过按钮 
        MagicUIButton *btnJump = [[MagicUIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-registImage.size.width/2, btnCode.frame.origin.y, registImage.size.width/2, registImage.size.height/2)];
        [self setMagicUIButton:btnJump setImageNorm:[UIImage imageNamed:@"btn_skip_def"] setImageHigh:[UIImage imageNamed:@"btn_skip_high"] signal:[DYBRegisterStep2ViewController JUMPBUTTON] setControl:self];
        
    }
}

- (void)setTextString {
    
    textInput[1].nameField.text = SHARED.registUserSetting.registTureName;
    textInput[3].nameField.text = SHARED.registUserSetting.registPhoneNum;
    
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
            //校园认证
            
            DLogInfo(@"===schoolid : 学校id======%@",SHARED.registUserSetting.registSchool);
            DLogInfo(@"====realname : 真实名字=====%@",SHARED.registUserSetting.registTureName);
            DLogInfo(@"===cert_key :======%@",SHARED.registUserSetting.registCodeNum);
            DLogInfo(@"=========%@",SHARED.registUserSetting.registcert_key);
            
            MagicRequest *request = [DYBHttpMethod security_cert:SHARED.registUserSetting.registSchool realName:SHARED.registUserSetting.registTureName certNum:SHARED.registUserSetting.registCodeNum phone:SHARED.registUserSetting.registPhoneNum cerCode:SHARED.registUserSetting.registver_code certKey:SHARED.registUserSetting.registcert_key isAlert:YES receive:self];
            [request setTag:2];
        }
        
        
    }
    
}


//字符位数
- (BOOL)sizeStatus {
    
    [self setButtonImage:self.leftButton setImage:@"btn_back_def" setHighString:@"btn_back_hlt"];
    [self setButtonImage:self.rightButton setImage:@"btn_ok_dis"];
    
    SHARED.registUserSetting.registTureName = textInput[1].nameField.text;
    SHARED.registUserSetting.registCodeNum = textInput[2].nameField.text;
    SHARED.registUserSetting.registPhoneNum = textInput[3].nameField.text;
    
    if (textInput[0].nameField.text.length < 1 || textInput[2].nameField.text.length < 1 || textInput[3].nameField.text.length < 1) {
        
        return NO;
        
    }
    
    if (![self phoneNumRegExp:textInput[3].nameField.text]) {
        
        return NO;
    }
    
    [self setButtonImage:self.rightButton setImage:@"btn_ok_def" setHighString:@"btn_ok_high"];
    return YES;
}


#pragma mark- RegExp 手机格式正则
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

/*
#pragma mark- 选择滑动框
- (void)handleViewSignal_DYBScroller:(MagicViewSignal *)signal
{
    NSDictionary *dict = (NSDictionary *)[signal object];
    DYBBoxView *boxView = [dict objectForKey:@"boxview"];
    
    
    if ([signal is:[DYBScroller PICKERCLICKEEND]])
    {
        textInput[2].nameField.userInteractionEnabled = YES;
        textInput[0].nameField.text = boxView.textLabel.text;
        SHARED.registUserSetting.registSchool = boxView.id;//获取学校id
        if (db) {
            REMOVEFROMSUPERVIEW(db);
        }
        
        MagicRequest *request = [DYBHttpMethod school_cert:boxView.id isAlert:YES receive:self];
        [request setTag:3];
        
        
    }
    
    if ([signal is:[DYBScroller PICKERCLICK]]) {
    }
    
}
*/

#pragma mark- 点击按钮
- (void)handleViewSignal_DYBRegisterStep2ViewController:(MagicViewSignal *)signal
{
    self.view.userInteractionEnabled= NO;
    //code 
    if ([signal is:[DYBRegisterStep2ViewController CODEBUTTON]])
    {
        DYBRegisterStep3ViewController *vc = [[DYBRegisterStep3ViewController alloc] init];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }
    //jump
    if ([signal is:[DYBRegisterStep2ViewController JUMPBUTTON]]) {
        if ([[[self drNavigationController] allviewControllers] containsObject:[DYBUITabbarViewController sharedInstace]])
        {
            [self.drNavigationController popVCAnimated:YES];
        }else
        {
            //跳转到动态页面
            DYBUITabbarViewController *vc = [[DYBUITabbarViewController sharedInstace] init:self];
            [vc initLeftView];
            [self.drNavigationController pushViewController:vc animated:YES];

        }
            
    }
    //school
    if ([signal is:[DYBRegisterStep2ViewController SCHOOLBUTTON]]) {
        
        

        DYBSelectSchoolController *vc = [[DYBSelectSchoolController alloc] init];
        [vc setFather:self];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
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
            textInput[0].userInteractionEnabled = YES;
            [self animateTextField:[textField superview] up:NO getContrl:self];
            
        }else if ([signal is:[MagicUITextField TEXTFIELD]])
        {
            [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(sizeStatus) userInfo:nil repeats:NO];
            
        }else if ([signal is:[MagicUITextField TEXTFIELDSHOULDRETURN]])
        {
            [textField resignFirstResponder];
            
        }else if ([signal is:[MagicUITextField TEXTFIELDDIDBEGINEDITING]]) //开始编辑
        {
            textInput[0].userInteractionEnabled = NO;
            [self animateTextField:[textField superview] up:YES getContrl:self];
            
        }else if ([signal is:[MagicUITextField TEXTFIELDSHOULDCLEAR]])
        {
            //点击删除文字按钮
            [self setButtonImage:self.rightButton setImage:@"btn_ok_dis"];
            
        }
        
        
    }
    
    
}

- (void)changeText:(NSString*)string scrollerData:(scrollerData*)scrollerData {
    
    textInput[2].nameField.userInteractionEnabled = YES;
    textInput[0].nameField.text = scrollerData.name;
    SHARED.registUserSetting.registSchool = scrollerData.id;//获取学校id
    textInput[2].nameField.placeholder = string;
}

#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        
        self.view.userInteractionEnabled= YES;
        //学校校园认证接口
        if (request.tag == 2) {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                SHARED.sessionID = response.sessID;
                
                security_cert *securityCert = [security_cert JSONReflection:response.data];
                
                
                if ([securityCert.verified isEqualToString:@"1"]) {
                    
                    SHARED.curUser.verify = @"2";
                    //跳转到动态页面
                    DYBUITabbarViewController *vc = [[DYBUITabbarViewController sharedInstace] init:self];
                    [vc initLeftView];
                    [self.drNavigationController pushViewController:vc animated:YES];
                }else {
                    
                    //跳转到验证码页面
                    DYBRegisterStep3ViewController *vc = [[DYBRegisterStep3ViewController alloc] init];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                
//                //是否需要出现认证码认证 0是1否  
//                if ([securityCert.authcode isEqualToString:@"0"]) {
//                    
//                    
//                    
//                }else {
//                    //跳转到动态页面
//                    DYBUITabbarViewController *vc = [[DYBUITabbarViewController sharedInstace] init:self];
//                    [vc initLeftView];
//                    [self.drNavigationController pushViewController:vc animated:YES];
//                }
                
            }
            
            if ([response response] ==khttpfailCode)
            {
                
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                DLogInfo(@"=======%@",response.message);
            }
        }
    }
    
}




@end
