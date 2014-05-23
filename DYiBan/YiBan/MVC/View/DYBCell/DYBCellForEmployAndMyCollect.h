//
//  DYBCellForEmployAndMyCollect.h
//  DYiBan
//
//  Created by zhangchao on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYBCustomLabel.h"

//就业信息和我的收藏cell
@interface DYBCellForEmployAndMyCollect : UITableViewCell

@property (nonatomic,assign) int type/*0:就业信息cell 1:我的收藏cell 2:搜索结果cell 3:就业信息详情cell*/;


-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;

@end
