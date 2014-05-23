//
//  DYBCellForAT.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYBCellForAT : UITableViewCell{
    MagicUIImageView *_imgV_showImg/*左边展示图*/,*_imgV_selectImg/*选择联系人cell右边的对号*/;
    MagicUILabel *_lb_newContent,*_lb_nickName;
    MagicUIButton *_btn_check;
}

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;

AS_SIGNAL(CHECK)

@end
