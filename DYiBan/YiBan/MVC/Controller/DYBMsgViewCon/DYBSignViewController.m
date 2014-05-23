//
//  DYBSignViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSignViewController.h"
#import "DYBPersonalHomePageViewController.h"
#import "UITableView+property.h"


@interface DYBSignViewController () {
    
    MagicUITextView *textView;
    MagicUILabel *numLabel;
    NSString *_stringCode;
    
    int maxLength;
}

@property (nonatomic,copy) NSString *str_newSign/*最新修改过的心情*/;


@end

@implementation DYBSignViewController

@synthesize str_newSign=_str_newSign,bDataBank = _bDataBank,oid = _oid,dictInfo = _dictInfo;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(15, self.headHeight+15, CGRectGetWidth(self.view.frame)-30, 90)];
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = [ColorDivLine CGColor];
        [self.view addSubview:backView];
        RELEASE(backView);
        
        textView = [[MagicUITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-30, 70)];
        [textView setBackgroundColor:[UIColor whiteColor]];
        
        maxLength = 40;
        [textView becomeFirstResponder];
        textView.font = [DYBShareinstaceDelegate DYBFoutStyle:16];
        textView.textColor = ColorBlack;
        [textView setMaxLength:maxLength];
        [backView addSubview:textView];
        RELEASE(textView);
        
        
        
        numLabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(textView.frame.origin.x+textView.frame.size.width-50, 70, 50, 20)];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.textColor = ColorGray;
        numLabel.text = [NSString stringWithFormat:@"0/%d",maxLength];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [DYBShareinstaceDelegate DYBFoutStyle:11];
        [backView addSubview:numLabel];
        RELEASE(numLabel);
  
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        //        [self backImgType:0];
        
        if (_bDataBank) {
            
            [self.headview setTitle:@"举报"];
            
            maxLength = 140;
            numLabel.text = [NSString stringWithFormat:@"0/%d",maxLength];
            [textView setMaxLength:maxLength];
            
        }else{
            
            [self.headview setTitle:@"易班心情"];
        }
        [self.leftButton setHidden:NO];
        [self.rightButton setHidden:NO];
        [self sizeStatus];
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        
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
            
            if (_bDataBank) {
                
                
                MagicRequest *request = [DYBHttpMethod document_publicreport_oid:[_dictInfo objectForKey:@"oid"] type:@"1" reason:textView.text isAlert:YES receive:self];
                [request setTag:2];
                
                _str_newSign=textView.text;
                [_str_newSign retain];
                
            }else{
            
                MagicRequest *request = [DYBHttpMethod user_setdesc:textView.text isAlert:YES receive:self];
                [request setTag:1];
                
                _str_newSign=textView.text;
                [_str_newSign retain];
            }
        }        
    }    
}

//字符位数
- (BOOL)sizeStatus {

    [self setButtonImage:self.leftButton setImage:@"btn_back_def"];
    [self setButtonImage:self.rightButton setImage:@"btn_ok_dis"];
    if (textView.text.length < 1) {
        
        return NO;
    }
    
    [self setButtonImage:self.rightButton setImage:@"btn_ok_def"];
    return YES;
}

#pragma mark- MagicUITextView
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
    if ([signal is:[MagicUITextView TEXTVIEW]])
    {
        [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(sizeStatus) userInfo:nil repeats:NO];
    }
    if ([signal is:[MagicUITextView TEXTVIEWDIDCHANGE]])
    {
        numLabel.text = [@"" stringByAppendingFormat:@"%d/%d",textView.text.length,maxLength];
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
                
                _stringCode = [response.data objectForKey:@"desc"];
                
                if ([_stringCode isEqualToString:@"1"]) {
                
                     DLogInfo(@"修改心情成功");
                    
                    DYBUITabbarViewController *con=(DYBUITabbarViewController *)[self.drNavigationController getViewController:[DYBUITabbarViewController class]];
                    DYBPersonalHomePageViewController *con1=/*[con.containerView.viewControllers objectAtIndex:con.selectedVC]*/ (DYBPersonalHomePageViewController *)con.selectedVC;
                    con1.tbv._b_isAutoRefresh=YES;
                    con1.user.desc=_str_newSign;
                    SHARED.curUser.desc=_str_newSign;
                    [self.drNavigationController popVCAnimated:YES];
                }
                
            }else if ([response response] ==khttpNeedUpdateCode)
            {
            }
            
            
        }else if (request.tag == 2){
        
            JsonResponse *response = (JsonResponse *)receiveObj;
            _stringCode = [response.data objectForKey:@"msg"];
            if ([response response] ==khttpsucceedCode)
            {
                                
                if ([[response.data objectForKey:@"result"] boolValue]) {
                    
                    [self.drNavigationController popVCAnimated:YES];
                    
                }

            }
                
                [DYBShareinstaceDelegate popViewText:_stringCode target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                
            
}
    }
}
- (void)dealloc
{
    RELEASE(_dictInfo);
    [super dealloc];
}
@end
