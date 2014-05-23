//
//  DYBDataBankController.m
//  DYiBan
//
//  Created by tom zeng on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankListController.h"
#import "DYBHttpMethod.h"
//#import "DYBDataBa、nkListCell.h"
//#import "DYBSideSwipeTableViewCell.h"
#import "DYBDataBankListCell.h"
#import "databanklist.h"
#import "DYBDataBankChildrenListViewController.h"
#import "DYBDataBankShotView.h"
#import <Accelerate/Accelerate.h>
#import "scrollerData.h"
#import "DYBScroller.h"
#import "DYBUITabbarViewController.h"
#import "UIView+MagicCategory.h"
#import "DYBUITabbarViewController.h"
#import "UITableView+property.h"
#import "DYBDataBankSelectBtn.h"
#import "DYBDataBankEclassListsViewController.h"
#import "DYBSelectContactViewController.h"
#import "DYBDataBankFileDetailViewController.h"
#import "DYBDataBankDownloadManageViewController.h"
#import <MediaPlayer/MediaPlayer.h> 
#import "DYBDataBnakSchoolAndCollegeViewController.h"
#import "DYBDataBankShareEnterView.h"
#import "Magic_Device.h"
#import "UserSettingMode.h"
#import "DYBGuideView.h"

static DYBDataBankListController *shareInstanceDataList = nil;

@interface DYBDataBankListController (){

    
    int page;
    int num;
    
    NSMutableArray *arrayFolderList;
    
    DYBUITableView *tbDataBank;
    DYBDtaBankSearchView *searchView;
    DYBDataBankFileDetailViewController *showFile;
    
    
}

@end

@implementation DYBDataBankListController

@synthesize tabbarView = _tabbarView,sender,arrayCellView;

DEF_SIGNAL(OPERATIONTABBARHIDE)
DEF_SIGNAL(OPEATTIONTABBARSHOW)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


+(DYBDataBankListController *)creatShareInstance{

    if (!shareInstanceDataList) {
        shareInstanceDataList = [[DYBDataBankListController alloc]init];
    }

    return shareInstanceDataList;
}

-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{

    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"所有资料"];
        
        if (![[NSUserDefaults standardUserDefaults] stringForKey:@"DYBDataBankListController"] || [[[NSUserDefaults standardUserDefaults] stringForKey:@"DYBDataBankListController"] intValue]==0) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DYBDataBankListController"];
            
            {
                DYBGuideView *guideV=[[DYBGuideView alloc]initWithFrame:self.view.frame];
                guideV.AddImgByName(@"databasehelp3", @"databasehelp2", @"databasehelp1",nil);
                [self.drNavigationController.view addSubview:guideV];
                RELEASE(guideV);
            }
        }
    }
   else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
       
        page = 1;
        num = 100;
       
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:@"" order:@"1" asc:@"1" num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@""  sAlert:YES receive:self];
        [request setTag:REQUESTTAG_FIRIST];

        tbDataBank = [[DYBUITableView alloc]initWithFrame:CGRectMake(0.0f, SEARCHBAT_HIGH + 44, 320.0f, self.view.frame.size.height - SEARCHBAT_HIGH - 44 - 20) isNeedUpdate:YES];
       
        [tbDataBank setTableViewType:DTableViewSlime];
        [self.view addSubview:tbDataBank];
        [tbDataBank setSeparatorColor:[UIColor clearColor]];
        RELEASE(tbDataBank);
               
        searchView = [[DYBDtaBankSearchView alloc]initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH) ];
        [searchView initView:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH) ];
        [self.view addSubview:searchView];
        [searchView release];
        [searchView setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
        
        tbDataBank.v_headerVForHide = searchView;
        
        arrayCellView = [[NSMutableArray alloc]init];
    }


   else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
              DLogInfo(@"rrr");
   } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
   
   
   
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


-(void)handleViewSignal_DYBDtaBankSearchView:(MagicViewSignal *)signal{

    if ([signal is:[DYBDtaBankSearchView FIRSTTOUCH]]) {
        
        DYBDtaBankSearchView *tt = (DYBDtaBankSearchView *)[signal object];
        [tt setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
        [self changeSearchBarFrame];
        
    }else if([signal is:[DYBDtaBankSearchView RECOVERBAR]]){
        
        DYBDtaBankSearchView *tt = (DYBDtaBankSearchView *)[signal object];
        [tt setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
        [self recoverSearchBar];
        
    }else if ([signal is:[DYBDtaBankSearchView DELOBJ]]){
    
        NSString *url = (NSString *)[signal object];
        
        for (int i = 0; i < arrayFolderList.count ; i++) {
            
            NSDictionary *dict = [arrayFolderList objectAtIndex:i];
            
            NSString *strEncode = [dict objectForKey:@"file_urlencode"];
            if ([strEncode isEqualToString:url]) {
                
                [arrayFolderList removeObjectAtIndex:i];
                break;
            }
        }
        
        [self creatCell];
  
    
    }else if ([signal is:[DYBDtaBankSearchView NEWNAME]]){
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        NSDictionary *dictNEW = [dict objectForKey:@"dict"];
        NSString *url = [dict objectForKey:@"url"];
        
        for (int i = 0; i < arrayFolderList.count ; i++) {
            
            NSDictionary *dict = [arrayFolderList objectAtIndex:i];
            
            NSString *strEncode = [dict objectForKey:@"file_urlencode"];
            if ([strEncode isEqualToString:url]) {
                
                [arrayFolderList replaceObjectAtIndex:i withObject:dictNEW];
                break;
            }
        }
        
        [self creatCell];
    
    }
}

-(void)creatCell{

    [arrayCellView removeAllObjects];
    
    for (int i = 0; i < arrayFolderList.count; i++) {
        
        NSDictionary *dict = [arrayFolderList objectAtIndex:i];
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

-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{

    DLogInfo(@"ddddd");
    if ([signal is:[DYBDataBankShotView LEFT]]) {
        
    }
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *text = [dict objectForKey:@"text"];
        NSString *type = [dict objectForKey:@"type"];
        NSNumber *row = [dict objectForKey:@"rowNum"];
        NSDictionary *dictResult = [arrayFolderList objectAtIndex:[row integerValue]];
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


#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    

    JsonResponse *response = (JsonResponse *)receiveObj;
    if (request.tag == BTNTAG_DEL) {
        
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            tbDataBank._selectIndex_now = nil;
            
            NSString *index = [response.data objectForKey:@"indexDataBack"];
            [arrayFolderList removeObjectAtIndex:[index integerValue]];
            
            [self creatCell];
            
        }
        
    }if (request.tag == BTNTAG_RENAME) {
        
        if ([response response] ==khttpsucceedCode)
        {
            
            if ([[response.data objectForKey:@"result"] boolValue]) {
                
                DLogInfo(@"dddd");
                NSDictionary *dict = [response.data objectForKey:@"list"];
                
                NSInteger index = [[response.data objectForKey:@"indexDataBack"] integerValue];
                
                if (dict) {
                    [arrayFolderList replaceObjectAtIndex:index withObject:dict];
                }
                
                
                [self creatCell];
                
            }
            
            NSString *strMSG = [response.data objectForKey:@"msg"];
            
            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        
        }
    }else if (request.tag == REQUESTTAG_MORE){
    
         if ([[response.data objectForKey:@"result"] boolValue]) {
        
             NSArray *list=[response.data objectForKey:@"list"];
        
             [arrayFolderList addObjectsFromArray:list];
             searchView.arrayResourcesList = arrayFolderList;
             
             [self creatCell];
             
             searchView.arrayViewCell = arrayCellView;

             BOOL bHaveNext = [[response.data objectForKey:@"havenext"] boolValue];
             
             if (bHaveNext == 1) {
                 [tbDataBank reloadData:NO];
             }else{
                 [tbDataBank reloadData:YES];
             }
        }
    }
    
    else if (request.tag == REQUESTTAG_FIRIST){
    
        if ([[response.data objectForKey:@"result"] boolValue])
        {
            
            RELEASEDICTARRAYOBJ(arrayFolderList);
            [arrayCellView removeAllObjects];
            
            NSArray *list=[response.data objectForKey:@"list"];
            DLogInfo(@"list -- %@",list);

            arrayFolderList = [[NSMutableArray alloc]initWithArray:list];
            searchView.arrayResourcesList = arrayFolderList;

            [self creatCell];
//            searchView.arrayViewCell = arrayCellView;

            searchView.current_dir = [response.data objectForKey:@"current_dir"];
            
            BOOL bHaveNext = [[response.data objectForKey:@"havenext"] boolValue];
            
            if (bHaveNext == 1) {
                [tbDataBank reloadData:NO];
            }else{
                [tbDataBank reloadData:YES];
            }
        }
    }
}




#pragma SearchView Delegate

-(void)changeSearchBarFrame{

    [searchView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, self.view.frame.size.height - 44)];
    [searchView setBackgroundColor:[UIColor clearColor]];
    [searchView.tbDataBank setFrame:CGRectMake(0.0f, searchView.tbDataBank.frame.origin.y , 320.0f, searchView.frame.size.height - SEARCHBAT_HIGH)];
}

-(void)recoverSearchBar{
    
    [searchView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH)];
    [searchView setBackgroundColor:[UIColor clearColor]];
    [searchView.tbDataBank setHidden:YES];
}

#pragma mark- 只接受tbv信号
//--

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{

    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSNumber *s = [NSNumber numberWithInteger:arrayFolderList.count];
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
        
    }
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
        [signal setReturnValue:cell ];
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        NSDictionary *dictResult = [arrayFolderList objectAtIndex:indexPath.row];

        BOOL isFolder = [[dictResult objectForKey:@"is_dir"] boolValue];
        
        if (!isFolder) {  //文件暂时不好浏览
            
            BOOL bShow = [DYBShareinstaceDelegate noShowTypeFileTarget:self type:[dictResult objectForKey:@"type"]];
            
            if (!bShow) {
                return;
            }
            
            showFile = [[DYBDataBankFileDetailViewController alloc]init];
            showFile.dictFileInfo = dictResult;
            showFile.iPublicType = 1;
            showFile.targetObj = self;
            showFile.index = indexPath.row;
            [self.drNavigationController pushViewController:showFile animated:YES];
            RELEASE(showFile);
            return ;
        }

        DYBDataBankChildrenListViewController *childerListController = [[DYBDataBankChildrenListViewController alloc]init];
        [childerListController setStrTitle:[dictResult objectForKey:@"title"]];
        [childerListController setFolderID:[dictResult objectForKey:@"file_path"]];
        [self.drNavigationController pushViewController:childerListController animated:YES];
        [childerListController release];
        
        [self cancelSelect];
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]) //刷新
    {
        MagicUIUpdateView *uptableview = (MagicUIUpdateView *)[signal object];
        
        page = 1;
        
        MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:@"" order:@"1" asc:@"1"  num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@""  sAlert:NO receive:self];
        [request setTag:REQUESTTAG_FIRIST];
        
        if (!request) {//无网路
            [uptableview setUpdateState:DUpdateStateNomal];
            [tbDataBank reloadData:NO];
        }        
        
    }else if([signal is:[MagicUITableView TAbLEVIEWLODATA]]) //加载更多
    {
        
        MagicUIUpdateView *uptableview = (MagicUIUpdateView *)[signal object];
        
        page ++;
        
        MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:@"" order:@"1" asc:@"1"  num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@""  sAlert:YES receive:self];
        [request setTag:REQUESTTAG_MORE];
        
        if (!request) {//无网路
            [uptableview setUpdateState:DUpdateStateNomal];
            [tbDataBank reloadData:NO];
        }
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){ //上滑动
        
        [tbDataBank StretchingUpOrDown:0];
        [DYBShareinstaceDelegate opeartionTabBarShow:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){ //下滑动
        
        [tbDataBank StretchingUpOrDown:1];
        [DYBShareinstaceDelegate opeartionTabBarShow:NO];
    }

}


-(void)cancelSelect{
    
    [tbDataBank deselectRowAtIndexPath:[tbDataBank indexPathForSelectedRow] animated:YES];

}

//转存完成要刷新根目录列表
-(void)handleViewSignal_DYBDataBankChildrenListViewController:(MagicViewSignal *)signal{

    if ([signal is:[DYBDataBankChildrenListViewController REFRESH]]) {        
        
        MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:@"" order:@"1" asc:@"1" num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",1] keyword:@""   sAlert:YES receive:self];
        [request setTag:REQUESTTAG_FIRIST];
        
    }else if ([signal is:[DYBDataBankChildrenListViewController SUCCESSCHANGEFOLDER]]){
            
            
            NSString *url = (NSString *)[signal object];
        
            for (int i = 0; i < arrayFolderList.count ; i++) {
                
                NSDictionary *dict = [arrayFolderList objectAtIndex:i];
                
                NSString *strEncode = [dict objectForKey:@"file_urlencode"];
                if ([strEncode isEqualToString:url]) {
                    
                    [arrayFolderList removeObjectAtIndex:i];
                    break;
                }
            }
            
            [self creatCell];
        
        }
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
                
                DYBDataBankShareEnterView * shareView = [[DYBDataBankShareEnterView alloc]initWithFrame:CGRectMake(0.0f, 0.0f , 320.0f, self.view.frame.size.height) target:self info:[arrayFolderList objectAtIndex:row] arrayFolderList:arrayFolderList index:row];
                [self.view addSubview:shareView];
                RELEASE(shareView);
                
            }
                break;
            case BTNTAG_CHANGE:
            {

                DYBDataBankChildrenListViewController *childr = [[DYBDataBankChildrenListViewController alloc]init];
                childr.folderID = @"";
                childr.strFromDir = [NSString stringWithFormat:@"%@",[[arrayFolderList objectAtIndex:row] objectForKey:@"id"]];
                childr.dictInfo = [arrayFolderList objectAtIndex:row] ;
                childr.bChangeFolder = YES;
                childr.bChangeSave = NO;
                childr.popController = self;
                [self.drNavigationController pushViewController:childr animated:YES];
                RELEASE(childr);
            }
                
                break;
            case BTNTAG_RENAME:
            {
                NSString *title = [[arrayFolderList objectAtIndex:row] objectForKey:@"title"];
                NSString *type = [[arrayFolderList objectAtIndex:row] objectForKey:@"type"];
                
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
                NSDictionary *dict = [arrayFolderList objectAtIndex:row];
                
                
                if ([MagicDevice hasInternetConnection] == NO/*无网络*/ || (SHARED.currentUserSetting.wifiForPush && ![[MagicDevice networkType] isEqualToString:@"wifi"]/*开了wifi下才能下载但不是wifi环境*/)) {//
                    
                    [self addOrHideDownIcan:[dict objectForKey:@"file_urlencode"] add:NO];

                }else{
                    [self addOrHideDownIcan:[dict objectForKey:@"file_urlencode"] add:YES];
                }
                
                
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

-(void)addOrHideDownIcan:(NSString *)key add:(BOOL)bAdd{
    
    for (DYBDataBankListCell *cell in arrayCellView) {
        if ([cell.strTag isEqualToString:key]) {
            [cell.imageViewDown setHidden:!bAdd];
        }
    }
}

-(void)handleViewSignal_DYBDataBankFileDetailViewController:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankFileDetailViewController NEWNAME]]) {
       
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        NSDictionary *dictNEW = [dict objectForKey:@"dict"];
        NSString *url = [dict objectForKey:@"url"];
        for (int i = 0; i < arrayFolderList.count ; i++) {
            
            NSDictionary *dict = [arrayFolderList objectAtIndex:i];
            
            NSString *strEncode = [dict objectForKey:@"file_urlencode"];
            if ([strEncode isEqualToString:url]) {
                
                [arrayFolderList replaceObjectAtIndex:i withObject:dictNEW];
                break;
            }
        }        
        [self creatCell];
    }else if([signal is: [DYBDataBankFileDetailViewController DELFILE]]){

        NSString *url = (NSString *)[signal object];
        
        for (int i = 0; i < arrayFolderList.count ; i++) {
            
            NSDictionary *dict = [arrayFolderList objectAtIndex:i];
            
            NSString *strEncode = [dict objectForKey:@"file_urlencode"];
            if ([strEncode isEqualToString:url]) {
                
                [arrayFolderList removeObjectAtIndex:i];
                break;
            }
        }        
        [self creatCell];        
    }
}

-(void)refreshList{

    page = 1;
    MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:@"" order:@"1" asc:@"1"  num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@""  sAlert:NO receive:self];
    [request setTag:REQUESTTAG_FIRIST];
    
    if (!request) {//无网路
//        [uptabletbDataBankview setUpdateState:DUpdateStateNomal];
        [tbDataBank reloadData:NO];
    }


}

- (void)dealloc
{
    RELEASE(shareInstanceDataList);
    shareInstanceDataList = nil;
    
    RELEASEDICTARRAYOBJ(arrayFolderList);
    
    for (DYBDataBankListCell *view in arrayCellView ) { //强制释放array中的对象
        
        [view release];
        view  = nil;
        
    }

    RELEASEDICTARRAYOBJ(arrayCellView);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
