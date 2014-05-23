//
//  DYBCellForTagManage.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tag_list_info.h"

@interface DYBCellForTagManage : UITableViewCell{
    UIView *_viewDelBKG;
    UIView *_viewCover;
    
    MagicUIButton *_btnDelete;
    MagicUILabel *_lbTagName;
    
    float fHeight;
    float fMaxMove;
    tag_list_info *_tlinfo;
}

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;
-(void)setContent:(id)data selected:(BOOL)bSelected indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;
-(void)reColorCell;
-(void)deColorCell;
-(void)resetContentView:(BOOL)bTap;

AS_SIGNAL(DELTAG)

@end
