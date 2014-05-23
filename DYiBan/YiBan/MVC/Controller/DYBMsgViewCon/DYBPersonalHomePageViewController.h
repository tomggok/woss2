//
//  DYBPersonalHomePageViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-8-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "user.h"
#import "DYBImagePickerController.h"

//个人主页
@interface DYBPersonalHomePageViewController : DYBBaseViewController<DYBImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    MagicUIButton *_bt_friend,*_bt_visitor/*访客*/,*_bt_PhotoAlbum/*相册*/,*_bt_datum/*资料*/,*_bt_BirthdayReminder/*生日提醒*/,*_bt_sendDynamic/*发动态*/,*_bt_backToTop/*回顶部*/,*_bt_AddFriends,*_bt_sendPriLetter,*_bt_refresh;
    user *_user;//接口读出来的用户数据
    MagicUIImageView *_imgV_show/*顶部展示图*/,*_imgV_head;
    MagicUIScrollView *_scr_All/*self.view上盖的一层,也是封面的父视图*/,*_scr_showImgBack/*和展示图宽高一样的展示图背景*/;
    BOOL _b_imgVShowSlideOver/*tbv上滑时展示图也得上滑一点,否则 tbv的H加高后1号cell就漏出来下边的展示图了*/;
}
AS_SIGNAL(ATUILABLEACTION)
@property (nonatomic,retain) NSMutableDictionary *d_model/*key: name ,userid*/;
@property (nonatomic,assign) BOOL b_isInMainPage/*是否在一级页面(如 tabbar里的 我的主页),则点击其左上角返回键右划主屏,否则返回上个con*/;
@property (nonatomic,retain) MagicUITableView *tbv;
@property (nonatomic,retain) user *user;//接口读出来的用户数据

@end
