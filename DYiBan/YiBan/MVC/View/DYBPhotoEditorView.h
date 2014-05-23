//
//  DYBPhotoEditorView.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"

@interface DYBPhotoEditorView : DYBBaseView{
    MagicUIImageView *_imgView;
    MagicUIImageView *_imgFilter;
    MagicUIScrollView *_scrollView;
 
    UIImage *_rootImage;
    NSInteger _rotation;
}

@property (nonatomic, retain) MagicUIImageView *imgRootView;
@property (nonatomic, retain) UIImage *curImage;
@property (nonatomic, assign) int ntype; // 1 发布 2 个人主页 3 发通知 4创建笔记


AS_SIGNAL(DOSELECT)
AS_SIGNAL(DOSAVE)
AS_SIGNAL(DOBACK)
AS_SIGNAL(DORIGHT)

AS_NOTIFICATION(DOSAVEIMAGE)

@end
