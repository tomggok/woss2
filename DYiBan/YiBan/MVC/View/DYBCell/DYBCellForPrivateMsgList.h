//
//  DYBCellForPrivateMsgList.h
//  DYiBan
//
//  Created by zhangchao on 13-8-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYBUnreadMsgView.h"
#import "DYBCustomLabel.h"

//私信列表的cell
@interface DYBCellForPrivateMsgList : UITableViewCell
{
    MagicUIImageView *_imgV_showImg/*左边展示图*/,*_imgV_newMsgNums/*新消息数量图*/;
    DYBCustomLabel *_lb_newContent,*_lb_nickName,*_lb_time;
    UIView *_v_toBeSlidingView/*要被滑动的view*/;
    MagicUIButton *_bt_delete;
}

@property (nonatomic,retain) DYBUnreadMsgView *v_UnreadMsgView;


-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;
-(void)resetContentView;

@end
