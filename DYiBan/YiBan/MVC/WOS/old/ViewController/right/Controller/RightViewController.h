//
//  RightViewController.h
//  splitViewTest
//
//  Created by zeng tom on 12-10-8
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "HttpCon_delegate.h"
//#import "YIBanAlertView.h"
#import "DYBBaseViewController.h"
@interface RightViewController : DYBBaseViewController
<UITableViewDelegate,UIScrollViewDelegate,
UITableViewDataSource>{
    UIButton *viewCover;
}
+(RightViewController *)share;
- (void)releaseShare;
- (void)unVerifyUser;
- (void)removeVerifyWarning;
- (void)refreashHeadBarMessageCount;

@property(retain,nonatomic)NSString *yb_new_comment;//新评论数
@property(retain,nonatomic)NSString *yb_new_at;// 新AT数
@property(retain,nonatomic)NSString *yb_new_message;//新消息数
@property(retain,nonatomic)NSString *yb_new_notice;//新通知数
@property(retain,nonatomic)NSString *yb_new_request;//新好友请求数
@end
