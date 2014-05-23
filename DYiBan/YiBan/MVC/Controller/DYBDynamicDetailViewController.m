//
//  DYBDynamicDetailViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDynamicDetailViewController.h"
#import "DYBCheckImageViewController.h"
#import "status_detail_model.h"
#import "status_detail_comment.h"
#import "Status_detail_follow.h"
#import "status_detail_other.h"
#import "comment.h"
#import "follow_list.h"
#import "action_list.h"
#import "DYBWebViewController.h"
#import "DYBPersonalHomePageViewController.h"
#import "DYBCheckMultiImageViewController.h"
#import "DYBDynamicViewController.h"
#import "XiTongFaceCode.h"
#import "DYBATViewController.h"
#import "DYBPublishViewController.h"
#import "DYBPersonalHomePageViewController.h"
#import "NSObject+KVO.h"
#import "UIViewController+MagicCategory.h"
#import "good_num_info.h"
#import "comment_num_info.h"
#import "active.h"
#import "DYBActivityViewController.h"
#import "WOSCalculateOrder.h"
@interface DYBDynamicDetailViewController (){
    UILabel *lableMid;
}

@end

@implementation DYBDynamicDetailViewController

DEF_SIGNAL(DYNAMICDIMAGEETAIL)
DEF_SIGNAL(DETAILCOMMENT)
DEF_SIGNAL(DETAILLIKE)
DEF_SIGNAL(DETAILSHARE)
DEF_SIGNAL(OPENURL)
DEF_SIGNAL(OPENPERSONPAGE)
DEF_SIGNAL(MORECOMMENT)
DEF_SIGNAL(MORELIKE)
DEF_SIGNAL(MORESHARE)
DEF_SIGNAL(MOREDEL)
DEF_SIGNAL(CLICKEMOJI)
DEF_SIGNAL(CLICKAT)
DEF_SIGNAL(CLICKSEND)
DEF_SIGNAL(SELECTATLIST)
DEF_SIGNAL(PERSONALPAGE)
DEF_SIGNAL(ACTIVITYPAGE)
DEF_SIGNAL(TRANSPARENT)//透明按钮


#define iconWidth 20

-(void)dealloc{
    RELEASE(_dynamicStatus);
    RELEASEDICTARRAYOBJ(_arrStatusData);
    [self unobserveAllNotification];
    [super dealloc];
}

- (id)init:(status *)statusdetail withStatus:(int)status bScroll:(BOOL)bScroll;
{
    self = [super init];
    if (self) {     
        nStatus = status;
        _bScoll = bScroll;
        _dynamicStatus = statusdetail;
    }
    return self;
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.headview setTitle:@"动态详情"];
        [self backImgType:0];
        [self backImgType:9];
        
        MagicUIButton *btnS = (MagicUIButton *)[_viewCommentBKG viewWithTag:916];
        if (btnS && [_txtViewComment.text length] > 0) {
            btnS.enabled = YES;
        }
        
    }else if ([signal is:[MagicViewController CREATE_VIEWS]]){
        _arrStatusData = [[NSMutableArray alloc] init];
        _arrStatusCell = [[NSMutableArray alloc] init];
        
        nPage = 1;
        nPageSize = 10;
        _bMore = NO;
        
        
        
        WOSCalculateOrder *calculateView  = [[WOSCalculateOrder alloc]initWithFrame:CGRectMake(30.0f, 150.0f, 120  , 40)];
        [self.view addSubview:calculateView];
        RELEASE(calculateView);
        
        UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(30.0f, 150.0f, 120.0f, 40.0f)];
        [view setBackgroundColor:[UIColor grayColor]];
//        [self.view addSubview:view];
//        RELEASE(view);
        
        UIButton *btnLeft = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
        [btnLeft setTitle:@"-" forState:UIControlStateNormal];
        [btnLeft setTitle:@"-" forState:UIControlStateHighlighted];
        [btnLeft setBackgroundColor:[UIColor redColor]];
        [btnLeft addTarget:self action:@selector(minusFood) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnLeft];
        RELEASE(btnLeft);
        
        lableMid = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(btnLeft.frame), 0, 40.0f, 40.0f)];
        [lableMid setText:@"0"];
        [lableMid setTextAlignment:NSTextAlignmentCenter];
        [lableMid setBackgroundColor:[UIColor grayColor]];
        [view addSubview:lableMid];
        RELEASE(lableMid);
        
        
        UIButton *btnRight = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(lableMid.frame) + CGRectGetMinX(lableMid.frame), 0.0f, 40.0f, 40.0f)];
        [btnRight setTitle:@"+" forState:UIControlStateNormal];
        [btnRight setTitle:@"+" forState:UIControlStateHighlighted];
        [btnRight setBackgroundColor:[UIColor redColor]];
        [btnRight addTarget:self action:@selector(addFood) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnRight];
        RELEASE(btnRight);
        
        MagicUITableView *orderTableView = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.frameHeight-self.headHeight) isNeedUpdate:YES];
        [self.view addSubview:orderTableView];
        RELEASE(orderTableView);
        
        
        _tabDynamicDetail = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.frameHeight-self.headHeight) isNeedUpdate:YES];
        [_tabDynamicDetail setTableViewType:DTableViewSlime];
        [_tabDynamicDetail setShowsVerticalScrollIndicator:NO];
        [_tabDynamicDetail setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        [self.view addSubview:_tabDynamicDetail];
//        RELEASE(_tabDynamicDetail);
        
//        if (!_dynamicStatus.comment_num) {//从非 DYBDynamicViewController 页跳转进来时,_dynamicStatus数据不完整,获取其完整数据并刷新页面
//            [self DYB_GetStatusDetail];
//        }else{
//            switch (nStatus) {
//                case 1://评论列表
//                    [self DYB_GetStatusCommentlist];
//                    break;
//                case 2://赞列表
//                    [self DYB_GetStatusLikelist];
//                    break;
//                case 3://转发列表
//                    [self DYB_GetStatusSharelist];
//                    break;
//                default:
//                    [self DYB_GetStatusCommentlist];
//                    break;
//            }
//        }
//        
//        //接受键盘的消息
//        [self observeNotification:[MagicUIKeyboard SHOWN]];
//        [self observeNotification:[MagicUIKeyboard HIDDEN]];        
        
    }
}

-(void)minusFood{

    int numFood = [lableMid.text integerValue];
    if (numFood == 0) {
        
    }else{
    
        numFood--;
    }

    lableMid.text = [NSString stringWithFormat:@"%d",numFood];
}

-(void)addFood{

    int numFood = [lableMid.text integerValue];        
    numFood++;
    lableMid.text = [NSString stringWithFormat:@"%d",numFood];
    
}

#pragma mark -
#pragma mark - notification
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification is:[MagicUIKeyboard SHOWN]])
    {
        [self setVCBackAnimation:SWIPELASTIMAGEBACKTYPE canBackPageNumber:0];
    }else if ([notification is:[MagicUIKeyboard HIDDEN]])
    {
        [self setVCBackAnimation:SWIPELASTIMAGEBACKTYPE canBackPageNumber:2];
    }

}

#pragma mark - 返回Button处理
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
        if ([SHARED.curUser.verify isEqualToString:@"0"]) {
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"非常抱歉，此功能仅对校方认证用户开放。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",4]];
            return;
        }
        
        [self creatDynamicControllerView];
        
        if (_bMore == NO) {
            [_viewMore setHidden:NO];
            TraparentView.hidden = _viewMore.hidden;
            [self.view bringSubviewToFront:self.headview];
            [_viewMore setFrame:CGRectMake(0, 44-93, CGRectGetWidth(self.view.frame), 90)];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.5];
            [self.view bringSubviewToFront:self.headview];
            [_viewMore setFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.frame), 90)];
            [UIView commitAnimations];
            
            
            
        }else{
            [self.view bringSubviewToFront:self.headview];
            [_viewMore setFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.frame), 90)];

            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [self.view bringSubviewToFront:self.headview];
            [_viewMore setFrame:CGRectMake(0, 44-93, CGRectGetWidth(self.view.frame), 90)];
            [UIView commitAnimations];
            
            _btnMoreComment.selected = NO;
            _btnMoreShare.selected = NO;
            
            if (TraparentView) {
                TraparentView.hidden = YES;
            }
            
//            [self performSelector:@selector(HiddenMoreView) withObject:nil afterDelay:0.5f];
        }
        
        _bMore = !_bMore;
        
    }else if ([signal is:[DYBBaseViewController BACKBUTTON]]){
        
        [self sendViewSignal:[DYBDynamicViewController REFRESHCELL] withObject:(NSObject *)_dynamicStatus from:self target:[[DYBUITabbarViewController sharedInstace] getFirstViewVC]];
        for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
            if ([vc isKindOfClass:[DYBActivityViewController class]]) {
                [self sendViewSignal:[DYBActivityViewController REFRESHCELL] withObject:_dynamicStatus from:self target:(DYBActivityViewController *)vc];
                break;
            }
        }
        
        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }    
}

- (void)HiddenMoreView{
    [_viewMore setHidden:YES];
}

- (void)creatDynamicControllerView{
    
    
    if (!TraparentView) {
        TraparentView = [[MagicUIButton alloc]initWithFrame:CGRectMake(0, self.headHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.headHeight)];
        TraparentView.tag = -1000;
        [TraparentView addSignal:[DYBDynamicDetailViewController TRANSPARENT] forControlEvents:UIControlEventTouchUpInside];
        TraparentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:TraparentView];
        RELEASE(TraparentView);
    }
    
    
    
    
    if (!_viewMore) {
        _viewMore = [[UIView alloc] initWithFrame:CGRectMake(0, 44-93, CGRectGetWidth(self.view.frame), 90)];
        [_viewMore setBackgroundColor:[UIColor whiteColor]];
        [_viewMore setAlpha:0.9f];
        [_viewMore setHidden:YES];
        [self.view addSubview:_viewMore];
        RELEASE(_viewMore);
        
        UIImage *imgShadow = [UIImage imageNamed:@"more_slide_shadow.png"];
        MagicUIImageView *viewShadow = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_viewMore.frame), imgShadow.size.width/2, imgShadow.size.height/2)];
        [viewShadow setImage:imgShadow];
        [viewShadow setBackgroundColor:[UIColor clearColor]];
        [_viewMore addSubview:viewShadow];
        RELEASE(viewShadow);
    }
    
    if (!_btnMoreComment) {
        UIImage *imgCom = [UIImage imageNamed:@"more_comment_def.png"];
        UIImage *imgComPress = [UIImage imageNamed:@"more_comment_press.png"];
         _btnMoreComment =[[MagicUIButton alloc] initWithFrame:CGRectMake(0, 20, imgCom.size.width/2, imgCom.size.height/2)];
        [_btnMoreComment setImage:imgCom forState:UIControlStateNormal];
        [_btnMoreComment setImage:imgComPress forState:UIControlStateHighlighted];
        [_btnMoreComment setBackgroundColor:[UIColor clearColor]];
        [_btnMoreComment setHidden:YES];
        [_btnMoreComment setSelected:NO];
        [_btnMoreComment addSignal:[DYBDynamicDetailViewController MORECOMMENT] forControlEvents:UIControlEventTouchUpInside];
        [_viewMore addSubview:_btnMoreComment];
        RELEASE(_btnMoreComment);
    }
    
    if (!_btnMoreLike) {
        UIImage *imgCom = [UIImage imageNamed:@"more_like_def.png"];
        UIImage *imgComPress = [UIImage imageNamed:@"more_like_press.png"];
        _btnMoreLike =[[MagicUIButton alloc] initWithFrame:CGRectMake(0, 20, imgCom.size.width/2, imgCom.size.height/2)];
        [_btnMoreLike setImage:imgCom forState:UIControlStateNormal];
        [_btnMoreLike setImage:imgComPress forState:UIControlStateHighlighted];
        [_btnMoreLike setBackgroundColor:[UIColor clearColor]];
        [_btnMoreLike setHidden:YES];
        [_btnMoreLike addSignal:[DYBDynamicDetailViewController MORELIKE] forControlEvents:UIControlEventTouchUpInside];
        [_viewMore addSubview:_btnMoreLike];
        RELEASE(_btnMoreLike);
    }
    
    if (!_btnMoreShare) {
        UIImage *imgCom = [UIImage imageNamed:@"more_forward_def.png"];
        UIImage *imgComPress = [UIImage imageNamed:@"more_forward_press.png"];
        _btnMoreShare =[[MagicUIButton alloc] initWithFrame:CGRectMake(0, 20, imgCom.size.width/2, imgCom.size.height/2)];
        [_btnMoreShare setImage:imgCom forState:UIControlStateNormal];
        [_btnMoreShare setImage:imgComPress forState:UIControlStateHighlighted];
        [_btnMoreShare setBackgroundColor:[UIColor clearColor]];
        [_btnMoreShare setHidden:YES];
        [_btnMoreShare setSelected:NO];
        [_btnMoreShare addSignal:[DYBDynamicDetailViewController MORESHARE] forControlEvents:UIControlEventTouchUpInside];
        [_viewMore addSubview:_btnMoreShare];
        RELEASE(_btnMoreShare);
    }
    
    if (!_btnMoreDel) {
        UIImage *imgCom = [UIImage imageNamed:@"more_del_def.png"];
        UIImage *imgComPress = [UIImage imageNamed:@"more_del_press.png"];
        _btnMoreDel =[[MagicUIButton alloc] initWithFrame:CGRectMake(0, 20, imgCom.size.width/2, imgCom.size.height/2)];
        [_btnMoreDel setImage:imgCom forState:UIControlStateNormal];
        [_btnMoreDel setImage:imgComPress forState:UIControlStateHighlighted];
        [_btnMoreDel setBackgroundColor:[UIColor clearColor]];
        [_btnMoreDel setHidden:YES];
        [_btnMoreDel addSignal:[DYBDynamicDetailViewController MOREDEL] forControlEvents:UIControlEventTouchUpInside];
        [_viewMore addSubview:_btnMoreDel];
        RELEASE(_btnMoreDel);
    }
   
    
    int nTotal = 4;
    float nBtnDis = 0;
    
    if (_dynamicStatus.userid != [SHARED.curUser.userid intValue]) {
        nTotal--;
    }
    
    if ([_dynamicStatus.canfollow isEqual:@"0"]) {
        nTotal--;
    }
    
    if (_dynamicStatus.type == 15) {
        nTotal--;
    }
    
    nBtnDis = (320 - nTotal*50)/(nTotal*2);
    
    if (nTotal == 4) {
        [_btnMoreComment setFrame:CGRectMake(nBtnDis, 20, 50, 50)];
        [_btnMoreLike setFrame:CGRectMake(CGRectGetMaxX(_btnMoreComment.frame)+2*nBtnDis, 20, 50, 50)];
        [_btnMoreShare setFrame:CGRectMake(CGRectGetMaxX(_btnMoreLike.frame)+2*nBtnDis, 20, 50, 50)];
        [_btnMoreDel setFrame:CGRectMake(CGRectGetMaxX(_btnMoreShare.frame)+2*nBtnDis, 20, 50, 50)];
        
        [_btnMoreComment setHidden:NO];
        [_btnMoreLike setHidden:NO];
        [_btnMoreShare setHidden:NO];
        [_btnMoreDel setHidden:NO];
    }else if (nTotal == 3){
        if ([_dynamicStatus.canfollow isEqual:@"1"]) {
            [_btnMoreComment setFrame:CGRectMake(nBtnDis, 20, 50, 50)];
            [_btnMoreLike setFrame:CGRectMake(CGRectGetMaxX(_btnMoreComment.frame)+2*nBtnDis, 20, 50, 50)];
            [_btnMoreShare setFrame:CGRectMake(CGRectGetMaxX(_btnMoreLike.frame)+2*nBtnDis, 20, 50, 50)];
            
            [_btnMoreComment setHidden:NO];
            [_btnMoreLike setHidden:NO];
            [_btnMoreShare setHidden:NO];
        }else{
            [_btnMoreComment setFrame:CGRectMake(nBtnDis, 20, 50, 50)];
            [_btnMoreLike setFrame:CGRectMake(CGRectGetMaxX(_btnMoreComment.frame)+2*nBtnDis, 20, 50, 50)];
            [_btnMoreDel setFrame:CGRectMake(CGRectGetMaxX(_btnMoreLike.frame)+2*nBtnDis, 20, 50, 50)];

            [_btnMoreLike setHidden:NO];
            [_btnMoreComment setHidden:NO];
            [_btnMoreDel setHidden:NO];
        }
    }else if (nTotal == 2){
        if (_dynamicStatus.type == 15) {
            [_btnMoreComment setFrame:CGRectMake(nBtnDis, 20, 50, 50)];
            [_btnMoreDel setFrame:CGRectMake(CGRectGetMaxX(_btnMoreComment.frame)+2*nBtnDis, 20, 50, 50)];
            
            [_btnMoreComment setHidden:NO];
            [_btnMoreDel setHidden:NO];
        }else{
            [_btnMoreComment setFrame:CGRectMake(nBtnDis, 20, 50, 50)];
            [_btnMoreLike setFrame:CGRectMake(CGRectGetMaxX(_btnMoreComment.frame)+2*nBtnDis, 20, 50, 50)];
            
            [_btnMoreLike setHidden:NO];
            [_btnMoreComment setHidden:NO];
        }
    }else if (nTotal == 1){
        [_btnMoreComment setFrame:CGRectMake(nBtnDis, 20, 50, 50)];
        
        [_btnMoreComment setHidden:NO];
    }

}

#pragma mark- 只接受UITableView信号
static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{

    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSNumber *_section = [dict objectForKey:@"section"];
        NSNumber *s;
        
        if ([_section intValue] == 0) {
            s = [NSNumber numberWithInteger:1];
        }else{
            s = [NSNumber numberWithInteger:[_arrStatusData count]];
        }
        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:2];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSNumber *s;
        
        if (indexPath.section == 0){
            if (!_cellDetail) {
                _cellDetail = [[DYBCellForDynamicDetail alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                [_cellDetail setContent:_dynamicStatus indexPath:indexPath tbv:tableView];
                [_arrStatusCell addObject:_cellDetail];
            }
            
            s = [NSNumber numberWithInteger:_cellDetail.frame.size.height];

        }else{
            DLogInfo(@"%d", indexPath.row);
            if (indexPath.row >= [_arrStatusCell count]-1) {
                _cellStatus = [[DYBCellForDynamicStatus alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                [_cellStatus setContent:[_arrStatusData objectAtIndex:indexPath.row] type:nStatus indexPath:indexPath tbv:tableView];
                [_arrStatusCell addObject:_cellStatus];
            }
    
            UITableViewCell *cell = (UITableViewCell *)[_arrStatusCell objectAtIndex:indexPath.row+1];
             s = [NSNumber numberWithInteger:cell.frame.size.height];
        }

        [signal setReturnValue:s];
    
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSNumber *_section = [dict objectForKey:@"section"];
        
        if ([_section intValue] == 1) {
            
            BOOL bShare = NO;
            
            if ([_dynamicStatus.canfollow isEqualToString:@"1"]) {
                bShare = YES;
            }
            
            UIView *viewTab = [[self viewHeardSection:0 commentCount:_dynamicStatus.comment_num shareCount:_dynamicStatus.follow_num likeCount:_dynamicStatus.good_num bShared:bShare] autorelease];
            [signal setReturnValue:viewTab];  
        }else{
            [signal setReturnValue:nil];            
        }
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSNumber *_section = [dict objectForKey:@"section"];
        
        DLogInfo(@"section, %d", [_section intValue]);
        if ([_section intValue] == 0) {
            [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        }else{
            [signal setReturnValue:[NSNumber numberWithFloat:39.0]];
        } 
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell;
        
        DLogInfo(@"%d", indexPath.section);
        
        if (indexPath.section == 0){
            cell = _cellDetail;
            if (!cell) {
                cell = _cellDetail;
            }      
        }else{
            cell=((UITableViewCell *)[_arrStatusCell objectAtIndex:indexPath.row+1]);
            if (!cell)
            {
                cell=((UITableViewCell *)[_arrStatusCell objectAtIndex:indexPath.row+1]);
            }
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        if ([SHARED.curUser.verify isEqualToString:@"0"]) {
            return;
        }
        
        if (indexPath.section != 0 && nStatus == 1) {
            DLogInfo(@"%d", indexPath.row);
            comment *cmt = (comment *)[_arrStatusData objectAtIndex:indexPath.row];
            
            if ([cmt.content length] == 0) {
                return;
            }

            [self initInput:YES];
            [_txtViewComment setText:[NSString stringWithFormat:@"@%@ ", cmt.user.name]];
        }
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        MagicRequest *request = nil;
        nPage = 1;
        _bScoll = NO;
        
        switch (nStatus) {
            case 1://评论列表
                request = [self DYB_GetStatusCommentlist];
                break;
            case 2://赞列表
                request = [self DYB_GetStatusLikelist];
                break;
            case 3://转发列表
                request = [self DYB_GetStatusSharelist];
                break;
            default:
                request = [self DYB_GetStatusCommentlist];
                break;
        }
        
        if (!request) {//无网路
            [_tabDynamicDetail reloadData:NO];
        }
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
        MagicRequest *request = nil;
        nPage++;
        
        switch (nStatus) {
            case 1://评论列表
                request = [self DYB_GetStatusCommentlist];
                break;
            case 2://赞列表
                request = [self DYB_GetStatusLikelist];
                break;
            case 3://转发列表
                request = [self DYB_GetStatusSharelist];
                break;
            default:
                request = [self DYB_GetStatusCommentlist];
                break;
        }
        
        if (!request) {//无网路
           [_tabDynamicDetail reloadData:NO];
        }
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
        [self cleanInterface];
    }
    
    
    
}

- (void)handleViewSignal_DYBDynamicDetailViewController:(MagicViewSignal *)signal{
    if([signal is:[DYBDynamicDetailViewController DYNAMICDIMAGEETAIL]]){
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
        
    }else if ([signal is:[DYBDynamicDetailViewController DETAILCOMMENT]]){
        DLogInfo(@"Comment");
        nStatus = 1;
        nPage = 1;
        
        [self changeBtnState:nStatus];
        [self DYB_GetStatusCommentlist];
        
    }else if ([signal is:[DYBDynamicDetailViewController DETAILLIKE]]){
        DLogInfo(@"Like");
        nStatus = 2;
        nPage = 1;
        
        [self changeBtnState:nStatus];
        [self DYB_GetStatusLikelist];
        
    }else if ([signal is:[DYBDynamicDetailViewController DETAILSHARE]]){
        DLogInfo(@"Share");
        nStatus = 3;
        nPage = 1;
        
        [self changeBtnState:nStatus];
        [self DYB_GetStatusSharelist];
        
    }else if ([signal is:[DYBDynamicDetailViewController OPENURL]]){
        NSString *streURL  = (NSString *)[signal object];
        
        DYBWebViewController *vc = [[DYBWebViewController alloc] init:streURL];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if([signal is:[DYBDynamicDetailViewController OPENPERSONPAGE]]){
        NSDictionary *dic = (NSDictionary *)[signal object];

        DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
        vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"username"], @"name", [dic objectForKey:@"userid"], @"userid", nil];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBDynamicDetailViewController MORECOMMENT]]){
        [self sendViewSignal:[DYBBaseViewController NEXTSTEPBUTTON]];
        
        MagicUIButton *btn = (MagicUIButton *)signal.source;
        _btnMoreShare.selected = NO;
        
        if (btn.selected == NO) {
             [self initInput:YES];
        }else{
            [self cleanInterface];
        }
    
        btn.selected = !btn.selected;
    }else if ([signal is:[DYBDynamicDetailViewController MORELIKE]]){
        [self sendViewSignal:[DYBBaseViewController NEXTSTEPBUTTON]];        
        [self cleanInterface];
        
        if ([_dynamicStatus.isrec isEqualToString:@"1"]) {
            [DYBShareinstaceDelegate loadFinishAlertView:@"已经赞过了" target:self];
            return;
        }

        MagicRequest *request = [DYBHttpMethod status_feedaction_id:[NSString stringWithFormat:@"%d", _dynamicStatus.id] action:@"1" type:@"1" isAlert:YES receive:self];
        request.tag = -6;
        
    }else if ([signal is:[DYBDynamicDetailViewController MORESHARE]]){
        [self sendViewSignal:[DYBBaseViewController NEXTSTEPBUTTON]];
        
        MagicUIButton *btn = (MagicUIButton *)signal.source;
        _btnMoreComment.selected = NO;

        if (btn.selected == NO) {
            [self initInput:NO];
        }else{
            [self cleanInterface];
        }
        
        btn.selected = !btn.selected;
        
    }else if ([signal is:[DYBDynamicDetailViewController MOREDEL]]){
        [self sendViewSignal:[DYBBaseViewController NEXTSTEPBUTTON]];
        [self cleanInterface];
        
        [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"真的要删除？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
    }else if ([signal is:[DYBDynamicDetailViewController CLICKSEND]]){
        NSString *strComment = [self convertSystemEmoji:_txtViewComment.text];
        
        strComment = [strComment stringByReplacingOccurrencesOfString: @"\r" withString:@""];
        strComment = [strComment stringByReplacingOccurrencesOfString: @"\n" withString:@""];
        strComment = [strComment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self hiddenInterface];
        
        if ([strComment length] > 140) {
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"超过140字数限制！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",3]];
            return;
        }
        
        MagicRequest *request = nil;
        
        if (_btnMoreComment.selected == YES) {
            request = [DYBHttpMethod status_addcomment_id:[NSString stringWithFormat:@"%d", _dynamicStatus.id] content:strComment isAlert:YES receive:self];
            request.tag = -7;
        }else if (_btnMoreShare.selected == YES){
            request = [DYBHttpMethod status_follow_id:[NSString stringWithFormat:@"%d", _dynamicStatus.id] content:strComment com_tag:@"1" isAlert:YES receive:self];
            request.tag = -9;
        }else{
            request = [DYBHttpMethod status_addcomment_id:[NSString stringWithFormat:@"%d", _dynamicStatus.id] content:strComment isAlert:YES receive:self];
            request.tag = -7;
        }

    }else if ([signal is:[DYBDynamicDetailViewController CLICKEMOJI]]){
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
            
            [_viewCommentBKG setFrame:CGRectMake(0, _viewFace.frame.origin.y-CGRectGetHeight(_viewCommentBKG.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(_viewCommentBKG.frame))];
            [_txtViewComment setFrame:CGRectMake(CGRectGetMinX(_txtViewComment.frame), _viewFace.frame.origin.y-CGRectGetHeight(_viewCommentBKG.frame)+7, CGRectGetWidth(_txtViewComment.frame), CGRectGetHeight(_txtViewComment.frame))];

        }
        
        _btnSelEmoji.selected = !_btnSelEmoji.selected;
    }else if ([signal is:[DYBDynamicDetailViewController CLICKAT]]){
        DYBATViewController *vc = [[DYBATViewController alloc] init];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBDynamicDetailViewController SELECTATLIST]]){
        NSArray *_arrATList = (NSArray *)[signal object];
        DLogInfo(@"list:%@", _arrATList);
        
        [_txtViewComment becomeFirstResponder];
        
        NSString *ATname = @"";
        for (NSString *name  in _arrATList) {
            NSString *at = [NSString stringWithFormat:@"@%@ ",name];
            ATname = [ATname stringByAppendingString:at];
        }
        
        NSString *beforeString = [self beforeString:_txtViewComment subString:ATname];
        _txtViewComment.text = [self subStringOperat:_txtViewComment subString:ATname beforeString:beforeString] ;
  
        //光标位置
        NSRange range = [_txtViewComment.text rangeOfString:beforeString];
        NSRange ragne1 = NSMakeRange(range.location+beforeString.length, 0);
        _txtViewComment.selectedRange = ragne1;
    }else if ([signal is:[DYBDynamicDetailViewController PERSONALPAGE]]){
        NSDictionary *dic = (NSDictionary *)[signal object];
        
        DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
        vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"username"], @"name", [dic objectForKey:@"userid"], @"userid", nil];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBDynamicDetailViewController ACTIVITYPAGE]]){
        NSString *strActivityID  = (NSString *)[signal object];
        
        MagicRequest *request = [DYBHttpMethod active_detail:strActivityID isAlert:YES receive:self];
        [request setTag:-10];
    }else if ([signal is:[DYBDynamicDetailViewController TRANSPARENT]]){
        if (TraparentView) {
            TraparentView.hidden = YES;
        }
        [self sendViewSignal:[DYBBaseViewController NEXTSTEPBUTTON]];
        [self cleanInterface];
        
    }
    
    

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

-(void)hideKeyBoard{
    [_txtViewComment resignFirstResponder];
}

-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        DLogInfo(@"DEL");
        
        NSDictionary *dicType = (NSDictionary *)[signal object];
        NSString *strType = [dicType objectForKey:@"type"];
        int row = [[dicType objectForKey:@"rowNum"] intValue];
        
        if ([strType intValue] == BTNTAG_DEL){
            [_btnMoreDel setUserInteractionEnabled:NO];
            
            MagicRequest *request = [DYBHttpMethod status_del_id:[NSString stringWithFormat:@"%d", _dynamicStatus.id] type:[NSString stringWithFormat:@"%d",_dynamicStatus.type] isAlert:YES receive:self];
            request.tag = -8;
        }else if ([strType intValue] == BTNTAG_SINGLE){
            if (row == 3) {
                [self showInterface];
            }else if (row == 4){
                [self sendViewSignal:[DYBBaseViewController BACKBUTTON]];
            }

        }
    }
}

- (UIView *) viewHeardSection:(NSInteger)nSelTab commentCount:(NSString *)nComCount shareCount:(NSString *)nShareCount likeCount:(NSString *)nlikeCount bShared:(BOOL)bShare{
    UIView *viewSectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];

    MagicUIImageView *viewSectionHeadBKG = [[MagicUIImageView alloc] initWithFrame:CGRectMake(15, 0, 290, 40)];
    [viewSectionHeadBKG setBackgroundColor:[UIColor clearColor]];
    [viewSectionHeadBKG setImage:[UIImage imageNamed:@"bg_details_tab.png"]];
    [viewSectionHeadBKG setUserInteractionEnabled:YES];
    [viewSectionHead addSubview:viewSectionHeadBKG];
    [viewSectionHead sendSubviewToBack:viewSectionHeadBKG];
    RELEASE(viewSectionHeadBKG);
    
    _viewComment = [[MagicUIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_comment.png"]];
    _viewLike = [[MagicUIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_like.png"]];
    
    _lbComment = [[MagicUILabel alloc] initWithFrame:CGRectMake([self GetNumLableStart:nComCount], 2, 60, 39)];
    [_lbComment setText:nComCount];
    [_lbComment setTextColor:[UIColor clearColor]];
    [_lbComment setBackgroundColor:[UIColor clearColor]];
    [_lbComment setTextAlignment:NSTextAlignmentLeft];
    [_lbComment setFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
    
    MagicUIButton *_btnComment = [[MagicUIButton alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 96.0f, 39.0f)];
    [_btnComment setBackgroundColor:[UIColor clearColor]];
    [_btnComment addSignal:[DYBDynamicDetailViewController DETAILCOMMENT] forControlEvents:UIControlEventTouchUpInside];
    [_viewComment setFrame:CGRectMake(CGRectGetMinX(_lbComment.frame)-iconWidth-3, 10, iconWidth, 20)];
    [_btnComment addSubview:_viewComment];
    [_btnComment addSubview:_lbComment];
    [viewSectionHead addSubview:_btnComment];
    RELEASE(_btnComment);
    
    MagicUIButton *_btnLike = nil;
    
    if (_dynamicStatus.type != 15) {
        _lbLike = [[MagicUILabel alloc] initWithFrame:CGRectMake([self GetNumLableStart:nlikeCount], 2, 60, 39)];
        [_lbLike setText:nlikeCount];
        [_lbLike setTextColor:ColorGray];
        [_lbLike setBackgroundColor:[UIColor clearColor]];
        [_lbLike setTextAlignment:NSTextAlignmentLeft];
        [_lbLike setFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
        
        _btnLike = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnComment.frame)+1, 0.0f, 96.0f, 39.0f)];
        [_btnLike setBackgroundColor:[UIColor clearColor]];
        [_btnLike addSignal:[DYBDynamicDetailViewController DETAILLIKE] forControlEvents:UIControlEventTouchUpInside];
        [_viewLike setFrame:CGRectMake(CGRectGetMinX(_lbLike.frame)-iconWidth-3, 10, iconWidth, 20)];
        [_btnLike addSubview:_viewLike];
        [_btnLike addSubview:_lbLike];
        [viewSectionHead addSubview:_btnLike];
        RELEASE(_btnLike);
    }else{
        _lbLike = nil;
    }

    
    if (bShare) {
        _viewShare = [[MagicUIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_share.png"]];
        
        _lbShare = [[MagicUILabel alloc] initWithFrame:CGRectMake([self GetNumLableStart:nShareCount], 2, 60, 39)];
        [_lbShare setText:nShareCount];
        [_lbShare setTextColor:ColorGray];
        [_lbShare setBackgroundColor:[UIColor clearColor]];
        [_lbShare setTextAlignment:NSTextAlignmentLeft];
        [_lbShare setFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
        
        MagicUIButton *_btnShare = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnLike.frame)+1, 0.0f, 96.0f, 39.0f)];
        [_btnShare setBackgroundColor:[UIColor clearColor]];
        [_btnShare addSignal:[DYBDynamicDetailViewController DETAILSHARE] forControlEvents:UIControlEventTouchUpInside];
        [_viewShare setFrame:CGRectMake(CGRectGetMinX(_lbShare.frame)-iconWidth-3, 10, iconWidth, 20)];
        [_btnShare addSubview:_viewShare];
        [_btnShare addSubview:_lbShare];
        [viewSectionHead addSubview:_btnShare];
        
        RELEASE(_btnShare);
        RELEASE(_viewShare);
        RELEASE(_lbShare);
    }
    
    UIImage *imgArrow = [UIImage imageNamed:@"arrow_details_tab.png"];
    _viewArrow = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(_btnComment.frame)-imgArrow.size.width/4, CGRectGetMaxY(_btnComment.frame)-imgArrow.size.height/2+1, imgArrow.size.width/2, imgArrow.size.height/2)];
    [_viewArrow setImage:imgArrow];
    [_viewArrow setBackgroundColor:[UIColor clearColor]];
    [viewSectionHead addSubview:_viewArrow];
    [viewSectionHead bringSubviewToFront:_viewArrow];
    RELEASE(_viewArrow);

    
    [self changeBtnState:nStatus];
    
    RELEASE(_lbComment);
    
    if (_lbLike) {
        RELEASE(_lbLike);
    }
    
    RELEASE(_viewComment);
    RELEASE(_viewLike);

  
    
    return viewSectionHead;
}


//得数字现实lable的起始居中位置
- (float)GetNumLableStart:(NSString *)strNum{
    float fStart = 0;
    
    CGSize labelSize = [strNum sizeWithFont:[DYBShareinstaceDelegate DYBFoutStyle:18] constrainedToSize:CGSizeMake(70, 39) lineBreakMode:NSLineBreakByCharWrapping];
    fStart = (96-iconWidth-labelSize.width)/2+iconWidth+3;/*单元格宽减图标宽减数字款除以2，加上图标宽加图标数字间距*/
    
    return fStart;
}

//设置标签颜色
-(void)changeBtnState:(NSInteger)btnIndex{
    [_lbComment setTextColor:ColorGray];
    
    if (_lbLike) {
        [_lbLike setTextColor:ColorGray];
        [_viewLike setImage:[UIImage imageNamed:@"icon_like.png"]];
    }
    
    if (_lbShare) {
        [_lbShare setTextColor:ColorGray];
    }
    
    
    [_viewComment setImage:[UIImage imageNamed:@"icon_comment.png"]];
    [_viewShare setImage:[UIImage imageNamed:@"icon_share.png"]];
    
    float nStartX = 0;
    
    switch (btnIndex) {
        case 1: /*评论*/
        {
            [_lbComment setTextColor:ColorBlack];
            [_viewComment setImage:[UIImage imageNamed:@"icon_comment_sel.png"]];
            nStartX = 53;
        }
            break;
        case 2: /*赞*/
        {
            [_lbLike setTextColor:ColorBlack];
            [_viewLike setImage:[UIImage imageNamed:@"icon_like_sel.png"]];
            nStartX = 149;
        }
            break;
        case 3: /*转发*/
        {
            [_lbShare setTextColor:ColorBlack];
            [_viewShare setImage:[UIImage imageNamed:@"icon_share_sel.png"]];
            nStartX = 244;
        }
            break;
        default:
            break;
    }
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3f];

    [_viewArrow setFrame:CGRectMake(nStartX, CGRectGetMinY(_viewArrow.frame), CGRectGetWidth(_viewArrow.frame), CGRectGetHeight(_viewArrow.frame))];
    
    [UIView commitAnimations];
}

#pragma mark- 动态详情请求
- (void)DYB_GetStatusDetail{
    MagicRequest *request = [DYBHttpMethod status_detail_id:_dynamicStatus.id type:1 since_id:nil max_id:nil num:@"100" page:@"1" message_id:nil isAlert:NO receive:self];
    [request setTag:-1];
}

//评论列表
- (MagicRequest *)DYB_GetStatusCommentlist{
    MagicRequest *request = [DYBHttpMethod status_comments:[NSString stringWithFormat:@"%d", _dynamicStatus.id] type:1 since_id:@"0" max_id:@"0" num:nPageSize page:nPage isAlert:YES receive:self];
    [request setTag:-2];
    
    return request;
}

//赞列表
- (MagicRequest *)DYB_GetStatusLikelist{
    MagicRequest *request = [DYBHttpMethod status_actionlist:[NSString stringWithFormat:@"%d", _dynamicStatus.id] action:1 page:nPage num:nPageSize isAlert:YES receive:self];
    [request setTag:-3];
    
    return request;
}

//转发列表
- (MagicRequest *)DYB_GetStatusSharelist{
    MagicRequest *request = [DYBHttpMethod status_followlist:[NSString stringWithFormat:@"%d", _dynamicStatus.id] num:nPageSize page:nPage isAlert:YES receive:self];
    [request setTag:-4];
    
    return request;
}

- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{
    if ([request succeed]){
        if (request.tag == -1){/*初始化*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode)
            {
                if (_dynamicStatus) {//刷新 从非 DYBDynamicViewController 页带来的 不完整的_dynamicStatus
                    [_dynamicStatus release];
                    _dynamicStatus=nil;
                    
                    [_cellDetail release];
                    _cellDetail=nil;
                    
                    [_arrStatusData removeAllObjects];
                    [_arrStatusCell removeAllObjects];
                }
                
               _dynamicStatus = [status JSONReflection:[respose.data objectForKey:@"status"]];
                [_dynamicStatus retain];
                
                [self.view setUserInteractionEnabled:YES];

                if ([[respose.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                    [_tabDynamicDetail reloadData:NO];
                }else{
                    [_tabDynamicDetail reloadData:YES];
                }
                
                switch (nStatus) {
                    case 1://评论列表
                        [self DYB_GetStatusCommentlist];
                        break;
                    case 2://赞列表
                        [self DYB_GetStatusLikelist];
                        break;
                    case 3://转发列表
                        [self DYB_GetStatusSharelist];
                        break;
                    default:
                        [self DYB_GetStatusCommentlist];
                        break;
                }
            }else if (respose.response == 105){
                NSString *strWhitespace =nil;
                strWhitespace = [_dynamicStatus.content stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if ([strWhitespace length] == 0) {
                    if ([_dynamicStatus.pic_array count] == 0) {
                        [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"该动态已经不存在！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",4]];
                        
                        return;
                    }
                }
            }
        }else if (request.tag == -2){
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                status_detail_comment *_statusComment = [status_detail_comment JSONReflection:respose.data];
                
                if ([_arrStatusData count] > 0 && nPage == 1) {
                    [_arrStatusData removeAllObjects];
                    [_arrStatusCell removeAllObjects];
                    
                    if (_cellDetail) {
                        [_arrStatusCell addObject:_cellDetail];
                    }
                }
                
                NSMutableArray *arrgInfo = [[NSMutableArray alloc] init];
                NSMutableArray *sqlcommentInfo = [[NSMutableArray alloc] initWithCapacity:1];
      
                for (comment *cmt in _statusComment.comment) {
                    [_arrStatusData addObject:cmt];
                    
                    comment_num_info* cInfo = [[comment_num_info alloc] init];
                    [cInfo setName:cmt.username];
                    [cInfo setPic:cmt.user.pic];
                    [cInfo setComment:cmt.content];
                              
                    if ([_dynamicStatus.comment_num_info count] > 0) {
                        [arrgInfo insertObject:cInfo atIndex:0];
                    }else{
                        arrgInfo = [[NSMutableArray alloc] initWithObjects:cInfo, nil];
                    }
                    
                    for (int i = 0; i < [arrgInfo count]; i++)
                    {
                        comment_num_info *cInfo = [arrgInfo objectAtIndex:i];
                        NSDictionary *gInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:cInfo.comment, @"comment", cInfo.pic, @"pic", cInfo.name, @"name", @"0", @"kind", @"", @"dateline", @"", @"target",  _dynamicStatus.content, @"tocontent", _dynamicStatus.username, @"tousername", [NSString stringWithFormat:@"%d", _dynamicStatus.id], @"touid", @"", @"totid", SHARED.curUser.userid, @"id", nil];
                        [sqlcommentInfo addObject:gInfoDict];
                    }
                    
                    RELEASE(cInfo);
                }
                
                [_lbComment setText:[NSString stringWithFormat:@"%@", _statusComment.comment_num]];
                _dynamicStatus.comment_num = [NSString stringWithFormat:@"%d", [_lbComment.text intValue]];
                _dynamicStatus.comment_num_info = [[NSArray alloc] initWithArray:(NSArray *)arrgInfo];
                
                RELEASEDICTARRAYOBJ(arrgInfo);
                RELEASE(_dynamicStatus.comment_num_info);
                
                if ([_statusComment.havenext isEqualToString:@"1"]) {
                    [_tabDynamicDetail reloadData:NO];
                }else{
                    [_tabDynamicDetail reloadData:YES];
                }
                
                if ([_arrStatusData count] == 0) {
                    comment *cmt = [[comment alloc] init];
                    [_arrStatusData insertObject:cmt atIndex:0];
                    RELEASE(cmt);
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    DYBCellForDynamicStatus *_cellAdd = [[[DYBCellForDynamicStatus alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
                    [_cellAdd setContent:[_arrStatusData objectAtIndex:0] type:nStatus+3 indexPath:indexPath tbv:_tabDynamicDetail];
                    [_arrStatusCell insertObject:_cellAdd atIndex:1];
                    
                    [_tabDynamicDetail reloadData];
                    
                    _bNoData =YES;
                }else{
                    _bNoData = NO;
                }
            }else if (respose.response == 105){
                [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:respose.message targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",4]];
                return;
            }
        }else if (request.tag == -3){
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                status_detail_other *_statusComment = [status_detail_other JSONReflection:respose.data];
                
                if ([_arrStatusData count] > 0 && nPage == 1) {
                    [_arrStatusData removeAllObjects];
                    [_arrStatusCell removeAllObjects];
                    
                    if (_cellDetail) {
                        [_arrStatusCell addObject:_cellDetail];
                    }
                }
                
                NSMutableArray *arrgInfo = nil;
                NSMutableArray *sqlGoodInfo = [[NSMutableArray alloc] initWithCapacity:1];
                
                for (action_list *act in _statusComment.action_list) {
                    [_arrStatusData addObject:act];
                    
                    if ([act.userid isEqualToString:SHARED.curUser.userid]) {
                        _dynamicStatus.isrec = @"1";
                    }
                    
                    good_num_info* gInfo = [[good_num_info alloc] init];
                    [gInfo setName:act.name];
                    [gInfo setUserid:act.userid];
                    [gInfo setTime:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]];
                    
                    if ([_dynamicStatus.good_num_info count] > 0) {
                        arrgInfo = [[NSMutableArray alloc] initWithArray:_dynamicStatus.good_num_info];
                        [arrgInfo insertObject:gInfo atIndex:0];
                    }else{
                        arrgInfo = [[NSMutableArray alloc] initWithObjects:gInfo, nil];
                    }
                    
                    RELEASE(gInfo);
                }
                
                for (int i = 0; i < [arrgInfo count]; i++)
                {
                    good_num_info *gInfo = [arrgInfo objectAtIndex:i];
                    NSDictionary *gInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:gInfo.userid, @"userid", gInfo.time, @"time", gInfo.name, @"name", nil];
                    [sqlGoodInfo addObject:gInfoDict];
                }
                 RELEASEDICTARRAYOBJ(sqlGoodInfo);
                
                [_lbLike setText:[NSString stringWithFormat:@"%@",_statusComment.good_num]];
                _dynamicStatus.good_num = [NSString stringWithFormat:@"%d", [_lbLike.text intValue]];
                _dynamicStatus.good_num_info = [[NSArray alloc] initWithArray:(NSArray *)arrgInfo];
           
                RELEASEDICTARRAYOBJ(arrgInfo);
                RELEASE(_dynamicStatus.good_num_info);
                
                if ([_statusComment.havenext isEqualToString:@"1"]) {
                    [_tabDynamicDetail reloadData:NO];
                }else{
                    [_tabDynamicDetail reloadData:YES];
                }
                
                if ([_arrStatusData count] == 0) {
                    action_list *act = [[action_list alloc] init];
                    [_arrStatusData insertObject:act atIndex:0];
                    RELEASE(act);
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    DYBCellForDynamicStatus *_cellAdd = [[[DYBCellForDynamicStatus alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
                    [_cellAdd setContent:[_arrStatusData objectAtIndex:0] type:nStatus+3 indexPath:indexPath tbv:_tabDynamicDetail];
                    [_arrStatusCell insertObject:_cellAdd atIndex:1];
                    
                    [_tabDynamicDetail reloadData];
                    
                    _bNoData =YES;
                }else{
                    _bNoData = NO;
                }
            }else if (respose.response == 105){
                [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:respose.message targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",4]];
                return;
            }
            
        }else if (request.tag == -4){
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                
                Status_detail_follow *_statusComment = [Status_detail_follow JSONReflection:respose.data];
                
                if ([_arrStatusData count] > 0 && nPage == 1) {
                    [_arrStatusData removeAllObjects];
                    [_arrStatusCell removeAllObjects];
                    
                    if (_cellDetail) {
                        [_arrStatusCell addObject:_cellDetail];
                    }
                }
                
                for (follow_list *flw in _statusComment.follow_list) {
                    [_arrStatusData addObject:flw];
                }
                
                [_lbShare setText:[NSString stringWithFormat:@"%@", _statusComment.follow_num]];
                _dynamicStatus.follow_num = [NSString stringWithFormat:@"%d", [_lbShare.text intValue]];
                
                if ([_statusComment.havenext isEqualToString:@"1"]) {
                    [_tabDynamicDetail reloadData:NO];
                }else{
                    [_tabDynamicDetail reloadData:YES];
                }
                
                if ([_arrStatusData count] == 0) {
                    follow_list *flw = [[follow_list alloc] init];
                    [_arrStatusData insertObject:flw atIndex:0];
                    RELEASE(flw);
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    DYBCellForDynamicStatus *_cellAdd = [[[DYBCellForDynamicStatus alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
                    [_cellAdd setContent:[_arrStatusData objectAtIndex:0] type:nStatus+3 indexPath:indexPath tbv:_tabDynamicDetail];
                    [_arrStatusCell insertObject:_cellAdd atIndex:1];
                    
                    [_tabDynamicDetail reloadData];
                
                    _bNoData =YES;
                }else{
                    _bNoData = NO;
                }
            }else if (respose.response == 105){
                [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:respose.message targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",4]];
                return;
            }
        }else if (request.tag == -6){
            [_lbLike setText:[NSString stringWithFormat:@"%d", [_lbLike.text intValue]+1]];
            _dynamicStatus.good_num = [NSString stringWithFormat:@"%d", [_lbLike.text intValue]];
            _dynamicStatus.isrec = @"1";
            _bMore = NO;
            
            [DYBShareinstaceDelegate handleSqlValue:[NSString stringWithFormat:@"%d", _dynamicStatus.id] valueKye:@"isrec" value:@"1"];
            [DYBShareinstaceDelegate handleSqlValue:[NSString stringWithFormat:@"%d", _dynamicStatus.id] valueKye:@"good_num" value:_dynamicStatus.good_num];
            
            good_num_info* gInfo = [[good_num_info alloc] init];
            [gInfo setName:SHARED.curUser.name];
            [gInfo setUserid:SHARED.curUser.userid];
            [gInfo setTime:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]];
            
            NSMutableArray *arrgInfo = nil;
            NSMutableArray *sqlGoodInfo = [[NSMutableArray alloc] initWithCapacity:1];
            
            if ([_dynamicStatus.good_num_info count] > 0) {
                arrgInfo = [[NSMutableArray alloc] initWithArray:_dynamicStatus.good_num_info];
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
             RELEASEDICTARRAYOBJ(sqlGoodInfo);
            
            _dynamicStatus.good_num_info = [[NSArray alloc] initWithArray:(NSArray *)arrgInfo];
            
            RELEASE(gInfo);
            RELEASEDICTARRAYOBJ(arrgInfo);
            RELEASE(_dynamicStatus.good_num_info);
            
            
            if (nStatus == 2) {
                if (_bNoData == YES && [_arrStatusData count] == 1) {
                    [_arrStatusData removeAllObjects];
                    [_arrStatusCell removeObjectAtIndex:1];
                }
                
                action_list *act = [[action_list alloc] init];
                act.name = [NSString stringWithFormat:@"%@", SHARED.curUser.name];
                act.pic = [NSString stringWithFormat:@"%@", SHARED.curUser.pic];
                act.time = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
                [_arrStatusData insertObject:act atIndex:0];
                RELEASE(act);
 
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                DYBCellForDynamicStatus *_cellAdd = [[[DYBCellForDynamicStatus alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
                [_cellAdd setContent:[_arrStatusData objectAtIndex:0] type:nStatus indexPath:indexPath tbv:_tabDynamicDetail];
                
                MagicUIImageView *imgSpLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(27, _cellAdd.frame.size.height-1, 266, 1) backgroundColor:[UIColor clearColor] image:[UIImage imageNamed:@"sepline2.png"] isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_cellAdd Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                
                RELEASE(imgSpLine);
                
                [_arrStatusCell insertObject:_cellAdd atIndex:1];

                [_tabDynamicDetail reloadData];
                _bNoData = NO;
            }
        }else if (request.tag == -7){
            NSString *strComment = [self convertSystemEmoji:_txtViewComment.text];
            [_lbComment setText:[NSString stringWithFormat:@"%d", [_lbComment.text intValue]+1]];
             _dynamicStatus.comment_num = [NSString stringWithFormat:@"%d", [_lbComment.text intValue]];
            _bMore = NO;
            
            [self showInterface];
            [self cleanInterface];

            comment_num_info* cInfo = [[comment_num_info alloc] init];
            [cInfo setName:SHARED.curUser.name];
            [cInfo setPic:SHARED.curUser.pic];
            [cInfo setComment:strComment];
            
            NSMutableArray *arrgInfo = nil;
            NSMutableArray *sqlcommentInfo = [[NSMutableArray alloc] initWithCapacity:1];
            
            if ([_dynamicStatus.comment_num intValue] > 0) {
                arrgInfo = [[NSMutableArray alloc] initWithArray:_dynamicStatus.comment_num_info];
//                [arrgInfo insertObject:cInfo atIndex:0];
                [arrgInfo addObject:cInfo];
            }else{
                arrgInfo = [[NSMutableArray alloc] initWithObjects:cInfo, nil];
            }
            
            for (int i = 0; i < [arrgInfo count]; i++)
            {
                comment_num_info *cInfo = [arrgInfo objectAtIndex:i];
                NSDictionary *gInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:cInfo.comment, @"comment", cInfo.pic, @"pic", cInfo.name, @"name", @"0", @"kind", @"", @"dateline", @"", @"target",  _dynamicStatus.content, @"tocontent", _dynamicStatus.username, @"tousername", [NSString stringWithFormat:@"%d", _dynamicStatus.id], @"touid", @"", @"totid", SHARED.curUser.userid, @"id", nil];
                [sqlcommentInfo addObject:gInfoDict];
            }
            
            _dynamicStatus.comment_num = [NSString stringWithFormat:@"%d", [_lbComment.text intValue]];
            _dynamicStatus.comment_num_info = [[NSArray alloc] initWithArray:(NSArray *)arrgInfo];
            
            RELEASE(cInfo);
            RELEASEDICTARRAYOBJ(arrgInfo);
            RELEASE(_dynamicStatus.comment_num_info);

            if (nStatus == 1) {
                if (_bNoData == YES && [_arrStatusData count] == 1) {
                    [_arrStatusData removeAllObjects];
                    [_arrStatusCell removeObjectAtIndex:1];
                }
                
                comment *cmt = [[comment alloc] init];
                cmt.username = SHARED.curUser.name;
                cmt.content = strComment;
                cmt.user = SHARED.curUser;
                cmt.time = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
                [_arrStatusData insertObject:cmt atIndex:0];
                RELEASE(cmt);
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                DYBCellForDynamicStatus *_cellAdd = [[[DYBCellForDynamicStatus alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
                [_cellAdd setContent:[_arrStatusData objectAtIndex:0] type:nStatus indexPath:indexPath tbv:_tabDynamicDetail];
                
                MagicUIImageView *imgSpLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(27, _cellAdd.frame.size.height-1, 266, 1) backgroundColor:[UIColor clearColor] image:[UIImage imageNamed:@"sepline2.png"] isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_cellAdd Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                
                RELEASE(imgSpLine);
                
                [_arrStatusCell insertObject:_cellAdd atIndex:1];
                
                [_tabDynamicDetail reloadData];
                _bNoData = NO;
            }
        }else if (request.tag == -8){
            
//            self.b_isAutoRefreshTbvInViewWillAppear=YES;
            [self postNotification:[UIViewController AutoRefreshTbvInViewWillAppear] withObject:Nil userInfo:Nil];
            
            [self sendViewSignal:[DYBDynamicViewController DELEFRESH] withObject:(NSObject *)_dynamicStatus.id from:self target:[[DYBUITabbarViewController sharedInstace] getFirstViewVC]];
            
            for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
                if ([vc isKindOfClass:[DYBActivityViewController class]]) {
                    [self sendViewSignal:[DYBActivityViewController DELEFRESH] withObject:(NSObject *)_dynamicStatus.id from:self target:(DYBActivityViewController *)vc];
                    break;
                }
            }
            
            [self sendViewSignal:[DYBBaseViewController BACKBUTTON]];
            
        }else if (request.tag == -9){
            NSString *strShare = [self convertSystemEmoji:_txtViewComment.text];
            [_lbShare setText:[NSString stringWithFormat:@"%d", [_lbShare.text intValue]+1]];
            _dynamicStatus.follow_num = [NSString stringWithFormat:@"%d", [_lbShare.text intValue]];
            _bMore = NO;
            
            [self showInterface];
            [self cleanInterface];
            
            [self postNotification:[UIViewController AutoRefreshTbvInViewWillAppear] withObject:Nil userInfo:Nil];
            
            if (nStatus == 3) {
                if (_bNoData == YES && [_arrStatusData count] == 1) {
                    [_arrStatusData removeAllObjects];
                    [_arrStatusCell removeObjectAtIndex:1];
                }
                
                follow_list *flw = [[follow_list alloc] init];
                flw.username = SHARED.curUser.name;
                flw.content = strShare;
                flw.user = SHARED.curUser;
                flw.time = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
                [_arrStatusData insertObject:flw atIndex:0];
                RELEASE(flw);
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                DYBCellForDynamicStatus *_cellAdd = [[[DYBCellForDynamicStatus alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
                [_cellAdd setContent:[_arrStatusData objectAtIndex:0] type:nStatus indexPath:indexPath tbv:_tabDynamicDetail];
                
                MagicUIImageView *imgSpLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(27, _cellAdd.frame.size.height-1, 266, 1) backgroundColor:[UIColor clearColor] image:[UIImage imageNamed:@"sepline2.png"] isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_cellAdd Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                
                RELEASE(imgSpLine);
                
                [_arrStatusCell insertObject:_cellAdd atIndex:1];
                
                [_tabDynamicDetail reloadData];
                 _bNoData = NO;
            }
        }else if (request.tag == -10)/*活动页面*/{
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
        
        if (nPage == 1) {
             [self scrollToTheTop];
        }
        
        
    }else if ([request failed]){
        if (request.tag == -6) {
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"没有赞成功，请稍后尝试！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
            [_btnMoreLike setUserInteractionEnabled:YES];
        }else if (request.tag == -8){
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"没有删除成功，请稍后尝试！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
            [_btnMoreDel setUserInteractionEnabled:YES];
        }else if (request.tag == -7){
            [self showInterface];
            [self cleanInterface];
            
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"评论失败，请稍后再试。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
        }else if (request.tag == -9){
            [self showInterface];
            [self cleanInterface];
            
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"转发失败，请稍后再试。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
        }else if (request.tag == -10)/*活动页面*/{
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"该活动不存在。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
        }

    }
}

#pragma mark- 点击动态列表的评论，跳转到section置顶
-(void)scrollToTheTop{
    if (_bScoll) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        CGRect frame = [_tabDynamicDetail rectForSection:indexPath.section];
        
        if (_tabDynamicDetail.contentSize.height < self.frameHeight-self.headHeight) {
            [_tabDynamicDetail setContentSize:CGSizeMake(0, self.frameHeight-self.headHeight+frame.origin.y)];
        }   
        [_tabDynamicDetail setContentOffset:CGPointMake(0, frame.origin.y) animated:NO];
        _bScoll = NO;
    }
}

#pragma mark- 初始化输入面板
-(void)initInput:(BOOL)bComment{
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
        [btnEmoji addSignal:[DYBDynamicDetailViewController CLICKEMOJI] forControlEvents:UIControlEventTouchUpInside];
        [_viewCommentBKG addSubview:btnEmoji];
        [btnEmoji setSelected:NO];
        RELEASE(btnEmoji);
        
        UIImage *imgAT = [UIImage imageNamed:@"forward_at_def.png"];
        UIImage *imgATPress = [UIImage imageNamed:@"forward_at_press.png"];
        MagicUIButton *btnAT = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnEmoji.frame), 0, imgAT.size.width/2, imgAT.size.height/2)];
        [btnAT setTag:915];
        [btnAT setBackgroundColor:[UIColor clearColor]];
        [btnAT setBackgroundImage:imgAT forState:UIControlStateNormal];
        [btnAT setBackgroundImage:imgATPress forState:UIControlStateHighlighted];
        [btnAT addSignal:[DYBDynamicDetailViewController CLICKAT] forControlEvents:UIControlEventTouchUpInside];
        [_viewCommentBKG addSubview:btnAT];
        [btnAT setHidden:YES];
        [btnAT setSelected:NO];
        RELEASE(btnAT);
         
        UIImage *imgSend = [UIImage imageNamed:@"btn_quick_send.png"];
        UIImage *imgSendDis = [UIImage imageNamed:@"btn_quick_send_dis.png"];
        MagicUIButton *btnSend = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_txtViewComment.frame), 0, imgSend.size.width/2, imgSend.size.height/2)];
        [btnSend setBackgroundColor:[UIColor clearColor]];
        [btnSend setTag:916];
        [btnSend setBackgroundImage:imgSend forState:UIControlStateNormal];
        [btnSend setBackgroundImage:imgSendDis forState:UIControlStateDisabled];
        [btnSend addSignal:[DYBDynamicDetailViewController CLICKSEND] forControlEvents:UIControlEventTouchUpInside];
        [_viewCommentBKG addSubview:btnSend];
        [btnSend setSelected:NO];
        RELEASE(btnSend);
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        }
    }

    MagicUIButton *btnE = (MagicUIButton *)[_viewCommentBKG viewWithTag:914];
    MagicUIButton *btnA = (MagicUIButton *)[_viewCommentBKG viewWithTag:915];

    if (!bComment) {
        [_txtViewComment setText:@""];
        _nRowCount = 1;
        [btnA setHidden:NO];
        [_txtViewComment setFrame:CGRectMake(95, CGRectGetMaxY(_viewCommentBKG.frame)-43, 175, 36)];
        [_viewCommentBKG setFrame:CGRectMake(0, CGRectGetMaxY(_viewCommentBKG.frame)-50, CGRectGetWidth(self.view.frame), 50)];
        [self getShareDefaultContent];
    }else{
        [_txtViewComment setText:@""];
        _nRowCount = 1;
        [btnA setHidden:YES];
        [_txtViewComment setFrame:CGRectMake(50, CGRectGetMaxY(_viewCommentBKG.frame)-43, 220, 36)];
        [_viewCommentBKG setFrame:CGRectMake(0, CGRectGetMaxY(_viewCommentBKG.frame)-50, CGRectGetWidth(self.view.frame), 50)];
        [_txtViewComment setPlaceHolder:@"评论"];
    }
    
    [btnE setFrame:CGRectMake(CGRectGetMinX(btnE.frame), CGRectGetHeight(_viewCommentBKG.frame)-CGRectGetHeight(btnE.frame), CGRectGetWidth(btnE.frame), CGRectGetHeight(btnE.frame))];
    [btnA setFrame:CGRectMake(CGRectGetMinX(btnA.frame), CGRectGetHeight(_viewCommentBKG.frame)-CGRectGetHeight(btnA.frame), CGRectGetWidth(btnA.frame), CGRectGetHeight(btnA.frame))];
    
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
    DLogInfo(@"%f", self.view.frame.size.height);
    
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
            _btnMoreShare.selected = NO;
            _btnMoreComment.selected = NO;
        }
        
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDCHANGE]])/*textViewDidChange*/{
        DLogInfo(@"change");
        
        MagicUITextView *textView= signal.source;
        MagicUIButton *btnS = (MagicUIButton *)[_viewCommentBKG viewWithTag:916];
        
        NSString *_strContent = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([_strContent length] == 0) {
            btnS.enabled = NO;
        }else{
            btnS.enabled = YES;
        }
        
        CGSize size = [[textView text] sizeWithFont:[textView font]];
        
        // 2. 取出文字的高度
        int length = size.height;
        
        //3. 计算行数
        int colomNumber = textView.contentSize.height/length;
        
        if (colomNumber >1 &&_nRowCount != colomNumber && _nRowCount <= 2) {//最多高度扩展3行
            
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
           
            
            [btnE setFrame:CGRectMake(CGRectGetMinX(btnE.frame), CGRectGetHeight(_viewCommentBKG.frame)-CGRectGetHeight(btnE.frame), CGRectGetWidth(btnE.frame), CGRectGetHeight(btnE.frame))];
            [btnA setFrame:CGRectMake(CGRectGetMinX(btnA.frame), CGRectGetHeight(_viewCommentBKG.frame)-CGRectGetHeight(btnA.frame), CGRectGetWidth(btnA.frame), CGRectGetHeight(btnA.frame))];
            
        }
        
        [btnS setFrame:CGRectMake(CGRectGetMinX(btnS.frame), CGRectGetHeight(_viewCommentBKG.frame)-CGRectGetHeight(btnS.frame), CGRectGetWidth(btnS.frame), CGRectGetHeight(btnS.frame))];
        
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

-(void)getShareDefaultContent{
    NSString *strDefault = nil;
    
    if ([_dynamicStatus.status isKindOfClass:[NSArray class]]) {
        if (_dynamicStatus.userid  == [SHARED.curUser.userid intValue]) {
            strDefault = @"转发微博 ";
        }else{
            strDefault = [NSString stringWithFormat:@"转发微博 @%@ ", _dynamicStatus.username];
        }
        
        [_txtViewComment setText:strDefault];
        
        NSRange range = NSMakeRange(strDefault.length, 0);
        [_txtViewComment setSelectedRange:range];
        
    }else{
        strDefault = [NSString stringWithFormat:@"//@%@: %@ ", _dynamicStatus.username, _cellDetail.strContent];
        
        [_txtViewComment setText:strDefault];
        
        NSRange range = NSMakeRange(0, 0);
        [_txtViewComment setSelectedRange:range];
    }

    [_txtViewComment sendViewSignal:[MagicUITextView TEXTVIEWDIDCHANGE]];
    [_txtViewComment setContentOffset:CGPointMake(0,0) animated:YES];
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
