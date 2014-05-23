//
//  DYBATViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBFriendsViewController.h"

@interface DYBATViewController : DYBBaseViewController{
    MagicUISearchBar *_search;
    MagicUITableView *_tbv_friends_myConcern_RecentContacts/*好友|我关注的|最近联系人tbv*/;
    NSMutableArray *_muA_data_friends/*好友列表数据源*/,*_muA_data_MyConcern/*我关注的列表数据源*//*,*_muA_data_RecentContacts最近联系人列表数据源*/;
    DYBMenuView *_tbv_dropDown;//下拉列表
    MagicUIButton *_bt_DropDown/*下拉按钮*/,*_bt_cancelViews/*点击取消某视图*/;
    DYBCallView *_v_call;/*打电话界面*/;
    
    //    BOOL _b_up;
    BOOL bPullDown;
    NSMutableArray *_arrAtlist;
    UIView *_viewWarning;
}

@property (nonatomic,copy) NSString *str_userid;
@property (nonatomic,assign) BOOL b_isInMainPage/*是否在一级页面(如 tabbar里的 我的主页),则点击其左上角返回键右划主屏,否则返回上个con*/;

@end
