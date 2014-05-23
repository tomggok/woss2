//
//  DYBTwoDimensionCodeViewController.h
//  DYiBan
//
//  Created by Song on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "ZBarReaderView.h"
#import "ZBarReaderViewController.h"
@interface DYBTwoDimensionCodeViewController : DYBBaseViewController<ZBarReaderDelegate,ZBarReaderViewDelegate>
@property(retain,nonatomic)NSString *strData;
- (void)addWillAppear;
AS_SIGNAL(ACTIVITYBUTTON)
AS_SIGNAL(WEBBUTTON)
@end
