//
//  DYBUITabbarViewController.m
//  DYiBan
//
//  Created by NewM on 13-8-29.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBUITabbarViewController.h"
#import "DYBBaseViewLeftView.h"

#import "DYBDataBankDownloadManageViewController.h"
#import "DYBDynamicViewController.h"
#import "DYBMsgViewController.h"
#import "DYBFriendsViewController.h"
#import "DYBSearchFriendsViewController.h"
#import "DYBUITabbarViewController.h"
#import "DYBSettingViewController.h"

#import "DYBDataBankListController.h"
#import "DYBDataBankSearchViewController.h"
#import "DYBDataBankShareViewController.h"
#import "NSObject+KVO.h"

#import "DYYBClassHomePageViewController.h"
#import "DYBPersonalHomePageViewController.h"
#import "DYBCheckInMainViewController.h"
#import "DYBApplicationViewController.h"

#import "DYBRegisterStep2ViewController.h"
#import "NSObject+MagicDatabase.h"
#import "DYBMyNotesViewController.h"
#import "DYBTabViewController.h"
#import "DYBShareInNotesViewController.h"
#import "DYBNoteDetailViewController.h"
#import "WOSPreferentialCardViewController.h"

#import "WOSAddrViewController.h"
#import "WOSCollectViewController.h"

#import "WOSHomeViewController.h"
#import "WOSOrderLostViewController.h"
#import "WOSPersonInfoViewController.h"
@interface DYBUITabbarViewController ()
{
    MagicUIThirdView *threeview;//三屏的view
    DYBBaseViewLeftView *view;
    
    NSInteger selectBtIndex;//左边视图选择的bt
    
    CGFloat leftViewWidth;
}

@end

@implementation DYBUITabbarViewController
@synthesize vc = _vc,v_totalNumOfUnreadMsg=_v_totalNumOfUnreadMsg;

DEF_SIGNAL(HIDDENBUTTONACTION)

-(MagicUIThirdView *)getThreeview{
    return threeview;
}

- (void)dealloc
{
    RELEASEVIEW(view)
    RELEASEVIEW(_containerView);
    RELEASEVIEW(threeview);
    [super dealloc];
}
static DYBUITabbarViewController *sharedInstace = nil;
+ (DYBUITabbarViewController *)sharedInstace
{
    if (!sharedInstace)
    {
        sharedInstace = [[DYBUITabbarViewController alloc] init];
    }

    return sharedInstace;
}

//释放自己
- (void)clearSelf
{
    [sharedInstace release];
    sharedInstace = nil;
    
}

- (id)init:(MagicViewController *)dVc
{
    self.vc = dVc;
    
    return [self initDync];
}

- (id)initDync
{
    NSArray *vcImgArr = [self initDynBarParams];
    
    selectBtIndex = 0;
    
    return [self initWithViewControllers:[vcImgArr objectAtIndex:0] imageArray:[vcImgArr objectAtIndex:1] reduceHeight:0.f];
}

- (id)initBank
{
    NSArray *vcImgArr = [self initDataBankParams];
    
    
    return [self initWithViewControllers:[vcImgArr objectAtIndex:0] imageArray:[vcImgArr objectAtIndex:1] reduceHeight:0.f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setVCBackAnimation:SWIPELASTIMAGEBACKTYPE canBackPageNumber:0];
}

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr reduceHeight:(CGFloat)reduceHeight barHeight:(CGFloat)barHeight withClass:(Class)clazz
{
    
    leftViewWidth = 230;
    
    [self initMagicUITabBarView:vcs imageArray:arr reduceHeight:reduceHeight barHeight:barHeight withClass:clazz];
    
    threeview = [[MagicUIThirdView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [threeview setUserInteractionEnabled:YES];
    [threeview setLeftWidth:leftViewWidth];
    
    [sharedInstace initLeftView];
    [threeview setViewType:MagicUILeftView];
    [self.view addSubview:threeview];
    
    MagicUIImageView *lineImg = [[MagicUIImageView alloc] initWithFrame:CGRectMake(-5, 0, 5, 640)];
    [lineImg setImage:[UIImage imageNamed:@"bg_shadow.png"]];
    [threeview.firstView addSubview:lineImg];
    RELEASE(lineImg);

    
    [threeview.firstView addSubview:_containerView];
    
    
    self.selectedIndex = 0;
    
    return self;
}

MagicUIButton *hiddenView;
- (void)handleNoVerity
{

    if ([SHARED.curUser.verify isEqualToString:@"0"] && !hiddenView) {
        
        hiddenView = [[MagicUIButton alloc] initWithFrame:CGRectMake(65, 0, self.view.frame.size.width-65, 50)];
        hiddenView.backgroundColor = [UIColor clearColor];
        [hiddenView addSignal:[DYBUITabbarViewController HIDDENBUTTONACTION] forControlEvents:UIControlEventTouchUpInside];
        
        [_containerView.tabBar addSubview:hiddenView];
        RELEASE(hiddenView);
    }
}

//创建左试图
- (void)initLeftView
{
    
    [self handleNoVerity];
    
    [threeview setViewType:MagicUILeftView];
    if (threeview)
    {
        if (view)
        {
            RELEASEVIEW(view)
        }
        view = [[DYBBaseViewLeftView alloc] initWithFrame:CGRectMake(0, 0, threeview.leftWidth, CGRectGetHeight(threeview.frame))];
        
        [threeview.secondView addSubview:view];
    }
    
}

//资料库
- (NSArray *)initDataBankParams{

    
        WOSOrderLostViewController *download = [[[WOSOrderLostViewController alloc] init] autorelease];

        [download setVc:_vc];

//        DYBDataBankListController *list = [[DYBDataBankListController creatShareInstance] autorelease];
//
//        [list setVc:_vc];
//
//
//        DYBDataBankSearchViewController *search = [[DYBDataBankSearchViewController creatShare] autorelease];
//        [search setVc:_vc];
//
//
//       DYBDataBankShareViewController *share = [[[DYBDataBankShareViewController alloc]init] autorelease];
//        [share setVc:_vc];


        NSArray *arrayVC = [NSArray arrayWithObjects:download, nil];

        CGFloat tabBarY = 0;
        if (![self.drNavigationController isNavigationBarHidden])
        {
            tabBarY = [self.drNavigationController navigationbarHeight];
        }


        NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
        [imgDic setObject:[UIImage imageNamed:@"tab_files_def"] forKey:TABBARBUTDEFAULT];
        [imgDic setObject:[UIImage imageNamed:@"tab_files_high"] forKey:TABBARBUTHIGHLIGHT];
        [imgDic setObject:[UIImage imageNamed:@"tab_files_sel"] forKey:TABBARBUTSELETED];
        NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
        [imgDic2 setObject:[UIImage imageNamed:@"tab_search_def"] forKey:TABBARBUTDEFAULT];
        [imgDic2 setObject:[UIImage imageNamed:@"tab_search_high.png"] forKey:TABBARBUTHIGHLIGHT];
        [imgDic2 setObject:[UIImage imageNamed:@"tab_search_sel.png"] forKey:TABBARBUTSELETED];
        NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
        [imgDic3 setObject:[UIImage imageNamed:@"tab_share_def"] forKey:TABBARBUTDEFAULT];
        [imgDic3 setObject:[UIImage imageNamed:@"tab_share_high.png"] forKey:TABBARBUTHIGHLIGHT];
        [imgDic3 setObject:[UIImage imageNamed:@"tab_share_sel.png"] forKey:TABBARBUTSELETED];
        NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
        [imgDic4 setObject:[UIImage imageNamed:@"tab_trans_def"] forKey:TABBARBUTDEFAULT];
        [imgDic4 setObject:[UIImage imageNamed:@"tab_trans_high.png"] forKey:TABBARBUTHIGHLIGHT];
        [imgDic4 setObject:[UIImage imageNamed:@"tab_trans_sel.png"] forKey:TABBARBUTSELETED];

        NSArray *imgArr = [NSArray arrayWithObjects:imgDic,nil];

        NSArray *VCIMGArr = [NSArray arrayWithObjects:arrayVC, imgArr, nil];
        return VCIMGArr;


}

//动态页的bar的参数
- (NSArray *)initDynBarParams
{
    WOSHomeViewController *homeVC = [[[WOSHomeViewController alloc]init] autorelease];
    [homeVC setVc:_vc];
//    DYBDynamicViewController *dynVc = [[[DYBDynamicViewController alloc] init] autorelease];
//    [dynVc setVc:_vc];
    
//    DYBMsgViewController *msgVc = [[[DYBMsgViewController alloc]init] autorelease];
//    [msgVc setVc:_vc];
//    [msgVc initTotalNumOfUnreadMsgRequest];
//    
//    DYBFriendsViewController *friendVc = [[[DYBFriendsViewController alloc]init] autorelease];
//    friendVc.b_isInMainPage=YES;
//    [friendVc setVc:_vc];
//    
//    DYBSearchFriendsViewController *searchFriendVc = [[[DYBSearchFriendsViewController alloc]init] autorelease];
//    searchFriendVc.b_isInMainPage = YES;
//    [searchFriendVc setVc:_vc];
//    
//    //回来改成个人主页
//    DYBPersonalHomePageViewController *peopleVC = [[[DYBPersonalHomePageViewController alloc] init] autorelease];
//    peopleVC.b_isInMainPage=YES;
//    [peopleVC setVc:_vc];
    
    NSArray *arrayVC = [NSArray arrayWithObjects:homeVC, nil];
    
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"tab1_def"] forKey:TABBARBUTDEFAULT];
    [imgDic setObject:[UIImage imageNamed:@"tab1_high"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic setObject:[UIImage imageNamed:@"tab1_sel"] forKey:TABBARBUTSELETED];
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic2 setObject:[UIImage imageNamed:@"tab2_def"] forKey:TABBARBUTDEFAULT];
    [imgDic2 setObject:[UIImage imageNamed:@"tab2_high"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic2 setObject:[UIImage imageNamed:@"tab2_sel"] forKey:TABBARBUTSELETED];
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic3 setObject:[UIImage imageNamed:@"tab3_def"] forKey:TABBARBUTDEFAULT];
    [imgDic3 setObject:[UIImage imageNamed:@"tab3_high"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic3 setObject:[UIImage imageNamed:@"tab3_sel"] forKey:TABBARBUTSELETED];
    NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic4 setObject:[UIImage imageNamed:@"tab4_def"] forKey:TABBARBUTDEFAULT];
    [imgDic4 setObject:[UIImage imageNamed:@"tab4_high"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic4 setObject:[UIImage imageNamed:@"tab4_sel"] forKey:TABBARBUTSELETED];
    NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic5 setObject:[UIImage imageNamed:@"tab5_def"] forKey:TABBARBUTDEFAULT];
    [imgDic5 setObject:[UIImage imageNamed:@"tab5_high"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic5 setObject:[UIImage imageNamed:@"tab5_sel"] forKey:TABBARBUTSELETED];
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic, imgDic2, imgDic3, imgDic4, imgDic5,nil];
    
    
    NSArray *VCIMGArr = [NSArray arrayWithObjects:arrayVC, imgArr, nil];
    return VCIMGArr;
}

- (NSArray *)initClassParams
{
    DYYBClassHomePageViewController *classVc = [[[DYYBClassHomePageViewController alloc] init] autorelease];
    [classVc setVc:_vc];
    NSArray *arrayVC = [NSArray arrayWithObjects:classVc, nil];
    
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"tab1_def"] forKey:TABBARBUTDEFAULT];
    [imgDic setObject:[UIImage imageNamed:@"tab1_high"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic setObject:[UIImage imageNamed:@"tab1_sel"] forKey:TABBARBUTSELETED];

    NSArray *imgArr = [NSArray arrayWithObjects:imgDic, nil];
    
    
    NSArray *VCIMGArr = [NSArray arrayWithObjects:arrayVC, imgArr, nil];
    return VCIMGArr;
}

//初始化设置页面
- (NSArray *)initSettingParams
{
    DYBSettingViewController *settingVC = [[[DYBSettingViewController alloc] init] autorelease];
    [settingVC setVc:_vc];
    NSArray *arrayVC = [NSArray arrayWithObjects:settingVC, nil];
    
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"tab1_def"] forKey:TABBARBUTDEFAULT];
    [imgDic setObject:[UIImage imageNamed:@"tab1_high"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic setObject:[UIImage imageNamed:@"tab1_sel"] forKey:TABBARBUTSELETED];
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic, nil];
    
    
    NSArray *VCIMGArr = [NSArray arrayWithObjects:arrayVC, imgArr, nil];
    return VCIMGArr;
}

//初始化应用页面
- (NSArray *)initApplicationParams
{
    DYBApplicationViewController *settingVC = [[[DYBApplicationViewController alloc] init] autorelease];
    [settingVC setVc:_vc];
    NSArray *arrayVC = [NSArray arrayWithObjects:settingVC, nil];
    
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"tab1_def"] forKey:TABBARBUTDEFAULT];
    [imgDic setObject:[UIImage imageNamed:@"tab1_high"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic setObject:[UIImage imageNamed:@"tab1_sel"] forKey:TABBARBUTSELETED];
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic, nil];
    
    
    NSArray *VCIMGArr = [NSArray arrayWithObjects:arrayVC, imgArr, nil];
    return VCIMGArr;
}



//初始化签到页面
- (NSArray *)initCheckInParams{
    DYBCheckInMainViewController *checkinVC = [[[DYBCheckInMainViewController alloc] init] autorelease];
    [checkinVC setVc:_vc];
    NSArray *arrayVC = [NSArray arrayWithObjects:checkinVC, nil];
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"tab1_def"] forKey:TABBARBUTDEFAULT];
    [imgDic setObject:[UIImage imageNamed:@"tab1_high"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic setObject:[UIImage imageNamed:@"tab1_sel"] forKey:TABBARBUTSELETED];
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic, nil];
    
    
    NSArray *VCIMGArr = [NSArray arrayWithObjects:arrayVC, imgArr, nil];
    return VCIMGArr;
}

//初始化Magicuitabbarview
- (MagicUITabBarView *)initMagicUITabBarView:(NSArray *)vcs imageArray:(NSArray *)arr reduceHeight:(CGFloat)reduceHeight barHeight:(CGFloat)barHeight withClass:(Class)clazz
{
    
    if (_containerView)
    {
        RELEASEVIEW(_containerView);
    }
    
    _containerView = [[MagicUITabBarView alloc] initWithViewControllers:vcs imageArray:arr reduceHeight:reduceHeight barHeight:barHeight withClass:clazz];
    
    [_containerView.tabBar setBackgroundColor:[UIColor clearColor]];
    [_containerView setTabBarTransparent:YES];
    [_containerView.tabBar.backgroundView setImage:[UIImage imageNamed:@"bg_file_bottom"]];
    
    return _containerView;
}


- (MagicNavigationController *)drNavigationController
{
    return _vc.drNavigationController;
}
//添加资料库
- (void)addBankView
{
    
    // 设置正在下载数目
    
   
    
    
    NSArray *vcimgArr = [self initDataBankParams];
    
    [_containerView removeAllVCView];
    
    [self hideBarAndNumber:NO vcImgArr:vcimgArr];
    
//    self.selectedIndex = 3;
//    self.selectedIndex = 0;
    
    [DYBShareinstaceDelegate opeartionTabBarShow:NO animated:NO];
    
    
//    self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET(); 
//    [self addAndRefreshTotalMsgView: self.DB.resultArray.count];
    
//    [self changeMsgTotalFrame];
    
}
//添加动态页
- (void)addDynView
{
    
    
    
    NSArray *vcimgArr = [self initDynBarParams];
    [_containerView removeAllVCView];
    
    [self hideBarAndNumber:NO vcImgArr:vcimgArr];
    [DYBShareinstaceDelegate opeartionTabBarShow:NO animated:NO];
    
    //恢复 数字提示位置
    int a=(_containerView.tabBar.frame.size.width/5);//一个tab的宽
    [_v_totalNumOfUnreadMsg setFrame:CGRectMake(a*2-a/2-a/4-4, _containerView.tabBar.frame.origin.y-10, 0, 0)];
    
    
    [self handleNoVerity];

}

-(void)addCardView{

    WOSPreferentialCardViewController *card = [[WOSPreferentialCardViewController alloc]init];
    
    [card setVc:_vc];
    [self.drNavigationController pushViewController:card animated:YES];
    
    [card release];
    return;
    
    
    NSArray *vcimgArr = [self initSavePaper];
    [_containerView removeAllVCView];
    
    [self hideBarAndNumber:NO vcImgArr:vcimgArr];
    [DYBShareinstaceDelegate opeartionTabBarShow:NO animated:NO];

    
    [self handleNoVerity];

}

-(void)addColView{
    
    
    NSArray *vcimgArr = [self initCal];
    [_containerView removeAllVCView];
    
    [self hideBarAndNumber:NO vcImgArr:vcimgArr];
    [DYBShareinstaceDelegate opeartionTabBarShow:NO animated:NO];
    
    
    [self handleNoVerity];
    
}

-(NSArray *)initCal{
    WOSCollectViewController *clo = [[[WOSCollectViewController alloc]init] autorelease];

    [clo setVc:_vc];
    
    
    
    NSArray *arrayVC = [NSArray arrayWithObjects:clo,  nil];
    
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"tab_note_def"] forKey:TABBARBUTDEFAULT];
    [imgDic setObject:[UIImage imageNamed:@"tab_note_sel"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic setObject:[UIImage imageNamed:@"tab_note_sel"] forKey:TABBARBUTSELETED];
    
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic2 setObject:[UIImage imageNamed:@"tab_tag_def"] forKey:TABBARBUTDEFAULT];
    [imgDic2 setObject:[UIImage imageNamed:@"tab_tag_sel"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic2 setObject:[UIImage imageNamed:@"tab_tag_sel"] forKey:TABBARBUTSELETED];
    
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic3 setObject:[UIImage imageNamed:@"tab_share_def_note"] forKey:TABBARBUTDEFAULT];
    [imgDic3 setObject:[UIImage imageNamed:@"tab_share_sel_note"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic3 setObject:[UIImage imageNamed:@"tab_share_sel_note"] forKey:TABBARBUTSELETED];
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic,nil];
    
    
    NSArray *VCIMGArr = [NSArray arrayWithObjects:arrayVC, imgArr, nil];
    return VCIMGArr;

}

#pragma mark-添加笔记页一级页面的3个con
- (void)addNotesCon
{
    NSArray *vcimgArr = [self initNotesCon];
    [_containerView removeAllVCView];
    
    [self hideBarAndNumber:YES vcImgArr:vcimgArr];
    _containerView.tabBar.hidden = NO;
    
    [DYBShareinstaceDelegate opeartionTabBarShow:NO animated:NO];    
    
    [self handleNoVerity];
    
}

#pragma mark-初始化笔记页一级页面的3个con
- (NSArray *)initNotesCon
{
    WOSAddrViewController *myNotesVc = [[[WOSAddrViewController alloc] init] autorelease];
    [myNotesVc setVc:_vc];
    
   
    
    NSArray *arrayVC = [NSArray arrayWithObjects:myNotesVc,  nil];
    
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"tab_note_def"] forKey:TABBARBUTDEFAULT];
    [imgDic setObject:[UIImage imageNamed:@"tab_note_sel"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic setObject:[UIImage imageNamed:@"tab_note_sel"] forKey:TABBARBUTSELETED];
    
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic2 setObject:[UIImage imageNamed:@"tab_tag_def"] forKey:TABBARBUTDEFAULT];
    [imgDic2 setObject:[UIImage imageNamed:@"tab_tag_sel"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic2 setObject:[UIImage imageNamed:@"tab_tag_sel"] forKey:TABBARBUTSELETED];
    
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic3 setObject:[UIImage imageNamed:@"tab_share_def_note"] forKey:TABBARBUTDEFAULT];
    [imgDic3 setObject:[UIImage imageNamed:@"tab_share_sel_note"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic3 setObject:[UIImage imageNamed:@"tab_share_sel_note"] forKey:TABBARBUTSELETED];
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic,nil];
    
    
    NSArray *VCIMGArr = [NSArray arrayWithObjects:arrayVC, imgArr, nil];
    return VCIMGArr;
}

//添加班级
- (void)addClassView
{
    NSArray *vcimgArr = [self initClassParams];
    [_containerView removeAllVCView];
    
    [self hideBarAndNumber:YES vcImgArr:vcimgArr];
    
}

//添加设置页面
- (void)addSettingView
{
    NSArray *vcimgArr = [self initSettingParams];
    [_containerView removeAllVCView];
    
    [self hideBarAndNumber:YES vcImgArr:vcimgArr];
    
}

//添加应用页面
- (void)addApplicationView
{
    NSArray *vcimgArr = [self initApplicationParams];
    [_containerView removeAllVCView];
    
    [self hideBarAndNumber:YES vcImgArr:vcimgArr];

}

//添加签到页面
- (void)addCheckinView{
    NSArray *vcimgArr = [self initCheckInParams];
    [_containerView removeAllVCView];
    
    [self hideBarAndNumber:YES vcImgArr:vcimgArr];
}

- (void)hideBarAndNumber:(BOOL)hidden vcImgArr:(NSArray *)vcimgArr
{
    [_containerView addVCView:[vcimgArr objectAtIndex:0] imgArr:[vcimgArr objectAtIndex:1]];
   
    self.selectedIndex = 0;

    [_containerView.tabBar setHidden:hidden];
    [_v_totalNumOfUnreadMsg setHidden:hidden];
    
    [self setVCBackAnimation:SWIPELASTIMAGEBACKTYPE canBackPageNumber:0];

}

//滑动主页面type：1为左面  2为右面
- (void)scrollMainView:(int)type
{
    if (type == 1)
    {
        [threeview endMoveViewWithX:leftViewWidth];
    }
}

#pragma mark-添加|刷新 总消息数view
-(void)addAndRefreshTotalMsgView:(int)num
{
//    if (num==0 || (selectBtIndex!=0 && selectBtIndex!=3)/*只在选择了 社区||资料库 时 创建*/) {
//        if (_v_totalNumOfUnreadMsg) {
//            _v_totalNumOfUnreadMsg.hidden=YES;
//        }
//        return;
//    }
//    
//    _v_totalNumOfUnreadMsg.hidden = NO; //防止在切换中隐藏
//    
//        if (!_v_totalNumOfUnreadMsg) {
//            UIImage *img=[UIImage imageNamed:@"tabtip_bottom"];
//            int a=(_containerView.tabBar.frame.size.width/5);//一个tab的宽
//            _v_totalNumOfUnreadMsg=[[DYBUnreadMsgView alloc]initWithFrame:CGRectMake(a*2-a/2-a/4-4, _containerView.tabBar.frame.origin.y-10, 0, 0) img:img nums:[NSString stringWithFormat:@"%d",num] arrowDirect:2];
//            [_containerView addSubview:_v_totalNumOfUnreadMsg];
//            RELEASE(_v_totalNumOfUnreadMsg);
////            _containerView.tabBar.hidden=YES;
//            [_containerView.tabBar addObserverObj:_v_totalNumOfUnreadMsg forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:[MagicUITabBar class]];
//        }else{
//            UIImage *img=[UIImage imageNamed:@"tabtip_bottom"];
//            [_v_totalNumOfUnreadMsg refreshByimg:img nums:[NSString stringWithFormat:@"%d",num]];
//        }
}

-(void)changeMsgTotalFrame{

    [_v_totalNumOfUnreadMsg setFrame:CGRectMake(260, _containerView.tabBar.frame.origin.y-10, 0, 0)];
    
}

#pragma mark -
#pragma mark - DYBBaseViewLeftView
- (void)handleViewSignal_DYBBaseViewLeftView:(MagicViewSignal *)signal
{
    MagicUIButton *button = (MagicUIButton *)[signal object];
    if ([signal is:[DYBBaseViewLeftView SELECTBUTTON]])
    {
        
        NSIndexPath *indexPath = (NSIndexPath *)[signal object];
        
//        WOSPersonInfoViewController *person = [[WOSPersonInfoViewController alloc]init];
//        
//        [self.drNavigationController pushViewController:person animated:YES];
//        RELEASE(person);

//        return;
        
//        if (selectBtIndex == button.tag)
//        {
//            if (button.tag == 2 ) {
//                [threeview endMoveViewWithX:0];
//
//                return;
//            }else{
//                [threeview endMoveViewWithX:0];
//                return;
//
//            }
//        }
//        
//        [view changStatus:button.tag];
        

        selectBtIndex = button.tag;
        if (button.tag == 10) {
            //社区
            
            WOSPreferentialCardViewController *card = [[WOSPreferentialCardViewController alloc]init];
            
//            [card setVc:_vc];
            [self.drNavigationController pushViewController:card animated:YES];
            
            [card release];
            
//            [self addCardView];
        }
        else if (button.tag == 11) {
            //订单管理
            WOSOrderLostViewController *download = [[[WOSOrderLostViewController alloc] init] autorelease];
            
            [download setVc:_vc];
            [self.drNavigationController pushViewController:download animated:YES];
            
//            [download release];

            
//            [self addBankView];
        }else if (button.tag == 12) {
            //地址管理
//            [self initNotesCon];
            WOSAddrViewController *myNotesVc = [[[WOSAddrViewController alloc] init] autorelease];
            [myNotesVc setVc:_vc];
            [self.drNavigationController pushViewController:myNotesVc animated:YES];
            
            [myNotesVc release];
            

        }else if (button.tag==13){
            
            WOSCollectViewController *card = [[WOSCollectViewController alloc]init];
            [card setVc:_vc];
            [self.drNavigationController pushViewController:card animated:YES];
            [card release];

        }else if (button.tag == 14){
        
            
            DYBSettingViewController *settingVC = [[[DYBSettingViewController alloc] init] autorelease];
            [settingVC setVc:_vc];
            [self.drNavigationController pushViewController:settingVC animated:YES];
            
            [settingVC release];
            [self addSettingView];
        
        
        }
        // 收藏进
//        [threeview endMoveViewWithX:0];
    }else if ([signal is:[DYBBaseViewLeftView MAPBUTTON]]){
        [self addCheckinView];
        [threeview endMoveViewWithX:0];
        selectBtIndex = -1;
    }

}


-(NSArray *)initSavePaper{

    WOSPreferentialCardViewController *card = [[WOSPreferentialCardViewController alloc]init];
    
    [card setVc:_vc];
    
    NSArray *arrayVC = [NSArray arrayWithObjects:card,  nil];
    
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"tab_note_def"] forKey:TABBARBUTDEFAULT];
    [imgDic setObject:[UIImage imageNamed:@"tab_note_sel"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic setObject:[UIImage imageNamed:@"tab_note_sel"] forKey:TABBARBUTSELETED];
    
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic2 setObject:[UIImage imageNamed:@"tab_tag_def"] forKey:TABBARBUTDEFAULT];
    [imgDic2 setObject:[UIImage imageNamed:@"tab_tag_sel"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic2 setObject:[UIImage imageNamed:@"tab_tag_sel"] forKey:TABBARBUTSELETED];
    
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic3 setObject:[UIImage imageNamed:@"tab_share_def_note"] forKey:TABBARBUTDEFAULT];
    [imgDic3 setObject:[UIImage imageNamed:@"tab_share_sel_note"] forKey:TABBARBUTHIGHLIGHT];
    [imgDic3 setObject:[UIImage imageNamed:@"tab_share_sel_note"] forKey:TABBARBUTSELETED];
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic, imgDic2, imgDic3,nil];
    
    
    NSArray *VCIMGArr = [NSArray arrayWithObjects:arrayVC, imgArr, nil];
    return VCIMGArr;
}




#pragma mark -
#pragma mark - handleButton
- (void)handleViewSignal_DYBUITabbarViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBUITabbarViewController HIDDENBUTTONACTION]])
    {
        DYBRegisterStep2ViewController *vc = [[DYBRegisterStep2ViewController alloc] init];
        [vc setBack:YES];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }

}


@end
