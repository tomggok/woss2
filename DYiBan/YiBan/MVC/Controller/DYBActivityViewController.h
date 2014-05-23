//
//  DYBActivityViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "active.h"
#import "DYBFaceView.h"

@interface DYBActivityViewController : DYBBaseViewController<UITextViewDelegate, faceDelegate>{
    MagicUITableView *_tabActivity;
    active *_active;
    
    NSMutableArray *_arrayActivity;
    NSMutableArray *_arrayActivityCell;
    
    UIView *_viewCommentBKG;
    UIView *_viewWarning;
    MagicUITextView *_txtViewComment;
    DYBFaceView *_viewFace;
    MagicUIImageView *_viewQuick;
    MagicUIButton *_btnQuick;
    
    int nPage;
    int nPageSize;
    int _nRowCount;
    int _nCurCommentRow;
    
    BOOL bAddActivity;
}

-(id)init:(active *)active;

AS_SIGNAL(DYNAMICDETAIL)
AS_SIGNAL(DYNAMICDIMAGEETAIL)
AS_SIGNAL(DYNAMICDETAILCOMMENT)
AS_SIGNAL(DYNAMICDETAILLIKE)
AS_SIGNAL(DELEFRESH)
AS_SIGNAL(PUBLISHREFRESH)
AS_SIGNAL(DYNAMICCOMMENT)
AS_SIGNAL(CLICKEMOJI)
AS_SIGNAL(CLICKSEND)
AS_SIGNAL(REMOVEQUICK)
AS_SIGNAL(PERSONALPAGE)
AS_SIGNAL(OPENURL)
AS_SIGNAL(REFRESHCELL)

@end
