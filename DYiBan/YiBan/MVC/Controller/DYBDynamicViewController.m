//
//  DYBDynamicViewController.m
//  DYiBan
//
//  Created by NewM on 13-8-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDynamicViewController.h"
#import "DYBHttpMethod.h"
#import "JSONKit.h"
#import "JSON.h"
#import "status_list.h"
#import "status.h"
#import "DYBCellForDynamic.h"
#import "DYBCellForBanner.h"
#import "DYBDynamicDetailViewController.h"
#import "DYBCheckImageViewController.h"
#import "DYBMenuView.h"
#import "eclass.h"
#import "DYBUITabbarViewController.h"
#import "UIView+MagicCategory.h"
#import "DYBPublishViewController.h"
#import "DYBCheckMultiImageViewController.h"
#import "good_num_info.h"
#import "XiTongFaceCode.h"
#import "comment_num_info.h"
#import "DYBCellForNotice.h"
#import "chat.h"
#import "DYBNoticeDetailViewController.h"
#import "DYBSearchFriendsViewController.h"
#import "DYBRegisterStep2ViewController.h"
#import "DYBPersonalHomePageViewController.h"
#import "DYBWebViewController.h"
#import "NSObject+KVO.h"
#import "DYBActivityViewController.h"
#import "DYBGuideView.h"
#import "WOSPersonInfoViewController.h"
#import "WOSALLOrderViewController.h"

@interface DYBDynamicViewController ()
{
    BOOL needAutoReload;//是否需要自动刷新
}
@end

@implementation DYBDynamicViewController

DEF_SIGNAL(SWITCHDYBAMICBUTTON)
DEF_SIGNAL(MENUSELECT)
DEF_SIGNAL(CLOSEAD)
DEF_SIGNAL(DYNAMICDETAIL)
DEF_SIGNAL(DYNAMICDETAILCOMMENT)
DEF_SIGNAL(DYNAMICDETAILLIKE)
DEF_SIGNAL(DYNAMICDIMAGEETAIL)
DEF_SIGNAL(DYNAMICREFRESH)
DEF_SIGNAL(DELEFRESH)
DEF_SIGNAL(PUBLISHREFRESH)
DEF_SIGNAL(DYNAMICCOMMENT)
DEF_SIGNAL(CLICKEMOJI)
DEF_SIGNAL(CLICKSEND)
DEF_SIGNAL(REMOVEQUICK)
DEF_SIGNAL(PERSONALPAGE)
DEF_SIGNAL(OPENURL)
DEF_SIGNAL(REFRESHCELL)
DEF_SIGNAL(ACTIVITYPAGE)

DEF_SIGNAL(DYNCSCROLLLEFTVIEW)//滑动出左面视图
-(void)dealloc{
    RELEASEDICTARRAYOBJ(_arrayDynamic);
    RELEASEDICTARRAYOBJ(_arrayDynamicCell);
    RELEASEDICTARRAYOBJ(_arrTitleLable);
    RELEASEDICTARRAYOBJ(_arreClass);
    RELEASE(_strMaxID);
    if (bBanner) {
        RELEASE(_bnerList);
    }
    
    RELEASE(_tabMenu);

    [super dealloc];
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        
        if ([_arrTitleLable count] == 0) {
            
            if ([_strRequestType isEqualToString:@"0"]) {
                [self.headview setTitle:@"随便看看"];
            }else{
                [self.headview setTitle:@"易友动态"];
            }
            
            
            [self.headview setTitleArrow];
        }
        
        if (![SHARED.curUser.verify isEqualToString:@"0"]) {
            [self backImgType:5];
        }else{
            [self.rightButton setEnabled:NO];
        }

        MagicUIButton *_btnSwichDybamic = [[MagicUIButton alloc] initWithFrame:CGRectMake(80, 0, self.view.frame.size.width-160, 44)];
        [_btnSwichDybamic addSignal:[DYBDynamicViewController SWITCHDYBAMICBUTTON] forControlEvents:UIControlEventTouchUpInside];
        [self.headview addSubview:_btnSwichDybamic];
        [self.headview bringSubviewToFront:_btnSwichDybamic];
        RELEASE(_btnSwichDybamic);
        
        if (![[NSUserDefaults standardUserDefaults] stringForKey:@"DYBDynamicViewController_DYBGuideView"] || [[[NSUserDefaults standardUserDefaults] stringForKey:@"DYBDynamicViewController_DYBGuideView"] intValue]==0) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DYBDynamicViewController_DYBGuideView"];
            
            {
                DYBGuideView *guideV=[[DYBGuideView alloc]initWithFrame:self.view.frame];
                guideV.AddImgByName(@"DynamicQuick",@"DynamicTab",nil);
                [self.drNavigationController.view addSubview:guideV];
                RELEASE(guideV);
            }
        }
//        [self.leftButton addSignal:[DYBDynamicViewController DYNCSCROLLLEFTVIEW] forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([signal is:[MagicViewController CREATE_VIEWS]]){
        _tabDynamic = [[DYBUITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.frameHeight-self.headHeight) isNeedUpdate:YES];
        [_tabDynamic setTableViewType:DTableViewSlime];
        [_tabDynamic setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_tabDynamic];
        RELEASE(_tabDynamic);
//        _tabDynamic.v_footerVForHide=[[DYBUITabbarViewController sharedInstace] containerView].tabBar;

        nPage = 1;
        nPageSize = 10;
        nSelMenu = 0;
        _nCurCommentRow = -1;

        bPullDown = NO;
        bBanner = NO;
        bAddBanner = NO;
        bCloseAD = NO;
        bRequst = NO;
        
        if ([SHARED.curUser.verify isEqualToString:@"0"]) {
            _strRequestType = @"0";//随便看看
            
            [self.headview setTitle:@"随便看看"];
            nSelMenu = 1;
        }else{
            _strRequestType = @"2";//易友动态
        }
        
        _arrayDynamic = [[NSMutableArray alloc] init];
        _arrayDynamicCell = [[NSMutableArray alloc] init];
        _arreClass = [[NSMutableArray alloc] init];
        
        [self DYB_GetStatuslist:YES];
    }
}

#pragma mark- 只接受UITableView信号

static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        NSNumber *s = [NSNumber numberWithInteger:_arrayDynamic.count];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
   
        if (bBanner && !bAddBanner && indexPath.row == 0) {
            
            DYBCellForBanner *cell = [[[DYBCellForBanner alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[_arrayDynamic objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if ([SHARED.curUser.verify isEqualToString:@"0"]) {
                
                cell.userInteractionEnabled = NO;
            }
            
            if (![_arrayDynamicCell containsObject:cell]){
                [_arrayDynamicCell insertObject:cell atIndex:0];
            }
            bAddBanner = YES;
            
            
        }else{
            DLogInfo(@"indexPath.row == %d", indexPath.row);
            if (indexPath.row >= [_arrayDynamicCell count]) {
                
                DYBCellForDynamic *cell = [[[DYBCellForDynamic alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
                [cell setContent:[_arrayDynamic objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
                
                if ([SHARED.curUser.verify isEqualToString:@"0"]) {
                    
                    cell.userInteractionEnabled = NO;
                }
                
                if (![_arrayDynamicCell containsObject:cell]){
                    [_arrayDynamicCell addObject:cell];
                }
            }
        }
        
        
        NSNumber *s = [NSNumber numberWithInteger:((DYBCellForDynamic *)[_arrayDynamicCell objectAtIndex:indexPath.row]).frame.size.height];
        [signal setReturnValue:s];
        
    
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        [signal setReturnValue:nil];
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell=((UITableViewCell *)[_arrayDynamicCell objectAtIndex:indexPath.row]);
        if (!cell)
        {
            cell=((UITableViewCell *)[_arrayDynamicCell objectAtIndex:indexPath.row]);
        }
        
        
        for (UIView *view in [cell subviews]) {
            if (view.tag == 924) {
                [view setHidden:YES];
                break;
            }
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        WOSPersonInfoViewController *person = [[WOSPersonInfoViewController alloc]init];
        [self.drNavigationController pushViewController:person animated:YES];
        RELEASE(person);
        
//        
//        status *s = [_arrayDynamic objectAtIndex:indexPath.row];
//        
//        if (s.type == 8) {
//            chat *c  = [[chat alloc] init];
//            c.id = [NSString stringWithFormat:@"%d", s.id];
//            s.isnotice = @"1";
//            
//            [DYBShareinstaceDelegate handleSqlValue:[NSString stringWithFormat:@"%d", s.id] valueKye:@"isnotice" value:@"1"];
//            
//            DYBNoticeDetailViewController *vc = [[DYBNoticeDetailViewController alloc] init];
//            vc.str_noticeID=c.id;
//            [self.drNavigationController pushViewController:vc animated:YES];
//            RELEASE(vc);
//            RELEASE(c);
//      
//            NSIndexPath *indexPathCell = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//            DYBCellForDynamic *cell = [[[DYBCellForDynamic alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
//            [cell setContent:[_arrayDynamic objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
//            
//            [_arrayDynamicCell removeObjectAtIndex:indexPath.row];
//            [_arrayDynamicCell insertObject:cell atIndex:indexPath.row];
//
//            [_tabDynamic beginUpdates];
//            [_tabDynamic reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathCell,nil] withRowAnimation:UITableViewRowAnimationNone];
//            [_tabDynamic endUpdates];
//        }
//        
//
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        nPage = 1;
        MagicRequest *request = nil;
        
        [self sendViewSignal:[DYBDynamicViewController REMOVEQUICK]];
        [self cleanInterface];
        
        
        
        
        
        if ([_strRequestType intValue] > 2) {
            request = [DYBHttpMethod status_eclasslist:nil num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] eclassid:_strCurClassID isAlert:YES receive:self];
            [request setTag:-2];
        }else{
            if (!needAutoReload) {//第一次reload不需要cache
                needAutoReload = YES;
                request = [DYBHttpMethod noCacheSetstatus_list:nil max_id:_strMaxID last_id:@"0" num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] type:_strRequestType userid:SHARED.userId  isAlert:NO receive:self];
            }else
            {
                request = [DYBHttpMethod setstatus_list:nil max_id:_strMaxID last_id:@"0" num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] type:_strRequestType userid:SHARED.userId  isAlert:NO receive:self];
            }
            
            [request setTag:-2];
        }

        
        if (!request) {//无网路
            [_tabDynamic reloadData:NO];
        }

    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){ 
        nPage ++;
        MagicRequest *request = nil;
        
        
        NSString *strLastID = [NSString stringWithFormat:@"%d", ((status *)[_arrayDynamic lastObject]).id];
        
        
        if ([_strRequestType intValue] > 2) {
            request = [DYBHttpMethod status_eclasslist:strLastID num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] eclassid:_strCurClassID isAlert:NO receive:self];
            [request setTag:-3];
        }else{
            request = [DYBHttpMethod setstatus_list:nil max_id:@"0" last_id:strLastID num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] type:_strRequestType userid:SHARED.userId isAlert:NO receive:self];
            [request setTag:-3];
        }
        
        if (!request) {//无网路
            [_tabDynamic reloadData:NO];
        }
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
        [_tabDynamic StretchingUpOrDown:0];
        [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];

    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [_tabDynamic StretchingUpOrDown:1];
        [[DYBUITabbarViewController sharedInstace] hideTabBar:NO animated:YES];

    }

}

- (void)handleViewSignal_DYBDynamicViewController:(MagicViewSignal *)signal
{
    if (bRequst) {
        return;
    }
    
    if ([signal is:[DYBDynamicViewController SWITCHDYBAMICBUTTON]]){
        if (_txtViewComment && CGRectGetMaxY(_txtViewComment.frame) < CGRectGetHeight(self.view.frame) ) {
            return;
        }
        
        if (_tabMenu) {
            REMOVEFROMSUPERVIEW(_tabMenu);
        }
        
        user *curUser = SHARED.curUser;
        _arrTitleLable = [[NSMutableArray alloc] initWithObjects:@"易友动态", @"随便看看", nil];
        
        for (eclass *eclass in curUser.eclasses) {
            if (eclass && [eclass.name length] != 0) {
                [_arrTitleLable insertObject:eclass.name atIndex:[_arrTitleLable count]];
                [_arreClass addObject:eclass];
            }
        }
        
        _tabMenu = [[DYBMenuView alloc]initWithData:_arrTitleLable selectRow:nSelMenu];
        [_tabMenu setHidden:YES];
        [self.view addSubview:_tabMenu];
        RELEASE(_tabMenu);
        
        if (bPullDown) {
            [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:self from:self target:_tabMenu];
            [_tabDynamic setUserInteractionEnabled:YES];
            
        }else{
            [self sendViewSignal:[DYBMenuView MENUDOWN] withObject:self from:self target:_tabMenu];
            [_tabDynamic setUserInteractionEnabled:NO];
        }
        
        bPullDown = !bPullDown;
        
    }else if ([signal is:[DYBDynamicViewController MENUSELECT]]){
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSNumber *nSection = [dict objectForKey:@"section"];
        
        DLogInfo(@"%d", [nSection intValue]);
        [self RefreshDynamicList:[nSection intValue]];
        [self.headview setTitleArrow];
        
        if ([nSection intValue] == 0) {
            _strRequestType = @"2";
        }else if ([nSection intValue] == 1){
            _strRequestType = @"0";
        }else{
            _strRequestType = @"3";
        }
        
        nSelMenu = [nSection intValue];
        
    }else if ([signal is:[DYBDynamicViewController CLOSEAD]]){
        [_arrayDynamic removeObjectAtIndex:0];
        [_arrayDynamicCell removeObjectAtIndex:0];
        
        [_tabDynamic beginUpdates];
        [_tabDynamic deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [_tabDynamic endUpdates];
        
        bBanner = NO;
        bCloseAD = YES;
        
        if ([_arrayDynamicCell count] > 0) {
            [_arrayDynamicCell removeAllObjects];
        }
        [_tabDynamic reloadData];
        
    }else if ([signal is:[DYBDynamicViewController DYNAMICDETAIL]]){
        [self cleanInterface];
        status *_status = (status *)[signal object];

        DYBDynamicDetailViewController *vc = [[DYBDynamicDetailViewController alloc] init:_status withStatus:1 bScroll:NO];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if([signal is:[DYBDynamicViewController DYNAMICDIMAGEETAIL]]){

        NSDictionary *dic = (NSDictionary *)[signal object];
        
        status *_status = (status *)[dic objectForKey:@"status"];
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
        
        DYBCheckMultiImageViewController *vc = [[DYBCheckMultiImageViewController alloc] initWithMultiImage:_arrPic nCurSel:[[dic objectForKey:@"tag"] intValue]];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
        RELEASEDICTARRAYOBJ(_arrPic);
        
    }else if ([signal is:[DYBDynamicViewController DYNAMICDETAILCOMMENT]]){
        [self cleanInterface];
        status *_status = (status *)[signal object];
        
        DYBDynamicDetailViewController *vc = [[DYBDynamicDetailViewController alloc] init:_status withStatus:1 bScroll:YES];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBDynamicViewController DYNAMICDETAILLIKE]]){
        [self cleanInterface];
        status *_status = (status *)[signal object];
        
        DYBDynamicDetailViewController *vc = [[DYBDynamicDetailViewController alloc] init:_status withStatus:2 bScroll:YES];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBDynamicViewController DYNAMICREFRESH]]){
        [self cleanInterface];
        
        NSInteger nIndexRow  = (NSInteger)[signal object];   
        
        status *_Status = [_arrayDynamic objectAtIndex:nIndexRow];
        good_num_info* gInfo = [[good_num_info alloc] init];
        [gInfo setName:SHARED.curUser.name];
        [gInfo setUserid:SHARED.curUser.userid];
        [gInfo setTime:[self getCurrentTime]];
        _Status.isrec = @"1";
        
        [DYBShareinstaceDelegate handleSqlValue:[NSString stringWithFormat:@"%d", _Status.id] valueKye:@"isrec" value:@"1"];
        
        NSMutableArray *arrgInfo = nil;   
        NSMutableArray *sqlGoodInfo = [[NSMutableArray alloc] initWithCapacity:1];
        
        if ([_Status.good_num_info count] > 0) {
            arrgInfo = [[NSMutableArray alloc] initWithArray:_Status.good_num_info];
            [arrgInfo insertObject:gInfo atIndex:0];
        }else{
            arrgInfo = [[NSMutableArray alloc] initWithObjects:gInfo, nil];
        }
        
        for (int i = 0; i < [arrgInfo count]; i++)
        {
            good_num_info *gInfo = [arrgInfo objectAtIndex:i];
            NSDictionary *gInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:gInfo.userid, @"userid", gInfo.time, @"time", gInfo.name, @"name", nil];
            [sqlGoodInfo addObject:gInfoDict];
        }
        
        _Status.good_num_info = [[NSArray alloc] initWithArray:(NSArray *)arrgInfo];
        _Status.good_num = [NSString stringWithFormat:@"%d", [_Status.good_num intValue]+1];
        
        NSString *statuID = [NSString stringWithFormat:@"%d", _Status.id];
        [DYBShareinstaceDelegate handleSqlValue:statuID valueKye:@"good_num" value:_Status.good_num];
        [DYBShareinstaceDelegate handleSqlValue:statuID valueKye:@"good_num_info" value:sqlGoodInfo];
        RELEASEDICTARRAYOBJ(sqlGoodInfo);
        

        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:nIndexRow inSection:0];
        DYBCellForDynamic *cell = [[[DYBCellForDynamic alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
        [cell setContent:_Status indexPath:indexPath tbv:_tabDynamic];
        [_arrayDynamicCell removeObjectAtIndex:nIndexRow];
        [_arrayDynamicCell insertObject:cell atIndex:nIndexRow];
        
        
        [_tabDynamic beginUpdates];   
        [_tabDynamic reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [_tabDynamic endUpdates]; 
        
        RELEASE(gInfo);
        RELEASEDICTARRAYOBJ(arrgInfo);
        RELEASE(_Status.good_num_info);
    }else if ([signal is:[DYBDynamicViewController DELEFRESH]]){
        int nStatusID = (int)[signal object];
        int i = 0;
  
        for (status *s in _arrayDynamic) {
            if ([s isKindOfClass:[status class]]) {
                if (s.id == nStatusID) {
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    [_arrayDynamic removeObjectAtIndex:i];
                    [_arrayDynamicCell removeObjectAtIndex:i];
                    
                    [_tabDynamic beginUpdates];
                    [_tabDynamic deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    [_tabDynamic endUpdates];
                    break;
                }
            }
        i++;
        }
    }else if ([signal is:[DYBDynamicViewController PUBLISHREFRESH]]){
        nPage = 1;
        MagicRequest *request = nil;
        
        
        
        if ([_strRequestType intValue] > 2) {
            request = [DYBHttpMethod status_eclasslist:nil num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] eclassid:_strCurClassID isAlert:YES receive:self];
            [request setTag:-2];
        }else{
            request = [DYBHttpMethod setstatus_list:nil max_id:_strMaxID last_id:@"0" num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] type:_strRequestType userid:SHARED.userId  isAlert:YES receive:self];
            [request setTag:-2];
        }

    }else if ([signal is:[DYBDynamicViewController DYNAMICCOMMENT]]){
        MagicUIButton *btn = (MagicUIButton *)signal.source;
        _nCurCommentRow = -1;
        _nCurCommentRow = (int)[signal object];
        
        if (btn.selected == NO) {
            [self initInput];
        }else{
            [self cleanInterface];
        }
        
        btn.selected = !btn.selected;
    
    }else if ([signal is:[DYBDynamicViewController CLICKSEND]]){
        NSString *strComment = [self convertSystemEmoji:_txtViewComment.text];
        strComment = [strComment stringByReplacingOccurrencesOfString: @"\r" withString:@""];
        strComment = [strComment stringByReplacingOccurrencesOfString: @"\n" withString:@""];
        strComment = [strComment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self hiddenInterface];
        [self sendViewSignal:[DYBDynamicViewController REMOVEQUICK]];
        
        if ([strComment length] > 140) {
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"超过140字数限制！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",3]];
            return;
        }
        
        if (_nCurCommentRow >= 0 && _nCurCommentRow < [_arrayDynamic count]) {
            status *_Status = (status *)[_arrayDynamic objectAtIndex:_nCurCommentRow];
            
            MagicRequest *request = [DYBHttpMethod status_addcomment_id:[NSString stringWithFormat:@"%d", _Status.id] content:strComment isAlert:YES receive:self];
            request.tag = -7;
        }else{
            [self showInterface];
        }
    }else if ([signal is:[DYBDynamicViewController CLICKEMOJI]]){
        
        [_tabDynamic StretchingUpOrDown:0];
        [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];
        
        MagicUIButton *_btnSelEmoji = (MagicUIButton *)signal.source;
        
        if (!_viewFace) {
            _viewFace = [[DYBFaceView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), 320, 200)];
            _viewFace.delegate = self;
            [self.view addSubview:_viewFace];
            RELEASE(_viewFace);
        }
        
        if (_btnSelEmoji.selected == NO) {
            [self hideKeyBoard];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.25f];
            [_viewFace setFrame:CGRectMake(0, self.view.frame.size.height-215, 320, 200)];
            [UIView commitAnimations];
            [self.view bringSubviewToFront:_viewFace];
        }
        
        [_viewCommentBKG setFrame:CGRectMake(0, _viewFace.frame.origin.y-CGRectGetHeight(_viewCommentBKG.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(_viewCommentBKG.frame))];
        [_txtViewComment setFrame:CGRectMake(CGRectGetMinX(_txtViewComment.frame), _viewFace.frame.origin.y-CGRectGetHeight(_viewCommentBKG.frame)+7, CGRectGetWidth(_txtViewComment.frame), CGRectGetHeight(_txtViewComment.frame))];
        
        _btnSelEmoji.selected = !_btnSelEmoji.selected;
    }else if ([signal is:[DYBDynamicViewController REMOVEQUICK]]){
        NSDictionary *dic = (NSDictionary *)[signal object];
        
        if (_viewQuick) {
            REMOVEFROMSUPERVIEW(_viewQuick);
        }
        
        _viewQuick = (MagicUIImageView *)[dic objectForKey:@"quick"];
        
        if(_btnQuick && _btnQuick.selected == YES && _btnQuick != (MagicUIButton *)[dic objectForKey:@"button"]){
            CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI*2);
            
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.3f];
            [_btnQuick setTransform:rotate];
            [UIView commitAnimations];
            
            _btnQuick.selected = NO;
        }

        _btnQuick = (MagicUIButton *)[dic objectForKey:@"button"];
    }else if ([signal is:[DYBDynamicViewController PERSONALPAGE]]){
        NSDictionary *dic = (NSDictionary *)[signal object];
        
        DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
        vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"username"], @"name", [dic objectForKey:@"userid"], @"userid", nil];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBDynamicViewController OPENURL]]){
        NSString *streURL  = (NSString *)[signal object];
        
        DYBWebViewController *vc = [[DYBWebViewController alloc] init:streURL];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBDynamicViewController REFRESHCELL]]){
        status *_Status = (status *)[signal object];
        int i = 0;
        
        for (status *s in _arrayDynamic) {
            if ([s isKindOfClass:[status class]]) {
                if (s.id == _Status.id) {
                    s = _Status;
                    
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    
                    DYBCellForDynamic *cell = [[[DYBCellForDynamic alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
                    [cell setContent:_Status indexPath:indexPath tbv:_tabDynamic];
                    
                    [_arrayDynamicCell removeObjectAtIndex:indexPath.row];
                    [_arrayDynamicCell insertObject:cell atIndex:indexPath.row];
                         
                    [_tabDynamic beginUpdates];
                    [_tabDynamic reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    [_tabDynamic endUpdates];
                    break;
                }
            }
            i++;
        }
    }else if ([signal is:[DYBDynamicViewController ACTIVITYPAGE]]){
        NSString *strActivityID  = (NSString *)[signal object];
        bRequst = YES;
        
        MagicRequest *request = [DYBHttpMethod active_detail:strActivityID isAlert:YES receive:self];
        [request setTag:-10];
    }
}

-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        DLogInfo(@"DEL");
        
        NSDictionary *dicType = (NSDictionary *)[signal object];
        NSString *strType = [dicType objectForKey:@"type"];
        int row = [[dicType objectForKey:@"rowNum"] intValue];
        
        if ([strType intValue] == BTNTAG_SINGLE) {
            if (row == 3) {
                [self showInterface];
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
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
//        DYBPublishViewController *vc = [[DYBPublishViewController alloc] init:nil activeid:nil bActive:NO];
//        [self.drNavigationController pushViewController:vc animated:YES];
//        RELEASE(vc);

        
//        WOSPersonInfoViewController *person = [[WOSPersonInfoViewController alloc]init];
//        [self.drNavigationController pushViewController:person animated:YES];
//        RELEASE(person);
        
        WOSALLOrderViewController *allOrder = [[WOSALLOrderViewController alloc]init];
        [self.drNavigationController pushViewController:allOrder animated:YES];
        RELEASE(allOrder);
        
    }
    
}

#pragma mark- 切换动态列表内容
-(void)RefreshDynamicList:(NSInteger)nIndex{
    nPage = 1;
    
    if (nIndex == 0) {
        _strRequestType = @"2";
    }else if (nIndex == 1){
        _strRequestType = @"0";
    }
    
    
    if (nIndex < 2) {
        [self DYB_GetStatuslist:YES];
    }else{
        if (nIndex-2 >= 0 && nIndex-2 < [_arreClass count]) {
            eclass *eclass = [_arreClass objectAtIndex:nIndex-2];
            _strCurClassID = eclass.id;
            [self DYB_GetClassStatuslis:_strCurClassID];
        }
    
    }
    
    [self.headview setTitle:[_arrTitleLable objectAtIndex:nIndex]];
    [self sendViewSignal:[DYBDynamicViewController SWITCHDYBAMICBUTTON]];
}

#pragma mark- 班级动态列表消息
-(void)DYB_GetClassStatuslis:(NSString *)eclassid{
    MagicRequest *request = [DYBHttpMethod status_eclasslist:nil num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] eclassid:eclassid isAlert:YES receive:self];
    [request setTag:-1];
}

#pragma mark- 动态消息请求
- (void)DYB_GetStatuslist:(BOOL)isAlert{
    MagicRequest *request = [DYBHttpMethod setstatus_list:nil max_id:nil last_id:@"0" num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] type:_strRequestType userid:SHARED.userId isAlert:isAlert receive:self];
    DLogInfo(@"%@",SHARED.curUser.userid);
    [request setTag:-1];
}

#pragma mark- 广告条消息请求
- (void)DYB_GetBannerlist{
    MagicRequest *request = [DYBHttpMethod yiban_source_banner_pageid:@"0" isAlert:NO receive:self];
    [request setTag:-4];
}

#pragma mark- 消息返回处理
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{
    
    [self.view setUserInteractionEnabled:YES];
    
    if ([request succeed]){
        if (request.tag == -1){/*初始化*/ 
            JsonResponse *respose =(JsonResponse *)receiveObj;

            if (respose.response == khttpsucceedCode){
                status_list *Slist = [status_list JSONReflection:respose.data];
                
                if ([_arrayDynamic count] > 0) {
                    [_arrayDynamic removeAllObjects];
                    [_arrayDynamicCell removeAllObjects];
                    
                    bAddBanner = NO;
                    bBanner = NO;
                }
                
                
                for (status *_status in Slist.status) {
                    DLogInfo(@"status.content ==== %@", _status.content);
                    [_arrayDynamic addObject:(status *)_status];
                }
                
                if ([_arrayDynamic count] > 0) {
                    _strMaxID = [NSString stringWithFormat:@"%d", ((status *)[_arrayDynamic objectAtIndex:0]).id];
                    [_strMaxID retain];
                    
                    if (!bCloseAD && _bnerList) {
                        [_arrayDynamic insertObject:_bnerList atIndex:0];
                        
                        if ([_bnerList.banner count] > 0) {
                            bBanner = YES;
                        }
                    }
                }
                
                if (_viewWarning) {
                    REMOVEFROMSUPERVIEW(_viewWarning);
                }
                
                if (Slist.havenext == 1) {
                    [_tabDynamic reloadData:NO];
                }else{
                    [_tabDynamic reloadData:YES];
                }
                
                
                if ([_arrayDynamic count] > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [_tabDynamic scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    
                    if (!bCloseAD && !_bnerList) {
                        [self DYB_GetBannerlist];
                    }
                }else{
                    [self addGuidePage];
                }
                
            }
            if (SHARED.isLoginMethod) {
                SHARED.isLoginMethod = NO;
            }else
            {
                [_tabDynamic launchRefreshing];//第一次做刷新功能不是登陆的方法或者校园验证跳过
            }
        
        }else if (request.tag == -2){/*刷新*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode) {
                status_list *Slist = [status_list JSONReflection:respose.data];

//                if ([Slist.new_count intValue] == 0) {
//                    [_tabDynamic reloadData:YES];
//                    return;
//                }
                
                if ([_arrayDynamic count] > 0) {
                    [_arrayDynamic removeAllObjects];
                    [_arrayDynamicCell removeAllObjects];
                }
                
                for (status *_status in Slist.status) {
                    DLogInfo(@"status.content ==== %@", _status.content);
                    
                    if (!_arrayDynamic) {
                        _arrayDynamic = [NSMutableArray arrayWithObject:_status];
                    }
                    else{
                        DLogInfo(@"status.content ==== %@", _status.content);
                        DLogInfo(@"status.content ==== %d", _status.id);
                        [_arrayDynamic addObject:(status *)_status];
                    }
                }
                
                if ([_arrayDynamic count] > 0) {
                    if(bBanner){
                        RELEASEOBJ(_strMaxID);
                        [_arrayDynamic insertObject:_bnerList atIndex:0];
                        _strMaxID = [NSString stringWithFormat:@"%d", ((status *)[_arrayDynamic objectAtIndex:1]).id];
                        [_strMaxID retain];
                    }else{
                        RELEASEOBJ(_strMaxID);
                        _strMaxID = [NSString stringWithFormat:@"%d", ((status *)[_arrayDynamic objectAtIndex:0]).id];
                        [_strMaxID retain];
                    }
                }
                
                bAddBanner = NO;
                
                if (_viewWarning) {
                    REMOVEFROMSUPERVIEW(_viewWarning);
                }
                
                if (Slist.havenext == 1) {
                    [_tabDynamic reloadData:NO];
                }else{
                    [_tabDynamic reloadData:YES];
                }
                
                if ([_arrayDynamic count] == 0) {
                    [self addGuidePage];
                }
                
            }
            
        }else if (request.tag == -3){/*加载更多*/ 
            JsonResponse *respose =(JsonResponse *)receiveObj;
            status_list *Slist = [status_list JSONReflection:respose.data];
            if (respose.response == khttpsucceedCode) {
//                status_list *Slist = [status_list JSONReflection:respose.data];         
                
                for (status *_status in Slist.status) {
                    DLogInfo(@"status.content ==== %@", _status.content);
                    
                    if ([_arrayDynamic count] > DynamicLimitNum) {
                        if ([_arrayDynamic containsObject:_status]) {
                            if(bBanner)
                                [_arrayDynamic removeObjectAtIndex:1];
                            else
                                [_arrayDynamic removeObjectAtIndex:0];
                        }
                    }
                    
                    [_arrayDynamic addObject:(status *)_status];
                }
                
                
                
            }
            if (Slist.havenext == 1 || !Slist) {
                [_tabDynamic reloadData:NO];
            }else if (Slist.havenext == 0){
                [_tabDynamic reloadData:YES];
            }

        }else if (request.tag == -4){/*广告条*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            if (respose.response == khttpsucceedCode) {             
                _bnerList = [bannerList JSONReflection:respose.data];
                
                if ([_bnerList.banner count] > 0) {
                    bBanner = YES;
                    
                    [_arrayDynamic insertObject:(bannerList *)[_bnerList retain] atIndex:0];
//
                    
                    if ([_arrayDynamicCell count] > 0) {
                        [_arrayDynamicCell removeAllObjects];
                    }
                    
                    if ([_bnerList.banner count] > 0) {
                        [_tabDynamic reloadData:NO];
                    }else{
                        [_tabDynamic reloadData:YES];
                    }
                }else{
                    _bnerList = nil;
                }
            }
        }else if (request.tag == -7)/*列表评论*/{
            JsonResponse *respose =(JsonResponse *)receiveObj;
            if (respose.response == khttpsucceedCode){
                status *_Status = [_arrayDynamic objectAtIndex:_nCurCommentRow];
                NSString *strConvert = [self convertSystemEmoji:_txtViewComment.text];
                
                [self showInterface];
                [self cleanInterface];
                
                comment_num_info* cInfo = [[comment_num_info alloc] init];
                [cInfo setName:SHARED.curUser.name];
                [cInfo setPic:SHARED.curUser.pic];
                [cInfo setComment:strConvert];
                
                NSMutableArray *arrgInfo = nil;
                NSMutableArray *sqlcommentInfo = [[NSMutableArray alloc] initWithCapacity:1];
                
                if ([_Status.comment_num_info count] > 0) {
                    arrgInfo = [[NSMutableArray alloc] initWithArray:_Status.comment_num_info];
                    [arrgInfo insertObject:cInfo atIndex:0];
                }else{
                    arrgInfo = [[NSMutableArray alloc] initWithObjects:cInfo, nil];
                }
                
                for (int i = 0; i < [arrgInfo count]; i++)
                {
                    comment_num_info *cInfo = [arrgInfo objectAtIndex:i];
                    NSDictionary *gInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:cInfo.comment, @"comment", cInfo.pic, @"pic", cInfo.name, @"name", @"0", @"kind", @"", @"dateline", @"", @"target",  _Status.content, @"tocontent", _Status.username, @"tousername", [NSString stringWithFormat:@"%d", _Status.id], @"touid", @"", @"totid", SHARED.curUser.userid, @"id", nil];
                    [sqlcommentInfo addObject:gInfoDict];
                }
                
                _Status.comment_num_info = [[NSArray alloc] initWithArray:(NSArray *)arrgInfo];
                _Status.comment_num = [NSString stringWithFormat:@"%d", [_Status.comment_num intValue]+1];
                
                NSString *statuID = [NSString stringWithFormat:@"%d", _Status.id];
                [DYBShareinstaceDelegate handleSqlValue:statuID valueKye:@"comment_num" value:_Status.comment_num];
                [DYBShareinstaceDelegate handleSqlValue:statuID valueKye:@"comment_num_info" value:sqlcommentInfo];
                RELEASEDICTARRAYOBJ(sqlcommentInfo);
                
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_nCurCommentRow inSection:0];
                DYBCellForDynamic *cell = [[[DYBCellForDynamic alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
                [cell setContent:_Status indexPath:indexPath tbv:_tabDynamic];
                [_arrayDynamicCell removeObjectAtIndex:_nCurCommentRow];
                [_arrayDynamicCell insertObject:cell atIndex:_nCurCommentRow];
                
                
                [_tabDynamic beginUpdates];
                [_tabDynamic reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [_tabDynamic endUpdates]; 
                
                RELEASE(cInfo);
                RELEASEDICTARRAYOBJ(arrgInfo);
                RELEASE(_Status.comment_num_info);
                [self cleanInterface];
            }
        }else if (request.tag == -10)/*活动页面*/{
            bRequst = NO;
            JsonResponse *respose =(JsonResponse *)receiveObj;
            if (respose.response == khttpsucceedCode){
                active *ac = [active JSONReflection:[[respose data] objectForKey:@"active"]];
                
                DYBActivityViewController *vc = [[DYBActivityViewController alloc] init:ac];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
            }else if (respose.response == khttpWrongfulCode){
                [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"该活动不存在。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
            }


        }
        
    }else if ([request failed]){
        [self.view setUserInteractionEnabled:YES];
        [_tabDynamic reloadData:NO];
        
        if (request.tag == -7){
            [self showInterface];
            [self cleanInterface];
            
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"评论失败，请稍后再试。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
        }else if (request.tag == -10)/*活动页面*/{
            bRequst = NO;
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"该活动不存在。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
        }
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
     UITouch *touch =  [touches anyObject];
     CGPoint originalLocation = [touch locationInView:self.view];
    
    if (originalLocation.y > _tabMenu.frame.size.height) {
        [self sendViewSignal:[DYBDynamicViewController SWITCHDYBAMICBUTTON]];
    }
    
}

#pragma mark- 初始化输入面板
-(void)initInput{
    if (!_viewCommentBKG) {
        _viewCommentBKG = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 50)];
        [_viewCommentBKG setBackgroundColor:[UIColor whiteColor]];
        [_viewCommentBKG setAlpha:0.9];
        [self.view addSubview:_viewCommentBKG];
        RELEASE(_viewCommentBKG);
        
        UIImage *imgShadow  = [UIImage imageNamed:@"txtbox_shadow.png"];
        MagicUIImageView *shadowLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, -3, CGRectGetWidth(self.view.frame), 3)];
        [shadowLine setBackgroundColor:[UIColor clearColor]];
        [shadowLine setImage:imgShadow];
        [_viewCommentBKG addSubview:shadowLine];
        RELEASE(shadowLine);
        
        _txtViewComment = [[MagicUITextView alloc] initWithFrame:CGRectMake(50, CGRectGetHeight(self.view.frame)+7, 220, 36)];
        [_txtViewComment setBackgroundColor:[UIColor whiteColor]];
        _txtViewComment.layer.masksToBounds=YES;
        _txtViewComment.layer.cornerRadius=3;
        _txtViewComment.layer.borderWidth=1;
        _txtViewComment.layer.borderColor=ColorCellSepL.CGColor;
        [_txtViewComment setReturnKeyType:UIReturnKeyDone];
        [_txtViewComment setTextColor:ColorBlack];
        [_txtViewComment setFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
        [_txtViewComment setPlaceHolder:@"评论"];
        [_txtViewComment setPlaceHolderColor:ColorTextCount];
        [self.view addSubview:_txtViewComment];
        RELEASE(_txtViewComment);
        
        _nRowCount = 1;
        
        UIImage *imgEmoji = [UIImage imageNamed:@"comment_face_def.png"];
        MagicUIButton *btnEmoji = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0, imgEmoji.size.width/2, imgEmoji.size.height/2)];
        [btnEmoji setTag:914];
        [btnEmoji setBackgroundColor:[UIColor clearColor]];
        [btnEmoji setBackgroundImage:imgEmoji forState:UIControlStateNormal];
        [btnEmoji addSignal:[DYBDynamicViewController CLICKEMOJI] forControlEvents:UIControlEventTouchUpInside];
        [_viewCommentBKG addSubview:btnEmoji];
        [btnEmoji setSelected:NO];
        RELEASE(btnEmoji);
        
        UIImage *imgSend = [UIImage imageNamed:@"btn_quick_send.png"];
        UIImage *imgSendDis = [UIImage imageNamed:@"btn_quick_send_dis.png"];
        MagicUIButton *btnSend = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_txtViewComment.frame), 0, imgSend.size.width/2, imgSend.size.height/2)];
        [btnSend setBackgroundColor:[UIColor clearColor]];
        [btnSend setTag:916];
        [btnSend setBackgroundImage:imgSend forState:UIControlStateNormal];
        [btnSend setBackgroundImage:imgSendDis forState:UIControlStateDisabled];
        [btnSend addSignal:[DYBDynamicViewController CLICKSEND] forControlEvents:UIControlEventTouchUpInside];
        [_viewCommentBKG addSubview:btnSend];
        [btnSend setSelected:NO];
        RELEASE(btnSend);
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        }
    }else{
        [_txtViewComment setText:@""];
        _nCurCommentRow = -1;
    }
    
    [_txtViewComment becomeFirstResponder];
    [_txtViewComment sendViewSignal:[MagicUITextView TEXTVIEWDIDCHANGE]];
}

-(void)keyboardWillChangeFrame:(NSNotification*)notif{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
    NSValue *keyboardBoundsValue = [[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
#else
    NSValue *keyboardBoundsValue = [[notif userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
#endif
    CGRect keyboardEndRect = [keyboardBoundsValue CGRectValue];
    
    DLogInfo(@"%f", keyboardEndRect.origin.y);
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3f];
    [_viewCommentBKG setFrame:CGRectMake(0, keyboardEndRect.origin.y-CGRectGetHeight(_viewCommentBKG.frame)-20, CGRectGetWidth(self.view.frame), CGRectGetHeight(_viewCommentBKG.frame))];
    [UIView commitAnimations];
    
    [_txtViewComment setFrame:CGRectMake(CGRectGetMinX(_txtViewComment.frame), keyboardEndRect.origin.y-CGRectGetHeight(_viewCommentBKG.frame)-13, CGRectGetWidth(_txtViewComment.frame), CGRectGetHeight(_txtViewComment.frame))];
    
    if (keyboardEndRect.origin.y <  self.view.frame.size.height) {
        MagicUIButton *btnE = (MagicUIButton *)[_viewCommentBKG viewWithTag:914];
        btnE.selected = NO;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.25f];
        [_viewFace setFrame:CGRectMake(0, self.view.frame.size.height, 320, 200)];
        [UIView commitAnimations];
    }
}

#pragma mark- 只接受UITextView信号
- (void)handleViewSignal_MagicUITextView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITextView TEXTVIEWSHOULDBEGINEDITING]])/*textViewShouldBeginEditing*/{
        
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDBEGINEDITING]])/*textViewDidBeginEditing*/{
        
    }else  if ([signal is:[MagicUITextView TEXT_OVERFLOW]])/*文字超长*/{
        
    }else  if ([signal is:[MagicUITextView TEXTVIEW]])/*shouldChangeTextInRange*/{
        NSMutableDictionary *muD = (NSMutableDictionary *)[signal object];
        NSString *emString=[muD objectForKey:@"text"];
        if ([emString isEqualToString:@"\n"]) {
            [signal returnNO];
            [self cleanInterface];
            [self sendViewSignal:[DYBDynamicViewController REMOVEQUICK]];
        }
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDCHANGE]])/*textViewDidChange*/{
        DLogInfo(@"change");
        
        MagicUITextView *textView= signal.source;
        
        CGSize size = [[textView text] sizeWithFont:[textView font]];
        
        MagicUIButton *btnS = (MagicUIButton *)[_viewCommentBKG viewWithTag:916];
        
        NSString *_strContent = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([_strContent length] == 0) {
            btnS.enabled = NO;
        }else{
            btnS.enabled = YES;
        }
        
        // 2. 取出文字的高度
        int length = size.height;
        
        //3. 计算行数
        int colomNumber = textView.contentSize.height/length;
        
        if (colomNumber >1 && _nRowCount != colomNumber && _nRowCount <= 2) {//最多高度扩展3行
        
            int nAdd = 0;
            
            if (_nRowCount < colomNumber) {
                nAdd = -length;
            }else{
                nAdd = length;
            }
            
            float nPlus = 0;
            
            float fheighTxt = CGRectGetHeight(_txtViewComment.frame)-nAdd;
            if (fheighTxt < 36) {
                fheighTxt = 36;
                nPlus = 36 - CGRectGetHeight(_txtViewComment.frame) + nAdd;
            }else if (fheighTxt > 84){
                return;
            }
            
            float fheighBKG = CGRectGetHeight(_viewCommentBKG.frame)-nAdd;
            if (fheighBKG < 50) {
                fheighBKG = 50;
            }
            
            
            [UIView beginAnimations:@"" context:nil];
            [UIView setAnimationDuration:0.3f];
            
            [_txtViewComment setFrame:CGRectMake(CGRectGetMinX(_txtViewComment.frame), CGRectGetMinY(_txtViewComment.frame)+nAdd-nPlus,  CGRectGetWidth(_txtViewComment.frame), fheighTxt)];
            [_viewCommentBKG setFrame:CGRectMake(CGRectGetMinX(_viewCommentBKG.frame), CGRectGetMinY(_viewCommentBKG.frame)+nAdd-nPlus, CGRectGetWidth(_viewCommentBKG.frame), fheighBKG)];
            
            [UIView commitAnimations];
            
            MagicUIButton *btnE = (MagicUIButton *)[_viewCommentBKG viewWithTag:914];
            MagicUIButton *btnA = (MagicUIButton *)[_viewCommentBKG viewWithTag:915];
            MagicUIButton *btnS = (MagicUIButton *)[_viewCommentBKG viewWithTag:916];
            
            [btnE setFrame:CGRectMake(CGRectGetMinX(btnE.frame), CGRectGetHeight(_viewCommentBKG.frame)-CGRectGetHeight(btnE.frame), CGRectGetWidth(btnE.frame), CGRectGetHeight(btnE.frame))];
            [btnA setFrame:CGRectMake(CGRectGetMinX(btnA.frame), CGRectGetHeight(_viewCommentBKG.frame)-CGRectGetHeight(btnA.frame), CGRectGetWidth(btnA.frame), CGRectGetHeight(btnA.frame))];
            [btnS setFrame:CGRectMake(CGRectGetMinX(btnS.frame), CGRectGetHeight(_viewCommentBKG.frame)-CGRectGetHeight(btnS.frame), CGRectGetWidth(btnS.frame), CGRectGetHeight(btnS.frame))];
            
        }
        
        _nRowCount = colomNumber;
        
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDCHANGESELECTION]])/*textViewDidChangeSelection*/{
        
    }else  if ([signal is:[MagicUITextView TEXTVIEWSHOULDENDEDITING]])/*textViewShouldEndEditing*/{
        
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDENDEDITING]])/*textViewDidEndEditing*/{
    }
}

#pragma mark - 表情功能
-(void)selectFace:(id)sender{
    UIButton *tempbtn = (UIButton *)sender;
    NSMutableDictionary *tempdic = [_viewFace.faces objectAtIndex:tempbtn.tag];
    NSArray *temparray = [tempdic allKeys];
    NSString *faceStr= [NSString stringWithFormat:@"%@",[temparray objectAtIndex:0]];
    NSArray *arrayTemp = [faceStr componentsSeparatedByString:@"/"];
    NSString *tempStr = [[[arrayTemp objectAtIndex:1] componentsSeparatedByString:@"]"] objectAtIndex:0];
    NSString *last = [[self getFaceCode] objectForKey:tempStr];
    
    NSString *beforeString = [self beforeString:_txtViewComment subString:last];
    _txtViewComment.text = [self subStringOperat:_txtViewComment subString:last beforeString:beforeString] ;
    
    //光标位置
    NSRange range = [_txtViewComment.text rangeOfString:beforeString];
    NSRange ragne1 = NSMakeRange(range.location+beforeString.length, 0);
    _txtViewComment.selectedRange = ragne1;
    
    [_txtViewComment sendViewSignal:[MagicUITextView TEXTVIEWDIDCHANGE]];
}

//操作字符串
-(NSString* )subStringOperat:(UITextView *)textView subString:(NSString*)string beforeString:(NSString *)beforeString{
    int location = textView.selectedRange.location;
    
    NSString *afterSacn = [textView.text substringFromIndex:location];
    if (afterSacn.length > 0) {
        afterSacn = [beforeString stringByAppendingString:afterSacn];
    }else{
        afterSacn = beforeString;
    }
    
    return afterSacn;
}

-(void)face_end{
    //    bONface = NO;
    [_viewFace setFrame:CGRectMake(0, 600, 320, 200)];
}

-(NSDictionary*)getFaceCode{
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"]];
    return dic ;
}

-(NSString* )beforeString:(UITextView* )textView subString :(NSString *)string{
    int location = textView.selectedRange.location;
    
    NSString*  beforeString = [textView.text substringToIndex:location];
    if (beforeString.length > 0) {
        beforeString = [beforeString stringByAppendingString:string];
    }else{
        beforeString = string;
    }
    
    return beforeString;
}


-(BOOL)checkIncludeString_string:(NSString*)str include_str:(NSString*)include_str{
    NSRange range = [str rangeOfString:include_str];
    if (range.length > 0) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 发送表情内容转化
-(NSString *)convertSystemEmoji:(NSString *)orgString{
    NSString *strConvert = [NSString stringWithFormat:@"%@", orgString];
    
    if ([self checkIncludeString_string:strConvert include_str:@"\xe2\x98\xba"])
    {
        strConvert = [strConvert stringByReplacingOccurrencesOfString:@"\xe2\x98\xba" withString:@"[小嘴微笑]"];
    }
    
    if ([self checkIncludeString_string:strConvert include_str:@"\xe2\x9c\x8c"]) {
        strConvert = [strConvert stringByReplacingOccurrencesOfString:@"\xe2\x9c\x8c" withString:@"[胜利]"];
    }
    if ([self checkIncludeString_string:strConvert include_str:@"\xe2\x9c\x8a"]) {
        strConvert = [strConvert stringByReplacingOccurrencesOfString:@"\xe2\x9c\x8a" withString:@"[掌心拳]"];
    }
    
    if (strConvert.length > 0) {
        
        XiTongFaceCode * faceCode = [[XiTongFaceCode alloc]init];
        NSMutableDictionary* dictFace = [faceCode ServerToXiTong];
        for (int i = 0; i < [strConvert length] - 1; i++) {
            NSRange range = NSMakeRange(i, 2);
            NSString *tempStr = [strConvert substringWithRange:range];
            NSString *temp = [dictFace objectForKey:tempStr];
            if (temp) {
                strConvert = [strConvert stringByReplacingOccurrencesOfString:tempStr withString:temp];
            }
        }
        
        [faceCode release];
    }
    
    return strConvert;
}

-(void)hideKeyBoard{
    [_txtViewComment resignFirstResponder];
}

- (void)hiddenInterface{
    if (_txtViewComment) {
        [self hideKeyBoard];
        
        [_viewCommentBKG setHidden:YES];
        [_txtViewComment setHidden:YES];
        
        if (_viewFace) {
            [_viewFace setHidden:YES];
        }
    }
}

- (void)showInterface{
    if (_txtViewComment){
        [_txtViewComment becomeFirstResponder];
        
        [_viewCommentBKG setHidden:NO];
        [_txtViewComment setHidden:NO];
        
        if (_viewFace) {
            [_viewFace setHidden:NO];
        }
    }
}

-(void)cleanInterface{
    if (_txtViewComment) {
        [self hideKeyBoard];
        
        REMOVEFROMSUPERVIEW(_viewCommentBKG);
        REMOVEFROMSUPERVIEW(_txtViewComment);
        
        if (_viewFace) {
            [_viewFace setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(_viewFace.frame))];
        }
    }
}

-(void)addGuidePage{
    if([_strRequestType isEqualToString:@"2"] && !_viewWarning){
        _viewWarning= [[UIView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(_tabDynamic.frame), self.frameHeight-self.headHeight)];
        [_viewWarning setBackgroundColor:[UIColor clearColor]];
        [_tabDynamic addSubview:_viewWarning];
        RELEASE(_viewWarning);
        
        MagicUILabel *labWarning = [[MagicUILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2, 0, 200, 60)];
        [labWarning setBackgroundColor:[UIColor clearColor]];
        [labWarning setText:@"一条好友动态也没有\n猛戳屏幕见证奇迹"];
        [labWarning setNumberOfLines:2];
        [labWarning setTextColor:ColorGray];
        [labWarning setFont:[DYBShareinstaceDelegate DYBFoutStyle:20]];
        [labWarning setTextAlignment:NSTextAlignmentCenter];

        UIImage *image = [UIImage imageNamed:@"ybx_big.png"];        
        float BearHeadStartX = (CGRectGetWidth(self.view.frame)-image.size.width/2)/2;
        float BearHeadStartY = (self.frameHeight-self.headHeight-image.size.height/2 - 100)/2-44;
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
    }
}

- (void)didTapScreenWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
        DLogInfo(@"%d", tappedView.tag);
        
        if ([SHARED.curUser.verify isEqualToString:@"0"]) {
            DYBRegisterStep2ViewController *vc = [[DYBRegisterStep2ViewController alloc] init];
            [vc setBack:YES];
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);

        }else{
            DYBSearchFriendsViewController *vc = [[DYBSearchFriendsViewController alloc] init];
            vc.b_isInMainPage = NO;
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
        }

    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

-(NSString *)getCurrentTime{
    NSDateFormatter *formater = [[[ NSDateFormatter alloc] init] autorelease];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formater setTimeZone:zone];
    
    NSDate *curDate = [NSDate date];
    NSString * curTime = [formater stringFromDate:curDate];
    
    return curTime;
}


@end
