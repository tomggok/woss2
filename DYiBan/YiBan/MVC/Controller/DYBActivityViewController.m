//
//  DYBActivityViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBActivityViewController.h"
#import "DYBCellForActivity.h"
#import "DYBCellForDynamic.h"
#import "status_list.h"
#import "DYBPublishViewController.h"
#import "DYBDynamicDetailViewController.h"
#import "DYBCheckMultiImageViewController.h"
#import "DYBPersonalHomePageViewController.h"
#import "DYBWebViewController.h"
#import "XiTongFaceCode.h"
#import "status.h"
#import "comment_num_info.h"

@interface DYBActivityViewController ()

@end

@implementation DYBActivityViewController

DEF_SIGNAL(DYNAMICDETAIL)
DEF_SIGNAL(DYNAMICDIMAGEETAIL)
DEF_SIGNAL(DYNAMICDETAILCOMMENT)
DEF_SIGNAL(DYNAMICDETAILLIKE)
DEF_SIGNAL(DELEFRESH)
DEF_SIGNAL(PUBLISHREFRESH)
DEF_SIGNAL(DYNAMICCOMMENT)
DEF_SIGNAL(CLICKEMOJI)
DEF_SIGNAL(CLICKSEND)
DEF_SIGNAL(REMOVEQUICK)
DEF_SIGNAL(PERSONALPAGE)
DEF_SIGNAL(OPENURL)
DEF_SIGNAL(REFRESHCELL)


-(void)dealloc{
    RELEASE(_active);
    RELEASEDICTARRAYOBJ(_arrayActivity);
    RELEASEDICTARRAYOBJ(_arrayActivityCell);
    
    [super dealloc];
}

-(id)init:(active *)active{
    self = [super init];
    if (self) {
        _active = active;
        [_active retain];
    }
    return self;    
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]]){
        [self setVCBackAnimation:SWIPELASTIMAGEBACKTYPE canBackPageNumber:0];
        [self.headview setTitle:@"活动主题"];
        [self backImgType:0];
        
        if (![SHARED.curUser.verify isEqualToString:@"0"] && ![_active.enabled isEqualToString:@"0"]) {
            [self backImgType:5];
        }else{
            [self.rightButton setEnabled:NO];
        }
        
    }else if ([signal is:[MagicViewController CREATE_VIEWS]]){
        _tabActivity = [[DYBUITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.frameHeight-self.headHeight) isNeedUpdate:YES];
        [_tabActivity setTableViewType:DTableViewSlime];
        [_tabActivity setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_tabActivity];
        RELEASE(_tabActivity);
        
        nPage = 1;
        nPageSize = 10;
        bAddActivity = NO;
        
        _arrayActivity = [[NSMutableArray alloc] init];
        _arrayActivityCell = [[NSMutableArray alloc] init];
        
        MagicRequest *request = [DYBHttpMethod active_feedlist:_active.id last_id:@"0" num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] isAlert:YES receive:self];
        request.tag = -1;
    }
}

#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
//        [self.drNavigationController popVCAnimated:YES];
        [self.drNavigationController popToViewcontroller:[[self.drNavigationController allviewControllers] objectAtIndex:1] animated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        DYBPublishViewController *vc = [[DYBPublishViewController alloc] init:_active.topics activeid:_active.id bActive:YES];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
        
    }
    
}

#pragma mark- 只接受UITableView信号
static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        NSNumber *s = [NSNumber numberWithInteger:_arrayActivity.count];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if (indexPath.row == 0 && _active && !bAddActivity) {
            
            DYBCellForActivity *cell = [[[DYBCellForActivity alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[_arrayActivity objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if (![_arrayActivityCell containsObject:cell]){
                [_arrayActivityCell insertObject:cell atIndex:0];
                bAddActivity = YES;
            }
            
        }else{
            if (indexPath.row >= [_arrayActivityCell count]) {
                
                DYBCellForDynamic *cell = [[[DYBCellForDynamic alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
                [cell setContent:[_arrayActivity objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
                
                if ([SHARED.curUser.verify isEqualToString:@"0"]) {
                    
                    cell.userInteractionEnabled = NO;
                }
                
                if (![_arrayActivityCell containsObject:cell]){
                    [_arrayActivityCell addObject:cell];
                }
            }
        }
        
        
        NSNumber *s = [NSNumber numberWithInteger:((DYBCellForDynamic *)[_arrayActivityCell objectAtIndex:indexPath.row]).frame.size.height];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        [signal setReturnValue:nil];
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell=((UITableViewCell *)[_arrayActivityCell objectAtIndex:indexPath.row]);
        if (!cell)
        {
            cell=((UITableViewCell *)[_arrayActivityCell objectAtIndex:indexPath.row]);
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
    
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        nPage = 1;
        
        [self sendViewSignal:[DYBActivityViewController REMOVEQUICK]];
        [self cleanInterface];
        
        [self.view setUserInteractionEnabled:NO];
    
        MagicRequest *request = [DYBHttpMethod active_feedlist:_active.id last_id:@"0" num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] isAlert:YES receive:self];
        request.tag = -1;
        
        if (!request) {//无网路
            [_tabActivity reloadData:NO];
        }
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
        nPage ++;
        
        [self.view setUserInteractionEnabled:NO];
//        NSString *strLastID = [NSString stringWithFormat:@"%d", ((status *)[_arrayActivity lastObject]).id];
        
        MagicRequest *request = [DYBHttpMethod active_feedlist:_active.id last_id:nil num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] isAlert:YES receive:self];
        request.tag = -2;
        
        if (!request) {//无网路
            [_tabActivity reloadData:NO];
        }
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
                
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
    }
    
}

- (void)handleViewSignal_DYBActivityViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBActivityViewController DYNAMICDETAIL]]){
        [self cleanInterface];
        status *_status = (status *)[signal object];
        
        DYBDynamicDetailViewController *vc = [[DYBDynamicDetailViewController alloc] init:_status withStatus:1 bScroll:NO];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if([signal is:[DYBActivityViewController DYNAMICDIMAGEETAIL]]){
        
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
        
    }else if ([signal is:[DYBActivityViewController DYNAMICDETAILCOMMENT]]){
        [self cleanInterface];
        status *_status = (status *)[signal object];
        
        DYBDynamicDetailViewController *vc = [[DYBDynamicDetailViewController alloc] init:_status withStatus:1 bScroll:YES];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBActivityViewController DYNAMICDETAILLIKE]]){
        [self cleanInterface];
        status *_status = (status *)[signal object];
        
        DYBDynamicDetailViewController *vc = [[DYBDynamicDetailViewController alloc] init:_status withStatus:2 bScroll:YES];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBActivityViewController DELEFRESH]]){
        int nStatusID = (int)[signal object];
        int i = 0;
        
        for (status *s in _arrayActivity) {
            if ([s isKindOfClass:[status class]]) {
                if (s.id == nStatusID) {
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    [_arrayActivity removeObjectAtIndex:i];
                    [_arrayActivityCell removeObjectAtIndex:i];
                    
                    [_tabActivity beginUpdates];
                    [_tabActivity deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    [_tabActivity endUpdates];
                    break;
                }
            }
            i++;
        }
    }else if ([signal is:[DYBActivityViewController PUBLISHREFRESH]]){
        nPage = 1;
        [self.view setUserInteractionEnabled:NO];
        
        MagicRequest *request = [DYBHttpMethod active_feedlist:_active.id last_id:@"0" num:[NSString stringWithFormat:@"%d", nPageSize] page:[NSString stringWithFormat:@"%d", nPage] isAlert:YES receive:self];
        request.tag = -1;
        
    }else if ([signal is:[DYBActivityViewController DYNAMICCOMMENT]]){
        MagicUIButton *btn = (MagicUIButton *)signal.source;
        _nCurCommentRow = -1;
        _nCurCommentRow = (int)[signal object];
        
        if (btn.selected == NO) {
            [self initInput];
        }else{
            [self cleanInterface];
        }
        
        btn.selected = !btn.selected;
        
    }else if ([signal is:[DYBActivityViewController CLICKSEND]]){
        NSString *strComment = [self convertSystemEmoji:_txtViewComment.text];
        strComment = [strComment stringByReplacingOccurrencesOfString: @"\r" withString:@""];
        strComment = [strComment stringByReplacingOccurrencesOfString: @"\n" withString:@""];
        strComment = [strComment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self hiddenInterface];
        [self sendViewSignal:[DYBActivityViewController REMOVEQUICK]];
        
        if ([strComment length] > 140) {
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"超过140字数限制！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",3]];
            return;
        }
        
        if (_nCurCommentRow >= 0 && _nCurCommentRow < [_arrayActivity count]) {
            status *_Status = (status *)[_arrayActivity objectAtIndex:_nCurCommentRow];
            
            MagicRequest *request = [DYBHttpMethod status_addcomment_id:[NSString stringWithFormat:@"%d", _Status.id] content:strComment isAlert:YES receive:self];
            request.tag = -7;
        }else{
            [self showInterface];
        }
    }else if ([signal is:[DYBActivityViewController CLICKEMOJI]]){
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
    }else if ([signal is:[DYBActivityViewController REMOVEQUICK]]){
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
    }else if ([signal is:[DYBActivityViewController PERSONALPAGE]]){
        NSDictionary *dic = (NSDictionary *)[signal object];
        
        DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
        vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"username"], @"name", [dic objectForKey:@"userid"], @"userid", nil];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBActivityViewController OPENURL]]){
        NSString *streURL  = (NSString *)[signal object];
        
        DYBWebViewController *vc = [[DYBWebViewController alloc] init:streURL];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }else if ([signal is:[DYBActivityViewController REFRESHCELL]]){
        status *_Status = (status *)[signal object];
        int i = 0;
        
        for (status *s in _arrayActivity) {
            if ([s isKindOfClass:[status class]]) {
                if (s.id == _Status.id) {
                    s = _Status;
                    
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    
                    DYBCellForDynamic *cell = [[[DYBCellForDynamic alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
                    [cell setContent:_Status indexPath:indexPath tbv:_tabActivity];
                    
                    [_arrayActivityCell removeObjectAtIndex:indexPath.row];
                    [_arrayActivityCell insertObject:cell atIndex:indexPath.row];
                    
                    [_tabActivity beginUpdates];
                    [_tabActivity reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    [_tabActivity endUpdates];
                    break;
                }
            }
            i++;
        }
    }
}

#pragma mark- 消息返回处理
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{
    
    [self.view setUserInteractionEnabled:YES];
    
    if ([request succeed]){
        if (request.tag == -1){/*初始化*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                status_list *Slist = [status_list JSONReflection:respose.data];
                
                if ([_arrayActivity count] > 0) {
                    [_arrayActivity removeAllObjects];
                    [_arrayActivityCell removeAllObjects];
                    
                    bAddActivity = NO;
                }

                
                for (status *_status in Slist.status) {
                    DLogInfo(@"status.content ==== %@", _status.content);
                    [_arrayActivity addObject:(status *)_status];
                }

                [_arrayActivity insertObject:_active atIndex:0];
                
                if (Slist.havenext == 1) {
                    [_tabActivity reloadData:NO];
                }else{
                    [_tabActivity reloadData:YES];
                }
              
                if ([_arrayActivity count] > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [_tabActivity scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                
            }
        }else if (request.tag == -2){/*加载更多*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            status_list *Slist = [status_list JSONReflection:respose.data];
            if (respose.response == khttpsucceedCode) {
                status_list *Slist = [status_list JSONReflection:respose.data];
                
                for (status *_status in Slist.status) {
                    DLogInfo(@"status.content ==== %@", _status.content);
                    
                    if ([_arrayActivity count] > DynamicLimitNum) {
                        if ([_arrayActivity containsObject:_status]) {
                            [_arrayActivity removeObjectAtIndex:1];
                        }
                    }
                    
                    [_arrayActivity addObject:(status *)_status];
                }
                
                
                
            }
            if (Slist.havenext == 1 || !Slist) {
                [_tabActivity reloadData:NO];
            }else if (Slist.havenext == 0){
                [_tabActivity reloadData:YES];
            }
            
        }else if (request.tag == -7)/*列表评论*/{
            JsonResponse *respose =(JsonResponse *)receiveObj;
            if (respose.response == khttpsucceedCode){
                status *_Status = [_arrayActivity objectAtIndex:_nCurCommentRow];
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
                [cell setContent:_Status indexPath:indexPath tbv:_tabActivity];
                [_arrayActivityCell removeObjectAtIndex:_nCurCommentRow];
                [_arrayActivityCell insertObject:cell atIndex:_nCurCommentRow];
      
                [_tabActivity beginUpdates];
                [_tabActivity reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [_tabActivity endUpdates];
                
                RELEASE(cInfo);
                RELEASEDICTARRAYOBJ(arrgInfo);
                RELEASE(_Status.comment_num_info);
                [self cleanInterface];
            }
        }
    }else if ([request failed]){
        [self.view setUserInteractionEnabled:YES];
        [_tabActivity reloadData:NO];
        
        if (request.tag == -7){
            [self showInterface];
            [self cleanInterface];
            
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"评论失败，请稍后再试。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
        }    }
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
        [btnEmoji addSignal:[DYBActivityViewController CLICKEMOJI] forControlEvents:UIControlEventTouchUpInside];
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
        [btnSend addSignal:[DYBActivityViewController CLICKSEND] forControlEvents:UIControlEventTouchUpInside];
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
            [self sendViewSignal:[DYBActivityViewController REMOVEQUICK]];
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


@end
