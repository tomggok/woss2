//
//  DYYBClassHomePageViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "eclass.h"

//班级主页
@interface DYYBClassHomePageViewController : DYBBaseViewController
{
    MagicUIImageView *_imgV_classImg,*_imgV_dashed/*虚线*/,*_imgV_arrow/*右箭头*/,*_imgv_verticalDashedLine/*竖虚线*/,*_imgV_arrowUp/*tbv顶部的箭头*/ ;
    MagicUILabel *_lb_name,*_lb_classSizeTab/*班级人数标签*/,*_lb_classSize/*班级实际人数*/;
    MagicUIButton *_bt_gotoClassDetail/*进入班级详情*/,*_bt_announcement/*公告*/,*_bt_topic/*话题*/,*_bt_classList/*右上角班级列表*/;
    UIView *_v_announcement_topic/*公告和话题全局背景*/;
    NSMutableArray *_muA_data_classList/*已加入的班级列表数据源*/,*_muA_data_announcement/*公告数据源*/,*_muA_data_topic/*话题数据源*/,*_muA_data_classSize/*人数数据源*/;
}

@property (nonatomic,copy) NSString *str_userid;//要查看班级的用户ID
@property (nonatomic,retain) NSMutableArray *muA_data_classList/*已加入的班级列表数据源*/;
@property (nonatomic,assign)eclass *modelClass;//如用户仅有一个班级，直接就是此班级;如用户有多个班级，就是已设为“活跃班级”;   如未设置活跃班级，则是最新加入的班级的数据模型。,且为nil时才被赋值,!=nil时表示从 选择班级页回来,进入特定班级主页
@property (nonatomic,retain) MagicUITableView *tbv;
@property (nonatomic,assign) BOOL b_isRefresh;
@end
