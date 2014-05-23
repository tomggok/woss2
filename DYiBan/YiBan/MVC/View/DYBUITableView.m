//
//  DYBUITableView.m
//  DYiBan
//
//  Created by NewM on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBUITableView.h"

@implementation DYBUITableView

- (void)reloadData:(BOOL)dataIsAllLoaded
{
    [super reloadData:dataIsAllLoaded];
    
    if (dataIsAllLoaded)
    {
        if (SHARED.isLogin)
        {
            [DYBShareinstaceDelegate loadFinishAlertView:@"全部加载完毕" target:self];
        }
    
    }
}

@end
