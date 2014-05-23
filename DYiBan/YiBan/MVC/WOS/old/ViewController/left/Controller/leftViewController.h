//
//  leftViewController.h
//  splitViewTest
//
//  Created by zeng tom on 12-10-8
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HttpCon_delegate.h"
//#import "YIBViewControlleranAlertView.h"
//#import "YiBanHeadBarView.h"
#import "DYBBaseViewController.h"
//左视图(动态,主页等列表页)
@interface leftViewController : DYBBaseViewController<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
{
    UILabel *labelName;
    UIImageView* imageViewUser;
    UITableView *leftList;
    UIButton *btnLogout;
    UIButton *viewCover;
    NSMutableArray *arrAppList;
    UIWebView *webview;
//    YiBanHeadBarView *bar;
}
@property(retain,nonatomic)UILabel *labelName;
@property(retain,nonatomic)UIImageView* imageViewUser;
@property(retain,nonatomic)UIButton *btnLogout;
@property(retain,nonatomic)NSMutableArray *arrAppList;
@property(retain,nonatomic)NSIndexPath *selectIndex;
+(leftViewController *)share;
- (void)releaseShare;
- (void)unVerifyUser;
- (void)removeVerifyWarning;

//注销操作
- (void)loginOutAction:(BOOL)ifSessID;
-(void)backPop;
@end
