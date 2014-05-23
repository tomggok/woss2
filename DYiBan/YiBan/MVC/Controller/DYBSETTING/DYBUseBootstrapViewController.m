//
//  DYBUseBootstrapViewController.m
//  DYiBan
//
//  Created by Song on 13-10-17.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBUseBootstrapViewController.h"
#import "UIView+Gesture.h"
#import "Magic_Device.h"
@interface DYBUseBootstrapViewController () {
    
    MagicUIScrollView *scroll;
}

@end

@implementation DYBUseBootstrapViewController
@synthesize type = _type;

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"使用引导"];
        [self backImgType:0];
//        self.headview.hidden = YES;
        
        
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        
        NSArray *imageArray = nil;
        int count = 6;
        
        if (_type == 2)
        {
            count = 5;
            if ([MagicDevice boundSizeType] == 1)
            {
                imageArray = @[@"noteteaching01_ip5",@"noteteaching02_ip5",@"noteteaching03_ip5",@"noteteaching04_ip5",@"noteteaching05_ip5"];
            }else
            {
                imageArray = @[@"noteteaching01",@"noteteaching02",@"noteteaching03",@"noteteaching04",@"noteteaching05"];
            }
        }else
        {
            if ([MagicDevice boundSizeType] == 1)
            {
                imageArray = @[@"databasehelp1-568h@2x",@"databasehelp2-568h@2x",@"databasehelp3-568h@2x",@"databasehelp4-568h@2x",@"databasehelp5-568h@2x",@"databasehelp6-568h@2x"];
            }else
            {
                imageArray = @[@"databasehelp1",@"databasehelp2",@"databasehelp3",@"databasehelp4",@"databasehelp5",@"databasehelp6"];
            }
        }
        
        
        
        scroll = [[MagicUIScrollView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-20)];
        scroll.tag = 1;
        scroll.pagingEnabled = YES;
        [self.view addSubview:scroll];
        RELEASE(scroll);
        
        [scroll CreatTapGeture:self selector:@selector(touch) numberOfTouchesRequired:1 numberOfTapsRequired:1];
        
        
        
        for (int i = 0; i < count; i++) {
            
            MagicUIImageView *imv = [[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*i, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-20)];
            UIImage *image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
            [imv setImage:image];
            [scroll addSubview:imv];
            RELEASE(imv);
        }
        
        [scroll setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds)*[imageArray count], CGRectGetHeight(self.view.bounds)-self.headHeight)];
        
    }
}

- (void)touch {
    //显示
    if (scroll.tag == 1) {
        self.headview.hidden = NO;
        scroll.tag = 2;
    }else {
        self.headview.hidden = YES;
        scroll.tag = 1;
    }
    
}

- (void)handleViewSignal_MagicUIScrollView:(MagicViewSignal *)signal {
    
    if ([signal is:[MagicUIScrollView SCROLLVIEWDIDSCROLL]])/*numberOfRowsInSection*/{
        
        self.headview.hidden = YES;
        scroll.tag = 1;
        
    }
}


@end
