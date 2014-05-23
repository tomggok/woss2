//
//  DYBBaseViewLeftController.h
//  DYiBan
//
//  Created by Song on 13-8-27.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"
//#import "DYBImagePickerController.h"
//DYBImagePickerControllerDelegate   Delegate
@interface DYBBaseViewLeftView: DYBBaseView<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)MagicUIButton *photoBtn;
@property(nonatomic,assign)int newTag;
@property(nonatomic,assign)int oldTag;
AS_SIGNAL(PHOTOBUTTON)//图片按钮
AS_SIGNAL(MAPBUTTON)//地图按钮
AS_SIGNAL(SELECTBUTTON)//选择按钮
- (void)changStatus:(int)tag;
@end
