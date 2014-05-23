//
//  DYBCellForMayKnowFriends.h
//  DYiBan
//
//  Created by zhangchao on 13-8-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

//可能认识的人cell
@interface DYBCellForMayKnowFriends : UITableViewCell
{
    MagicUIImageView *_imgV_showImg/*左边展示图*/,*_imgV_arrow;
    MagicUILabel *_lb_newContent,*_lb_nickName,*_lb_check;
}

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;

@end
