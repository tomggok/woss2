//
//  DYBATViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBATViewController.h"
#import "UITableView+property.h"
#import "user.h"
#import "DYBCellForAT.h"
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
#import "DYBPublishViewController.h"
#import "DYBDynamicDetailViewController.h"
#import "DYBSearchFriendsViewController.h"
#import "DYBActivityViewController.h"

@interface DYBATViewController ()

@end

@implementation DYBATViewController

@synthesize str_userid=_str_userid;


#pragma mark- creatTbv
-(void)creatTbv{
    if (!_tbv_friends_myConcern_RecentContacts) {
        _tbv_friends_myConcern_RecentContacts = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight+_search.frame.size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headHeight-_search.frame.size.height) isNeedUpdate:NO];
        _tbv_friends_myConcern_RecentContacts._cellH=65;
        [self.view addSubview:_tbv_friends_myConcern_RecentContacts];
        _tbv_friends_myConcern_RecentContacts.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
        _tbv_friends_myConcern_RecentContacts.tag=-1;
        _tbv_friends_myConcern_RecentContacts._page=1;
        _tbv_friends_myConcern_RecentContacts.separatorStyle=UITableViewCellSeparatorStyleNone;
//        [_tbv_friends_myConcern_RecentContacts setTableViewType:DTableViewSlime];
        _tbv_friends_myConcern_RecentContacts.v_headerVForHide=_search;
        RELEASE(_tbv_friends_myConcern_RecentContacts);
        
        //        _tbv_friends_myConcern_RecentContacts.v_footerVForHide=[[DYBUITabbarViewController sharedInstace] containerView].tabBar;
        
    }
    
}

#pragma makr -
#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        BOOL bHave = NO;
        
        for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
            if ([vc isKindOfClass:[DYBPublishViewController class]]) {
                bHave = YES;
                [self sendViewSignal:[DYBPublishViewController SELECTATLIST] withObject:_arrAtlist from:self target:(DYBPublishViewController *)vc];
                break;
            }
        }
        
        if (!bHave) {
            for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
                if ([vc isKindOfClass:[DYBDynamicDetailViewController class]]) {
                    bHave = YES;
                    [self sendViewSignal:[DYBDynamicDetailViewController SELECTATLIST] withObject:_arrAtlist from:self target:(DYBDynamicDetailViewController *)vc];
                }
            }
        } 
        
        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }
    
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        _arrAtlist = [[NSMutableArray alloc] init];
        
        if (!_str_userid) {
            _str_userid=SHARED.curUser.userid;
        }
        
        if (!_search) {
            _search=[[MagicUISearchBar alloc]initWithFrame:CGRectMake(0, self.headHeight, self.view.frame.size.width, 50) backgroundColor:BKGGray placeholder:@"昵称/姓名" isHideOutBackImg:YES isHideLeftView:NO];
            [_search customBackGround:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_search"]] autorelease]];
            _search.tag=-1;
            [self.view addSubview:_search];
            [_search release];
        }
        
        {//HTTP请求好友列表
            [self.view setUserInteractionEnabled:NO];
            
            MagicRequest *request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"0" isAlert:YES receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
//                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
            }
        }
        
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        
        [self.headview setTitle:@"@好友"];
        [self backImgType:0];
        [self backImgType:3];
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv_friends_myConcern_RecentContacts releaseDataResource];
        
        RELEASEDICTARRAYOBJ(_muA_data_friends);
        RELEASEDICTARRAYOBJ(_muA_data_MyConcern);
        RELEASEDICTARRAYOBJ(_arrAtlist);
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
        
        REMOVEFROMSUPERVIEW(_tbv_friends_myConcern_RecentContacts);//界面不显示时彻底释放TBV,已释放cell
        
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
            
            DYBCellForAT *cell = [[[DYBCellForAT alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
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
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForAT *)[(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
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
        
        cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
        cell.selectedBackgroundView.backgroundColor = ColorBackgroundGray;
        
        [signal setReturnValue:cell];
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        MagicUITableView *tableview = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        friends *model=[[_tbv_friends_myConcern_RecentContacts.muD_allSectionValues objectForKey:[_tbv_friends_myConcern_RecentContacts.muA_allSectionKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        UITableViewCell *cell = [_tbv_friends_myConcern_RecentContacts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
        
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[MagicUIButton class]]) {
                MagicUIButton *btn = (MagicUIButton *)view;
                btn.selected = !btn.selected;
                
                if (btn.selected == NO) {
                    [_arrAtlist removeObject:model.name];
                }
                else{
                    [_arrAtlist addObject:model.name];
                }
            }
        }
        
        DLogInfo(@"name: %@", _arrAtlist);
        
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
            [self.view setUserInteractionEnabled:NO];
            MagicRequest *request=nil;
            [_search cancelSearch];
            
            switch (_tbv_dropDown.row) {
                case 0://好友
                {
                    request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"0" isAlert:YES receive:self];
                    [request setTag:1];
                }
                    break;
                case 1://我关注的
                {//HTTP请求|刷新 我关注的
                    
                    request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"1" isAlert:YES receive:self];
                    [request setTag:2];
                }
                    break;
                case 2://最近联系人
                {//HTTP请求|刷新
                    
                    request = [DYBHttpMethod user_recentcontact:_str_userid isAlert:YES receive:self];
                    [request setTag:3];
                }
                    break;
                default:
                    break;
            }
            
            
            if (!request) {//无网路
                [_tbv_friends_myConcern_RecentContacts reloadData:NO];
            }
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
        
        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
        [_tbv_friends_myConcern_RecentContacts resetSectionData];
        [_tbv_friends_myConcern_RecentContacts reloadData:YES];
        
    }else if ([signal is:[MagicUISearchBar SEARCH]]){//按下搜索按钮
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
        [search resignFirstResponder];
        
    }else if ([signal is:[MagicUISearchBar CHANGEWORD]]){//内容改变
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
        
        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
        [tbv reloadData];
    }
}

#pragma mark- DYBPullDownMenuView消息
- (void)handleViewSignal_DYBDynamicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBDynamicViewController MENUSELECT]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        int  nSection = [[dict objectForKey:@"section"] intValue];
        
        switch (nSection) {
            case 0://好友
            {
                if (!_muA_data_friends) {
                    [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                    [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                    
                    {//HTTP请求|刷新 我关注的
                        [self.view setUserInteractionEnabled:NO];
                        
                        MagicRequest *request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"0" isAlert:YES receive:self];
                        [request setTag:1];
                        
                        if (!request) {//无网路
//                            [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                }else{
                    //                    [_tbv_friends_myConcern_RecentContacts._muA_differHeightCellView removeAllObjects];
                    [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                    [self initSectionOrder:_muA_data_friends tbv:_tbv_friends_myConcern_RecentContacts] ;
                    [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                    
                }
                
                [self.headview setTitle:[_tbv_dropDown.arrMenu objectAtIndex:nSection]];
                //                [self.headview setTitle:@"好友"];
            }
                break;
            case 1://我|TA 关注的
            {
                if (!_muA_data_MyConcern) {
                    [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                    [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                    
                    {//HTTP请求|刷新 我关注的
                        [self.view setUserInteractionEnabled:NO];
                        
                        MagicRequest *request = [DYBHttpMethod user_friendlist_userid:_str_userid num:@"10" page:1 type:@"1" isAlert:YES receive:self];
                        [request setTag:2];
                        
                        if (!request) {//无网路
//                            [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                }else{
                    [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                    [self initSectionOrder:_muA_data_MyConcern tbv:_tbv_friends_myConcern_RecentContacts];
                    [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                    
                }
                
                [self.headview setTitle:[_tbv_dropDown.arrMenu objectAtIndex:nSection]];
                
            }
                break;
            case 2://最近联系人
            {
                //                _tbv_friends_myConcern.hidden=YES;
                
                if (!_tbv_friends_myConcern_RecentContacts.muA_singelSectionData) {
                    [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                    [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                    
                    {//HTTP请求|刷新 最近联系人
                        [self.view setUserInteractionEnabled:NO];
                        
                        MagicRequest *request = [DYBHttpMethod user_recentcontact:_str_userid isAlert:YES receive:self];
                        [request setTag:3];
                        
                        if (!request) {//无网路
//                            [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                }else{
                    [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                    [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                    
                    [_tbv_friends_myConcern_RecentContacts resetSectionData];//每个section里的value
                    [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                    
                }
                
                [self.headview setTitle:[_tbv_dropDown.arrMenu objectAtIndex:nSection]];
                
                //                [self.headview setTitle:@"最近联系人"];
                
            }
                break;
            default:
                break;
        }
        
        [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:nil from:self target:_tbv_dropDown];
        //        [self sendViewSignal:[MagicUISearchBar CANCEL] withObject:_search];
        [_search cancelSearch];
        
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
        MagicUILabel *lb_title=[[MagicUILabel alloc]initWithFrame:CGRectMake(15, 4, 0, 0)];
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
//        [lb_title changePosInSuperViewWithAlignment:1];
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
                    
                    if (_viewWarning) {
                        [_search setHidden:NO];
                        REMOVEFROMSUPERVIEW(_viewWarning);
                    }
                    
                    if (d.count==0) {//无数据时服务器坑爹的发来个数组
                        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                        [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                        [_tbv_friends_myConcern_RecentContacts reloadData];
                        [self.view setUserInteractionEnabled:YES];
                        [self addGuidePage];
                        return;
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
                        }
                        
                    }
                    
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
//                [_tbv_friends_myConcern_RecentContacts.footerView changeState:PULLSTATEEND];
                
            }
                
                break;
            case 2://获取|刷新 我关注的列表
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if (_viewWarning) {
                        [_search setHidden:NO];
                        REMOVEFROMSUPERVIEW(_viewWarning);
                    }
                    
                    id ob=[response.data objectForKey:@"user_list"];
                    if (![ob isKindOfClass:[NSDictionary class]]) {/*无数据,服务器 作死的返回 这种 {
                                                                    havenext = 0;
                                                                    "user_list" =     (
                                                                    );本来user_list对应的值是字典,没数据时却返回数组*/
                        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                        [_tbv_friends_myConcern_RecentContacts releaseDataResource];
                        [_tbv_friends_myConcern_RecentContacts reloadData];
                        [self.view setUserInteractionEnabled:YES];
                        return;
                    }
                    
                    NSDictionary *d=[response.data objectForKey:@"user_list"];
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
                            [self initSectionOrder:_muA_data_MyConcern tbv:_tbv_friends_myConcern_RecentContacts];
                            [self creatTbv];
                            [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv_friends_myConcern_RecentContacts reloadData:NO];
                            }else{
                                [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
//                            [_tbv_friends_myConcern_RecentContacts.headerView changeState:PULLSTATENORMAL];
                        }
                        
                    }
                    
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
//                [_tbv_friends_myConcern_RecentContacts.footerView changeState:PULLSTATEEND];
                
            }
                
                break;
                
            case 3://获取最近联系人
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    NSDictionary *d=[response.data objectForKey:@"user_list"];
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
                            
                            //                            _tbv_friends_myConcern_RecentContacts.muA_singelSectionData=_muA_data_RecentContacts;
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv_friends_myConcern_RecentContacts reloadData:NO];
                            }else{
                                [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
//                            [_tbv_friends_myConcern_RecentContacts.headerView changeState:PULLSTATENORMAL];
                        }
                        
                    }
                    
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
//                [_tbv_friends_myConcern_RecentContacts.footerView changeState:PULLSTATEEND];
                
            }
                break;
            default:
                break;
        }
    }
}

-(void)addGuidePage{
    if(!_viewWarning){
        [_search setHidden:YES];
        
        _viewWarning= [[UIView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(self.view.frame), self.frameHeight-self.headHeight)];
        [_viewWarning setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:_viewWarning];
        
        MagicUILabel *labWarning = [[MagicUILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2, 0, 200, 60)];
        [labWarning setBackgroundColor:[UIColor clearColor]];
        [labWarning setText:@"您暂时还没有好友\n猛戳屏幕见证奇迹"];
        [labWarning setNumberOfLines:2];
        [labWarning setTextColor:ColorGray];
        [labWarning setFont:[DYBShareinstaceDelegate DYBFoutStyle:20]];
        [labWarning setTextAlignment:NSTextAlignmentCenter];
        
        UIImage *image = [UIImage imageNamed:@"ybx_big.png"];
        float BearHeadStartX = (CGRectGetWidth(self.view.frame)-image.size.width/2)/2;
        float BearHeadStartY = (self.frameHeight-self.headHeight-image.size.height/2-60)/2;
        MagicUIImageView *viewBearHead = [[MagicUIImageView alloc] initWithFrame:CGRectMake(BearHeadStartX, BearHeadStartY, image.size.width/2, image.size.height/2)];
        [viewBearHead setBackgroundColor:[UIColor clearColor]];
        [viewBearHead setImage:image];
        
        [labWarning setFrame:CGRectMake(CGRectGetMinX(labWarning.frame), CGRectGetMaxY(viewBearHead.frame)+10, CGRectGetWidth(labWarning.frame), CGRectGetHeight(labWarning.frame))];
        
        [_viewWarning addSubview:labWarning];
        [_viewWarning addSubview:viewBearHead];
        RELEASE(viewBearHead);
        RELEASE(labWarning);
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapScreenWithGesture:)];
        [_viewWarning addGestureRecognizer:tapGestureRecognizer];
        RELEASE(tapGestureRecognizer);
        [self.view bringSubviewToFront:_viewWarning];
        RELEASE(_viewWarning);
    }
}

- (void)didTapScreenWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
        DLogInfo(@"%d", tappedView.tag);
        
        DYBSearchFriendsViewController *vc = [[DYBSearchFriendsViewController alloc] init];
        vc.b_isInMainPage = NO;
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
        
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

@end
