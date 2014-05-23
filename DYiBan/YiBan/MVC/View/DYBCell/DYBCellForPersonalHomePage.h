//
//  DYBCellForPersonalHomePage.h
//  DYiBan
//
//  Created by zhangchao on 13-9-4.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYBCustomLabel.h"
#import "status.h"
@interface DYBCellForPersonalHomePage : UITableViewCell
{
    MagicUIImageView *_imgV_head,*_imgV_headBack/*头像白色背景*/,*_imgV_icon/*动态cell左边的icon*/,*_imgV_SpreadDayViewBack/*展开的day视图的蓝色背景*/,*_imgV_footMark/*脚印*/,*_imgV_signRightView/*签名右边的图标*/;
    UIView *_v_sign/*心情签名背景*/,*_v_btBackView/*好友|访客|踩等按钮背景*/,*_v_sepLine1/*签名下边的第一条横的分割线*/,*_v_sepL/*分割线*/,*_vVerticalLine/*竖线*/,*_v_day/*,*_V_AllBack动态cell的整体背景,根据内容不同换颜色*//*,*_v_sepLine2头像下边的竖线*/;
    DYBCustomLabel *_lb_sign/*心情签名*/,*_lb_content,*_lbDay/*动态cell左边的日期*/;
    MagicUIButton *_bt_friend,*_bt_visitor/*访客*/,*_bt_PhotoAlbum/*相册*/,*_bt_datum/*资料*/,*_bt_BirthdayReminder/*生日提醒*/,*_bt_pushUp,*_bt_stamp/*踩*/,*_bt_pushUpNumsArea/*顶的人数区域*/,*_bt_stampNumsArea/*踩的人数区域*/;
    status *_dynamicStatus;
    NSMutableArray *_muA_allAddTapGestureView/*保存动态cell里每个动态里被加了手势的view,已在view释放前释放在view上添加手势时被retain的_dynamicStatus*/;  /**_muA_allStatesModelInOneCell一个cell里的所有动态model*/// ,*_muA_viewCoverLike/*同 _muA_allBackView*/,*_muA_viewCoverComment/*同 _muA_allBackView*/;
}

@property (nonatomic,retain) MagicUIImageView *imgV_head;
@property (nonatomic,retain) MagicUIButton *bt_pushUpNumsArea,*bt_stamp;

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;
-(void)refreshUi:(id)data tbv:(UITableView *)tbv;
-(void)spreadOrShrinkDayView;
-(void)pushUp_stampAnimation;

@end
