//
//  WOSGoodFoodListCell.h
//  DYiBan
//
//  Created by tom zeng on 13-12-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOSGoodFoodListCell : UITableViewCell

@property (nonatomic,assign) int row;


-(id)initRow:(NSDictionary *)dic;
@end
