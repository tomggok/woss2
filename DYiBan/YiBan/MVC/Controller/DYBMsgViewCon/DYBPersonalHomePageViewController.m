//
//  DYBPersonalHomePageViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBPersonalHomePageViewController.h"
#import "DYBFriendsViewController.h"
#import "DYBVisitorViewController.h"
#import "DYBPersonalProfileViewController.h"
#import "DYBBirthdayReminderViewController.h"
#import "UITableView+property.h"
#import "DYBCellForPersonalHomePage.h"
#import "UIView+MagicCategory.h"
#import "status.h"
#import "NSString+Count.h"
#import "DYBSignViewController.h"
#import "DYBCheckImageViewController.h"
#import "DYBDynamicDetailViewController.h"
#import "DYBImagePickerController.h"
#import "UserSettingMode.h"
#import "Magic_Device.h"
#import "DYBPersonalPhotoViewController.h"
#import "DYBCheckImageViewController.h"
#import "user_avatardolist.h"
#import "user_avatartop_ user_avatartread.h"
#import "DYBSendWishViewController.h"
#import "DYBPublishViewController.h"
#import "DYBSendPrivateLetterViewController.h"
#import "UIImage+MagicCategory.h"
#import "DYBCheckMultiImageViewController.h"
#import "DYBTop_StampListViewController.h"
#import "DYBDataBankShotView.h"
#import "UIView+Animations.h"
#import "NSObject+KVO.h"
#import "UIViewController+MagicCategory.h"
#import "UITableView+property.h"
#import "DYBNoticeDetailViewController.h"

static CGFloat WindowHeight = 150;
static CGFloat ImageHeight  = 150;
static CGFloat ImageOffset  = 100;//WindowHeight和ImageHeight的偏移参数
static CGFloat ImageWidth  = 320.0;

@interface DYBPersonalHomePageViewController ()
{
    BOOL _b_isMyHome,_b_couldAccess/*是否可访问*/;
    UIView *_v_tabbar/*底部*/;
    int _imgType/*从手机相册返回的图片用于什么用途 0:头像 1:背景图*/;
    DYBPhotoEditorView *_photoEditor;
    
    BOOL creatNoDetail;//输入账号密码登陆时在CREATE_VIEWS消息里调1号接口,自动登陆后在WILL_APPEAR消息调1号接口,就这2种登陆节奏
}
@end

@implementation DYBPersonalHomePageViewController
DEF_SIGNAL(ATUILABLEACTION)
@synthesize d_model=_d_model,b_isInMainPage=_b_isInMainPage,user=_user;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS])
    {
        
//        MagicRequest *request = [DYBHttpMethod setstatus_list:@"0" max_id:@"" last_id:@"0" num:@"10" page:[NSString stringWithFormat:@"%d", _tbv._page=1] type:@"1" userid:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
//        [request setTag:2];
        
        [self observeNotification:[DYBPhotoEditorView DOSAVEIMAGE]];
        
        [self observeNotification:[UIViewController AutoRefreshTbvInViewWillAppear]];
        
        if (!_d_model)
        {
            self.d_model=[NSDictionary dictionaryWithObjectsAndKeys:SHARED.curUser.name,@"name",SHARED.curUser.userid,@"userid", nil];
        }
        
        _b_isMyHome=([[_d_model objectForKey:@"userid"] intValue]==[SHARED.curUser.userid intValue]);
        
        {//self.view上盖的一层,也是封面的父视图;  支持多图
            _scr_All  = [[MagicUIScrollView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, self.view.bounds.size.height)];
            _scr_All.backgroundColor                  = [UIColor clearColor];
            _scr_All.showsHorizontalScrollIndicator   = NO;
            _scr_All.showsVerticalScrollIndicator     = NO;
            
//            NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"ballpark1.png"],
//                               [UIImage imageNamed:@"ballpark2.png"],
//                               [UIImage imageNamed:@"ballpark3.png"],
//                               [UIImage imageNamed:@"ballpark4.png"],
//                               nil];
//            
//            int  tag = 0;
//            for (UIImage *image in images) {
//                UIImageView *imageView  = [[UIImageView alloc] initWithImage:image];
//                imageView.frame = CGRectMake(ImageWidth*tag, 0, ImageWidth, ImageHeight);
//                imageView.tag = tag + 10;
//                tag++;
//                [_scr_All addSubview:imageView];
//            }
            
            _scr_All.contentSize = CGSizeMake(/*[images count]**/ImageWidth, self.view.bounds.size.height);
            [self.view addSubview:_scr_All];
            RELEASE(_scr_All);
            
            _imgV_show = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, 0, _scr_All.frame.size.width, ImageHeight)
                                                  backgroundColor:[UIColor clearColor]
                                                            image:nil
                                            isAdjustSizeByImgSize:NO
                                           userInteractionEnabled:YES
                                                    masksToBounds:NO
                                                     cornerRadius:-1
                                                      borderWidth:-1
                                                      borderColor:nil
                                                        superView:_scr_All
                                                        Alignment:-1
                                                      contentMode:UIViewContentModeScaleAspectFill
                                 stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            [_imgV_show setImgWithUrl:_user.background_pic defaultImg:no_pic_50];
            RELEASE(_imgV_show);
            
//            WindowHeight=ImageHeight-ImageOffset;
            
        }
        
        {
            _scr_showImgBack = [[MagicUIScrollView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
            _scr_showImgBack.backgroundColor = [UIColor clearColor];
            _scr_showImgBack.pagingEnabled = YES;
            _scr_showImgBack.showsVerticalScrollIndicator = NO;
            _scr_showImgBack.showsHorizontalScrollIndicator = NO;
            _scr_showImgBack.contentSize = CGSizeMake(ImageWidth, ImageHeight);
            [_scr_showImgBack addSignal:[UIView TAP] object:nil];
            _scr_showImgBack.tag=9;
            [_scr_showImgBack retain];
            
            UIView *iconBg = [[UIView alloc] initWithFrame:CGRectMake(10, (ImageHeight - 30), 80, 40)];
            [iconBg setBackgroundColor:[UIColor clearColor]];
            [iconBg addSignal:[UIView TAP] object:nil];
            [iconBg setTag:7];
            iconBg.layer.masksToBounds=YES;
            iconBg.layer.cornerRadius=CGRectGetWidth(iconBg.frame)/2;
            [_scr_showImgBack addSubview:iconBg];
            RELEASE(iconBg);

        }
        
        [self initTabbar];

        [self creatTbv];
        
        {//HTTP请求 用户详情
            if (![_d_model objectForKey:@"userid"])
            {
                creatNoDetail = YES;
            }
            if (!creatNoDetail)
            {
                MagicRequest *request = [DYBHttpMethod user_detail:[_d_model objectForKey:@"userid"] isAlert:NO receive:self];
                [request setTag:1];
            }
            
        }
        
//        {//DYBPersonalHomePageViewController 监听 刷新事件
//            DYBFriendsViewController *con=[[[DYBUITabbarViewController sharedInstace].containerView viewControllers]objectAtIndex:2];
//            [self addObserverObj:con forKeyPath:@"b_isAutoRefreshTbvInViewWillAppear" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:[con class]];
//            
//        }
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        if (!_b_isInMainPage) {
            [self backImgType:10];
        }else{
            [self backImgType:4];
        }
        
        [self.headview setTitle:[_d_model objectForKey:@"name"]];
        [self.headview setTitleColor:ColorWhite];
        self.headview.backgroundColor=[MagicCommentMethod color:0 green:0 blue:0 alpha:0.2];
//        _tbv.v_headerVForHide=self.headview;
        self.headview.lineView.hidden=YES;
        
        if (!_bt_sendDynamic && _b_isMyHome) {//发动态
            UIImage *img= [UIImage imageNamed:@"grzy_2"];
            _bt_sendDynamic = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.headview.frame.size.width-img.size.width/2, 0, img.size.width/2, img.size.height/2)];
            _bt_sendDynamic.backgroundColor=[UIColor clearColor];
            _bt_sendDynamic.tag=-10;
            [_bt_sendDynamic addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_sendDynamic setImage:img forState:UIControlStateNormal];
            [_bt_sendDynamic setImage:img forState:UIControlStateHighlighted];
            [self.headview addSubview:_bt_sendDynamic];
            _bt_sendDynamic.showsTouchWhenHighlighted=YES;
            [_bt_sendDynamic changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_sendDynamic);
        }
        
//        [self layoutImage];
//        [self updateOffsets];
        
        if (_tbv._b_isAutoRefresh) {//刷新心情
            [_tbv release_muA_differHeightCellView];
            [_tbv reloadData];
            _tbv._b_isAutoRefresh=NO;
        }
        
        if ([_d_model count] == 0)
        {
            self.d_model=[NSDictionary dictionaryWithObjectsAndKeys:SHARED.curUser.name,@"name",SHARED.curUser.userid,@"userid", nil];
        }
        
        _b_isMyHome=([[_d_model objectForKey:@"userid"] intValue]==[SHARED.curUser.userid intValue]);
        
        if (creatNoDetail || self.b_isAutoRefreshTbvInViewWillAppear)
        {
            MagicRequest *request = [DYBHttpMethod user_detail:[_d_model objectForKey:@"userid"] isAlert:NO receive:self];
            [request setTag:1];
            creatNoDetail = NO;
            
            self.b_isAutoRefreshTbvInViewWillAppear=NO;
        }
        
        DLogInfo(@"WILL_APPEAR=================================");
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        
//        [self dealloc_observer];
        
        [self unobserveAllNotification];
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
//        RELEASE(_v_tabbar);
        
        [_tbv release_muA_differHeightCellView];
        
        REMOVEFROMSUPERVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}

- (void)handleViewSignal_DYBPersonalHomePageViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBPersonalHomePageViewController ATUILABLEACTION]])
    {
        NSDictionary *dic = (NSDictionary *)[signal object];
        
        DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
        vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"username"], @"name", [dic objectForKey:@"userid"], @"userid", nil];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }
}

-(void)creatTbv{
    if (_tbv) {
        REMOVEFROMSUPERVIEW(_tbv);//避免刷新时tbv不释放导致cell没彻底释放
    }
    
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:self.view.bounds isNeedUpdate:YES];
        _tbv._cellH=65;
        [_tbv setTableViewType:DTableViewSlime];
        [self.view addSubview:_tbv];
        _tbv.backgroundColor=[UIColor clearColor];//248 248 255
        _tbv.tag=-1;
        _tbv.i_pageNums=10;
        _tbv._page=1;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        //        _tbv.muA_allSectionKeys=[[NSMutableArray alloc]initWithObjects:@"0",@"1" ,nil];
        _tbv.muA_singelSectionData=[[NSMutableArray alloc]initWithObjects:/*[[NSNull alloc]init]*/ _scr_showImgBack ,((!_user)?([[NSNull alloc]init]):(_user)), nil];
        //        _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSMutableArray arrayWithObjects:@"", nil],@"0",_tbv.muA_singelSectionData,@"1", nil];
        
        [_tbv reloadData:YES];
        
        RELEASE(_tbv);
        
        _tbv.v_headerVForHide=self.headview;
        _tbv.v_headerVForHide._originFrame=CGRectMake(CGRectGetMinX(self.headview.frame), CGRectGetMinY(self.headview.frame), CGRectGetWidth(self.headview.frame), CGRectGetHeight(self.headview.frame));
        _tbv.v_footerVForHide=_v_tabbar;
        
        [self.view bringSubviewToFront:_v_tabbar];
        [self.view bringSubviewToFront:self.headview];

    }
    
}

#pragma mark- 初始化无数据提示view
-(void)initNoDataView
{
    UIImage *img=[UIImage imageNamed:@"ybx_big"];
    UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self.view Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    [imgV setFrame:CGRectMake(CGRectGetMinX(imgV.frame), CGRectGetMinY(imgV.frame)-50, CGRectGetWidth(imgV.frame), CGRectGetHeight(imgV.frame))];
    RELEASE(imgV);
    
    {
        MagicUILabel *lb=[[MagicUILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame)+20, 0, 0)];
        lb.backgroundColor=[UIColor clearColor];
        lb.textAlignment=NSTextAlignmentLeft;
        lb.font=[DYBShareinstaceDelegate DYBFoutStyle:20];
        lb.text=@"该主页设置了访问权限";
        lb.textColor=ColorGray;
        lb.numberOfLines=1;
        lb.lineBreakMode=NSLineBreakByWordWrapping;
        [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(self.view.frame), 1000)];
        [self.view addSubview:lb];
        [lb changePosInSuperViewWithAlignment:0];
        
        //        lb.linesSpacing=20;
        //        [lb setNeedCoretext:YES];
        RELEASE(lb);
    }
    
    [self.view addSignal:[UIView TAP] object:nil];
    
}

#pragma mark- 拉伸封面
-(void)stretchShowImg
{
    CGFloat yOffset   = _tbv.contentOffset.y;
    CGFloat xOffset   = _scr_showImgBack.contentOffset.x;
    
    if (yOffset < 0) {
        
        CGFloat pageWidth = _scr_showImgBack.frame.size.width;
        int page = /*向下取整*/floor((_scr_showImgBack.contentOffset.x - pageWidth / 2) / pageWidth) + 1;//_scr_showImgBack加多张图时算第几页
        
        UIImageView *imgTmp=_imgV_show;
        //                for (UIView *view in _scr_All.subviews) {
        //                    if ([view isKindOfClass:[UIImageView class]]) {
        //                        if (view.tag == 10+ page) {
        //                            imgTmp = (UIImageView*)view;
        //                        }
        //                    }
        //                }
        
        CGFloat factor = ((ABS(yOffset)+ ImageHeight )*ImageWidth)/ ImageHeight;
        
        CGRect f = CGRectMake((-(factor-ImageWidth)/2) + CGRectGetWidth(_scr_showImgBack.frame) *page, 0, ImageWidth, ImageHeight);
        f.size.height = ImageHeight+ABS(yOffset);
        f.size.width = factor;
        imgTmp.frame = f;
        
        CGRect frame = _scr_All.frame;
        frame.origin.y = 0;
        _scr_All.frame = frame;
    } else {
        _scr_All.contentOffset = CGPointMake(xOffset, yOffset);
    }
}

#pragma mark- 创建底部tabbar
-(void)initTabbar
{
    if (!_v_tabbar && !_b_isMyHome) {
        _v_tabbar=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-50-kH_StateBar, CGRectGetWidth(self.view.frame), 50)];
        _v_tabbar.backgroundColor=[MagicCommentMethod color:255 green:255 blue:255 alpha:0.9];
        _v_tabbar.layer.shadowColor=ColorBlack.CGColor;
        _v_tabbar.layer.shadowOffset=CGSizeMake(0, -1);
        
        [self.view addSubview:_v_tabbar];
        RELEASE(_v_tabbar);
        
        {
            UIImage *img=[UIImage imageNamed:@"txtbox_shadow"];
            UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, -(img.size.height/2), (img.size.width/2), (img.size.height/2)) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_tabbar Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            [_v_tabbar addSubview:imgV];
            RELEASE(imgV);
        }
    }
    
    if (_v_tabbar && !_bt_AddFriends) {//
        UIImage *img= [UIImage imageNamed:@"add_friend_def"];
        _bt_AddFriends = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2)];
        _bt_AddFriends.backgroundColor=[UIColor clearColor];
        _bt_AddFriends.tag=-12;
        [_bt_AddFriends addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
        [_bt_AddFriends setImage:img forState:UIControlStateNormal];
        [_bt_AddFriends setImage:[UIImage imageNamed:@"add_friend_press"] forState:UIControlStateHighlighted];
        [_v_tabbar addSubview:_bt_AddFriends];
        _bt_AddFriends.showsTouchWhenHighlighted=YES;
        [_bt_AddFriends changePosInSuperViewWithAlignment:1];
        RELEASE(_bt_AddFriends);
    }
    
    if (_v_tabbar && !_bt_sendPriLetter) {//
        UIImage *img= [UIImage imageNamed:@"msg_def"];
        _bt_sendPriLetter = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2)];
        _bt_sendPriLetter.backgroundColor=[UIColor clearColor];
        _bt_sendPriLetter.tag=-13;
        [_bt_sendPriLetter addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
        [_bt_sendPriLetter setImage:img forState:UIControlStateNormal];
        [_bt_sendPriLetter setImage:[UIImage imageNamed:@"msg_press"] forState:UIControlStateHighlighted];
        [_v_tabbar addSubview:_bt_sendPriLetter];
        _bt_sendPriLetter.showsTouchWhenHighlighted=YES;
        [_bt_sendPriLetter changePosInSuperViewWithAlignment:2];
        RELEASE(_bt_sendPriLetter);
    }
    
    if (_v_tabbar && !_bt_refresh) {//
        UIImage *img= [UIImage imageNamed:@"refresh_def"];
        _bt_refresh = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_v_tabbar.frame)-img.size.width/2, 0, img.size.width/2, img.size.height/2)];
        _bt_refresh.backgroundColor=[UIColor clearColor];
        _bt_refresh.tag=-14;
        [_bt_refresh addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
        [_bt_refresh setImage:img forState:UIControlStateNormal];
        [_bt_refresh setImage:[UIImage imageNamed:@"refresh_press"] forState:UIControlStateHighlighted];
        [_v_tabbar addSubview:_bt_refresh];
        _bt_refresh.showsTouchWhenHighlighted=YES;
        [_bt_refresh changePosInSuperViewWithAlignment:1];
        RELEASE(_bt_refresh);
    }
    
    switch ([_user.isfriend intValue]) {//isfriend ： 是否是好友 0否 1是 2我发过好友请求 3对方发过好友请求
        case 0://加好友|加关注
        {
            if ([_user.canfriend intValue]==0) {//不能加好友,只能加关注
                if ([_user.isfollow isEqualToString:@"1"]) {//已经关注了
                    [_bt_AddFriends setImage:[UIImage imageNamed:@"delete_care_def"] forState:UIControlStateNormal];
                    [_bt_AddFriends setImage:[UIImage imageNamed:@"delete_care_press"] forState:UIControlStateHighlighted];
                    _bt_AddFriends.enabled=YES;
                }else{//未关注,可以加关注
                    [_bt_AddFriends setImage:[UIImage imageNamed:@"add_care_def"] forState:UIControlStateNormal];
                    [_bt_AddFriends setImage:[UIImage imageNamed:@"add_care_press"] forState:UIControlStateHighlighted];
                    _bt_AddFriends.enabled=YES;                }
                
            }else if ([_user.canfriend intValue]==1)//可以加好友
            {
                [_bt_AddFriends setImage:[UIImage imageNamed:@"add_friend_def"] forState:UIControlStateNormal];
                [_bt_AddFriends setImage:[UIImage imageNamed:@"add_friend_press"] forState:UIControlStateHighlighted];
                _bt_AddFriends.enabled=YES;
            }
            
        }
            break;
        case 1://删好友(已经是好友)
        {
            [_bt_AddFriends setImage:[UIImage imageNamed:@"delete_friend_def"] forState:UIControlStateNormal];
            [_bt_AddFriends setImage:[UIImage imageNamed:@"delete_friend_press"] forState:UIControlStateHighlighted];
            
            _bt_AddFriends.enabled=YES;
        }
            break;
        case 2://我发过好友请求.
        {
            //            _bt_refresh.enabled=NO;
            [_bt_AddFriends setImage:[UIImage imageNamed:@"waiting_friend"] forState:UIControlStateNormal];
            [_bt_AddFriends setImage:[UIImage imageNamed:@"waiting_friend"] forState:UIControlStateHighlighted];
            
            _bt_AddFriends.enabled=NO;
        }
            break;
        case 3://对方发过好友请求,@"message_applyfriend" 同意被加为好友,图片用 add_friend_def,点了加好友后直接调同意接口
        {
            if ([_user.canfriend intValue]==1)//可以加好友
            {
                [_bt_AddFriends setImage:[UIImage imageNamed:@"add_friend_def"] forState:UIControlStateNormal];
                [_bt_AddFriends setImage:[UIImage imageNamed:@"add_friend_press"] forState:UIControlStateHighlighted];
                _bt_AddFriends.enabled=YES;
            }
        }
            break;
        default:
            break;
    }
    
}


#pragma mark- 接受tbv信号

static NSString *cellName = @"cellName";//

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSInteger section = [[dict objectForKey:@"section"] integerValue];
        
        if ([tableView isOneSection]) {/*一个section模式*/
            NSNumber *s = [NSNumber numberWithInteger:tableView.muA_singelSectionData.count];
            [signal setReturnValue:s];
        }else if(tableView.muA_allSectionKeys.count>section){
            NSString *key = [tableView.muA_allSectionKeys objectAtIndex:section];
            NSArray *array = [tableView.muD_allSectionValues objectForKey:key];
            NSNumber *s = [NSNumber numberWithInteger:array.count];
            [signal setReturnValue:s];
        }
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if ([tableView isOneSection]) {/*一个section模式*/
            NSNumber *s = [NSNumber numberWithInteger:1];
            [signal setReturnValue:s];
        }else{
            NSNumber *s = [NSNumber numberWithInteger:tableView.muA_allSectionKeys.count];
            [signal setReturnValue:s];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath  暂时把每个cell保存,后期有时间优化为只保存高度,返回cell时再异步计算cell的视图,目前刷新后所有cell的view都要重新创建
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        NSMutableArray *arr_curSectionForCell=nil;
        NSMutableArray *arr_curSectionForModel=nil;
        
        if (![tableView isOneSection]) {//
            //多section时 _muA_differHeightCellView变成2维数组,第一维是 有几个section,第二维是每个section里有几个cell
            if (!tableView._muA_differHeightCellView) {
//                tableView._muA_differHeightCellView=[[NSMutableArray alloc]initWithCapacity:[tableView.muD_allSectionValues allKeys].count];
                tableView._muA_differHeightCellView=[NSMutableArray arrayWithCapacity:[tableView.muD_allSectionValues allKeys].count];
            }
            
            if (tableView._muA_differHeightCellView.count==0) {
                for (int i=0; i<[tableView.muD_allSectionValues allKeys].count; i++) {
                    [tableView._muA_differHeightCellView addObject:[[NSMutableArray alloc]initWithCapacity:3]];
                }
            }
            
            //保存cell的当前section对应的array
            arr_curSectionForCell=(((NSMutableArray *)([tableView._muA_differHeightCellView objectAtIndex:indexPath.section])));
            
            //保存数据模型的当前section对应的array
            arr_curSectionForModel=[tableView.muD_allSectionValues objectForKey:[tableView.muA_allSectionKeys objectAtIndex:indexPath.section]];
        }
        
        if(indexPath.row==((([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)).count/*只创建没计算过的cell*/) || !tableView._muA_differHeightCellView || ((([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)).count/*只创建没计算过的cell*/)==0)
        {
            
            DYBCellForPersonalHomePage *cell = [[[DYBCellForPersonalHomePage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[(([tableView isOneSection])?(tableView.muA_singelSectionData):(arr_curSectionForModel)) objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if (!tableView._muA_differHeightCellView) {
//                tableView._muA_differHeightCellView=[[NSMutableArray alloc]initWithCapacity:[tableView.muD_allSectionValues allKeys].count];
                tableView._muA_differHeightCellView=[NSMutableArray arrayWithCapacity:[tableView.muD_allSectionValues allKeys].count];
            }
            
            if (![(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) containsObject:cell]) {
                [(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) addObject:cell];
            }
            
            NSNumber *s = [NSNumber numberWithInteger:cell.frame.size.height];
            [signal setReturnValue:s];
            
        }else{//之前计算过的cell
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForPersonalHomePage *)[(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
            [signal setReturnValue:s];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if ([tableView isOneSection]) {/*一个section模式*/
        }else{
            [self createSectionHeaderView:signal];
        }
        
    }//
    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
    {
        
        [signal setReturnValue:[NSNumber numberWithFloat:0]];
        
    }
    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell  只返回显示的cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if ([tableView isOneSection]) {/*一个section模式*/
            cell=((UITableViewCell *)[tableView._muA_differHeightCellView objectAtIndex:indexPath.row]);
        }else{
            //保存cell的当前section对应的array
            NSMutableArray *arr_curSectionForCell=(((NSMutableArray *)([tableView._muA_differHeightCellView objectAtIndex:indexPath.section])));
            cell=((UITableViewCell *)[arr_curSectionForCell objectAtIndex:indexPath.row]);
        }
        
        [signal setReturnValue:cell];
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        

    }
    else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"scrollView"];
        [self stretchShowImg];
        
        {//刷新回顶部bt
            if (_tbv.contentOffset.y>CGRectGetHeight(self.view.frame)) {
                if (!_bt_backToTop) {//
                    UIImage *img= [UIImage imageNamed:@"grzy_11"];
                    _bt_backToTop = [[MagicUIButton alloc] initWithFrame:CGRectMake(img.size.width/6-5, CGRectGetMaxY(self.view.frame)-img.size.height/2-45-5, img.size.width/2, img.size.height/2)];
                    _bt_backToTop.backgroundColor=[UIColor clearColor];
                    _bt_backToTop.tag=-11;
                    [_bt_backToTop addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                    [_bt_backToTop setImage:img forState:UIControlStateNormal];
                    //            [_bt_backToTop setImage:img forState:UIControlStateHighlighted];
                    [self.view addSubview:_bt_backToTop];
                    RELEASE(_bt_backToTop);
                }
                
                
            }else if (_tbv.contentOffset.y<10) {
                REMOVEFROMSUPERVIEW(_bt_backToTop);
            }
        }
        
    }
    else if ([signal is:[MagicUITableView TABLESECTIONINDEXTITLESFORTABLEVIEW]])//右侧索引列表
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if (![tableView isOneSection]) {/*多个section模式*/
            //            [signal setReturnValue:tableView.muA_allSectionKeys];
        }
    }else if ([signal is:[MagicUITableView TABLESECTIONFORSECTIONINDEXTITLE]])//点击右测是索引列表上的某个字母时回调,参数index和title是 右侧索引列表上被点击的字母在 索引列表的下标和名字,返回被点击的字母对应的section的下标
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSString *title = [dict objectForKey:@"title"];
        
        //在数据源的下标
        NSInteger count = 0;
        
        for(NSString *character in tableview.muA_allSectionKeys)
        {
            if([character isEqualToString:title])
            {
                [signal setReturnValue:[NSNumber numberWithInteger:count]];
                break;
            }
            count ++;
        }
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        {//HTTP请求,私信列表
            
            
            //最后一个model可能是 年月cell,也可能是 保存动态cell的数组
            id lastObj=[_tbv.muA_singelSectionData lastObject];
            NSString *str_id=nil;
            
            if ([lastObj isKindOfClass:[status class]]) {
                str_id=[NSString stringWithFormat:@"%d",((status *)lastObj).id];
            }else{//上个model是数组
                lastObj=[lastObj lastObject];
                str_id=[NSString stringWithFormat:@"%d",((status *)lastObj).id];
            }
            
            MagicRequest *request = [DYBHttpMethod setstatus_list:nil max_id:@"0" last_id:str_id num:[NSString stringWithFormat:@"%d",tableView.i_pageNums] page:[NSString stringWithFormat:@"%d", ++_tbv._page] type:@"1" userid:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
            [request setTag:3];
            
//            if (!request) {//无网路
//                [tableView reloadData:NO];
//            }
        }
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
//        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        {//HTTP请求
            
            MagicRequest *request = [DYBHttpMethod user_detail:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
            [request setTag:1];
            
            MagicRequest *request2 = [DYBHttpMethod noCacheSetstatus_list:@"0" max_id:@"" last_id:@"0" num:@"10" page:[NSString stringWithFormat:@"%d", _tbv._page=1] type:@"1" userid:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
            [request2 setTag:2];
            
            if (!request) {//无网路
                //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
            }
        }
        
//        for (status *model in tableView.muA_singelSectionData) {
//            if ([model isKindOfClass:[status class]]&&model.type==0) {//动态列表
//                MagicRequest *request = [DYBHttpMethod setstatus_list:nil max_id:[NSString stringWithFormat:@"%d",model.id] last_id:@"0" num:[NSString stringWithFormat:@"%d",tableView.i_pageNums] page:[NSString stringWithFormat:@"%d", _tbv._page=1] type:@"1" userid:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
//                [request setTag:2];
//                break;
//            }
//         } 
        
    
    }
    
    else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
        [_tbv StretchingUpOrDown:0];
        [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        [_tbv StretchingUpOrDown:1];
        [[DYBUITabbarViewController sharedInstace] hideTabBar:NO animated:YES];
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIERELOADOVER]])//reload完毕
    {
        //        NSDictionary *dict = (NSDictionary *)[signal object];
        //        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        //        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        //        [_v_inputV.textV becomeFirstResponder];
    }
}

#pragma mark- 创建sectionHeaderView
-(void)createSectionHeaderView:(MagicViewSignal *)signal
{
    NSDictionary *dict = (NSDictionary *)[signal object];
    UITableView *tableView = [dict objectForKey:@"tableView"];
    NSInteger section = [[dict objectForKey:@"section"] integerValue];
    
    switch (section) {
        case 0:
        {
            UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, WindowHeight)];
            v.backgroundColor=[UIColor redColor];
            //            RELEASE(v);
            [signal setReturnValue:v];
            
        }
            break;
        case 1:
        {
            UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 190)];
            v.backgroundColor=[MagicCommentMethod color:255 green:255 blue:255 alpha:1];
            
            //            if(!_imgV_head){//头像
            //                UIImage *img=[UIImage imageNamed:@"no_pic_50.png"];
            //                _imgV_head = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, 0, 80,80) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:v Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            //                _imgV_head.center=CGPointMake(v.center.x, 0);
            //                RELEASE(_imgV_head);
            //            }
            
            //    {
            //        MagicUILabel *lb_title=[[MagicUILabel alloc]initWithFrame:CGRectMake(15,0, 0, 0)];
            //        lb_title.backgroundColor=[UIColor clearColor];
            //        lb_title.textAlignment=NSTextAlignmentLeft;
            //        lb_title.font=[DYBShareinstaceDelegate DYBFoutStyle:20];
            //        lb_title.text=[_tbv_friends_myConcern_RecentContacts.muA_allSectionKeys objectAtIndex:section];
            //        [lb_title setNeedCoretext:NO];
            //        lb_title.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
            //        lb_title.numberOfLines=1;
            //        lb_title.lineBreakMode=NSLineBreakByCharWrapping;
            //        [lb_title sizeToFitByconstrainedSize:CGSizeMake(screenShows.size.width-20, 100)];
            //        [v addSubview:lb_title];
            //        [lb_title changePosInSuperViewWithAlignment:1];
            //        RELEASE(lb_title);
            //    }
            
            
            [signal setReturnValue:v];
        }
        default:
            break;
    }
    
    
    //    [v release];
}


//#pragma mark - Parallax effect

//更新_imageScroller的contentOffset
//- (void)updateOffsets {
//    CGFloat yOffset   = _tbv.contentOffset.y;
//    CGFloat threshold/*img最大伸展度*/ = ImageHeight - WindowHeight;
//    
//    if (yOffset > -threshold && yOffset < 0) {
//        _scrollV.contentOffset = CGPointMake(0.0, floorf(yOffset / 2.0));
//    } else if (yOffset < 0) {
//        _scrollV.contentOffset = CGPointMake(0.0, yOffset + floorf(threshold / 2.0));
//    } else {
//        _scrollV.contentOffset = CGPointMake(0.0, yOffset);
//    }
//}

//#pragma mark - View Layout
//重新布局img
//- (void)layoutImage
//{
//    CGFloat imageWidth   = _scrollV.frame.size.width;
//    CGFloat imageYOffset = floorf((WindowHeight  - ImageHeight) / 2.0);
//    CGFloat imageXOffset = 0.0;
//    
//    _imgV_show.frame             = CGRectMake(imageXOffset, imageYOffset, imageWidth, ImageHeight);
//    _scrollV.contentSize   = CGSizeMake(imageWidth, self.view.bounds.size.height);
//    _scrollV.contentOffset = CGPointMake(0.0, 0.0);
//}

#pragma makr -
#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        if (_b_isInMainPage) {
            DYBUITabbarViewController *dync = [DYBUITabbarViewController sharedInstace];
            [dync scrollMainView:1];
        }else{//在二级页面直接pop
            [self.drNavigationController popViewControllerAnimated:YES];
        }
        
    }
    
}

- (void)back
{
    if (_b_isInMainPage) {
        DYBUITabbarViewController *dync = [DYBUITabbarViewController sharedInstace];
        [dync scrollMainView:1];
    }else{//在二级页面直接pop
        [self.drNavigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal{
    if ([signal is:[UIView TAP]]) {
        UIView *v=signal.source;
        switch (v.tag) {
            case -1://心情
            {
                if (_b_couldAccess && _b_isMyHome) {
                    DYBSignViewController *con=[[DYBSignViewController alloc]init];
                    [self.drNavigationController pushViewController:con animated:YES animationType:ANIMATION_TYPE_REVEAL];
                    RELEASE(con);
                }
                
            }
                break;
            case 1://展开day视图
            {
                NSDictionary *d=(NSDictionary *)signal.object;
                DYBCellForPersonalHomePage *cell=(DYBCellForPersonalHomePage *)[d objectForKey:@"object"];
                
                [cell spreadOrShrinkDayView];
            }
                break;
            case 2://收缩day视图
            {
                NSDictionary *d=(NSDictionary *)signal.object;
                DYBCellForPersonalHomePage *cell=(DYBCellForPersonalHomePage *)[d objectForKey:@"object"];
                
                [cell spreadOrShrinkDayView];
            }
                break;
            case 3://点赞
            {
                NSDictionary *d = (NSDictionary *)[signal object];
                status *model=[d objectForKey:@"object"];
                
                DYBDynamicDetailViewController *vc = [[DYBDynamicDetailViewController alloc] init:[model retain] withStatus:2 bScroll:YES];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
            }
                break;
            case 4://点评论
            {
                NSDictionary *d = (NSDictionary *)[signal object];
                status *model=[d objectForKey:@"object"];
                
                DYBDynamicDetailViewController *vc = [[DYBDynamicDetailViewController alloc] init:[model retain] withStatus:1 bScroll:YES];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
            }
                break;
            case 5://正常进入动态详情
            {
                NSDictionary *d = (NSDictionary *)[signal object];
                status *model=[d objectForKey:@"object"];
                
                if (model.type==8) {//通知详情
                    DYBNoticeDetailViewController *vc = [[DYBNoticeDetailViewController alloc] init];
                    vc.str_noticeID=[NSString stringWithFormat:@"%d",model.id];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }else{
                    DYBDynamicDetailViewController *vc = [[DYBDynamicDetailViewController alloc] init:[model retain] withStatus:1 bScroll:NO];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                
               
            }
                break;
            case 6://点动态cell的图片
            {                
                NSDictionary *dic = (NSDictionary *)[signal object];
                status *_status = (status *)([[dic objectForKey:@"object"] objectForKey:@"status"]);
                
                NSMutableArray *_arrPic = [[NSMutableArray alloc] init];
                
                if ([_status.isfollow isEqualToString:@"1"]) {
                    for (NSDictionary *dic in _status.status.pic_array) {
                        [_arrPic addObject:[dic objectForKey:@"pic"]];
                    }
                }else{
                    for (NSDictionary *dic in _status.pic_array) {
                        [_arrPic addObject:[dic objectForKey:@"pic"]];
                    }
                }
                
                DLogInfo(@"点动态cell的图片=================================");
                DYBCheckMultiImageViewController *vc = [[DYBCheckMultiImageViewController alloc] initWithMultiImage:_arrPic nCurSel:[([[dic objectForKey:@"object"] objectForKey:@"tag"]) intValue]];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
                RELEASEDICTARRAYOBJ(_arrPic);
                
            }
                break;
            case 7://修改头像
            {
                if (_b_isMyHome) {
                    UIActionSheet *actionView = [[[UIActionSheet alloc]initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"立刻拍照" otherButtonTitles:@"手机相册",@"查看头像", nil] autorelease];
                    actionView.tag=1;
                    [actionView showInView:self.view];
                }
                
            }
                break;
            case 8://进入 发送祝福列表
            {
                DYBSendWishViewController *vc = [[DYBSendWishViewController alloc] init];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
            }
                break;
            case 9://换封面
            {
                if (_b_isMyHome) {
                    UIActionSheet *actionView = [[[UIActionSheet alloc]initWithTitle:@"修改背景" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"立刻拍照" otherButtonTitles:@"手机相册",@"查看背景", nil] autorelease];
                    actionView.tag=2;
                    [actionView showInView:self.view];
                }
                
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://立即拍照
        {
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self.drNavigationController presentModalViewController:imagePicker animated:YES];
                [imagePicker release];
                //                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyBoard) name:@"photoShowKeyBoard" object:nil];
                _imgType=actionSheet.tag-1;
            }
            
            
        }
            break;
        case 1://手机相册
        {
            
            //            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            //            imagePicker.delegate = self;
            //            [self.drNavigationController presentModalViewController:imagePicker animated:YES];
            //            [imagePicker release];
            
            {
                
                DYBImagePickerController *_imgPicker = [[DYBImagePickerController alloc] init];
                [_imgPicker setFather:self];
                _imgPicker.delegate = self;
                _imgPicker.allowsMultipleSelection = NO;//是否是多图上传
                _imgPicker.limitsMaximumNumberOfSelection = YES;// 最大图片数量
                _imgPicker.maximumNumberOfSelection = 1;
                [self.drNavigationController pushViewController:_imgPicker animated:YES];
                
                _imgType=actionSheet.tag-1;
                //                RELEASE(_imgPicker);
            }
            
        }
            break;
        case 2:{//查看
            {
                switch (actionSheet.tag) {
                    case 1://头像
                    {
                        NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:0];
                        DYBCellForPersonalHomePage *cell=(DYBCellForPersonalHomePage *)[_tbv cellForRowAtIndexPath:index];
                        
                        DYBCheckImageViewController *vc = [[DYBCheckImageViewController alloc] initWithImage:cell.imgV_head.image];
                        vc.bIsNeedDeleBt=NO;
                        [self.drNavigationController pushViewController:vc animated:YES];
                        RELEASE(vc);
                    }
                        break;
                    case 2://皮肤
                    {
                        DYBCheckImageViewController *vc = [[DYBCheckImageViewController alloc] initWithImage:_imgV_show.image];
                        vc.bIsNeedDeleBt=NO;
                        [self.drNavigationController pushViewController:vc animated:YES];
                        RELEASE(vc);
                    }
                        break;
                    default:
                        break;
                }
                
            }
        }
            break;
    }
}

- (void)imagePickerController: (UIImagePickerController *)picker
didFinishPickingMediaWithInfo: (NSDictionary *)info
{
    if([picker isKindOfClass:[DYBImagePickerController class]]){
        {
//            [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(timeForAction:) userInfo:[info objectForKey:@"UIImagePickerControllerOriginalImage"] repeats:NO];
            [self timeForAction:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
        }
        
        //        [self dismissViewControllerAnimated:YES completion:NULL];
        //    [self.drNavigationController dismissModalViewControllerAnimated:NO];
        [self.drNavigationController popToViewcontroller:((DYBUITabbarViewController *)[self.drNavigationController getViewController:[DYBUITabbarViewController class]]) animated:YES];
    }else if ([picker isKindOfClass:[UIImagePickerController class]]){
        
        _photoEditor = [[DYBPhotoEditorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.bounds.size.height)];
        _photoEditor.ntype = 2;

        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
        if (((UIImagePickerController *)picker).sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将拍到的图片保存到相册
        }
        
        if ((((UIImagePickerController *)picker).sourceType == UIImagePickerControllerSourceTypeCamera)) {
            [self manageImage:image];
            
        }
        
        [_photoEditor.imgRootView setCenter:CGPointMake(160.0f,self.view.bounds.size.height/2-25)];
        
        _photoEditor.imgRootView.image = _photoEditor.curImage;
        [self.view addSubview:_photoEditor];
        
        [DYBUITabbarViewController sharedInstace].containerView.tabBar.hidden=YES;
        [DYBUITabbarViewController sharedInstace].v_totalNumOfUnreadMsg.hidden=YES;
        
        [self.drNavigationController dismissViewControllerAnimated:YES completion:NULL];
        
        RELEASE(_photoEditor);

    }
    
}

//线程的方法
- (void)timeForAction:/*(id)sender*/ (UIImage *)img{
//    NSTimer *t = (NSTimer *)sender;
    UIImage *object = /*t.userInfo*/ img;
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:object];
    
    [DYBUITabbarViewController sharedInstace].containerView.tabBar.hidden=NO;
    
    NSMutableDictionary  *params=nil;
    switch (_imgType) {
        case 0://换头像
        {
            params = [DYBHttpInterface user_uploadavatar];
            NSData *data = [self zipImg:imgView.image];
            
            DYBRequest *request1 = [[DYBRequest alloc]init];
            NSArray *a = @[data];
            MagicRequest *request = [request1 DYBPOSTIMG:params isAlert:YES receive:self imageData:a];
            [request setTag:4];
            
        }
            break;
        case 1://换皮肤
        {
            params = [DYBHttpInterface user_setbackground:@"1" tag:@"1"];
            NSData *data = [self zipImg:imgView.image];
            
            DYBRequest *request1 = [[DYBRequest alloc]init];
            NSArray *a = @[data];
            MagicRequest *request = [request1 DYBPOSTIMG:params isAlert:YES receive:self imageData:a];
            [request setTag:13];
        }
            break;
        default:
            break;
    }
}

//修改个性头像最后一步
- (void)changeOwnIcon:(NSString *)picId{
    
    MagicRequest *request = [DYBHttpMethod user_setavatar:picId isAlert:YES receive:self];
    
    [request setTag:5];
    
}


-(void)manageImage:(UIImage*)image{
    
    float ratX = image.size.width/320;
    float ratY = image.size.height/self.view.bounds.size.height;
    float lastRat =  1;
    
    if (ratX>ratY) {
        lastRat = ratX;
        [_photoEditor.imgRootView setFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, image.size.height*320/image.size.width)];
        UIImage *smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(self.view.bounds.size.width*2, image.size.height*320/image.size.width*2) interpolationQuality:kCGInterpolationDefault];
        _photoEditor.curImage = smallImage;
        
    }else{
        lastRat = ratY;
        [_photoEditor.imgRootView setFrame:CGRectMake(0.0f, 0.0f, image.size.width*self.view.bounds.size.height/image.size.height, self.view.bounds.size.height)];
        UIImage *smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(image.size.width*self.view.bounds.size.height/image.size.height*2, self.view.bounds.size.height*2) interpolationQuality:kCGInterpolationDefault];
        _photoEditor.curImage = smallImage;
        
    }
    
    _photoEditor.imgRootView.contentMode = UIViewContentModeScaleAspectFit;
    
}

#pragma mark- 通知中心回调
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification is:[DYBPhotoEditorView DOSAVEIMAGE]]){
        
        NSDictionary *dic = (NSDictionary *)[notification userInfo];
        NSInteger nType = [[dic objectForKey:@"type"] intValue];
        if (nType != 2) {
            return;
        }
        
        UIImage *img = (UIImage*)[notification object];
//        img=[[UIImage alloc]ini];
//        [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(timeForAction:) userInfo:img repeats:NO];
        [self timeForAction:img];
        
    }else if ([notification is:[UIViewController AutoRefreshTbvInViewWillAppear]]){
        self.b_isAutoRefreshTbvInViewWillAppear=YES;
    }
}


#pragma mark- 接受按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        if (bt)
        {
            switch (bt.tag) {
                case -1://好友
                {
//                    if ([_user.friend_num intValue]==0) {
//                        return;
//                    }
                    DYBFriendsViewController *vc = [[DYBFriendsViewController alloc] init];
                    [vc setIsPush:YES];
                    vc.str_userid=[_d_model objectForKey:@"userid"];
                    
//                    {//vc 监听 刷新事件
//                        //                        DYBPersonalHomePageViewController *con=[[[DYBUITabbarViewController sharedInstace].containerView viewControllers]objectAtIndex:4];
//                        [vc addObserverObj:self forKeyPath:@"b_isAutoRefreshTbvInViewWillAppear" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:[self class]];
//                        
//                    }
                    
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                    
                }
                    break;
                    
                case -2://访客
                {
                    DYBVisitorViewController *vc = [[DYBVisitorViewController alloc] init];
                    vc.d_model=_d_model;
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                case -3://相册
                {
                    
                    DYBPersonalPhotoViewController *vc = [[DYBPersonalPhotoViewController alloc] init];
                    vc.str_userid=[_d_model objectForKey:@"userid"];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                case -4://资料
                {
                    DYBPersonalProfileViewController *vc = [[DYBPersonalProfileViewController alloc] init];
                    vc.model=_user;
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                case -5://生日提醒
                {
                    DYBBirthdayReminderViewController *vc = [[DYBBirthdayReminderViewController alloc] init];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                case -6://顶
                {
                    {//HTTP请求
                        
                        MagicRequest *request = [DYBHttpMethod user_avatartop:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
                        [request setTag:6];
                        
                        if (!request) {//无网路
                            //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                    
                    _user.i_playTop_stampTag=1;
                    {//HTTP请求
                        
                        MagicRequest *request = [DYBHttpMethod user_detail:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
                        [request setTag:1];
                        
                        if (!request) {//无网路
                            //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                }
                    break;
                case -7://踩
                {
                    {//HTTP请求
                        
                        MagicRequest *request = [DYBHttpMethod user_avatartread:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
                        [request setTag:7];
                        
                        if (!request) {//无网路
                            //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                }
                    break;
                case -8://顶 的人数区域
                case -9://踩 的人数区域
                {
                    DYBTop_StampListViewController *vc = [[DYBTop_StampListViewController alloc] init];
                    if (bt.tag==-8) {
                        vc.type=0;
                    }else{
                        vc.type=1;
                        
                    }
                    vc.str_userid=_user.userid;
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                case -10://发动态
                {
                    DYBPublishViewController *vc = [[DYBPublishViewController alloc] init:nil activeid:nil bActive:NO];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                    
                }
                    break;
                case -11://回顶部
                {
                    [_tbv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    
                    REMOVEFROMSUPERVIEW(_bt_backToTop);
                }
                    break;
                case -12://加删好友|加删关注|同意被加好友
                {
                    if ([_user.isfriend isEqualToString:@"1"] || [_user.isfriend isEqualToString:@"3"]) {//是否是好友 0否 1是 2我发过好友请求 3对方发过好友请求
                        switch ([_user.isfriend intValue]) {//是好友
//                            case 0://不是好友, 可以 加好友|加关注
//                            {
//                                {//HTTP请求
//                                    
//                                    MagicRequest *request = [DYBHttpMethod message_reqfriend:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
//                                    [request setTag:12];
//                                    
//                                    if (!request) {//无网路
//                                        //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
//                                    }
//                                }
//                            }
//                                break;
                            case 1://删好友
                            {
                                if ([_user.isfriend isEqualToString:@"1"]) {
                                    [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要解除好友关系？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
                                }else if ([_user.canfriend isEqualToString:@"0"])//
                                {
                                    [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要解除关注关系？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
                                }
                            }
                                break;
                            case 3://对方发过好友请求,@"message_applyfriend" 同意被加为好友
                            {
                                {//HTTP请求
                                    
                                    MagicRequest *request = [DYBHttpMethod message_applyfriend:[_d_model objectForKey:@"userid"] op:@"1" isAlert:YES receive:self];
                                    [request setTag:14];
                                }
                            }
                                break;
                            default:
                                break;
                        }
                    }else if ([_user.isfriend isEqualToString:@"0"])//不是 好友, 加删好友|关注操作
                    {
                        if ([_user.canfriend intValue]==0) {//是否能加好友 0只能加关注 1能加好友
                            if ([_user.isfollow intValue]==0) {//是否已关注 0否 1是
                                {//HTTP请求 加关注
                                    
                                    MagicRequest *request = [DYBHttpMethod message_reqfriend:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
                                    [request setTag:12];
                                    
                                    if (!request) {//无网路
                                        //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
                                    }
                                }
                            }else{//取消关注
                                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要解除关注关系？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
                            }
                        }else if ([_user.canfriend intValue]==1){//加好友
                            {//HTTP请求
                                
                                MagicRequest *request = [DYBHttpMethod message_reqfriend:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
                                [request setTag:12];
                                
                                if (!request) {//无网路
                                    //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
                                }
                            }
                        }
                    }
                   
                    
                }
                    break;
                case -13://发私信
                {
                    {
                        DYBSendPrivateLetterViewController *vc = [[DYBSendPrivateLetterViewController alloc] init];
                        vc.model=[NSDictionary dictionaryWithObjectsAndKeys:_user.userid,@"userid",_user.name,@"name",_user.pic,@"pic", nil];
                        [self.drNavigationController pushViewController:vc animated:YES];
                        RELEASE(vc);
                    }
                }
                    break;
                case -14://刷新
                {
                    {//HTTP请求
                        
                        MagicRequest *request = [DYBHttpMethod user_detail:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
                        [request setTag:1];
                        
                        if (!request) {//无网路
                            //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                    
//                    {//动态列表
//                        MagicRequest *request = [DYBHttpMethod setstatus_list:nil max_id:nil last_id:@"0" num:[NSString stringWithFormat:@"%d",_tbv.i_pageNums] page:[NSString stringWithFormat:@"%d", _tbv._page=1] type:@"1" userid:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
//                        [request setTag:2];
//                    }
                }
                    break;
                case -15:
                {
                    DLogInfo(@"");
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}

- (void)handleViewSignal_UIImageView:(MagicViewSignal *)signal
{
    if ([signal is:[UIImageView SDWEBIMGDOWNSUCCESS]]) {
        UIImage *img=(UIImage *)signal.object;
        ImageHeight=img.size.height;
        
    }
    
}

#pragma mark- 选择提示框按键回调
-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        {//HTTP请求
            
            MagicRequest *request = [DYBHttpMethod user_delfriend:nil oneId:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
            [request setTag:15];
        }
        
    }
}

#pragma mark- 刷新cell里的头像等UI
-(void)refreshUI{
    NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:0];
    DYBCellForPersonalHomePage *cell=(DYBCellForPersonalHomePage *)[_tbv cellForRowAtIndexPath:index];
    //    [cell setContent:_user indexPath:index tbv:_tbv];
//    [cell refreshUi:_user tbv:_tbv];
    [cell.imgV_head setImgWithUrl:_user.pic_b defaultImg:no_pic_50];
}

#pragma mark- 观察者要实现此响应方法
- (void) observeValueForKeyPath:(NSString *)keyPath
					   ofObject:(id)object/*被观察者*/
						 change:(NSDictionary *)change
						context:(void *)context/*观察者class*/{
    Class class=(Class)context;
    NSString *className=[NSString stringWithCString:object_getClassName(class) encoding:NSUTF8StringEncoding];
    
    if ([className isEqualToString:[NSString stringWithCString:object_getClassName([self class]) encoding:NSUTF8StringEncoding]]) {
        self.b_isAutoRefreshTbvInViewWillAppear=[[change objectForKey:@"new"] boolValue];
        
    }else{//将不能处理的 key 转发给 super 的 observeValueForKeyPath 来处理
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
    
}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取当前主页显示的用户信息
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([[response.data objectForKey:@"access"] isEqualToString:@"1"]) {//有访问权限
                        _b_couldAccess=YES;
                        int i=_user.i_playTop_stampTag;
                        if (_user) {
                            RELEASE(_user);
                        }
                        _user=[user JSONReflection:[response.data objectForKey:@"user"]];
                        [_user retain];
                        _user.i_playTop_stampTag=i;
                        
                        [self.headview setTitle:_user.name];
                        [_tbv.muA_singelSectionData replaceObjectAtIndex:1 withObject:_user];
                        
//                        [_imgV_show setImgWithUrl:_user.background_pic defaultImg:no_pic_50];
                        [self initTabbar];
                        

                        
                        BOOL b=NO;
//                        for (id model in _tbv.muA_singelSectionData) {
//                            if ([model isKindOfClass:[NSMutableArray class]]) {
//                                for (status *ob in model) {
//                                    if ([ob isKindOfClass:[status class]]&&ob.type==0) {//动态列表
//                                        MagicRequest *request = [DYBHttpMethod setstatus_list:nil max_id:[NSString stringWithFormat:@"%d",ob.id] last_id:@"0" num:[NSString stringWithFormat:@"%d",_tbv.i_pageNums] page:[NSString stringWithFormat:@"%d", _tbv._page=1] type:@"1" userid:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
//                                        [request setTag:2];
//                                        b=YES;
//                                        break;
//                                    }
//                                }
//                            }
//                           
//                        
//                        }
                        
                        if (!b) {
                            {//动态列表
                                MagicRequest *request = [DYBHttpMethod setstatus_list:@"0" max_id:@"" last_id:@"0" num:@"10" page:[NSString stringWithFormat:@"%d", _tbv._page=1] type:@"1" userid:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
                                [request setTag:2];
                            }
                        }
                        
                    }else{
                        
                        //                        [_tbv release_muA_differHeightCellView];
                        //                        [_tbv releaseDataResource];
                        //                        [_tbv reloadData];
                        
                        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-self.headHeight)];
                        v.backgroundColor=[UIColor whiteColor];
                        [self.view addSubview:v];
                        RELEASE(v);
                        
                        [self backImgType:0];
                        [self.headview setTitleColor:ColorBlack];
                        [self.headview setTitle:[_d_model objectForKey:@"name"]];
                        self.headview.backgroundColor=[MagicCommentMethod color:248 green:248 blue:248 alpha:1];
                        
                        [self initNoDataView];
                    }
                }else if ([response response] ==khttpfailCode){
                    
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back) userInfo:nil repeats:NO];
                    
                }

            }
                
                break;
                
            case 2://获取|刷新 动态列表
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"status"];
                    if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                        
                        [_tbv release_muA_differHeightCellView];
                        
                        [_tbv releaseDataResource];
                        
                        [self creatTbv];
                        
                        _tbv.muA_singelSectionData=[[NSMutableArray alloc]initWithObjects:/*[[NSNull alloc]init]*/ _scr_showImgBack,((!_user)?([[NSNull alloc]init]):(_user)), nil];
                        
                    }
                    
                    [_imgV_show setImgWithUrl:_user.background_pic defaultImg:no_pic_50];//避免 动态列表没出来前,顶部展示图加载后其高度太高超过 1号cell
                    
                    if ([[response.data objectForKey:@"haveBirthday"] intValue]==1 && _tbv.muA_singelSectionData.count>0 && [[_d_model objectForKey:@"userid"] isEqualToString:SHARED.curUser.userid]) {//有生日提醒cell
                        status *temp=[[status alloc]init];
                        temp.type=-2;
                        temp.content=@"最近有人要过生日了呦~";
                        [_tbv.muA_singelSectionData insertObject:temp atIndex:2];
                        RELEASE(temp);
                    }
                    
                    int month=-1,day=-1,index=0;
                    NSMutableArray *arr=nil;
                    for (NSDictionary *d in list) {
                        status *model = [status JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                        }else{
                            
                            if([NSString getDateComponentsByTimeStamp:[model.time intValue]].month!=month){  //如果前一个model的月份和此model月份不一样,数据源里要先加一个显示年月份的model,再加此model,已和cell的顺序一致
                                month=[NSString getDateComponentsByTimeStamp:[model.time intValue]].month;
                                status *temp=[[status alloc]init];
                                temp.time=model.time;
                                temp.type=-1;
                                temp.id=model.id;
                                [_tbv.muA_singelSectionData addObject:temp];
                                RELEASE(temp);
                            }
                            
                            if ([NSString getDateComponentsByTimeStamp:[model.time intValue]].day!=day) {//如果前一个model的日和此model日不一样,数据源里要一个保存所有此日model的数组,后边的model.day如果和此日一样,则被加到此数组里,已和cell的结构顺序一致,一个非 年月的cell就是 一个day里发的所有动态model
                                RELEASE(arr);
                                arr=[NSMutableArray arrayWithObject:model];
//                                RELEASE(model);
                                [arr retain];
                                day=[NSString getDateComponentsByTimeStamp:[model.time intValue]].day;
                                [_tbv.muA_singelSectionData addObject:arr];
                                
                            }else{
                                
                                if (!arr) {
                                    arr=[NSMutableArray arrayWithObject:model];
                                    [arr retain];
                                }else{
                                    [arr addObject:model];
                                }
                            }
                            
                        }
                    }
                    
                    {
                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                            //                            [self creatTbv];
                            //                            [self initSectionOrder:_muA_data_friends tbv:_tbv_friends_myConcern_RecentContacts];
                            //                            [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            
                            {//避免有 好友等数据但没动态数据的用户刷新不到 好友等数据
                                [_tbv release_muA_differHeightCellView];
                                
                                [_tbv releaseDataResource];
                                
                                _tbv.muA_singelSectionData=[[NSMutableArray alloc]initWithObjects:/*[[NSNull alloc]init]*/ _scr_showImgBack,((!_user)?([[NSNull alloc]init]):(_user)), nil];
                            }
                            
                            if(_tbv.muA_singelSectionData.count==2){//添加无数据提示cell
                                status *temp=[[status alloc]init];
                                temp.type=-3;
                                temp.content=(_b_isMyHome)?(@"三日不发动态, 面目可憎"):(@"这个人太懒了,什么都没有留下");
                                [_tbv.muA_singelSectionData insertObject:temp atIndex:2];
                                RELEASE(temp);
                            }
                            [_tbv reloadData:YES];
                        }
                        
                    }
                    
                    
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                
                //                [_tbv.footerView changeState:PULLSTATEEND];
                
            }
                break;
            case 3://加载更多
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"status"];
                    
                    //上一个model可能是 年月cell,也可能是 保存动态cell的数组
                    id lastObj=[_tbv.muA_singelSectionData lastObject];
                    int month=-1,day=-1;
                    
                    NSMutableArray *arr=nil;
                    
                    if ([lastObj isKindOfClass:[status class]]) {//上个model是年月cell
                        month=[NSString getDateComponentsByTimeStamp:[((status *)lastObj).time intValue]].month;
                    }else{//上个model是数组
                        arr=[_tbv.muA_singelSectionData lastObject];

                        lastObj=[lastObj lastObject];
                        month=[NSString getDateComponentsByTimeStamp:[((status *)lastObj).time intValue]].month;
                        day=[NSString getDateComponentsByTimeStamp:[((status *)lastObj).time intValue]].day;
                        
                    }
//                    NSMutableArray *arr=nil;
                    
                    BOOL isRefreshLastCell;//是否刷新上页最后一个cell,因为第二页的新model也加到那个cell里了
                    
                    for (NSDictionary *d in list) {
                        status *model = [status JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            [self creatTbv];
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                        }else{
                            
                            if([NSString getDateComponentsByTimeStamp:[model.time intValue]].month!=month ){  //如果前一个model的月份和此model月份不一样,数据源里要先加一个显示年月份的model,再加此model,已和cell的顺序一致
                                
                                month=[NSString getDateComponentsByTimeStamp:[model.time intValue]].month;
                                status *temp=[[status alloc]init];
                                temp.time=model.time;
                                temp.type=-1;
                                temp.id=model.id;
                                [_tbv.muA_singelSectionData addObject:temp];
                                RELEASE(temp);
                                
                            }
                            
                            //                            [_tbv.muA_singelSectionData addObject:model];
                            
                            if ([NSString getDateComponentsByTimeStamp:[model.time intValue]].day!=day) {//如果前一个model的日和此model日不一样,数据源里要一个保存所有此日model的数组,后边的model.day如果和此日一样,则被加到此数组里,已和cell的结构顺序一致,一个非 年月的cell就是 一个day里发的所有动态model
                                if (arr &&[[_tbv.muA_singelSectionData lastObject] isKindOfClass:[NSArray class]] &&![arr isEqualToArray:[_tbv.muA_singelSectionData lastObject]]) {//避免释放 [_tbv.muA_singelSectionData lastObject]
                                    RELEASE(arr);
                                }
                                arr=[NSMutableArray arrayWithObject:model];
                                [arr retain];
                                day=[NSString getDateComponentsByTimeStamp:[model.time intValue]].day;
                                [_tbv.muA_singelSectionData addObject:arr];
                                
                            }else{
                                
//                                [arr addObject:model];
//                                if (!arr) {//下页的model.day=上页最后一个cell.day; 即下页的数据也是上页最后一个cell里的同一天的model
//                                    arr=[NSMutableArray arrayWithObject:model];
//                                    [arr retain];
//                                    
//                                    day=[NSString getDateComponentsByTimeStamp:[model.time intValue]].day;
//                                    [_tbv.muA_singelSectionData addObject:arr];
//                                }else
                                {
                                    [arr addObject:model];
                                    if ([[_tbv.muA_singelSectionData lastObject] isKindOfClass:[NSArray class]]&&[arr isEqualToArray:[_tbv.muA_singelSectionData lastObject]]) {//上页的最后cell的数组加新model
                                        isRefreshLastCell=YES;
                                    }
                                }
                            }
                        }
                    }
                    
                    {//加载更多
                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                            
                            if (isRefreshLastCell) {//若增加的model.day==_tbv._muA_differHeightCellView.lastObject.model.day,得刷新cell,已加长cell
                                DYBCellForPersonalHomePage *cell=_tbv._muA_differHeightCellView.lastObject;
                                if (cell.superview) {//6个 显示出来的cell不能释放
                                    [cell removeFromSuperview];
                                }else{
                                    //                RELEASE(cell);
                                }
                                
                                [cell removeAllSignal];
                                
                                for (int i=cell.retainCount; --i>=2;) {//把cell的retainCount减到2,已在tbv reloadData 后 释放_tbv._muA_differHeightCellView.lastObject
                                    RELEASE(cell);
                                }
                                
                                if (cell.retainCount==2) {
//                                    RELEASE(cell);
                                    [_tbv._muA_differHeightCellView removeLastObject];
                                }
                                cell=nil;
                            }
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
                        }
                        
                    }
                    
                    
                    return;
                    
                }else if ([response response] ==khttpfailCode)
                {
                    
                }
                
                
//                [_tbv.footerView changeState:PULLSTATEEND];
                
                
            }
                break;
                
            case 4://上传头像图片
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSString *urlString = [response.data objectForKey:@"id"];
                    [self changeOwnIcon:urlString];
                }else if ([response response] ==khttpfailCode)
                {
                    
                }
            }
                break;
                
            case 5://换头像
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSString *urlString = [response.data objectForKey:@"pic_s"];
                    //                        urlString=@"http://10.21.3.30:30080/userphoto/weibo/7/44/3827_o/1.jpg";
                    [_user setPic:urlString];
                    [_user setPic_b:[response.data objectForKey:@"pic_b"]];
                    [_user setPic_s:urlString];
                    [SHARED.curUser setPic:urlString];
                    [SHARED.curUser setPic_b:[response.data objectForKey:@"pic_b"]];
                    [SHARED.curUser setPic_s:urlString];
                    
                    
//                    {
//                        [_tbv release_muA_differHeightCellView];
//                        [_tbv reloadData];
//                    }
                    
                    [self refreshUI];
                    
//                    [self postNotification:[NSObject ChangeImg] withObject:nil];
                    
                    //                        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeUserImage" object:[response.data objectForKey:@"pic_s"]];//更换头像时把裁剪好的大小图片作为通知对象发出去
                    //                        [_imgV_head setImageWithURL:[NSURL URLWithString:urlString]];
                }else if ([response response] ==khttpfailCode)
                {
                    
                }
            }
                break;
            case 6://用户头像的顶
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    user_avatartop__user_avatartread *model = [user_avatartop__user_avatartread JSONReflection:response.data];
                    
                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                    [pop setDelegate:self];
                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                    [pop setText:model.content4c];
                    [pop alertViewAutoHidden:3 isRelease:YES];
                    
                    _user.i_playTop_stampTag=1;
                    
                    {//HTTP请求
                        
                        MagicRequest *request = [DYBHttpMethod user_detail:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
                        [request setTag:1];
                        
                        if (!request) {//无网路
                            //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                    
                }else if ([response response] ==khttpfailCode)
                {
                    //                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                    //                    [pop setDelegate:self];
                    //                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                    //                    [pop setText:response.message];
                    //                    [pop alertViewAutoHidden:3 isRelease:YES];
                }
                
                
                
            }
                break;
            case 7://用户头像的踩
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    user_avatartop__user_avatartread *model = [user_avatartop__user_avatartread JSONReflection:response.data];
                    
                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                    [pop setDelegate:self];
                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                    [pop setText:model.content4c];
                    [pop alertViewAutoHidden:3 isRelease:YES];
                    
                    _user.i_playTop_stampTag=1;
                    
                    {//HTTP请求
                        
                        MagicRequest *request = [DYBHttpMethod user_detail:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
                        [request setTag:1];
                        
                        if (!request) {//无网路
                            //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                    
                }else if ([response response] ==khttpfailCode)
                {
                    //                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                    //                    [pop setDelegate:self];
                    //                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                    //                    [pop setText:response.message];
                    //                    [pop alertViewAutoHidden:3 isRelease:YES];
                }
                
                
                
            }
                break;
            case 8://用户头像的顶踩记录列表user_avatardolist
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    
                }else if ([response response] ==khttpfailCode)
                {
                    
                }
                
                
                
            }
                break;
            case 12://添加好友或关注 
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSString *req = [response.data objectForKey:@"req"];//添加 好友|关注的结果                    
                    if ([req intValue]==1) {   //添加 好友|关注的结果
                        
                        if ([_user.canfriend isEqualToString:@"1"]) {//添加好友操作成功
                            
                            if ([_user.isfriend isEqualToString:@"3"]) {//对方发过好友请求
                                _user.isfriend=@"1";
                                
                                {
                                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                                    [pop setDelegate:self];
                                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                                    [pop setText:@"同意被添加好友"];
                                    [pop alertViewAutoHidden:.5f isRelease:YES];
                                }
                            }else if([_user.isfriend isEqualToString:@"0"]){//0否 1是 2我发过好友请求 3对方发过好友请求
                                _user.isfriend=@"2";
                                
                                {
                                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                                    [pop setDelegate:self];
                                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                                    [pop setText:@"好友申请已发送"];
                                    [pop alertViewAutoHidden:.5f isRelease:YES];
                                }
                            }
                          
                            
                        }else if([_user.canfriend isEqualToString:@"0"]){//添加关注操作成功
                            _user.isfollow=@"1";
                            {
                                MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                                [pop setDelegate:self];
                                [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                                [pop setText:@"添加关注成功"];
                                [pop alertViewAutoHidden:.5f isRelease:YES];
                            }
                        }
                        
                        [self initTabbar];
                    }
                    
                }else if ([response response] ==khttpfailCode)
                {
                    
                }
                
                
                
            }
                break;
            case 13://换皮肤
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    {//HTTP请求 用户详情
                        
                        MagicRequest *request = [DYBHttpMethod user_detail:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
                        [request setTag:1];
                        
                        if (!request) {//无网路
                            //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                    
//                    {//动态列表
//                        MagicRequest *request = [DYBHttpMethod setstatus_list:nil max_id:nil last_id:@"0" num:@"10" page:[NSString stringWithFormat:@"%d", _tbv._page] type:@"1" userid:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
//                        [request setTag:2];
//                    }
                }else if ([response response] ==khttpfailCode)
                {
                    
                }
            }
                break;
            case 14://同意被添加好友
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([[response.data objectForKey:@"apply"] isEqualToString:@"1"]) {//成功
                        
                        _user.isfriend=@"1";
                        [self initTabbar];
                        
                        {
                            MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                            [pop setDelegate:self];
                            [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                            [pop setText:@"同意被添加好友成功"];
                            [pop alertViewAutoHidden:.5f isRelease:YES];
                        }
                        
                    }
                }else if ([response response] ==khttpfailCode)
                {
                    
                }
                
                
            }
                break;
            case 15://删除 好友|关注
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSString *result = [response.data objectForKey:@"result"];//删除 好友|关注 的结果
                    
                        if([result intValue]==1){
                            if ([_user.isfriend intValue]==1) {  //0否 1是 2我发过好友请求 3对方发过好友请求
                                _user.isfriend=0;
                                {
                                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                                    [pop setDelegate:self];
                                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                                    [pop setText:@"删除好友成功"];
                                    [pop alertViewAutoHidden:.5f isRelease:YES];
                                }
                            }else if ([_user.isfriend intValue]==0){
                                _user.isfollow=@"0";
                                {
                                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                                    [pop setDelegate:self];
                                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                                    [pop setText:@"删除关注成功"];
                                    [pop alertViewAutoHidden:.5f isRelease:YES];
                                }
                            }
//                            [self initTabbar];
                            {//HTTP请求
                                
                                MagicRequest *request = [DYBHttpMethod user_detail:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
                                [request setTag:1];
                                
                                if (!request) {//无网路
                                    //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
                                }
                            }
                            
                            {
//                                for (NSDictionary *d in self._array_targets) {//观察自己的对象信息
//                                    DYBFriendsViewController *con=[d objectForKey:@"b_isAutoRefreshTbvInViewWillAppear"];
//                                    con.b_isAutoRefreshTbvInViewWillAppear=YES;
//                                }
//                                DYBFriendsViewController *con=[self getObserverBykeyPath:@"b_isAutoRefreshTbvInViewWillAppear"];
//                                con.b_isAutoRefreshTbvInViewWillAppear=YES;
                                
//                                self.b_isAutoRefreshTbvInViewWillAppear=YES;
                                [self postNotification:[UIViewController AutoRefreshTbvInViewWillAppear] withObject:Nil userInfo:Nil];

                            }
                    }
                    
                }else if ([response response] ==khttpfailCode)
                {
                    
                }
                
                
                
            }
                break;
            default:
                break;
        }
    }
}


@end
