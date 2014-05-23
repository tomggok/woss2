//
//  MessageDynamicViewController.m
//  Magic
//
//  Created by tom zeng on 12-11-3.
//
//
//#import "DetailNotificationViewController.h"
//#import "MainConrtrollerCell.h"
#import "MessageDynamicViewController.h"
//#import "Rrequest_Data.h"
//#import "HttpHelp.h"
#import "user.h"
//#import "Static.h"
#import "JsonResponse.h"
#import "status_list.h"
#import "status.h"
//#import "MainConrtrollerCell.h"
//#import "PullDownView.h"
//#import "errAlertView.h"
#import "LLSplitViewController.h"
//#import "YiBanDetail.h"
//#import "YiBanLocalDataManager.h"
//#import "PersonalPageImgViewController.h"
//#import "PersonalPageComingViewController.h"
//#import "PersonalPageMessageViewController.h"
#import "UIImageView+WebCache.h"
//#import "BigImageViewController.h"
//#import "YiBanHeadBarView.h"
//#import "YiBanTableView.h"
//#import "YiBanGuideView.h"
#import "AppDelegate.h"
//#import "webController.h"
//#import "Debug.h"
//#import "UIViewController+KNSemiModal.h"
//#import "connection_view.h"
#define REMOVERPHOTOVIEW  @"removePhotoView"
#define wight objectNmu*32+50 > 200 ? 200 :objectNmu*32+50  //判断班级个数，设置下拉条的高度
#define LIMITNUM 10000  //现在一共要保留多少cell


@interface MessageDynamicViewController (){
    
    int type; // 信息类型
    UIButton*   selectStye;
    BOOL isRotating; //箭头旋转
//    PullDownView *pullview;
//    YiBanHeadBarView *bar; // hard bar
    int page; // 动态页
    int pageSize; //每页大小
    BOOL isShow_top; // 点击tableview 防止点击2次的效果
    NSMutableArray * item_temp;
    int objectNmu;
    int will_delete_postion;
    
    BOOL deleteZeroDataType;//判断是否删除items的第一条为了去除重覆数据
    BOOL bZeroBanner;// 删除最后一个banner
//    YibanBanner *bannerController; // 广告栏
    NSString* showBanner; // 显示广告栏，标记，写在沙盒中
    BOOL isShowPullView;
    float tempHight;
    
    NSMutableArray *mutableItems; // 保留 id 数组
    NSMutableArray *mutableHight; // 保留高度 数组
    NSMutableDictionary *dictHight; //保留高度 字典
    NSMutableDictionary *dictView; // 保留cell view 字典
    
    NSMutableDictionary *dictTotalData; // 保留data 的总集合，，、
    
//    NSString* maxID ;// imtes 大于51时候，做特殊的处理
//    connection_view *  connectioning ;
    
    NSMutableArray *arrayID ;//存储所有的id
    NSMutableArray *arrayView;//存储view
    NSMutableArray *viewHigt; //存储高度
    
    
}

@property (nonatomic,retain) NSMutableArray *mutableHight; // 保留高度 数组

@end

@implementation MessageDynamicViewController
@synthesize items,checkPageView;
@synthesize tableRowZeroView = _tableRowZeroView;
@synthesize userModel,isHiddenHeader;
@synthesize delegate = _delegate;
@synthesize nsnotification,maxID,stringPic,mutableHight;


-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setParameter:) name:@"setParameter" object:nil];
        singleORclass = [[NSString alloc]initWithString:@"single"];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setHidePullView) name:@"setHidePullView" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setStly:) name:@"stye" object:nil];
    }
//    YBLogInfo(@"@implementation MessageDynamicViewController");
    return self;
}


//设置
-(void)setStly:(NSNotification*)info{
    
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:0.2f];
    if (isRotating) {
        CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI*1 );
        [selectStye setTransform:rotate];
        isRotating = NO;
    }else{
        CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI*2 );
        [selectStye setTransform:rotate];
        isRotating = YES;
    }
    [UIView commitAnimations];
    
//    NSString *infomation  =[info object];
//    [bar.titleLabel setText:infomation];
//    int leng = [infomation sizeWithFont:YIHEADERTITLESIZE].width;
//    [bar.titleLabel sizeToFit];
//    [bar.titleLabel setCenter:CGPointMake(150.0f, 22.0f)];
//    
//    CGRect rectBar = [bar.titleLabel frame];
//    [bar.titleLabel setFrame:CGRectMake(rectBar.origin.x,rectBar.origin.y , leng, rectBar.size.height)];
//    if (rectBar.size.width>190.0f) {
//        rectBar.size.width = 190.0f;
//        [bar.titleLabel setFrame:CGRectMake(rectBar.origin.x, rectBar.origin.y, 190.0f, rectBar.size.height)];
//        [bar.titleLabel setCenter:CGPointMake(150.0f, 22.0f)];
//        rectBar = [bar.titleLabel frame];
//    }
//    [selectStye setFrame:CGRectMake(rectBar.origin.x+rectBar.size.width, rectBar.origin.y+7, 11.0f, 14.0f)];
}
//隐藏下拉选项
//-(void)setHidePullView{
//    [UIView beginAnimations:@"animationID" context:nil];
//    [UIView setAnimationDuration:.5f];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [pullview setFrame:CGRectMake((320-144)/2, -objectNmu*32-70.0f, 144.0f, wight)];
//    [UIView commitAnimations];
//    
//}
//-(void)doPullView{
//    [[CommonHelper shareInstance] playSound:5];
//    if (!isShowPullView) {
//        [UIView beginAnimations:@"animationID" context:nil];
//        [UIView setAnimationDuration:.5f];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [pullview setFrame:CGRectMake((320-144)/2, 44.0f, 144.0f, wight)];
//        [UIView commitAnimations];
//        isShowPullView = YES;
//    }else{
//        [self setHidePullView];
//        isShowPullView = NO;
//    }
//    
//}
//-(void)doHideList:(UIPanGestureRecognizer *)hide{
//    
//    UIView *view = [self viewWithTag:100];
//    if (view!= nil) {
//        [UIView beginAnimations:@"animationID" context:nil];
//        [UIView setAnimationDuration:.5f];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [view setFrame:CGRectMake((320-144)/2, -260.0f, 144.0f, wight)];
//        [UIView commitAnimations];
//    }
//}
//-(void)removePhoto{
//    [self doBackCurrent];
//}
//
////显示中间控制器左边控制器的view
//-(void)doLeft{
//    [[CommonHelper shareInstance] playSound:5];
//    
//    [[LLSplitViewController getmainController] showLeftView:YES];
//}
//
//-(void)doRight{
//    [[CommonHelper shareInstance] playSound:5];
//    
//    [[LLSplitViewController getmainController] showRightView:YES];
//    
//}
// 箭头动画
-(void)setIndicateCode{
    
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:0.2f];
    if (isRotating) {
        CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI*1 );
        [selectStye setTransform:rotate];
        isRotating = NO;
    }else{
        CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI*2 );
        [selectStye setTransform:rotate];
        isRotating = YES;
    }
    [UIView commitAnimations];
}

////
//-(void)doSelect{
//    [self setIndicateCode];
//    [self doPullView];
//    
//}
//// 刷新tabelview
//-(void)reloadData{
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONNOSOUNDFORLOAD object:nil];
//    [table_view launchRefreshing];
//    [self refresh];
//}
//-(void)send_reflash{
//    [self refresh];
//}
//
// 关闭定时器
-(void)stopTimer{
    
}

// 判断是否有广告
//-(void)isNOTbanner:(NSArray *)array{
//    if (array.count>0) {
//        bZeroBanner = NO;
//        [table_view beginUpdates];
//        NSArray *_tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
//        [table_view insertRowsAtIndexPaths:_tempIndexPathArr withRowAnimation:UITableViewRowAnimationNone];
//        [table_view endUpdates];
//    }else{
//        
//        bZeroBanner = YES;
//    }
//}
- (void)viewDidLoad
{
//    [super viewDidLoad];
    arrayView = [[NSMutableArray alloc]init];
    viewHigt = [[NSMutableArray alloc]init];
    
    mutableItems = [[NSMutableArray alloc]init];
    mutableHight = [[NSMutableArray alloc]init];
    dictView = [[NSMutableDictionary alloc]init];
    dictHight = [[NSMutableDictionary alloc]init];
    
    arrayID = [[NSMutableArray alloc]init];
    
    dictTotalData = [[NSMutableDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISREQUESTDETAIL"];
    tempHight = 0;
    showBanner = [[NSUserDefaults standardUserDefaults]objectForKey:@"showBanner"];
    //个人主页没有广告
    bZeroBanner = YES;
    isShowPullView = NO;
    if (nsnotification!=nil) {
        [self setParameter:nsnotification];
        return;
    }
    
    [self setBackgroundColor:[UIColor redColor]];
//    //新消息提示
//    if (!userModel) {
//        self.userModel = [YiBanLocalDataManager sharedInstance].currentUser;
//    }
//    isShow_top = NO;
//   
//    CGRect rect = [[UIScreen mainScreen]applicationFrame];
//   YiBanTableView * _table_view = [[YiBanTableView alloc]initWithFrame:CGRectMake(0, 44, 320, rect.size.height-44)];
//    // tableview 点击事件
////    if (isHiddenHeader) {
////        [_table_view.headerView setHidden:YES];
////        [_table_view.footerView setHidden:YES];
////    }
//    [_table_view setDelegate:self];
//    [_table_view setTag:505];
//    [self addSubview:_table_view];
//    [_table_view setTouchDelegate:self];
//    [_table_view setDataSource:self];
//    [_table_view release];
//    
//    self.table_view = _table_view;
//    
//    if (isHiddenHeader) {
//        [table_view setBackgroundColor:[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f]];
//    }else{
//        [table_view setBackgroundColor:[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f]];
//    }
//    [table_view setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    page = 1;
    pageSize= 30;
    item_temp = [[NSMutableArray alloc]init]; // lings
    isRotating = YES;
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new_bar.png"]];
    [image setFrame:CGRectMake(0.0f, 44-25.0f, 320.0f, 25.0f)];
    [image setTag:600];
    if (isHiddenHeader) {
        [image setHidden:YES];
       
    }
    [self addSubview:image];
    [image release];
    UILabel *label = [[UILabel alloc]init];
    [label setTag:1];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:13]];
    [label setFrame:CGRectMake(85.0f, 0.0f, 150.0f, 25.0f)];
    [image addSubview:label];
    [label release];
    
    //生成下拉选项卡，
//    pullview = [[PullDownView alloc]init ];//WithFrame:CGRectMake((320-144)/2, -280.0f, 144.0f, 200.0f)];
//    [pullview setDelegate:self];
//    [pullview setTag:100];
//    objectNmu = pullview.arrayItem.count;
//    [pullview setFrame:CGRectMake((320-144)/2, -objectNmu*32-50.0f, 144.0f, wight)];
//    [pullview setBackgroundColor:[UIColor clearColor]];
//    [self addSubview:pullview];
//    [pullview setHidden:isHiddenHeader];
    
//    UIImageView *imageFoot = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, wight, 144.0f, 10.0f)];
//    [imageFoot setImage:[UIImage imageNamed:@"topslide_foot.png"]];
//    [pullview addSubview:imageFoot];
//    [imageFoot release];
//    
//    UIImageView *imagMid = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 144.0f, wight)];
//    [imagMid setImage:[UIImage imageNamed:@"topslide_mid.png"]];
//    [pullview addSubview:imagMid];
//    [imagMid release];
//    [pullview.pullDown setBackgroundColor:[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f]];
//    [pullview setBackgroundColor:[UIColor clearColor]];
//    [pullview initPullDown:CGRectMake(0.0f, 0.0f, 144.0f, wight)];
//    bar = [[YiBanHeadBarView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f) titleLabel:@"随便看看"];
//    if (![Static isVerify]) {
//        
//        type = 0;
//    }else{
//        [bar setTitleLabelString:@"易友动态"];
//        type = 2;
////    }
//    [bar.leftButton setImage:[UIImage imageNamed:@"btn_leftmenu_a.png"] forState:UIControlStateNormal];
//    [bar.leftButton setImage:[UIImage imageNamed:@"btn_leftmenu_b.png"] forState:UIControlStateHighlighted];
//    [bar normalHeadView];
//    [bar setHidden:isHiddenHeader];
//    [bar.titleLabel sizeToFit];
//    [[bar leftButton] addTarget:self action:@selector(doLeft) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:bar];
////    [bar release];
//    [bar.titleLabel setCenter:CGPointMake(150.0f, 22.0f)];
//    [bar.rightButton setHidden:NO];
//    [bar.rightButton addTarget:self action:@selector(doRight) forControlEvents:UIControlEventTouchUpInside];
//    [bar.rightButton setImage:[UIImage imageNamed:@"btn_msg_a.png"] forState:UIControlStateNormal];
//    [bar.rightButton setImage:[UIImage imageNamed:@"btn_msg_b.png"] forState:UIControlStateHighlighted];
//    [bar setTipView];
//    
//    CGRect rectBar = [bar.titleLabel frame];
//    selectStye = [[UIButton alloc]initWithFrame:CGRectMake(rectBar.origin.x+rectBar.size.width+2, rectBar.origin.y+7, 11.0f, 14.0f)];
//    [selectStye setBackgroundImage:[UIImage imageNamed:@"toparrow_white.png"] forState:UIControlStateNormal];
//    [selectStye addTarget:self action:@selector(doSelect) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:selectStye];
//    [selectStye setHidden:isHiddenHeader];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removePhoto) name:@"REMOVERPHOTOVIEW" object:nil];
//    UITapGestureRecognizer *hideList  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doHideList:)];
//    hideList.numberOfTapsRequired = 1;
//	[hideList release];
//    items = [[NSMutableArray alloc]initWithCapacity:50]; //总的信息
//    self.haveNext = [[NSString alloc]init];
//    float tableViewY = 44.f;
//    if (isHiddenHeader) {
//        tableViewY = 44.f;
//        table_view.frame =  CGRectMake(0.0f, tableViewY, 320.0f, table_view.frame.size.height-100);
//        [self setFrame:CGRectMake(0.0f, -44.0f, 320.0f, self.frame.size.height)];
//        [self setBackgroundColor:[UIColor clearColor]];
//    }
//    
//    
    //如果是主页进来个人主页
    if (checkPageView) {
        type = 1;
    }
    UIButton*  stye = [[UIButton alloc]initWithFrame:CGRectMake(65.0f, 0.0f, 200.0f, 44.0f)];
    [stye.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [stye.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    [stye setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stye setBackgroundColor:[UIColor clearColor]];
    [stye addTarget:self action:@selector(doSelect) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:stye];
    [stye setHidden:isHiddenHeader];
//    [stye release];
//    
//    if (!userModel) {
//        self.userModel = [YiBanLocalDataManager sharedInstance].currentUser;
//        
//    }
//    
//    NSMutableDictionary *params = [self statusListForRefreshDict];
//      HttpHelp * help =  [[HttpHelp alloc]initWithView:self showNotice:YES page:page];
//    if (isHiddenHeader) {
//        help.isHome = YES;
//        [self setBackgroundColor:[UIColor clearColor]];
//        [table_view setBackgroundColor:[UIColor clearColor]];
//    }
//    help.type = [NSString stringWithFormat:@"%d",type];
//    [help startHttpEX:status_lists :params];
//       
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteZeroObj) name:NOTIFICATIONDELETESTATUSFIRTSTOBJ object:nil];
    
}

//- (void)getBanner{
//    YibanBanner *banner = [[YibanBanner alloc]init];
//    banner.delegate = self;
//    [banner setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 60.0f)];
//    self.bannerController = banner;
//    [banner release];
//    isRelease = NO;
//}

//删除多余的数据（废弃）
- (void)deleteZeroObj{
    deleteZeroDataType = YES;
}
//-(void)goWeb:(NSString *)url{
//    
//    webController* web = [[webController alloc]init];
//    web.url = url;
//    [[LLSplitViewController getmainController].navigationController pushViewController:web animated:YES];
//    [web release];
//}
//- (NSMutableDictionary *)statusListForRefreshDict{
//    NSMutableDictionary *params = [Rrequest_Data setstatus_list:nil  max_id:nil last_id:@"0" num:@"10" page:@"1" type:[NSString stringWithFormat:@"%d",type] userid:userModel.userid];
//
//    return params;
//}

-(void)hidePullDown{
    
    UIView *view = [self viewWithTag:100];
    if (view!= nil) {
        [UIView beginAnimations:@"animationID" context:nil];
        [UIView setAnimationDuration:.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [view setFrame:CGRectMake((320-144)/2, -objectNmu*32-50.0f, 144.0f,wight)];
        
        [UIView commitAnimations];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    YBLogInfo(@"isShow_top22 ===%d",isShow_top);
    
  
    if (!isShow_top) {
        NSDictionary* dicStatus;
        if (isHiddenHeader) {
            will_delete_postion = indexPath.row;
            dicStatus = [self.items objectAtIndex:indexPath.row];
        }else if (!bZeroBanner) {
            will_delete_postion = indexPath.row-1;
            dicStatus = [self.items objectAtIndex:indexPath.row-1];
        }else{
            will_delete_postion = indexPath.row;
            dicStatus = [self.items objectAtIndex:indexPath.row];
        }
        UITableViewCell *tt = [tableView cellForRowAtIndexPath:indexPath];
        [dicStatus objectForKey:@"id"];
//        if ([[dicStatus objectForKey:@"type"] integerValue] == 8) {
//            DetailNotificationViewController *detailNotification = [[DetailNotificationViewController alloc]init];
//            detailNotification.isPush = YES;
//            detailNotification.message_id = [NSString stringWithFormat:@"%@",[dicStatus objectForKey:@"id"]];
//            detailNotification.type = [NSString stringWithFormat:@"%@",[dicStatus objectForKey:@"type"]];
//            [[LLSplitViewController getmainController].navigationController pushViewController: detailNotification animated:YES];
//            detailNotification.isRight = NO;
//            [detailNotification release];
//        }else{//进动态详情页
//            YiBanDetail *detai = [[YiBanDetail alloc]init];
//            detai.isPush = YES;
//            detai.dynameic_status = dicStatus;
//            MainConrtrollerCell *tt = [arrayView objectAtIndex:will_delete_postion];
//
//            [detai setStatusCell:tt];
//            detai.isHome = isHiddenHeader;
//            detai.users = [dicStatus objectForKey:@"user_info"];
//            detai.messageDynamic = self;
//            detai.sql_type = [NSString stringWithFormat:@"%d",type];
//            detai.isopen = NO; 
//            detai.message_id =[NSString stringWithFormat:@"%@",[dicStatus objectForKey:@"id"]];
//            detai.type = [NSString stringWithFormat:@"%@",[dicStatus objectForKey:@"type"]];
//            detai.sql_type = [NSString stringWithFormat:@"%i",type];
//            [[LLSplitViewController getmainController].navigationController pushViewController:detai animated:YES];
//            detai.isRight = NO;
//            [detai release];
//        }
    }else{
//        YBLogInfo(@"isShow_top33 ===%d",isShow_top);
        isShow_top = NO;
    }
}
// 拦截点击tableview事件
-(void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (isShowPullView) {
        [self doPullView];
        isShow_top = YES;
        isShowPullView = NO;
        [self setIndicateCode];
//        YBLogInfo(@"isShow_top444 ===%d",isShow_top);
    }
//    YBLogInfo(@"isShow_to534p ===%d",isShow_top);
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    YBLogInfo(@"itemsCount ---=== %d", arrayView.count);
    
    if ((bZeroBanner||isHiddenHeader)) {
        return arrayView.count;
    }else{
        return arrayView.count+1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isHiddenHeader) {
        
        return [[viewHigt objectAtIndex:indexPath.row] integerValue];
        
    }else if (!bZeroBanner) {
        if (indexPath.row == 0) {
            return 60;
        }else{
            
            return [[viewHigt objectAtIndex:indexPath.row -1] integerValue];
        }
    }else{
        
        return [[viewHigt objectAtIndex:indexPath.row] integerValue];
    }
}

static bool isRelease;

////- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([gestureRecognizer.view isKindOfClass:[UITableView class]]) {
//        YBLogInfo(@"dfdf");
//        
//        
//        return YES;
//    }
//    // 过滤掉UIButton，也可以是其他类型
//    if ( [touch.view isKindOfClass:[UIButton class]])
//    {
//        return NO;
//    }
//    return YES;
//}
//
//// 查看大图
//-(void)DoPicBig:(NSMutableArray *)arry{
//    
//    int Difference = isHiddenHeader ? 110 : 0;
//    CGRect rect = [Static iphone5Frame];
//    
//    Difference = (rect.size.height == 548.0f)  ? Difference   : Difference ;
//    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, rect.size.height+20)];
//    [view setTag:401];
//    [view setAlpha:0.8f];
//    [view setBackgroundColor:[UIColor blackColor]];
//    
//    [theApp.window addSubview:view];
//    [[[LLSplitViewController getmainController].view viewWithTag:3000] setHidden:YES];
//    //点击消失手势
//    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doBackCurrent)];
//    singleRecognizer.numberOfTapsRequired = 1;
//    singleRecognizer.cancelsTouchesInView = NO; 
//    singleRecognizer.delegate = self;
//    
//    [view addGestureRecognizer:singleRecognizer];
//    [singleRecognizer release];
//    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((320-220)/2, self.frame.size.height-360 + Difference, 220.0f, 220.0)];
//    [imageView setImageWithURL:[NSURL URLWithString:[arry objectAtIndex:0]]];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [imageView setTag:402];
//    [imageView setAlpha:1.0f];
//    [theApp.window addSubview:imageView];
//    
//    {
//        imageView.alpha=0;
//        [UIView animateWithDuration:0.3 animations:^{
//            imageView.alpha=1;
//        }];
//    }
//    
//    UITapGestureRecognizer *singleRecognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doBackCurrent)];
//    singleRecognizer1.numberOfTapsRequired = 1;
//    [imageView addGestureRecognizer:singleRecognizer1];
//    [singleRecognizer1 release];
//    
//    UIButton *btnOriginal = [[UIButton alloc]initWithFrame:CGRectMake((320-135)/2, self.frame.size.height-100 + Difference, 135.0f, 55.0)];
//    [btnOriginal setBackgroundColor:[UIColor clearColor]];
//    [btnOriginal setTag:403];
//    [btnOriginal setImage:[UIImage imageNamed:@"btn_viewbigpic_a.png"] forState:UIControlStateNormal];
//    [btnOriginal setImage:[UIImage imageNamed:@"btn_viewbigpic_b.png"] forState:UIControlStateHighlighted];
//    [btnOriginal addTarget:self action:@selector(showOriginal:) forControlEvents:UIControlEventTouchUpInside];
//    [theApp.window addSubview:btnOriginal];
//    [btnOriginal release];
//    [imageView release];
//    [view release];
//    self.stringPic = [arry objectAtIndex:1];
//    
//    {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification) name:k_Notification_SuccessDownImg object:nil];
//    }
//    
//}
//回调 main_cell
-(void)hideDownView{
    if (isShowPullView) {
        [self setIndicateCode];
        [self doPullView];
        isShowPullView = NO;
    }
}
//// 移除查看大图上的view
//-(void)doBackCurrent{
//    UIView* view = (UIView*)[theApp.window viewWithTag:401];
//    UIView *view1= (UIView *)[theApp.window viewWithTag:402];
//    UIView *view2 = (UIView *)[theApp.window viewWithTag:403];
//    [view2 removeFromSuperview];
//    [view removeFromSuperview];
//    [view1 removeFromSuperview];
//    [[[LLSplitViewController getmainController].view viewWithTag:3000] setHidden:NO];
//}
//
////点"查看大图"后回调
//-(void)showOriginal:(id)sender{
//    [[CommonHelper shareInstance]playSound:5];
//    BigImageViewController *bigImage = [[BigImageViewController alloc]init];
//    bigImage.picURL = stringPic;
//    [bigImage doNext];
//    [self doBackCurrent];
//    
//    [[LLSplitViewController getmainController]  presentModalViewController:bigImage animated:(([k_isAnimateShowDetailImg isEqualToString:@"0"])?(YES):(NO))];
//
//    //Add by Hyde 20130219 #memoryleaks
//    [bigImage release];
//    
//}
//// 查看大图返回
-(void)doBackBigPic{
    [self doBackCurrent];
    UIView* view = (UIView*)[self viewWithTag:402];
    [view removeFromSuperview];
    
}

-(void)setPameraDelegate:(NSDictionary *)dic{
    
    [self setParameter:dic];
}
-(void)setParameter:(NSDictionary*)dic{
    self.nsnotification = dic;
    page = 1;
    
    [mutableHight removeAllObjects];
    [mutableItems removeAllObjects];
    [dictHight removeAllObjects];
    [dictView removeAllObjects];
    [dictTotalData removeAllObjects];
    
    
    isShowPullView = NO; //设置箭头的状态
    NSNumber* row = [dic objectForKey:@"row"];
    classID = [dic objectForKey:@"classID"];
    type  = [row intValue];
//    [table_view reloadData:YES];
//    NSMutableDictionary *params = nil;
//    
//   HttpHelp * help = [[HttpHelp alloc]initWithView:self showNotice:YES page:page];
//    if ([row integerValue]>=3) { // 判断选着的是否是班级的动态
//        singleORclass = @"class";
//        params = [Rrequest_Data eclass_list:@"0" num:@"10" page:@"1" eclassid:classID];
//        help.type = classID;
//        [help startHttpEX:status_eclasslist :params];
//    }
//    else{
//        singleORclass = @"";
//        params  = [self statusListForRefreshDict];
//        help.type = [NSString stringWithFormat:@"%d",type];
//        [help startHttpEX:status_lists :params];
//    }
}
- (BOOL) refresh
{
    page = 1;
    NSMutableDictionary *params;
//    HttpHelp * help = [[HttpHelp alloc]initWithView:self showNotice:NO page:0];
//    if (isHiddenHeader) {
//        help.isHome = YES;
//    }
//    NSString *max_ID = @"";
//    if ([items count] > 0) {
//        max_ID = self.maxID;
//
//    }else{//发的第一条
//        
//        params  = [self statusListForRefreshDict];
//        help.type = [NSString stringWithFormat:@"%d",type];
//        [help startHttpEX:status_lists :params isrefresh:YES];
//        return YES;
//    }
    
//    if ([singleORclass isEqualToString:@"class"]) {
//        params = [Rrequest_Data eclass_list:nil num:@"10" page:@"1" eclassid:classID];
//        help.type = classID;
//        [help startHttpEX:status_eclasslist :params isrefresh:YES];
//    }else if(type==2){//列表大于1条时发
//        
//        params = [Rrequest_Data setstatus_list:@"0"max_id:max_ID  last_id:@"0" num:@"10" page:@"1" type:[NSString stringWithFormat:@"%d",type] userid:userModel.userid];
//        help.type = [NSString stringWithFormat:@"%d",type];
//        [help startHttpEX:status_lists :params isrefresh:YES];
//        
//    
//    }
//    else{
//        params = [Rrequest_Data setstatus_list:@"0"max_id:@""  last_id:@"0" num:@"10" page:@"1" type:[NSString stringWithFormat:@"%d",type] userid:userModel.userid];
//        help.type = [NSString stringWithFormat:@"%d",type];
//        [help startHttpEX:status_lists :params isrefresh:YES];
//    }
    return YES;
}
-(void)ref_reload{
//    YBLogInfo(@"%i",will_delete_postion);
    if ([items count] > 0) {
        [items removeObjectAtIndex:will_delete_postion];
    }
    if (arrayView.count > 0) {
        [arrayView removeObjectAtIndex:will_delete_postion];
    }
    if (viewHigt.count > 0) {
        [viewHigt removeObjectAtIndex:will_delete_postion];
    }
//    [table_view reloadData];
}
-(void)doMore{
    
    NSMutableDictionary *params;
    page++;
//   HttpHelp * help = [[HttpHelp alloc]initWithView:self showNotice:NO page:page];
//    if ([singleORclass isEqualToString:@"class"]) {
//        NSString* i = [NSString stringWithFormat:@"%@",([(NSDictionary*)[items lastObject] objectForKey:@"id"]) ];
//        params = [Rrequest_Data eclass_list:i num:@"10" page:@"0" eclassid:classID];
//        help.type = classID;
//        [help startHttpEX:status_eclasslist :params isQueryMore:YES];
//    }
//    else{
//        NSString* i = [NSString stringWithFormat:@"%@",([(NSDictionary*)[items lastObject] objectForKey:@"id"]) ];
//        params = [Rrequest_Data setstatus_list:@"0"max_id:@"0" last_id:i num:@"10" page:@"1" type:[NSString stringWithFormat:@"%d",type] userid:userModel.userid];
//        help.type = [NSString stringWithFormat:@"%d",type];
//        [help startHttpEX:status_lists :params isQueryMore:YES];
//    }
    
}

//#pragma mark - httpDelegate
//- (void)requestSuccess:(NSDictionary *)data message:(NSString *)message http:(HttpHelp *)http
//{
//    
//    [items removeAllObjects];
//    [mutableHight removeAllObjects];
//    [mutableItems removeAllObjects];
//    [dictTotalData removeAllObjects];
//    [dictView removeAllObjects];
//    [dictHight removeAllObjects];
//    [arrayID removeAllObjects];
//    [arrayView removeAllObjects];
//    [viewHigt removeAllObjects];
//
////    if (isHiddenHeader) {
////        
//        [table_view.headerView setHidden:NO];
//        [table_view.footerView setHidden:NO];
////        [connectioning removeFromSuperview];
////        
////    }
//
//    
//    UITableView *view = (UITableView*)[self viewWithTag:505];
//    if (!view) {
//        
//    }
//    if ([[LLSplitViewController getmainController].view viewWithTag:9]) {
//        
//        [self removeViewFromMainView];
//    }
//    YBLogInfo(@"我要解锁！！！！");
//    [[LLSplitViewController getmainController].view setUserInteractionEnabled:YES];
//    YBLogInfo(@"message Http_result == %@",data);
//    
//    [table_view setContentOffset:CGPointMake(0.0f, 0.0f)];
//    [items removeAllObjects];
//    [item_temp removeAllObjects];
//    
//    NSMutableArray* arrayTemp = [data objectForKey:@"status"];
//   
//    if (arrayTemp.count == 0) {
//        [table_view reloadData:YES];
//        [table_view reloadData];
//
//        if ([http.type isEqualToString:@"2"] && !isHiddenHeader) {//易友动态的请求没有收到动态内容
//            UIView *bt=[self viewWithTag:-1];
//            if (!bt) {//提示去找人页
//                UIImage *img=[UIImage imageNamed:@"guideAdd.png"];
//                _imgV_findFriend=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
//                [_imgV_findFriend release];
//                [self insertSubview:_imgV_findFriend belowSubview:pullview];
//                
//                UIButton *bt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) BackgroundImageForNormalState:Nil BackgroundImageForSelectState:Nil NormalImage:nil tag:-1 target:self selector:@selector(btClick:) Title:Nil selectImg:nil showsTouchWhenHighlighted:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil font:Nil NormalStateTitleColor:Nil selectStateTitleColor:Nil isAdjustSizeByTitleLabel:NO superView:self Alignment:2];
//                bt.backgroundColor=[UIColor clearColor];
//                [self insertSubview:bt belowSubview:pullview];
//                [DeBug layerAnimation:bt.layer duration:0.3 curve:kCAMediaTimingFunctionEaseInEaseOut :kCATransitionFade :kCATransitionFromTop selector:Nil userInfo:Nil target:self];
//                [bt release];
//                table_view.hidden=YES;
//            }else{
//                bt.hidden=NO;
//                _imgV_findFriend.hidden=NO;
//            }
//            
//            UIView *bt2=[self viewWithTag:-2];
//            if (bt2) {
//                bt2.hidden=YES;
//                _imgV_sendAction.hidden=YES;
//            }
//           
//        }else if ([http.type isEqualToString:@"1"] && !isHiddenHeader ){//我的动态的请求没有收到动态内容
//            UIView *bt=[self viewWithTag:-2];
//            if (!bt) {//提示去发动态页
//                UIImage *img=[UIImage imageNamed:@"guideAddnews.png"];
//                _imgV_sendAction=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
//                [_imgV_sendAction release];
//                [self insertSubview:_imgV_sendAction belowSubview:pullview];
//
//                UIButton *bt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) BackgroundImageForNormalState:Nil BackgroundImageForSelectState:Nil NormalImage:Nil tag:-2 target:self selector:@selector(btClick:) Title:Nil selectImg:Nil showsTouchWhenHighlighted:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil font:Nil NormalStateTitleColor:Nil selectStateTitleColor:Nil isAdjustSizeByTitleLabel:NO superView:self Alignment:2];
//                [self insertSubview:bt belowSubview:pullview];
//                [DeBug layerAnimation:bt.layer duration:0.3 curve:kCAMediaTimingFunctionEaseInEaseOut :kCATransitionFade :kCATransitionFromTop selector:Nil userInfo:Nil target:self];
//                [bt release];
//                table_view.hidden=YES;
//                
//            }else{
//                bt.hidden=NO;
//                _imgV_sendAction.hidden=NO;
//            }
//            
//            UIView *bt1=[self viewWithTag:-1];
//            if (bt1) {
//                bt1.hidden=YES;
//                _imgV_findFriend.hidden=YES;
//            }
//        }
//        
//        [http release];
//        return;
//    }else{
//        UIView *bt=[self viewWithTag:-1];
//        if (bt) {
//            [bt removeFromSuperview];
//            bt=Nil;
//            
//            [_imgV_findFriend removeFromSuperview];
//            _imgV_findFriend=nil;
//        }
//        
//        UIView *bt2=[self viewWithTag:-2];
//        if (bt2) {
//            [bt2 removeFromSuperview];
//            bt2=Nil;
//            
//            [_imgV_sendAction removeFromSuperview];
//            _imgV_sendAction=nil;
//        }
//
//        table_view.hidden=NO;
//    }
//
//    self.maxID = [[arrayTemp objectAtIndex:0] objectForKey:@"id"];
//    status_list *list = (status_list *)[data initDictionaryTo:[status_list class]];
//    self.haveNext = [NSString stringWithFormat:@"%d",list.havenext];
//    for (NSDictionary *dic in arrayTemp) {
//        [dictTotalData setValue:dic forKey:[dic objectForKey:@"id"]];
//        if (items.count > LIMITNUM) {
//            YBLogInfo(@"dfdf");
//            if (![items containsObject:dic]) {
//                
//                 [items removeObjectAtIndex:0];
//            }
//           
//        }
//            [items addObject:dic];
//            [item_temp addObject:dic];
//            [arrayID addObject:[dic objectForKey:@"id"]];
//
//        
//    }
//    [self hight];//获取cell的高度
//    
//    
//    if (list.havenext==1) {
//        [table_view reloadData:NO];
//    }else{
//        [table_view reloadData:YES];
//    }
//    [table_view reloadData];
//    if (bZeroBanner) {
//        if (!isHiddenHeader && [showBanner isEqualToString:@"YES"]) {
//            [self getBanner];
//        }
//    }
//    [list release];
//    [http release];
//    
//    
//}
//
//- (void)requestForQueryMore:(NSDictionary *)data message:(NSString *)message http:(HttpHelp *)http
//{
//    YBLogInfo(@"message http queryMore == %@",data);
//    [item_temp removeAllObjects];
//    NSMutableArray *tempArray = [data objectForKey:@"status"];
//
//    status_list *list = (status_list *)[data initDictionaryTo:[status_list class]];
//    YBLogInfo(@"havenext ---> %d",list.havenext);
//    for (NSDictionary *dic in tempArray) {
//        [dictTotalData setValue:dic forKey:[dic objectForKey:@"id"]];
//        if (items.count >LIMITNUM) {
//            
//            if (![items containsObject:dic]) {
//                
//                [items removeObjectAtIndex:0];
//                [items addObject:dic];
//            }
//            
//           
//        }else{
//                [items addObject:dic];
//                [item_temp addObject:dic];
//                [arrayID addObject:[dic objectForKey:@"id"]];
//        }
//        
//        
//    
//    }
//    if ([items count]<=0) {
//        [table_view reloadData:YES];
//        return;
//    }
//    int itemp_count = item_temp.count;
//    [self hight];//获取cell的高度
//    if (list.havenext==1) {
//        [table_view reloadData:NO];
//    }else{
//        [table_view reloadData:YES];
//    }
//    int highe = 0 ;
//    
//    [table_view reloadData];
//    
//    if (items.count >= LIMITNUM) {
//        int newHight = 0;       
//        for (int i = 0; i < itemp_count ; i++) {
//            NSString *tempID = [mutableHight objectAtIndex:mutableHight.count - itemp_count -1 + i];
//            newHight = newHight + [[dictHight objectForKey:tempID] integerValue];
//        }
//        [table_view setContentOffset:CGPointMake(0, self.table_view.contentSize.height - newHight -self.table_view.frame.size.height ) animated:NO];
//    }else{
//    }
//    
//    YBLogInfo(@"hight is  ---> %d",highe);
//    YBLogInfo(@"contentsize.highe is --> %f",table_view.contentSize.height);
//    
//    [list release];
//    [http release];
//    
//}
//
////下拉刷新请求后回调
//- (void)requestForQueryRefresh:(NSDictionary *)data message:(NSString *)message http:(HttpHelp *)http
//{
//    YBLogInfo(@"message http query_refresh == %@",data);
//    [items removeAllObjects];
//    [mutableHight removeAllObjects];
//    [mutableItems removeAllObjects];
//    [dictTotalData removeAllObjects];
//    [dictView removeAllObjects];
//    [dictHight removeAllObjects];
//    [arrayID removeAllObjects];
//    [arrayView removeAllObjects];
//    [viewHigt removeAllObjects];
//    
//    status_list *list = (status_list *)[data initDictionaryTo:[status_list class]];
//    NSMutableArray *arry  = [data objectForKey:@"status"];
//    self.haveNext = [NSString stringWithFormat:@"%d",list.havenext];
//    
//    if ([[data objectForKey:@"new_count"] integerValue] > 0) { // 判断是否有新的消息
//        
//        [self creatReflashBar:[[data objectForKey:@"new_count"] integerValue]];
//       self.maxID = [[arry objectAtIndex:0] objectForKey:@"id"];
//    }
//    for (NSDictionary *dic in arry) {
//        [dictTotalData setValue:dic forKey:[dic objectForKey:@"id"]];
//        if (items.count > LIMITNUM) {
//            if (![items containsObject:dic]) {
//                [items removeObjectAtIndex:0];
//            }
//        
//        }
//            [items addObject:dic];
//            [item_temp addObject:dic];
//            [arrayID addObject:[dic objectForKey:@"id"]];
//        
//    }
//    
//    
//    if ([arry count]<=0) {
//        
//        [table_view reloadData:YES];
//
//        [table_view reloadData];
//        
//        if ([http.type isEqualToString:@"2"] && !isHiddenHeader) {//易友动态的请求没有收到动态内容
//            UIView *bt=[self viewWithTag:-1];
//            if (!bt) {//提示去找人页
//                UIImage *img=[UIImage imageNamed:@"guideAdd.png"];
//                _imgV_findFriend=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
//                [_imgV_findFriend release];
//                [self insertSubview:_imgV_findFriend belowSubview:pullview];
//
//                UIButton *bt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) BackgroundImageForNormalState:Nil BackgroundImageForSelectState:Nil NormalImage:nil tag:-1 target:self selector:@selector(btClick:) Title:Nil selectImg:nil showsTouchWhenHighlighted:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil font:Nil NormalStateTitleColor:Nil selectStateTitleColor:Nil isAdjustSizeByTitleLabel:NO superView:self Alignment:2];
//                bt.backgroundColor=[UIColor clearColor];
//                [self insertSubview:bt belowSubview:pullview];
//                [DeBug layerAnimation:bt.layer duration:0.3 curve:kCAMediaTimingFunctionEaseInEaseOut :kCATransitionFade :kCATransitionFromTop selector:Nil userInfo:Nil target:self];
//                [bt release];
//                table_view.hidden=YES;
//            }else{
//                bt.hidden=NO;
//                _imgV_findFriend.hidden=NO;
//            }
//            
//            UIView *bt2=[self viewWithTag:-2];
//            if (bt2) {
//                bt2.hidden=YES;
//                _imgV_sendAction.hidden=YES;
//            }
//            
//        }else if ([http.type isEqualToString:@"1"] && !isHiddenHeader ){//我的动态的请求没有收到动态内容
//            UIView *bt=[self viewWithTag:-2];
//            if (!bt) {//提示去发动态页
//                UIImage *img=[UIImage imageNamed:@"guideAddnews.png"];
//                _imgV_sendAction=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
//                [_imgV_sendAction release];
//                [self insertSubview:_imgV_sendAction belowSubview:pullview];
//
//                UIButton *bt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) BackgroundImageForNormalState:Nil BackgroundImageForSelectState:Nil NormalImage:Nil tag:-2 target:self selector:@selector(btClick:) Title:Nil selectImg:Nil showsTouchWhenHighlighted:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil font:Nil NormalStateTitleColor:Nil selectStateTitleColor:Nil isAdjustSizeByTitleLabel:NO superView:self Alignment:2];
//                [self insertSubview:bt belowSubview:pullview];
//                [DeBug layerAnimation:bt.layer duration:0.3 curve:kCAMediaTimingFunctionEaseInEaseOut :kCATransitionFade :kCATransitionFromTop selector:Nil userInfo:Nil target:self];
//                [bt release];
//                table_view.hidden=YES;
//                
//            }else{
//                bt.hidden=NO;
//                _imgV_sendAction.hidden=NO;
//            }
//            
//            UIView *bt1=[self viewWithTag:-1];
//            if (bt1) {
//                bt1.hidden=YES;
//                _imgV_findFriend.hidden=YES;
//            }
//        }
//        
//        return;
//    }else{
//        UIView *bt=[self viewWithTag:-1];
//        if (bt) {
//            [bt removeFromSuperview];
//            bt=Nil;
//            
//            [_imgV_findFriend removeFromSuperview];
//            _imgV_findFriend=nil;
//        }
//        
//        UIView *bt2=[self viewWithTag:-2];
//        if (bt2) {
//            [bt2 removeFromSuperview];
//            bt2=Nil;
//            
//            [_imgV_sendAction removeFromSuperview];
//            _imgV_sendAction=nil;
//        }
//
//        table_view.hidden=NO;
//    }
//
//
//    [self hight_add];
//    if (list.havenext==1) {
//        [table_view reloadData:NO];
//    }else{
//        [table_view reloadData:YES];
//    }
//    [table_view reloadData];
//    
//    
//    [list release];
//    [http release];
//}
//
//
//-(void)creatReflashBar:(int)newCount{
//    UIImageView *image = (UIImageView*)[self viewWithTag:600];
//    UILabel *label = (UILabel*)[image viewWithTag:1];
//    [label setText:[NSString stringWithFormat:@"%d条新消息",newCount]];
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:5.0f];
//    [image setFrame:CGRectMake(0.0f,44.0f, 320.0f, 25.0f)];
//    [UIView commitAnimations];
//    [self hideNew];
//}
//-(void)hideNew{
//    UIImageView *image = (UIImageView*)[self viewWithTag:600];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:2.5f];
//    [image setFrame:CGRectMake(0.0f,44-25.0f, 320.0f, 25.0f)];
//    [UIView commitAnimations];
//    
//    
//}
////解除mainview上面的view 解锁
//-(void)removeViewFromMainView{
//    UIView *view = (UIView*)[[LLSplitViewController getmainController].view viewWithTag:9];
//    [view removeFromSuperview];
//}
//
//
//-(void)requestFail:(NSDictionary *)data message:(NSString *)message http:(HttpHelp *)help{
//    if (data==nil) {
//        [table_view reloadData:NO];
//        [table_view reloadData];
//    }else{
//        [table_view reloadData:YES];
//        [table_view reloadData];
//    }
//    if ([[LLSplitViewController getmainController].view viewWithTag:9]) {
//        [self removeViewFromMainView];
//    }
//    
//    if (isHiddenHeader) {
//  
//        [table_view.headerView setHidden:YES];
//        [table_view.footerView setHidden:YES];
//   
//    }
//    YBLogInfo(@"我要解锁！！！！");
//    [[LLSplitViewController getmainController].view setUserInteractionEnabled:YES];
//    
//}
//
-(void)dealloc{
//    YBLogInfo(@"message is   kkkkkk");
    
//    [_delegate release];
//    _delegate = nil;
//    
//    self.table_view.scrollEnabled=NO;
//    [table_view setDelegate:nil];
//    [table_view setDataSource:nil];
////    [table_view release];
//    
//    [stringPic release];
//    bannerController.delegate = nil;
//    [bannerController release];
//    bannerController = nil;
    
    [item_temp removeAllObjects];
    [item_temp release];
    item_temp = nil;
    
    [mutableItems removeAllObjects];
    [mutableItems release];
    mutableItems = nil;
    
    [mutableHight removeAllObjects];
    [mutableHight release];
    mutableHight = nil;
    
    [arrayView removeAllObjects];
    [arrayView release];
    arrayView = nil;
    
    [viewHigt removeAllObjects];
    [viewHigt release];
    viewHigt = nil;
    
    [items removeAllObjects];
    [items release];
    items = nil;

    [maxID release];
    maxID = nil;
    
    [dictHight removeAllObjects];
    [dictHight release];
    dictHight  = nil;
    
    [dictTotalData removeAllObjects];
    [dictTotalData release];
    dictTotalData = nil;
    
    [dictView removeAllObjects];
    [dictView release];
    dictView = nil;
    
    [arrayID removeAllObjects];
    [arrayID release];
    arrayID = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super dealloc];
}
//-(void)hight{
//    tempHight = 0;
//    int j = items.count -item_temp.count;
//    //只刷新获取回来的新数据
//    for (int i  = 0; i<[item_temp count]; i++,j++) {
//        id dic = [items objectAtIndex:j];
//        MainConrtrollerCell* ccell = [[MainConrtrollerCell alloc]init];
////        ccell.mdvc = self;
//        CGFloat hight =  [ccell createcell:dic row:j sql_type:[NSString stringWithFormat:@"%i",type]];
//        if (ccell == nil) {
//            YBLogInfo(@"dfdf");
//        }
//        if (ccell) {
//             NSNumber *obHight = [[NSNumber alloc ]initWithFloat:hight];
//            if (dictView.count > LIMITNUM) {
//                
//                NSString *item = [mutableHight objectAtIndex:0];
//                
//                
////                if (![dictView.allKeys containsObject:[dic objectForKey:@"id"]]) { //顺便看看的 id 会循环
//                
//                    [dictHight removeObjectForKey:item];
//                    [dictView removeObjectForKey:item];
//                    [mutableHight removeObject:item];
//                    
//                    [mutableHight addObject:[dic objectForKey:@"id"]];
//                    [dictView setValue:ccell forKey:[dic objectForKey:@"id"]];
//                    [dictHight setValue:obHight forKey:[dic objectForKey:@"id" ]];
////                }
//                
//            }else{
////                if (![dictHight.allKeys containsObject:[dic objectForKey:@"id"]]) {
////                NSMutableArray *arrayView = nil;
//                [arrayView addObject:ccell];
//                [viewHigt addObject:obHight];
////                    [mutableHight addObject:[dic objectForKey:@"id"]];
////                    [dictView setValue:ccell forKey:[dic objectForKey:@"id"]];
////                    [dictHight setValue:obHight forKey:[dic objectForKey:@"id"]];
////                }
//            
//            }
//        
//            [obHight release];
//        }
//        //Add by Hyde 20130219 #memoryleaks
//        
//        [ccell release];
//        
//    }
//    [item_temp removeAllObjects];
//}
//-(void)hight_add{
//    //只刷新获取回来的新数据
//
//    for (int i  = 0; i<[items count]; i++) {
//        id dic = [items objectAtIndex:i];
//        MainConrtrollerCell* ccell = [[MainConrtrollerCell alloc]init];
////        ccell.mdvc = self;
//        CGFloat hight =  [ccell createcell:dic row:i sql_type:[NSString stringWithFormat:@"%i",type]];
//
//        
//        if (ccell) {
//            NSNumber *obHight = [[NSNumber alloc ]initWithFloat:hight];
//            if (dictView.count > LIMITNUM) {
//                
//                NSString *item = [mutableHight objectAtIndex:0];
//            
//                
//                if (![dictView.allKeys containsObject:[dic objectForKey:@"id"]]) { //顺便看看的 id 会循环
//                    
//                    [dictHight removeObjectForKey:item];
//                    [dictView removeObjectForKey:item];
//                    [mutableHight removeObject:item];
//                    
//                    [mutableHight addObject:[dic objectForKey:@"id"]];
//                    [dictView setValue:ccell forKey:[dic objectForKey:@"id"]];
//                    [dictHight setValue:obHight forKey:[dic objectForKey:@"id" ]];
//                }
//                
//            }else{
////                if (![dictHight.allKeys containsObject:[dic objectForKey:@"id"]]) {
////                    [mutableHight addObject:[dic objectForKey:@"id"]];
////                    [dictView setValue:ccell forKey:[dic objectForKey:@"id"]];
////                    [dictHight setValue:obHight forKey:[dic objectForKey:@"id"]];
//                
//                [arrayView addObject:ccell];
//                [viewHigt addObject:obHight];
////                }
//            
//            }
//            
//            [obHight release];
//        }
//        //Add by Hyde 20130219 #memoryleaks
//        
//        [ccell release];
//        
////    }
//
//    }
//}
//
//
#pragma mark- NSNotificationCenter
-(void)handleNotification
{
    UIView *v=[self viewWithTag:401];//展示大图的背景在大图加载完毕后再支持手势检测
    v.userInteractionEnabled=YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Notification_SuccessDownImg object:nil];
}

#pragma mark- CustomUIButtonDelegate
-(void)btClick:(UIButton *)bt{
    switch (bt.tag) {
        case -1://点击 木有易友动态提示
        {
            UIView *bt=[self viewWithTag:-1];
            if (bt) {
                [bt removeFromSuperview];
                bt=Nil;
                
                [_imgV_findFriend removeFromSuperview];
                _imgV_findFriend=nil;
            }
            
            UIView *bt2=[self viewWithTag:-2];
            if (bt2) {
                [bt2 removeFromSuperview];
                bt2=Nil;
                
                [_imgV_sendAction removeFromSuperview];
                _imgV_sendAction=nil;
            }
            
//            table_view.hidden=NO;
            [[MainViewController share] addViewFive];
        }
            break;
            
        case -2://点击 木有我的动态提示
        {
            [[MainViewController share] doSomething];
        }
            break;

        default:
            break;
    }
}

@end
