//
//  DYBSystemMsgViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSystemMsgViewController.h"
#import "UITableView+property.h"
#import "friend_request_list.h"
#import "reqlist.h"
#import "DYBCellForSystemMsg.h"
#import "DYBPersonalHomePageViewController.h"
#import "UIViewController+MagicCategory.h"

@interface DYBSystemMsgViewController ()
{
    MagicUIImageView *imgV;
    MagicUILabel *lb;
}
@end

@implementation DYBSystemMsgViewController

DEF_SIGNAL(PERSONALPAGE)

-(void)creatTbv{
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headHeight) isNeedUpdate:YES];
        _tbv._cellH=65;
        [self.view addSubview:_tbv];
        _tbv.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
        _tbv.tag=-1;
        _tbv._page=1;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tbv setTableViewType:DTableViewSlime];
        RELEASE(_tbv);
        
    }
    
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        {//HTTP请求
            [self.view setUserInteractionEnabled:NO];
            MagicRequest *request = [DYBHttpMethod message_friendreqlist_yaoqing:1 pageNum:10 isAlert:YES receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
//                [_tbv.footerView changeState:VIEWTYPEFOOTER];
            }
        }
        
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"系统消息"];
        [self backImgType:0];
        self.rightButton.hidden=YES;

    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv release_muA_differHeightCellView];
        
        REMOVEFROMSUPERVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}

#pragma mark- 初始化无数据提示view
-(void)initNoDataView:(NSString *)str{
    if (imgV) {
        REMOVEFROMSUPERVIEW(imgV);
        REMOVEFROMSUPERVIEW(lb);
    }
    
    if ([str isEqualToString:@""]) {
        return;
    }
    
    UIImage *img=[UIImage imageNamed:@"ybx_big"];
    imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self.view Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    
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
    
}

#pragma mark- 接受按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        NSDictionary *d=(NSDictionary *)signal.object;
        if (bt)
        {
            switch (bt.tag) {
                case 1://同意
                case 0://忽略
                {//HTTP请求
                    [self.view setUserInteractionEnabled:NO];
                    MagicRequest *request = [DYBHttpMethod message_applyfriend:[d objectForKey:@"userId"] op:[NSString stringWithFormat:@"%d",bt.tag] isAlert:YES receive:self];
                    [request setTag:3];
                    
                    if (!request) {//无网路
//                        [_tbv.footerView changeState:VIEWTYPEFOOTER];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
        
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
            
            DYBCellForSystemMsg *cell = [[[DYBCellForSystemMsg alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
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
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForSystemMsg *)[(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
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
        
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        {//HTTP请求
            [self.view setUserInteractionEnabled:NO];
            MagicRequest *request = [DYBHttpMethod message_friendreqlist_yaoqing:++tableView._page pageNum:10 isAlert:YES receive:self];
            [request setTag:2];
            
            if (!request) {//无网路
                [tableView reloadData:NO];
            }
        }
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        {//HTTP请求
            [self.view setUserInteractionEnabled:NO];
            MagicRequest *request = [DYBHttpMethod message_friendreqlist_yaoqing:(tableView._page=1) pageNum:10 isAlert:YES receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
                [tableView reloadData:NO];
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
        
        [_tbv StretchingUpOrDown:0];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [_tbv StretchingUpOrDown:1];
        
    }

}

/*
 {"response":"100","message":"\u8bf7\u6c42\u6210\u529f","data":{"reqlist":[{"user_info":{"userid":"184740","name":"example1","truename":"\u8d75\u6d01","sex":"1","desc":"\u4f60\u597dguutyygfdgg yuu","pic":"http:\/\/10.21.3.30:30080\/userphoto\/48\/38\/66th_7f184740.jpg","pic_s":"http:\/\/10.21.3.30:30080\/userphoto\/48\/38\/150th_7f184740.jpg","pic_b":"http:\/\/10.21.3.30:30080\/userphoto\/48\/38\/or_7f184740.jpg","verify":"2","usertype":"0","fullname":"example1(\u8d75\u6d01)","is_vip":"0"},"id":"7911965","time":"1384055023","content":"\u5df2\u540c\u610f\u60a8\u7684\u597d\u53cb\u8bf7\u6c42","kind":"2","view":"1"},{"user_info":{"userid":"184740","name":"example1","truename":"\u8d75\u6d01","sex":"1","desc":"\u4f60\u597dguutyygfdgg yuu","pic":"http:\/\/10.21.3.30:30080\/userphoto\/48\/38\/66th_7f184740.jpg","pic_s":"http:\/\/10.21.3.30:30080\/userphoto\/48\/38\/150th_7f184740.jpg","pic_b":"http:\/\/10.21.3.30:30080\/userphoto\/48\/38\/or_7f184740.jpg","verify":"2","usertype":"0","fullname":"example1(\u8d75\u6d01)","is_vip":"0"},"id":"7911856","time":"1383819037","content":"\u606d\u559c\u4f60\uff0c\u83b7\u5f97\u4e00\u4e2a\u6613\u6253\u5370\u8bc6\u522b\u7801\uff1a\u003Cfont color='red'\u003Eg9qe3o\u003C\/font\u003E\uff0c\u5e76\u5df2\u6210\u529f\u6263\u9664\u7f51\u85aa30@\uff0c\u8bc6\u522b\u7801 2013-11-10 18:10\u5230\u671f\uff0c\u8bf7\u5c3d\u5feb\u4f7f\u7528\uff0c\u003Ca href='http:\/\/www.yiban.cn\/i\/index\/print' target='_blank'\u003E\u67e5\u770b\u8be6\u60c5\u003E\u003E\u003E\u003C\/a\u003E","kind":"118","view":"1"}],"havenext":"0"},"sessID":"vj32O9K74pXKigmM250UODAWJrirB3IRUH2ZREhthos4yStxR3a41t9xiLmVBwxSiztyhmfrjkQ="}
 */

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
                    NSArray *list=[response.data objectForKey:@"reqlist"];
                    
                    if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                        [_tbv.muA_singelSectionData removeAllObjects];
                        
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        reqlist *model = [reqlist JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            [self creatTbv];
                            [self initNoDataView:@""];

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
                            
                            [self.view setUserInteractionEnabled:YES];
                            return;
                            
                        }else{//没获取到数据,恢复headerView
//                            [_tbv reloadData:YES];
                        }
                        
                    }
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self initNoDataView:@"没有系统消息"];
                [_tbv releaseDataResource];
                [_tbv release_muA_differHeightCellView];
                [_tbv reloadData:YES];
                
                [self.view setUserInteractionEnabled:YES];
                
            }
                
                break;
                
            case 2://加载更多
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"reqlist"];
                    for (NSDictionary *d in list) {
                        reqlist *model = [reqlist JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                        }else{
                            [_tbv.muA_singelSectionData addObject:model];
                        }
                    }
                    
//                    if (list.count>0) {
//                        [_tbv reloadData:NO];
//                    }else{
//                        [_tbv.footerView changeState:PULLSTATEEND];
//                    }
                    
                    {//加载更多
                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                            
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
                    
                }else if ([response response] ==khttpfailCode)
                {
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
//                [_tbv.footerView changeState:PULLSTATEEND];
                
                
            }
                break;
                
            case 3://同意|忽略
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([[response.data objectForKey:@"apply"] isEqualToString:@"1"]) {//成功
                        [_tbv release_muA_differHeightCellView];
                        [_tbv releaseDataResource];
                        
                        {//HTTP请求,刷新列表
                            [self.view setUserInteractionEnabled:NO];
                            MagicRequest *request = [DYBHttpMethod message_friendreqlist_yaoqing:(_tbv._page=1) pageNum:10 isAlert:YES receive:self];
                            [request setTag:1];
                            
                            if (!request) {//无网路
//                                [_tbv.footerView changeState:VIEWTYPEFOOTER];
                            }
                        }
                    }
                    
                    [self postNotification:[UIViewController AutoRefreshTbvInViewWillAppear] withObject:Nil userInfo:Nil];
                }else if ([response response] ==khttpfailCode)
                {
                    
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

- (void)handleViewSignal_DYBSystemMsgViewController:(MagicViewSignal *)signal{
    if ([signal is:[DYBSystemMsgViewController PERSONALPAGE]]){
        NSDictionary *dic = (NSDictionary *)[signal object];
        
        DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
        vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"username"], @"name", [dic objectForKey:@"userid"], @"userid", nil];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }
}


@end
