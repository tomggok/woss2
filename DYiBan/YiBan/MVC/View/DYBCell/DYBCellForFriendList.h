//
//  DYBCellForFriendList.h
//  DYiBan
//
//  Created by zhangchao on 13-8-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

//好友列表的cell
@interface DYBCellForFriendList : UITableViewCell
{
    MagicUIImageView *_imgV_showImg/*左边展示图*/,*_imgV_selectImg/*选择联系人cell右边的对号*/;
    MagicUILabel *_lb_newContent,*_lb_nickName;
    MagicUIButton *_bt_private/*发私信*/,*_bt_call/*打电话*/;
}

@property (nonatomic,retain)     MagicUIImageView *imgV_showImg/*左边展示图*/;
@property (nonatomic,assign)     BOOL bEnterDataBank;
@property (nonatomic,assign)     NSIndexPath *indexPath;
@property (nonatomic,retain)     NSMutableArray *arrayCollect;
@property (nonatomic,assign)     int type/*0:好友cell  1:选择联系人cell*/;
@property (nonatomic,assign)     NSMutableDictionary *dictSelectResult;

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;

@end
