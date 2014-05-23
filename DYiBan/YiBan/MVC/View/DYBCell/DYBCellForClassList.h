//
//  DYBCellForClassList.h
//  DYiBan
//
//  Created by zhangchao on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

//班级列表|选择班级cell
@interface DYBCellForClassList : UITableViewCell
{
    MagicUILabel *_lb_newContent;
    MagicUIImageView *_imgV_sepline/*分割线*/,*_imgV_star/**/,*_imgV_YES/*对号*/;
}

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;
@end
