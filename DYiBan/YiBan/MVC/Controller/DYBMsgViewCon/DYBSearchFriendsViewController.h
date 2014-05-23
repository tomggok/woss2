//
//  DYBSearchFriendsViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-8-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

//找人页
@interface DYBSearchFriendsViewController : DYBBaseViewController
{
    MagicUISearchBar *_search;
    //    MagicUITableView *_tbv_mayKnow,*_tbv_nearBy;//
    //    NSMutableArray *_muA_data_mayKnow,*_muA_data_nearBy;
    MagicUIButton *_bt_mayKnow/*可能认识的*/,*_bt_nearBy/*附近的*/;
    
    UIView *_v_btBack/*按钮背景*/,*_v_bt_tbv/*按钮和tbv背景*/;
}

@property (nonatomic,assign) BOOL b_isInMainPage/*是否在一级页面(如 tabbar里的 我的主页),则点击其左上角返回键右划主屏,否则返回上个con*/;
@end
