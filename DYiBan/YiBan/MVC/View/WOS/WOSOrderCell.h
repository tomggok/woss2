//
//  WOSOrderCell.h
//  DYiBan
//
//  Created by tom zeng on 13-12-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOSOrderCell : UITableViewCell

AS_SIGNAL(DOORDER)
@property (nonatomic,retain)NSDictionary *dictInfo;

-(void)creatCell:(NSDictionary *)dict;
@end
