//
//  DYBRegisterStep3ViewController.m
//  DYiBan
//
//  Created by Song on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBRegisterStep3ViewController.h"
#import "userRegistModel.h"
#import "DYBBoxView.h"
#import "DYBScroller.h"
#import "scrollerData.h"
#import "DYBSelectSchoolController.h"
#import "CALayer+Custom.h"
#import "user.h"
@interface DYBRegisterStep3ViewController () {
    
    DYBScroller *db;
}

@end

@implementation DYBRegisterStep3ViewController
DEF_SIGNAL(SCHOOLBUTTON) //选择学校
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.headview setTitle:@"校方认证"];
        [self setTextString];
        [self sizeStatus];
        self.view.backgroundColor =ColorBackgroundGray;
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        
        _schoollist_data = [[NSMutableArray alloc]init];
        NSArray *namArr = [[NSArray alloc]initWithObjects:@"学校",@"姓名",@"验证码",@"手机", nil];
        
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
        
        
        MagicUIButton *schoolBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(5, 5, INPUTWIDTH-10, INPUTHEIGHT-10)];
        schoolBtn.backgroundColor = [UIColor clearColor];
        [schoolBtn addSignal:[DYBRegisterStep3ViewController SCHOOLBUTTON] forControlEvents:UIControlEventTouchUpInside];
        textInput[0].userInteractionEnabled = YES;
        [textInput[0] addSubview:schoolBtn];
        RELEASE(schoolBtn);
        
        [self setTextString];
        
        
        MagicUILabel *textLabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y+bgView.frame.size.height+12-4, INPUTWIDTH, 40)];
        textLabel.numberOfLines = 2;
        textLabel.text = @"如果校方认证遇到问题，可向辅导员老师或学工部老师获取验证码通过验证。";
        [self setLabel:textLabel sizeFont:15 setColor:[MagicCommentMethod colorWithHex:@"aaaaaa"]];
    }
}

- (void)setTextString {
    
    textInput[1].nameField.text = SHARED.registUserSetting.registTureName;
    textInput[3].nameField.text = SHARED.registUserSetting.registPhoneNum;
    
}

//设置label属性
- (void)setLabel:(MagicUILabel*)label sizeFont:(int)size setColor:(UIColor *)color{
    
    label.font = [DYBShareinstaceDelegate DYBFoutStyle:size];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
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
        
        if ([self sizeStatus]) {
            /*
            NSLog(@"========registSchool=======%@",SHARED.registUserSetting.registSchool);
            NSLog(@"========registTureName=======%@",SHARED.registUserSetting.registTureName);
            NSLog(@"========registPhoneNum=======%@",SHARED.registUserSetting.registPhoneNum);
            NSLog(@"========registver_code=======%@",SHARED.registUserSetting.registver_code);
            NSLog(@"=========registcert_key======%@",SHARED.registUserSetting.registcert_key);
             */
            
            //校园认证
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
    SHARED.registUserSetting.registver_code = textInput[2].nameField.text;
    SHARED.registUserSetting.registPhoneNum = textInput[3].nameField.text;
    
    if (textInput[0].nameField.text.length < 1 || textInput[1].nameField.text.length < 1 || textInput[2].nameField.text.length < 1 || textInput[3].nameField.text.length < 1) {
        
        return NO;
        
    }
    
    if (![self phoneNumRegExp:textInput[3].nameField.text]) {
        
        return NO;
    }
    
    [self setButtonImage:self.rightButton setImage:@"btn_ok_def" setHighString:@"btn_ok_high"];
    return YES;
}


- (void)changeText:(NSString*)string scrollerData:(scrollerData*)scrollerData {
    
    textInput[0].nameField.text = scrollerData.name;
    SHARED.registUserSetting.registSchool = scrollerData.id;//获取学校id
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

#pragma mark- 点击按钮
- (void)handleViewSignal_DYBRegisterStep3ViewController:(MagicViewSignal *)signal
{
    //school
    if ([signal is:[DYBRegisterStep3ViewController SCHOOLBUTTON]]) {
        
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


#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        
        //校园认证验证码请求
        if (request.tag == 2) {
            
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                
                SHARED.sessionID = response.sessID;
                SHARED.curUser.verify = @"2";
                //跳转到动态页面
                DYBUITabbarViewController *vc = [[DYBUITabbarViewController sharedInstace] init:self];
                [vc initLeftView];
                [self.drNavigationController pushViewController:vc animated:YES];

              
            }else if ([response response] ==khttpfailCode){
                
                [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
            }
        }
        
        
    }
    
}


@end
