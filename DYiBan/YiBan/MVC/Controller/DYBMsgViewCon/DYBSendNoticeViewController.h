//
//  DYBSendNoticeViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-9-10.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBFaceView.h"
#import "DYBImagePickerController.h"

//发通知
@interface DYBSendNoticeViewController : DYBBaseViewController<faceDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,DYBImagePickerControllerDelegate,UINavigationControllerDelegate>
{
   
}

@property (nonatomic,retain) NSMutableArray *muA_noticeArea/*通知范围*/;

@end
