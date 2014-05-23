//
//  DYBUITabbarViewController.h
//  DYiBan
//
//  Created by NewM on 13-8-29.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_UITabBarController.h"
#import "DYBUnreadMsgView.h"

@interface DYBUITabbarViewController : MagicUITabBarController
{
}
AS_SIGNAL(HIDDENBUTTONACTION)
@property (nonatomic, assign)MagicViewController *vc;
@property (nonatomic,retain) DYBUnreadMsgView *v_totalNumOfUnreadMsg/*未读信息总数视图*/;

+ (DYBUITabbarViewController *)sharedInstace;

- (id)init:(MagicViewController *)dVc;

-(void)addAndRefreshTotalMsgView:(int)num;

//创建左试图
- (void)initLeftView;

//滑动主页面type：1为左面  2为右面
- (void)scrollMainView:(int)type;

//释放自己
- (void)clearSelf;

-(MagicUIThirdView *)getThreeview;

//改变计数view位置
-(void)changeMsgTotalFrame;
@end
