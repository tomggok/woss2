//
//  DYBDtaBankSearchView.m
//  DYiBan
//
//  Created by tom zeng on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDtaBankSearchView.h"
#import "DYBDataBankListCell.h"
#import "UIView+MagicCategory.h"
#import "DYBDataBankChildrenListViewController.h"
#import "DYBDataBankFileDetailViewController.h"
#import "DYBDataBankShareEnterView.h"
#import "DYBDataBankDownloadManageViewController.h"
#import "DYBDataBankListCell.h"
#import "DYBSignViewController.h"
#import "UITableView+property.h"


#define  NORESULTVIEW   102
#define  SEATCHBTN_TAG 120
#define  OPEARTIONTAG  101
#define  BACKBG_TAG    890

@implementation DYBDtaBankSearchView{

    NSString *strKeyword;
    NSString *strEncodeUrl;
    NSMutableArray *arrTag;
    NSMutableArray *arrName;
    NSMutableArray *arrContent;
   
    int page;
    int num;
    int badRow;
    int goodRow;
    BOOL isNETSearch;
    int iSelectRow;
    
    NSMutableArray *arraySearchResult;
    NSMutableDictionary *dictSearchResult;
    NSMutableArray *arrayCell;
}

@synthesize arrayResourcesList,arrayViewCell = _arrayViewCell,iCellType = _iCellType;
@synthesize tbDataBank,searchbar = _searchbar, VC = _VC,slideHideView = _slideHideView;
@synthesize iOrder = _iOrder,iBtnType = _iBtnType,badBtn = _badBtn,goodBtn = _goodBtn;
@synthesize current_dir = _current_dir,strTarget = _strTarget;

DEF_SIGNAL(FIRSTTOUCH)
DEF_SIGNAL(RECOVERBAR)
DEF_SIGNAL(TOUCHSIGLEBTN)
DEF_SIGNAL(BEGINEDITING)
DEF_SIGNAL(NEWNAME)
DEF_SIGNAL(DELOBJ)
DEF_SIGNAL(CANCELSHARE)

- (id)initWithFrame:(CGRect)frame object:(id)object
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self initView:frame];
        _VC = object;
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame slideView:(UIView *)slideView{
    
    _slideHideView = slideView;
    
    id obj = [self initWithFrame:frame];
    
    return obj;
}
-(void)initView:(CGRect)frame{

    strKeyword = [[NSString alloc]init];
    strEncodeUrl = [[NSString alloc]init];
    arrayCell = [[NSMutableArray alloc]init];
    
    page = 1;
    num = 100;
    isNETSearch = NO;
    iSelectRow = 0;
    badRow = 0;
    goodRow = 0;
    
    _searchbar = [[MagicUISearchBar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame)) backgroundColor:[UIColor clearColor] placeholder:@"文件名" isHideOutBackImg:NO isHideLeftView:NO];
    for (UIView *subview in [_searchbar subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
        }else if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            [(UITextField *)subview setBackground:[UIImage imageNamed:@"bg_search"]];
            
        }else if ([subview isKindOfClass:[UIButton class]]){
        
        
        }
    }
    [_searchbar setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
    [_searchbar setUserInteractionEnabled:YES];
    [self addSubview:_searchbar];
//    [_searchbar release]; // 异常 报错
    
    tbDataBank = [[DYBUITableView alloc]initWithFrame:CGRectMake(0.0f, _searchbar.frame.origin.y + _searchbar.frame.size.height , 320.0f, self.frame.size.height - _searchbar.frame.origin.y - _searchbar.frame.size.height ) isNeedUpdate:YES];
    [tbDataBank setBackgroundColor:[UIColor clearColor]];
    [tbDataBank setHidden:YES];
    [tbDataBank setTableViewType:DTableViewSlime];
    [self addSubview:tbDataBank];
    [tbDataBank setSeparatorColor:[UIColor clearColor]];
    tbDataBank.v_headerVForHide = _searchbar;
    [tbDataBank release];
        
    arraySearchResult = [[NSMutableArray alloc]init];
    dictSearchResult = [[NSMutableDictionary alloc]init];

    UIButton *btnSearch = [[UIButton alloc]initWithFrame:CGRectMake(320-96/2, (SEARCHBAT_HIGH - 60/2)/2, 60/2, 60/2)];
    [btnSearch setBackgroundColor:[UIColor clearColor]];
    [btnSearch setTag:SEATCHBTN_TAG];
    [btnSearch setHidden:NO];
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_search_cancel"] forState:UIControlStateNormal];
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_search_cancel"] forState:UIControlStateHighlighted];
    [btnSearch addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    [_searchbar addSubview:btnSearch];
    RELEASE(btnSearch);
    
}

-(void)setFrame:(CGRect)frame{

    [super setFrame:frame];
    
    UIButton *viewBtn = (UIButton *)[self viewWithTag:BACKBG_TAG];
    if (!viewBtn) {
        
        viewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0, 0,0)];
        [viewBtn setTag:BACKBG_TAG];
        [viewBtn setAlpha:0.7];
//        [viewBtn addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
        [viewBtn setBackgroundColor:[UIColor blackColor]];
        [self insertSubview:viewBtn atIndex:0];
        RELEASE(viewBtn);
        
        
    }else{
    
        [viewBtn setFrame:CGRectMake(0.0f, 0.0, frame.size.width, frame.size.height)];
    }
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)doCancel{
    
    UIView *viewNoResult = [self viewWithTag:NORESULTVIEW];
    if (viewNoResult) {
     
        [viewNoResult removeFromSuperview];
    }
    
    [arraySearchResult removeAllObjects];
    [arrayCell removeAllObjects];

    [_searchbar setText:@""];
    
    [_searchbar resignFirstResponder];

    [tbDataBank reloadData];
    
    UIView *view = [_searchbar viewWithTag:SEATCHBTN_TAG]; //移除searchbtn
    if (view) {
        [view setHidden:YES];
    }
    
    UIButton *viewBtn = (UIButton *)[self viewWithTag:BACKBG_TAG]; //移除背景
    if (viewBtn) {
        
        [viewBtn removeFromSuperview];
    }

    
    [self sendViewSignal:[DYBDtaBankSearchView RECOVERBAR] withObject:nil from:self];
    
    [((DYBBaseViewController *)[self superCon]).rightButton setHidden:NO];
    
    [_searchbar setShowsCancelButton:NO animated:YES];
}

-(void)hideKeyBoard{
    
    [_searchbar setShowsCancelButton:NO animated:YES];
    [_searchbar setText:@""];
    [_searchbar resignFirstResponder];
    
    UIView *view = [_searchbar viewWithTag:SEATCHBTN_TAG]; //移除searchbtn
    if (view) {
        [view setHidden:YES];
    }
    [self setFrame:CGRectMake(0.0f, self.frame.origin.y, 320.0f, SEARCHBAT_HIGH)];
    [tbDataBank setHidden:YES];
    
    [tbDataBank StretchingUpOrDown:1];
    [DYBShareinstaceDelegate opeartionTabBarShow:NO];
}

-(void)handleViewSignal_MagicUISearchBar:(MagicViewSignal *)signal{
    
    
    if ([signal is:[MagicUISearchBar BEGINEDITING]]) {
        
//        [arraySearchResult removeAllObjects]; //清除内容

         [((DYBBaseViewController *)[self superCon]).rightButton setHidden:YES];
        UIButton *btnSearch = (UIButton *)[_searchbar viewWithTag:SEATCHBTN_TAG];
       
        if (btnSearch) {
            [btnSearch setHidden:NO];
        }
        
        MagicUISearchBar *obj = (MagicUISearchBar *)[signal object];
        [obj setShowsCancelButton:YES];
       
       
        [self sendViewSignal:[DYBDtaBankSearchView FIRSTTOUCH] withObject:nil from:self];
        
        [tbDataBank setBackgroundColor:[UIColor clearColor]];
        
        UIButton *view = (UIButton *)[self viewWithTag:BACKBG_TAG];
        if (view) {
            
            if (view.hidden) {
                
                 [self setBackgroundColor:[UIColor whiteColor]];
            }
            
        }
        
    }else if([signal is:[MagicUISearchBar CANCEL]]){
        
        MagicUISearchBar *obj = (MagicUISearchBar *)[signal object];
        [obj resignFirstResponder];
        [obj setShowsCancelButton:YES];
        [self sendViewSignal:[DYBDtaBankSearchView RECOVERBAR] withObject:nil from:self];
        
        
        UIButton *viewBtn = (UIButton *)[self viewWithTag:BACKBG_TAG];
        if (!viewBtn) {
        
            [viewBtn removeFromSuperview];
        
        }
        
         [((DYBBaseViewController *)[self superCon]).rightButton setHidden:NO];
        
    }else if([signal is:[MagicUISearchBar SEARCH]]){
        
        
        
        MagicUISearchBar *obj = (MagicUISearchBar *)[signal object];
        [obj resignFirstResponder];
        [obj setShowsCancelButton:YES];
//        [self addOBjToArray:obj.text];
        
        strKeyword = obj.text;
        page = 1;
        
        [self resolutionRequest:1]; //根据搜索的文字，请求网络
        
        
        
    }else if ([signal is:[MagicUISearchBar CHANGEWORD]]){
    
//        MagicUISearchBar *search=(MagicUISearchBar *)signal.source;
//        [self addOBjToArray:search.text];
        
    }
    
    
}

-(void)resolutionRequest:(int)tag{

    MagicRequest *request = nil;
    
    int asc = 1;
    if (_iOrder == 1) {
        asc = 2;
    }else{
    
        asc = 1;
    }
    
    if ([[self superCon] isKindOfClass:[DYBDataBankShareViewController class]]) {
        
        switch (_iBtnType) {
            case SomeoneShowToME:
            {
                request = [DYBHttpMethod share_formelist_target:_strTarget order:[NSString stringWithFormat:@"%d",_iOrder] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:strKeyword asc:[NSString stringWithFormat:@"%d",asc]  isAlert:NO receive:self];
            }
                break;
            case MEShowToSomeone:
            {
                request = [DYBHttpMethod share_frommelist:[NSString stringWithFormat:@"%d",_iOrder] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:strKeyword asc:[NSString stringWithFormat:@"%d",asc] isAlert:NO receive:self];              
            }
                break;
            case Commonality:
            {
                request = [DYBHttpMethod document_public_order:[NSString stringWithFormat:@"%d",_iOrder] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:strKeyword asc:[NSString stringWithFormat:@"%d",asc] isAlert:YES receive:self];
            }
                break;
                
            default:
                break;
        }
        

    }else{
    
      request = [DYBHttpMethod dataBankList_navi_id:_current_dir order:@"1" asc:@"1" num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:strKeyword  sAlert:YES receive:self];
    
    }

        [request setTag:tag];

    
        if (!request) {//无网路
    //            [uptableview setUpdateState:DUpdateStateNomal];
                [tbDataBank reloadData:NO];
           }

    
}

//tag_info
-(void)addOBjToArray:(NSString *)signal{ //全部转小写搜索

    
    [arraySearchResult removeAllObjects]; //移除全部结果，重新加入
    [arrayCell removeAllObjects];
    
    NSString *obj = [signal lowercaseString];
    for (NSDictionary *dict in arrayResourcesList) {
        
        
        //标签判断
        NSString *title3 = [[dict objectForKey:@"title"] lowercaseString];
        NSRange range3 = [title3 rangeOfString:obj];
        if (range3.length >  0 ) { // 加强判断 有风险
            
            if (![arraySearchResult containsObject:dict] ) {
                [arraySearchResult addObject:dict];
            }
        }
    }
    if (obj.length > 0) {

        
    }else{
        
        [arraySearchResult removeAllObjects];
    }
        
    [self creatCell];
    
    
   UIButton *view = (UIButton *)[self viewWithTag:BACKBG_TAG];
    

        if (arrayCell.count > 0) {
            
            if (view && !view.hidden) {
                
                [view setHidden:YES];
            }
            [tbDataBank setHidden:NO];
            
            [self setBackgroundColor:[UIColor whiteColor]];
        }else{
            
         
            if (!view) {
                
                view = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0, 0,0)];
                [view setTag:BACKBG_TAG];
                [view setAlpha:0.7];
                [view addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
                [view setBackgroundColor:[UIColor blackColor]];
                [self insertSubview:view atIndex:0];
                RELEASE(view);
                
                
            }else{
                [view setHidden:NO];
            }
            
            [tbDataBank setHidden:YES];
            [self setBackgroundColor:[UIColor clearColor]];
        }
}

-(void)hideSelf{

    [self doCancel];
}

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSNumber *s = [NSNumber numberWithInteger:arrayCell.count];
        [signal setReturnValue:s];
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath
    {
                
        [signal setReturnValue:[NSNumber numberWithInteger:CELLHIGHT]];
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        [signal setReturnValue:nil];
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
    {
        [signal setReturnValue:nil];
        
    }//
    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
    {
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
    }
    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
     
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        DYBDataBankListCell *cell = (DYBDataBankListCell *)[arrayCell objectAtIndex:indexPath.row];
        
        if (indexPath.row%2 == 0) {
            [cell setSwipViewBackColor:[UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1.0f]];
        }else{
            [cell setSwipViewBackColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
            
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
       
        [self performSelector:@selector(showCancelBtn) withObject:nil afterDelay:1];
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        NSDictionary *dictResult = [arraySearchResult objectAtIndex:indexPath.row];
        
        
        BOOL isFolder = [[dictResult objectForKey:@"is_dir"] boolValue];
        
        if (!isFolder) {  //文件暂时不好浏览
            
            BOOL bShow = [DYBShareinstaceDelegate noShowTypeFileTarget:self type:[dictResult objectForKey:@"type"]];
            
            if (!bShow) {
                return;
            }
            
            DYBDataBankFileDetailViewController *showFile = [[DYBDataBankFileDetailViewController alloc]init];
            showFile.dictFileInfo = dictResult;
            showFile.targetObj = self;
            showFile.iPublicType = _iBtnType;
            showFile.index = indexPath.row;
            showFile.arraySource = arrayResourcesList;
            showFile.cellOperater = [arrayCell objectAtIndex:indexPath.row];
        
            
            for (int i = 0;  i < _arrayViewCell.count; i++) {
                
                DYBDataBankListCell *cell = [_arrayViewCell objectAtIndex:i];
                if ([cell.strTag isEqualToString:[dictResult objectForKey:@"file_urlencode"]]) {
                    
                    showFile.cellOperaterSearch = cell;
                }
            }
            
            
            [((DYBBaseViewController *)[self superCon]).drNavigationController pushViewController:showFile animated:YES];
            RELEASE(showFile);
            return ;
        }
        
        
        DYBDataBankChildrenListViewController *childerListController = [[DYBDataBankChildrenListViewController alloc]init];
        
        [childerListController setStrTitle:[dictResult objectForKey:@"title"]];
        [childerListController setFolderID:[dictResult objectForKey:@"file_path"]];
        
        
        
        [((DYBBaseViewController *)[self superCon]).drNavigationController pushViewController:childerListController animated:YES];
        [childerListController release];

    }else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])
    {
        if (_searchbar) {
            
            [_searchbar resignFirstResponder];
            [_searchbar setShowsCancelButton:YES];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])
    {
        DLogInfo(@"1111");
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){
        
        [tbDataBank StretchingUpOrDown:0];
        [DYBShareinstaceDelegate opeartionTabBarShow:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){
        
        [tbDataBank StretchingUpOrDown:1];
        [DYBShareinstaceDelegate opeartionTabBarShow:NO];
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])
    {

        page = 1;
        
        [self resolutionRequest:1];

    }else if([signal is:[MagicUITableView TAbLEVIEWLODATA]]) //加载更多
    {
        
        MagicUIUpdateView *uptableview = (MagicUIUpdateView *)[signal object];
        
        page ++;
        
        [self resolutionRequest:8];
    }
}

-(void)showCancelBtn{

     [_searchbar setShowsCancelButton:YES animated:NO];

}

-(void)handleViewSignal_DYBDtaBankSearchView_TOUCHSIGLEBTN:(MagicViewSignal *)signal
{
    [self handleViewSignal_DYBDataBankSelectBtn_TOUCHSIGLEBTN:signal];
}

-(void)handleViewSignal_DYBDataBankSelectBtn_TOUCHSIGLEBTN:(MagicViewSignal *)signal{

    if ([signal is:[DYBDtaBankSearchView TOUCHSIGLEBTN]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UIButton *btn = (UIButton *)[dict objectForKey:@"btn"];
        DLogInfo(@"tag -- %d",btn.tag);
        int row = [[dict objectForKey:@"row"] integerValue];
        
        iSelectRow = row;
        
        [_searchbar resignFirstResponder];
        [_searchbar setShowsCancelButton:YES animated:NO];

        DYBDataBankListCell *cell = [arrayCell objectAtIndex:row]; //关闭 cell
        [cell closeCell];
        
        switch (btn.tag) {
                
            case BTNTAG_SHARE:
                
            {
                NSDictionary *dictSend = nil;
                NSString *strEncode = [[arraySearchResult objectAtIndex:row] objectForKey:@"file_urlencode"];
                

                if (dictSend == nil) {
                    
                    dictSend = [arraySearchResult objectAtIndex:row];
                }
                
                
                UIView *view =   ((DYBBaseViewController *)[self superCon]).drNavigationController.view;
                
                DYBDataBankShareEnterView * shareView = [[DYBDataBankShareEnterView alloc]initWithFrame:CGRectMake(0.0f, 0.0f , 320.0f, view.frame.size.height) target:((DYBBaseViewController *)[self superCon]) info:dictSend arrayFolderList:nil index:row];
                
                
                for (int i = 0;  i < _arrayViewCell.count; i++) {
                    
                    DYBDataBankListCell *cell = [_arrayViewCell objectAtIndex:i];
                    if ([cell.strTag isEqualToString:strEncode]) {
                        
                        shareView.cellDetail = cell;
                    }
                }
                
                for (int i = 0;  i < arrayCell.count; i++) {
                    
                    DYBDataBankListCell *cell = [arrayCell objectAtIndex:i];
                    if ([cell.strTag isEqualToString:strEncode]) {
                        
                        shareView.cellDetailSearch = cell;
                    }
                }
                
                [view addSubview:shareView];
                RELEASE(shareView);
                
            }
                break;
            case BTNTAG_CHANGE:
            {
                
                id controller = [self superCon];
                
                if ([controller isKindOfClass:[DYBDataBankShareViewController class]]) {
                    
                    
                    DYBDataBankChildrenListViewController *childr = [[DYBDataBankChildrenListViewController alloc]init];
                    childr.dictInfo = [arraySearchResult objectAtIndex:row] ;
                    childr.folderID = @"";
                    
                    if (self.iBtnType == SomeoneShowToME) {
                        
                        childr.strChangeType = @"SHARE";
                    }else{
                        
                        childr.strChangeType = @"O";
                    }
                    childr.popController = self;
                    childr.bChangeSave = YES;
                    childr.strFromDir = [NSString stringWithFormat:@"%@",[[arraySearchResult objectAtIndex:row] objectForKey:@"file_path"]];
                    childr.bChangeFolder = YES;
                    
                    [((DYBBaseViewController *)[self superCon]).drNavigationController pushViewController:childr animated:YES];
                    RELEASE(childr);
                    
                }else{
                    
                    DYBDataBankChildrenListViewController *childr = [[DYBDataBankChildrenListViewController alloc]init];
                    childr.folderID = @"";
                    childr.strFromDir = [NSString stringWithFormat:@"%@",[[arraySearchResult objectAtIndex:row] objectForKey:@"id"]];
                    childr.dictInfo = [arraySearchResult objectAtIndex:row] ;
                    childr.bChangeFolder = YES;
                    childr.bChangeSave = NO;
                    [((DYBBaseViewController *)[self superCon]).drNavigationController pushViewController:childr animated:YES];
                    RELEASE(childr);
                    
                }                
            }
                
                break;
            case BTNTAG_RENAME:
            {
                NSString *title = [[arraySearchResult objectAtIndex:row] objectForKey:@"title"];
                NSString *type = [[arraySearchResult objectAtIndex:row] objectForKey:@"type"];
                NSString *name = nil;
                if (type.length > 0 && type) {
                    name = [[title componentsSeparatedByString:[NSString stringWithFormat:@".%@",type]] objectAtIndex:0];
                }else{
                    
                    name = title;
                }
                
                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:name targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_RENAME rowNum:[NSString stringWithFormat:@"%d",row]];
            }
                break;
            case BTNTAG_DOWNLOAD:{
                
                                
                DYBDataBankDownloadManageViewController *downLoad = [DYBDataBankDownloadManageViewController shareDownLoadInstance];
                NSDictionary *dict = [arraySearchResult objectAtIndex:row];
                [downLoad insertCell:dict];
                
                for (DYBDataBankListCell* cell in _arrayViewCell) { //上层view 添加标记
                    
                    if ([[dict objectForKey:@"file_urlencode"] isEqual:cell.strTag]) {
                        
                        [cell.imageViewDown setHidden:NO];
                    }
                }
                
                for (DYBDataBankListCell* cell in arrayCell) { //本层view 添加标记
                    
                    if ([[dict objectForKey:@"file_urlencode"] isEqual:cell.strTag]) {
                        
                        [cell.imageViewDown setHidden:NO];
                    }
                }
            }
                break;
            case BTNTAG_DEL:
            {
                
                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要删除吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",row]];
            }
                break;
            case BTNTAG_CANCELSHARE:
            {
                
                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要取消共享吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_CANCELSHARE rowNum:[NSString stringWithFormat:@"%d",row]];
                
            }
             break;
            case BTNTAG_BAD:
            {
                
                badRow = row;
                
                [btn setEnabled:NO];
                _badBtn = btn;
                
                [self creatGoodANDBadIMG:@"cai"];
                
                NSDictionary *dict = [arraySearchResult objectAtIndex:row];
                
                MagicRequest *request = [DYBHttpMethod document_estimate_id:[dict objectForKey:@"oid"] type:@"2" isAlert:NO receive:self];
                [request setTag:BTNTAG_BAD];
            }
                break;
            case BTNTAG_GOOD:
            {

                [self creatGoodANDBadIMG:@"ding"];
                NSDictionary *dict = [arraySearchResult objectAtIndex:row];
                
                goodRow = row;
                
                [btn setEnabled:NO];
                _goodBtn = btn;
                
                MagicRequest *request = [DYBHttpMethod document_estimate_id:[dict objectForKey:@"oid"] type:@"1" isAlert:NO receive:self];
                [request setTag:BTNTAG_GOOD];
            }
                break;
            case BTNTAG_REPORT:
            {
                NSDictionary *dict = [arraySearchResult objectAtIndex:row];
                
                DYBSignViewController *vc = [[DYBSignViewController alloc]init];
                vc.bDataBank = YES;
                vc.dictInfo = dict;
                [((DYBBaseViewController *)[self superCon]).drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);

            }
                break;

            default:
                break;
        }
    }
}

-(void)creatGoodANDBadIMG:(NSString *)strType{

    UIImageView *imageViewOperation = (UIImageView *)[self viewWithTag:OPEARTIONTAG];
    if (!imageViewOperation) {
        imageViewOperation  = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0)];
        [imageViewOperation setTag:OPEARTIONTAG];
        [imageViewOperation setCenter:CGPointMake(320.0f/2, self.frame.size.height/2)];
        [imageViewOperation setImage:[UIImage imageNamed:strType]];
        [self addSubview:imageViewOperation];
        RELEASE(imageViewOperation);
        
    }else{
        
        [imageViewOperation setImage:[UIImage imageNamed:strType]];
    }
}

-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    DLogInfo(@"ddddd");
    if ([signal is:[DYBDataBankShotView LEFT]]) {
        
    }
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *text = [dict objectForKey:@"text"];
        NSString *type = [dict objectForKey:@"type"];
        NSNumber *row = [dict objectForKey:@"rowNum"];
        NSDictionary *dictResult = [arraySearchResult objectAtIndex:[row integerValue]];
        NSString *fileURL = [dictResult objectForKey:@"file_path"];
        switch ([type integerValue]) {
            case BTNTAG_DEL:{
                
                strEncodeUrl = [dictResult objectForKey:@"file_urlencode"];
                
                MagicRequest *request = [DYBHttpMethod document_deldoc_doc:fileURL indexDataBack:[NSString stringWithFormat:@"%@",row] isAlert:YES receive:self];
                
                [request setTag:BTNTAG_DEL];
                
            }
                break;
                
            case BTNTAG_CHANGE:
                
                
                break;
                
            case BTNTAG_RENAME:
            {
                
                NSString *doc_id = [dictResult objectForKey:@"id"];
                NSString *dir = [dictResult objectForKey:@"dir"];
               
                
                NSString *type = [dictResult objectForKey:@"type"];
                if (type.length > 0 && type) {
                    text= [NSString stringWithFormat:@"%@.%@",text,type];
                }

                
                BOOL bOK = [DYBShareinstaceDelegate isOKName:text];
                
                int lenght = text.length;
                if (!bOK|| lenght > 255) {
                    
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"输入的名称不符合要求" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",0]];
                    
                    return;
                }
                
                strEncodeUrl =  [dictResult objectForKey:@"file_urlencode"];
                
                MagicRequest *request = [DYBHttpMethod document_rename_doc_id:doc_id name:text is_dir:dir indexDataBank:[NSString stringWithFormat:@"%@",row]  sAlert:YES receive:self ];                
                [request setTag:BTNTAG_RENAME];
            }
                break;
            case BTNTAG_SHARE:
                
                break;
            case BTNTAG_CANCELSHARE:
            {
                
                NSString *strDoc = [dictResult objectForKey:@"file_path"];
                
                MagicRequest *request = [DYBHttpMethod document_share_doc:strDoc target:@"" isAlert:YES receive:self ];
                [request setTag:BTNTAG_CANCELSHARE];

            }
            default:
                break;
        }
    }
}


#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    
    JsonResponse *response = (JsonResponse *)receiveObj;
    if (request.tag == BTNTAG_DEL) {
        
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            DLogInfo(@"dddd");
            int index = [[response.data objectForKey:@"indexDataBack"] integerValue];

            [arraySearchResult removeObjectAtIndex:index];
            
                        
            [self creatCell];
            [DYBShareinstaceDelegate popViewText:@"删除成功！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            
            [self sendViewSignal:[DYBDtaBankSearchView  DELOBJ] withObject:strEncodeUrl from:self target:[self superview]];
            
        }else{
        
            [DYBShareinstaceDelegate popViewText:@"删除失败！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        }
        
    }if (request.tag == BTNTAG_RENAME) {
        
        NSString *strMSG = [response.data objectForKey:@"msg"];
        
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            NSDictionary *dict = [response.data objectForKey:@"list"];
            NSInteger index = [[response.data objectForKey:@"indexDataBack"] integerValue];
            
            if (dict) {
                [arraySearchResult replaceObjectAtIndex:index withObject:dict];
            }
            
            [self creatCell];
            
            NSDictionary *sendDict = [[NSDictionary alloc]initWithObjectsAndKeys:dict,@"dict",strEncodeUrl,@"url", nil];
            
            [self sendViewSignal:[DYBDtaBankSearchView  NEWNAME] withObject:sendDict from:self target:[self superview]];

        }
        
            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        
        }else if (request.tag == BTNTAG_CANCELSHARE){
        
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            
            
            if (arraySearchResult.count >= iSelectRow) {
                
                NSDictionary *dict = [arraySearchResult objectAtIndex:iSelectRow];
                [self sendViewSignal:[DYBDtaBankSearchView CANCELSHARE] withObject:[dict objectForKey:@"file_urlencode"] from:self target:[self superview]];
                
                [arraySearchResult removeObjectAtIndex:iSelectRow];
                
                [self creatCell];

            }
            
        }else{
            
            [DYBShareinstaceDelegate popViewText:@"取消共享失败" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            
        }
    }
    
    else if (request.tag ==1){
 
        
        if ([[response.data objectForKey:@"result"] boolValue])
        {
            
            RELEASEDICTARRAYOBJ(arraySearchResult);
            [arrayCell removeAllObjects];
            
            NSArray *list=[response.data objectForKey:@"list"];
            DLogInfo(@"list -- %@",list);
            arraySearchResult = [[NSMutableArray alloc]initWithArray:list];
            
            [self creatCell];
            
            BOOL bHaveNext = [[response.data objectForKey:@"havenext"] boolValue];
            
            if (bHaveNext == 1) {
                [tbDataBank reloadData:NO];
            }else{
                [tbDataBank reloadData:YES];
            }

            
            UIButton *view = (UIButton *)[self viewWithTag:BACKBG_TAG];

            
                if (view && !view.hidden) {
                    
                    [view setHidden:YES];
                }
                [tbDataBank setHidden:NO];
                
                [self setBackgroundColor:[UIColor whiteColor]];
            
            if (arraySearchResult.count == 0) {
                
                [self addNOresultImageView:@"没有找到你想找的文件或文件夹哦！"];
            }else{
                
                UIView *view = [self viewWithTag:NORESULTVIEW];
                if (view) {
                
                    [view removeFromSuperview];
                }
            
            }
            
        }
    }else if (request.tag == BTNTAG_BAD){
        
        
        if ([[response.data objectForKey:@"result"] boolValue]) { //操作ok
            
            DYBDataBankListCell *cell = [arrayCell objectAtIndex:badRow];
            
            DYBDataBankListCell *cellOld = nil;
            
            for (DYBDataBankListCell *cell1 in _arrayViewCell) {
                if ([cell1.strTag isEqualToString:cell.strTag]) {
                    
                    cellOld = cell1;
                }
            }
            
            NSDictionary *dictNew = [response.data objectForKey:@"list"];
            
            if ([dictNew isKindOfClass:[NSNull class]]) {
                return;
            }
            cell.labelGood.text = [dictNew objectForKey:@"up"];
            cell.labelBad.text = [dictNew objectForKey:@"down"];
            
            cellOld.labelGood.text = [dictNew objectForKey:@"up"];
            cellOld.labelBad.text = [dictNew objectForKey:@"down"];
            
            UIButton *btnGood = (UIButton *)[cell viewWithTag:BTNTAG_GOOD];
            UIButton *btnGoodOld = (UIButton *)[cellOld viewWithTag:BTNTAG_GOOD];
            if ([[dictNew objectForKey:@"is_estimate_up"] boolValue] ) {
                
                
                [btnGood setEnabled:NO];
                [btnGoodOld setEnabled:NO];
            }else{
                
                [btnGood setEnabled:YES];
                [btnGoodOld setEnabled:YES];
            }
            
            UIButton *btnBad = (UIButton *)[cell viewWithTag:BTNTAG_BAD];
            UIButton *btnBadOld = (UIButton *)[cellOld viewWithTag:BTNTAG_BAD];
            if ([[dictNew objectForKey:@"is_estimate_down"] boolValue] ) {
                
                
                [btnBad setEnabled:NO];
                [btnBadOld setEnabled:NO];
            }else{
                
                [btnBad setEnabled:YES];
                [btnBadOld setEnabled:YES];
            }
            
            
            [arraySearchResult replaceObjectAtIndex:badRow withObject:dictNew];  //替换 array中的dict
            
            UIView *opeationView = [self viewWithTag:OPEARTIONTAG];
            
            [UIView animateWithDuration:.5f animations:^{
                
                opeationView.alpha = .0f;
                
            } completion:^(BOOL finished) {
                
                [opeationView removeFromSuperview];
                [btnGood setEnabled:YES];
                [btnGoodOld setEnabled:YES];
                
            }];
            
        }else{
            
            
            UIView *opeationView = [self viewWithTag:OPEARTIONTAG];
            
            [UIView animateWithDuration:.5f animations:^{
                
                opeationView.alpha = .0f;
                
            } completion:^(BOOL finished) {
                
                [opeationView removeFromSuperview];
                
                [_badBtn setEnabled:YES];
                
            }];
            DLogInfo(@"dddd");
        }
    }else if (request.tag == BTNTAG_GOOD){
        
        
        //已经操作过踩 的，要将踩数-- 。赞的数 ++
        
        if ([[response.data objectForKey:@"result"] boolValue]) { //没有操作ok
            DYBDataBankListCell *cell = [arrayCell objectAtIndex:goodRow];
            
            DYBDataBankListCell *cellOld = nil;
            
            for (DYBDataBankListCell *cell1 in _arrayViewCell) {
                if ([cell1.strTag isEqualToString:cell.strTag]) {
                    
                    cellOld = cell1;
                }
            }
            
            NSDictionary *dictNew = [response.data objectForKey:@"list"];
            
            if ([dictNew isKindOfClass:[NSNull class]]) {
                return;
            }
            
            cell.labelGood.text = [dictNew objectForKey:@"up"];
            cell.labelBad.text = [dictNew objectForKey:@"down"];
            
            cellOld.labelGood.text = [dictNew objectForKey:@"up"];
            cellOld.labelBad.text = [dictNew objectForKey:@"down"];
            
            UIButton *btnGood = (UIButton *)[cell viewWithTag:BTNTAG_GOOD];
            UIButton *btnGoodOld = (UIButton *)[cellOld viewWithTag:BTNTAG_GOOD];
            if ([[dictNew objectForKey:@"is_estimate_up"] boolValue] ) {
                
                
                [btnGood setEnabled:NO];
                [btnGoodOld setEnabled:NO];
            }else{
                
                [btnGood setEnabled:YES];
                [btnGoodOld setEnabled:YES];
            }
            
            UIButton *btnBad = (UIButton *)[cell viewWithTag:BTNTAG_BAD];
            UIButton *btnBadOld = (UIButton *)[cellOld viewWithTag:BTNTAG_BAD];
            if ([[dictNew objectForKey:@"is_estimate_down"] boolValue] ) {
                
                
                [btnBad setEnabled:NO];
                [btnBadOld setEnabled:NO];
            }else{
                
                [btnBad setEnabled:YES];
                [btnBadOld setEnabled:YES];
            }
            
            [arraySearchResult replaceObjectAtIndex:goodRow withObject:dictNew];  //替换 array中的dict
            
            UIView *opeationView = [self viewWithTag:OPEARTIONTAG];
            
            [UIView animateWithDuration:.5f animations:^{
                
                opeationView.alpha = .0f;
                
            } completion:^(BOOL finished) {
                
                [opeationView removeFromSuperview];
                [btnBad setEnabled:YES];
                [btnBadOld setEnabled:YES];
            }];
            
        }else{
            
            UIView *opeationView = [self viewWithTag:OPEARTIONTAG];
            
            [UIView animateWithDuration:.5f animations:^{
                
                opeationView.alpha = .0f;
                
            } completion:^(BOOL finished) {
                
                [opeationView removeFromSuperview];
                [_goodBtn setEnabled:YES];
                
            }];
        }
    }
    else if (request.tag == 8){
    
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            NSArray *list=[response.data objectForKey:@"list"];
            
            [arraySearchResult addObjectsFromArray:list];
            
            [self creatCell];
            
            
            BOOL bHaveNext = [[response.data objectForKey:@"havenext"] boolValue];
            
            if (bHaveNext == 1) {
                [tbDataBank reloadData:NO];
            }else{
                [tbDataBank reloadData:YES];
            }
        }
    }
}

-(void)opeaterCellObj:(DYBDataBankListCell *)cell response:(JsonResponse *)response{

    DYBDataBankListCell *cellOld = nil;
    
    for (DYBDataBankListCell *cell1 in _arrayViewCell) {
        if ([cell1.strTag isEqualToString:cell.strTag]) {
            
            cellOld = cell1;
        }
    }
    
    NSDictionary *dictNew = [response.data objectForKey:@"list"];
    cell.labelGood.text = [dictNew objectForKey:@"up"];
    cell.labelBad.text = [dictNew objectForKey:@"down"];
    
    cellOld.labelGood.text = [dictNew objectForKey:@"up"];
    cellOld.labelBad.text = [dictNew objectForKey:@"down"];
    
    UIButton *btnGood = (UIButton *)[cell viewWithTag:BTNTAG_GOOD];
    UIButton *btnGoodOld = (UIButton *)[cellOld viewWithTag:BTNTAG_GOOD];
    if ([[dictNew objectForKey:@"is_estimate_up"] boolValue] ) {
        
        
        [btnGood setEnabled:NO];
        [btnGoodOld setEnabled:NO];
    }else{
        
        [btnGood setEnabled:YES];
        [btnGoodOld setEnabled:YES];
    }
    
    UIButton *btnBad = (UIButton *)[cell viewWithTag:BTNTAG_BAD];
    UIButton *btnBadOld = (UIButton *)[cellOld viewWithTag:BTNTAG_BAD];
    if ([[dictNew objectForKey:@"is_estimate_down"] boolValue] ) {
        
        
        [btnBad setEnabled:NO];
        [btnBadOld setEnabled:NO];
    }else{
        
        [btnBad setEnabled:YES];
        [btnBadOld setEnabled:YES];
    }
    
    
    [arraySearchResult replaceObjectAtIndex:badRow withObject:dictNew];  //替换 array中的dict
    
    UIView *opeationView = [self viewWithTag:OPEARTIONTAG];
    
    [UIView animateWithDuration:.5f animations:^{
        
        opeationView.alpha = .0f;
        
    } completion:^(BOOL finished) {
        
        [opeationView removeFromSuperview];
        [btnGood setEnabled:YES];
        [btnGoodOld setEnabled:YES];
        
    }];
}

-(void)creatCell{

    [arrayCell removeAllObjects];
    
    for (int i = 0; i < arraySearchResult.count; i++) {
        
        DYBDataBankListCell *cell = [[DYBDataBankListCell alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, CELLHIGHT)];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [cell setIndexPath:indexPath];
        [cell setTb:tbDataBank];
        if ([[self superCon] isKindOfClass:[DYBDataBankShareViewController class]]) {
            
            [cell setCellType:_iCellType];
            [cell setBtnType:_iBtnType];
        }else{
            
            [cell setCellType:0];
        }
        [cell initViewCell_dict:[arraySearchResult objectAtIndex:indexPath.row]];
        
        [arrayCell addObject:cell];
        [cell release];
        
    }
    
    [tbDataBank._muA_differHeightCellView release];
    tbDataBank._muA_differHeightCellView = nil;
    tbDataBank._muA_differHeightCellView = [[NSMutableArray alloc]initWithArray:arrayCell];
    
    [tbDataBank reloadData];
}


-(void)cancelSelect{
    
    [tbDataBank deselectRowAtIndexPath:[tbDataBank indexPathForSelectedRow] animated:YES];
    
}



#pragma  Operation search bar 

-(void)setSearchFirstResponder{

    [_searchbar resignFirstResponder];
    
}

-(void)isShowCanelButton:(BOOL)key{

    [_searchbar setShowsCancelButton:key];
}


-(void)handleViewSignal_DYBDataBankFileDetailViewController:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankFileDetailViewController NEWNAME]]) {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        NSDictionary *dictNEW = [dict objectForKey:@"dict"];
        NSString *url = [dict objectForKey:@"url"];
        for (int i = 0; i < arraySearchResult.count ; i++) {
            
            NSDictionary *dict = [arraySearchResult objectAtIndex:i];
            
            NSString *strEncode = [dict objectForKey:@"file_urlencode"];
            if ([strEncode isEqualToString:url]) {
                
                [arraySearchResult replaceObjectAtIndex:i withObject:dictNEW];
                break;
            }
        }
        [self creatCell];
        
        //将信息传到上层
        [self sendViewSignal:[DYBDtaBankSearchView  NEWNAME] withObject:dict from:self target:[self superview]];
        
    }else if([signal is: [DYBDataBankFileDetailViewController DELFILE]]){
        
        NSString *url = (NSString *)[signal object];
        
        NSString *strEncode = nil;
        for (int i = 0; i < arraySearchResult.count ; i++) {
            
            NSDictionary *dict = [arraySearchResult objectAtIndex:i];
            
           strEncode = [dict objectForKey:@"file_urlencode"];
            if ([strEncode isEqualToString:url]) {
                
                [arraySearchResult removeObjectAtIndex:i];
                break;
            }
        }
        [self creatCell];
        [self sendViewSignal:[DYBDtaBankSearchView  DELOBJ] withObject:strEncode from:self target:[self superview]];
    }else if([signal is:[DYBDataBankFileDetailViewController CANCELSHARE]]){
    
        NSNumber *index = (NSNumber *)[signal object];
        
        NSString *strEncode = [[arraySearchResult objectAtIndex:[index integerValue]] objectForKey:@"file_urlencode"];
                [arraySearchResult removeObjectAtIndex:[index integerValue]];
        
        [self creatCell];
        [self sendViewSignal:[DYBDtaBankSearchView  DELOBJ] withObject:strEncode from:self target:[self superview]];
    
    }
}


-(void)addNOresultImageView:(NSString *)strMsg{
    
    
    UIView *view = [self viewWithTag:NORESULTVIEW];
    if (!view) {
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 44 + SEARCHBAT_HIGH, 300.0f, 400.0f)];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setTag:NORESULTVIEW];
        [self insertSubview:view atIndex:0];
        RELEASE(view);
        
        UIImage *image = [UIImage imageNamed:@"ybx_big.png"];
        float BearHeadStartX = (CGRectGetWidth(self.frame)-image.size.width/2)/2;
        float BearHeadStartY = self.frame.size.height -44 - SEARCHBAT_HIGH;
        MagicUIImageView *viewBearHead = [[MagicUIImageView alloc] initWithFrame:CGRectMake(BearHeadStartX, BearHeadStartY, image.size.width/2, image.size.height/2)];
        [viewBearHead setBackgroundColor:[UIColor clearColor]];
        [viewBearHead setCenter:CGPointMake(160, 44)];
        [viewBearHead setImage:image];
        [view addSubview:viewBearHead];
        RELEASE(viewBearHead);
        
        MagicUILabel *labelMsg = [[MagicUILabel alloc]initWithFrame:CGRectMake((320 - 250)/2, viewBearHead.frame.size.height + viewBearHead.frame.origin.y + 15, 250.0f, 40.0f)];
        [labelMsg setText:strMsg];
        //        [labelMsg setFont:[UIFont systemFontOfSize:14]];
        [labelMsg setTextColor:ColorGray];
        [labelMsg setFont:[DYBShareinstaceDelegate DYBFoutStyle:20]];
        [labelMsg setTextAlignment:NSTextAlignmentCenter];
        [labelMsg setNumberOfLines:2];
        [labelMsg setTag:909];
        [labelMsg setBackgroundColor:[UIColor clearColor]];
        [view addSubview:labelMsg];
        RELEASE(labelMsg);
        
    }else{
        
        UILabel *label = (UILabel *)[view viewWithTag:909];
        [label setText:strMsg];
        
    } 
}


#pragma UISearchDelegate Function


- (void)dealloc
{
    RELEASE(_VC);
    _VC = nil;
    
    for (DYBDataBankListCell *view in _arrayViewCell ) { //强制释放array中的对象
        
        [view release];
        view  = nil;
    }

    RELEASE(strEncodeUrl);
    RELEASEDICTARRAYOBJ(_arrayViewCell);
    RELEASEDICTARRAYOBJ(arraySearchResult);
    RELEASEDICTARRAYOBJ(arrContent);
    RELEASEDICTARRAYOBJ(arrName);
    RELEASEDICTARRAYOBJ(arrTag);
    RELEASEDICTARRAYOBJ(dictSearchResult);
    [super dealloc];
}

@end
