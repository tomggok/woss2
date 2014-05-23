//
//  DYBApplicationViewController.m
//  DYiBan
//
//  Created by Song on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBApplicationViewController.h"
#import "DYBXinHuaViewController.h"
#import "DYBYiMaTongViewController.h"
#import "DYBEmployInfoViewController.h"
#import "DYBTwoDimensionCodeViewController.h"

@interface DYBApplicationViewController () {
    
    MagicUIButton *appBtn[3];
    MagicUILabel *label[3];
}

@end

@implementation DYBApplicationViewController
DEF_SIGNAL(SELECTBUTTON)//按钮点击
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"应用"];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        NSArray *a = @[@"应用_01",@"应用_03",@"应用_02"];
        NSArray *b = @[@"新华e讯",@"易码通",@"就业信息"];
        for (int i = 0; i < 3; i++) {
            
            appBtn[i] = [[MagicUIButton alloc]initWithFrame:CGRectMake(20+80*i, self.headHeight+20, 60, 60)];
            appBtn[i].tag = i;
            
            label[i] = [[MagicUILabel alloc]initWithFrame:CGRectMake(20+80*i, self.headHeight+20+70, 60, 30)];
            label[i].textAlignment = NSTextAlignmentCenter;
            label[i].font = [DYBShareinstaceDelegate DYBFoutStyle:15];  //字体和大小设置
            label[i].textColor = [MagicCommentMethod colorWithHex:@"333333"];
            label[i].backgroundColor = [UIColor clearColor];
            label[i].text = [b objectAtIndex:i];
            [self.view addSubview:label[i]];
            RELEASE(label[i]);
            
            [self setMagicUIButton:appBtn[i] setImageNorm:[UIImage imageNamed:[a objectAtIndex:i]] setImageHigh:[UIImage imageNamed:[a objectAtIndex:i]]  signal:[DYBApplicationViewController SELECTBUTTON] setControl:self];
            
        }
        
    
    }
}

#pragma makr -
#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        DYBUITabbarViewController *dync = [DYBUITabbarViewController sharedInstace];
        [dync scrollMainView:1];
    }
    
}

#pragma mark- 点击按钮
- (void)handleViewSignal_DYBApplicationViewController:(MagicViewSignal *)signal
{
    self.view.userInteractionEnabled = NO;
    if ([signal is:[DYBApplicationViewController SELECTBUTTON]])
    {
        MagicUIButton *btn = signal.source;
        
        if (btn.tag == 0) {
            
            DYBXinHuaViewController *vc = [[DYBXinHuaViewController alloc] init];
            self.view.userInteractionEnabled = YES;
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
            
        }else if (btn.tag == 1) {
            
//            DYBYiMaTongViewController *vc = [[DYBYiMaTongViewController alloc] init];
//            [self.drNavigationController pushViewController:vc animated:YES];
//            RELEASE(vc);
            DYBTwoDimensionCodeViewController *vc = [[DYBTwoDimensionCodeViewController alloc] init];
            self.view.userInteractionEnabled = YES;
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
            
        }else {//就业信息
            
            DYBEmployInfoViewController *vc = [[DYBEmployInfoViewController alloc] init];
            self.view.userInteractionEnabled = YES;
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
            
        }
        
    }
}

@end
