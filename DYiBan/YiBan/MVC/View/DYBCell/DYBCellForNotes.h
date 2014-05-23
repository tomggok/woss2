//
//  DYBCellForNotes.h
//  DYiBan
//
//  Created by zhangchao on 13-10-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYBCustomLabel.h"

@interface DYBCellForNotes : UITableViewCell
{
    DYBCustomLabel *_lb_newContent,*_lb_nickName,*_lb_time;
    MagicUIScrollView *_scrV_Tip/*标签的背景滚动*/;
    MagicUIImageView *_imgV_star,*imgV_show;
    UIView *v_line/*标签下的横线*/;
    MagicUIButton *_bt_delete,*_bt_favorite/*星标*/,*_bt_gotoDataBase/*转存*/,*_bt_share;
    MagicUIImageView *_v_toBeSlidingView/*要被滑动的view*/;
}

@property (nonatomic,retain) MagicUIImageView *imgV_star;

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;
-(void)changeStar:(int)i;
-(void)resetContentView;

@end
