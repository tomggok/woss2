//
//  CellForDYBMsgViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-8-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

//私信页的4个cell
@interface DYBCellForDYBMsgViewController : UITableViewCell
{
    MagicUIImageView *_imgV_showImg/*左边展示图*/,*_imgV_newMsgNums/*新消息数量图*/;
    MagicUILabel *_lb_content;
}

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;
@end
