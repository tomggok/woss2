//
//  DYBFriendsViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-8-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBCallView.h"
#import "DYBMenuView.h"

//好友页
@interface DYBFriendsViewController : DYBBaseViewController
{
    MagicUISearchBar *_search;
    MagicUITableView *_tbv_friends_myConcern_RecentContacts/*好友|我关注的|最近联系人tbv*/;
    NSMutableArray *_muA_data_friends/*好友列表数据源*/,*_muA_data_MyConcern/*我关注的列表数据源*//*,*_muA_data_RecentContacts最近联系人列表数据源*/;
    DYBMenuView *_tbv_dropDown;//下拉列表
    MagicUIButton *_bt_DropDown/*下拉按钮*/,*_bt_cancelViews/*点击取消某视图*/;
    DYBCallView *_v_call;/*打电话界面*/;
    MagicUIButton *TraparentView;

//    BOOL _b_up;
    BOOL bPullDown,_b_isRequested/*是否请求过1号MagicRequest,避免输入账号密码登陆后在 CREATE_VIEWS 信号里请求后 又在 tabbar切换时 在 WILL_APPEAR 信号请求*/;

}

@property (nonatomic,copy) NSString *str_userid;
@property (nonatomic, assign) BOOL b_isInMainPage/*是否在一级页面(如 tabbar里的 我的主页),则点击其左上角返回键右划主屏,否则返回上个con*/;
@property (nonatomic, assign) BOOL isPush;

@end
