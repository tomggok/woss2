//
//  DYBNoticeDetailViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBNoticeDetailViewController.h"
#import "UITableView+property.h"
#import "status.h"
#import "DYBCellForNoticeDetail.h"
#import "DYBCustomLabel.h"
#import "NSString+Count.h"
#import "UIView+MagicCategory.h"
#import "DYBReadedViewController.h"
#import "notice.h"
#import "status_notice_model.h"
#import "DYBCheckMultiImageViewController.h"

@interface DYBNoticeDetailViewController ()
{
    MagicUITableView *_tbv;
    status_notice_model *_status;/*通知的内容*/
    DYBCustomLabel *_lb_readedNums/*已读人数*/;
    UIView *_v_tabbar;//底部tabbar
    NSMutableArray *_muA_readedUser;//已读人数列表
    MagicUIButton *_bt_IKnow;
    BOOL _b_isInstructorInNoticeClass;//当前用户在发这条通知的班级里是不是辅导员
}
@end

@implementation DYBNoticeDetailViewController

@synthesize str_noticeID=_str_noticeID;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        self.view.backgroundColor=ColorWhite;
        
        [self refreshTabbar];

        {//HTTP请求
            [self.view setUserInteractionEnabled:NO];
            
            MagicRequest *request = [DYBHttpMethod status_notice_id:_str_noticeID type:@"8" page:@"1" num:@"10" isAlert:YES receive:self];
            [request setTag:1];
            
//            if (!request) {//无网路
//                [_tbv.footerView changeState:VIEWTYPEFOOTER];
//            }
        }
        
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"通知详情"];
        [self backImgType:0];
        self.rightButton.hidden=YES;
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        
        //        RELEASE(_muA_data);
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv release_muA_differHeightCellView];
        
        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}

-(void)creatTbv{
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headHeight-50) isNeedUpdate:YES];
        //        _tbv._cellH=92;
        [self.view addSubview:_tbv];
        _tbv.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
        _tbv.tag=-1;
        _tbv._page=1;
        _tbv.i_pageNums=10;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tbv setTableViewType:DTableViewSlime];
    }
    
}

-(void)refreshTabbar
{//底部tabbar
    if (!_v_tabbar) {
        _v_tabbar=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-50-kH_StateBar, CGRectGetWidth(self.view.frame), 50)];
        _v_tabbar.backgroundColor=ColorNav;
        [self.view addSubview:_v_tabbar];
        RELEASE(_v_tabbar);
    }
    
    if (!_status) {
        return;
    }
    
    if (/*[SHARED.curUser.usertype intValue]==1 [[NSString stringWithFormat:@"%d",_status.status.userid] isEqualToString:SHARED.curUser.userid]*/ _b_isInstructorInNoticeClass) {//辅导员
        {
            //                UIImage *img= [UIImage imageNamed:@"msg_del"];
            MagicUIButton *_bt_refresh = [[MagicUIButton alloc] initWithFrame:CGRectMake(_v_tabbar.frame.size.width-75, 0,75, CGRectGetHeight(_v_tabbar.frame))];
            _bt_refresh.tag=1;
            _bt_refresh.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
            //            _bt_DropDown.alpha=0.9;
            [_bt_refresh addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:nil];
            //                [_bt_delete setImage:img forState:UIControlStateNormal];
            //            [_bt_sendNotice setBackgroundImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
            [_bt_refresh setTitle:@"刷新"];
            [_bt_refresh setTitleColor:ColorBlue];
            [_bt_refresh setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
            //                [_bt_refresh setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
            [_v_tabbar addSubview:_bt_refresh];
            [_bt_refresh changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_refresh);
        }
    }else{
        if (!_bt_IKnow) {
            //                UIImage *img= [UIImage imageNamed:@"msg_del"];
            _bt_IKnow = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0,100, CGRectGetHeight(_v_tabbar.frame))];
            _bt_IKnow.tag=2;
            _bt_IKnow.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
            //            _bt_DropDown.alpha=0.9;
            [_bt_IKnow addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:nil];
            //                [_bt_delete setImage:img forState:UIControlStateNormal];
            //            [_bt_sendNotice setBackgroundImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
            [_bt_IKnow setTitle:@"我知道了"];
            [_bt_IKnow setTitleColor:ColorBlue];
            [_bt_IKnow setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
            //                [_bt_refresh setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
            [_v_tabbar addSubview:_bt_IKnow];
            [_bt_IKnow changePosInSuperViewWithAlignment:2];
            RELEASE(_bt_IKnow);
            
            if ([SHARED.curUser.verify isEqualToString:@"0"]) {
                _bt_IKnow.enabled=NO;
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
            
            DYBCellForNoticeDetail *cell = [[[DYBCellForNoticeDetail alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
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
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForNoticeDetail *)[(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
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
            
            MagicRequest *request = [DYBHttpMethod status_notice_id:_str_noticeID type:@"8" page:@"1" num:@"10" isAlert:YES receive:self];
            [request setTag:1];
            
//            if (!request) {//无网路
//                [_tbv reloadData:YES];
//                [self.view setUserInteractionEnabled:YES];
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
        
        [_tbv StretchingUpOrDown:0];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [_tbv StretchingUpOrDown:1];
        
    }
    
}

-(void)refreshReadedUserList:(NSArray *)arr
{
    if (/*[[NSString stringWithFormat:@"%d",_status.status.userid] isEqualToString:SHARED.curUser.userid]*/ /*[SHARED.curUser.usertype intValue]==1*/ _b_isInstructorInNoticeClass) {//辅导员
        RELEASEDICTARRAYOBJ(_muA_readedUser);
        if (!_muA_readedUser && arr.count>0) {
            for (id ob in arr) {
                notice *model=ob;
                if (!_muA_readedUser) {
                    _muA_readedUser=[NSMutableArray arrayWithObject:model];
                    [_muA_readedUser retain];
                }else{
                    [_muA_readedUser addObject:model];
                }
            }
            
        }
    }
 
}


-(void)refreshReadedNums:(status_notice_model *)model
{
    if (/*[[NSString stringWithFormat:@"%d",model.status.userid] isEqualToString:SHARED.curUser.userid]  [SHARED.curUser.usertype intValue]==1*/ _b_isInstructorInNoticeClass) {//辅导员
        if (!_lb_readedNums) {
            _lb_readedNums=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(15, 0, 0, 0)];
            _lb_readedNums.backgroundColor=[UIColor clearColor];
            _lb_readedNums.textAlignment=NSTextAlignmentLeft;
            _lb_readedNums.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
            _lb_readedNums.text=[NSString stringWithFormat:@"已读人数 (%d)",[model.response_num integerValue]];
            _lb_readedNums.textColor=ColorBlue;
            _lb_readedNums.numberOfLines=1;
            _lb_readedNums.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_readedNums sizeToFitByconstrainedSize:CGSizeMake(_v_tabbar.frame.size.width-_lb_readedNums.frame.origin.x, 100)];
            [_v_tabbar addSubview:_lb_readedNums];
            [_lb_readedNums changePosInSuperViewWithAlignment:1];
            [_lb_readedNums addSignal:[UIView TAP] object:nil target:self];
            
            _lb_readedNums.FONT(@"5",[NSString stringWithFormat:@"%d",model.response_num.length+2],@"13");
            [_lb_readedNums setNeedCoretext:YES];
            RELEASE(_lb_readedNums);
        }else{
            _lb_readedNums.text=[NSString stringWithFormat:@"已读人数 (%d)",[model.response_num integerValue]];
            [_lb_readedNums sizeToFitByconstrainedSize:CGSizeMake(_v_tabbar.frame.size.width-_lb_readedNums.frame.origin.x, 100)];
            _lb_readedNums.FONT(@"5",[NSString stringWithFormat:@"%d",model.response_num.length+2],@"13");
            [_lb_readedNums setNeedCoretext:YES];
        }
    }

}

#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal{
    
    if ([signal is:[UIView TAP]]) {
//        NSDictionary *d=(NSDictionary *)signal.object;
//        user_birthday *model=[d objectForKey:@"object"];
        
        
        UIView *v=signal.source;
        switch (v.tag) {
            case 0:
            {
                if (_muA_readedUser.count>0) {
                    DYBReadedViewController *vc = [[DYBReadedViewController alloc] init];
                    vc.muA_readedUser=[NSMutableArray arrayWithArray:_muA_readedUser];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
            }
                break;
            case 6://点动态cell的图片
            {
                NSDictionary *dic = (NSDictionary *)[signal object];
                status *_status = (status *)([[dic objectForKey:@"object"] objectForKey:@"status"]);
                
                NSMutableArray *_arrPic = [[NSMutableArray alloc] init];
                
                if ([_status.isfollow isEqualToString:@"1"]) {
                    for (NSDictionary *dic in _status.status.pic_array) {
                        [_arrPic addObject:[dic objectForKey:@"pic"]];
                    }
                }else{
                    for (NSDictionary *dic in _status.pic_array) {
                        [_arrPic addObject:[dic objectForKey:@"pic"]];
                    }
                }
                
                DYBCheckMultiImageViewController *vc = [[DYBCheckMultiImageViewController alloc] initWithMultiImage:_arrPic nCurSel:[([[dic objectForKey:@"object"] objectForKey:@"tag"]) intValue]];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
                RELEASEDICTARRAYOBJ(_arrPic);
                
            }
            default:
                break;
        }

        
    }
}

#pragma mark- 接受按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        NSDictionary *d=(NSDictionary *)signal.object;
        if (bt)
        {
            switch (bt.tag) {
                case 1://
                {//HTTP请求
                    [self.view setUserInteractionEnabled:NO];
                    
                    MagicRequest *request = [DYBHttpMethod status_notice_id:_str_noticeID type:@"8" page:@"1" num:@"10" isAlert:YES receive:self];
                    [request setTag:1];
                    
                    if (!request) {//无网路
//                        [_tbv.footerView changeState:VIEWTYPEFOOTER];
                    }
                }
                    break;
                case 2://我知道了
                {
                    {//HTTP请求
                        [self.view setUserInteractionEnabled:NO];
                        
                        MagicRequest *request = [DYBHttpMethod status_feedaction_id:_str_noticeID action:@"3" type:@"1" isAlert:YES receive:self];
                        [request setTag:2];
                        
//                        if (!request) {//无网路
//                            [_tbv reloadData:YES];
//                            [self.view setUserInteractionEnabled:YES];
//                        }
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
            case 1://获取|刷新
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    
                    status_notice_model *model=[status_notice_model JSONReflection:response.data];
                    if (!model) {
                        return;
                    }
                    _status=nil;
                    _status=model;
                    
                    _b_isInstructorInNoticeClass=(model.status.userid==[SHARED.curUser.userid intValue]);
                    
                    [self refreshTabbar];
                    
                    [self refreshReadedNums:model];
                    
                    [self refreshReadedUserList:model.notice];
                    
                if ([_status.status.isnotice intValue]==1 && !_b_isInstructorInNoticeClass /*[SHARED.curUser.usertype intValue]!=1  ![[NSString stringWithFormat:@"%d",_status.status.userid] isEqualToString:SHARED.curUser.userid]*/ ) {//把我知道了变成已读
                    [_bt_IKnow setTitle:@"已读"];
                    _bt_IKnow.enabled=NO;
                    [_bt_IKnow setTitleColor:ColorGray];
                }

                    if (_tbv.muA_singelSectionData.count>0) {
                        [_tbv.muA_singelSectionData removeAllObjects];
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    {
                        if (!_tbv.muA_singelSectionData) {
                            [self creatTbv];
                            
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:_status];
                            [_tbv.muA_singelSectionData retain];
                        }else{
                            [_tbv.muA_singelSectionData addObject:_status];
                        }
                    }
                    
                    {
                        if (_tbv.muA_singelSectionData.count>0) {
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
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
                
            }
                
                break;
                
            case 2://我知道了
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                [pop setDelegate:self];
                [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                [pop setText:[response.data objectForKey:@"message"]];
                [pop alertViewAutoHidden:.5f isRelease:YES];

                if ([response response] ==khttpsucceedCode)
                {
                    NSString *result=[response.data objectForKey:@"result"];
                    if ([result isEqualToString:@"1"]) {
                        
                        [_bt_IKnow setTitle:@"已读"];
                        _bt_IKnow.enabled=NO;
                        [_bt_IKnow setTitleColor:ColorGray];
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
                
            default:
                break;
        }
    }
}

@end
