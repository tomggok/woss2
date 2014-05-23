//
//  WOSOrderLastViewController.h
//  DYiBan
//
//  Created by tom zeng on 13-12-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface WOSOrderLastViewController : DYBBaseViewController<UITextViewDelegate>

@property (nonatomic, assign)float fTotalPrice;
@property (nonatomic,retain)NSDictionary *dictInfo;
@end
