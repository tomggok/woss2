//
//  DYBTagNotesViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-11-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBTagNotesViewController.h"
#import "DYBTagManageViewController.h"
#import "Magic_Device.h"
#import "UITableView+property.h"
#import "DYBInputView.h"
#import "noteModel.h"
#import "DYBCellForNotes.h"
#import "DYBNoteDetailViewController.h"
#import "UserSettingMode.h"
#import "DYBSelectContactViewController.h"
#import "DYBNoteDetailViewController.h"
#import "UIView+MagicCategory.h"

@interface DYBTagNotesViewController ()

@end

@implementation DYBTagNotesViewController

DEF_SIGNAL(REFRESHTB)

-(void)dealloc{
    RELEASEDICTARRAYOBJ(_arrayTagNotes);
    RELEASEDICTARRAYOBJ(_arrayTagNotesCell);
    RELEASE(_tag_info);
    
    if (_strSearchText) {
        RELEASE(_strSearchText);
    }
    
    [super dealloc];
}


-(id)initwithTaginfo:(tag_list_info *)tag_info{
    self = [super init];
    if (self) {
        _tag_info = tag_info;
        [_tag_info retain];
    }
    return self;
    
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        if (nPage <= 0) {
            nPage = 1;
        }
        nPageSize = 10;
        
        _arrayTagNotes = [[NSMutableArray alloc] init];
        _arrayTagNotesCell = [[NSMutableArray alloc] init];
        _strSearchText = nil;
        
        MagicUIImageView *_viewBKG = [[MagicUIImageView alloc] initWithFrame:self.view.bounds];
        [_viewBKG setBackgroundColor:[UIColor clearColor]];
        [_viewBKG setUserInteractionEnabled:YES];
        
        if ([MagicDevice boundSizeType]==1) {
            [_viewBKG setImage:[UIImage imageNamed:@"bg_note_ip5.png"]];
        }else{
            [_viewBKG setImage:[UIImage imageNamed:@"bg_note.png"]];
        }
        
        [self.view addSubview:_viewBKG];
        RELEASE(_viewBKG);
        
        
        if (!_TagNoteSearch) {
            _TagNoteSearch=[[MagicUISearchBar alloc]initWithFrame:CGRectMake(0, self.headHeight+1, self.view.frame.size.width, 50) backgroundColor:ColorNav placeholder:@"标签" isHideOutBackImg:YES isHideLeftView:NO];
            [_TagNoteSearch customBackGround:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_search"]] autorelease]];
            _TagNoteSearch.tag=-1;
            [_viewBKG addSubview:_TagNoteSearch];
            [_TagNoteSearch release];
        }
        
        _tabTagNotes = [[DYBUITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_TagNoteSearch.frame), self.view.frame.size.width, self.frameHeight-self.headHeight-50) isNeedUpdate:YES];
        [_tabTagNotes setBackgroundColor:[UIColor clearColor]];
        [_tabTagNotes setTableViewType:DTableViewSlime];
        [_tabTagNotes setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_viewBKG addSubview:_tabTagNotes];
        RELEASE(_tabTagNotes);
        
        MagicRequest *request = [DYBHttpMethod notes_listByKeywords:_tag_info.tag tagid:@"" favorite:@"0" page:[NSString stringWithFormat:@"%d", nPage] num:[NSString stringWithFormat:@"%d", nPageSize] searchmonth:@"" delnum:@"" isAlert:YES receive:self];
        [request setTag:-1];

        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:_tag_info.tag];
        
        [self backImgType:0];
        [self backImgType:12];
    }
}

#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        DYBNoteDetailViewController *vc = [[DYBNoteDetailViewController alloc] init];
        [self.drNavigationController pushViewController:vc animated:YES];
        vc.isEditing=YES;
        [vc initWithTags:@[_tag_info]];
        
        RELEASE(vc);    
    }
    
}

#pragma mark- 接受其他信号
- (void)handleViewSignal_DYBTagNotesViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBTagNotesViewController REFRESHTB]]){
        [self sendViewSignal:[MagicUITableView TABLEVIEWUPDATA]];
    }
}

#pragma mark- 只接受UITableView信号
static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        NSNumber *s = [NSNumber numberWithInteger:_arrayTagNotes.count];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        
        if (indexPath.row >= [_arrayTagNotesCell count]) {
            
            DYBCellForNotes *cell = [[[DYBCellForNotes alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[_arrayTagNotes objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if (![_arrayTagNotesCell containsObject:cell]){
                [_arrayTagNotesCell addObject:cell];
            }
        }
        
        NSNumber *s = [NSNumber numberWithInteger:((DYBCellForNotes *)[_arrayTagNotesCell objectAtIndex:indexPath.row]).frame.size.height];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        [signal setReturnValue:nil];
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell=((UITableViewCell *)[_arrayTagNotesCell objectAtIndex:indexPath.row]);
        if (!cell)
        {
            cell=((UITableViewCell *)[_arrayTagNotesCell objectAtIndex:indexPath.row]);
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        noteModel *model=[_arrayTagNotes objectAtIndex:indexPath.row];
        
        if (model.type==0) {
            DYBNoteDetailViewController *vc = [[DYBNoteDetailViewController alloc] init];
            
            vc.str_nid=model.nid;
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
        }
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        nPage = 1;
        _strSearchText = nil;
        
        [self.view setUserInteractionEnabled:NO];
        
        MagicRequest *request = [DYBHttpMethod notes_listByKeywords:_tag_info.tag tagid:@"" favorite:@"0" page:[NSString stringWithFormat:@"%d", nPage] num:[NSString stringWithFormat:@"%d", nPageSize] searchmonth:@""  delnum:@"" isAlert:YES receive:self];
        [request setTag:-1];
        
        if (!request) {//无网路
            [_tabTagNotes reloadData:NO];
        }
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
        nPage ++;
        
        [self.view setUserInteractionEnabled:NO];
        
        MagicRequest *request = nil;
        
        if ([_strSearchText length] == 0) {
            request = [DYBHttpMethod notes_listByKeywords:_tag_info.tag tagid:@"" favorite:@"0" page:[NSString stringWithFormat:@"%d", nPage] num:[NSString stringWithFormat:@"%d", nPageSize] searchmonth:@"" delnum:@"" isAlert:YES receive:self];
            [request setTag:-2];
        }else{
            request = [DYBHttpMethod notes_listByKeywords:_strSearchText tagid:_tag_info.tag_id favorite:@"0" page:[NSString stringWithFormat:@"%d", nPage] num:[NSString stringWithFormat:@"%d", nPageSize] searchmonth:@"" delnum:@"" isAlert:YES receive:self];
            request.tag = -11;
        }
        
        if (!request) {//无网路
            [_tabTagNotes reloadData:NO];
        }
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
        [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [[DYBUITabbarViewController sharedInstace] hideTabBar:NO animated:YES];
        
    }
    
}

#pragma mark- 只接受searchBar信号
- (void)handleViewSignal_MagicUISearchBar:(MagicViewSignal *)signal{
    if ([signal is:[MagicUISearchBar BEGINEDITING]]) {//第一次按下搜索框
        
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        {
            search.showsScopeBar = YES;//控制搜索栏下部的选择栏是否显示出来
            [search setShowsCancelButton:YES animated:YES];
            [search initShadeBt];
            [search initCancelBt:[UIImage imageNamed:@"btn_search_cancel"] HighlightedImg:[UIImage imageNamed:@"btn_search_cancel"]];
            
        }
        
    }else if ([signal is:[MagicUISearchBar CANCEL]]){//
        
        [_TagNoteSearch cancelSearch];
        
        _strSearchText = nil;
        
        if (_notes_list) {
            if ([_arrayTagNotes count] > 0) {
                [_arrayTagNotes removeAllObjects];
                [_arrayTagNotesCell removeAllObjects];
            }
            
            for (NSDictionary *dic in _notes_list.result) {
                noteModel *_tlInfo = [noteModel JSONReflection:dic];
                _tlInfo.cellH=140;
                [_arrayTagNotes addObject:(noteModel *)_tlInfo];
            }
            
            if (_viewWarning) {
                REMOVEFROMSUPERVIEW(_viewWarning);
            }
            
            if ([_notes_list.havenext isEqualToString:@"1"]) {
                [_tabTagNotes reloadData:NO];
            }else{
                [_tabTagNotes reloadData:YES];
            }
            
            if ([_arrayTagNotes count] == 0) {
                [self addGuidePage];
            }
        }else{
            nPage = 1;
            
            MagicRequest *request = [DYBHttpMethod notes_listByKeywords:_tag_info.tag tagid:@"" favorite:@"0" page:[NSString stringWithFormat:@"%d", nPage] num:[NSString stringWithFormat:@"%d", nPageSize] searchmonth:@"" delnum:@"" isAlert:YES receive:self];
            [request setTag:-1];
        }
        
    }else if ([signal is:[MagicUISearchBar SEARCH]]){//按下搜索按钮
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        _strSearchText = [NSString stringWithFormat:@"%@", search.text];
        [_strSearchText retain];
        
        MagicRequest *request = [DYBHttpMethod notes_listByKeywords:search.text tagid:_tag_info.tag_id favorite:@"0" page:@"1" num:[NSString stringWithFormat:@"%d", nPageSize] searchmonth:@"" delnum:@"" isAlert:YES receive:self];
        request.tag = -10;
        
    }else if ([signal is:[MagicUISearchBar CHANGEWORD]]){//内容改变
        
    }else if ([signal is:[MagicUISearchBar SEARCHING]]){
        
    }
}

-(void)addGuidePage{
    if(!_viewWarning){
        _viewWarning= [[UIView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(_tabTagNotes.frame), self.frameHeight-self.headHeight)];
        [_viewWarning setBackgroundColor:[UIColor clearColor]];
        [_tabTagNotes addSubview:_viewWarning];
        RELEASE(_viewWarning);
        
        MagicUILabel *labWarning = [[MagicUILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2, 0, 200, 60)];
        [labWarning setBackgroundColor:[UIColor clearColor]];
        [labWarning setText:@"一条笔记也没有\n请猛戳右上角的加号"];
        [labWarning setNumberOfLines:2];
        [labWarning setTextColor:ColorGray];
        [labWarning setFont:[DYBShareinstaceDelegate DYBFoutStyle:20]];
        [labWarning setTextAlignment:NSTextAlignmentCenter];
        
        UIImage *image = [UIImage imageNamed:@"ybx_big.png"];
        float BearHeadStartX = (CGRectGetWidth(self.view.frame)-image.size.width/2)/2;
        float BearHeadStartY = (self.frameHeight-self.headHeight-image.size.height/2 - 150)/2-44;
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
        
        [self sendViewSignal:[DYBBaseViewController NEXTSTEPBUTTON]];
        
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

#pragma mark- 消息返回处理
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{
    
    [self.view setUserInteractionEnabled:YES];
    
    if (_TagNoteSearch) {
        [_TagNoteSearch cancelSearch];
    }
    
    if ([request succeed]){
        if (request.tag == -1){/*初始化*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                _notes_list = [notes_list JSONReflection:respose.data];
                
                if ([_arrayTagNotes count] > 0) {
                    [_arrayTagNotes removeAllObjects];
                    [_arrayTagNotesCell removeAllObjects];
                }
                
                for (NSDictionary *dic in _notes_list.result) {
                    noteModel *_tlInfo = [noteModel JSONReflection:dic];
                    _tlInfo.cellH=140;
                    [_arrayTagNotes addObject:(noteModel *)_tlInfo];
                }
                
                if (_viewWarning) {
                    REMOVEFROMSUPERVIEW(_viewWarning);
                }
                
                if ([_notes_list.havenext isEqualToString:@"1"]) {
                    [_tabTagNotes reloadData:NO];
                }else{
                    [_tabTagNotes reloadData:YES];
                }
                
                if ([_arrayTagNotes count] == 0) {
                    [self addGuidePage];
                }
                
                [_notes_list retain];
                
            }
        }else if (request.tag == -2){
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                notes_list *tMorelist = [notes_list JSONReflection:respose.data];
                
                for (NSDictionary *dic in tMorelist.result) {
                    noteModel *_tlInfo = [noteModel JSONReflection:dic];
                    _tlInfo.cellH=140;
                    [_arrayTagNotes addObject:(tag_list_info *)_tlInfo];
                }
                
                if (_viewWarning) {
                    REMOVEFROMSUPERVIEW(_viewWarning);
                }
                
                if ([tMorelist.havenext isEqualToString:@"1"]) {
                    [_tabTagNotes reloadData:NO];
                }else{
                    [_tabTagNotes reloadData:YES];
                }
                
                if ([_arrayTagNotes count] == 0) {
                    [self addGuidePage];
                }
                
            }
            
        }else if (request.tag == -3){
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                if ([[response.data objectForKey:@"result"] intValue]==1) {//成功
                    //
                    DYBCellForNotes *cell=[_arrayTagNotesCell objectAtIndex: _Noteindex.row];
                    [cell changeStar:[[response.data objectForKey:@"result"] intValue]];
                    
                    noteModel *model=[_arrayTagNotes objectAtIndex: _Noteindex.row];
                    model.favorite=[response.data objectForKey:@"result"];
                    
                    [DYBShareinstaceDelegate loadFinishAlertView:@"收藏成功" target:self];
                }else{
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"收藏失败，请稍后再试。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
                }
                
                _Noteindex = nil;
            }
        }else if (request.tag == -4){
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                if ([[response.data objectForKey:@"result"] intValue]==1) {//成功
                    //
                    DYBCellForNotes *cell=[_arrayTagNotesCell objectAtIndex: _Noteindex.row];
                    [cell changeStar:0];
                    
                    noteModel *model=[_arrayTagNotes objectAtIndex: _Noteindex.row];
                    model.favorite = 0;
                }else{
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"取消收藏失败，请稍后再试。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
                }
                
                _Noteindex = nil;
            }
        }else if (request.tag == -5){
            JsonResponse *respose = (JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                DLogInfo(@"respose.data == %@", [respose.data objectForKey:@"result"]);
                int nResult = [[respose.data objectForKey:@"result"] intValue];
                if (nResult == 1) {
                    int i = 0;
                
                    for (NSDictionary *dic in _notes_list.result) {
                        noteModel *_tlInfo = [noteModel JSONReflection:dic];
                        
                        if ([_tlInfo.nid isEqualToString:_strNoteID]) {
                            [((NSMutableArray *)_notes_list.result) removeObject:dic];
                            break;
                        }
                    }
                    
                    for (noteModel *s in _arrayTagNotes) {
                        if ([s isKindOfClass:[noteModel class]]) {
                            if ([s.nid isEqualToString:_strNoteID]) {
                                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                                [_arrayTagNotes removeObjectAtIndex:i];
                                [_arrayTagNotesCell removeObjectAtIndex:i];
                                
                                [_tabTagNotes beginUpdates];
                                [_tabTagNotes deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                [_tabTagNotes endUpdates];
                                break;
                            }
                        }
                        i++;
                    }
                    
                    _strNoteID  = nil;
                }else{
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"删除失败，请稍后再试。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
                }
            }

        }else if (request.tag == -6){
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                if ([[response.data objectForKey:@"result"] intValue]==1) {//成功
                    if (SHARED.currentUserSetting.notesSaveForPush) {//删除原笔迹
                        [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"成功转存至资料库,原笔记已自动删除" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
                    }else{
                        [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"成功转存至资料库,原笔记已保留" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE];
                    }
                    return;
                }
            }else if ([response response] ==khttpfailCode){
                
            }
            
        }else if (request.tag == -10){/*初始化*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                notes_list *_nlist = [notes_list JSONReflection:respose.data];
                
                if ([_arrayTagNotes count] > 0) {
                    [_arrayTagNotes removeAllObjects];
                    [_arrayTagNotesCell removeAllObjects];
                }
                
                for (NSDictionary *dic in _nlist.result) {
                    noteModel *_tlInfo = [noteModel JSONReflection:dic];
                    _tlInfo.cellH=140;
                    [_arrayTagNotes addObject:(noteModel *)_tlInfo];
                }
                
                if (_viewWarning) {
                    REMOVEFROMSUPERVIEW(_viewWarning);
                }
                
                if ([_nlist.havenext isEqualToString:@"1"]) {
                    [_tabTagNotes reloadData:NO];
                }else{
                    [_tabTagNotes reloadData:YES];
                }
                
                if ([_arrayTagNotes count] == 0) {
                    [self addGuidePage];
                }
            }
        }else if (request.tag == -11){/*加载更多*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                notes_list *_nlist = [notes_list JSONReflection:respose.data];
                
                for (NSDictionary *dic in _nlist.result) {
                    noteModel *_tlInfo = [noteModel JSONReflection:dic];
                    _tlInfo.cellH=140;
                    [_arrayTagNotes addObject:(noteModel *)_tlInfo];
                }
                
                if (_viewWarning) {
                    REMOVEFROMSUPERVIEW(_viewWarning);
                }
                
                if ([_nlist.havenext isEqualToString:@"1"]) {
                    [_tabTagNotes reloadData:NO];
                }else{
                    [_tabTagNotes reloadData:YES];
                }
            }
        }

        
    }else if ([request failed]){
        [self.view setUserInteractionEnabled:YES];
        
        
    }
}

-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        NSDictionary *dicType = (NSDictionary *)[signal object];
        NSString *strType = [dicType objectForKey:@"type"];
        
        if ([strType intValue] == BTNTAG_DEL){//HTTP请求
            MagicRequest *request = [DYBHttpMethod notes_delnote:_strNoteID isAlert:YES receive:self];
            [request setTag:-5];
        }
    }
}

#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal{
    if ([signal is:[UIView TAP]]) {
        UIView *v=signal.source;
        switch (v.tag) {
            case 1://添加|取消收藏
            {
                NSDictionary *d=(NSDictionary *)signal.object;
                
                noteModel *model=[d valueForKeyPath:@"object.model"];
                if ([model.favorite intValue]==0) {//HTTP请求,收藏
                    MagicRequest *request = [DYBHttpMethod notes_addfavorite:model.nid isAlert:YES receive:self];
                    [request setTag:-3];
                }else{
                    MagicRequest *request = [DYBHttpMethod notes_delfavorite:model.nid isAlert:YES receive:self];
                    [request setTag:-4];
                }
            }
                break;
        }
    }
}

#pragma mark- 按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        
        if (bt)
        {
            switch (bt.tag) {
                    
                case -3://删除笔记
                {
                    NSIndexPath *index=(NSIndexPath *)signal.object;
                    noteModel *model=[_arrayTagNotes objectAtIndex:index.row];
                    _strNoteID = model.nid;
                    
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"真的要删除？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
                }
                    break;
                case -4://星标
                {
                    NSIndexPath *index=(NSIndexPath *)signal.object;
                    _Noteindex = index;
                    noteModel *model=[_arrayTagNotes objectAtIndex:index.row];
                    
                    DYBCellForNotes *cell=[_arrayTagNotesCell objectAtIndex:index.row];
                    [cell resetContentView];

                    if ([model.favorite intValue]==0) {//HTTP请求,收藏
                        MagicRequest *request = [DYBHttpMethod notes_addfavorite:model.nid isAlert:YES receive:self];
                        [request setTag:-3];
                    }else{
                        MagicRequest *request = [DYBHttpMethod notes_delfavorite:model.nid isAlert:YES receive:self];
                        [request setTag:-4];
                    }
                }
                    break;
                case -5://转存
                {
                    NSIndexPath *index=(NSIndexPath *)signal.object;
                    noteModel *model=[_arrayTagNotes objectAtIndex:index.row];
                    
                    {//HTTP请求
                        MagicRequest *request = [DYBHttpMethod notes_dumpnote:model.nid del:((SHARED.currentUserSetting.notesSaveForPush)?(@"1"):(@"0")) isAlert:YES receive:self];
                        [request setTag:-6];
                    }
                }
                    break;
                case -6://共享
                {
                    NSIndexPath *index=(NSIndexPath *)signal.object;
                    
                    if ([_arrayTagNotes count]>index.row) {
                        noteModel *model=[_arrayTagNotes objectAtIndex:index.row];
                        
                        DYBSelectContactViewController *classM = [[DYBSelectContactViewController alloc]init];
                        classM.nid=model.nid;
                        classM.bEnterDataBank=YES;
                        [self.drNavigationController pushViewController:classM animated:YES];
                        RELEASE(classM);
                    }
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}

@end
