//
//  WOShopDetailViewController.h
//  DYiBan
//
//  Created by tom zeng on 13-12-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "WOSShoppDetailTableViewCell.h"

@interface WOShopDetailViewController : DYBBaseViewController<WOSShoppDetailTableViewCellDelegate>

@property (nonatomic,retain)NSDictionary *dictInfo;
AS_SIGNAL(BTNONE);
AS_SIGNAL(BTNTWO);
@end
