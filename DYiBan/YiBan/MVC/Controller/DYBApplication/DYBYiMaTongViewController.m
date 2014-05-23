//
//  DYBYiMaTongViewController.m
//  DYiBan
//
//  Created by Song on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBYiMaTongViewController.h"
#import "DYBTwoDimensionCodeViewController.h"
@interface DYBYiMaTongViewController ()

@end

@implementation DYBYiMaTongViewController
DEF_SIGNAL(SCANBUTTON);
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"易码通"];
        [self backImgType:0];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        [self.view setBackgroundColor:[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f]];
        MagicUIImageView *imageview = [[MagicUIImageView alloc]initWithImage:[UIImage imageNamed:@"scanweb.png"]];
        [imageview setFrame:CGRectMake(60.0f, 120,150 , 200)];
        [imageview setCenter:CGPointMake(160.0f, 180.0f)];
        [imageview setUserInteractionEnabled:YES];
        [self.view addSubview:imageview];
        RELEASE(imageview)
        
        MagicUIButton *btn = [[MagicUIButton alloc]initWithFrame:CGRectMake(20.0f, 120.0f, 132.0f, 42.0f)];
        [self setMagicUIButton:btn setImageNorm:[UIImage imageNamed:@"btn_blank2_a"] setImageHigh:[UIImage imageNamed:@"btn_blank2_b"]  signal:[DYBYiMaTongViewController SCANBUTTON] setControl:self];
        [btn setCenter:CGPointMake(160.0f, 320.0f)];
        [btn setTitle:@"开始扫描" forState:UIControlStateNormal];
        [self.view addSubview:btn];
        RELEASE(btn);
    }
}

#pragma mark- 点击按钮
- (void)handleViewSignal_DYBYiMaTongViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBYiMaTongViewController SCANBUTTON]])
    {
        DYBTwoDimensionCodeViewController *vc = [[DYBTwoDimensionCodeViewController alloc] init];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
        
    }
}

@end
