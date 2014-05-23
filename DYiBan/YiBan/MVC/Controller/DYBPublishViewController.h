//
//  DYBPublishViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBMenuBLueView.h"
#import "DYBImagePickerController.h"
#import "DYBFaceView.h"
#import "DYBPhotoEditorView.h"

@interface DYBPublishViewController : DYBBaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIActionSheetDelegate,DYBImagePickerControllerDelegate, faceDelegate>{
    MagicUIButton *_btnLocation;
    MagicUIButton *_btnPrivate;
    MagicUIButton *_btnShareRenRen;
    MagicUIButton *_btnShareTencent;
    MagicUIButton *_btnSelImage;
    MagicUIButton *_btnSelEmoji;
    MagicUIButton *_btnSelAt;

    int _sync_tag;
    int _sync_btn;
    
    MagicUITextView *_txtViewPublish;
    DYBMenuBLueView *_menuPrivate;
    DYBFaceView *_viewFace;
    MagicUILabel *_textCount;
    DYBPhotoEditorView *_photoEditor;
    NSArray *_arrMenu;
    UIScrollView *_viewPicBKG;
    NSMutableArray *_arrSelPic;
    
    NSString *_strActiveTitle;
    NSString *_strActiveid;
    
    BOOL _bOverSize;
    BOOL _bActive;
}

AS_SIGNAL(SELFLOCATION) //是否发送位置
AS_SIGNAL(DYNAMICPRIVATE) //动态隐私设置下拉菜单
AS_SIGNAL(SHARERENREN)  //同步到人人
AS_SIGNAL(SHARETENCENT)  //同步到腾讯微博
AS_SIGNAL(SYNCRESULT)  //同步结果
AS_SIGNAL(PRIVATESELECT)  //动态隐私选择
AS_SIGNAL(SELECTIMAGE)  //选择图片
AS_SIGNAL(SHOWIMAGE) //查看大图
AS_SIGNAL(DELETEMAGE) //删除图片
AS_SIGNAL(SELECTEMOJI) //选择表情
AS_SIGNAL(SELECTAT) //选择@
AS_SIGNAL(SELECTATLIST) //返回选择@列表

-(id)init:(NSString *)activeTitle activeid:(NSString *)activeid bActive:(BOOL)bActive;
@end
