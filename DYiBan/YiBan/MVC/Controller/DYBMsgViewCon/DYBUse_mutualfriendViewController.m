//
//  DYBUse_mutualfriendViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-9-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBUse_mutualfriendViewController.h"
#import "UITableView+property.h"
#import "friends.h"
#import "DYBCellForFriendList.h"
#import "DYBSendPrivateLetterViewController.h"
#import "DYBCallView.h"
#import "NSString+Count.h"
#import "DYBPersonalHomePageViewController.h"

@interface DYBUse_mutualfriendViewController ()
{
    MagicUITableView *_tbv;
    MagicUIButton *_bt_cancelViews/*点击取消某视图*/;
    DYBCallView *_v_call;/*打电话界面*/;

}
@end

@implementation DYBUse_mutualfriendViewController

@synthesize userid=_userid;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        {//HTTP请求
            [self.view setUserInteractionEnabled:NO];
            
            MagicRequest *request = [DYBHttpMethod user_mutualfriend:_userid isAlert:YES receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
//                [_tbv_mayKnow.footerView changeState:VIEWTYPEFOOTER];
            }
        }
        
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"共同好友"];
        [self backImgType:0];
        self.rightButton.hidden=YES;
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }
    else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        
    }
    else if ([signal is:[MagicViewController DELETE_VIEWS]]){
        
        [_tbv release_muA_differHeightCellView];
        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
    }
    
}

-(void)creatTbv{
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headHeight) isNeedUpdate:YES];
        _tbv._cellH=65;
        [self.view addSubview:_tbv];
        _tbv.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
        _tbv.tag=-1;
        _tbv.i_pageNums=10;
        _tbv._page=1;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tbv setTableViewType:DTableViewSlime];
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
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if ([tableView isOneSection]) {/*一个section模式*/
        }else{
            //            [self createSectionHeaderView:signal];
        }
        
    }//
    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        int section=[[dict objectForKey:@"section"] intValue];
        
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
        
        {
            friends *model=[tableview.muA_singelSectionData objectAtIndex:indexPath.row];
            
            DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
            
            vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:model.name,@"name",model.id,@"userid", nil];
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
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
        
//        {
//            [UIView animateWithDuration:0.0 animations:^{
//                
//            }completion:^(BOOL b){
////                [_tbv.headerView changeState:VIEWTYPEHEADER];
//            }];
//        }
        
        [tableView reloadData:YES];
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
                case -1://发私信
                {
                    friends *d=(friends *)signal.object;
                    
                    DYBSendPrivateLetterViewController *vc = [[DYBSendPrivateLetterViewController alloc] init];
                    vc.model=[NSDictionary dictionaryWithObjectsAndKeys:d.id,@"userid",d.name,@"name",d.pic,@"pic", nil];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
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
                case k_tag_bt_cancelViews://取消打电话界面
                {
                    UIView *v=[[DYBUITabbarViewController sharedInstace] containerView].tabBar;
                    
                    
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
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"list"];
                    
                    if (_tbv.muA_singelSectionData.count>0 && list.count>0 ) {
                        [_tbv release_muA_differHeightCellView];
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        friends *model = [friends JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            [self creatTbv];
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                        }else{
                            [_tbv.muA_singelSectionData addObject:model];
                        }
                    }
                    
                    {
                        if (_tbv.muA_singelSectionData.count>0 && list.count>0 ) {
                            [_tbv release_muA_differHeightCellView];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
                        }
                        
                    }
                    
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
//                [_tbv_mayKnow.footerView changeState:PULLSTATEEND];
                
            }
                break;
                
            case 3://附近的人加载更多
//            {
//                JsonResponse *response = (JsonResponse *)receiveObj;
//                
//                if ([response response] ==khttpsucceedCode)
//                {
//                    NSArray *list=[response.data objectForKey:@"user_list"];
//                    for (NSDictionary *d in list) {
//                        nearByFriends *model = [nearByFriends JSONReflection:d];
//                        if (!_tbv_nearBy.muA_singelSectionData) {
//                            _tbv_nearBy.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
//                            [_tbv_nearBy.muA_singelSectionData retain];
//                        }else{
//                            [_tbv_nearBy.muA_singelSectionData addObject:model];
//                        }
//                    }
//                    
//                    {//加载更多
//                        if (_tbv_nearBy.muA_singelSectionData.count>0 && list.count>0) {
//                            
//                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
//                                [_tbv_nearBy reloadData:NO];
//                            }else{
//                                [_tbv_nearBy reloadData:YES];
//                            }
//                        }else{//没获取到数据,恢复headerView
//                            [_tbv_nearBy reloadData:YES];
//                        }
//                        
//                    }
//                    
//                    [self.view setUserInteractionEnabled:YES];
//                    return;
//                    
//                }else if ([response response] ==khttpfailCode)
//                {
//                    
//                }
//                
//                [self.view setUserInteractionEnabled:YES];
//                [_tbv_nearBy.footerView changeState:PULLSTATEEND];
//                
//                
//            }
                break;
                
            default:
                break;
        }
    }
}
@end
