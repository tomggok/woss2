//
//  DYBDynamicDetailViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "status.h"
#import "DYBCellForDynamicDetail.h"
#import "DYBCellForDynamicStatus.h"
#import "DYBFaceView.h"

@interface DYBDynamicDetailViewController : DYBBaseViewController<UITextViewDelegate, faceDelegate>{
    MagicUITableView *_tabDynamicDetail;
    status *_dynamicStatus;
    DYBCellForDynamicDetail *_cellDetail;
    DYBCellForDynamicStatus *_cellStatus;
    
    MagicUIImageView *_viewComment;
    MagicUIImageView *_viewLike;
    MagicUIImageView *_viewShare;
    MagicUIImageView *_viewArrow;
    
    MagicUILabel *_lbComment;
    MagicUILabel *_lbLike;
    MagicUILabel *_lbShare;
    
    MagicUIButton *_btnMoreComment;
    MagicUIButton *_btnMoreLike;
    MagicUIButton *_btnMoreShare;
    MagicUIButton *_btnMoreDel;
    
    NSMutableArray *_arrStatusData;
    NSMutableArray *_arrStatusCell;
    UIView *_viewMore;
    MagicUIButton *TraparentView;//透明层
    UIView *_viewCommentBKG;
    MagicUITextView *_txtViewComment;
    DYBFaceView *_viewFace;
    
    int nStatus;//1,评论 2,赞 3,转发
    int nPage;
    int nPageSize;
    BOOL _bScoll;
    BOOL _bMore;
    BOOL _bNoData;
    int _nRowCount;
}

- (id)init:(status *)statusdetail withStatus:(int)status bScroll:(BOOL)bScroll;//1 评论 2,赞 3,转发 bScroll:YES,滚动置顶

AS_SIGNAL(DYNAMICDIMAGEETAIL)
AS_SIGNAL(DETAILCOMMENT)
AS_SIGNAL(DETAILLIKE)
AS_SIGNAL(DETAILSHARE)
AS_SIGNAL(OPENURL)
AS_SIGNAL(OPENPERSONPAGE)
AS_SIGNAL(MORECOMMENT)
AS_SIGNAL(MORELIKE)
AS_SIGNAL(MORESHARE)
AS_SIGNAL(MOREDEL)
AS_SIGNAL(CLICKEMOJI)
AS_SIGNAL(CLICKAT)
AS_SIGNAL(CLICKSEND)
AS_SIGNAL(SELECTATLIST)
AS_SIGNAL(PERSONALPAGE)
AS_SIGNAL(ACTIVITYPAGE)
AS_SIGNAL(TRANSPARENT)

@end
