//
//  SYBMsgViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBMsgViewController.h"
#import "UIView+MagicCategory.h"
#import "UITableView+property.h"
#import "DYBCellForDYBMsgViewController.h"
#import "JsonResponse.h"
#import "message_list.h"
#import "contact.h"
#import "DYBCellForPrivateMsgList.h"
#import "DYBMentionedMeViewController.h"
#import "DYBCommentMeViewController.h"
#import "DYBNoticeViewController.h"
#import "DYBSystemMsgViewController.h"
#import "DYBSelectContactViewController.h"
#import "DYBUnreadMsgView.h"
#import "DYBPersonalLetterCheckRecordViewController.h"
#import "DYBUITabbarViewController.h"
#import "DYBSendPrivateLetterViewController.h"
#import "DYBSendNoticeViewController.h"
#import "UIViewController+MagicCategory.h"
#import "DYBGuideView.h"

@interface DYBMsgViewController ()
{
    MagicUIImageView *imgV;
    MagicUILabel *lb;
}
@end

@implementation DYBMsgViewController

//@synthesize v_totalNumOfUnreadMsg=_v_totalNumOfUnreadMsg;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
//        [self creatTbv];
        
        self.view.backgroundColor=[UIColor whiteColor];
        
        {
            _v_fourbtBack=[[UIView alloc]initWithFrame:CGRectMake(0, self.headHeight, self.view.frame.size.width, 85)];
//            _v_fourbtBack.backgroundColor=self.headview.backgroundColor;
            _v_fourbtBack._originFrame=CGRectMake(0, self.headHeight, self.view.frame.size.width, 85);
            _v_fourbtBack.backgroundColor=[MagicCommentMethod color:248 green:248 blue:248 alpha:1];
            [self.view addSubview:_v_fourbtBack];
            RELEASE(_v_fourbtBack);
        }
        
        if (!_bt_notice) {
            UIImage *img= [UIImage imageNamed:@"info_notes_def"];
            _bt_notice = [[MagicUIButton alloc] initWithFrame:CGRectMake(15, 0, img.size.width/2, img.size.height/2)];
            _bt_notice.tag=-3;
            [_bt_notice addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_notice setImage:img forState:UIControlStateNormal];
            [_bt_notice setImage:[UIImage imageNamed:@"info_notes_high"] forState:UIControlStateHighlighted];
            [_v_fourbtBack addSubview:_bt_notice];
            [_bt_notice changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_notice);
        }
        
        if (!_bt_MentionedMe) {//提醒
            UIImage *img= [UIImage imageNamed:@"info_at_def"];
            _bt_MentionedMe = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_notice.frame.origin.x+_bt_notice.frame.size.width+16, 0, img.size.width/2, img.size.height/2)];
            _bt_MentionedMe.tag=-4;
            [_bt_MentionedMe addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_MentionedMe setImage:img forState:UIControlStateNormal];
            [_bt_MentionedMe setImage:[UIImage imageNamed:@"info_at_high"] forState:UIControlStateHighlighted];
            [_v_fourbtBack addSubview:_bt_MentionedMe];
            [_bt_MentionedMe changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_MentionedMe);
        }
        
        if (!_bt_CommentMe) {//评论我的
            UIImage *img= [UIImage imageNamed:@"info_comment_def"];
            _bt_CommentMe = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_MentionedMe.frame.origin.x+_bt_MentionedMe.frame.size.width+17, 0, img.size.width/2, img.size.height/2)];
            _bt_CommentMe.tag=-5;
            [_bt_CommentMe addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_CommentMe setImage:img forState:UIControlStateNormal];
            [_bt_CommentMe setImage:[UIImage imageNamed:@"info_comment_high"] forState:UIControlStateHighlighted];
            [_v_fourbtBack addSubview:_bt_CommentMe];
            [_bt_CommentMe changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_CommentMe);
        }
        
        if (!_bt_systemMsg) {//
            UIImage *img= [UIImage imageNamed:@"info_sys_def"];
            _bt_systemMsg = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_CommentMe.frame.origin.x+_bt_CommentMe.frame.size.width+16, 0, img.size.width/2, img.size.height/2)];
            _bt_systemMsg.tag=-6;
            [_bt_systemMsg addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_systemMsg setImage:img forState:UIControlStateNormal];
            [_bt_systemMsg setImage:[UIImage imageNamed:@"info_sys_high"] forState:UIControlStateHighlighted];
            [_v_fourbtBack addSubview:_bt_systemMsg];
            [_bt_systemMsg changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_systemMsg);
        }
        
        UIImage *img= [UIImage imageNamed:@"txtbox_shadow"];
        MagicUIImageView *_ima_line = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, 85-img.size.height/2, img.size.width/2, img.size.height/2)];
        
        [_ima_line setImage:img];
        [_v_fourbtBack addSubview:_ima_line];
        RELEASE(_ima_line);
        
//        _b_couldReload=NO;
        
        {//HTTP请求,私信列表
            [self.view setUserInteractionEnabled:NO];
            MagicRequest *request = [DYBHttpMethod message_contact_sixin:1 pageNum:10 isAlert:NO receive:self];
            [request setTag:2];
        }

    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"消息"];
        
//        if (_v_fourbtBack) {
//            [_v_fourbtBack setFrame:_v_fourbtBack._originFrame];
//        }
        
        {//HTTP请求,用户新信息数接口
            [self.view setUserInteractionEnabled:NO];
            MagicRequest *request = [DYBHttpMethod message_count:NO receive:self];
            [request setTag:1];
        }
        //
        if(self.b_isAutoRefreshTbvInViewWillAppear){//HTTP请求,私信列表
            [self.view setUserInteractionEnabled:NO];
            MagicRequest *request = [DYBHttpMethod message_contact_sixin:1 pageNum:10 isAlert:NO receive:self];
            [request setTag:2];
            
            self.b_isAutoRefreshTbvInViewWillAppear=NO;
        }

    if ((![[NSUserDefaults standardUserDefaults] stringForKey:@"DYBMsgViewController_DYBGuideView"] || [[[NSUserDefaults standardUserDefaults] stringForKey:@"DYBMsgViewController_DYBGuideView"] intValue]==0  )&& ([SHARED.curUser.is_moderator isEqualToString:@"1"]/*是否是班级管理员*/)) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DYBMsgViewController_DYBGuideView"];
        
        {
            DYBGuideView *guideV=[[DYBGuideView alloc]initWithFrame:self.view.frame];
            guideV.AddImgByName(@"msg",nil);
            [self.drNavigationController.view addSubview:guideV];
            RELEASE(guideV);
        }
    }
    
    }else if ([signal is:MagicViewController.DID_APPEAR]){
        [self.headview setTitle:@"消息"];
        
        self.rightButton.hidden=YES;

    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        if (!_bt_sendPrivateLetter&& self.headview) {
            UIImage *img= [UIImage imageNamed:@"btn_msg_def"];
            _bt_sendPrivateLetter = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.headview.frame.size.width-img.size.width/2-0, 0, img.size.width/2, img.size.height/2)];
            _bt_sendPrivateLetter.tag=-1;
            [_bt_sendPrivateLetter addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_sendPrivateLetter setBackgroundImage:img forState:UIControlStateNormal];
            [_bt_sendPrivateLetter setBackgroundImage:[UIImage imageNamed:@"btn_msg_high"] forState:UIControlStateHighlighted];
            [self.headview setRightView:_bt_sendPrivateLetter];
            [_bt_sendPrivateLetter changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_sendPrivateLetter);
        }
        
        if (!_bt_sendNotice&& self.headview && [SHARED.curUser.is_moderator isEqualToString:@"1"]/*是否是班级管理员*/) {
            UIImage *img= [UIImage imageNamed:@"btn_note_def"];
            _bt_sendNotice = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_sendPrivateLetter.frame.origin.x-img.size.width/2, 0, img.size.width/2, img.size.height/2)];
            _bt_sendNotice.tag=-2;
            [_bt_sendNotice addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_sendNotice setBackgroundImage:img forState:UIControlStateNormal];
            [_bt_sendNotice setBackgroundImage:[UIImage imageNamed:@"btn_note_press"] forState:UIControlStateHighlighted];
            [self.headview setRightView:_bt_sendNotice];
            [_bt_sendNotice changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_sendNotice);
        }
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        REMOVEFROMSUPERVIEW(_bt_sendNotice);
        REMOVEFROMSUPERVIEW(_bt_sendPrivateLetter);

        [_tbv release_muA_differHeightCellView];  //
        
//        REMOVEFROMSUPERVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}

#pragma mark-
-(void)creatTbv{
    if (_tbv) {
        REMOVEFROMSUPERVIEW(_tbv);//避免刷新时tbv不释放导致cell没彻底释放,这句不能删
    }
    
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight+_v_fourbtBack.frame.size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headHeight-_v_fourbtBack.frame.size.height) isNeedUpdate:YES];
        _tbv._cellH=64;
        [_tbv setTableViewType:DTableViewSlime];
        [self.view insertSubview:_tbv belowSubview:_v_fourbtBack];
        _tbv.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor whiteColor];//248 248 255
        _tbv.tag=-1;
        _tbv._page=1;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tbv.v_headerVForHide=_v_fourbtBack;
//        [_tbv set_selectIndex_now:[NSIndexPath indexPathForRow:-1 inSection:0]];//有滑动cell的tbv要初始化tbv已经划开的cell的下标不是0
        RELEASE(_tbv);
    }
    
}

#pragma mark- 初始化无数据提示view
-(void)initNoDataView:(NSString *)str
{
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


#pragma mark- 刷新 新消息的提示
-(void)refreshPromptNewMsg
{    
    if ([_model_message_count.new_notice intValue]>0) {//未读通知
        if (!_v_Notice) {
            UIImage *img=[UIImage imageNamed:@"tabtip_top"];
            RELEASEOBJ(_v_Notice);
            _v_Notice=[[DYBUnreadMsgView alloc]initWithFrame:CGRectMake(_bt_notice.center.x-(img.size.width/4), _v_fourbtBack.frame.size.height-(img.size.height/4), 0, 0) img:img nums:_model_message_count.new_notice arrowDirect:1];
            [_v_fourbtBack addSubview:_v_Notice];
            RELEASE(_v_Notice);
        }else{
            UIImage *img=[UIImage imageNamed:@"tabtip_top"];
            [_v_Notice refreshByimg:img nums:_model_message_count.new_notice];
        }
        
        [_bt_notice setImage:[UIImage imageNamed:@"info_notes_new"] forState:UIControlStateNormal];
        [_bt_notice setImage:[UIImage imageNamed:@"info_notes_new_high"] forState:UIControlStateHighlighted];
    }else if(_v_Notice){
        REMOVEFROMSUPERVIEW(_v_Notice);
        [_bt_notice setImage:[UIImage imageNamed:@"info_notes_def"] forState:UIControlStateNormal];
        [_bt_notice setImage:[UIImage imageNamed:@"info_notes_high"] forState:UIControlStateHighlighted];
    }
    
    if ([_model_message_count.new_at intValue]>0) {
        if (!_v_MentionedMe) {
            UIImage *img=[UIImage imageNamed:@"tabtip_top"];
            _v_MentionedMe=[[DYBUnreadMsgView alloc]initWithFrame:CGRectMake(_bt_MentionedMe.center.x-(img.size.width/4), _v_fourbtBack.frame.size.height-(img.size.height/4), 0, 0) img:img nums:_model_message_count.new_at arrowDirect:1];
            [_v_fourbtBack addSubview:_v_MentionedMe];
            RELEASE(_v_MentionedMe);
        }else{
            UIImage *img=[UIImage imageNamed:@"tabtip_top"];
            [_v_MentionedMe refreshByimg:img nums:_model_message_count.new_at];
        }
        
        [_bt_MentionedMe setImage:[UIImage imageNamed:@"info_at_new"] forState:UIControlStateNormal];
        [_bt_MentionedMe setImage:[UIImage imageNamed:@"info_at_new_high"] forState:UIControlStateHighlighted];
    }else if(_v_MentionedMe){
        REMOVEFROMSUPERVIEW(_v_MentionedMe);
        [_bt_MentionedMe setImage:[UIImage imageNamed:@"info_at_def"] forState:UIControlStateNormal];
        [_bt_MentionedMe setImage:[UIImage imageNamed:@"info_at_high"] forState:UIControlStateHighlighted];
        
    }
    
    if ([_model_message_count.new_comment intValue]>0) {
        if (!_v_CommentMe) {
            UIImage *img=[UIImage imageNamed:@"tabtip_top"];
            _v_CommentMe=[[DYBUnreadMsgView alloc]initWithFrame:CGRectMake(_bt_CommentMe.center.x-(img.size.width/4), _v_fourbtBack.frame.size.height-(img.size.height/4), 0, 0) img:img nums:_model_message_count.new_comment arrowDirect:1];
            [_v_fourbtBack addSubview:_v_CommentMe];
            RELEASE(_v_CommentMe);
        }else{
            UIImage *img=[UIImage imageNamed:@"tabtip_top"];
            [_v_CommentMe refreshByimg:img nums:_model_message_count.new_comment];
        }
        [_bt_CommentMe setImage:[UIImage imageNamed:@"info_comment_new"] forState:UIControlStateNormal];
        [_bt_CommentMe setImage:[UIImage imageNamed:@"info_comment_new_high"] forState:UIControlStateHighlighted];
    }else if(_v_CommentMe){
        REMOVEFROMSUPERVIEW(_v_CommentMe);
        [_bt_CommentMe setImage:[UIImage imageNamed:@"info_comment_def"] forState:UIControlStateNormal];
        [_bt_CommentMe setImage:[UIImage imageNamed:@"info_comment_high"] forState:UIControlStateHighlighted];
    }
    
    if ([_model_message_count.new_request intValue]>0) {
        if (!_v_systemMsg) {
            UIImage *img=[UIImage imageNamed:@"tabtip_top"];
            _v_systemMsg=[[DYBUnreadMsgView alloc]initWithFrame:CGRectMake(_bt_systemMsg.center.x-(img.size.width/4), _v_fourbtBack.frame.size.height-(img.size.height/4), 0, 0) img:img nums:_model_message_count.new_request arrowDirect:1];
            [_v_fourbtBack addSubview:_v_systemMsg];
            RELEASE(_v_systemMsg);
        }else{
            UIImage *img=[UIImage imageNamed:@"tabtip_top"];
            [_v_systemMsg refreshByimg:img nums:_model_message_count.new_request];
        }
        [_bt_systemMsg setImage:[UIImage imageNamed:@"info_sys_new"] forState:UIControlStateNormal];
        [_bt_systemMsg setImage:[UIImage imageNamed:@"info_sys_new_high"] forState:UIControlStateHighlighted];
    }else if(_v_systemMsg){
        REMOVEFROMSUPERVIEW(_v_systemMsg);
        [_bt_systemMsg setImage:[UIImage imageNamed:@"info_sys_def"] forState:UIControlStateNormal];
        [_bt_systemMsg setImage:[UIImage imageNamed:@"info_sys_high"] forState:UIControlStateHighlighted];
    }
}


#pragma mark- 接受tbv信号

static NSString *cellName = @"DYBCellForDYBMsgViewController";//前4个cell
//static NSString *CellForPrivateMsgList = @"CellForPrivateMsgList";//私信列表cel

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
            
            DYBCellForPrivateMsgList *cell = [[[DYBCellForPrivateMsgList alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[(([tableView isOneSection])?(tableView.muA_singelSectionData):(arr_curSectionForModel)) objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if (!tableView._muA_differHeightCellView) {
                tableView._muA_differHeightCellView=[[NSMutableArray alloc]initWithCapacity:[tableView.muD_allSectionValues allKeys].count];
            }
            
            if (![(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) containsObject:cell]) {
                [(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) addObject:cell];
            }
            
            NSNumber *s = [NSNumber numberWithInteger:cell.frame.size.height];
            [signal setReturnValue:s];//里边addSignal了自己,所以 cell.retainCount=4
            
        }else{//之前计算过的cell
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForPrivateMsgList *)[(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
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
        
        contact *model=[_tbv.muA_singelSectionData objectAtIndex:indexPath.row];
        if (model.view==0) {
            model.view=1;//已读
//            self.b_isAutoRefreshTbvInViewWillAppear=YES;
            
//        [tableview release_muA_differHeightCellView];
//        [tableview reloadData];
            
        UITableViewCell *cell=[tableview._muA_differHeightCellView objectAtIndex:indexPath.row];
//            REMOVEFROMSUPERVIEW(((DYBCellForPrivateMsgList *)cell).v_UnreadMsgView);
            ((DYBCellForPrivateMsgList *)cell).v_UnreadMsgView.hidden=YES;
        }
//        [tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        

        
//        DYBPersonalLetterCheckRecordViewController *vc = [[DYBPersonalLetterCheckRecordViewController alloc] init];
//        vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:model.user_info.name,@"name",model.user_info.userid,@"userid", nil];
//        [self.drNavigationController pushViewController:vc animated:YES];
//        RELEASE(vc);
        
        DYBSendPrivateLetterViewController *vc = [[DYBSendPrivateLetterViewController alloc] init];
        vc.model=[NSDictionary dictionaryWithObjectsAndKeys:model.user_info.userid,@"userid",model.user_info.name,@"name",model.user_info.pic_s,@"pic", nil];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
        
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        {//HTTP请求,私信列表
            [self.view setUserInteractionEnabled:NO];
            MagicRequest *request = [DYBHttpMethod message_contact_sixin:++tableView._page pageNum:10 isAlert:NO receive:self];
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
            [self.view setUserInteractionEnabled:NO];
            MagicRequest *request = [DYBHttpMethod message_count:NO receive:self];
            [request setTag:1];
            
            {//HTTP请求,私信列表
                MagicRequest *request = [DYBHttpMethod message_contact_sixin:(tableView._page=1) pageNum:10 isAlert:YES receive:self];
                [request setTag:2];
            }
            
//            if (!request) {//无网路
//                [tableView reloadData:NO];
//            }
            
            //                    _b_couldReload=NO;
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
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
        [_tbv StretchingUpOrDown:0];
        [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];

        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [_tbv StretchingUpOrDown:1];
        [[DYBUITabbarViewController sharedInstace] hideTabBar:NO animated:YES];

    }
}

#pragma mark- 接受按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        if (bt)
        {
            switch (bt.tag) {
                case -1://选择联系人
                {
                    DYBSelectContactViewController *vc = [[DYBSelectContactViewController alloc] init];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                    
                case -2://发通知
                {
                    if ([SHARED.curUser.is_moderator isEqualToString:@"1"]) {
                        DYBSendNoticeViewController *vc = [[DYBSendNoticeViewController alloc] init];
                        [self.drNavigationController pushViewController:vc animated:YES];
                        RELEASE(vc);
                    }
                    
                }
                    break;
                case -3://通知
                {
                    DYBNoticeViewController *vc = [[DYBNoticeViewController alloc] init];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                    
                }
                    break;
                case -4://提醒
                {
                    DYBMentionedMeViewController *vc = [[DYBMentionedMeViewController alloc] init];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                case -5://评论我的
                {
                    DYBCommentMeViewController *vc = [[DYBCommentMeViewController alloc] init];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                case -6://系统消息
                {
                    DYBSystemMsgViewController *vc = [[DYBSystemMsgViewController alloc] init];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                case -7://删除cell
                {
                    NSIndexPath *index=(NSIndexPath *)signal.object;
                    
                    contact *model=[_tbv.muA_singelSectionData objectAtIndex:index.row];
                    
                    {//HTTP请求,用户新信息数接口
                        [self.view setUserInteractionEnabled:NO];
                        MagicRequest *request = [DYBHttpMethod messageDelContact:model.user_info.userid ContactType:@"0" isAlert:YES receive:self];
                        [request setTag:4];
                        
                        if (!request) {//无网路
//                            [_tbv.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}

#pragma makr -
#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        DYBUITabbarViewController *dync = [DYBUITabbarViewController sharedInstace];
        [dync scrollMainView:1];
    }
    
}

#pragma mark- 初始化获取总未读消息数
-(void)initTotalNumOfUnreadMsgRequest
{
    {//HTTP请求,用户新信息数接口
        [self.view setUserInteractionEnabled:NO];
        MagicRequest *request = [DYBHttpMethod message_count:NO receive:self];
        [request setTag:1];
    }
    
    
}

#pragma mark- 计算总未读消息数
-(void)countTotalNumOfUnreadMsg
{
    _i_totalNumOfUnreadMsg=[_model_message_count.new_at intValue]+[_model_message_count.new_comment intValue]+[_model_message_count.new_message intValue]+[_model_message_count.new_notice intValue]+[_model_message_count.new_request intValue];
    
    [self refreshPromptNewMsg];
}


#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://用户新信息数接口
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if (_model_message_count) {
                        RELEASEOBJ(_model_message_count);
                    }
                    _model_message_count=[msg_count JSONReflection:response.data];
                    [_model_message_count retain];
                    
                    [self countTotalNumOfUnreadMsg];
                    [self refreshPromptNewMsg];
                    
                    [[DYBUITabbarViewController sharedInstace] addAndRefreshTotalMsgView:_i_totalNumOfUnreadMsg];
                    
//                    if (_b_couldReload) {
//                        [_tbv release_muA_differHeightCellView];
//                        [_tbv reloadData:NO];
//                    }else{
//                        _b_couldReload=YES;
//                    }
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];

            }
                break;
            case 2://获取|刷新 私信列表
            {
                if ([_tbv.v_headerVForHide frame].origin.y < 0)
                {
                    CGRect frame = [_tbv.v_headerVForHide frame];
                    frame.origin.y = 44;
                    [_tbv.v_headerVForHide setFrame:frame];
                }
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"contact"];
                    
                    if (_tbv.muA_singelSectionData.count>0 && list.count>0)  {
//                        [_tbv.muA_singelSectionData removeAllObjects];
                        [_tbv releaseDataResource];
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        contact *model = [contact JSONReflection:d];
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
                            [_tbv release_muA_differHeightCellView];
//                            [self countTotalNumOfUnreadMsg];
                            [self initNoDataView:@""];

                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                            
                            [self.view setUserInteractionEnabled:YES];
                            return;
                        }else{//没获取到数据,恢复headerView
//                            [_tbv.muA_singelSectionData removeAllObjects];
//                            [_tbv release_muA_differHeightCellView];
//                            [self initNoDataView:@"没有私信"];
//                            [_tbv reloadData:YES];
                        }
                        
                    }
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self initNoDataView:@"没有私信"];
                [_tbv releaseDataResource];
                [_tbv release_muA_differHeightCellView];
                [_tbv reloadData:YES];
                
                [self.view setUserInteractionEnabled:YES];

            }
            
                break;
                
            case 3://加载更多
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"contact"];
                    for (NSDictionary *d in list) {
                        contact *model = [contact JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            [self creatTbv];
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                        }else{
                            [_tbv.muA_singelSectionData addObject:model];
                        }
                    }
                    
                    if (list.count>0) {
                        [_tbv reloadData:NO];                        
                    }else{
//                        [_tbv.footerView changeState:PULLSTATEEND];
                    }
                    
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
                
            case 4://删私信
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSString *del=[response.data objectForKey:@"del"];
                    
                    if ([del isEqualToString:@"1"]) {
                        NSIndexPath *index=_tbv._selectIndex_now;
                        
                        [_tbv.muA_singelSectionData removeObjectAtIndex:index.row];
                        [_tbv._muA_differHeightCellView removeObjectAtIndex:index.row];

//                        [_tbv beginUpdates];
                        [_tbv deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
//                        [_tbv endUpdates];
                        
                        [_tbv release_muA_differHeightCellView];
                        [_tbv reloadData:YES];
                        
//                        [_tbv._selectIndex_now release];
                        _tbv._selectIndex_now=Nil;
                        
                        {//HTTP请求,用户新信息数接口
                            [self.view setUserInteractionEnabled:NO];
                            MagicRequest *request = [DYBHttpMethod message_count:NO receive:self];
                            [request setTag:1];
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
            
            default:
                break;
        }
    }
}
@end
