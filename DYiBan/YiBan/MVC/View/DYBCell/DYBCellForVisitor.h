//
//  DYBCellForVisitor.h
//  DYiBan
//
//  Created by zhangchao on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

//访客cell
@interface DYBCellForVisitor : UITableViewCell
{
    MagicUIImageView *_imgV_showImg/*左边展示图*/,*_imgV_newMsgNums/*新消息数量图*/;
    MagicUILabel *_lb_newContent,*_lb_nickName,*_lb_time;
    MagicUIButton *_bt_agree,*_bt_ignore;
}

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;

@end
