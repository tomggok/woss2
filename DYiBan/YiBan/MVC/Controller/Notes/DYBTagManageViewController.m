//
//  DYBTagManageViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBTagManageViewController.h"
#import "DYBCellForTagManage.h"
#import "Magic_Device.h"
#import "UITableView+property.h"
#import "DYBInputView.h"
#import "ChineseToPinyin.h"
#import "pinyin.h"
#import "DYBCellForTagList.h"
#import "tag_list_info.h"
#import "DYBTabViewController.h"
#import "DYBCellForTagManage.h"

@interface DYBTagManageViewController ()

@end

@implementation DYBTagManageViewController
DEF_SIGNAL(DELTAG)

-(void)dealloc{
    RELEASEDICTARRAYOBJ(_arrayTagManage);
    RELEASEDICTARRAYOBJ(_arrayTagManageCell);
    RELEASE(_Tlist);
    
    [super dealloc];
}

-(id)initwithTagList:(tag_list *)tag_list page:(int)page{
    self = [super init];
    if (self) {
        _Tlist = tag_list;
        nPage = page;
        [_Tlist retain];
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
        nPageSize = 1000;
        
        _arrayTagManage = [[NSMutableArray alloc] init];
        _arrayTagManageCell = [[NSMutableArray alloc] init];
        _strNewTag = nil;
        
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
        
        
        if (!_Tagsearch) {
            _Tagsearch=[[MagicUISearchBar alloc]initWithFrame:CGRectMake(0, self.headHeight+1, self.view.frame.size.width, 50) backgroundColor:ColorNav placeholder:@"标签" isHideOutBackImg:YES isHideLeftView:NO];
            [_Tagsearch customBackGround:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_search"]] autorelease]];
            _Tagsearch.tag=-1;
            [_viewBKG addSubview:_Tagsearch];
            [_Tagsearch release];
        }
        
        _tabTagManage = [[DYBUITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_Tagsearch.frame), self.view.frame.size.width, self.frameHeight-self.headHeight-50) isNeedUpdate:YES];
        [_tabTagManage setBackgroundColor:[UIColor clearColor]];
        [_tabTagManage setTableViewType:DTableViewSlime];
        [_tabTagManage setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_viewBKG addSubview:_tabTagManage];
        RELEASE(_tabTagManage);
        
        if (_Tlist) {
            if ([_arrayTagManage count] > 0) {
                [_arrayTagManage removeAllObjects];
                [_arrayTagManageCell removeAllObjects];
            }
            
            for (NSDictionary *dic in _Tlist.result) {
                tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
                [_arrayTagManage addObject:(tag_list_info *)_tlInfo];
            }
            
            [_arrayTagManage sortUsingFunction :DYBtagSort context:NULL];
            
            if ([_Tlist.havenext isEqualToString:@"1"]) {
                [_tabTagManage reloadData:NO];
            }else{
                [_tabTagManage reloadData:YES];
            }
        }else{
            MagicRequest *request = [DYBHttpMethod notes_taglist:nil showcount:@"1" page:@"1" num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
            request.tag = -1;
        }
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"标签管理"];
        
        [self backImgType:0];
        [self backImgType:13];
    }
}

#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self sendViewSignal:[DYBTabViewController REFLIST] withObject:_Tlist from:self target:[[DYBUITabbarViewController sharedInstace] getFirstViewVC]];
        
        [self.drNavigationController popVCAnimated:YES];
        
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        DYBDataBankShotView *view = [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_RENAME rowNum:@"1"];
        [view changePlaceText:@"新建标签"];
    }
    
}

-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *type = [dict objectForKey:@"type"];
        NSString *row = [[dict objectForKey:@"rowNum"] description];
        
        if ([type intValue] == BTNTAG_RENAME) {
            _strNewTag = [dict objectForKey:@"text"];
            BOOL bOK = [DYBShareinstaceDelegate isOKName:_strNewTag];
            
            int lenght = [_strNewTag length];
            if (!bOK|| lenght > 6) {
                
                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"请输入6字以内的标签名" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:@"0"];
                
                return;
                
            }
            
            MagicRequest *request = [DYBHttpMethod notes_addtag:_strNewTag isAlert:YES receive:self];
            request.tag = -6;

        }else if(![row isEqualToString:@"0"]){
            MagicRequest *request = [DYBHttpMethod notes_deltag:_strTagID isAlert:YES receive:self];
            request.tag = -5;
        }
    }else if ([signal is:[DYBDataBankShotView LEFT]]){
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *type = [dict objectForKey:@"type"];
        
        if ([type intValue] != BTNTAG_RENAME){
            if (_tabTagManage._selectIndex_now.row > [_arrayTagManageCell count]) {
                return;
            }
            
            DYBCellForTagManage *cell=[_arrayTagManageCell objectAtIndex:_tabTagManage._selectIndex_now.row];
            [cell resetContentView:NO];
        }
    }
}

- (void)handleViewSignal_DYBTagManageViewController:(MagicViewSignal *)signal{
    if ([signal is:[DYBTagManageViewController DELTAG]]) {
        _strTagID = (NSString *)[signal object];

        [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"真的要删除？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
    }
    
}

#pragma mark- 只接受UITableView信号
static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        NSNumber *s = [NSNumber numberWithInteger:_arrayTagManage.count];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        
        if (indexPath.row >= [_arrayTagManageCell count]) {
            
            DYBCellForTagManage *cell = [[[DYBCellForTagManage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[_arrayTagManage objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if (![_arrayTagManageCell containsObject:cell]){
                [_arrayTagManageCell addObject:cell];
                _tabTagManage._muA_differHeightCellView = _arrayTagManageCell;
            }
        }
        
        NSNumber *s = [NSNumber numberWithInteger:((DYBCellForTagList *)[_arrayTagManageCell objectAtIndex:indexPath.row]).frame.size.height];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        [signal setReturnValue:nil];
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell=((UITableViewCell *)[_arrayTagManageCell objectAtIndex:indexPath.row]);
        if (!cell)
        {
            cell=((UITableViewCell *)[_arrayTagManageCell objectAtIndex:indexPath.row]);
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        nPage = 1;
        
        [self.view setUserInteractionEnabled:NO];
        
        MagicRequest *request = [DYBHttpMethod notes_taglist:nil showcount:@"1" page:@"1" num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
        request.tag = -1;
        
        if (!request) {//无网路
            [_tabTagManage reloadData:NO];
        }
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
        nPage ++;
        
        [self.view setUserInteractionEnabled:NO];
        
        MagicRequest *request = [DYBHttpMethod notes_taglist:nil showcount:@"1" page:[NSString stringWithFormat:@"%d", nPage] num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
        request.tag = -2;
        
        if (!request) {//无网路
            [_tabTagManage reloadData:NO];
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
        
        [_Tagsearch cancelSearch];
        
        if (_Tlist) {
            if ([_arrayTagManage count] > 0) {
                [_arrayTagManage removeAllObjects];
                [_arrayTagManageCell removeAllObjects];
            }
            
            for (NSDictionary *dic in _Tlist.result) {
                tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
                [_arrayTagManage addObject:(tag_list_info *)_tlInfo];
            }
            
            [_arrayTagManage sortUsingFunction :DYBtagSort context:NULL];
            
            if ([_Tlist.havenext isEqualToString:@"1"]) {
                [_tabTagManage reloadData:NO];
            }else{
                [_tabTagManage reloadData:YES];
            }
        }else{
            MagicRequest *request = [DYBHttpMethod notes_taglist:nil showcount:@"1" page:@"1" num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
            request.tag = -1;
        }
        
    }else if ([signal is:[MagicUISearchBar SEARCH]]){//按下搜索按钮
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
        MagicRequest *request = [DYBHttpMethod notes_taglist:search.text showcount:@"1" page:@"1" num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
        request.tag = -10;
        
    }else if ([signal is:[MagicUISearchBar CHANGEWORD]]){//内容改变
        
    }else if ([signal is:[MagicUISearchBar SEARCHING]]){
        
    }
}

NSInteger DYBtagSort(id tinfo1, id tinfo2, void *context)
{
    tag_list_info *t1 = (tag_list_info *)tinfo1;
    tag_list_info *t2 = (tag_list_info *)tinfo2;
    
    if ([t1.tag length] > 0 && [t2.tag length] > 0) {
        NSRange range = NSMakeRange(0, 1);
        NSString *strTaf1 = t1.tag;
        NSString *strTaf2 = t2.tag;
        
        if ([t1.sys isEqualToString:@"2"] && [t2.sys isEqualToString:@"2"]) {
            return NSOrderedSame;
        }else if ([t1.sys isEqualToString:@"2"]){
            return NSOrderedAscending;
        }else if ([t2.sys isEqualToString:@"2"]){
            return NSOrderedDescending;
        }else{
            NSString *subString1 = [strTaf1 substringWithRange:range];
            const char *cString1 = [subString1 UTF8String];
            
            NSString *subString2 = [strTaf2 substringWithRange:range];
            const char *cString2 = [subString2 UTF8String];
            
            if (strlen(cString1) == 3 && strlen(cString2) == 3) {
                return  [t2.tag localizedCompare:t1.tag];
            }else if (strlen(cString1) == 3 || strlen(cString2) == 3){
                NSString *str11stLetter = nil;
                NSString *str21stLetter = nil;
                
                if (strlen(cString1) == 3) {
                    str11stLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([strTaf1 characterAtIndex:0])] uppercaseString];
                    str21stLetter = [[strTaf2 substringWithRange:NSMakeRange(0, 1)] uppercaseString];
                }else{
                    str11stLetter = [[strTaf1 substringWithRange:NSMakeRange(0, 1)] uppercaseString];
                    str21stLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([strTaf2 characterAtIndex:0])] uppercaseString];
                }
                
                return [str11stLetter compare:str21stLetter];
                
            }else{
                return  [t1.tag localizedCompare:t2.tag];
            }
        }
        
        
    }
    
    return  [t1.tag localizedCompare:t2.tag];
}

#pragma mark- 消息返回处理
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{
    
    [self.view setUserInteractionEnabled:YES];
    
    if (_Tagsearch) {
        [_Tagsearch cancelSearch];
    }
    
    if ([request succeed]){
        if (request.tag == -1){/*初始化*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                _Tlist = [tag_list JSONReflection:respose.data];
                
                if ([_arrayTagManage count] > 0) {
                    [_arrayTagManage removeAllObjects];
                    [_arrayTagManageCell removeAllObjects];
                }
                
                for (NSDictionary *dic in _Tlist.result) {
                    tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
                    [_arrayTagManage addObject:(tag_list_info *)_tlInfo];
                }
                
                if (_viewWarning) {
                    REMOVEFROMSUPERVIEW(_viewWarning);
                }
                
                [_arrayTagManage sortUsingFunction:DYBtagSort context:NULL];
                
                if ([_Tlist.havenext isEqualToString:@"1"]) {
                    [_tabTagManage reloadData:NO];
                }else{
                    [_tabTagManage reloadData:YES];
                }
                
                if ([_arrayTagManage count] == 0) {
                    [self addGuidePage];
                }
                
                [_Tlist retain];
            }
        }else if (request.tag == -2){
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                tag_list *tMorelist = [tag_list JSONReflection:respose.data];
                
                for (NSDictionary *dic in tMorelist.result) {
                    tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
                    [_arrayTagManage addObject:(tag_list_info *)_tlInfo];
                }
                
                [_arrayTagManage sortUsingFunction:DYBtagSort context:NULL];
                
                if (_viewWarning) {
                    REMOVEFROMSUPERVIEW(_viewWarning);
                }
                
                if ([tMorelist.havenext isEqualToString:@"1"]) {
                    [_tabTagManage reloadData:NO];
                }else{
                    [_tabTagManage reloadData:YES];
                }
                
                if ([_arrayTagManage count] == 0) {
                    [self addGuidePage];
                }
            }
            
        }else if (request.tag == -5){/*删除Tag*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                DLogInfo(@"respose.data == %@", [respose.data objectForKey:@"result"]);
                int nResult = [[respose.data objectForKey:@"result"] intValue];
                if (nResult == 1) {
                    int nStatusID = [_strTagID intValue];
                    int i = 0;
                    
                    
                    for (NSDictionary *dic in _Tlist.result) {
                        tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
                        
                        if ([_tlInfo.tag_id intValue] == nStatusID) {
                            [((NSMutableArray *)_Tlist.result) removeObject:dic];
                            break;
                        }
                    }
                    
                    for (tag_list_info *s in _arrayTagManage) {
                        if ([s isKindOfClass:[tag_list_info class]]) {
                            if ([s.tag_id intValue] == nStatusID) {
                                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                                [_arrayTagManage removeObjectAtIndex:i];
                                [_arrayTagManageCell removeObjectAtIndex:i];
                                
                                [_tabTagManage beginUpdates];
                                [_tabTagManage deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                [_tabTagManage endUpdates];
                                break;
                            }
                        }
                        i++;
                    }
                }else{
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"删除失败，请稍后再试。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
                }
                
                _strTagID  = nil;
            }
        }else if (request.tag == -6){/*新建Tag*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                DLogInfo(@"respose.data == %@", [respose.data objectForKey:@"result"]);
                int nResult = [[respose.data objectForKey:@"result"] intValue];
                if (nResult == 1) {
                    
                    tag_list_info *_tlInfo = [[[tag_list_info alloc] init] autorelease];
                    _tlInfo.count = @"0";
                    _tlInfo.tag = _strNewTag;
                    _tlInfo.tag_id = [respose.data objectForKey:@"tag_id"];
                    _tlInfo.sys = @"1";
                    
                    NSDictionary *dic = [[[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"count", _strNewTag, @"tag", [respose.data objectForKey:@"tag_id"], @"tag_id", @"1", @"sys", nil] autorelease];
                    
                    
                    if (_viewWarning) {
                        REMOVEFROMSUPERVIEW(_viewWarning);
                        
                        if (_Tlist) {
                            if ([_arrayTagManage count] > 0) {
                                [_arrayTagManage removeAllObjects];
                            }
                            
                            for (NSDictionary *dic in _Tlist.result) {
                                tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
                                [_arrayTagManage addObject:(tag_list_info *)_tlInfo];
                            }
                        }
                    }
                    
                    [((NSMutableArray *)_Tlist.result) addObject:dic];
                    [_arrayTagManage addObject:(tag_list_info *)_tlInfo];
                    [_arrayTagManage sortUsingFunction:DYBtagSort context:NULL];
                    [_arrayTagManageCell removeAllObjects];
                    
                    if ([_Tlist.havenext isEqualToString:@"1"]) {
                        [_tabTagManage reloadData:NO];
                    }else{
                        [_tabTagManage reloadData:YES];
                    }
                    
                    _strNewTag = nil;
                    
                }else{
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"新建失败，请稍后再试。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
                }
            }
        }else if (request.tag == -10){/*初始化*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                tag_list *_TSlist = [tag_list JSONReflection:respose.data];
                
                if ([_arrayTagManage count] > 0) {
                    [_arrayTagManage removeAllObjects];
                    [_arrayTagManageCell removeAllObjects];
                }
                
                for (NSDictionary *dic in _TSlist.result) {
                    tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
                    [_arrayTagManage addObject:(tag_list_info *)_tlInfo];
                }
                
                if (_viewWarning) {
                    REMOVEFROMSUPERVIEW(_viewWarning);
                }
                
                [_arrayTagManage sortUsingFunction:DYBtagSort context:NULL];
                
                if ([_TSlist.havenext isEqualToString:@"1"]) {
                    [_tabTagManage reloadData:NO];
                }else{
                    [_tabTagManage reloadData:YES];
                }
                
                if ([_arrayTagManage count] == 0) {
                    [self addGuidePage];
                }
            }
        }
    }else if ([request failed]){
        [self.view setUserInteractionEnabled:YES];
        
        if (request.tag == -6) {
                [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"新建失败，请稍后再试。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
        }
    }
}

-(void)addGuidePage{
    if(!_viewWarning){
        _viewWarning= [[UIView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(_tabTagManage.frame), self.frameHeight-self.headHeight)];
        [_viewWarning setBackgroundColor:[UIColor clearColor]];
        [_tabTagManage addSubview:_viewWarning];
        RELEASE(_viewWarning);
        
        MagicUILabel *labWarning = [[MagicUILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-250)/2, 0, 250, 60)];
        [labWarning setBackgroundColor:[UIColor clearColor]];
        [labWarning setText:@"一条标签也没有\n请猛戳右上角的按钮来新建"];
        [labWarning setNumberOfLines:2];
        [labWarning setTextColor:ColorGray];
        [labWarning setFont:[DYBShareinstaceDelegate DYBFoutStyle:20]];
        [labWarning setTextAlignment:NSTextAlignmentCenter];
        [labWarning setUserInteractionEnabled:YES];
        
        UIImage *image = [UIImage imageNamed:@"ybx_big.png"];
        float BearHeadStartX = (CGRectGetWidth(self.view.frame)-image.size.width/2)/2;
        float BearHeadStartY = (self.frameHeight-self.headHeight-image.size.height/2 - 150)/2-44;
        MagicUIImageView *viewBearHead = [[MagicUIImageView alloc] initWithFrame:CGRectMake(BearHeadStartX, BearHeadStartY, image.size.width/2, image.size.height/2)];
        [viewBearHead setBackgroundColor:[UIColor clearColor]];
        [viewBearHead setImage:image];
        [viewBearHead setUserInteractionEnabled:YES];
        
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

@end
