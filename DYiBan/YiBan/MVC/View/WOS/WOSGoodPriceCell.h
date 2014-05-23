//
//  WOSGoodPriceCell.h
//  DYiBan
//
//  Created by tom zeng on 13-12-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYBBaseViewController.h"
@interface WOSGoodPriceCell : UITableViewCell

@property (nonatomic,retain)DYBBaseViewController *targetObj;
-(void)creatView:(NSDictionary *)dcit;
@end
