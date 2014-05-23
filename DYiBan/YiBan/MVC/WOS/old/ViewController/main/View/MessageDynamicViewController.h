//
//  MessageDynamicViewController.h
//  Magic
//
//  Created by tom zeng on 12-11-3.
//
//



@protocol MessageDynamicViewControllerDelegate <NSObject>

@optional
- (void)tableViewScrollView:(UITableView *)_tableView scrollView:(UIScrollView *)_scrollView;

@end
//@class YibanBanner;
//#import "HttpCon_delegate.h"
//#import "MainConrtrollerCell.h"
#import "MainViewController.h"
#import "LLSplitViewController.h"
//#import "YiBanTableView.h"
//#import "TouchTableViewDelegate.h"
//#import "YiBanDefinite.h"
//#import "PullDownView.h"
//#import "YibanBanner.h"
//#import "UIButton+Custom.h"
//#import "UIImageView+Custom.h"

@class user;

//中间控制器(显示  易友动态 等)
@interface MessageDynamicViewController : UIView<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>{
    NSString *singleORclass;
    NSString *classID;
    NSString *stringPic ;//照片原图URL
    
    BOOL checkPageView;//判断是否从主页进来
    UIView *_tableRowZeroView;//table的row为0的view
    user *userModel;//要查询用户的userid
    
    id<MessageDynamicViewControllerDelegate> _delegate;
    
    BOOL isHiddenHeader;//隐藏头
    UIImageView *_imgV_findFriend/*提示去找人img*/,*_imgV_sendAction/*提示发动态img*/;
}
//@property (nonatomic, assign) UITableView *_talbeView;//当前页面的tableview
@property (nonatomic, assign) UIView *tableRowZeroView;//table的row为0的view
@property (nonatomic, assign) BOOL checkPageView;//判断是否从主页进来
@property (nonatomic, retain) user *userModel;//要查询用户的userid
@property (nonatomic, assign) BOOL isHiddenHeader;//隐藏头
@property (retain,nonatomic) NSMutableArray *items;
@property (retain,nonatomic)NSString *haveNext;
@property (nonatomic, assign)id<MessageDynamicViewControllerDelegate> delegate;
//@property (assign,nonatomic)    YiBanTableView * table_view;
@property(retain,nonatomic)NSDictionary* nsnotification;
@property(nonatomic, copy)NSString *maxID;
//@property(nonatomic,retain)YibanBanner *bannerController;
@property (nonatomic,retain)NSString *stringPic ;


-(void)hight:(NSMutableArray*)item;
-(void)hight_update:(NSMutableArray*)item updateNumber :(int)rowNumber;
- (BOOL) refresh;
-(void)reloadData;
//-(void)addBannerView;
-(void)stopTimer;
-(void)ref_reload;// 删除的时候，回调，，
- (void)viewDidLoad;
-(void)send_reflash;
@end
