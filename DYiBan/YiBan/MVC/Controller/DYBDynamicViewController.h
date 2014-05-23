//
//  DYBDynamicViewController.h
//  DYiBan
//
//  Created by NewM on 13-8-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "banner.h"
#import "bannerList.h"
#import "DYBMenuView.h"
#import "DYBFaceView.h"

@interface DYBDynamicViewController : DYBBaseViewController<UITextViewDelegate, faceDelegate>{
    MagicUITableView *_tabDynamic;
    DYBMenuView *_tabMenu;
    bannerList *_bnerList;
    
    NSMutableArray *_arrayDynamic;
    NSMutableArray *_arrayDynamicCell;
    NSMutableArray *_arrTitleLable;
    NSMutableArray *_arreClass;
    
    NSString *_strMaxID;
    NSString *_strRequestType; // 1 随便看看 2易友动态 3班级动态
    NSString *_strCurClassID;
    
    BOOL bPullDown;
    BOOL bBanner;
    BOOL bAddBanner;
    BOOL bCloseAD;
    BOOL bRequst; //请求活动详情的时候，屏蔽 handleViewSignal_DYBDynamicViewController，防止进入DYBDynamicDetailViewController
    
    int nPage;
    int nPageSize;
    int nSelMenu;
    int _nRowCount;
    int _nCurCommentRow;

    UIView *_viewCommentBKG;
    UIView *_viewWarning;
    MagicUITextView *_txtViewComment;
    DYBFaceView *_viewFace;
    MagicUIImageView *_viewQuick;
    MagicUIButton *_btnQuick;
}

AS_SIGNAL(SWITCHDYBAMICBUTTON)
AS_SIGNAL(MENUSELECT)
AS_SIGNAL(CLOSEAD)
AS_SIGNAL(DYNAMICDETAIL)
AS_SIGNAL(DYNAMICDETAILCOMMENT)
AS_SIGNAL(DYNAMICDETAILLIKE)
AS_SIGNAL(DYNAMICDIMAGEETAIL)
AS_SIGNAL(DYNAMICREFRESH)
AS_SIGNAL(DELEFRESH)
AS_SIGNAL(PUBLISHREFRESH)
AS_SIGNAL(DYNAMICCOMMENT)
AS_SIGNAL(CLICKEMOJI)
AS_SIGNAL(CLICKSEND)
AS_SIGNAL(REMOVEQUICK)
AS_SIGNAL(PERSONALPAGE)
AS_SIGNAL(OPENURL)
AS_SIGNAL(REFRESHCELL)
AS_SIGNAL(ACTIVITYPAGE)

AS_SIGNAL(DYNCSCROLLLEFTVIEW)//滑动出左面视图

@end
