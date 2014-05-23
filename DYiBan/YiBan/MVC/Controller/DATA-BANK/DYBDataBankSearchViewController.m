//
//  DYBDataBankSearchViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankSearchViewController.h"
//#import "DYBDataBankTableView.h"
#import "DYBDataBankChildrenListViewController.h"
#import "DYBDataBankListCell.h"
#import "UIView+MagicCategory.h"
#import "DYBUITabbarViewController.h"
#import "UITableView+property.h"
#import "DYBDataBankFileDetailViewController.h"
#import "DYBDataBankSelectBtn.h"
#import "DYBDataBankShareEnterView.h"
#import "DYBDataBankDownloadManageViewController.h"
#import "DYBMenuView.h"

#define NORESULTVIEW  119
#define SEATCHBTN_TAG 120
#define SEARCHNUM     10

@interface DYBDataBankSearchViewController (){

    DYBUITableView *tbDataBank;
    MagicUISearchBar *searchView;

    NSMutableArray *arrayResult;
    
    
    int page;
    BOOL bPullDown;
    
    NSString *strKey;
    NSString *strSearchType;
    
    DYBMenuView *_tabMenu;
}

@end

@implementation DYBDataBankSearchViewController
@synthesize arrayCellView;

DEF_SIGNAL(SWITCHDYBAMICBUTTON)


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

static DYBDataBankSearchViewController *shareIntance = nil;

+ (DYBDataBankSearchViewController *)creatShare{

    if (shareIntance == nil) {
        shareIntance = [[DYBDataBankSearchViewController alloc]init];
    }
    return shareIntance;

}

-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        
        page = 1;
        strKey = [[NSString alloc]init];
        strSearchType = [[NSString alloc]initWithString:@"all"];
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        
        tbDataBank = [[DYBUITableView alloc]initWithFrame:CGRectMake(0.0f, SEARCHBAT_HIGH + 44, 320.0f, self.view.frame.size.height - SEARCHBAT_HIGH - 44 -20) isNeedUpdate:YES];
        tbDataBank.tableViewType = DTableViewSlime;
        [tbDataBank setSeparatorColor:[UIColor clearColor]];
        [self.view addSubview:tbDataBank];
        
//        [tbDataBank release];
                
        
        searchView = [[MagicUISearchBar alloc]initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH) backgroundColor:[UIColor whiteColor] placeholder:@"文件名" isHideOutBackImg:YES isHideLeftView:NO];
        [searchView setShowsCancelButton:NO];
        [searchView setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
        
        
        UIButton *btnSearch = [[UIButton alloc]initWithFrame:CGRectMake(320-96/2, (SEARCHBAT_HIGH - 60/2)/2, 60/2, 60/2)];
        [btnSearch setBackgroundColor:[UIColor clearColor]];
        [btnSearch setTag:SEATCHBTN_TAG];
        [btnSearch setHidden:NO];
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_search_cancel"] forState:UIControlStateNormal];
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_search_cancel"] forState:UIControlStateHighlighted];
        [btnSearch addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
        [searchView addSubview:btnSearch];
        
        
        for (UIView *subview in [searchView subviews]) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
            }else if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                [(UITextField *)subview setBackground:[UIImage imageNamed:@"bg_search"]];
                
            }
        }

//        [searchView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:searchView];
        [searchView release];
        arrayCellView = [[NSMutableArray alloc]init];
        
        tbDataBank.v_headerVForHide = searchView;
        
        [self addNOresultImageView:@"试试通过类型筛选来查找\n您所有的资料吧！"];
        
        
    }
    
    
    if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        MagicUIButton *_btnSwichDybamic = [[MagicUIButton alloc] initWithFrame:CGRectMake(110, 0, 100, 44)];
        [_btnSwichDybamic addSignal:[DYBDataBankSearchViewController SWITCHDYBAMICBUTTON] forControlEvents:UIControlEventTouchUpInside];
        [self.headview addSubview:_btnSwichDybamic];
        [_btnSwichDybamic setBackgroundColor:[UIColor clearColor]];
        [self.headview bringSubviewToFront:_btnSwichDybamic];
        RELEASE(_btnSwichDybamic);
        
        
        
        
        
        if ([strSearchType isEqualToString:@"all"]) {
            
            [self.headview setTitle:@"搜索全部"];
            
        }else if ([strSearchType isEqualToString:@"audio"]){
            
            [self.headview setTitle:@"音频"];
        
        }else if ([strSearchType isEqualToString:@"image"]){
            
            [self.headview setTitle:@"图片"];
        }else if ([strSearchType isEqualToString:@"doc"]){
            
            [self.headview setTitle:@"文档"];
        }
        
        [self.headview setTitleArrow];

       
    } else if([signal is:[MagicViewController LAYOUT_VIEWS]]){
    
        
        if (arrayCellView.count == 0 ) {
            [tbDataBank setHidden:YES];
        }else{
            [tbDataBank setHidden:NO];
        
        }
    
    }
}

-(void)hideSearchBtn{

    [searchView resignFirstResponder];
    [searchView setShowsCancelButton:NO animated:YES];
    
    UIView *view = [searchView viewWithTag:SEATCHBTN_TAG]; //移除searchbtn
    if (view) {
        [view setHidden:YES];
    }

    
}

-(void)handleViewSignal_DYBDataBankSearchViewController:(MagicViewSignal *)signal{

    if ([signal is:[DYBDataBankSearchViewController SWITCHDYBAMICBUTTON]]) {
        
        [self initDYBMenuView];
        [searchView resignFirstResponder];
    }
}


-(void)initDYBMenuView{
    
    if (!_tabMenu) {
        
        
        NSArray *_arrTitleLable =[[NSArray alloc]initWithObjects:@"搜索全部",@"文档",@"图片",@"音频",@"视频",@"压缩文件",@"可执行文件", nil];
        _tabMenu = [[DYBMenuView alloc]initWithData:_arrTitleLable selectRow:0];
//        _tabMenu.sendTargetObj =self;
        [self.view addSubview:_tabMenu];
        
        RELEASE(_tabMenu);
        RELEASE(_arrTitleLable);
        
    }
    
    
    
    if (bPullDown) {
        
        // hide
        
        [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:self from:self target:_tabMenu];
        //    [_tabDynamic setUserInteractionEnabled:YES];
        
    }else{
        
        // show
        [self sendViewSignal:[DYBMenuView MENUDOWN] withObject:self from:self target:_tabMenu];
        //    [_tabDynamic setUserInteractionEnabled:NO];
        //        [_tabMenu setBlurSuperView:self.view];
    }
    
    [_tabMenu changeArrowStatus:!bPullDown];
    bPullDown = !bPullDown;
    
    
}

-(void)handleViewSignal_DYBMenuView:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBMenuView MENUSELECTCELL]]) {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *section = [dict objectForKey:@"section"];
        NSString *strType = [self getStringTitle:[section integerValue]];
        
        [self.headview setTitle:strType];
        
        [self initDYBMenuView];
        [self.headview setTitleArrow];
    }
    
    
}


-(NSString *)getStringTitle:(int)type{
    
    [arrayCellView removeAllObjects];
    [tbDataBank reloadData];
    page = 1;
    switch (type) {
        case 0:{

            
            strSearchType = @"all";
            
            MagicRequest *request = [DYBHttpMethod search_disk_keyword:strKey page:page num:SEARCHNUM type:strSearchType sAlert:YES receive:self];
            [request setTag:1];
            
            return @"搜索全部";
            
        }
            break;
        case 1:{

            strSearchType = @"doc";
            
            MagicRequest *request = [DYBHttpMethod search_disk_keyword:strKey page:page num:SEARCHNUM type:strSearchType sAlert:YES receive:self];
            [request setTag:1];
            
            return @"文档";
        }
            break;
        case 2:{
            

            strSearchType = @"image";
            
            MagicRequest *request = [DYBHttpMethod search_disk_keyword:strKey page:page num:SEARCHNUM type:strSearchType sAlert:YES receive:self];
            [request setTag:1];
            
            return @"图片";
        }
            break;
            
        case 3:{

            strSearchType = @"audio";
            
            MagicRequest *request = [DYBHttpMethod search_disk_keyword:strKey page:page num:SEARCHNUM type:strSearchType sAlert:YES receive:self];
            [request setTag:1];
            
            return @"音频";
            
        }
            break;
        case 4:{

            strSearchType = @"video";
            
            MagicRequest *request = [DYBHttpMethod search_disk_keyword:strKey page:page num:SEARCHNUM type:strSearchType sAlert:YES receive:self];
            [request setTag:1];
            
            return @"视频";
        }
            break;
            
        case 5:{
            
            strSearchType = @"zip";
            
            MagicRequest *request = [DYBHttpMethod search_disk_keyword:strKey page:page num:SEARCHNUM type:strSearchType sAlert:YES receive:self];
            [request setTag:1];
            
            return @"压缩文件";
        }
            break;
        case 6:{
            
            strSearchType = @"exe";
            
            MagicRequest *request = [DYBHttpMethod search_disk_keyword:strKey page:page num:SEARCHNUM type:strSearchType sAlert:YES receive:self];
            [request setTag:1];
            
            return @"可执行文件";
        }
            break;
        
            
        default:
            break;
    }
    return @"";
}



-(void)doCancel{
    
    
    [searchView resignFirstResponder];
//    [searchView setShowsCancelButton:YES];
    
    [searchView setShowsCancelButton:NO animated:YES];
    [tbDataBank reloadData];
    
    UIView *view = [searchView viewWithTag:SEATCHBTN_TAG]; //移除searchbtn
    if (view) {
        [view setHidden:YES];
    }
    
    [self sendViewSignal:[DYBDtaBankSearchView RECOVERBAR] withObject:nil from:self];
}

-(void)setSearchViewFirstResponder{

    [searchView becomeFirstResponder];

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


#pragma mark- 只接受tbv信号
//static NSString *reuseIdentifier = @"reuseIdentifier";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSNumber *s = [NSNumber numberWithInteger:arrayCellView.count];
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
        
        DYBDataBankListCell *cell = [arrayCellView objectAtIndex:indexPath.row];
        
        if (indexPath.row%2 == 0) {
            
            [cell setSwipViewBackColor:[UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1.0f]];
        }else{
            
            [cell setSwipViewBackColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
            
        }
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
        
        [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:self from:self target:_tabMenu];
        [_tabMenu changeArrowStatus:NO];
        bPullDown = NO;
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        NSDictionary *dictResult = [arrayResult objectAtIndex:indexPath.row];
        
        
        BOOL isFolder = [[dictResult objectForKey:@"is_dir"] boolValue];
        
        
        
        
        if (!isFolder) {  //文件暂时不好浏览
            
            BOOL bShow = [DYBShareinstaceDelegate noShowTypeFileTarget:self type:[dictResult objectForKey:@"type"]];
            
            if (!bShow) {
                return;
            }
            
            
            DYBDataBankFileDetailViewController *showFile = [[DYBDataBankFileDetailViewController alloc]init];
            showFile.dictFileInfo = dictResult;
            showFile.iPublicType = 1;
            showFile.targetObj = self;
            [self.drNavigationController pushViewController:showFile animated:YES];
            RELEASE(showFile);
            return ;
        }
        
        
        DYBDataBankChildrenListViewController *childerListController = [[DYBDataBankChildrenListViewController alloc]init];
        
        
        [childerListController setStrTitle:[dictResult objectForKey:@"title"]];
        [childerListController setFolderID:[dictResult objectForKey:@"file_path"]];
        [self.drNavigationController pushViewController:childerListController animated:YES];
        [childerListController release];
        
    }else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])//滚动停止
    {
        
        [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:self from:self target:_tabMenu];
        [_tabMenu changeArrowStatus:NO];
        
        bPullDown = NO;
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){
       
        
        [self hideSearchBtn];
        
        [tbDataBank StretchingUpOrDown:0];
        [self opeartionTabBar_show:YES];
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){
       
        [self hideSearchBtn];
        
        [tbDataBank StretchingUpOrDown:1];
        [self opeartionTabBar_show:NO];
       
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])
    {
        
        page = 1;
        MagicRequest *request = [DYBHttpMethod search_disk_keyword:strKey page:page num:SEARCHNUM type:strSearchType sAlert:YES receive:self];
        [request setTag:1];
        
        if (!request) {//无网路
            [tbDataBank reloadData:NO];
        }
        
    }else if([signal is:[MagicUITableView TAbLEVIEWLODATA]])
    {        
        page ++;
        MagicRequest *request = [DYBHttpMethod search_disk_keyword:strKey page:page num:SEARCHNUM type:strSearchType sAlert:YES receive:self];
        [request setTag:page];
         [request setTag:8];
        DLogInfo(@"dddddddddd page %d",page);
        if (!request) {//无网路
            [tbDataBank reloadData:NO];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
     [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:self from:self target:_tabMenu];
     [_tabMenu changeArrowStatus:NO];
    
     bPullDown = NO;
    
    [searchView resignFirstResponder];
    
}


-(void)handleViewSignal_DYBDataBankFileDetailViewController:(MagicViewSignal *)signal{
    

    
    if ([signal is:[DYBDataBankFileDetailViewController NEWNAME]]) {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        NSDictionary *dictNEW = [dict objectForKey:@"dict"];
        NSString *url = [dict objectForKey:@"url"];        
        
        for (int i = 0; i < arrayResult.count ; i++) {
            
            NSDictionary *dict = [arrayResult objectAtIndex:i];
            
            NSString *strEncode = [dict objectForKey:@"file_urlencode"];
            if ([strEncode isEqualToString:url]) {
                
                [arrayResult replaceObjectAtIndex:i withObject:dictNEW];
                break;
            }
        }

        [self creatCell];

        
    }else if([signal is: [DYBDataBankFileDetailViewController DELFILE]]){

        
        NSString *url = (NSString *)[signal object];
        
        for (int i = 0; i < arrayResult.count ; i++) {
            
            NSDictionary *dict = [arrayResult objectAtIndex:i];
            
            NSString *strEncode = [dict objectForKey:@"file_urlencode"];
            if ([strEncode isEqualToString:url]) {
                
                [arrayResult removeObjectAtIndex:i];
                break;
            }
        }
        
        
        [self creatCell];
        
        
    }
}-(void)opeartionTabBar_show:(BOOL)key{
    
    DYBUITabbarViewController *tabBatC = [DYBUITabbarViewController sharedInstace];
    
    if (key) {
        
        [tabBatC hideTabBar:YES animated:YES];
    }else{
        
        [tabBatC hideTabBar:NO animated:YES];
    }
    
    
}
-(void)ShowTB{
    
    if (arrayCellView.count > 0) {
        [tbDataBank setHidden:NO];
    }

}


- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{

    [searchView resignFirstResponder];
     [self.view setUserInteractionEnabled:YES];
    UIView *view = [searchView viewWithTag:SEATCHBTN_TAG]; //移除searchbtn
    if (view) {
        [view setHidden:YES];
    }

     JsonResponse *response = (JsonResponse *)receiveObj;
    if (request.tag == 1) {
            
    
        if ([[response.data objectForKey:@"result"] boolValue])
        {
            [arrayResult removeAllObjects];
            RELEASE(arrayResult);
            [arrayCellView removeAllObjects];
            
            NSArray *list=[response.data objectForKey:@"list"];
            arrayResult = [[NSMutableArray alloc]initWithArray:list];
            DLogInfo(@"list -- %@",list);
            
            [self creatCell];
            BOOL bNext = [[response.data objectForKey:@"havenext"] boolValue];
            
            if (bNext == 1) {
                [tbDataBank reloadData:NO];
            }else{
                [tbDataBank reloadData:YES];
            }
        
            [self ShowTB];
    
        
            if (arrayResult.count <= 0) {
                
                [self addNOresultImageView:@"没有搜索到你想要的结果！"];
            }else{
            
                [self removerNOresultImageView];
            }
        }else{
        
            NSString *strMSG = [response.data objectForKey:@""];
        
        
        }
        
        
        
    }else if (request.tag == 2){
    
    
        if ([[response.data objectForKey:@"result"] boolValue])
        {
            NSArray *list=[response.data objectForKey:@"list"];
            DLogInfo(@"list -- %@",list);
            [arrayResult addObjectsFromArray:list];

            [self creatCell];
        
        
        BOOL bNext = [[response.data objectForKey:@"havenext"] boolValue];
        
        if (bNext == 1) {
            [tbDataBank reloadData:NO];
        }else{
            [tbDataBank reloadData:YES];
        }
        
        [tbDataBank reloadData];
        
        if (arrayResult.count <= 0) {
            
             [self addNOresultImageView:@"没有搜索到你想要的结果！"];
        }else{
            
            [self removerNOresultImageView];
        }
        
        }
    }else if (request.tag == 8){
        
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            NSArray *list=[response.data objectForKey:@"list"];
            
            [arrayResult addObjectsFromArray:list];
            
            [self creatCell];
            
            BOOL bHaveNext = [[response.data objectForKey:@"havenext"] boolValue];
            
            if (bHaveNext == 1) {
                [tbDataBank reloadData:NO];
            }else{
                [tbDataBank reloadData:YES];
            }
            
            
        }
    }
    
   else if (request.tag == BTNTAG_DEL) {
        
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            DLogInfo(@"dddd");
            int index = [[response.data objectForKey:@"indexDataBack"] integerValue];
            
            [arrayResult removeObjectAtIndex:index];
            [self creatCell];
                    
            [DYBShareinstaceDelegate popViewText:@"删除成功！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        }else{
        
            [DYBShareinstaceDelegate popViewText:@"删除失败！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        }
       
       
    }else if (request.tag == BTNTAG_RENAME) {
        
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            DLogInfo(@"dddd");
            NSDictionary *dict = [response.data objectForKey:@"list"];
            
            NSInteger index = [[response.data objectForKey:@"indexDataBack"] integerValue];
            
            if (dict) {
                [arrayResult replaceObjectAtIndex:index withObject:dict];
            }
            
            [self creatCell];

        }
        
            NSString *strMSG = [response.data objectForKey:@"msg"];
        
            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
    }
}

-(void)handleViewSignal_MagicUISearchBar:(MagicViewSignal *)signal{


    if ([signal is:[MagicUISearchBar BEGINEDITING]]) {
        
//        [searchView setShowsCancelButton:YES];
        
        UIButton *btnSearch = (UIButton *)[searchView viewWithTag:SEATCHBTN_TAG];
        
        if (btnSearch) {
            [btnSearch setHidden:YES];
        }
        strKey = [searchView text];
        page = 1;
        
    }else if([signal is:[MagicUISearchBar CANCEL]]){
    
       strKey = [searchView text];
        
        MagicUISearchBar *obj = (MagicUISearchBar *)[signal object];
        [obj resignFirstResponder];
        [obj setShowsCancelButton:NO];
        
    }else if([signal is:[MagicUISearchBar SEARCH]]){
    
        strKey = [searchView text];
        [self request:1];

    }
}

-(void)request:(int)tag {

    MagicRequest *request = [DYBHttpMethod search_disk_keyword:strKey page:page num:SEARCHNUM type:strSearchType sAlert:YES receive:self];
    [request setTag:tag];

}

-(void)handleViewSignal_DYBDataBankSelectBtn:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankSelectBtn TOUCHSIGLEBTN]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UIButton *btn = (UIButton *)[dict objectForKey:@"btn"];
        DLogInfo(@"tag -- %d",btn.tag);
        
        int row = [[dict objectForKey:@"row"] integerValue];
        DYBDataBankListCell *cell = [arrayCellView objectAtIndex:row]; //关闭 cell
        [cell closeCell];
        
        switch (btn.tag) {
                
            case BTNTAG_SHARE:
                
            {
                DYBDataBankShareEnterView * shareView = [[DYBDataBankShareEnterView alloc]initWithFrame:CGRectMake(0.0f, 0.0f , 320.0f, self.view.frame.size.height) target:self info:[arrayResult objectAtIndex:row] arrayFolderList:arrayResult index:row];
                
                [self.view addSubview:shareView];
                RELEASE(shareView);                
            }
                break;
            case BTNTAG_CHANGE:
            {

                
                DYBDataBankChildrenListViewController *childr = [[DYBDataBankChildrenListViewController alloc]init];
                childr.folderID = @"";
                childr.strFromDir = [NSString stringWithFormat:@"%@",[[arrayResult objectAtIndex:row] objectForKey:@"id"]];
                childr.dictInfo = [arrayResult objectAtIndex:row] ;
                childr.bChangeFolder = YES;
                childr.bChangeSave = NO;
                [self.drNavigationController pushViewController:childr animated:YES];
                RELEASE(childr);
            }
                
                break;
            case BTNTAG_RENAME:
            {
                
                NSString *title = [[arrayResult objectAtIndex:row] objectForKey:@"title"];
                NSString *type = [[arrayResult objectAtIndex:row] objectForKey:@"type"];
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
                downLoad.cellDown = [arrayCellView objectAtIndex:row];
                NSDictionary *dict = [arrayResult objectAtIndex:row];
                [downLoad insertCell:dict];
                
            }
                break;
            case BTNTAG_DEL:
            {
                
                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要删除吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",row]];
            }
                break;
                
            default:
                break;
        }
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
        NSDictionary *dictResult = [arrayResult objectAtIndex:[row integerValue]];
        NSString *fileURL = [dictResult objectForKey:@"file_path"];
        switch ([type integerValue]) {
            case BTNTAG_DEL:{
                
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
                
                
                MagicRequest *request = [DYBHttpMethod document_rename_doc_id:doc_id name:text is_dir:dir indexDataBank:[NSString stringWithFormat:@"%@",row]  sAlert:YES receive:self ];
                
                
                [request setTag:BTNTAG_RENAME];
            }
                break;
            case BTNTAG_SHARE:
                
                break;
                
            default:
                break;
        }
    }
}

-(void)addNOresultImageView:(NSString *)strMsg{

    
    UIView *view = [self.view viewWithTag:NORESULTVIEW];
    if (!view) {
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 44 + SEARCHBAT_HIGH, 300.0f, 400.0f)];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setTag:NORESULTVIEW];
        [self.view insertSubview:view atIndex:0];
        RELEASE(view);
        
        UIImage *image = [UIImage imageNamed:@"ybx_big.png"];
        float BearHeadStartX = (CGRectGetWidth(self.view.frame)-image.size.width/2)/2;
        float BearHeadStartY = (self.frameHeight-self.headHeight-image.size.height/2 - 70)/2-44 - SEARCHBAT_HIGH;
        MagicUIImageView *viewBearHead = [[MagicUIImageView alloc] initWithFrame:CGRectMake(BearHeadStartX, BearHeadStartY, image.size.width/2, image.size.height/2)];
        [viewBearHead setBackgroundColor:[UIColor clearColor]];
        [viewBearHead setUserInteractionEnabled:YES];
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

-(void)creatCell{

    [arrayCellView removeAllObjects];
    
    for (int i = 0; i < arrayResult.count; i++) {
        
        NSDictionary *dict = [arrayResult objectAtIndex:i];
        DYBDataBankListCell *cell = [[DYBDataBankListCell alloc] init];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [cell setIndexPath:indexPath];
        [cell setTb:tbDataBank];
        [cell setCellType:0];
        [cell initViewCell_dict:dict];
        [arrayCellView addObject:cell];
        [cell release];
        
    }
    
    RELEASEDICTARRAYOBJ(tbDataBank._muA_differHeightCellView)
    tbDataBank._muA_differHeightCellView = [[NSMutableArray alloc]initWithArray:arrayCellView];
    [tbDataBank reloadData];

}


-(void)removerNOresultImageView{

    UIView *view = [self.view viewWithTag:NORESULTVIEW];
    if (view) {

        [view removeFromSuperview];
    }
}


- (void)dealloc
{
    RELEASE(shareIntance)
    shareIntance = nil;
    RELEASE(strKey);
    RELEASEDICTARRAYOBJ(arrayResult);
    RELEASEDICTARRAYOBJ(arrayCellView)
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
