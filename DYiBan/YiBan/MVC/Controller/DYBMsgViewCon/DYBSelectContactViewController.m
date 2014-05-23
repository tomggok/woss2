//
//  DYBWritePrivateLetterViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSelectContactViewController.h"
#import "UITableView+property.h"
#import "user.h"
#import "friends.h"
#import "NSString+Count.h"
#import "DYBCellForFriendList.h"
#import "DYBSendPrivateLetterViewController.h"
#import "UIView+MagicCategory.h"
#import "eclass.h"
#import "DYBDynamicViewController.h"
#import "ChineseToPinyin.h"
#import "DYBUITabbarViewController.h"
#import "NSString+Count.h"

@interface DYBSelectContactViewController (){

    int nSelMenu;
    NSMutableDictionary *selectDic;
}

@end

@implementation DYBSelectContactViewController
@synthesize bEnterDataBank = _bEnterDataBank,docAddr = _docAddr,dictInfo = _dictInfo,cellDetail = _cellDetail,cellDetailSearch = _cellDetailSearch ,nid=_nid;
#pragma mark-
-(void)creatTbv{
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight+_search.frame.size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headHeight-_search.frame.size.height) isNeedUpdate:YES];
        _tbv._cellH=80;
        [self.view addSubview:_tbv];
        _tbv.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
        _tbv.tag=-1;
        _tbv._page=1;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tbv setTableViewType:DTableViewSlime];
        _tbv.v_headerVForHide=_search;
    }
    
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        if (!_search) {
            _search=[[MagicUISearchBar alloc]initWithFrame:CGRectMake(0, self.headHeight, self.view.frame.size.width, 50) backgroundColor:ColorNav placeholder:@"昵称/姓名" isHideOutBackImg:YES isHideLeftView:NO];
            [_search customBackGround:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_search"]] autorelease]];
            _search.tag=-1;
            [self.view addSubview:_search];
            [_search release];
        }
        
        if (_bEnterDataBank) {
            
            if (_nid) {//HTTP请求,好友列表
                [self.view setUserInteractionEnabled:NO];
                
                MagicRequest *request = [DYBHttpMethod user_friendlist_userid:SHARED.curUser.userid num:@"1000" page:1 type:@"0" isAlert:YES receive:self];
                [request setTag:1];
                
                if (!request) {//无网路
                    //                    [_tbv.footerView changeState:VIEWTYPEFOOTER];
                }
            }else{
                MagicRequest *request = [DYBHttpMethod source_friendlist_doc:_docAddr isAlert:YES receive:self];
                [request setTag:1];
            }
            
        }
        else{
            {//HTTP请求,好友列表
                [self.view setUserInteractionEnabled:NO];
                
                MagicRequest *request = [DYBHttpMethod user_friendlist_userid:SHARED.curUser.userid num:@"1000" page:1 type:@"0" isAlert:YES receive:self];
                [request setTag:1];

                if (!request) {//无网路
//                    [_tbv.footerView changeState:VIEWTYPEFOOTER];
                }
            }
        }
        {//HTTP请求已加入的班级列表
            [self.view setUserInteractionEnabled:NO];
            
            MagicRequest *request = [DYBHttpMethod user_myeclass_list:SHARED.curUser.userid isAlert:YES receive:self];
            [request setTag:2];
            
            if (!request) {//无网路
//                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
            }
        }
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        
        if (_bEnterDataBank) {
            [self.headview setTitle:@"共享给好友"];
            [self backImgType:1];
            self.rightButton.hidden=NO;
            selectDic = [[NSMutableDictionary alloc]init];
        }else{
            [self.headview setTitle:@"好友"];
            [self backImgType:0];
            self.rightButton.hidden=YES;
        }
        if (!_bt_DropDown) {
            //            UIImage *img= [UIImage imageNamed:@"btn_mainmenu_default"];
            _bt_DropDown = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0,140, self.headHeight)];
            _bt_DropDown.tag=-3;
            _bt_DropDown.backgroundColor=[UIColor clearColor];
            [_bt_DropDown addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            //            [_bt_mayKnow setBackgroundImage:img forState:UIControlStateNormal];
            //            [_bt_sendNotice setBackgroundImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
            [self.headview addSubview:_bt_DropDown];
            [_bt_DropDown changePosInSuperViewWithAlignment:2];
            RELEASE(_bt_DropDown);
            
            [self.headview setTitleArrow];
        }
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        
        [_muA_data removeAllObjects];
        [_muA_data release];
        _muA_data=nil;
        
        [_muA_data_classDetail removeAllObjects];
        [_muA_data_classDetail release];
        _muA_data_classDetail=nil;
        
        RELEASEDICTARRAYOBJ(selectDic);
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv release_muA_differHeightCellView];
        
        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}

#pragma mark- 接受tbv信号

static NSString *cellForFriends = @"cellForFriends";//好友cell

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
            
            DYBCellForFriendList *cell = [[[DYBCellForFriendList alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellForFriends] autorelease];
            
            if (_bEnterDataBank) {
                cell.indexPath = indexPath;
                cell.bEnterDataBank = _bEnterDataBank;
                cell.arrayCollect = [selectDic allKeys];
                cell.dictSelectResult = selectDic;
            }else{
                cell.type=1;
            }
            
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
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellForFriends];
        if ([tableView isOneSection]) {/*一个section模式*/
            cell=((UITableViewCell *)[tableView._muA_differHeightCellView objectAtIndex:indexPath.row]);
        }else{
            //保存cell的当前section对应的array
            NSMutableArray *arr_curSectionForCell=(((NSMutableArray *)([tableView._muA_differHeightCellView objectAtIndex:indexPath.section])));
            cell=((UITableViewCell *)[arr_curSectionForCell objectAtIndex:indexPath.row]);
        }
        
        if (_bEnterDataBank) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [signal setReturnValue:cell];
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        if (!_bEnterDataBank) {
            
            friends *model=[[_tbv.muD_allSectionValues objectForKey:[_tbv.muA_allSectionKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            
            DYBSendPrivateLetterViewController *vc = [[DYBSendPrivateLetterViewController alloc] init];
            vc.model=[NSDictionary dictionaryWithObjectsAndKeys:model.id,@"userid",model.name,@"name",model.pic,@"pic", nil];
            [self.drNavigationController pushViewController:vc animated:YES];
            
            [tableview deselectRowAtIndexPath:indexPath animated:YES];
            
            if ([_search cancelSearch]) {
                [tableview release_muA_differHeightCellView];
                [tableview resetSectionData];
                [tableview reloadData:YES];
            }

            
        }else{
        
            UITableViewCell *selectCell = [tableview cellForRowAtIndexPath:[tableview indexPathForSelectedRow]];
           
            UIButton *btn = (UIButton *)[selectCell viewWithTag:88];
            
         friends *f=[[_tbv.muD_allSectionValues objectForKey:[_tbv.muA_allSectionKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
//            friends *f = [_muA_data objectAtIndex:indexPath.row];
            
            int num = indexPath.section * 1000 +indexPath.row;
            
            if (btn.selected) {
                btn.selected = NO;
                [selectDic removeObjectForKey:[NSString stringWithFormat:@"%d",num]];
                //            [collectClass removeObjectForKey:class.name];
            }else{
                btn.selected = YES;
                [selectDic setValue:f.id forKey:[NSString stringWithFormat:@"%d",num]];
                //            [collectClass setValue:class forKey:class.name];
            }

        
        }
        
        
               
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        [selectDic removeAllObjects];
        
        {//HTTP请求
            [self.view setUserInteractionEnabled:NO];
            
            MagicRequest *request=Nil;
            
            if(_tbv_dropDown.row>0){//刷新班级成员
                eclass *model=[_muA_data_class objectAtIndex:_tbv_dropDown.row-1];
                
                [self.headview setTitle:model.name];
                
                //                        [_tbv release_muA_differHeightCellView];
                //                        [_tbv releaseDataResource];
                //                        [_muA_data_classDetail removeAllObjects];
                
                {//HTTP请求,班级详情
                    [self.view setUserInteractionEnabled:NO];
                    
                    request = [DYBHttpMethod eclass_detail:model.id num:1000 page:1 isAlert:YES receive:self];
                    [request setTag:3];
                    
                    if (!request) {//无网路
                        [tableView reloadData:NO];
                    }
                }
            }else{//刷新好友
                request = [DYBHttpMethod user_friendlist_userid:SHARED.curUser.userid num:@"10" page:1 type:@"0" isAlert:YES receive:self];
                [request setTag:1];
            }
            
            
            if (!request) {//无网路
                [tableView reloadData:NO];
            }
        }
    }

    else if ([signal is:[MagicUITableView TABLESECTIONINDEXTITLESFORTABLEVIEW]])//右侧索引列表
    {
//        NSDictionary *dict = (NSDictionary *)[signal object];
//        UITableView *tableview = [dict objectForKey:@"tableView"];
//        NSString *title = [dict objectForKey:@"title"];
//        NSInteger index = [[dict objectForKey:@"index"] integerValue];
//        
//        //在数据源的下标
//        NSInteger count = 0;
//        
//        for(NSString *character in tableview.muA_allSectionKeys)
//        {
//            if([character isEqualToString:title])
//            {
//                [signal setReturnValue:[NSNumber numberWithInteger:count]];
//                break;
//            }
//            count ++;
//        }
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
        
        for(NSString *character in _tbv.muA_allSectionKeys)
        {
            if([character isEqualToString:title])
            {
                [signal setReturnValue:[NSNumber numberWithInteger:count]];
                break;
            }
            count ++;
        }
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
        [_tbv StretchingUpOrDown:0];
        [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];

        [_search resignFirstResponder];
        [_search releaseCancelBt];
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [_tbv StretchingUpOrDown:1];
        [[DYBUITabbarViewController sharedInstace] hideTabBar:NO animated:YES];

        [_search resignFirstResponder];
        [_search releaseCancelBt];
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){//touch
      
        [_search resignFirstResponder];
        [_search releaseCancelBt];
    }
    
}

- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        DLogInfo(@"selectDic ---- >%@",selectDic);
        DLogInfo(@"fffff");
        
        
        NSArray *arrayClass = [selectDic allValues];
        
        if (arrayClass.count >0) {
            
        
            if (_nid) {//共享笔记
                MagicRequest *request = [DYBHttpMethod notes_sharenote:_nid to_userid:[NSString joinedArrayToStr:arrayClass separaterChar:@","] isAlert:YES receive:self];
                [request setTag:6];
            }else{
                NSString *strClass = [arrayClass componentsJoinedByString:@","];
                
                //        for (NSString *str in arrayClass) {
                //            strClass = [strClass stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
                //        }
                NSString *target = [NSString stringWithFormat:@"U,%@",strClass];
                
                MagicRequest *request = [DYBHttpMethod document_share_doc:_docAddr target:target isAlert:YES receive:self ];
                [request setTag:5];
            }
           
            
        }else{
        
            [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"请选择指定共享的人！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:nil];
        
        }
    }
    
    
}



#pragma mark- 接受按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        friends *d=(friends *)signal.object;
        
        if (bt)
        {
            switch (bt.tag) {
                case -1://发私信
                {
                    DYBSendPrivateLetterViewController *vc = [[DYBSendPrivateLetterViewController alloc] init];
                    vc.model=[NSDictionary dictionaryWithObjectsAndKeys:d.id,@"userid",d.name,@"name",d.pic,@"pic", nil];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    
                    
                    RELEASE(vc);
                }
                    break;
                    
                case -2://打电话
                {
                    
                }
                    break;
                    
                case -3://顶部打开下拉列表按钮
                {
                    RELEASEVIEW(_tbv_dropDown);
                    if (TraparentView) {
                        RELEASEVIEW(TraparentView);
                    }
                    
                    
                    if (!_tbv_dropDown) {
                        NSMutableArray *arrBtnLable = [[NSMutableArray alloc] initWithObjects:@"好友", nil];
                        
                        for (eclass *model in _muA_data_class) {
//                            [model retain];
                            [arrBtnLable addObject:model.name];
                        }
                        
                        TraparentView = [[MagicUIButton alloc]initWithFrame:CGRectMake(0, self.headHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.headHeight)];
                        TraparentView.tag = -1000;
                        [TraparentView addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                        TraparentView.backgroundColor = [UIColor clearColor];
                        [self.view addSubview:TraparentView];
                        
                        _tbv_dropDown = [[DYBMenuView alloc]initWithData:arrBtnLable selectRow:nSelMenu];
                        [_tbv_dropDown setHidden:YES];
                        [self.view addSubview:_tbv_dropDown];
                        
                        
                    }
                    
                    if (bPullDown) {
                        //            [_tabMenu setFrame:CGRectMake(120, 44-CGRectGetHeight(_tabMenu.frame), 100, CGRectGetHeight(_tabMenu.frame))];
                        //            [_tabMenu setHidden:YES];
                        if (TraparentView) {
                            RELEASEVIEW(TraparentView);
                        }
                        
                        [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:self from:self target:_tbv_dropDown];
                    }else{
                        //            [_tabMenu setFrame:CGRectMake(120, 44, 100, CGRectGetHeight(_tabMenu.frame))];
                        //            [_tabMenu setHidden:NO];
                        
                        [self sendViewSignal:[DYBMenuView MENUDOWN] withObject:self from:self target:_tbv_dropDown];
                    }
                    
                    
                    
                    bPullDown = !bPullDown;
                    
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

#pragma mark- 只接受searchBar信号
- (void)handleViewSignal_MagicUISearchBar:(MagicViewSignal *)signal{
    if ([signal is:[MagicUISearchBar BEGINEDITING]]) {//第一次按下搜索框
        
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        {
            search.showsScopeBar = YES;//控制搜索栏下部的选择栏是否显示出来
            [search setShowsCancelButton:YES animated:YES];
            [search initCancelBt:[UIImage imageNamed:@"btn_search_cancel"] HighlightedImg:[UIImage imageNamed:@"btn_search_cancel"]];

        }
        
    }else if ([signal is:[MagicUISearchBar CANCEL]]){//取消搜索
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
        [_tbv release_muA_differHeightCellView];
        [_tbv resetSectionData];
        [_tbv reloadData:YES];
        
        [selectDic removeAllObjects];
        
    }else if ([signal is:[MagicUISearchBar SEARCH]]){//按下搜索按钮
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
        {
            [search resignFirstResponder];
            //            self.text=Nil;//消失右边的X号
            
            search.b_isSearching=NO;
            
            [search releaseCancelBt];
        }
        
    }else if ([signal is:[MagicUISearchBar CHANGEWORD]]){//内容改变
        NSString *str=(NSString *)signal.object;
        MagicUISearchBar *search=(MagicUISearchBar *)signal.source;
        
        if ([str length] == 0) {//删除完search里的内容
            [_tbv release_muA_differHeightCellView];
            [_tbv resetSectionData];//每个section里的value
            [_tbv reloadData:YES];
            return;
        }
        
        [search sendViewSignal:[MagicUISearchBar SEARCHING] withObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"searchContent",_tbv,@"tbv", nil]];
        
        
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
        }
        
        //        [self performSelectorOnMainThread:@selector(reloadtable) withObject:nil waitUntilDone:YES];
        
        [_tbv release_muA_differHeightCellView];
        [tbv reloadData];
    }
}


#pragma mark- DYBPullDownMenuView消息
- (void)handleViewSignal_DYBDynamicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBDynamicViewController MENUSELECT]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        int  _nSection = [[dict objectForKey:@"section"] intValue];
        nSelMenu=_nSection;
        
        switch (_nSection) {
            case 0://好友
            {
                if (!_muA_data) {
                    [_tbv release_muA_differHeightCellView];
                    
                    [_tbv releaseDataResource];
                    
                    {//HTTP请求,好友列表
                        [self.view setUserInteractionEnabled:NO];
                        
                        MagicRequest *request = [DYBHttpMethod user_friendlist_userid:SHARED.curUser.userid num:@"10" page:1 type:@"0" isAlert:YES receive:self];
                        [request setTag:1];
                        
                        if (!request) {//无网路
//                            [_tbv.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                }else{
                    //                    [_tbv_friends_myConcern_RecentContacts._muA_differHeightCellView removeAllObjects];
                    [_tbv release_muA_differHeightCellView];
                    [self initSectionOrder:_muA_data tbv:_tbv];
                    [_tbv reloadData:YES];
                    
                }
                
                [self.headview setTitle:@"好友"];
            }
                break;
         
            default:
            {
                eclass *model=[_muA_data_class objectAtIndex:nSelMenu-1];
                
                [self.headview setTitle:model.name];
            
//                [_tbv release_muA_differHeightCellView];
//                [_tbv releaseDataResource];
//                [_muA_data_classDetail removeAllObjects];
                
                {//HTTP请求,班级详情
                    [self.view setUserInteractionEnabled:NO];
                    
                    MagicRequest *request = [DYBHttpMethod eclass_detail:model.id num:1000 page:1 isAlert:YES receive:self];
                    [request setTag:3];
                    
                    if (!request) {//无网路
//                        [_tbv.footerView changeState:VIEWTYPEFOOTER];
                    }
                }
            }
                break;
        }
        
//        [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:nil from:self target:_tbv_dropDown];
        [_search cancelSearch];
        
        [self.headview setTitleArrow];
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
    v.backgroundColor=[MagicCommentMethod color:255 green:255 blue:255 alpha:0.5];
    
    {
        MagicUILabel *lb_title=[[MagicUILabel alloc]initWithFrame:CGRectMake(15,0, 0, 0)];
        lb_title.backgroundColor=[UIColor clearColor];
        lb_title.textAlignment=NSTextAlignmentLeft;
        lb_title.font=[DYBShareinstaceDelegate DYBFoutStyle:20];
        lb_title.text=[_tbv.muA_allSectionKeys objectAtIndex:section];
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
//        line.clipsToBounds=NO;
        [v addSubview:line];
        RELEASE(line);
    }
    
    [signal setReturnValue:v];
    //    [v release];
}


#pragma mark- 初始列表section顺序
-(void)initSectionOrder:(NSMutableArray *)array tbv:(UITableView *)tbv
{
    [tbv releaseDataResource];
    [tbv release_muA_differHeightCellView];
    
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

#pragma mark- 初始化无数据提示view
-(void)initNoDataView:(NSString *)str
{

    
    if ([str isEqualToString:@""]) {
        return;
    }
    
    UIImage *img=[UIImage imageNamed:@"ybx_big"];
    MagicUIImageView *imgV = [[MagicUIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self.view Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    
    RELEASE(imgV);
    
    {
        MagicUILabel *lb=[[MagicUILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame)+20, 0, 0)];
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
                        [self initNoDataView:@"没有好友"];
                        [_tbv release_muA_differHeightCellView];
                        [_tbv releaseDataResource];
                        [_tbv reloadData];
                        [self.view setUserInteractionEnabled:YES];
                        return;
                    }
                    
                    NSArray *list=[d objectForKey:@"user"];
                    if (_muA_data.count>0 && list.count>0 ) {
                        [_muA_data removeAllObjects];
                        
//                        [_tbv._muA_differHeightCellView removeAllObjects];
//                        _tbv._muA_differHeightCellView=nil;
                        
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    
                    for (int i = 0; i< list.count;i++ ) {
                        
                        NSDictionary *d = [list objectAtIndex:i];
                        friends *model = [friends JSONReflection:d];
                        if (!_muA_data) {
                            _muA_data=[NSMutableArray arrayWithObject:model];
                            [_muA_data retain];
                        }else{
                            [_muA_data addObject:model];
                        }
                        
                        
                    }
//                    for (NSDictionary *d in list) {
//                        friends *model = [friends JSONReflection:d];
//                        if (!_muA_data) {
//                            _muA_data=[NSMutableArray arrayWithObject:model];
//                            [_muA_data retain];
//                        }else{
//                            [_muA_data addObject:model];
//                        }
//                    }
                    
                    {
                        if (_muA_data.count>0 && list.count>0 ) {
                            [self creatTbv];

                            [self initSectionOrder:_muA_data tbv:_tbv];
//                            [_tbv._muA_differHeightCellView removeAllObjects];
                            
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
//                [_tbv.footerView changeState:PULLSTATEEND];
                
            }
                
                break;
                
            case 2://获取 已加入的班级
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
//                    NSDictionary *d=[response.data objectForKey:@"user_list"];
                    NSArray *list=[response.data objectForKey:@"eclass"];
                    if (_muA_data_class.count>0 && list.count>0) {
                        [_muA_data_class removeAllObjects];
                        
//                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        eclass *model = [eclass JSONReflection:d];
                        if (!_muA_data_class) {
                            _muA_data_class=[NSMutableArray arrayWithObject:model];
                            [_muA_data_class retain];
                        }else{
                            [_muA_data_class addObject:model];
                        }
                    }
                    
                    {
                        if (_muA_data_class.count>0 && list.count>0) {
                            if(_tbv_dropDown){
                                NSMutableArray *arrBtnLable = [[NSMutableArray alloc] initWithObjects:@"好友", nil];
                                
                                for (eclass *model in _muA_data_class) {
                                    [arrBtnLable addObject:model.name];
                                }
                                
                            [_tbv_dropDown.arrMenu release];
                            _tbv_dropDown.arrMenu=Nil;
                            
                            _tbv_dropDown.arrMenu=[[NSArray alloc]initWithArray:arrBtnLable];
                                RELEASE(arrBtnLable);
                                
                                [_tbv_dropDown reloadData];
                                
                            }
                            
                        }else{//没获取到数据,恢复headerView
                            [_tbv_dropDown reloadData:YES];
                        }
                        
                    }
                    
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
//                [_tbv.footerView changeState:PULLSTATEEND];
                
            }
                break;
                
            case 3://获取班级成员
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    NSDictionary *d=[response.data objectForKey:@"user_list"];
                    NSArray *list=[d objectForKey:@"user"];
                    if (_muA_data_classDetail.count>0 && list.count>0) {
                        [_muA_data_classDetail removeAllObjects];
                        [_tbv releaseDataResource];
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        friends *model = [friends JSONReflection:d];
                        if (!_muA_data_classDetail) {
                            _muA_data_classDetail=[NSMutableArray arrayWithObject:model];
                            [_muA_data_classDetail retain];
                        }else{
                            [_muA_data_classDetail addObject:model];
                        }
                    }
                    
                    {
                        if (_muA_data_classDetail.count>0 && list.count>0) {
                            [self creatTbv];
                            
                            [self initSectionOrder:_muA_data_classDetail tbv:_tbv];
                            
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
                    [_tbv reloadData:YES];

                }
                
                [self.view setUserInteractionEnabled:YES];
//                [_tbv.footerView changeState:PULLSTATEEND];
                
            }
                break;
            case 5://
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    [_dictInfo setValue:@"3" forKey:@"perm"];
                    if (_cellDetail) {
                        [_cellDetail setPublicString:@"3"];
                        [_cellDetailSearch setPublicString:@"3"];
                    }
                    [self.drNavigationController popVCAnimated:YES];
                }
                NSString *MSG = [response.data objectForKey:@"msg"];
                
                //        [self.window setBackgroundColor:[UIColor redColor]];
                
                [DYBShareinstaceDelegate popViewText:MSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            }
                break;
                
            case 6://共享笔记
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([[response.data objectForKey:@"result"] intValue]==1) {
                        [self.drNavigationController popVCAnimated:YES];
                        
                        MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                        [pop setDelegate:self];
                        [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                        [pop setText:@"共享成功"];
                        [pop alertViewAutoHidden:.5f isRelease:YES];
                        
                        return;
                    }
                }else if ([response response] ==khttpfailCode){
                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                    [pop setDelegate:self];
                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                    [pop setText:@"共享失败"];
                    [pop alertViewAutoHidden:.5f isRelease:YES];
                    
                }
                
                
            }
                break;
            default:
                break;
        }
    }
}

@end
