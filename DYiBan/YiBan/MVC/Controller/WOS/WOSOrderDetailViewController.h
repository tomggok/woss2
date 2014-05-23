//
//  WOSOrderDetailViewController.h
//  DYiBan
//
//  Created by tom zeng on 13-12-24.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface WOSOrderDetailViewController : UIView

@property (nonatomic,retain)NSDictionary *dictInfo;

-(void)creatView:(NSDictionary *)dict;
@end
