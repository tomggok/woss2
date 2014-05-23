//
//  DYBSendPrivateLetterViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-8-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "friends.h"
#import "DYBCustomInputView.h"
#import "DYBPhotoView.h"
#import "DYBFaceView.h"
#import "notice_list.h"
#import "chat.h"

//发私信页
@interface DYBSendPrivateLetterViewController : DYBBaseViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,faceDelegate>
{
//    MagicUITableView *_tbv;//
//    NSMutableArray *_muA_data;
//    MagicUIButton *_bt_mayKnow/*可能认识的*/,*_bt_nearBy/*附近的*/;
    
    MagicUIImageView *_imgV_headView/*对方头像*/;
    UIView *_v_bottomView/*底部白色tabbar*/,*_v_threeBtView/*点加号后出现的3个bt的背景*/;
    MagicUIButton *_bt_add/*加号*/,*_bt_send,*_bt_face/*表情*/,*_bt_photo,*_bt_location;
    DYBCustomInputView *_v_inputV;
    DYBPhotoView *_v_filter/*滤镜*/;
    BOOL bONface,isChangeOriFrame;
    notice_list *lsit;
    NSMutableArray *cell_list;
    
    
    int indexRow;
    int _showTag;
    
    chat *saveExt;
    
    BOOL keyboardY;
    int keyboardChange;//键盘弹出
    int keyboardChangeNOW;//键盘输入
//    int sizeOfchange;
    
    int updown;
    
    int lastLineNums;
    
}
AS_SIGNAL(SENDLOCATION);//点击图片
AS_SIGNAL(OPENURL);//打开链接

//@property (nonatomic,copy) NSString *_str_userId,*_str_userName;
@property (nonatomic,retain) DYBFaceView *faceView;
@property (nonatomic,retain) NSDictionary *model; //friends *model;
- (void)sendPhotoImage:(UIImage *)image;
@end
