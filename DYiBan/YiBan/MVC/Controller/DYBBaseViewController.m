//
//  DYBBaseViewController.m
//  DYiBan
//
//  Created by NewM on 13-8-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "Magic_Device.h"
#import "UserSettingMode.h"

@interface DYBBaseViewController ()
{
}
@end

@implementation DYBBaseViewController
@synthesize leftButton = _leftButton,headview = _headview,rightButton = _rightButton;
@synthesize baseView = _baseView;
@synthesize vc = _vc;
@synthesize tbv = _tbv;
@synthesize headViewHeight = _headViewHeight;

@synthesize headHeight, frameHeight, frameY;

DEF_SIGNAL(BACKBUTTON);
DEF_SIGNAL(NEXTSTEPBUTTON)
DEF_SIGNAL(NoInternetConnection)//无网

- (float)headViewHeight
{
    float h = CGRectGetHeight(_headview.frame);
    if ([MagicDevice sysVersion] >= 7)
    {
        h -= 20;
    }
    return h;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    CGSize mainSize = MAINSIZE;
//    UIView *barColorView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, mainSize.width, 20)];
////    [barColorView setBackgroundColor:[MagicCommentMethod colorWithHex:@"f8f8f8"]];
//    [barColorView setBackgroundColor:[UIColor yellowColor]];
//    [self.view addSubview:barColorView];
//    RELEASE(barColorView);
    
    _headview = [[DYBNaviView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    float y = 0;
    if ([MagicDevice sysVersion] >= 7)
    {
        y = 20;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= IOS_7        
//        self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    }
    
    _leftButton = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, y, 60, self.headViewHeight)];
    
    //临时
    _rightButton = [[MagicUIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, y, 60,  self.headViewHeight)];
    [_rightButton addSignal:[DYBBaseViewController NEXTSTEPBUTTON] forControlEvents:UIControlEventTouchUpInside];
    
//    [_headview setTitle:@"登陆"];
    [_leftButton setImage:[UIImage imageNamed:@"btn_mainmenu_default.png"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"btn_mainmenu_hilight.png"] forState:UIControlStateHighlighted];
    [_leftButton addSignal:[DYBBaseViewController BACKBUTTON] forControlEvents:UIControlEventTouchUpInside];
    
    [_headview setLeftView:_leftButton];
    [_headview setLeftView:_rightButton];
    
    RELEASE(_leftButton);
    RELEASE(_rightButton);
    
    [self.view addSubview:_headview];

    RELEASE(_headview);
    
    [self setVCBackAnimation:SWIPELASTIMAGEBACKTYPE canBackPageNumber:2];

    [self observeNotification:[DYBBaseViewController NoInternetConnection]];
    
    if ([MagicDevice sysVersion] >= 7)
    {
        [self.view setFrame:CGRectMake(CGRectGetMinX(self.view.frame),20 , 320.0f, CGRectGetHeight(self.view.frame))];
        
//       self.view.frame.origin.y = 20.0f;
    }
}

- (DYBBaseView *)baseView
{
    if (!_baseView)
    {
        _baseView = [[DYBBaseView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_baseView];
        
        RELEASE(_baseView);
    }
    return _baseView;
}

//适配ios7 偏移
- (float)getOffset {
    
    float y = 0;
    if ([MagicDevice sysVersion] >= 7)
    {
        y = 20;
    }
    return y;
}

//根据不同页面自动变换BT的样式
- (void)backImgType:(int)type
{
    switch (type)
    {
        case 0://返回按钮
        {
            [_leftButton setImage:[UIImage imageNamed:@"btn_back_def.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"btn_back_hlt.png"] forState:UIControlStateHighlighted];
//            [_leftButton setImageEdgeInsets:UIEdgeInsetsMake(10,15,10,15)];//BT上的图片相对于frame的位置
        }
            break;
        case 1://返回按钮
        {
            [self setButtonImage:self.leftButton setImage:@"btn_back_def"];
            [self setButtonImage:self.rightButton setImage:@"btn_ok_def"];
        }
            break;
        case 2://签到按钮
        {
            [_rightButton setImage:[UIImage imageNamed:@"btn_locate_def.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"btn_locate_high.png"] forState:UIControlStateHighlighted];
        }
            break;
        case 3://签到确认按钮
        {
            [_rightButton setImage:[UIImage imageNamed:@"btn_ok_def.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"btn_ok_dis.png"] forState:UIControlStateDisabled];
            [_rightButton setImage:[UIImage imageNamed:@"btn_ok_high.png"] forState:UIControlStateHighlighted];
        }
            break;
        case 4://个人主页在一级页面时的返回按钮
        {
            [_leftButton setImage:[UIImage imageNamed:@"grzy_1.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"grzy_1.png"] forState:UIControlStateHighlighted];
            _leftButton.showsTouchWhenHighlighted=YES;

        }
            break;
        case 5://发动态页面跳转按钮
        {
            [_rightButton setImage:[UIImage imageNamed:@"btn_write_def.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"btn_write_hlt.png"] forState:UIControlStateHighlighted];
        }
            break;
        case 6://发送动态按钮
        {
            [_rightButton setImage:[UIImage imageNamed:@"btn_send_normal.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"btn_send_highlight.png"] forState:UIControlStateHighlighted];
            [_rightButton setImage:[UIImage imageNamed:@"btn_send_dis.png"] forState:UIControlStateDisabled];
        }
            break;
        case 7://查看大图等导航条是透明的返回按钮
        {
            [_leftButton setImage:[UIImage imageNamed:@"back_white_def.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"back_white_hlt.png"] forState:UIControlStateHighlighted];
        }
            break;
        case 8://查看大图等导航条是透明的返回按钮
        {
            [_rightButton setImage:[UIImage imageNamed:@"btn_del_def.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"btn_del_hlt.png"] forState:UIControlStateHighlighted];
        }
            break;
        case 9://右侧更多功能
        {
            [_rightButton setImage:[UIImage imageNamed:@"btn_more_def.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"btn_more_hlt.png"] forState:UIControlStateHighlighted];
        }
            break;
        case 10://个人主页在2级页面时的返回按钮
        {
            [_leftButton setImage:[UIImage imageNamed:@"person_back_def.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"person_back_def.png"] forState:UIControlStateHighlighted];
            _leftButton.showsTouchWhenHighlighted=YES;
            
        }
            break;
        case 11:{
            [_rightButton setImage:[UIImage imageNamed:@"btn_savetolocal_def.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"btn_savetolocal_hlt.png"] forState:UIControlStateHighlighted];
        }
            break;
        case 12:{//加号
            [_rightButton setImage:[UIImage imageNamed:@"btn_addtag_def.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"btn_addtag_press.png"] forState:UIControlStateHighlighted];         
            [_rightButton setFrame:CGRectMake(275, CGRectGetMinY(_rightButton.frame), 45, CGRectGetHeight(_rightButton.frame))];
        }
            break;
        case 13:{//加号
            [_rightButton setImage:[UIImage imageNamed:@"btn_tagadd_def.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"btn_tagadd_press.png"] forState:UIControlStateHighlighted];
        }
            break;
        default:
            break;
    }
}


- (void)setButtonImage:(MagicUIButton *)button setImage:(NSString *)string {
    
    [button setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:string] forState:UIControlStateHighlighted];
}

- (void)setButtonImage:(MagicUIButton *)button setImage:(NSString *)string  setHighString:(NSString *)hight{
    
    [button setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hight] forState:UIControlStateHighlighted];
}


- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        
    }

}

//textFeild 属性 输入框 默认字符 颜色 所属类
- (void)setTextFeild:(MagicUITextField *)textFeild setPlaceholder:(NSString *)placeholder setColor:(UIColor *)color setControl:(UIViewController *)control {
    
    textFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textFeild setReturnKeyType:UIReturnKeyDone];
    [textFeild setPlaceholder:placeholder];
    [textFeild setBackgroundColor:color];
    [control.view addSubview:textFeild];
    RELEASE(textFeild);
}

//btn 属性 按钮 名称 信号 颜色 所属类
- (void)setMagicUIButton:(MagicUIButton *)btn setImageNorm:(UIImage *)ImageNorm setImageHigh:(UIImage *)ImageHigh signal:(NSString *)signal setControl:(UIViewController *)control {
    
    [btn setBackgroundImage:ImageNorm forState:UIControlStateNormal];
    [btn setBackgroundImage:ImageHigh forState:UIControlStateHighlighted];
//    [btn addSignal:signal forControlEvents:UIControlEventTouchUpInside];
    [btn addSignal:signal forControlEvents:UIControlEventTouchUpInside object:btn];
    [control.view addSubview:btn];
    RELEASE(btn);
}

//键盘上升
- (void) animateTextField:(UIView *)view up:(BOOL)yesOn getContrl:(UIViewController *)control
{
    int animatedDistance;
    int moveUpValue = 319;//临时固定值
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = 216-(SCREEN_HEIGHT-moveUpValue);
    }
    else
    {
        animatedDistance = 162-(320-moveUpValue-5);
    }
    
    if(animatedDistance>0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f;
        int movement = (yesOn ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        control.view.frame = CGRectOffset(control.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

//获得vc的去处header的Y轴
- (CGFloat)frameY
{
    CGSize mainSize = MAINSIZE;
    return (mainSize.height - self.headHeight);
}

//获得vc的view的高度
- (CGFloat)frameHeight
{
    CGSize mainSize = MAINSIZE;
    float height = mainSize.height;
    /*if ([MagicDevice sysVersion] >= 7)
    {
        height += 20;
    }*/
    return height;
}

//获得vc的header的高度
- (float)headHeight
{
    float screenY = 44;
    if ([MagicDevice sysVersion] >= 7)
    {
        screenY += 20;
    }
    
    return screenY;
}

- (MagicNavigationController *)drNavigationController
{
    if (![super drNavigationController]) {
        return _vc.drNavigationController;
    }
    
    return [super drNavigationController];
}

#pragma mark- 接收 通知中心
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification is:[DYBBaseViewController NoInternetConnection]]){//没网通知
        
        [_tbv reloadData:YES];
        [self.view setUserInteractionEnabled:YES];
        
    }

}

#pragma mark- 图片压缩＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//获得图片质量
- (NSInteger)getTYPE{
    UserSettingMode *userDic =  SHARED.currentUserSetting;
    NSString *imgType = userDic.upSendImgType;
    NSString *type = imgType;
    if ([type isEqualToString:@"自动"]) {
        return 0;
    }else if([type isEqualToString:@"高"]){
        return 3;
    }else if([type isEqualToString:@"中"])
    {
        return  2;
        
    }else{//低
        
        return 1;
    }
}

- (NSData *)zipImg:(UIImage *)image{
    
    NSInteger type = [self getTYPE];
    
    NSData *data = nil;
    
    int qu = type;
    if (qu == 0)//图片质量自动
    {
        if ([[MagicDevice networkType] isEqualToString:@"wifi"])
        {
            qu = 3;//wifi
        }
        else
        {
            qu = 2;//3g
        }
    }
    if (qu == 3 && image.size.width*image.size.height >= 320*480) {//高
        
         data = UIImageJPEGRepresentation(image, 0.9);
//        data= [self CompressPicturesMoreThanKB:1000 Img:image imgData:[self UIImageToNSData:image compressionQuality:1]];
        
    } else if(qu == 2 && (image.size.width*image.size.height)/0.49 >= 320*480)//中
    {
        data = UIImageJPEGRepresentation(image, 0.8);
//        data= [self CompressPicturesMoreThanKB:400 Img:image imgData:[self UIImageToNSData:image compressionQuality:1]];
        
    } else if(qu == 1 && (image.size.width*image.size.height)/0.25 >= 320*480)//图片质量低
    {
        data = UIImageJPEGRepresentation(image, 0.7);
//        data= [self CompressPicturesMoreThanKB:100 Img:image imgData:[self UIImageToNSData:image compressionQuality:1]];
        
    }
    else {//自动
        data = UIImageJPEGRepresentation(image, 1.0);
        
    }
    
    if (qu!=3&&qu!=2) {
        NSInteger willDe = 0;
        for (int i = 8; i > 0; i--) {
            if (data.length/i <= 1000000) {//1000k
                willDe = i;
                break;
            }
        }
        
        if (data.length > 1000000) {
            float s = (CGFloat)(willDe/10);
            data = UIImageJPEGRepresentation(image, s);
        }
    }
    
    
    return data;
}


#pragma mark-把大于多少K的图片压缩
- (NSData *)CompressPicturesMoreThanKB:(CGFloat)k Img:(UIImage *)img imgData:(NSData *)imgData
{
    NSUInteger sizeOrigin = [imgData length];
    
    /*NSUInteger*/ CGFloat sizesizeOriginKB = (CGFloat)(sizeOrigin / 1024.f);
    if (sizesizeOriginKB > k) {
        float a = k;
        float  b = (float)sizesizeOriginKB;
        float q = sqrt(a/b);
        CGSize sizeImage = [img size];
        CGFloat iwidthSmall = sizeImage.width * q;
        CGFloat iheightSmall = sizeImage.height * q;
        CGSize itemSizeSmall = CGSizeMake(iwidthSmall, iheightSmall);
        UIGraphicsBeginImageContext(itemSizeSmall);
        CGRect imageRectSmall = CGRectMake(0.0f, 0.0f, (NSUInteger)itemSizeSmall.width+1, (NSUInteger)itemSizeSmall.height+1);
        [img drawInRect:imageRectSmall];
        UIImage *SmallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *dataImageSend = UIImageJPEGRepresentation(SmallImage, 1.0);
        imgData = dataImageSend;
    }
    return imgData;
}


#pragma mark-把UIImage转化压缩成NSData
- (NSData *)UIImageToNSData:(UIImage *)img compressionQuality:(CGFloat)compressionQuality/*传-1表示返回png;压缩系数,一般为1.0,如果对图片的清晰度要求不高,可减小压缩系数,从而大福降低图片数据量,此函数本身就比UIImagePNGRepresentation函数得到的图片数据量低*/
{
    return (compressionQuality!=-1)?(UIImageJPEGRepresentation(img, compressionQuality)):(UIImagePNGRepresentation(img));
}

@end
