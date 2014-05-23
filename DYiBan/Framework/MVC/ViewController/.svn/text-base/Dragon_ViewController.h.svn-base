//
//  Dragon_BaseViewController.h
//  DragonFramework
//
//  Created by NewM on 13-3-5.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dragon_ViewSignal.h"
#import "Dragon_NavigationController.h"
#import "UINavigationBar+DragonNavigationBar.h"
#import "UIViewController+DragonViewSignal.h"
#import "UIView+DragonViewSignal.h"

#import "NSObject+Dragon_Notification.h"

@class DragonNavigationController;


enum viewState
{
    STATE_VIEW_DISAPPEARED = 0,//页面已经消失
    STATE_VIEW_DISAPPEARING = 1,//页面将要消失
    STATE_VIEW_APPEARING = 2,//页面将要显示
    STATE_VIEW_APPEARED = 3//页面已经显示
    
};

typedef enum DragonVCBackType {
    NORAMLBACKTYPE = 0,
    SWIPESCROLLERBACKTYPE = 1,
    SWIPELASTIMAGEBACKTYPE = 2
    } DragonVCBackType;

@class DragonViewController;
@interface UIView(DragonViewController)
- (DragonViewController *)board;

@end



@interface DragonViewController : UIViewController
{
    BOOL _bool_firstEnter;//第一次进入
    BOOL _bool_presenting;//正在呈现
    BOOL _bool_viewBuilt;//页面绘制
    BOOL _bool_dataLoaded;//数据读取完毕
    NSInteger _int_state;//页面的状态
}

@property (nonatomic, assign) BOOL      bool_firstEnter;//第一次进入
@property (nonatomic, assign) BOOL      bool_presenting;//正在呈现
@property (nonatomic, assign) BOOL      bool_viewBuilt;//页面绘制
@property (nonatomic, assign) BOOL      bool_dataLoaded;//数据读取完毕
@property (nonatomic, assign) NSInteger int_state;//页面的状态

@property (nonatomic, assign) NSInteger int_navi_animation_type;//页面跳转动画类型

////////////
AS_SIGNAL(CREATE_VIEWS)         //创建视图
AS_SIGNAL(DELETE_VIEWS)         //释放视图
AS_SIGNAL(LAYOUT_VIEWS)         //布局视图
AS_SIGNAL(LOAD_DATAS)           //加载数据
AS_SIGNAL(FREE_DATAS)           //释放数据
AS_SIGNAL(WILL_APPEAR)          //将要显示视图
AS_SIGNAL(DID_APPEAR)           //已经显示视图
AS_SIGNAL(WILL_DISAPPEAR)       //将要消失视图
AS_SIGNAL(DID_DISAPPEAR)        //已经消失视图
AS_SIGNAL(ORIENTATION_CHANGED)  //方向改变
AS_SIGNAL(ENTERBACKGROUND)      //进入后台
AS_SIGNAL(ENTERFOREGROUND)      //从后台回来


AS_SIGNAL(VCBACKSUCCESS)        //页面回退成功

AS_NOTIFICATION(NOTIFICATIONWILLAPPEAR)//通知页面即将显示

////////////

//+ (NSArray *)allViewController;
+ (DragonViewController *)vcalloc;

- (DragonNavigationController *)drNavigationController;
- (void)load;
- (void)unload;

- (void)enterBackground;//进入后台
- (void)enterForeground;//从后台回来

- (void)setVCBackAnimation:(DragonVCBackType)animationType canBackPageNumber:(NSInteger)number;
@end
