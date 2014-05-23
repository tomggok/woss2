//
//  DYBSearchFriendsViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSearchFriendsViewController.h"
#import "UITableView+property.h"
#import "user.h"
#import "DYBCellForMayKnowFriends.h"
#import "DYBCellForNearBy.h"
#import "nearByFriends.h"
#import "UIView+MagicCategory.h"
#import "DYBPersonalHomePageViewController.h"
#import "ChineseToPinyin.h"
#import "DYBSearchResultViewController.h"
#import "DYBUITabbarViewController.h"
#import "DYBUse_mutualfriendViewController.h"
#import "DYBMapView.h"

@interface DYBSearchFriendsViewController ()
{
    MagicUIImageView *_imgV_noData;
    MagicUILabel *_lb_noData;
    NSMutableArray *_muA_mayKnow,*_muA_nearBy;
}
@end

@implementation DYBSearchFriendsViewController

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        if (!_search) {
            _search=[[MagicUISearchBar alloc]initWithFrame:CGRectMake(0, self.headHeight, self.view.frame.size.width, 50) backgroundColor:ColorNav placeholder:@"昵称/姓名/学校" isHideOutBackImg:YES isHideLeftView:NO];
            [_search customBackGround:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_search"]] autorelease]];
            _search.tag=-1;
            [self.view addSubview:_search];
            [_search release];
        }
        
        {//按钮和tbv的背景
            _v_bt_tbv=[[UIView alloc]initWithFrame:CGRectMake(0, _search.frame.origin.y+_search.frame.size.height, self.view.frame.size.width, CGRectGetHeight(self.view.bounds)-self.headHeight-_search.frame.size.height-kH_StateBar)];
            _v_bt_tbv.backgroundColor=[UIColor clearColor];
            
            [self.view addSubview:_v_bt_tbv];
            RELEASE(_v_bt_tbv);
            
            _v_bt_tbv.v_headerVForHide=_search;
            
            //            _v_bt_tbv.v_footerVForHide=[[DYBUITabbarViewController sharedInstace] containerView].tabBar;
            
            
        }
        
        {
            _v_btBack=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 57)];
            _v_btBack.backgroundColor=[MagicCommentMethod color:255 green:255 blue:255 alpha:0.3];
            
            [_v_bt_tbv addSubview:_v_btBack];
            RELEASE(_v_btBack);
        }
        
        if (!_bt_mayKnow) {
            UIImage *img= [UIImage imageNamed:@"2tabs_left_def"];
            _bt_mayKnow = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0,img.size.width/2, img.size.height/2)];
            _bt_mayKnow.tag=-1;
            _bt_mayKnow.showsTouchWhenHighlighted=YES;
            _bt_mayKnow.backgroundColor=[UIColor clearColor];
            [_bt_mayKnow addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_mayKnow setBackgroundImage:img forState:UIControlStateNormal];
            [_bt_mayKnow setBackgroundImage:[UIImage imageNamed:@"2tabs_left_sel"] forState:UIControlStateSelected];
            [_bt_mayKnow setTitle:@"可能认识的人"];
            [_bt_mayKnow setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:14]];
            [_v_btBack addSubview:_bt_mayKnow];
            [_bt_mayKnow changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_mayKnow);
            _bt_mayKnow.selected=YES;
            //            [_bt_mayKnow changeStateImg:UIControlStateSelected];
        }
        
        if (!_bt_nearBy) {
            UIImage *img= [UIImage imageNamed:@"2tabs_right_def"];
            _bt_nearBy = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_mayKnow.frame.origin.x+_bt_mayKnow.frame.size.width, _bt_mayKnow.frame.origin.y,_bt_mayKnow.frame.size.width, _bt_mayKnow.frame.size.height)];
            _bt_nearBy.tag=-2;
            _bt_nearBy.showsTouchWhenHighlighted=YES;
            _bt_nearBy.backgroundColor=[UIColor clearColor];
            [_bt_nearBy addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_nearBy setBackgroundImage:img forState:UIControlStateNormal];
            [_bt_nearBy setBackgroundImage:[UIImage imageNamed:@"2tabs_right_sel"] forState:UIControlStateSelected];
            [_bt_nearBy setTitle:@"附近的人"];
            [_bt_nearBy setTitleColor:ColorBlue];
            [_bt_nearBy setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:14]];
            [_v_btBack addSubview:_bt_nearBy];
            //            [_bt_mayKnow changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_nearBy);
            
            [_bt_mayKnow setFrame:CGRectMake((_v_btBack.frame.size.width-_bt_mayKnow.frame.size.width-_bt_nearBy.frame.size.width)/2, _bt_mayKnow.frame.origin.y, _bt_mayKnow.frame.size.width, _bt_mayKnow.frame.size.height)];
            [_bt_nearBy setFrame:CGRectMake(_bt_mayKnow.frame.origin.x+_bt_mayKnow.frame.size.width, _bt_mayKnow.frame.origin.y,_bt_mayKnow.frame.size.width, _bt_mayKnow.frame.size.height)];
        }
        
        {//HTTP请求
            
            
            MagicRequest *request = [DYBHttpMethod user_recommendlist_userid:[NSString stringWithFormat:@"%d",numsOfPage] isAlert:NO receive:self];
            [request setTag:1];
            
            //            if (!request) {//无网路
            //                [_tbv_mayKnow.footerView changeState:VIEWTYPEFOOTER];
            //            }
        }
        
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        
        if (!_b_isInMainPage) {
            [self backImgType:0];
        }
        
        [self.headview setTitle:@"找人"];
        //        [self backImgType:0];
        self.rightButton.hidden=YES;
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }
    else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        //        [_tbv_mayKnow releaseDataResource];
        //        [_tbv_nearBy releaseDataResource];
        [_tbv releaseDataResource];
        
        //        [_muA_data_mayKnow removeAllObjects];
        //        [_muA_data_mayKnow release];
        //        _muA_data_mayKnow=nil;
        
        //        [_tbv_nearBy.muA_singelSectionData removeAllObjects];
        //        [_tbv_nearBy.muA_singelSectionData release];
        //        _tbv_nearBy.muA_singelSectionData=nil;
        
    }
    else if ([signal is:[MagicViewController DELETE_VIEWS]]){
        
        //        [_tbv_mayKnow release_muA_differHeightCellView];
        //        RELEASEVIEW(_tbv_mayKnow);//界面不显示时彻底释放TBV,已释放cell
        //
        //        [_tbv_nearBy release_muA_differHeightCellView];
        //        RELEASEVIEW(_tbv_nearBy);//界面不显示时彻底释放TBV,已释放cell
        
        [_tbv release_muA_differHeightCellView];
        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
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

#pragma mark-
//-(void)creat_tbv_mayKnow{
//    if (!_tbv_mayKnow) {
//        _tbv_mayKnow = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, _v_btBack.frame.origin.y+_v_btBack.frame.size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(_v_bt_tbv.bounds)-CGRectGetHeight(_v_btBack.bounds)) isNeedUpdate:YES];
//        _tbv_mayKnow._cellH=65;
//        _tbv_mayKnow._originFrame=CGRectMake(0, _v_btBack.frame.origin.y+_v_btBack.frame.size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(_v_bt_tbv.bounds)-CGRectGetHeight(_v_btBack.bounds));
//        [_v_bt_tbv insertSubview:_tbv_mayKnow belowSubview:_v_btBack];
//        _tbv_mayKnow.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
//        _tbv_mayKnow.tag=-1;
//        _tbv_mayKnow._page=1;
//        _tbv_mayKnow.separatorStyle=UITableViewCellSeparatorStyleNone;
//        [_tbv_mayKnow setTableViewType:DTableViewSlime];
////        _tbv_mayKnow.v_footerVForHide=[[DYBUITabbarViewController sharedInstace] get_containerView].tabBar;
//
//    }
//
//}

#pragma mark-
//-(void)creat_tbv_nearBy{
//    if (!_tbv_nearBy) {
//        _tbv_nearBy = [[MagicUITableView alloc] initWithFrame:_tbv_mayKnow.frame isNeedUpdate:YES];
//        _tbv_nearBy._cellH=65;
//        _tbv_nearBy._originFrame=CGRectMake(0, _v_btBack.frame.origin.y+_v_btBack.frame.size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(_v_bt_tbv.bounds)-CGRectGetHeight(_v_btBack.bounds));
//        [_v_bt_tbv insertSubview:_tbv_nearBy belowSubview:_v_btBack];
//        _tbv_nearBy.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
//        _tbv_nearBy.tag=-2;
//        _tbv_nearBy._page=1;
//        _tbv_nearBy.hidden=NO;
//        _tbv_nearBy.separatorStyle=UITableViewCellSeparatorStyleNone;
//        [_tbv_nearBy setTableViewType:DTableViewSlime];
////        _tbv_nearBy.v_footerVForHide=[[DYBUITabbarViewController sharedInstace] get_containerView].tabBar;
//
//    }
//
//}

-(void)creat_tbv{
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, _v_btBack.frame.origin.y+_v_btBack.frame.size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(_v_bt_tbv.bounds)-CGRectGetHeight(_v_btBack.bounds)) isNeedUpdate:YES];
        _tbv._cellH=65;
        _tbv._originFrame=CGRectMake(0, _v_btBack.frame.origin.y+_v_btBack.frame.size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(_v_bt_tbv.bounds)-CGRectGetHeight(_v_btBack.bounds));
        [_v_bt_tbv insertSubview:_tbv belowSubview:_v_btBack];
        _tbv.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
        _tbv.tag=-1;
        _tbv._page=1;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tbv setTableViewType:DTableViewSlime];
        //        _tbv_mayKnow.v_footerVForHide=[[DYBUITabbarViewController sharedInstace] get_containerView].tabBar;
        
    }
    
}

#pragma mark- 初始化无数据提示view
-(void)initNoDataView:(NSString *)str
{
    if (!_imgV_noData) {
        UIImage *img=[UIImage imageNamed:@"ybx_big"];
        MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self.view Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        _imgV_noData=imgV;
        [imgV setFrame:CGRectMake(CGRectGetMinX(imgV.frame), CGRectGetMinY(imgV.frame), CGRectGetWidth(imgV.frame), CGRectGetHeight(imgV.frame))];
        RELEASE(imgV);
    }
    
    
    if(!_lb_noData){
        MagicUILabel *lb=[[MagicUILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imgV_noData.frame)+20, 0, 0)];
        _lb_noData=lb;
        lb.backgroundColor=[UIColor clearColor];
        lb.textAlignment=NSTextAlignmentLeft;
        lb.font=[DYBShareinstaceDelegate DYBFoutStyle:20];
        lb.text=str;
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
    
}

-(void)releaseNoDataView
{
    REMOVEFROMSUPERVIEW(_imgV_noData);
    REMOVEFROMSUPERVIEW(_lb_noData);
    
}


#pragma mark- 接受tbv信号

static NSString *cellNameFormayKnow = @"cellNameFormayKnow";//可能认识的人
static NSString *cellNameForNearBy = @"cellNameForNearBy";//

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
            DYBCellForMayKnowFriends *cell_DYBCellForMayKnowFriends=nil;
            DYBCellForNearBy *cell_DYBCellForNearBy=nil;
            
            if (/*!_tbv_mayKnow.hidden*/ _bt_mayKnow.selected) {
                cell_DYBCellForMayKnowFriends = [[[DYBCellForMayKnowFriends alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNameFormayKnow] autorelease];
                [(DYBCellForMayKnowFriends *)cell_DYBCellForMayKnowFriends setContent:[(([tableView isOneSection])?(tableView.muA_singelSectionData):(arr_curSectionForModel)) objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
                
            }else{
                cell_DYBCellForNearBy=[[[DYBCellForNearBy alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNameForNearBy] autorelease];
                [(DYBCellForNearBy *)cell_DYBCellForNearBy setContent:[(([tableView isOneSection])?(tableView.muA_singelSectionData):(arr_curSectionForModel)) objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
                
            }
            
            if (!tableView._muA_differHeightCellView) {
                tableView._muA_differHeightCellView=[[NSMutableArray alloc]initWithCapacity:[tableView.muD_allSectionValues allKeys].count];
            }
            
            if (![(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) containsObject:((_bt_mayKnow.selected)?(cell_DYBCellForMayKnowFriends):(cell_DYBCellForNearBy))]) {
                [(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) addObject:((_bt_mayKnow.selected)?(cell_DYBCellForMayKnowFriends):(cell_DYBCellForNearBy))];
            }
            
            NSNumber *s = [NSNumber numberWithInteger:((_bt_mayKnow.selected)?(cell_DYBCellForMayKnowFriends):(cell_DYBCellForNearBy)).frame.size.height];
            [signal setReturnValue:s];
            
        }else{//之前计算过的cell
            NSNumber *s = [NSNumber numberWithInteger:((UITableViewCell *)[(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
            [signal setReturnValue:s];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
    {
        //        NSDictionary *dict = (NSDictionary *)[signal object];
        //        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        [signal setReturnValue:nil];
        
    }//
    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
    {
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        
    }
    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell  只返回显示的cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:((/*!_tbv_mayKnow.hidden*/ _bt_mayKnow.selected)?(cellNameFormayKnow):(cellNameForNearBy))];
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
        
        if (_bt_mayKnow.selected) {
            user *model=[_tbv.muA_singelSectionData objectAtIndex:indexPath.row];
            
            DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
            vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:model.name,@"name",model.userid,@"userid", nil];
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
        }else{
            nearByFriends *model=[_tbv.muA_singelSectionData objectAtIndex:indexPath.row];
            
            DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
            vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:model.name,@"name",model.userid,@"userid", nil];
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
        }
        
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        {//HTTP请求
            
            
            //            MagicRequest *request = [DYBHttpMethod searchNearby:@"5" latitude:@"31.292900" longitude:@"121.508504" page:[NSString stringWithFormat:@"%d",++tableView._page] userid:SHARED.curUser.userid isAlert:YES receive:self];
            
            MagicRequest *request = [DYBHttpMethod searchNearby:@"5" latitude:[[NSUserDefaults standardUserDefaults] objectForKey:k_Signlat] longitude:[[NSUserDefaults standardUserDefaults] objectForKey:k_Signlng] page:[NSString stringWithFormat:@"%d",++tableView._page] userid:SHARED.curUser.userid isAlert:NO receive:self];
            
            [request setTag:3];
            
            if (!request) {//无网路
                [tableView reloadData:NO];
            }
        }
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        {//HTTP请求
            
            
            if (/*!_tbv_mayKnow.hidden*/ _bt_mayKnow.selected) {//刷新 可能认识的人
                MagicRequest *request = [DYBHttpMethod user_recommendlist_userid:[NSString stringWithFormat:@"%d",numsOfPage] isAlert:NO receive:self];
                [request setTag:1];
                
                if (!request) {//无网路
                    [tableView reloadData:NO];
                }
            }else{
                //                MagicRequest *request = [DYBHttpMethod searchNearby:@"5" latitude:@"31.292900" longitude:@"121.508504" page:[NSString stringWithFormat:@"%d",(tableView._page=1)] userid:SHARED.curUser.userid isAlert:YES receive:self];
                
                MagicRequest *request = [DYBHttpMethod searchNearby:@"5" latitude:[[NSUserDefaults standardUserDefaults] objectForKey:k_Signlat] longitude:[[NSUserDefaults standardUserDefaults] objectForKey:k_Signlng] page:[NSString stringWithFormat:@"%d",(tableView._page=1)] userid:SHARED.curUser.userid isAlert:NO receive:self];
                
                [request setTag:2];
                
                //                if (!request) {//无网路
                //                    [tableView reloadData:NO];
                //                }
            }
            
        }
    }
    
    else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        
        [_v_bt_tbv StretchingUpOrDown:0];
        [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            //            [_tbv_mayKnow setFrame:CGRectMake(_tbv.frame.origin.x, 0, _tbv.frame.size.width, _v_bt_tbv.frame.size.height)];
            //            [_tbv_nearBy setFrame:CGRectMake(_tbv_nearBy.frame.origin.x, 0, _tbv.frame.size.width, _v_bt_tbv.frame.size.height)];
            [_tbv setFrame:CGRectMake(_tbv.frame.origin.x, 0, _tbv.frame.size.width, _v_bt_tbv.frame.size.height)];
            
        }completion:^(BOOL b){
            
        }];
        
        [_search resignFirstResponder];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [UIView animateWithDuration:0 animations:^{
            //            [_tbv_mayKnow setFrame:_tbv_mayKnow._originFrame];
            //            [_tbv_nearBy setFrame:_tbv_nearBy._originFrame];
            [_tbv setFrame:_tbv._originFrame];
            
        }completion:^(BOOL b){
            
        }];
        [_v_bt_tbv StretchingUpOrDown:1];
        [_search resignFirstResponder];
        [[DYBUITabbarViewController sharedInstace] hideTabBar:NO animated:YES];
        
        
    }
}

#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal
{
    if ([signal is:[UIView TAP]]) {//单击信号
        NSDictionary *d=(NSDictionary *)signal.object;
        NSString *userid=[[d objectForKey:@"object"] objectForKey:@"userid"];
        
        DYBUse_mutualfriendViewController *con=[[DYBUse_mutualfriendViewController alloc]init];
        con.userid=userid;
        [self.drNavigationController pushViewController:con animated:YES];
        RELEASE(con);
    }
}

#pragma mark- 只接受searchBar信号
- (void)handleViewSignal_MagicUISearchBar:(MagicViewSignal *)signal{
    if ([signal is:[MagicUISearchBar BEGINEDITING]]) {//第一次按下搜索框
        
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        {
            search.showsScopeBar = YES;//控制搜索栏下部的选择栏是否显示出来
            [search setShowsCancelButton:YES animated:YES];
            [search initShadeBt];
            [search initCancelBt:[UIImage imageNamed:@"btn_search_cancel"] HighlightedImg:[UIImage imageNamed:@"btn_search_cancel"]];
            
        }
        
    }else if ([signal is:[MagicUISearchBar CANCEL]]){//取消搜索
        //        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
    }else if ([signal is:[MagicUISearchBar SEARCH]]){//按下搜索按钮
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
        DYBSearchResultViewController *vc=[[DYBSearchResultViewController alloc]init];
        
        vc.str_searchContent=search.text;
        
        [_search cancelSearch];
        
        [self.drNavigationController pushViewController:vc animated:YES animationType:ANIMATION_TYPE_FADE];
        RELEASE(vc);
        
        
        
    }else if ([signal is:[MagicUISearchBar CHANGEWORD]]){//内容改变
        NSString *str=(NSString *)signal.object;
        MagicUISearchBar *search=(MagicUISearchBar *)signal.source;
        
        if ([str length] == 0) {//删除完search里的内容
            //            if (!_tbv_mayKnow.hidden) {
            //                [_tbv_mayKnow release_muA_differHeightCellView];
            //                [_tbv_mayKnow resetSectionData];
            //                [_tbv_mayKnow reloadData:YES];
            //            }else{
            //                [_tbv_nearBy release_muA_differHeightCellView];
            //                [_tbv_nearBy resetSectionData];
            //                [_tbv_nearBy reloadData:YES];
            //            }
            return;
        }
        
        //        [search sendViewSignal:[MagicUISearchBar SEARCHING] withObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"searchContent",((!_tbv_mayKnow.hidden)?(_tbv_mayKnow):(_tbv_nearBy)),@"tbv", nil]];
        
        
    }else if ([signal is:[MagicUISearchBar SEARCHING]]){
        
    }
}


#pragma mark- 接受按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        if (bt)
        {
            switch (bt.tag) {
                case -1://可能认识的人
                {
                    [_tbv setHidden:NO];
                    //                    _tbv_nearBy.hidden=YES;
                    _bt_mayKnow.selected=YES;
                    _bt_nearBy.selected=NO;
                    //                    _tbv_mayKnow.hidden=NO;
                    
                    [_bt_mayKnow setTitleColor:[UIColor whiteColor]];
                    [_bt_nearBy setTitleColor:ColorBlue];
                    
                    if (_muA_mayKnow.count==0) {//可能认识的人
                        MagicRequest *request = [DYBHttpMethod user_recommendlist_userid:[NSString stringWithFormat:@"%d",numsOfPage] isAlert:YES receive:self];
                        [request setTag:1];
                        
                        //                        if (!request) {//无网路
                        //                            [_tbv_mayKnow.footerView changeState:VIEWTYPEFOOTER];
                        //                        }
                    }else{
                        //                        _tbv_mayKnow.hidden=NO;
                        [self releaseNoDataView];
                        
                        [_tbv release_muA_differHeightCellView];
                        //                        [_tbv releaseDataResource];
                        _tbv.muA_singelSectionData=_muA_mayKnow;
                        [_tbv reloadData];
                        
                    }
                }
                    break;
                    
                case -2://附近的
                {
                    [_tbv setHidden:NO];
                    _bt_mayKnow.selected=NO;
                    _bt_nearBy.selected=YES;
                    //                    _tbv_mayKnow.hidden=YES;
                    //                    _tbv_nearBy.hidden=NO;
                    
                    [_bt_mayKnow setTitleColor:ColorBlue];
                    [_bt_nearBy setTitleColor:[UIColor whiteColor]];
                    _tbv.muA_singelSectionData=Nil;
                    
                    //                    if(!_tbv_nearBy){//HTTP请求
                    //                        
                    //
                    //                        MagicRequest *request = [DYBHttpMethod searchNearby:@"5" latitude:[[NSUserDefaults standardUserDefaults] objectForKey:k_Signlat] longitude:[[NSUserDefaults standardUserDefaults] objectForKey:k_Signlng] page:@"1" userid:SHARED.curUser.userid isAlert:YES receive:self];
                    //                        [request setTag:2];
                    //
                    //                        if (!request) {//无网路
                    //                            [_tbv_nearBy.footerView changeState:VIEWTYPEFOOTER];
                    //                        }
                    //                    }else{
                    //                        _tbv_nearBy.hidden=NO;
                    //                    }
                    if (_muA_nearBy.count>0) {
                        _tbv.muA_singelSectionData=_muA_nearBy;
                        [_tbv release_muA_differHeightCellView];
                        [_tbv reloadData];
                        [self releaseNoDataView];
                        break;
                    }
                    
                    if ( ([[NSUserDefaults standardUserDefaults] stringForKey:k_Signlat]) && ([[NSUserDefaults standardUserDefaults] stringForKey:k_Signlng])) {//在沙盒获得的经纬度必须存在且!=0再调接口
                        
                        
                        
                        MagicRequest *request = [DYBHttpMethod searchNearby:@"5" latitude:[[NSUserDefaults standardUserDefaults] objectForKey:k_Signlat] longitude:[[NSUserDefaults standardUserDefaults] objectForKey:k_Signlng] page:@"1" userid:SHARED.curUser.userid isAlert:YES receive:self];
                        [request setTag:2];
                    }else{
                        //                        [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"请在“设置-隐私-定位服务”中开启“易班”后，重新尝试，谢谢！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
                        {
                            MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                            [pop setDelegate:self];
                            [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                            [pop setText:@"请在“设置-隐私-定位服务”中开启“易班”后，重新尝试，谢谢！"];
                            [pop alertViewAutoHidden:1.5f isRelease:YES];
                        }
                        
                        [self initNoDataView:@"没有找到..."];
                        [_tbv release_muA_differHeightCellView];
                        [_tbv reloadData];
                    }
                }
                    break;
                case k_tag_fadeBt://取消search的背景按钮
                {
                    if ([_search cancelSearch]) {
                        [_search sendViewSignal:[MagicUISearchBar CANCEL] withObject:_search];
                        
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取|刷新 可能认识的
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                [_tbv setHidden:NO];
                if ([response response] ==khttpsucceedCode)
                {
                    NSDictionary *d=[response.data objectForKey:@"user_list"];
                    if (d && [d count] > 0)
                    {
                        NSArray *list=[d objectForKey:@"user"];
                        
                        if (_muA_mayKnow.count>0 && list.count>0 ) {
                            [_muA_mayKnow removeAllObjects];
                            
                            [_tbv release_muA_differHeightCellView];
                        }
                        
                        for (NSDictionary *d in list) {
                            user *model = [user JSONReflection:d];
                            if (!_muA_mayKnow) {
                                [self creat_tbv];
                                _muA_mayKnow=[NSMutableArray arrayWithObject:model];
                                [_muA_mayKnow retain];
                            }else{
                                [_muA_mayKnow addObject:model];
                            }
                        }
                        
                        {
                            if (_muA_mayKnow.count>0 && list.count>0 ) {
                                [_tbv._muA_differHeightCellView removeAllObjects];
                                _tbv.muA_singelSectionData=_muA_mayKnow;
                                
                                [self releaseNoDataView];
                                
                                if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                    [_tbv reloadData:NO];
                                }else{
                                    [_tbv reloadData:YES];
                                }
                            }else{//没获取到数据,恢复headerView
                                
                                //                                [_tbv releaseDataResource];
                                [_tbv release_muA_differHeightCellView];
                                [self initNoDataView:@"没有找到..."];
                                [_tbv reloadData:YES];
                            }
                            
                        }
                        
                        
                    }else{
                        //                        [_tbv releaseDataResource];
                        [_tbv release_muA_differHeightCellView];
                        [self initNoDataView:@"没有找到..."];
                        [_tbv setHidden:YES];
                    }
                    
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    //                    [_tbv releaseDataResource];
                    [_tbv release_muA_differHeightCellView];
                    [self initNoDataView:@"没有找到..."];
                    [_tbv setHidden:YES];
                }
                
                
                //                [_tbv_mayKnow.footerView changeState:PULLSTATEEND];
                
            }
                
                break;
                
            case 2://获取|刷新 附近的人
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"user_list"];
                    
                    if (_muA_nearBy.count>0 && list.count>0 ) {
                        //                        [_tbv  releaseDataResource];
                        [_tbv release_muA_differHeightCellView];
                        [_muA_nearBy removeAllObjects];
                    }
                    
                    for (NSDictionary *d in list) {
                        nearByFriends *model = [nearByFriends JSONReflection:d];
                        if (!_muA_nearBy) {
                            [self creat_tbv];
                            _muA_nearBy=[NSMutableArray arrayWithObject:model];
                            [_muA_nearBy retain];
                        }else{
                            [_muA_nearBy addObject:model];
                        }
                    }
                    
                    {
                        if (_muA_nearBy.count>0 && list.count>0 ) {
                            [_tbv._muA_differHeightCellView removeAllObjects];
                            [self releaseNoDataView];
                            _tbv.muA_singelSectionData=_muA_nearBy;
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                            
                        }else{//没获取到数据,恢复headerView
                            [_tbv.muA_singelSectionData removeAllObjects];
                            [_tbv release_muA_differHeightCellView];
                            [_tbv reloadData:YES];
                            [self initNoDataView:@"没有找到..."];
                        }
                        
                    }
                    
                    
                    return;
                    
                }else if ([response response] ==khttpfailCode)
                {
                    [_tbv.muA_singelSectionData removeAllObjects];
                    [_tbv release_muA_differHeightCellView];
                    [self initNoDataView:@"没有找到..."];
                }
                
                
                //                [_tbv_nearBy.footerView changeState:PULLSTATEEND];
                
                
            }
                break;
                
            case 3://附近的人加载更多
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"user_list"];
                    for (NSDictionary *d in list) {
                        nearByFriends *model = [nearByFriends JSONReflection:d];
                        if (!_muA_nearBy) {
                            _muA_nearBy=[NSMutableArray arrayWithObject:model];
                            [_muA_nearBy retain];
                        }else{
                            [_muA_nearBy addObject:model];
                        }
                    }
                    
                    {//加载更多
                        if (_muA_nearBy.count>0 && list.count>0) {
                            
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
                
                
                //                [_tbv_nearBy.footerView changeState:PULLSTATEEND];
                
                
            }
                break;
                
            default:
                break;
        }
    }
}


@end
