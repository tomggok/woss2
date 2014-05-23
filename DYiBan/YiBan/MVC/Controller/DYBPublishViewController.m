//
//  DYBPublishViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBPublishViewController.h"
#import "user.h"
#import "DYBSNSSyncViewController.h"
#import "DYBImagePickerController.h"
#import "DYBCheckImageViewController.h"
#import "DYBATViewController.h"
#import "XiTongFaceCode.h"
#import "UIViewController+MagicViewSignal.h"
#import "UIImage+MagicCategory.h"
#import "DYBDynamicViewController.h"
#import "DYBDataBankSelectBtn.h"
#import "UIViewController+MagicCategory.h"
#import "NSObject+KVO.h"
#import "DYBPersonalHomePageViewController.h"
#import "DYBGuideView.h"
#import "DYBActivityViewController.h"

@interface DYBPublishViewController ()

@end

@implementation DYBPublishViewController

DEF_SIGNAL(SELFLOCATION)
DEF_SIGNAL(DYNAMICPRIVATE)
DEF_SIGNAL(SHARERENREN)
DEF_SIGNAL(SHARETENCENT)
DEF_SIGNAL(SYNCRESULT);
DEF_SIGNAL(PRIVATESELECT)
DEF_SIGNAL(SELECTIMAGE)
DEF_SIGNAL(SHOWIMAGE)
DEF_SIGNAL(DELETEMAGE)
DEF_SIGNAL(SELECTEMOJI)
DEF_SIGNAL(SELECTAT)
DEF_SIGNAL(SELECTATLIST)

- (void)dealloc{
    RELEASEDICTARRAYOBJ(_arrSelPic);
    
    [self unobserveAllNotification];
    [super dealloc];
}

-(id)init:(NSString *)activeTitle activeid:(NSString *)activeid bActive:(BOOL)bActive{
    self = [super init];
    if (self) {
        _bActive = bActive;
        if (_bActive) {
            _strActiveTitle = activeTitle;
            _strActiveid = activeid;
        }
    }
    return self;
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]]){
        [self.headview setTitle:@"发动态"];
        [self backImgType:0];
        [self backImgType:6];
        
        NSString *_strContent = [self convertSystemEmoji:_txtViewPublish.text];
        _strContent = [_strContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([_arrSelPic count] == 0 && [_strContent length] == 0) {
            self.rightButton.enabled = NO;
        }
        
        if (_bActive) {
            return;
        }
        
        if (![[NSUserDefaults standardUserDefaults] stringForKey:@"DYBPublishViewController_DYBGuideView"] || [[[NSUserDefaults standardUserDefaults] stringForKey:@"DYBPublishViewController_DYBGuideView"] intValue]==0) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DYBPublishViewController_DYBGuideView"];
            
            {
                [self hideKeyBoard];
                DYBGuideView *guideV=[[DYBGuideView alloc]initWithFrame:self.view.frame];
                guideV.AddImgByName(@"Dynamicshare", nil);
                [self.drNavigationController.view addSubview:guideV];
                RELEASE(guideV);
            }
        }
  
    }else if ([signal is:[MagicViewController CREATE_VIEWS]]){
        _sync_tag = [SHARED.curUser.sync_tag intValue];
        _arrMenu = [[NSArray alloc] initWithArray:@[@"", @"   公开", @"   好友可见", @"   班级可见"]];
        _arrSelPic = [[NSMutableArray alloc] initWithCapacity:6];
        _bOverSize = NO;
        
        [self initPublishInterface];
        
        
        [self observeNotification:[DYBPhotoEditorView DOSAVEIMAGE]];
        //键盘消息
        [self observeNotification:[MagicUIKeyboard SHOWN]];
        [self observeNotification:[MagicUIKeyboard HIDDEN]];
    }
}

// 触摸背景，关闭键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIView *view = (UIView *)[touch view];
    if (view == self.view) {
        [_txtViewPublish resignFirstResponder];
    }
}


#pragma mark- 初始化界面
-(void)initPublishInterface{
    UIView *viewBKG = [[UIView alloc] initWithFrame:CGRectMake(15, 44+15, CGRectGetWidth(self.view.frame)-30, 88+2)];
    [viewBKG setBackgroundColor:ColorDivLine];
    CALayer *lay  = viewBKG.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [viewBKG.layer setMasksToBounds:YES];
    [viewBKG.layer setCornerRadius:5.0f];//值越大，角度越圆
    [viewBKG.layer setShadowOffset:CGSizeMake(3.0f, 3.0f)];
    [viewBKG.layer setShadowColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:viewBKG];
    RELEASE(viewBKG);
    
    UIView *viewBKGWhite = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 288, 88)];
    [viewBKGWhite setBackgroundColor:[UIColor whiteColor]];
    CALayer *layW  = viewBKGWhite.layer;//获取ImageView的层
    [layW setMasksToBounds:YES];
    [viewBKGWhite.layer setMasksToBounds:YES];
    [viewBKGWhite.layer setCornerRadius:4.0f];//值越大，角度越圆
    [viewBKGWhite.layer setShadowOffset:CGSizeMake(3.0f, 3.0f)];
    [viewBKGWhite.layer setShadowColor:[UIColor whiteColor].CGColor];
    [viewBKG addSubview:viewBKGWhite];
    RELEASE(viewBKGWhite);
    
    _txtViewPublish = [[MagicUITextView alloc] initWithFrame:CGRectMake(0, 0, 288, 58)];
    [_txtViewPublish setTextColor:ColorBlack];
    [_txtViewPublish setFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
    [_txtViewPublish setBackgroundColor:[UIColor clearColor]];
//    [_txtViewPublish becomeFirstResponder];
    [_txtViewPublish setReturnKeyType:UIReturnKeyDone];
    [viewBKGWhite addSubview:_txtViewPublish];
    RELEASE(_txtViewPublish);
    
    if(_bActive && [_strActiveTitle length] > 0){
        [_txtViewPublish setText:[NSString stringWithFormat:@"#%@#", _strActiveTitle]];
    }

    UIImage *imgAt = [UIImage imageNamed:@"btn_at_nor.png"];
    _btnSelAt = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(viewBKGWhite.frame)-imgAt.size.width/2, CGRectGetHeight(viewBKGWhite.frame)-imgAt.size.height/2, imgAt.size.width/2, imgAt.size.height/2)];
    [_btnSelAt setBackgroundColor:[UIColor clearColor]];
    [_btnSelAt setBackgroundImage:imgAt forState:UIControlStateNormal];
    [_btnSelAt addSignal:[DYBPublishViewController SELECTAT] forControlEvents:UIControlEventTouchUpInside];
    [viewBKGWhite addSubview:_btnSelAt];
    RELEASE(_btnSelAt);
    
    UIImage *imgEmoji = [UIImage imageNamed:@"btn_emoji_nor.png"];
    _btnSelEmoji = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_btnSelAt.frame)-imgEmoji.size.height/2, CGRectGetMinY(_btnSelAt.frame), imgEmoji.size.width/2, imgEmoji.size.height/2)];
    [_btnSelEmoji setBackgroundColor:[UIColor clearColor]];
    [_btnSelEmoji setBackgroundImage:imgEmoji forState:UIControlStateNormal];
    [_btnSelEmoji addSignal:[DYBPublishViewController SELECTEMOJI] forControlEvents:UIControlEventTouchUpInside];
    [viewBKGWhite addSubview:_btnSelEmoji];
    [_btnSelEmoji setSelected:NO];
    RELEASE(_btnSelEmoji);
    
    _textCount = [[MagicUILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(viewBKGWhite.frame)-21, 70, 25)];
    [_textCount setBackgroundColor:[UIColor clearColor]];
    [_textCount setFont:[DYBShareinstaceDelegate DYBFoutStyle:13]];
    [_textCount setTextColor:ColorTextCount];
    [_textCount setText:@"0/140"];
    [_textCount setTextAlignment:NSTextAlignmentLeft];
    [_textCount setNeedCoretext:YES];
    [viewBKGWhite addSubview:_textCount];
    RELEASE(_textCount);
    
    _viewPicBKG = [[UIScrollView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(viewBKG.frame)+10, CGRectGetWidth(viewBKG.frame), 63)];
    [_viewPicBKG setBackgroundColor:ColorCellSepL];
    [_viewPicBKG setContentSize:CGSizeMake(349, 63)];
    [_viewPicBKG setShowsHorizontalScrollIndicator:NO];
    [_viewPicBKG setScrollEnabled:NO];
    [self.view addSubview:_viewPicBKG];
    RELEASE(_viewPicBKG);
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHiddenInput)];
        [_viewPicBKG addGestureRecognizer:tapGestureRecognizer];
        RELEASE(tapGestureRecognizer);
    }

    UIImage *imgSel = [UIImage imageNamed:@"btn_imgSelect_nor"];
    _btnSelImage = [[MagicUIButton alloc] initWithFrame:CGRectMake(6, 7, 50, 50)];
    [_btnSelImage setBackgroundColor:[UIColor clearColor]];
    [_btnSelImage setBackgroundImage:imgSel forState:UIControlStateNormal];
    [_btnSelImage addSignal:[DYBPublishViewController SELECTIMAGE] forControlEvents:UIControlEventTouchUpInside];
    [_viewPicBKG addSubview:_btnSelImage];
    RELEASE(_btnSelImage);
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.0) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelImage)];
        [_btnSelImage addGestureRecognizer:tapGestureRecognizer];
        RELEASE(tapGestureRecognizer);
    }
    
    if (!_bActive) {
        _btnLocation = [[MagicUIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_viewPicBKG.frame)+10, 140, 45)];
        [_btnLocation setBackgroundColor:[UIColor clearColor]];
        [_btnLocation setBackgroundImage:[UIImage imageNamed:@"btn_locate_off.png"] forState:UIControlStateNormal];
        [_btnLocation setBackgroundImage:[UIImage imageNamed:@"btn_locate_on.png"] forState:UIControlStateSelected];
        [_btnLocation setTitle:@"   当前位置" forState:UIControlStateNormal];
        [_btnLocation setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
        [_btnLocation setTitleColor:[UIColor whiteColor]];
        [_btnLocation addSignal:[DYBPublishViewController SELFLOCATION] forControlEvents:UIControlEventTouchUpInside];
        
        if ([[self GetLocationPrivateStatus] isEqualToString:@"1"]) {
            [_btnLocation setSelected:YES];
        }
        
        [self.view addSubview:_btnLocation];
        RELEASE(_btnLocation);
        
        _btnPrivate = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnLocation.frame)+10, CGRectGetMinY(_btnLocation.frame), 140, 45)];
        [_btnPrivate setBackgroundColor:[UIColor clearColor]];
        [_btnPrivate setBackgroundImage:[UIImage imageNamed:@"btn_private_normal.png"] forState:UIControlStateNormal];
        [_btnPrivate setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
        [_btnPrivate setTitleColor:[UIColor whiteColor]];
        [_btnPrivate addSignal:[DYBPublishViewController DYNAMICPRIVATE] forControlEvents:UIControlEventTouchUpInside];
        [_btnPrivate setAdjustsImageWhenHighlighted:NO];
        [_btnPrivate setSelected:NO];
        [self.view addSubview:_btnPrivate];
        RELEASE(_btnPrivate);
        
        if ([[self GetDynamicPrivateStatus] isEqualToString:@"2"]) {
            [_btnPrivate setTitle:[_arrMenu objectAtIndex:2] forState:UIControlStateNormal];
        }else if([[self GetDynamicPrivateStatus] isEqualToString:@"4"]){
            [_btnPrivate setTitle:[_arrMenu objectAtIndex:3] forState:UIControlStateNormal];
        }else{
            [_btnPrivate setTitle:[_arrMenu objectAtIndex:1] forState:UIControlStateNormal];
        }
        
        _btnShareRenRen = [[MagicUIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_btnLocation.frame)+20, 30, 30)];
        [_btnShareRenRen setBackgroundColor:[UIColor clearColor]];
        [_btnShareRenRen setBackgroundImage:[UIImage imageNamed:@"btn_renren_off.png"] forState:UIControlStateNormal];
        [_btnShareRenRen setBackgroundImage:[UIImage imageNamed:@"btn_renren_on.png"] forState:UIControlStateSelected];
        [_btnShareRenRen addSignal:[DYBPublishViewController SHARERENREN] forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnShareRenRen];
        RELEASE(_btnShareRenRen);
        
        _btnShareTencent = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnShareRenRen.frame)+15, CGRectGetMinY(_btnShareRenRen.frame), 30, 30)];
        [_btnShareTencent setBackgroundColor:[UIColor clearColor]];
        [_btnShareTencent setBackgroundImage:[UIImage imageNamed:@"btn_tencent_off.png"] forState:UIControlStateNormal];
        [_btnShareTencent setBackgroundImage:[UIImage imageNamed:@"btn_tencent_on.png"] forState:UIControlStateSelected];
        [_btnShareTencent addSignal:[DYBPublishViewController SHARETENCENT] forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnShareTencent];
        RELEASE(_btnShareTencent);
        
        switch (_sync_tag) {
            case 2://腾讯是否同步
                [_btnShareTencent setSelected:YES];
                break;
            case 4://人人是否同步
                [_btnShareRenRen setSelected:YES];
                break;
            case 6://人人与腾讯都已经同步
                [_btnShareTencent setSelected:YES];
                [_btnShareRenRen setSelected:YES];
                break;
        }
    }else{
        [_txtViewPublish sendViewSignal:[MagicUITextView TEXTVIEWDIDCHANGE]];
    }
}

- (void)tapSelImage{
    [_btnSelImage sendViewSignal:[DYBPublishViewController SELECTIMAGE]];
}

- (void)tapHiddenInput{
    [self hideKeyBoard];
    
    if (_btnSelEmoji.selected == YES) {
        [_btnSelEmoji sendViewSignal:[DYBPublishViewController SELECTEMOJI]];
    }
}


#pragma mark - 返回Button处理
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
        [self hideKeyBoard];
        
        if (_bOverSize) {
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"超过字数限制！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
            [self hideKeyBoard];
            return;
        }
        
        NSMutableArray *_arrIMGData = [[NSMutableArray alloc] init];
        
        for (UIImage *imgSendPic in _arrSelPic) {
            NSData *dataPic = [self zipImg:imgSendPic];
//            NSData *dataPic = UIImagePNGRepresentation(imgSendPic);
            [_arrIMGData addObject:dataPic];
        }

        NSString *_strContent = [self convertSystemEmoji:_txtViewPublish.text];
        _strContent = [_strContent stringByReplacingOccurrencesOfString: @"\r" withString:@""];
        _strContent = [_strContent stringByReplacingOccurrencesOfString: @"\n" withString:@""];
        _strContent = [_strContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *strPrivacy = [[NSUserDefaults standardUserDefaults] stringForKey:@"LocationPrivacy"];
        NSString *strAdd = nil;
        
        if ([strPrivacy isEqualToString:@"1"]) {
            strAdd = [[NSUserDefaults standardUserDefaults] stringForKey:@"SignAdd"];
        }
        
        NSMutableDictionary *dict = nil;
        if (_bActive) {
            dict = [DYBHttpInterface active_addfeed:_strContent active_id:_strActiveid];
        }else{
            MagicUIButton *bt = [signal source];
            [bt setNetClickOne];
            dict = [DYBHttpInterface status_add_content:_strContent add_notice:@"0" sync_tag:_sync_tag refuse:[self GetDynamicPrivateStatus] at_eclass:@"" address:strAdd];
        }

        DYBRequest *request = AUTORELEASE([[DYBRequest alloc] init]);
        MagicRequest *dre = [request DYBPOSTIMG:dict isAlert:YES receive:self imageData:_arrIMGData];
        dre.tag =  -1;
        
        RELEASEDICTARRAYOBJ(_arrIMGData);
    }else if ([signal is:[DYBBaseViewController BACKBUTTON]]){
        [self hideKeyBoard];
        
        if (self.rightButton.enabled == YES || [_arrSelPic count] > 0) {    
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"是否放弃发布动态？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:@"1"];
        }else{
            [self.drNavigationController popVCAnimated:YES];
            [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
        }
    }
    
}

-(BOOL)checkIncludeString_string:(NSString*)str include_str:(NSString*)include_str{
    NSRange range = [str rangeOfString:include_str];
    if (range.length > 0) {
        return YES;
    }else{
        return NO;
    }
}

-(NSString *)convertSystemEmoji:(NSString *)orgString{
    NSString *strConvert = [NSString stringWithFormat:@"%@", orgString];
    
    if ([self checkIncludeString_string:strConvert include_str:@"\xe2\x98\xba"])
    {
        strConvert = [strConvert stringByReplacingOccurrencesOfString:@"\xe2\x98\xba" withString:@"[小嘴微笑]"];
    }
    
    if ([self checkIncludeString_string:strConvert include_str:@"\xe2\x9c\x8c"]) {
        strConvert = [strConvert stringByReplacingOccurrencesOfString:@"\xe2\x9c\x8c" withString:@"[胜利]"];
    }
    if ([self checkIncludeString_string:strConvert include_str:@"\xe2\x9c\x8a"]) {
        strConvert = [strConvert stringByReplacingOccurrencesOfString:@"\xe2\x9c\x8a" withString:@"[掌心拳]"];
    }
    
    if (strConvert.length > 0) {
        
        XiTongFaceCode * faceCode = [[XiTongFaceCode alloc]init];
        NSMutableDictionary* dictFace = [faceCode ServerToXiTong];
        for (int i = 0; i < [strConvert length] - 1; i++) {
            NSRange range = NSMakeRange(i, 2);
            NSString *tempStr = [strConvert substringWithRange:range];
            NSString *temp = [dictFace objectForKey:tempStr];
            if (temp) {
                strConvert = [strConvert stringByReplacingOccurrencesOfString:tempStr withString:temp];
            }
        }
        
        [faceCode release];
    }
    
    return strConvert;
}

- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{
    if ([request succeed]){
        if (request.tag == -1){/*发送动态*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                DLogInfo(@"publish is successful");
                [DYBShareinstaceDelegate loadFinishAlertView:@"发送成功" target:self];
                
                [self sendViewSignal:[DYBDynamicViewController PUBLISHREFRESH] withObject:nil from:self target:[[DYBUITabbarViewController sharedInstace] getFirstViewVC]];
                
                for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
                    if ([vc isKindOfClass:[DYBActivityViewController class]]) {
                        [self sendViewSignal:[DYBActivityViewController PUBLISHREFRESH] withObject:nil from:self target:(DYBActivityViewController *)vc];
                        break;
                    }
                }
                
                [self postNotification:[UIViewController AutoRefreshTbvInViewWillAppear] withObject:Nil userInfo:Nil];
                
                [self.drNavigationController popVCAnimated:YES];
//                [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
                
            }
        }else if (request.tag == -3){
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                NSString * result = [respose.data objectForKey:@"result"];
                if ([result isEqualToString:@"1"]) {
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"解除绑定成功！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
                    [_btnShareTencent setSelected:NO];
                    SHARED.curUser.sync_tag = [NSString stringWithFormat:@"%d", [SHARED.curUser.sync_tag intValue]-2];
                }
                else{
                     [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"解除绑定失败！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
                }
            }
        }else if (request.tag == -4){
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                NSString * result = [respose.data objectForKey:@"result"];
                if ([result isEqualToString:@"1"]) {
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"解除绑定成功！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
                    [_btnShareRenRen setSelected:NO];
                    SHARED.curUser.sync_tag = [NSString stringWithFormat:@"%d", [SHARED.curUser.sync_tag intValue]-4];
                }
                else{
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"解除绑定失败！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
                }
            }
        }
    }else if ([request failed]){
        [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"发送失败！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
        [self hideKeyBoard];
    }
}

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification is:[DYBPhotoEditorView DOSAVEIMAGE]]){
        
        UIImage *img = (UIImage*)[notification object];
        NSDictionary *dic = (NSDictionary *)[notification userInfo];
        
        NSInteger nType = [[dic objectForKey:@"type"] intValue];
        
        if (nType != 1) {
            return;
        }
        
        
        if (![_arrSelPic containsObject:img]) {
            [_arrSelPic addObject:img];
        }
        
        UIImage *imgScale = [self scaleToSize:img size:CGSizeMake(50, 50)];
        NSData *imageData = UIImageJPEGRepresentation(imgScale, 0.5);
        
        if ([_arrSelPic count] < 7) {
            int nIndex = [_arrSelPic count] -1;
            MagicUIButton *btnPic = [[MagicUIButton alloc] initWithFrame:CGRectMake(7+nIndex*57, 7, 50, 50)];
            [btnPic setBackgroundColor:[UIColor clearColor]];
            [btnPic setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
            [btnPic setContentMode:UIViewContentModeScaleToFill];
            [btnPic addSignal:[DYBPublishViewController SHOWIMAGE] forControlEvents:UIControlEventTouchUpInside];
            [_viewPicBKG addSubview:btnPic];
            RELEASE(btnPic);
        }
        
        [_btnSelImage setFrame:CGRectMake(6+57*[_arrSelPic count], 7, 50, 50)];
    
        int nCount = [_arrSelPic count];
        
        if (nCount >= 6) {
            [_btnSelImage setHidden:YES];
            [_viewPicBKG setScrollEnabled:YES];
            [_viewPicBKG setContentOffset:CGPointMake(64, 0) animated:YES];
        }else if (nCount == 5){
            [_viewPicBKG setScrollEnabled:YES];
            [_viewPicBKG setContentOffset:CGPointMake(64, 0) animated:YES];
        }
        
        [self.rightButton setEnabled:YES];
        
    }else if([notification is:[MagicUIKeyboard SHOWN]]){
        
        if (_btnSelEmoji.selected == YES) {
            [self sendViewSignal:[DYBPublishViewController SELECTEMOJI]];
        }
        [self setVCBackAnimation:SWIPELASTIMAGEBACKTYPE canBackPageNumber:0];
    }else if ([notification is:[MagicUIKeyboard HIDDEN]])
    {
        [self setVCBackAnimation:SWIPELASTIMAGEBACKTYPE canBackPageNumber:2];
    }else if ([notification is:[MagicUIKeyboard HEIGHT_CHANGED]]){
        if (_btnSelEmoji.selected == YES) {
            [self sendViewSignal:[DYBPublishViewController SELECTEMOJI]];
        }
    }
}

#pragma mark - 返回用户关于动态位置信息的状态
-(NSString *)GetLocationPrivateStatus{
    // SignPrivacy key: 0,不公开；1, 公开；
    NSString *strPrivacy = [[NSUserDefaults standardUserDefaults] stringForKey:@"LocationPrivacy"];
    if ([strPrivacy length] == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"LocationPrivacy"];
        strPrivacy = [[NSUserDefaults standardUserDefaults] stringForKey:@"LocationPrivacy"];
    }
    
    return strPrivacy;
}

#pragma mark - 返回用户关于动态信息的状态
-(NSString *)GetDynamicPrivateStatus{
    // SignPrivacy key: 0,公开；2, 好友， 4班级；
    NSString *strPrivacy = [[NSUserDefaults standardUserDefaults] stringForKey:@"DynamicPrivacy"];
    if ([strPrivacy length] == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"DynamicPrivacy"];
        strPrivacy = [[NSUserDefaults standardUserDefaults] stringForKey:@"DynamicPrivacy"];
    }
    
    return strPrivacy;
}


-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        NSDictionary *dicType = (NSDictionary *)[signal object];
        NSString *strType = [dicType objectForKey:@"type"];
        int row = [[dicType objectForKey:@"rowNum"] intValue];
        
        if (row == 1) {
            [self.drNavigationController popVCAnimated:YES];
            [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
        }else if ([strType intValue] == BTNTAG_DEL){
            [self DYB_DelSNSSync:_sync_btn];
        }
    }
}


- (void)DYB_DelSNSSync:(NSInteger)nType{
    MagicRequest *request = [DYBHttpMethod user_delsync_m:[NSString stringWithFormat:@"%d",nType] isAlert:YES receive:self];
    if (nType == 2) {
        request.tag = -3;
    }else{
        request.tag = -4;
    }
    
}


#pragma mark- 接受其他信号
- (void)handleViewSignal_DYBPublishViewController:(MagicViewSignal *)signal
{
    [self hideKeyBoard];
    
    if ([signal is:[DYBPublishViewController SELFLOCATION]]){
        _btnLocation.selected = !_btnLocation.selected;
        
        if (_btnLocation.selected == YES) {
             [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"LocationPrivacy"];
        }else{
             [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"LocationPrivacy"];
        }
    }else if ([signal is:[DYBPublishViewController DYNAMICPRIVATE]]){
        
        if(!_menuPrivate){            
            _menuPrivate = [[DYBMenuBLueView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_btnPrivate.frame) , CGRectGetMaxY(_btnPrivate.frame), 0, 0) menuArray:_arrMenu selectRow:1 cellType:0];
            [self.view addSubview:_menuPrivate];
            RELEASE(_menuPrivate);
        }
        
        if (_btnPrivate.selected  == NO) {
            [_menuPrivate setFrame:CGRectMake(CGRectGetMinX(_btnPrivate.frame) , CGRectGetMinY(_btnPrivate.frame), 140, 45)];
            [self.view bringSubviewToFront:_btnPrivate];
            
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.5f];
            [self.view bringSubviewToFront:_btnPrivate];
            [_menuPrivate setFrame:CGRectMake(CGRectGetMinX(_btnPrivate.frame) , CGRectGetMinY(_btnPrivate.frame), 140, [_arrMenu count]*45+10)];
            [UIView commitAnimations];
            
            _btnPrivate.selected = YES;
        }else{
            [_menuPrivate setFrame:CGRectMake(CGRectGetMinX(_btnPrivate.frame) , CGRectGetMinY(_btnPrivate.frame), 140, [_arrMenu count]*45+10)];
            [self.view bringSubviewToFront:_btnPrivate];
            
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.5f];
            [self.view bringSubviewToFront:_btnPrivate];
            [_menuPrivate setFrame:CGRectMake(CGRectGetMinX(_btnPrivate.frame) , CGRectGetMinY(_btnPrivate.frame), 140, 45)];
            [UIView commitAnimations];
            
            _btnPrivate.selected = NO;
        }

    }else if ([signal is:[DYBPublishViewController SHARERENREN]]){             
        if (_btnShareRenRen.selected == NO){
            DYBSNSSyncViewController *vc = [[DYBSNSSyncViewController alloc] init:2];
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
            
        }else{
            _sync_btn = 4;
            [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"确定要解除与人人网的绑定？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
        }
        
    }else if ([signal is:[DYBPublishViewController SHARETENCENT]]){
        if (_btnShareTencent.selected == NO){
            DYBSNSSyncViewController *vc = [[DYBSNSSyncViewController alloc] init:1];
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
            
        }else{
            _sync_btn = 2;
            [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"确定要解除与腾讯微博的绑定？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
        }
    }else if ([signal is:[DYBPublishViewController SYNCRESULT]]){
        NSDictionary *dicResult = (NSDictionary *)[signal object];
        
        if ([[dicResult objectForKey:@"result"] isEqualToString:@"1"]) {
            if ([[dicResult objectForKey:@"type"] isEqualToString:@"1"]) {
                _btnShareTencent.selected = YES;
                _sync_tag = _sync_tag+2;
            }else if ([[dicResult objectForKey:@"type"] isEqualToString:@"2"]){
                _btnShareRenRen.selected = YES;
                _sync_tag = _sync_tag+4;
            }
        }else{
            if ([[dicResult objectForKey:@"type"] isEqualToString:@"1"]) {
                _btnShareTencent.selected = NO;
            }else if ([[dicResult objectForKey:@"type"] isEqualToString:@"2"]){
                _btnShareRenRen.selected = NO;
            }
        }
        
    }else if ([signal is:[DYBPublishViewController PRIVATESELECT]]){
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSNumber *nRow = [dict objectForKey:@"row"];
        
        switch ([nRow intValue]) {
            case 1:
                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"DynamicPrivacy"];
                break;
            case 2:
                [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"DynamicPrivacy"];
                break;
            case 3:
                [[NSUserDefaults standardUserDefaults] setValue:@"4" forKey:@"DynamicPrivacy"];
                break;
            default:
                break;
        }
        
        [_btnPrivate setTitle:[_arrMenu objectAtIndex:[nRow intValue]] forState:UIControlStateNormal];
        [self sendViewSignal:[DYBPublishViewController DYNAMICPRIVATE]];
    }else if ([signal is:[DYBPublishViewController SELECTIMAGE]]){
        UIActionSheet *actionView = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"立刻拍照" otherButtonTitles:@"相册选择", nil];
        [actionView showInView:self.view];
        RELEASE(actionView);
        
    }else if ([signal is:[DYBPublishViewController SHOWIMAGE]]){
        MagicUIButton *bt = (MagicUIButton *)signal.source;
        
        int nindex = (bt.frame.origin.x-7)/57;
        
        DYBCheckImageViewController *vc = [[DYBCheckImageViewController alloc] initWithImage:[_arrSelPic objectAtIndex:nindex]];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBPublishViewController DELETEMAGE]]){
        UIImage *img = (UIImage *)[signal object];
        [_arrSelPic removeObject:img];
        
        for (MagicUIButton *btn in [_viewPicBKG subviews]) {
            if ([btn isKindOfClass:[MagicUIButton class]] && btn != _btnSelImage) {
                [btn removeFromSuperview];
            }
        }

        for (int i = 0; i < [_arrSelPic count]; i++) {
            UIImage *imgSel = (UIImage *)[_arrSelPic objectAtIndex:i];
            MagicUIButton *btnPic = [[MagicUIButton alloc] initWithFrame:CGRectMake(7+i*57, 7, 50, 50)];
            [btnPic setBackgroundColor:[UIColor clearColor]];
            [btnPic setImage:imgSel forState:UIControlStateNormal];
            [btnPic setContentMode:UIViewContentModeScaleToFill];
            [btnPic addSignal:[DYBPublishViewController SHOWIMAGE] forControlEvents:UIControlEventTouchUpInside];
            [_viewPicBKG addSubview:btnPic];
            RELEASE(btnPic);
        }
        
        [_btnSelImage setHidden:NO];
        [_btnSelImage setFrame:CGRectMake(6+57*[_arrSelPic count], 7, 50, 50)];
        
        if ([_arrSelPic count] == 5) {
            [_viewPicBKG setScrollEnabled:YES];
            [_viewPicBKG setContentOffset:CGPointMake(64, 0) animated:YES];
        }else if ([_arrSelPic count] < 5){
            [_viewPicBKG setScrollEnabled:NO];
            [_viewPicBKG setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }else if ([signal is:[DYBPublishViewController SELECTEMOJI]]){
        DLogInfo(@"emoji");
        
        if (!_viewFace) {
            _viewFace = [[DYBFaceView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), 320, 200)];
            _viewFace.delegate = self;
            [self.view addSubview:_viewFace];
            RELEASE(_viewFace);
            
            UIImage *imgShadowLine = [UIImage imageNamed:@"line_padshadow"];
            MagicUIImageView *viewShadowLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, -3, imgShadowLine.size.width/2, imgShadowLine.size.height/2)];
            [viewShadowLine setImage:imgShadowLine];
            [viewShadowLine setBackgroundColor:[UIColor clearColor]];
            [_viewFace addSubview:viewShadowLine];
            RELEASE(viewShadowLine);
        }
        
        if (_btnSelEmoji.selected == NO) {
            [self hideKeyBoard];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.25f];
            [_viewFace setFrame:CGRectMake(0, self.view.frame.size.height-215, 320, 200)];
            [UIView commitAnimations];
        }else{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.25f];
            [_viewFace setFrame:CGRectMake(0, self.view.frame.size.height, 320, 200)];
            [UIView commitAnimations];
        }
        _btnSelEmoji.selected = !_btnSelEmoji.selected;

    }else if ([signal is:[DYBPublishViewController SELECTAT]]){
        DLogInfo(@"AT");
        
        DYBATViewController *vc = [[DYBATViewController alloc] init];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBPublishViewController SELECTATLIST]]){
        NSArray *_arrATList = (NSArray *)[signal object];
        DLogInfo(@"list:%@", _arrATList);
        
        NSString *ATname = @"";
        for (NSString *name  in _arrATList) {
            NSString *at = [NSString stringWithFormat:@"@%@ ",name];
            ATname = [ATname stringByAppendingString:at];
        }
        
        NSString *beforeString = [self beforeString:_txtViewPublish subString:ATname];
        _txtViewPublish.text = [self subStringOperat:_txtViewPublish subString:ATname beforeString:beforeString] ;
        
        
        [_textCount setText:[NSString stringWithFormat:@"%d/140", [_txtViewPublish.text length]]];
        
        if ([_txtViewPublish.text length] >= 140) {
            NSRange range = [_textCount.text rangeOfString:@"/"];
            _textCount.COLOR(@"0", [NSString stringWithFormat:@"%d", (int)range.location], [UIColor redColor]);
            _bOverSize = YES;
        }else{
            _bOverSize = NO;
        }
        //光标位置
        
        NSRange range = [_txtViewPublish.text rangeOfString:beforeString];
        NSRange ragne1 = NSMakeRange(range.location+beforeString.length, 0);
        _txtViewPublish.selectedRange = ragne1;
        
        [_txtViewPublish sendViewSignal:[MagicUITextView TEXTVIEWDIDCHANGE]];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self hideKeyBoard];
    switch (buttonIndex) {
        case 0:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.drNavigationController presentModalViewController:imagePicker animated:YES];
                RELEASE(imagePicker);
            }
            break;
        case 1:{
            
            DYBImagePickerController *_imgPicker = [[DYBImagePickerController alloc] init];
            [_imgPicker setFather:self];
            _imgPicker.delegate = self;
            _imgPicker.allowsMultipleSelection = YES;//是否是多图上传
            _imgPicker.limitsMaximumNumberOfSelection = YES;// 最大图片数量
            _imgPicker.maximumNumberOfSelection = 6 - [_arrSelPic count];
            [self.drNavigationController pushViewController:_imgPicker animated:YES];
            RELEASE(_imgPicker);
        }
            break;
    }
}

-(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark 图片选择回调
- (void)imagePickerController:(DYBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if([imagePickerController isKindOfClass:[DYBImagePickerController class]]){
        
        if(imagePickerController.allowsMultipleSelection) {
            NSArray *mediaInfoArray = (NSArray *)info;
            
            for (int i = 0; i < [mediaInfoArray count]; i++) {
                NSDictionary *dic = [mediaInfoArray objectAtIndex:i];
                UIImage *img = (UIImage *)[dic objectForKey:@"UIImagePickerControllerOriginalImage"];
                
                if (![_arrSelPic containsObject:img]) {
                    [_arrSelPic addObject:img];
                }
                
                UIImage *imgScale = [self scaleToSize:img size:CGSizeMake(50, 50)];
                NSData *imageData = UIImageJPEGRepresentation(imgScale, 0.5);
                
                if ([_arrSelPic count] < 7) {
                    int nIndex = [_arrSelPic count] -1;
                    MagicUIButton *btnPic = [[MagicUIButton alloc] initWithFrame:CGRectMake(7+nIndex*57, 7, 50, 50)];
                    [btnPic setBackgroundColor:[UIColor clearColor]];
                    [btnPic setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                    [btnPic setContentMode:UIViewContentModeScaleToFill];
                    [btnPic addSignal:[DYBPublishViewController SHOWIMAGE] forControlEvents:UIControlEventTouchUpInside];
                    [_viewPicBKG addSubview:btnPic];
                    RELEASE(btnPic);
                }
                
                [_btnSelImage setFrame:CGRectMake(6+57*[_arrSelPic count], 7, 50, 50)];
            }
            
            int nCount = [_arrSelPic count];
            
            if (nCount >= 6) {
                [_btnSelImage setHidden:YES];
                [_viewPicBKG setScrollEnabled:YES];
                [_viewPicBKG setContentOffset:CGPointMake(64, 0) animated:YES];
            }else if (nCount == 5){
                [_viewPicBKG setScrollEnabled:YES];
                [_viewPicBKG setContentOffset:CGPointMake(64, 0) animated:YES];
            }
            
            if (nCount == 0){
                [self.rightButton setEnabled:NO];
            }else{
                [self.rightButton setEnabled:YES];
            }
        }
        
    }else if ([imagePickerController isKindOfClass:[UIImagePickerController class]]){
        
        _photoEditor = [[DYBPhotoEditorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.bounds.size.height)];
        _photoEditor.ntype = 1;
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
        if (((UIImagePickerController *)imagePickerController).sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将拍到的图片保存到相册
        }
        
        if ((((UIImagePickerController *)imagePickerController).sourceType == UIImagePickerControllerSourceTypeCamera)) {
            [self manageImage:image];
            
        }
        
        [_photoEditor.imgRootView setCenter:CGPointMake(160.0f,self.view.bounds.size.height/2-25)];
        
        _photoEditor.imgRootView.image = _photoEditor.curImage;
        [self.view addSubview:_photoEditor];
        [self dismissModalViewControllerAnimated:YES];
        RELEASE(_photoEditor);
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)manageImage:(UIImage*)image{
    
    float ratX = image.size.width/320;
    float ratY = image.size.height/self.view.bounds.size.height;
    
    if (ratX>ratY) {
        [_photoEditor.imgRootView setFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, image.size.height*320/image.size.width)];
        UIImage *smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(self.view.bounds.size.width*2, image.size.height*320/image.size.width*2) interpolationQuality:kCGInterpolationDefault];
        _photoEditor.curImage = smallImage;
        
    }else{
        [_photoEditor.imgRootView setFrame:CGRectMake(0.0f, 0.0f, image.size.width*self.view.bounds.size.height/image.size.height, self.view.bounds.size.height)];
        UIImage *smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(image.size.width*self.view.bounds.size.height/image.size.height*2, self.view.bounds.size.height*2) interpolationQuality:kCGInterpolationDefault];
        _photoEditor.curImage = smallImage;
        
    }
    
    _photoEditor.imgRootView.contentMode = UIViewContentModeScaleAspectFit;

}

//隐藏键盘
-(void)hideKeyBoard{
    [_txtViewPublish resignFirstResponder];
}

#pragma mark- 只接受UITextView信号
- (void)handleViewSignal_MagicUITextView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITextView TEXTVIEWSHOULDBEGINEDITING]])/*textViewShouldBeginEditing*/{
        
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDBEGINEDITING]])/*textViewDidBeginEditing*/{
        
    }else  if ([signal is:[MagicUITextView TEXT_OVERFLOW]])/*文字超长*/{

    }else  if ([signal is:[MagicUITextView TEXTVIEW]])/*shouldChangeTextInRange*/{
        NSMutableDictionary *muD = (NSMutableDictionary *)[signal object];
        
        [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(changeLabelColor) userInfo:nil repeats:NO];
        NSString *emString=[muD objectForKey:@"text"];
        if ([emString isEqualToString:@"\n"]) {
            [signal returnNO];
            [self hideKeyBoard];
        }
        
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDCHANGE]])/*textViewDidChange*/{
        NSString *_strContent = [self convertSystemEmoji:_txtViewPublish.text];
        _strContent = [_strContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [_textCount setText:[NSString stringWithFormat:@"%d/140", [_strContent length]]];
        self.rightButton.enabled = YES;

        [self changeLabelColor];
        
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDCHANGESELECTION]])/*textViewDidChangeSelection*/{
    }else  if ([signal is:[MagicUITextView TEXTVIEWSHOULDENDEDITING]])/*textViewShouldEndEditing*/{
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDENDEDITING]])/*textViewDidEndEditing*/{
    }
}

- (void)changeLabelColor
{
    NSString *_strContent = [self convertSystemEmoji:_txtViewPublish.text];
    _strContent = [_strContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([_strContent length] > 140) {
        NSRange range = [_textCount.text rangeOfString:@"/"];
        _textCount.COLOR(@"0", [NSString stringWithFormat:@"%d", (int)range.location], [UIColor redColor]);
        _bOverSize = YES;
    }else if ([_strContent length] == 0){
        
        if ([_arrSelPic count] == 0) {
            self.rightButton.enabled = NO;
        }
        
        NSRange range = [_textCount.text rangeOfString:@"/"];
        _textCount.COLOR(@"0", [NSString stringWithFormat:@"%d", (int)range.location], ColorTextCount);
    }else{
        _bOverSize = NO;
        NSRange range = [_textCount.text rangeOfString:@"/"];
        _textCount.COLOR(@"0", [NSString stringWithFormat:@"%d", (int)range.location], ColorTextCount);
    }
}

#pragma mark - 表情功能
-(void)selectFace:(id)sender{
    UIButton *tempbtn = (UIButton *)sender;
    NSMutableDictionary *tempdic = [_viewFace.faces objectAtIndex:tempbtn.tag];
    NSArray *temparray = [tempdic allKeys];
    NSString *faceStr= [NSString stringWithFormat:@"%@",[temparray objectAtIndex:0]];
    NSArray *arrayTemp = [faceStr componentsSeparatedByString:@"/"];
    NSString *tempStr = [[[arrayTemp objectAtIndex:1] componentsSeparatedByString:@"]"] objectAtIndex:0];
    NSString *last = [[self getFaceCode] objectForKey:tempStr];    
    
    NSString *beforeString = [self beforeString:_txtViewPublish subString:last];
    _txtViewPublish.text = [self subStringOperat:_txtViewPublish subString:last beforeString:beforeString] ;
    
    //光标位置
    NSRange range = [_txtViewPublish.text rangeOfString:beforeString];
    NSRange ragne1 = NSMakeRange(range.location+beforeString.length, 0);
   _txtViewPublish.selectedRange = ragne1;
    
    [self sendViewSignal:[MagicUITextView TEXTVIEWDIDCHANGE]];
}

//操作字符串
-(NSString* )subStringOperat:(UITextView *)textView subString:(NSString*)string beforeString:(NSString *)beforeString{
    NSUInteger location = textView.selectedRange.location;
    
    if (textView.text.length == 0)
    {
        location = 0;
    }

    NSString *afterSacn = [textView.text substringFromIndex:location];
    if (afterSacn.length > 0) {
        afterSacn = [beforeString stringByAppendingString:afterSacn];
    }else{    
        afterSacn = beforeString;        
    }
    
    return afterSacn;
}

-(void)face_end{
//    bONface = NO;
    [_viewFace setFrame:CGRectMake(0, 600, 320, 200)];
}

-(NSDictionary*)getFaceCode{
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"]];
    return dic ;
}

-(NSString* )beforeString:(UITextView* )textView subString :(NSString *)string{
    NSUInteger location = textView.selectedRange.location;
    
    if (textView.text.length == 0)
    {
        location = 0;
    }
    
    NSString*  beforeString = [textView.text substringToIndex:location];
    if (beforeString.length > 0) {
        beforeString = [beforeString stringByAppendingString:string];
    }else{
        beforeString = string;
    }
    
    return beforeString;
}
@end
