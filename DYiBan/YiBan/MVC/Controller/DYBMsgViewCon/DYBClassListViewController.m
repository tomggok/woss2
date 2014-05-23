//
//  DYBClassListViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBClassListViewController.h"
#import "UITableView+property.h"
#import "DYBCellForClassList.h"
#import "user.h"
#import "eclass.h"
#import "DYYBClassHomePageViewController.h"
#import "DYBClassMemberViewController.h"
#import "UIView+MagicCategory.h"
#import "UITableView+property.h"
#import "DYBGuideView.h"

@interface DYBClassListViewController ()

@end

@implementation DYBClassListViewController

@synthesize type=_type,muA_noticeArea=_muA_noticeArea,i_classIDByClassHome=_i_classIDByClassHome;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        switch (_type) {
            case 0://从班级主页进来
            {//HTTP请求已加入的班级列表                
                MagicRequest *request = [DYBHttpMethod user_myeclass_list:SHARED.curUser.userid isAlert:YES receive:self];
                [request setTag:1];
            }
                break;
            case 1://发通知选择通知范围
            {//HTTP请求已加入的班级列表
                MagicRequest *request = [DYBHttpMethod eclass_managelist:SHARED.curUser.userid isAlert:YES receive:self];
                [request setTag:3];
            }
            default:
                break;
        }
        
        
//        [self creatTbv];
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"选择班级"];
        [self backImgType:0];
        
        switch (_type) {
            case 0:
            {
                self.rightButton.hidden=YES;
            }
                break;
                
            case 1:
            {
                if (!_bt_ok) {//
                    UIImage *img= [UIImage imageNamed:@"btn_ok_def"];
                    _bt_ok = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.headview.frame.size.width-img.size.width/2, 0, img.size.width/2, img.size.height/2)];
                    _bt_ok.backgroundColor=[UIColor clearColor];
                    _bt_ok.tag=-1;
                    [_bt_ok addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                    [_bt_ok setImage:img forState:UIControlStateNormal];
                    [_bt_ok setImage:img forState:UIControlStateHighlighted];
                    [_bt_ok setImage:[UIImage imageNamed:@"btn_ok_dis"] forState:UIControlStateDisabled];
                    [self.headview addSubview:_bt_ok];
                    //            _bt_send.showsTouchWhenHighlighted=YES;
                    [_bt_ok changePosInSuperViewWithAlignment:1];
                    _bt_ok.enabled=NO;
                    RELEASE(_bt_ok);
                }
            }
                break;
            default:
                break;
        }
        
        if ((![[NSUserDefaults standardUserDefaults] stringForKey:@"selectClass"] || [[[NSUserDefaults standardUserDefaults] stringForKey:@"selectClass"] intValue]==0 ) && _type==0) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"selectClass"];
            
            {
                DYBGuideView *guideV=[[DYBGuideView alloc]initWithFrame:self.view.frame];
                guideV.AddImgByName(@"selectClass",nil);
                [self.drNavigationController.view addSubview:guideV];
                RELEASE(guideV);
            }
        }
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
//        RELEASEDICTARRAYOBJ(_muA_classList);
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv release_muA_differHeightCellView];

        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}

#pragma mark-
-(void)creatTbv{
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight, self.view.frame.size.width, CGRectGetHeight(self.view.bounds)-self.headHeight) isNeedUpdate:YES];
        _tbv._cellH=50;
        [_tbv setTableViewType:DTableViewSlime];
        [self.view addSubview:_tbv];
//        _tbv.backgroundColor=BKGGray;
        _tbv.tag=-1;
        _tbv._page=1;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
//        [_tbv.footerView changeState:PULLSTATEEND];

    }
    
}

#pragma mark- 接受tbv信号

static NSString *cellName = @"cellName";//前4个cell

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSInteger section = [[dict objectForKey:@"section"] integerValue];
        
        if (tableView.muA_allSectionKeys.count==0) {/*一个section模式*/
            NSNumber *s = [NSNumber numberWithInteger:_tbv.muA_singelSectionData.count];
            [signal setReturnValue:s];
        }else{
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
        
        if (tableView.muA_allSectionKeys.count==0/*一个section模式*/) {/*一个section模式*/
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
        
        if (tableView.muA_allSectionKeys.count>0/*多section模式*/) {
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
        
        if(indexPath.row==(((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(tableView._muA_differHeightCellView):(arr_curSectionForCell)).count/*只创建没计算过的cell*/) || !tableView._muA_differHeightCellView || (((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(tableView._muA_differHeightCellView):(arr_curSectionForCell)).count/*只创建没计算过的cell*/)==0)
        {
            
            DYBCellForClassList *cell = [[[DYBCellForClassList alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(_tbv.muA_singelSectionData):(arr_curSectionForModel)) objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if (!tableView._muA_differHeightCellView) {
                tableView._muA_differHeightCellView=[[NSMutableArray alloc]initWithCapacity:[tableView.muD_allSectionValues allKeys].count];
            }
            
            if (![((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) containsObject:cell]) {
                [((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) addObject:cell];
                
                if ([_muA_noticeArea containsObject:((eclass *)[_tbv.muA_singelSectionData objectAtIndex:indexPath.row]).id]) {
                    [cell setSelected:YES animated:YES];
                    
                    _bt_ok.enabled=YES;
                }
            }
            
            NSNumber *s = [NSNumber numberWithInteger:cell.frame.size.height];
            [signal setReturnValue:s];
            
        }else{//之前计算过的cell
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForClassList *)[((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
            [signal setReturnValue:s];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSInteger section = [[dict objectForKey:@"section"] integerValue];
        
        if (tableView.muA_allSectionKeys.count==0) {/*一个section模式*/
            
        }else{
            [signal setReturnValue:[tableView.muA_allSectionKeys objectAtIndex:section]];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if (tableView.muA_allSectionKeys.count==0) {/*一个section模式*/
        }else{
//            [self createSectionHeaderView:signal];
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
        if ( tableView.muA_allSectionKeys.count==0) {/*一个section模式*/
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
        
        switch (_type) {
            case 0:
            {
//                DYBClassMemberViewController *con=[[DYBClassMemberViewController alloc]init];
//                con.str_classID=((eclass *)[_tbv.muA_singelSectionData objectAtIndex:indexPath.row]).id;
//                [self.drNavigationController pushViewController:con animated:YES];
//                RELEASE(con);
                
                
//                    if (_type==0)
                    {
                        eclass *model=[_tbv.muA_singelSectionData objectAtIndex:indexPath.row];
//                        if ([model.active intValue]==1)
                        {
                            DYBUITabbarViewController *con=((DYBUITabbarViewController *)[self.drNavigationController getViewController:[DYBUITabbarViewController class]]);
                            DYYBClassHomePageViewController *home=(DYYBClassHomePageViewController *)[con getFirstViewVC];
                            eclass *model2=home.modelClass;
                            if (/*model2 && */![model2.id isEqualToString:model.id])
                            {
                                home.modelClass=model;
                                [home.modelClass retain];
                                home.b_isRefresh=YES;
                            }
//                            else{
//                                home.b_isRefresh=NO;
//                            }
                        }
                    }
                
                [self.drNavigationController popVCAnimated:YES];
            }
                break;
            case 1:
            {
                eclass *model=[_tbv.muA_singelSectionData objectAtIndex:indexPath.row];
                
                if (!_muA_noticeArea) {
                    _muA_noticeArea=[[NSMutableArray alloc]initWithObjects:model.id, nil];
                }else{
                    if (![_muA_noticeArea containsObject:model.id]) {
                        [_muA_noticeArea addObject:model.id];
                    }else{
                        [_muA_noticeArea removeObject:model.id];
                    }
                }
                
                if (_muA_noticeArea.count>0) {
                    _bt_ok.enabled=YES;
                }else{
                    _bt_ok.enabled=NO;
                }
            }
                break;
            default:
                break;
        }
        
        
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
//        {//HTTP请求已加入的班级列表
//            [self.view setUserInteractionEnabled:NO];
//            
//            MagicRequest *request = [DYBHttpMethod user_myeclass_list:SHARED.curUser.userid isAlert:YES receive:self];
//            [request setTag:1];
//            
//            if (!request) {//无网路
//                [_tbv reloadData:NO];
//            }
//        }
        
        switch (_type) {
            case 0://从班级主页进来
            {//HTTP请求已加入的班级列表
                MagicRequest *request = [DYBHttpMethod user_myeclass_list:SHARED.curUser.userid isAlert:YES receive:self];
                [request setTag:1];
            }
                break;
            case 1://发通知选择通知范围
            {//HTTP请求已加入的班级列表
                MagicRequest *request = [DYBHttpMethod eclass_managelist:SHARED.curUser.userid isAlert:YES receive:self];
                [request setTag:3];
            }
            default:
                break;
        }
    }
    else if ([signal is:[MagicUITableView TABLESECTIONINDEXTITLESFORTABLEVIEW]])//右侧索引列表
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if (tableView.muA_allSectionKeys.count>0) {/*多个section模式*/
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
    }
}

#pragma mark- 接受按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        if (bt)
        {
            switch (bt.tag) {
                case -1://
                {
                    [self.drNavigationController popVCAnimated:YES];
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}


#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal
{
    if ([signal is:[UIView TAP]]) {
        NSDictionary *object=(NSDictionary *)signal.object;
        
        NSIndexPath *index = [object objectForKey:@"object"];
        _index=index;
        
        {//HTTP请求,班级活跃度
            [self.view setUserInteractionEnabled:NO];
            
            MagicRequest *request = [DYBHttpMethod eclass_active:((eclass *)[_tbv.muA_singelSectionData objectAtIndex:index.row]).id isAlert:YES receive:self];
            [request setTag:2];
//            if (!request) {//无网路
//                [_tbv.footerView changeState:VIEWTYPEFOOTER];
//            }
        }
    }
}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取|刷新已加入的班级列表
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    //                    NSDictionary *d=[response.data objectForKey:@"user_list"];
                    NSArray *list=[response.data objectForKey:@"eclass"];
                    if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                        [_tbv.muA_singelSectionData removeAllObjects];
                        
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        eclass *model = [eclass JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            [self creatTbv];

                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                            
//                            if ([model.active intValue]==1) {//设置活跃班级,插入到0号下标                                
//                                ((DYYBClassHomePageViewController *)[self.drNavigationController getViewController:[DYYBClassHomePageViewController class]]).modelClass=model;
//                            }
                        }else{
//                            if ([model.active intValue]==1) {//设置活跃班级,插入到0号下标
//                                [_tbv.muA_singelSectionData insertObject:model atIndex:0];
//                                
////                                ((DYYBClassHomePageViewController *)[self.drNavigationController getViewController:[DYYBClassHomePageViewController class]]).modelClass=model;
//                            }else
                            {
                                [_tbv.muA_singelSectionData addObject:model];
                                
                                if (_type==0) {
//                                    eclass *model=[_tbv.muA_singelSectionData objectAtIndex:0];
                                    if ([model.active intValue]==1) {//活跃班级
                                        DYBUITabbarViewController *con=((DYBUITabbarViewController *)[self.drNavigationController getViewController:[DYBUITabbarViewController class]]);
                                        DYYBClassHomePageViewController *home=(DYYBClassHomePageViewController *)[con getFirstViewVC];
                                        eclass *model2=home.modelClass;
                                        if (model2 && ![model2.id isEqualToString:model.id]) {
                                            home.b_isRefresh=YES;
                                            home.modelClass=Nil;
                                        }
                                    }
//                                    else{
//                                        DYBUITabbarViewController *con=((DYBUITabbarViewController *)[self.drNavigationController getViewController:[DYBUITabbarViewController class]]);
//                                        DYYBClassHomePageViewController *home=(DYYBClassHomePageViewController *)[con getFirstViewVC];
//                                        home.b_isRefresh=NO;
////                                        home.modelClass=Nil;
//                                    }
                                }
                            }
                        }
                    }
                    
                    {
                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                            [_tbv._muA_differHeightCellView removeAllObjects];
                                                        
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
                        }
                        
                    }
                    
//                    if (_type==0) {
//                        eclass *model=[_tbv.muA_singelSectionData objectAtIndex:0];
//                        if ([model.active intValue]==1) {
//                            DYBUITabbarViewController *con=((DYBUITabbarViewController *)[self.drNavigationController getViewController:[DYBUITabbarViewController class]]);
//                            DYYBClassHomePageViewController *home=(DYYBClassHomePageViewController *)[con getFirstViewVC];
//                            eclass *model2=home.modelClass;
//                            if (model2 && ![model2.id isEqualToString:model.id]) {
//                                home.b_isRefresh=YES;
//                            }
//                        }
//                    }
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
                //                [_tbv.footerView changeState:PULLSTATEEND];
                
            }
                break;
                
            case 2://设置活跃班级接口eclass_active
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode){
                    if ([[response.data objectForKey:@"result"] isEqualToString:@"1"]) {
//                        eclass *model=[_tbv.muA_singelSectionData objectAtIndex:_index.row];
//                        model.active=@"1";
//                        [_tbv.muA_singelSectionData insertObject:model atIndex:0];
//                        
//                        model=[_tbv.muA_singelSectionData objectAtIndex:1];
//                        model.active=@"0";
//                        
//                        [_tbv.muA_singelSectionData removeObjectAtIndex:_index.row+1];
//                        
//                        [_tbv release_muA_differHeightCellView];
//                        [_tbv reloadData:YES];
                        
//                        {//设置班级主页的内容是否需要重新刷新
//                            DYYBClassHomePageViewController *con=((DYYBClassHomePageViewController *)[self.drNavigationController getViewController:[DYYBClassHomePageViewController class]]);
//                            if (![con.modelClass.id isEqualToString:((eclass *)[_tbv.muA_singelSectionData objectAtIndex:0]).id]) {
//                                con.tbv._b_isToObtainData=YES;
//                            }else{
//                                con.tbv._b_isToObtainData=NO;
//                            }
//                            
//                        }
                        
                        {//HTTP请求已加入的班级列表
                            [self.view setUserInteractionEnabled:NO];
                            
                            MagicRequest *request = [DYBHttpMethod user_myeclass_list:SHARED.curUser.userid isAlert:YES receive:self];
                            [request setTag:1];
                            
                            if (!request) {//无网路
                                //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                            }
                        }
                    }
                
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
            }
                break;
            case 3://获取 通知范围
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    //                    NSDictionary *d=[response.data objectForKey:@"user_list"];
                    NSArray *list=[response.data objectForKey:@"eclass_managelist"];
                    if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                        [_tbv.muA_singelSectionData removeAllObjects];
                        
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        eclass *model = [eclass JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            [self creatTbv];
                            
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                            
                            //                            if ([model.active intValue]==1) {//设置活跃班级,插入到0号下标
                            //                                ((DYYBClassHomePageViewController *)[self.drNavigationController getViewController:[DYYBClassHomePageViewController class]]).modelClass=model;
                            //                            }
                        }else{
                            if ([model.active intValue]==1) {//设置活跃班级,插入到0号下标
                                [_tbv.muA_singelSectionData insertObject:model atIndex:0];
                                
                                //                                ((DYYBClassHomePageViewController *)[self.drNavigationController getViewController:[DYYBClassHomePageViewController class]]).modelClass=model;
                            }else{
                                [_tbv.muA_singelSectionData addObject:model];
                            }
                        }
                    }
                    
                    {
                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                            [_tbv._muA_differHeightCellView removeAllObjects];
                            
//                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
//                                [_tbv reloadData:NO];
//                            }else{
//                                [_tbv reloadData:YES];
//                            }
                            [_tbv reloadData:YES];
                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
                        }
                        
                    }
                    
//                    if (_type==0) {
//                        eclass *model=[_tbv.muA_singelSectionData objectAtIndex:0];
//                        if ([model.active intValue]==1) {
//                            DYBUITabbarViewController *con=((DYBUITabbarViewController *)[self.drNavigationController getViewController:[DYBUITabbarViewController class]]);
//                            DYYBClassHomePageViewController *home=(DYYBClassHomePageViewController *)[con getFirstViewVC];
//                            eclass *model2=home.modelClass;
//                            if (model2 && ![model2.id isEqualToString:model.id]) {
//                                home.b_isRefresh=YES;
//                            }
//                        }
//                    }
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
                //                [_tbv.footerView changeState:PULLSTATEEND];
                
            }
                break;
            default:
                break;
        }
    }
}

@end
 