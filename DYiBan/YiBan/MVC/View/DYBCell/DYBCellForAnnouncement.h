//
//  DYBCellForAnnouncement.h
//  DYiBan
//
//  Created by zhangchao on 13-8-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

//公告cell
@interface DYBCellForAnnouncement : UITableViewCell
{
    MagicUILabel *_lb_newContent,*_lb_time;
    MagicUIImageView *_imgV_sepline/*分割线*/;
}

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;

@end
