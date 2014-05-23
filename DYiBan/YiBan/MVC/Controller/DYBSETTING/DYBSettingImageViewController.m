//
//  DYBSettingImageViewController.m
//  DYiBan
//
//  Created by Song on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSettingImageViewController.h"
#import "DYBSetButton.h"
#import "UserSettingMode.h"
@interface DYBSettingImageViewController () {
    
    MagicUIButton *btnSelect;
    MagicUIImageView *imv_radio;
}

@end

@implementation DYBSettingImageViewController
DEF_SIGNAL(SETIMAGEBUTTON) //设置图片消息
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"图片设置"];
        [self backImgType:0];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        
        
        
        NSArray *textArray = [[NSArray alloc]initWithObjects:@"上传图片质量",@"自动",@"高",@"中",@"低", nil];
        DYBSetButton *settingButton[[textArray count]];
        
        //选择按钮图片质量radio_off
        UIImage *imageRadio = [UIImage imageNamed:@"radio_off"];
        UIImage *image = [UIImage imageNamed:@"radio_on"];
        btnSelect = [[MagicUIButton alloc] initWithFrame:CGRectMake(10,(BUTTONHEIGHT-image.size.height/2)/2, image.size.width/2, image.size.height/2)];
        [btnSelect setImage:image forState:UIControlStateNormal];
        
        for (int i = 0; i < [textArray count]; i++) {
            
            settingButton[i] = [[DYBSetButton alloc]initWithFrame:CGRectMake(OFFSETFROM, OFFSETFROM+self.headHeight+(BUTTONHEIGHT-1)*i, BUTTONWIDTH, BUTTONHEIGHT) labelText:[textArray objectAtIndex:i] isArrow:YES type:1];
            
            if (i > 0) {
                [settingButton[i] addSignal:[DYBSettingImageViewController SETIMAGEBUTTON] forControlEvents:UIControlEventTouchUpInside];
                settingButton[i].tag = i;
                [settingButton[i].textLabel setFrame:CGRectMake(40, 5, BUTTONWIDTH-40, BUTTONHEIGHT-10)];
                
                imv_radio = [[MagicUIImageView alloc]initWithFrame:CGRectMake(10, (BUTTONHEIGHT-imageRadio.size.height/2)/2, imageRadio.size.width/2, imageRadio.size.height/2)];
                [imv_radio setImage:imageRadio];
                [settingButton[i] addSubview:imv_radio];
                RELEASE(imv_radio);
                
                
            }else {
                settingButton[i].layer.borderWidth = 0;
                settingButton[i].backgroundColor = [UIColor whiteColor];
            }
            [self.view addSubview:settingButton[i]];
            RELEASE(settingButton[i]);
            
        }
        
        MagicUILabel *highlabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(60, 6, BUTTONWIDTH-35, BUTTONHEIGHT-10)];
        [self setLabel:highlabel setText:@"(建议wifi或3G环境下使用)" setButton:settingButton[2]];
        
        MagicUILabel *lowlabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(60, 6, BUTTONWIDTH-35, BUTTONHEIGHT-10)];
        [self setLabel:lowlabel setText:@"(省流量 上传更快)" setButton:settingButton[4]];
        
        
        
        if ([SHARED.currentUserSetting.upSendImgType isEqualToString: @"自动"]) {
            [settingButton[1] addSubview:btnSelect];
        }else if ([SHARED.currentUserSetting.upSendImgType isEqualToString: @"高"]) {
            [settingButton[2] addSubview:btnSelect];
        }else if ([SHARED.currentUserSetting.upSendImgType isEqualToString: @"中"]) {
            [settingButton[3] addSubview:btnSelect];
        }else if ([SHARED.currentUserSetting.upSendImgType isEqualToString: @"低"]) {
            [settingButton[4] addSubview:btnSelect];
        }else {
            [settingButton[1] addSubview:btnSelect];
        }
        
        
        
    }
}

//添加label
- (void)setLabel:(MagicUILabel *)label setText:(NSString *)string setButton:(DYBSetButton *)btn{
    
    label.textAlignment = UIControlContentVerticalAlignmentCenter;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [DYBShareinstaceDelegate DYBFoutStyle:18];  //字体和大小设置
    label.text = string;
    label.textColor = [MagicCommentMethod colorWithHex:@"333333"];
    label.backgroundColor = [UIColor clearColor];
    [btn addSubview:label];
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
        //        DYBRegisterStep2ViewController *vc = [[DYBRegisterStep2ViewController alloc] init];
        //        [self.drNavigationController pushViewController:vc animated:YES];
        //        RELEASE(vc);
        
    }
    
}


#pragma mark- 按钮点击
- (void)handleViewSignal_DYBSettingImageViewController:(MagicViewSignal *)signal
{
    MagicUIButton *btn = signal.source;
    
    if ([signal is:[DYBSettingImageViewController SETIMAGEBUTTON]])
    {
        
        [btn addSubview:btnSelect];
        if (btn.tag == 1) {
            SHARED.currentUserSetting.upSendImgType = @"自动";
        }
        if (btn.tag == 2) {
            SHARED.currentUserSetting.upSendImgType = @"高";
        }
        if (btn.tag == 3) {
            SHARED.currentUserSetting.upSendImgType = @"中";
        }
        if (btn.tag == 4) {
            SHARED.currentUserSetting.upSendImgType = @"低";
        }
        
    }
    
    
    
}


@end
