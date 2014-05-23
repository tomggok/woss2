//
//  DYBSelectSchoolController.m
//  DYiBan
//
//  Created by Song on 13-9-3.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSelectSchoolController.h"
#import "scrollerData.h"
#import "UITableView+property.h"
#import "UIView+MagicCategory.h"
#import "DYBCellForSchoolList.h"
#import "Magic_UIUpdateView.h"
#import "friends.h"
#import "ChineseToPinyin.h"
#import "school_list.h"
#import "userRegistModel.h"
#import "DYBRegisterStep2ViewController.h"
#import "DYBRegisterStep3ViewController.h"
@interface DYBSelectSchoolController ()

@end

@implementation DYBSelectSchoolController
@synthesize father = _father;
#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        if (!_search) {
            _search=[[MagicUISearchBar alloc]initWithFrame:CGRectMake(0, self.headHeight, self.view.frame.size.width, 50) backgroundColor:BKGGray placeholder:@"学校名称" isHideOutBackImg:YES isHideLeftView:NO];
            [_search customBackGround:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_search"]] autorelease]];
            _search.tag=-1;
            [self.view addSubview:_search];
            [_search release];
        }
        
        oldIndex = -1;
        newIndex = -1;
        
        [self.view setUserInteractionEnabled:NO];
        
        MagicRequest *request = [DYBHttpMethod school_list:@"1" isAlert:YES receive:self];
        [request setTag:1];
        
        if (!request) {//无网路
//            [_tbv.footerView changeState:VIEWTYPEFOOTER];
        }
        
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"选择学校"];
        [self setButtonImage:self.leftButton setImage:@"btn_back_def" setHighString:@"btn_back_hlt"];
        [self setButtonImage:self.rightButton setImage:@"btn_ok_dis"];
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv release_muA_differHeightCellView];
        
        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}



#pragma mark-
-(void)creatTbv{
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight+_search.frame.size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headHeight-_search.frame.size.height) isNeedUpdate:YES];
        _tbv._cellH=50;
        [self.view addSubview:_tbv];
        _tbv.tag=-1;
        _tbv._page=1;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
//        [_tbv.footerView changeState:PULLSTATEEND];
        _tbv.v_headerVForHide=_search;
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
            
            DYBCellForSchoolList *cell = [[[DYBCellForSchoolList alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(_tbv.muA_singelSectionData):(arr_curSectionForModel)) objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if (!tableView._muA_differHeightCellView) {
                tableView._muA_differHeightCellView=[[NSMutableArray alloc]initWithCapacity:[tableView.muD_allSectionValues allKeys].count];
            }
            
            if (![((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) containsObject:cell]) {
                [((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) addObject:cell];
            }
            
            NSNumber *s = [NSNumber numberWithInteger:cell.frame.size.height];
            [signal setReturnValue:s];
            
        }else{//之前计算过的cell
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForSchoolList *)[((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
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
        
        for (int i = 0; i < [tableview._muA_differHeightCellView count]; i++) {
            DYBCellForSchoolList *cell=((DYBCellForSchoolList *)[tableview._muA_differHeightCellView objectAtIndex:i]);
            [cell._imgV_star setImage:[UIImage imageNamed:@"radio_off"]];
        }
        
        DYBCellForSchoolList *cell=((DYBCellForSchoolList *)[tableview._muA_differHeightCellView objectAtIndex:indexPath.row]);
        if (oldIndex == indexPath.row) {
            [cell._imgV_star setImage:[UIImage imageNamed:@"radio_off"]];
            oldIndex = -1;
            [self setButtonImage:self.rightButton setImage:@"btn_ok_dis"];
            return;
            
        }
        
        newIndex = indexPath.row;
        
        oldIndex = newIndex;
        
        
        [cell._imgV_star setImage:[UIImage imageNamed:@"radio_on"]];
        [self setButtonImage:self.rightButton setImage:@"btn_ok_def" setHighString:@"btn_ok_high"];
        medelData = [tableview.muA_singelSectionData objectAtIndex:indexPath.row];
        
        NSLog(@"====cellID======%@",medelData.id);
        
        
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
//        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        {//HTTP请求已加入的班级列表
            [self.view setUserInteractionEnabled:NO];
            
            MagicRequest *request = [DYBHttpMethod school_list:@"1" isAlert:YES receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
//                [tableView setUpdateState:DUpdateStateNomal];
            }
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
        
        [_tbv StretchingUpOrDown:0];
        [_search resignFirstResponder];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [_tbv StretchingUpOrDown:1];
        [_search resignFirstResponder];
        
    }
}


#pragma mark- 
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        if (self.rightButton.imageView.image == [UIImage imageNamed:@"btn_ok_dis"]) {
            return;
        }
        MagicRequest *request = [DYBHttpMethod school_cert:medelData.id isAlert:YES receive:self];
        [request setTag:2];
    }
    
}


#pragma mark- 只接受searchBar信号
- (void)handleViewSignal_MagicUISearchBar:(MagicViewSignal *)signal{
    if ([signal is:[MagicUISearchBar BEGINEDITING]]) {//第一次按下搜索框
        
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        {
            search.showsScopeBar = YES;//控制搜索栏下部的选择栏是否显示出来
            [search setShowsCancelButton:YES animated:YES];
        }
        
    }else if ([signal is:[MagicUISearchBar CANCEL]]){//取消搜索
        
        [_tbv release_muA_differHeightCellView];
        [_tbv resetSectionData];
        [_tbv reloadData:YES];
        
    }else if ([signal is:[MagicUISearchBar SEARCH]]){//按下搜索按钮
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
        [search resignFirstResponder];
        
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
        
        NSDictionary *d=(NSDictionary *)signal.object;
        UITableView *tbv=[d objectForKey:@"tbv"];
        NSString *searchContent=[d objectForKey:@"searchContent"];
        
        [tbv resetSectionData];//每个section里的value
        
        if (tbv.muA_allSectionKeys == 0) {//循环搜索单section的tbv
            
         
                
            NSMutableArray *toRemove = [[NSMutableArray alloc] init];
            
            for (scrollerData *u_info in tbv.muA_singelSectionData) {
                int strLen = [searchContent length];//字符串的长度，一个字母和汉字都算一个
                const char *cString = [searchContent UTF8String];
                int bytLeng = strlen(cString);
                
                NSString *strName = nil;
                
                if(strLen < bytLeng){
                    strName = [NSString stringWithFormat:@"%@", u_info.name];
                }
                else{
                    strName = [NSString stringWithFormat:@"%@",[ChineseToPinyin pinyinFromChiniseString:u_info.name]];
                }
                
                if ([strName rangeOfString:searchContent options:NSCaseInsensitiveSearch].location == NSNotFound)
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
                
                for (scrollerData *u_info in array) {
                    int strLen = [searchContent length];//字符串的长度，一个字母和汉字都算一个
                    const char *cString = [searchContent UTF8String];
                    int bytLeng = strlen(cString);
                    
                    NSString *strName = nil;
                    NSString *strTrueName = nil;
                    
                    if(strLen < bytLeng){
                        strName = [NSString stringWithFormat:@"%@", u_info.name];
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
            
            if ([tbv.muD_allSectionValues count] == 0) {
                [DYBShareinstaceDelegate loadFinishAlertView:@"未找到学校" target:self];
            }
            
            [sectionsToRemove release];
        }
        
        //        [self performSelectorOnMainThread:@selector(reloadtable) withObject:nil waitUntilDone:YES];
        
       [tbv release_muA_differHeightCellView];
        [tbv reloadData];
    }
}




    


#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取|刷新 班级成员
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    
                     NSArray *list = [response.data objectForKey:@"school_list"];
                    
                    if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                        [_tbv.muA_singelSectionData removeAllObjects];
                        
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        scrollerData *model = [scrollerData JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            [self creatTbv];
                            
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                            
                        }else{
                            
                            [_tbv.muA_singelSectionData addObject:model];
                            
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
                    
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                    [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                }
                
                [self.view setUserInteractionEnabled:YES];
                
            }
                break;
            case 2: {
                
                //学校认证数据接口的获得认证字段
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    
                    school_list *schoolList = [school_list JSONReflection:[response.data objectForKey:@"school"]];
                    
                    SHARED.registUserSetting.registcert_key = schoolList.cert_key;
                    
                    NSString *textString;
                    if ([schoolList.cert_key isEqualToString:@"sid"]) {
                        textString = @"学号/工号";
                    }
                    if ([schoolList.cert_key isEqualToString:@"cid"]) {
                        textString = @"身份证号";
                    }
                    if ([schoolList.cert_key isEqualToString:@"tid"]) {
                        textString = @"准考证号";
                    }
                    if ([schoolList.cert_key isEqualToString:@"phone"]) {
                        textString = @"手机号码";
                    }
                    if ([schoolList.cert_key isEqualToString:@"aid"]) {
                        textString = @"录取通知书编号";
                    }
                    if ([schoolList.cert_key isEqualToString:@"bid"]) {
                        textString = @"报名号";
                    }
                    
                    [_father changeText:textString scrollerData:medelData];
                    [self.drNavigationController popViewControllerAnimated:YES];
                }
                if ([response response] ==khttpfailCode)
                {
                    [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                    DLogInfo(@"=======%@",response.message);
                }
            }
                break;
        }
    }
}

@end
