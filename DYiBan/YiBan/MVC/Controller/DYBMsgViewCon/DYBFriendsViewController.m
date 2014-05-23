//
//  DYBFriendsViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBFriendsViewController.h"
#import "UITableView+property.h"
#import "user.h"
#import "DYBCellForFriendList.h"
#import "DYBSendPrivateLetterViewController.h"
#import "friends.h"
#import "NSString+Count.h"
#import "Magic_CommentMethod.h"
#import "UIView+MagicCategory.h"
#import "DYBDynamicViewController.h"
#import "DYBPersonalHomePageViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+Count.h"
#import "ChineseToPinyin.h"
#import "DYBUITabbarViewController.h"
#import "UILabel+ReSize.h"
#import "UIViewController+MagicCategory.h"
#import "DYBSearchFriendsViewController.h"
#import "NSObject+KVO.h"

#define k_noFriends @"太孤独了,一个好友都没有\n       狂戳屏幕见证奇迹"

@interface DYBFriendsViewController ()
{
    int nSelMenu;
    UIImageView *imgV;
    MagicUILabel *lb;
    MagicUIButton *_bt_gotoSearchFriend;//没好友时点击屏幕跳到找人页
}
@end

@implementation DYBFriendsViewController

@synthesize str_userid=_str_userid;
@synthesize isPush = _isPush;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        if (!_str_userid) {
            _str_userid=SHARED.curUser.userid;
        }
        
        if (!_search) {
            _search=[[MagicUISearchBar alloc]initWithFrame:CGRectMake(0, self.headHeight+1, self.view.frame.size.width, 50) backgroundColor:ColorNav placeholder:@"昵称/姓名" isHideOutBackImg:YES isHideLeftView:NO];
            [_search customBackGround:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_search"]] autorelease]];
            _search.tag=-1;
            [self.view addSubview:_search];
            [_search release];
            
            //            {//底线
            //                UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_search.frame)-1, _search.frame.size.width, 1)];
            //                line.backgroundColor=ColorDivLine;
            //                line.clipsToBounds=NO;
            //                [_search addSubview:line];
            //                RELEASE(line);
            //            }
        }
        
        if (_str_userid && !_b_isRequested)
        {
            MagicRequest *request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"0" isAlert:NO receive:self];
            [request setTag:1];
            _b_isRequested=YES;
        }
        
        [self observeNotification:[UIViewController AutoRefreshTbvInViewWillAppear]];
        
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        if (!_b_isInMainPage) {
            [self backImgType:0];
        }
        self.rightButton.hidden=YES;
        
        if (!_bt_DropDown) {
            //            UIImage *img= [UIImage imageNamed:@"btn_mainmenu_default"];
            _bt_DropDown = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0,90, self.headHeight)];
            _bt_DropDown.tag=-3;
            _bt_DropDown.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
            //            _bt_DropDown.alpha=0.9;
            [_bt_DropDown addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            //            [_bt_mayKnow setBackgroundImage:img forState:UIControlStateNormal];
            //            [_bt_sendNotice setBackgroundImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
            //            [_bt_DropDown setTitle:@"好友"];
            [_bt_DropDown setTitleColor:[UIColor blackColor]];
            [_bt_DropDown setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
            [self.headview addSubview:_bt_DropDown];
            [_bt_DropDown changePosInSuperViewWithAlignment:2];
            RELEASE(_bt_DropDown);
            
            [self.headview setTitle:(([_str_userid isEqualToString:SHARED.curUser.userid])?(@"好友"):(@"TA的好友"))];
            [self.headview setTitleArrow];
            
        }
        
        if (!_str_userid) {//HTTP请求好友列表
            _str_userid=SHARED.curUser.userid;
            [self.headview setTitle:(([_str_userid isEqualToString:SHARED.curUser.userid])?(@"好友"):(@"TA的好友"))];
            [self.headview setTitleArrow];

        }
        
        if (_str_userid && (!_b_isRequested || self.b_isAutoRefreshTbvInViewWillAppear))
        {
            if (self.b_isAutoRefreshTbvInViewWillAppear) {
                if (nSelMenu==0) {//可能从 最近联系人列表进入他人主页,把他删除好友,再回来,要刷新好友列表
                    MagicRequest *request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"0" isAlert:YES receive:self];
                    [request setTag:1];
                    _b_isRequested=YES;
                }else if (nSelMenu==1)//可能从关注列表进入他人主页,把他删除关注,再回来,要刷新关注列表
                {//HTTP请求|刷新 我关注的
                    MagicRequest *request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"1" isAlert:YES receive:self];
                    [request setTag:2];
                }
                
                self.b_isAutoRefreshTbvInViewWillAppear=NO;
            }else{
                MagicRequest *request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"0" isAlert:YES receive:self];
                [request setTag:1];
                _b_isRequested=YES;
            }
            
        }
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv_friends_myConcern_RecentContacts releaseDataResource];
        
        [_muA_data_friends removeAllObjects];
        [_muA_data_friends release];
        _muA_data_friends=nil;
        
        [_muA_data_MyConcern removeAllObjects];
        [_muA_data_MyConcern release];
        _muA_data_MyConcern=nil;
        
        [self unobserveAllNotification];
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
        
        REMOVEFROMSUPERVIEW(_tbv_friends_myConcern_RecentContacts);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}

#pragma mark- creatTbv
-(void)creatTbv{
    if (!_tbv_friends_myConcern_RecentContacts) {
        _tbv_friends_myConcern_RecentContacts = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight+_search.frame.size.height+1, CGRectGetWidth(self.view.bounds), /*CGRectGetHeight(self.view.bounds)*/((CGRectGetHeight(self.view.bounds)>480/*从 班级切回主社区时会被回调,但不知道为何此时回调的self.view.H大于第一次登陆时的高*/)?(548):(460)) -self.headHeight-_search.frame.size.height) isNeedUpdate:YES];
        _tbv_friends_myConcern_RecentContacts._cellH=65;
        [self.view addSubview:_tbv_friends_myConcern_RecentContacts];
        _tbv_friends_myConcern_RecentContacts.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
        _tbv_friends_myConcern_RecentContacts.tag=-1;
        _tbv_friends_myConcern_RecentContacts._page=1;
        _tbv_friends_myConcern_RecentContacts.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tbv_friends_myConcern_RecentContacts setTableViewType:DTableViewSlime];
        _tbv_friends_myConcern_RecentContacts.v_headerVForHide=_search;
        RELEASE(_tbv_friends_myConcern_RecentContacts);
        _tbv=_tbv_friends_myConcern_RecentContacts;
        
//        _tbv_friends_myConcern_RecentContacts.v_footerVForHide=[[DYBUITabbarViewController sharedInstace] containerView].tabBar;

    }
    
}

- (void)removeNoDataView
{
    if (imgV) {
        REMOVEFROMSUPERVIEW(imgV);
        REMOVEFROMSUPERVIEW(lb);
        REMOVEFROMSUPERVIEW(_bt_gotoSearchFriend);
        
    }
}

#pragma mark- 初始化无数据提示view
-(void)initNoDataView:(NSString *)str
{
    [self removeNoDataView];
    
    if ([str isEqualToString:@""]) {
        return;
    }
    
    if (![_str_userid isEqualToString:SHARED.curUser.userid])
    {
        str = @"一个好友都没有";
    }
    
    UIImage *img=[UIImage imageNamed:@"ybx_big"];
    imgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self.view Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    if (_search.b_isSearching)
    {
        [imgV setFrame:CGRectMake(CGRectGetMinX(imgV.frame), CGRectGetMinY(imgV.frame)-80, CGRectGetWidth(imgV.frame), CGRectGetHeight(imgV.frame))];
    }else{
        [imgV setFrame:CGRectMake(CGRectGetMinX(imgV.frame), CGRectGetMinY(imgV.frame)-40, CGRectGetWidth(imgV.frame), CGRectGetHeight(imgV.frame))];
    }
    RELEASE(imgV);
    
    {
        lb=[[MagicUILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame)+20, 0, 0)];
        lb.backgroundColor=[UIColor clearColor];
        lb.textAlignment=NSTextAlignmentLeft;
        lb.font=[DYBShareinstaceDelegate DYBFoutStyle:20];
        lb.text=str;
        lb.textColor=ColorGray;
        lb.numberOfLines=2;
        lb.lineBreakMode=NSLineBreakByWordWrapping;
        [lb sizeToFitByconstrainedSize:CGSizeMake(240, 1000)];
        [self.view addSubview:lb];
        [lb changePosInSuperViewWithAlignment:0];
        
        lb.linesSpacing=20;
        [lb setNeedCoretext:YES];
        RELEASE(lb);
    }
    
    if ([str isEqualToString:k_noFriends] && !_bt_gotoSearchFriend) {
        //            UIImage *img= [UIImage imageNamed:@"btn_mainmenu_default"];
        _bt_gotoSearchFriend = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, self.headHeight+_search.frame.size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headHeight-_search.frame.size.height)];
        _bt_gotoSearchFriend.tag=-4;
        _bt_gotoSearchFriend.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
        //            _bt_DropDown.alpha=0.9;
        [_bt_gotoSearchFriend addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
        //            [_bt_mayKnow setBackgroundImage:img forState:UIControlStateNormal];
        //            [_bt_sendNotice setBackgroundImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
        //            [_bt_DropDown setTitle:@"好友"];
//        [_bt_DropDown setTitleColor:[UIColor blackColor]];
//        [_bt_DropDown setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
        [self.view addSubview:_bt_gotoSearchFriend];
//        [_bt_DropDown changePosInSuperViewWithAlignment:2];
        RELEASE(_bt_gotoSearchFriend);
        
    }
    
}



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
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
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
                tableView._muA_differHeightCellView=[[NSMutableArray alloc]initWithCapacity:[tableView.muD_allSectionValues allKeys].count];
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
           
            DYBCellForFriendList *cell = [[[DYBCellForFriendList alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[(([tableView isOneSection])?(tableView.muA_singelSectionData):(arr_curSectionForModel)) objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if (!tableView._muA_differHeightCellView) {
                tableView._muA_differHeightCellView=[[NSMutableArray alloc]initWithCapacity:[tableView.muD_allSectionValues allKeys].count];
            }
            
            if (![(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) containsObject:cell]) {
                [(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) addObject:cell];
            }
            
            NSNumber *s = [NSNumber numberWithInteger:cell.frame.size.height];
            [signal setReturnValue:s];
            
        }else{//之前计算过的cell
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForFriendList *)[(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
            [signal setReturnValue:s];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSInteger section = [[dict objectForKey:@"section"] integerValue];
        
        if ([tableView isOneSection]) {/*一个section模式*/

        }else{
            [signal setReturnValue:[tableView.muA_allSectionKeys objectAtIndex:section]];
        }

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
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        [signal setReturnValue:[NSNumber numberWithFloat:((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(0):(27))]];
        
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
        
        if ([_str_userid isEqualToString:SHARED.curUser.userid]) {//自己的好友页
            switch (_tbv_dropDown.row) {
                case 0://好友
                case 1://我关注的
                {
                    friends *model=[[_tbv_friends_myConcern_RecentContacts.muD_allSectionValues objectForKey:[_tbv_friends_myConcern_RecentContacts.muA_allSectionKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
                    
                    DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
                    
//                    [vc addObserverObj:self forKeyPath:@"b_isAutoRefreshTbvInViewWillAppear" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:[self class]];
//                    
//                    for (NSDictionary *d in self._array_observers) {//观察我的人观察的KeyPath==我观察别人的的KeyPath时,观察我的人不观察我了,直接也观察我观察的人
//                        UIViewController *o=[d objectForKey:@"b_isAutoRefreshTbvInViewWillAppear"];//观察我的对象
//                        for (NSDictionary *dd in o._array_targets) {
//                            if ([[[dd allKeys]objectAtIndex:0] isEqualToString:@"b_isAutoRefreshTbvInViewWillAppear"])
//                                //                                [dd setValue:vc forKey:@"b_isAutoRefreshTbvInViewWillAppear"];
//                                [o._array_targets removeObject:dd];
//                            [self removeObserver:o forKeyPath:@"b_isAutoRefreshTbvInViewWillAppear"];
//                            
//                            [vc addObserverObj:o forKeyPath:@"b_isAutoRefreshTbvInViewWillAppear" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:[o class]];
//                            dd=[NSDictionary dictionaryWithObjectsAndKeys:vc,@"b_isAutoRefreshTbvInViewWillAppear", nil];
//                            [o._array_targets addObject:dd];
//                        }
//                    }

                    vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:model.name,@"name",model.id,@"userid", nil];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                case 2://最近联系
                {
                    friends *model=[tableview.muA_singelSectionData objectAtIndex:indexPath.row];
                    
                    DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
                    
                    vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:model.name,@"name",model.id,@"userid", nil];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                default:
                    break;
            }
        }else{//TA的好友页
            switch (_tbv_dropDown.row) {
                case 0://TA的好友
                case 1://我关注的
                {
                    friends *model=[[_tbv_friends_myConcern_RecentContacts.muD_allSectionValues objectForKey:[_tbv_friends_myConcern_RecentContacts.muA_allSectionKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
                    
                    DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
                    
                    vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:model.name,@"name",model.id,@"userid", nil];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                case 2://最近联系
                {
                    friends *model=[tableview.muA_singelSectionData objectAtIndex:indexPath.row];
                    
                    DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
                    
                    vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:model.name,@"name",model.id,@"userid", nil];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                default:
                    break;
            }
        }
     
        
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
        
        if ([_search cancelSearch]) {
            [tableview release_muA_differHeightCellView];
            [tableview resetSectionData];
            [tableview reloadData:YES];
        }
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        {//HTTP请求
            
            MagicRequest *request=nil;
            [_search cancelSearch];
            
            switch (_tbv_dropDown.row) {
                case 0://好友
                {
                    request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"0" isAlert:NO receive:self];
                    [request setTag:1];
                }
                    break;
                case 1://我关注的
                {//HTTP请求|刷新 我关注的
                    
                    request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"1" isAlert:NO receive:self];
                    [request setTag:2];
                }
                    break;
                case 2://最近联系人
                {//HTTP请求|刷新
                    
                    request = [DYBHttpMethod user_recentcontact:_str_userid isAlert:NO receive:self];
                    [request setTag:3];
                }
                    break;
                default:
                    break;
            }
            
            
//            if (!request) {//无网路
//                [tableView setUpdateState:DUpdateStateNomal];
//            }
        }
    }

    else if ([signal is:[MagicUITableView TABLESECTIONINDEXTITLESFORTABLEVIEW]])//右侧索引列表
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if (![tableView isOneSection]) {/*多个section模式*/
            [signal setReturnValue:tableView.muA_allSectionKeys];
        }
    }else if ([signal is:[MagicUITableView TABLESECTIONFORSECTIONINDEXTITLE]])//点击右测是索引列表上的某个字母时回调,参数index和title是 右侧索引列表上被点击的字母在 索引列表的下标和名字,返回被点击的字母对应的section的下标
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSString *title = [dict objectForKey:@"title"];
        NSInteger index = [[dict objectForKey:@"index"] integerValue];

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
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
        [_tbv_friends_myConcern_RecentContacts StretchingUpOrDown:0];
        
        [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];

        [_search resignFirstResponder];
        [_search releaseCancelBt];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [_tbv_friends_myConcern_RecentContacts StretchingUpOrDown:1];
        [[DYBUITabbarViewController sharedInstace] hideTabBar:NO animated:YES];

        [_search resignFirstResponder];
        [_search releaseCancelBt];

    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){//touch
        
        [_search resignFirstResponder];
        [_search releaseCancelBt];
    }
}

#pragma mark- 只接受searchBar信号
- (void)handleViewSignal_MagicUISearchBar:(MagicViewSignal *)signal{
    if ([signal is:[MagicUISearchBar BEGINEDITING]]) {//第一次按下搜索框
        
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
//        if ([[_tbv_friends_myConcern_RecentContacts.muD_allSectionValues allValues] count]>0 || _tbv_friends_myConcern_RecentContacts.muA_singelSectionData.count>0)
        {
            search.showsScopeBar = YES;//控制搜索栏下部的选择栏是否显示出来
            [search setShowsCancelButton:YES animated:YES];
            [search initCancelBt:[UIImage imageNamed:@"btn_search_cancel"] HighlightedImg:[UIImage imageNamed:@"btn_search_cancel"]];
            
        }
//        else{
//            [signal setReturnValue:NO];
//        }
        
    }else if ([signal is:[MagicUISearchBar CANCEL]]){//取消搜索
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
        [_tbv_friends_myConcern_RecentContacts resetSectionData];
        [_tbv_friends_myConcern_RecentContacts reloadData:YES];
        
        if (imgV) {
            [imgV removeFromSuperview];
            imgV = nil;
            [lb removeFromSuperview];
            lb = nil;
        }
        
    }else if ([signal is:[MagicUISearchBar SEARCH]]){//按下搜索按钮
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
//        [search cancelSearch];
        {
            [search resignFirstResponder];
//            self.text=Nil;//消失右边的X号
            
            search.b_isSearching=NO;
                        
            [search releaseCancelBt];
        }
        
    }else if ([signal is:[MagicUISearchBar CHANGEWORD]]){//内容改变
        [imgV removeFromSuperview];
        imgV = nil;
        [lb removeFromSuperview];
        lb = nil;
        
        NSString *str=(NSString *)signal.object;
        MagicUISearchBar *search=(MagicUISearchBar *)signal.source;

        if ([str length] == 0) {//删除完search里的内容            
            [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
            [_tbv_friends_myConcern_RecentContacts resetSectionData];//每个section里的value
            [_tbv_friends_myConcern_RecentContacts reloadData:YES];
            return;
        }
        
        [search sendViewSignal:[MagicUISearchBar SEARCHING] withObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"searchContent",_tbv_friends_myConcern_RecentContacts,@"tbv", nil]];

        
    }else if ([signal is:[MagicUISearchBar SEARCHING]]){//正在搜索
        
        MagicUISearchBar *search=(MagicUISearchBar *)signal.source;
        NSDictionary *d=(NSDictionary *)signal.object;
        UITableView *tbv=[d objectForKey:@"tbv"];
        NSString *searchContent=[d objectForKey:@"searchContent"];
        
        [tbv resetSectionData];//每个section里的value

        if ([tbv isOneSection]) {//循环搜索单section的tbv
            
            NSMutableArray *toRemove = [[NSMutableArray alloc] init];
            
            for (friends *u_info in tbv.muA_singelSectionData) {
                int strLen = [searchContent length];//字符串的长度，一个字母和汉字都算一个
                const char *cString = [searchContent UTF8String];
                int bytLeng = strlen(cString);
                
                NSString *strName = nil;
                NSString *strTrueName = nil;
                
                if(strLen < bytLeng){
                    strName = [NSString stringWithFormat:@"%@", u_info.name];
                    strTrueName = [NSString stringWithFormat:@"%@", u_info.truename];
                }
                else{
                    strName = [NSString stringWithFormat:@"%@",[ChineseToPinyin pinyinFromChiniseString:u_info.name]];
                    strTrueName = [NSString stringWithFormat:@"%@",[ChineseToPinyin pinyinFromChiniseString:u_info.truename]];
                }
                
                if ([strName rangeOfString:searchContent options:NSCaseInsensitiveSearch].location == NSNotFound && [strTrueName rangeOfString:searchContent options:NSCaseInsensitiveSearch].location == NSNotFound)
                    [toRemove addObject:u_info];
                
            }
            
            [tbv.muA_singelSectionData removeObjectsInArray:toRemove];
            [toRemove release];
            
            if ([tbv.muA_singelSectionData count] == 0) {
                
                [self initNoDataView:@"没有数据...."];
            }
            
        }
        else{
            NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];//要被移除的section
            for (NSString *key in tbv.muD_allSectionValues) {
                NSMutableArray *array = [tbv.muD_allSectionValues valueForKey:key];//每个section里的值
                NSMutableArray *toRemove = [[NSMutableArray alloc] init];
                
                for (friends *u_info in array) {
                    int strLen = [searchContent length];//字符串的长度，一个字母和汉字都算一个
                    const char *cString = [searchContent UTF8String];
                    int bytLeng = strlen(cString);
                    
                    NSString *strName = nil;
                    NSString *strTrueName = nil;
                    
                    if(strLen < bytLeng){
                        strName = [NSString stringWithFormat:@"%@", u_info.name];
                        strTrueName = [NSString stringWithFormat:@"%@", u_info.truename];
                    }
                    else{
                        strName = [NSString stringWithFormat:@"%@",[ChineseToPinyin pinyinFromChiniseString:u_info.name]];
                        strTrueName = [NSString stringWithFormat:@"%@",[ChineseToPinyin pinyinFromChiniseString:u_info.truename]];
                    }
                    
                    if ([strName rangeOfString:searchContent options:NSCaseInsensitiveSearch].location == NSNotFound && [strTrueName rangeOfString:searchContent options:NSCaseInsensitiveSearch].location == NSNotFound)
                        [toRemove addObject:u_info];
                    
                }
                
                if ([array count] == [toRemove count])
                    [sectionsToRemove addObject:key];
                
                [array removeObjectsInArray:toRemove];
                
                
                [toRemove release];
            }
            
            [tbv.muA_allSectionKeys removeObjectsInArray:sectionsToRemove];
            [tbv.muD_allSectionValues removeObjectsForKeys:sectionsToRemove];
            [sectionsToRemove release];
            
            if ([[tbv.muD_allSectionValues allValues] count] == 0) {
                
                [self initNoDataView:@"没有数据...."];
            }
        }
        
//        [self performSelectorOnMainThread:@selector(reloadtable) withObject:nil waitUntilDone:YES];
        
        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
        [tbv reloadData];
    }
}

#pragma mark- 接受按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        
        if (bt)
        {
            switch (bt.tag) {
                case -1://发私信
                {
                    friends *d=(friends *)signal.object;

                    DYBSendPrivateLetterViewController *vc = [[DYBSendPrivateLetterViewController alloc] init];
                    vc.model=[NSDictionary dictionaryWithObjectsAndKeys:d.id,@"userid",d.name,@"name",d.pic,@"pic", nil];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                    
                    if ([_search cancelSearch]) {
                        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                        [_tbv_friends_myConcern_RecentContacts resetSectionData];
                        [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                    }
                }
                    break;
                    
                case -2://打电话
                {
                    friends *model=(friends *)signal.object;
                    if (!model.phone||model.phone.length==1) {//没电话
                        return;
                    }
                    
                    {//下移tabbar
                        UIView *v=[[DYBUITabbarViewController sharedInstace] containerView].tabBar;
                        [UIView animateWithDuration:0.3 animations:^{
                            [[[DYBUITabbarViewController sharedInstace] containerView].tabBar setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y+v.frame.size.height, v.frame.size.width, v.frame.size.height)];
                        }completion:^(BOOL b){
                            [DYBUITabbarViewController sharedInstace].v_totalNumOfUnreadMsg.hidden=YES;
                        }];
                        
                    }
                    
                    if (!_bt_cancelViews) {
                        //            UIImage *img= [UIImage imageNamed:@"btn_mainmenu_default"];
                        _bt_cancelViews = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, /*self.view.frame.size.height-250-70*/ self.view.frame.size.height)];
                        _bt_cancelViews.tag=-4;
                        _bt_cancelViews.backgroundColor=[UIColor blackColor];//self.headview.backgroundColor;
                        _bt_cancelViews.alpha=0;
                        [_bt_cancelViews addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                        //            [_bt_mayKnow setBackgroundImage:img forState:UIControlStateNormal];
                        //                        //            [_bt_sendNotice setBackgroundImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
                        //                        [_bt_DropDown setTitle:@"好友"];
                        //                        [_bt_DropDown setTitleColor:[UIColor blackColor]];
                        //                        [_bt_DropDown setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
                        [self.view addSubview:_bt_cancelViews];
                        //                        [_bt_DropDown changePosInSuperViewWithAlignment:2];
                        RELEASE(_bt_cancelViews);
                    }
                    
                    if (!_v_call) {
                        
                        _v_call=[[DYBCallView alloc]initWithFrame:CGRectMake(0, /*self.view.bounds.size.height-70-250*/ self.view.frame.size.height, self.view.frame.size.width, 250+70) model:(friends *)signal.object superV:self.view];
                        [_v_call cutBlurImg:self.view withRect:CGRectMake(0, self.view.bounds.size.height-70-250, _v_call.frame.size.width, _v_call.frame.size.height)];
                        [_v_call setBlurSuperView:self.view];
                        [self.view addSubview:_v_call];
                        _v_call.backgroundColor=[MagicCommentMethod color:255 green:255 blue:255 alpha:0.9];
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            [_v_call setFrame:CGRectMake(0, self.view.bounds.size.height-70-250, _v_call.frame.size.width, _v_call.frame.size.height)];
                            _v_call.bt_cancelViews.alpha=0.7;
                            [_v_call.bt_cancelViews setFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height-250-70 )];
                            
                            DLogInfo(@"_v_call.y == %f", _v_call.frame.origin.y);                           
                            
                        }completion:^(BOOL b){
//                            [_v_call removeFromSuperview];
                            
//                            [self.view addSubview:_v_call];
//                            DLogInfo(@"_v_call.y == %f", _v_call.frame.origin.y);
//                            [_v_call setFrame:CGRectMake(0, self.view.bounds.size.height-70-250, _v_call.frame.size.width, _v_call.frame.size.height)];
//                            [_v_call setNeedBlur:YES];
//                            [_v_call setBlurSuperView:self.view];
                        }];
                        RELEASE(_v_call);
                    }
                    
                }
                    break;
                    
                case -3://顶部打开下拉列表按钮
                {
                    RELEASEVIEW(_tbv_dropDown);
                    if (TraparentView) {
                        RELEASEVIEW(TraparentView);
                    }
                    
                    TraparentView = [[MagicUIButton alloc]initWithFrame:CGRectMake(0, self.headHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.headHeight)];
                    TraparentView.tag = -1000;
                    [TraparentView addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                    TraparentView.backgroundColor = [UIColor clearColor];
                    [self.view addSubview:TraparentView];
                    
                    
                    if (!_tbv_dropDown) {
                        NSArray *arrBtnLable =(([_str_userid isEqualToString:SHARED.curUser.userid])?([[NSArray alloc] initWithObjects:@"好友", @"我关注的", @"最近联系人",nil]):([[NSArray alloc] initWithObjects:@"TA的好友", @"TA关注的人",nil])) ;
                        _tbv_dropDown = [[DYBMenuView alloc]initWithData:arrBtnLable selectRow:nSelMenu];
                        [_tbv_dropDown setHidden:YES];
//                        [self.view insertSubview:_tbv_dropDown belowSubview:self.headview];

                        [self.view addSubview:_tbv_dropDown];
                    }
                    
                    
                    
                    if (bPullDown) {
                        //            [_tabMenu setFrame:CGRectMake(120, 44-CGRectGetHeight(_tabMenu.frame), 100, CGRectGetHeight(_tabMenu.frame))];
                        //            [_tabMenu setHidden:YES];
                        
                        [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:self from:self target:_tbv_dropDown];
                        if (TraparentView) {
                            RELEASEVIEW(TraparentView);
                        }
                    }else{
                        //            [_tabMenu setFrame:CGRectMake(120, 44, 100, CGRectGetHeight(_tabMenu.frame))];
                        //            [_tabMenu setHidden:NO];
                        
                        [self sendViewSignal:[DYBMenuView MENUDOWN] withObject:self from:self target:_tbv_dropDown];
                    }
                    
                    
                    
                    bPullDown = !bPullDown;

                }
                    break;
                case k_tag_bt_cancelViews://取消打电话界面
                {
                    UIView *v=[[DYBUITabbarViewController sharedInstace] containerView].tabBar;

                    [DYBUITabbarViewController sharedInstace].v_totalNumOfUnreadMsg.hidden=NO;

                    [UIView animateWithDuration:0.3 animations:^{
                        [_v_call setFrame:CGRectMake(0, /*self.view.bounds.size.height-70-250*/self.view.frame.size.height, self.view.frame.size.width, 250+70)];
                        _v_call.bt_cancelViews.alpha=0;
                        [_v_call.bt_cancelViews setFrame:CGRectMake(0, 0,self.view.frame.size.width, /*self.view.frame.size.height-250-70*/ self.view.frame.size.height)];
                        
                        {//上移tabbar
                            [[[DYBUITabbarViewController sharedInstace] containerView].tabBar setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y-v.frame.size.height, v.frame.size.width, v.frame.size.height)];
                        }
                        
                    }completion:^(BOOL b){
                        //                        REMOVEFROMSUPERVIEW(_v_call.bt_cancelViews);
                        REMOVEFROMSUPERVIEW(_v_call);
                    }];
                    
                }
                    break;
                    
                case k_tag_bt_ensurelViews://确认打电话
                {
                    NSString *str=(NSString *)signal.object;
                    [str LaunchPhoneCall];
                }
                    break;
//                case k_tag_CancelBt://取消搜索
//                {
//                    MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
//                    [search cancelSearch];
//                }
//                    break;
                    
                case -4://跳转到找人页
                {
                    if (_isPush)
                    {
                        DYBSearchFriendsViewController *searchFriendVc = [[[DYBSearchFriendsViewController alloc]init] autorelease];
                        [self.drNavigationController pushViewController:searchFriendVc animated:YES];
                    }else
                    {
                        DYBUITabbarViewController *con=(DYBUITabbarViewController *)[self.drNavigationController getViewController:[DYBUITabbarViewController class]];
                        con.selectedIndex=3;
                    }
                    
                    [_search cancelSearch];
                }
                    break;
                case -1000://去掉弹出框
                {
                    [_bt_DropDown didTouchUpInside];
                    
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}

#pragma mark- DYBPullDownMenuView消息
- (void)handleViewSignal_DYBDynamicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBDynamicViewController MENUSELECT]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        int  _nSection = [[dict objectForKey:@"section"] intValue];
        nSelMenu=_nSection;
        
        switch (nSelMenu) {
            case 0://好友
            {
                if (!_muA_data_friends) {
                    [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                    [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                    
                    {//HTTP请求|刷新 我关注的
                        
                        
                        MagicRequest *request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"0" isAlert:YES receive:self];
                        [request setTag:1];
                        
//                        if (!request) {//无网路
//                            [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
//                        }
                    }
                }else{
//                    [_tbv_friends_myConcern_RecentContacts._muA_differHeightCellView removeAllObjects];
                    [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                    [self initSectionOrder:_muA_data_friends tbv:_tbv_friends_myConcern_RecentContacts] ;
                    [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                    [self initNoDataView:@""];
                }
                
                [self.headview setTitle:[_tbv_dropDown.arrMenu objectAtIndex:nSelMenu]];
//                bPullDown = !bPullDown;
                
            }
                break;
            case 1://我|TA 关注的
            {
                if (!_muA_data_MyConcern) {
                    [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                    [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                    
                    {//HTTP请求|刷新 我关注的
                        
                        
                        MagicRequest *request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"1" isAlert:YES receive:self];
                        [request setTag:2];
                        
//                        if (!request) {//无网路
//                            [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
//                        }
                    }
                }else{
                    [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                    [self initSectionOrder:_muA_data_MyConcern tbv:_tbv_friends_myConcern_RecentContacts];
                    [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                    [self initNoDataView:@""];
                }
                
                [self.headview setTitle:[_tbv_dropDown.arrMenu objectAtIndex:nSelMenu]];
//                bPullDown = !bPullDown;

            }
                break;
            case 2://最近联系人
            {
//                _tbv_friends_myConcern.hidden=YES;
                
                if (!_tbv_friends_myConcern_RecentContacts.muA_singelSectionData) {
                    [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                    [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                    
                    {//HTTP请求|刷新 最近联系人
                        
                        
                        MagicRequest *request = [DYBHttpMethod user_recentcontact:_str_userid isAlert:YES receive:self];
                        [request setTag:3];
                        
//                        if (!request) {//无网路
//                            [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
//                        }
                    }
                }else{
                    [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                    [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                    
                    [_tbv_friends_myConcern_RecentContacts resetSectionData];//每个section里的value
                    [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                    [self initNoDataView:@""];

                }
                
                [self.headview setTitle:[_tbv_dropDown.arrMenu objectAtIndex:nSelMenu]];


            }
                break;
            default:
                break;
        }
        
        [_search cancelSearch];
        [self.headview setTitleArrow];
        
//        RELEASEVIEW(_tbv_dropDown);
//        [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:nil from:self target:_tbv_dropDown];
//        bPullDown = !bPullDown;
        
        [_bt_DropDown didTouchUpInside];

    }
}


#pragma mark- 创建sectionHeaderView
-(void)createSectionHeaderView:(MagicViewSignal *)signal
{
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSInteger section = [[dict objectForKey:@"section"] integerValue];

    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 27)];
    v.backgroundColor=[MagicCommentMethod color:255 green:255 blue:255 alpha:0.8];
    
    {
        MagicUILabel *lb_title=[[MagicUILabel alloc]initWithFrame:CGRectMake(15,0, 0, 0)];
        lb_title.backgroundColor=[UIColor clearColor];
        lb_title.textAlignment=NSTextAlignmentLeft;
        lb_title.font=[DYBShareinstaceDelegate DYBFoutStyle:20];
        lb_title.text=[_tbv_friends_myConcern_RecentContacts.muA_allSectionKeys objectAtIndex:section];
        [lb_title setNeedCoretext:NO];
        lb_title.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
        lb_title.numberOfLines=1;
        lb_title.lineBreakMode=NSLineBreakByCharWrapping;
        [lb_title sizeToFitByconstrainedSize:CGSizeMake(screenShows.size.width-20, 100)];
        [v addSubview:lb_title];
        [lb_title changePosInSuperViewWithAlignment:1];
        [lb_title setFrame:CGRectMake(CGRectGetMinX(lb_title.frame), CGRectGetMinY(lb_title.frame)+1, CGRectGetWidth(lb_title.frame), CGRectGetHeight(lb_title.frame))];
        RELEASE(lb_title);
    }
    
    {//底线
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, v.frame.size.height-1, tableView.frame.size.width, 1)];
        line.backgroundColor=[MagicCommentMethod color:238 green:238 blue:238 alpha:1];
        line.clipsToBounds=NO;
        [v addSubview:line];
        RELEASE(line);
    }
    
    [signal setReturnValue:v];
//    [v release];
}

#pragma mark- 初始并改变列表section的数据源及顺序
-(void)initSectionOrder:(NSMutableArray *)array tbv:(UITableView *)tbv
{
    [tbv releaseDataResource];
    
    //用于多section
    tbv.muA_allCompareWord = [[NSMutableArray alloc] initWithObjects:@"A", @"B", @"C",@"D", @"E", @"F",@"G", @"H", @"I",@"J", @"K", @"L",@"M", @"N", @"O",@"P", @"Q", @"R",@"S", @"T", @"U",@"V", @"W", @"X",@"Y", @"Z", @"#", nil];
    
    NSString *_str_firstChar = nil;//名字的首字母
    
    NSMutableArray *arrMain = [[NSMutableArray alloc] init];//每个元素是一个NSMutableArray,表示一个section
    for (int i = 0; i < 27; i++) {
        NSMutableArray *arrOne = [[NSMutableArray alloc] init];
        [arrMain addObject:arrOne];
        [arrOne release];
    }
    
    for (int i = 0; i < array.count; i++) {
        friends * u_info = (friends*)[array objectAtIndex:i];
        NSString *strName = nil;
        BOOL isChinesseName=NO;//名字开头第一个字是否是中文
        
        if ([u_info.name length] > 0) {
            strName = [NSString stringWithFormat:@"%@", u_info.name];
            
            if ( [strName IsChinese:NSMakeRange(0, 1)])//名字首字母是汉字
            {
                _str_firstChar = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([strName characterAtIndex:0])] uppercaseString];//把汉字转成对应的英文字母谐音 [ uppercaseString]
                isChinesseName=YES;
            }
            else{
                _str_firstChar = [[strName substringWithRange:NSMakeRange(0, 1)] uppercaseString];
            }
        }
        else{
            strName = [NSString stringWithFormat:@""];
            _str_firstChar = [NSString stringWithFormat:@"#"];
        }
        
        BOOL bAdd  = NO;//修改BUG:无法将以数字或者符号开头的名字加入到好友列表中\
        
        for (int i = 0 ; i < [tbv.muA_allCompareWord count]; i++) {
            if ([_str_firstChar isEqualToString:[tbv.muA_allCompareWord objectAtIndex:i]]) {
                if (isChinesseName) {
                    [[arrMain objectAtIndex:i] addObject:u_info];
                }else{
                    [[arrMain objectAtIndex:i] insertObject:u_info atIndex:0];
                }
                bAdd = YES;
                break;
            }
        }
        
        if (!bAdd) {//把已数字或符号开头的名字加到#section里
            [[arrMain lastObject] addObject:u_info];
        }
    }
    
    for (int i = 0 ; i < [tbv.muA_allCompareWord count]; i++){
        if ([[arrMain objectAtIndex:i] count] > 0) {
            if (!tbv.muA_allSectionKeys) {
                tbv.muA_allSectionKeys=[[NSMutableArray alloc]initWithCapacity:10];
            }
            [tbv.muA_allSectionKeys addObject:[tbv.muA_allCompareWord objectAtIndex:i]];
            
            if (!tbv.muD_allSectionValues) {
                tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithCapacity:10];
            }
            [tbv.muD_allSectionValues setValue:[arrMain objectAtIndex:i] forKey:[tbv.muA_allCompareWord objectAtIndex:i]];
        }
    }
    
    [arrMain release];
}
//
//#pragma mark- 观察者要实现此响应方法
//- (void) observeValueForKeyPath:(NSString *)keyPath
//					   ofObject:(id)object/*被观察者*/
//						 change:(NSDictionary *)change
//						context:(void *)context/*观察者class*/{
//    Class class=(Class)context;
//    NSString *className=[NSString stringWithCString:object_getClassName(class) encoding:NSUTF8StringEncoding];
//    
//    if ([className isEqualToString:[NSString stringWithCString:object_getClassName([self class]) encoding:NSUTF8StringEncoding]]) {
//        self.b_isAutoRefreshTbvInViewWillAppear=[[change objectForKey:@"new"] boolValue];
//        
//    }else{//将不能处理的 key 转发给 super 的 observeValueForKeyPath 来处理
//        [super observeValueForKeyPath:keyPath
//                             ofObject:object
//                               change:change
//                              context:context];
//    }
//    
//}

#pragma mark- 通知中心回调
- (void)handleNotification:(NSNotification *)notification
{
   if ([notification is:[UIViewController AutoRefreshTbvInViewWillAppear]]){
        self.b_isAutoRefreshTbvInViewWillAppear=YES;
    }
}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取|刷新 好友列表
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    NSDictionary *d=[response.data objectForKey:@"user_list"];
                    if (d.count==0) {//无数据时服务器坑爹的发来个数组
                        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                        [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                        [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                        
                        [self initNoDataView:k_noFriends];
                        [_muA_data_friends removeAllObjects];
                        return;
                    }else
                    {
                        [self removeNoDataView];
                    }
                    NSArray *list=[d objectForKey:@"user"];
                    if (_muA_data_friends.count>0 && list.count>0) {
                        [_muA_data_friends removeAllObjects];
                        
                        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                        [_tbv_friends_myConcern_RecentContacts releaseDataResource];

                    }
                    
                    for (NSDictionary *d in list) {
                        friends *model = [friends JSONReflection:d];
                        if (!_muA_data_friends) {
                            _muA_data_friends=[NSMutableArray arrayWithObject:model];
                            [_muA_data_friends retain];
                        }else{
                            [_muA_data_friends addObject:model];
                        }
                    }
                    
                    {
                        if (_muA_data_friends.count>0 && list.count>0) {
                            [self creatTbv];
                            [self initSectionOrder:_muA_data_friends tbv:_tbv_friends_myConcern_RecentContacts];
                            [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv_friends_myConcern_RecentContacts reloadData:NO];
                            }else{
                                [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                            
                            [self initNoDataView:k_noFriends];
                        }
                        
                    }
                    
                    
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                
                [_tbv_friends_myConcern_RecentContacts reloadData:YES];

            }
                
                break;
            case 2://获取|刷新 我关注的列表
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    NSDictionary *d=[response.data objectForKey:@"user_list"];
                    if (d.count==0) {/*无数据,服务器 作死的返回 这种 {
                        havenext = 0;
                        "user_list" =     (
                        );本来user_list对应的值是字典,没数据时却返回数组*/

                        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                        [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                        [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                        
                        
                        [self initNoDataView:@"没有关注的人"];
                        
                        [_muA_data_MyConcern removeAllObjects];

                        return;
                    }
                       
//                    NSDictionary *d=[response.data objectForKey:@"user_list"];
                    NSArray *list=[d objectForKey:@"user"];
                    if (_muA_data_MyConcern.count>0 && list.count>0) {
                        [_muA_data_MyConcern removeAllObjects];
                        
                        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                        [_tbv_friends_myConcern_RecentContacts releaseDataResource];

                    }
                    
                    for (NSDictionary *d in list) {
                        friends *model = [friends JSONReflection:d];
                        if (!_muA_data_MyConcern) {
                            _muA_data_MyConcern=[NSMutableArray arrayWithObject:model];
                            [_muA_data_MyConcern retain];
                        }else{
                            [_muA_data_MyConcern addObject:model];
                        }
                    }
                    
                    {
                        if (_muA_data_MyConcern.count>0) {
                            [self initNoDataView:@""];
                            [self creatTbv];
                            [self initSectionOrder:_muA_data_MyConcern tbv:_tbv_friends_myConcern_RecentContacts];
                            [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv_friends_myConcern_RecentContacts reloadData:NO];
                            }else{
                                [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
//                            [_tbv_friends_myConcern_RecentContacts.headerView changeState:PULLSTATENORMAL];
                            
                            [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                            [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                            [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                            [self initNoDataView:@"没有关注的人"];
                        }
                        
                    }
                    
                    
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                
                [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                
            }
                
                break;
                
            case 3://获取最近联系人
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    NSDictionary *d=[response.data objectForKey:@"user_list"];
                    if (d.count==0) {//无数据时服务器坑爹的发来个数组
                        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                        [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                        [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                        
                        
                        [self initNoDataView:@"没有最近联系人"];

                        return;
                    }
                    NSArray *list=[d objectForKey:@"user"];
                    if (_tbv_friends_myConcern_RecentContacts.muA_singelSectionData.count>0 && list.count>0) {
                        [_tbv_friends_myConcern_RecentContacts.muA_singelSectionData removeAllObjects];
                        
                        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                        [_tbv_friends_myConcern_RecentContacts releaseDataResource];

                    }
                    
                    for (NSDictionary *d in list) {
                        friends *model = [friends JSONReflection:d];
                        if (!_tbv_friends_myConcern_RecentContacts.muA_singelSectionData) {
                            _tbv_friends_myConcern_RecentContacts.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv_friends_myConcern_RecentContacts.muA_singelSectionData retain];
                        }else{
                            [_tbv_friends_myConcern_RecentContacts.muA_singelSectionData addObject:model];
                        }
                    }
                    
                    {
                        if (_tbv_friends_myConcern_RecentContacts.muA_singelSectionData.count>0) {
//                            [self initSectionOrder:1];
//                            [self creat_tbv_RecentContacts];
                            [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                            [self initNoDataView:@""];
//                            _tbv_friends_myConcern_RecentContacts.muA_singelSectionData=_muA_data_RecentContacts;
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv_friends_myConcern_RecentContacts reloadData:NO];
                            }else{
                                [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
//                            [_tbv_friends_myConcern_RecentContacts.headerView changeState:PULLSTATENORMAL];
                            [self initNoDataView:@"没有最近联系人"];
                            [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                            [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                            [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                        }
                        
                    }
                    
                    
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    {//无数据时
                        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                        [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                        [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                        
                        
                        [self initNoDataView:@"没有最近联系人"];
                        
                        return;
                    }
                }
                
                
                [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                
            }
                break;
            default:
                break;
        }
    }
}
@end
