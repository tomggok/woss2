//
//  DYBClassListViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

//班级列表|选择班级
@interface DYBClassListViewController : DYBBaseViewController
{
//    MagicUITableView *_tbv;
    NSIndexPath *_index;//被选中要被设置成的活跃班级
    MagicUIButton *_bt_ok/*选择通知范围时的右上角确认按钮*/;
}

@property (nonatomic,assign) int type/*0:选活跃班级  1:选通知范围*/;
@property (nonatomic,assign) NSMutableArray *muA_noticeArea/*通知范围*/;
@property (nonatomic,assign) int i_classIDByClassHome;//从班级主页切进来时,班级主页当前班级的id
@end
