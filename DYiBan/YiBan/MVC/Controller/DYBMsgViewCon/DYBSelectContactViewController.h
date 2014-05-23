//
//  DYBWritePrivateLetterViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBMenuView.h"
#import "DYBDataBankListCell.h"
//选择联系人页
@interface DYBSelectContactViewController : DYBBaseViewController
{
    MagicUISearchBar *_search;
//    MagicUITableView *_tbv;//
    NSMutableArray *_muA_data/*好友数据源*/,*_muA_data_class/*班级列表数据源*/,*_muA_data_classDetail/*班级成员数据源*/;
    MagicUIButton *TraparentView;//下拉列表
    DYBMenuView *_tbv_dropDown;//下拉列表
    MagicUIButton *_bt_DropDown/*下拉按钮*/;
    BOOL bPullDown;

}


@property (nonatomic,assign)BOOL bEnterDataBank;
@property (nonatomic,assign)NSString *nid;//分享笔记的ID

@property (nonatomic,retain)NSString *docAddr;
@property (nonatomic,retain)NSDictionary *dictInfo;
@property (nonatomic,retain)DYBDataBankListCell *cellDetail;
@property (nonatomic,retain)DYBDataBankListCell *cellDetailSearch;
@end
