//
//  DYBTop_StampListViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-9-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBTop_StampListViewController.h"
#import "UITableView+property.h"
#import "user.h"
#import "user_avatardolist.h"
#import "DYBCellForUser_avatardolist.h"
#import "UITableViewCell+MagicCategory.h"
#import "DYBPersonalHomePageViewController.h"

@interface DYBTop_StampListViewController ()

@end

@implementation DYBTop_StampListViewController

@synthesize type,str_userid=_str_userid;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
//        [self creatTbv];
//        
        {//HTTP请求
            [self.view setUserInteractionEnabled:NO];
            MagicRequest *request = [DYBHttpMethod user_avatardolist:_str_userid type:[NSString stringWithFormat:@"%d",type] isAlert:YES receive:self];
            [request setTag:1];
        }
        
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:((type==0)?(@"顶我的人"):(@"踩我的人"))];
        [self backImgType:0];
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv release_muA_differHeightCellView];
        //
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

- (void)back
{
    [self.drNavigationController popViewControllerAnimated:YES];
    
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
            
            DYBCellForUser_avatardolist *cell = [[[DYBCellForUser_avatardolist alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            cell.i_type=type;
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
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForUser_avatardolist *)[(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
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
            user_avatardolist *model=[tableview.muA_singelSectionData objectAtIndex:indexPath.row];
            
            DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
            
            vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:model.username,@"name",model.userid,@"userid", nil];
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
        
        {//HTTP请求
            [self.view setUserInteractionEnabled:NO];
            MagicRequest *request = [DYBHttpMethod user_avatardolist:_str_userid type:[NSString stringWithFormat:@"%d",type] isAlert:YES receive:self];
            [request setTag:1];
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


#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取|刷新
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"user_list"];
                    
                    if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                        [_tbv release_muA_differHeightCellView];
                        [_tbv releaseDataResource];
                    }
                    
//                    int previousLastTopTime=0;//response.data里上一个顶我的人顶我的时间
//                    int index=0;//数组排序用
                    
                    for (NSDictionary *d in list) {
                        user_avatardolist *model = [user_avatardolist JSONReflection:d];
//                        if (type==0 && [model.topCount intValue]>0) {//顶我的人
//                            if (!_tbv.muA_singelSectionData) {
//                                [self creatTbv];
//                                _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
//                                [_tbv.muA_singelSectionData retain];
////                                previousLastTopTime=[model.lastTopTime intValue];//第一个顶我的人的顶我的时间
//                            }else{
//                                
//                                [_tbv.muA_singelSectionData addObject:model];
//                                                                
//                                {//当前顶我的人比上一个顶我的人顶我的时间更近,和上一个顶我的人互换数组位置
//                                    
//                                    for (int i=_tbv.muA_singelSectionData.count-1;i>0;i--) {//再拿换到前一个下标的元素和他之前的比,如果对比成功,再往前换一个index,直到换到0号index
//                                        if (([((user_avatardolist *)[_tbv.muA_singelSectionData objectAtIndex:i]).lastTopTime intValue]) > ([((user_avatardolist *)[_tbv.muA_singelSectionData objectAtIndex:i-1]).lastTopTime intValue])) {//lastTopTime的值越大,表示 离 现在的时间越近
//                                            [_tbv.muA_singelSectionData exchangeObjectAtIndex:i withObjectAtIndex:i-1];
//                                        }
//                                    }
//                                }
//
//                            }
//                            
////                            index++;
//                        }else if (type==1 && [model.treadCount intValue]>0)//踩我的人
//                        {
//                            if (!_tbv.muA_singelSectionData) {
//                                [self creatTbv];
//                                _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
//                                [_tbv.muA_singelSectionData retain];
//                            }else{
//                                [_tbv.muA_singelSectionData addObject:model];
//                                
//                                {//当前踩我的人比上一个踩我的人踩我的时间更近,和上一个踩我的人互换数组位置
//                                    
//                                    for (int i=_tbv.muA_singelSectionData.count-1; i>0;i--) {//再拿换到前一个下标的元素和他之前的比,如果对比成功,再往前换一个index,直到换到0号index
//                                        if (([((user_avatardolist *)[_tbv.muA_singelSectionData objectAtIndex:i]).lastTreadTime intValue]) > ([((user_avatardolist *)[_tbv.muA_singelSectionData objectAtIndex:i-1]).lastTreadTime intValue])) {//lastTreadTime的值越大,表示 离 现在的时间越近
//                                            [_tbv.muA_singelSectionData exchangeObjectAtIndex:i withObjectAtIndex:i-1];
//                                        }
//                                    }
//                                }
//                                
//                            }
//                        }
                        
                            if (!_tbv.muA_singelSectionData) {
                                [self creatTbv];
                                _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                                [_tbv.muA_singelSectionData retain];
//                                previousLastTopTime=[model.lastTopTime intValue];//第一个顶我的人的顶我的时间
                            }else{

                                [_tbv.muA_singelSectionData addObject:model];

                            }
                       
                    }
                    
                    {
                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                            [_tbv release_muA_differHeightCellView];
//                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
//                                [_tbv reloadData:NO];
//                            }else{
//                                [_tbv reloadData:YES];
//                            }
                            [_tbv reloadData:YES];

                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
                            
                            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back) userInfo:nil repeats:NO];
                        }
                        
                    }
                    
                }else if ([response response] ==khttpfailCode){
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back) userInfo:nil repeats:NO];
                }
                
                [self.view setUserInteractionEnabled:YES];
                
            }
                
                break;
                
            case 2://加载更多
                //            {
                //                JsonResponse *response = (JsonResponse *)receiveObj;
                //
                //                if ([response response] ==khttpsucceedCode)
                //                {
                //                    NSArray *list=[response.data objectForKey:@"reqlist"];
                //                    for (NSDictionary *d in list) {
                //                        reqlist *model = [reqlist JSONReflection:d];
                //                        if (!_muA_data) {
                //                            _muA_data=[NSMutableArray arrayWithObject:model];
                //                            [_muA_data retain];
                //                        }else{
                //                            [_muA_data addObject:model];
                //                        }
                //                    }
                //
                //                    if (list.count>0) {
                //                        [_tbv reloadData:NO];
                //                    }else{
                //                        [_tbv.footerView changeState:PULLSTATEEND];
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
                //                [_tbv.footerView changeState:PULLSTATEEND];
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
