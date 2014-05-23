//
//  DYBDataBankChildrenListViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-8-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankChildrenListViewController.h"
#import "UIView+MagicCategory.h"
#import "scrollerData.h"
#import "DYBScroller.h"
#import "DYBDataBankShotView.h"
#import "DYBSelectContactViewController.h"
#import "DYBDataBankEclassListsViewController.h"
#import "DYBDataBankSelectBtn.h"
#import "UIView+MagicCategory.h"
#import "UITableView+property.h"
#import "DYBHttpMethod.h"
#import "Magic_Request.h"
#import "DYBDataBankFileDetailViewController.h"
#import "DYBDataBankDownloadManageViewController.h"
#import "DYBDataBankShareEnterView.h"
#import "DYBDataBankTopRightCornerView.h"
#import "DYBUITabbarViewController.h"
#import "DYBDataBankListController.h"
#import "Magic_Device.h"
#import "UserSettingMode.h"
#import "NSObject+MagicDatabase.h"
#import "NSString+Count.h"
#import "DYBDataBankFileDetailViewController.h"

#define RIGHTVIEWTAG 89
#define NORESULTVIEW 100


@interface DYBDataBankChildrenListViewController (){

    DYBUITableView *tbDataBank;
    DYBDtaBankSearchView *searchView;
    
    int right;
    int page ;
    int num ;
    
    NSMutableArray *arrayFolderList;
    NSMutableArray *arrayCellView;
    NSString *strCurrent_dir;
}

@end

@implementation DYBDataBankChildrenListViewController

@synthesize folderID,strTitle = _strTitle,bChangeFolder = _bChangeFolder,strFromDir = _strFromDir;
@synthesize current_dir = _current_dir,currentFile = _currentFile,dictInfo = _dictInfo;
@synthesize strChangeType = _strChangeType,popController = _popController,iInfoID = _iInfoID;

DEF_SIGNAL(ADDFOLDER)
DEF_SIGNAL(REFRESH)
DEF_SIGNAL(SUCCESSCHANGEFOLDER)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void)handleViewSignal:(MagicViewSignal *)signal{

    if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        arrayCellView = [[NSMutableArray alloc]init];
        
        right = 1;
        page = 1;
        num = 10;
        
        MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:folderID order:@"1" asc:@"2" num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@""  sAlert:YES receive:self];
        [request setTag:REQUESTTAG_FIRIST];
        
        float tabelViewHigh = 0;

            tabelViewHigh = self.view.frame.size.height - SEARCHBAT_HIGH - 44 -20;

        
        tbDataBank = [[DYBUITableView alloc]initWithFrame:CGRectMake(0.0f, 44.0f + SEARCHBAT_HIGH, 320.0f, tabelViewHigh) isNeedUpdate:YES];
        
        [self.view addSubview:tbDataBank];
        [tbDataBank setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tbDataBank release];
        
        
        searchView = [[DYBDtaBankSearchView alloc]initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH)];
        [searchView initView:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH) ];
        [self.view addSubview:searchView];
        [searchView release];

        tbDataBank.v_headerVForHide = searchView;
        [tbDataBank setTableViewType:DTableViewSlime];
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]]){
    
        [self setButtonImage:self.leftButton setImage:@"btn_back_def" setHighString:@"btn_back_hlt"];
        [self.headview setTitle:_strTitle];
        
        if (_bChangeFolder) {
            
            if (_strTitle.length == 0) {
                
                 [self.headview setTitle:@"所有资料"];
            }else{
            
                [self.headview setTitle:_strTitle];
            }
            [self.rightButton setHidden:NO];
            [self setButtonImage:self.rightButton setImage:@"btn_ok_def" setHighString:@"btn_ok_high"] ;
            
            [self creatAddFolderBar];
        }else{
        
            //显示排序按钮
            [self setButtonImage:self.rightButton setImage:@"btn_sequence_def.png" setHighString:@"btn_sequence_hlt"] ;
        
        }
    }
}
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        if (_bChangeFolder && !_bChangeSave) {
                    
            if (strCurrent_dir.length == 0) {
                
                strCurrent_dir = @"";                
            }
            
            MagicRequest *request = [DYBHttpMethod document_move_name:[_dictInfo objectForKey:@"title"] old_dir:[_dictInfo objectForKey:@"file_path"] new_dir:strCurrent_dir isAlert:YES receive:self];
            [request setTag:3];
            
        }else if(_bChangeSave){
            
            NSString *userID = [_dictInfo objectForKey:@"owner_id"];
            NSString *strFrom = [_dictInfo objectForKey:@"file_path"];
            if (strCurrent_dir.length == 0) {
                
                strCurrent_dir = @"";

            }
            
            MagicRequest *request = [DYBHttpMethod document_changestore_from_id:userID doc_from:strFrom doc_to:strCurrent_dir type:_strChangeType isAlert:YES receive:self];
            [request setTag:13];
            
        }else{
            
            [self addRightTopView];
           
        }
    }
}

-(void)addRightTopView{
    
    UIView *view = [self.view viewWithTag:RIGHTVIEWTAG];
    if (!view) {
        
        NSArray *arrayType = [[NSArray alloc]initWithObjects:@"按时间",@"按类型", nil];
        DYBDataBankTopRightCornerView *rightV = [[DYBDataBankTopRightCornerView alloc]initWithFrame:CGRectMake(320.0f - 95, 40, 90, 99) arrayResult:arrayType target:self];
        [rightV setBackgroundColor:[UIColor clearColor]];
        
        [rightV setTag:RIGHTVIEWTAG];
        [self.view addSubview:rightV];
        RELEASE(rightV);
        RELEASE(arrayType);
        
    }else{
        
        if (view.hidden) {
            
            [view setHidden:NO];
            
        }else{
            [view setHidden:YES];
            
        }
    }
}

-(BOOL)hideRightView{
    
    UIView *view = [self.view viewWithTag:RIGHTVIEWTAG];
    
    if (view) {
        
        if (!view.hidden) {
            
            [view setHidden:YES];
            return YES;
        }
        return NO;
    }
    return NO;
}

-(void)handleViewSignal_DYBDataBankTopRightCornerView:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankTopRightCornerView TOUCHSINGLEBTN]]) {
        
        NSNumber *num1 = (NSNumber *)[signal object];
        UIView *view = [self.view viewWithTag:RIGHTVIEWTAG];
//        right = [num1 integerValue];
        page = 1;
        switch ([num1 integerValue]) {
            case 1:
            {
                
                right = 1;
                MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:folderID order:@"1" asc:@"2" num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@""  sAlert:YES receive:self];
                [request setTag:REQUESTTAG_FIRIST];

            
            }
                break;
            case 2:{
            
                right = 3;
                MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:folderID order:@"3" asc:@"1" num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@""  sAlert:YES receive:self];
                [request setTag:REQUESTTAG_FIRIST];
            }
                
                break;
//            case 3:{
//            
//                MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:folderID order:@"3" asc:@"1" num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@""
//                                                                      sAlert:YES receive:self];
//                [request setTag:REQUESTTAG_FIRIST];
//            }
//                
//                break;
//            case 4:
//            {
//            
//                MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:folderID order:@"4" asc:@"1"  num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@""  sAlert:YES receive:self];
//                [request setTag:REQUESTTAG_FIRIST];
//            
//            }
//                break;
                
            default:
                break;
        }
        
        if (!view.hidden && view) {
            [view setHidden:YES];
        }
    }
}



-(void)handleViewSignal_DYBDataBankChildrenListViewController:(MagicViewSignal *)signal{

     if ([signal is:[DYBDataBankChildrenListViewController ADDFOLDER]])
    {
        
        [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"新建文件夹" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_ADDFOLDER ];
        
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

-(void)creatAddFolderBar{
    
    UIView *view = [self.view viewWithTag:99];
    if (!view) {
        
        UIImage *image = [UIImage imageNamed:@"btn_newfolder_def"];
        
        UIImageView *barView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, self.view.bounds.size.height- image.size.height/2 - 20 - 2, 320, image.size.height/2 +2)];
        [barView setImage:[UIImage imageNamed:@"bg_whitefooter"]];
        [barView setUserInteractionEnabled:YES];
        [barView setTag:99];
        [barView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:barView];
        RELEASE(barView);
        
        MagicUIButton *btn = [[MagicUIButton alloc]initWithFrame:CGRectMake(320 - image.size.width/2 , 2.0f, image.size.width/2, image.size.height/2 )];
        [btn setImage:[UIImage imageNamed:@"btn_newfolder_def"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_newfolder_hlt"] forState:UIControlStateHighlighted];
        [btn setBackgroundColor:[UIColor clearColor]];
        
        [btn addSignal:[DYBDataBankChildrenListViewController ADDFOLDER] forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:btn];
        RELEASE(btn);

    }    
}

- (void)hideTabBar:(BOOL)isHidden animated:(BOOL)animated opeartionView:(UIView *)view
{
    
    float _barHeight = view.frame.size.height;
    
    if (isHidden)
    {
        if (view.frame.origin.y == self.view.frame.size.height)
        {
            return;
        }
    }else
    {
        if (view.frame.origin.y == self.view.frame.size.height - _barHeight)
        {
            return;
        }
    }
    
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3f];
        if (isHidden)
        {
            CHANGEFRAMEORIGIN(view.frame, view.frame.origin.x, view.frame.origin.y + _barHeight);
        }else
        {
            CHANGEFRAMEORIGIN(view.frame, view.frame.origin.x, view.frame.origin.y - _barHeight);
        }
        [UIView commitAnimations];
    }else
    {
        if (isHidden)
        {
            CHANGEFRAMEORIGIN(view.frame, view.frame.origin.x, view.frame.origin.y + _barHeight);
        }else
        {
            CHANGEFRAMEORIGIN(view.frame, view.frame.origin.x, view.frame.origin.y - _barHeight);
        }
    }
}


#pragma mark- 只接受tbv信号
//static NSString *reuseIdentifier = @"reuseIdentifier";

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
        if ([self hideRightView]) {
            return;
        }
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        NSDictionary *dictResult = [arrayFolderList objectAtIndex:indexPath.row];
        
        BOOL isFolder = [[dictResult objectForKey:@"is_dir"] boolValue];
        
        if (!isFolder) {  //文件暂时不好浏览
            
            BOOL bShow = [DYBShareinstaceDelegate noShowTypeFileTarget:self type:[dictResult objectForKey:@"type"]];
            
            if (!bShow) {
                return;
            }
            
            DYBDataBankFileDetailViewController *showFile = [[DYBDataBankFileDetailViewController alloc]init];
            showFile.targetObj = self;
            showFile.iPublicType = 1; 
            showFile.dictFileInfo = dictResult;
            [self.drNavigationController pushViewController:showFile animated:YES];
            RELEASE(showFile);
            return ;
        }
        
        DYBDataBankChildrenListViewController *childerListController = [[DYBDataBankChildrenListViewController alloc]init];
        
        if (_bChangeFolder&&!_bChangeSave) { //移动文件
            
            childerListController.bChangeFolder = YES;
            childerListController.dictInfo = _dictInfo;
            childerListController.strChangeType = _strChangeType;
            [childerListController setStrFromDir: _strFromDir];
            childerListController.bChangeSave = NO;
            childerListController.popController = _popController;
            
        }else if(_bChangeSave){ //转存文件
        
            childerListController.bChangeFolder = YES;
            childerListController.bChangeSave = YES;
            childerListController.folderID = @"";
            childerListController.strChangeType = _strChangeType;
     
            childerListController.dictInfo = _dictInfo; //文件的信息信息传送到下一层
            childerListController.strFromDir = [NSString stringWithFormat:@"%@",[[arrayFolderList objectAtIndex:indexPath.row] objectForKey:@"file_path"]];
            
        }

        [childerListController setStrTitle:[dictResult objectForKey:@"title"]];
        [childerListController setFolderID:[dictResult objectForKey:@"file_path"]];
        [childerListController setCurrentFile:[dictResult objectForKey:@"file_path"]];
        [self.drNavigationController pushViewController:childerListController animated:YES];
        [childerListController release];

        [tbDataBank deselectRowAtIndexPath:[tbDataBank indexPathForSelectedRow] animated:YES];        
        
    }else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])
    {
        
    }
    else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])
    {
        DLogInfo(@"1111");
        [self hideRightView];
//        MagicUITableView *tableview = (MagicUITableView *)[signal source];
//        [tableview reloadData:NO];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){
        [tbDataBank StretchingUpOrDown:0];
        
        if (_bChangeFolder) {
            
            UIView *view = [self.view viewWithTag:99];
            if (view) {
                [self hideTabBar:YES animated:YES opeartionView:view];
            }
        }
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){
        [tbDataBank StretchingUpOrDown:1];
        
        if (_bChangeFolder) {
            
            UIView *view = [self.view viewWithTag:99];
            if (view) {
                [self hideTabBar:NO animated:YES opeartionView:view];
                
            }
        }
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])
    {

        [self.view setUserInteractionEnabled:NO];
       
        page = 1;
        
        int asc = 1;
        
        if (right == 1) {
            asc = 2;
        }else{
            asc = 1;
        }
        
        MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:folderID order:[NSString stringWithFormat:@"%d",right] asc:[NSString stringWithFormat:@"%d",asc] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@""  sAlert:YES receive:self];
        [request setTag:REQUESTTAG_FIRIST];
        
        if (!request) {//无网路
            [tbDataBank reloadData:NO];
        }
        
    }else if([signal is:[MagicUITableView TAbLEVIEWLODATA]])
    {
        page ++ ;
        int asc = 1;
        
        if (right == 1) {
            asc = 2;
        }else{
            asc = 1;
        }

        MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:folderID order:[NSString stringWithFormat:@"%d",right] asc:[NSString stringWithFormat:@"%d",asc] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@""  sAlert:YES receive:self];
        [request setTag:REQUESTTAG_MORE];
        
        if (!request) {//无网路
            [tbDataBank reloadData:NO];
        }
    }    
}


#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    [self.view setUserInteractionEnabled:YES];
    JsonResponse *response = (JsonResponse *)receiveObj;
    if (request.tag == BTNTAG_DEL) {
        
        if ([[response.data objectForKey:@"result"] boolValue]) {

            
            tbDataBank._selectIndex_now = nil;
            
            NSString *index = [response.data objectForKey:@"indexDataBack"];
            [arrayFolderList removeObjectAtIndex:[index integerValue]];
            
            [self creatCell];

        }
 
    }if (request.tag == BTNTAG_RENAME) {
        
        
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
    
    else if (request.tag ==REQUESTTAG_FIRIST){
        
        
        if ([response response] ==khttpsucceedCode)
        {
            
             if ([[response.data objectForKey:@"result"] boolValue]) {
            RELEASEDICTARRAYOBJ(arrayFolderList);
            [arrayCellView removeAllObjects];
            
            NSArray *list=[response.data objectForKey:@"list"];
            
            arrayFolderList = [[NSMutableArray alloc]initWithArray:list];
            searchView.arrayResourcesList = arrayFolderList;
            
            for (int i = 0; i < arrayFolderList.count; i++) {
                NSDictionary *dict = [arrayFolderList objectAtIndex:i];
                DYBDataBankListCell *cell = [[DYBDataBankListCell alloc] init];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [cell setIndexPath:indexPath];
                [cell setTb:tbDataBank];
                
                if (_bChangeFolder) {
                    [cell setBSwip:@"NO"];
                }
                [cell setCellType:0];
                [cell initViewCell_dict:dict];
                [arrayCellView addObject:cell];
                RELEASE(cell);
                
            }
            
//            [tbDataBank._muA_differHeightCellView release];
                 RELEASEDICTARRAYOBJ(tbDataBank._muA_differHeightCellView)
            
            tbDataBank._muA_differHeightCellView = [[NSMutableArray alloc]initWithArray:arrayCellView];
            
            [strCurrent_dir release];
            strCurrent_dir = nil;
            strCurrent_dir = [[NSString alloc]initWithString:[response.data objectForKey: @"current_dir"]];

            [tbDataBank reloadData];
            
            searchView.current_dir = strCurrent_dir;
                 
            if (arrayFolderList.count == 0) {
                
                [self addNOresultImageView:@"该文件夹没有文件哦！"];
            
            }else{
            
                UIView *view = [self.view viewWithTag:NORESULTVIEW];
                
                if (view) {
                    [view removeFromSuperview];
                
                }
            }
        }
        
            BOOL bHaveNext = [[response.data objectForKey:@"havenext"] boolValue];
            
            if (bHaveNext == 1) {
                [tbDataBank reloadData:NO];
            }else{
                [tbDataBank reloadData:YES];
            }
            
       
        }

    }if (request.tag == BTNTAG_ADDFOLDER) {
        
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            MagicRequest *request = [DYBHttpMethod dataBankList_navi_id:folderID order:@"1" asc:@"2"  num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@""  sAlert:YES receive:self];
            [request setTag:REQUESTTAG_FIRIST];
            
        }else{
        
        NSString *strMSG = [response.data objectForKey:@"msg"];
        [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        }
    }else if (request.tag == 3){ // yidong zhuancun
    
        if ([[response.data objectForKey:@"result"] boolValue])
        {
//            // 刷新DB 离线的数据
            
            
            NSString *strEncode = [_dictInfo objectForKey:@"file_urlencode"];
            
            
            
            [self sendViewSignal:[DYBDataBankChildrenListViewController SUCCESSCHANGEFOLDER] withObject:strEncode from:self target:_popController];
            
            if([_popController isKindOfClass:[DYBDataBankFileDetailViewController class]])
            {
                NSDictionary *dictSendInfo = nil;
                if (strCurrent_dir.length == 0) { //移动到根目录
                    
                    dictSendInfo = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"bRoot",strEncode,@"strEncode", nil];
                }else{
                
                    dictSendInfo = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"bRoot",strEncode,@"strEncode", nil];
                }
                
                [self sendViewSignal:[DYBDataBankFileDetailViewController DELFILE] withObject:dictSendInfo from:self target:_popController];
                
                RELEASE(dictSendInfo);
            }
            
            
            NSDictionary *dict = [response.data objectForKey:@"list"];
            
            [_dictInfo setValue:[dict objectForKey:@"dir"] forKey:@"dir"];
            [_dictInfo setValue:[dict objectForKey:@"file_path"] forKey:@"file_path"];
            [_dictInfo setValue:[dict objectForKey:@"file_url"] forKey:@"file_url"];
            [_dictInfo setValue:[dict objectForKey:@"file_urlencode"] forKey:@"file_urlencode"];
//            _dictInfo = dict;
//            [_dictInfo retain];
            
            NSString *strUrl = [_dictInfo objectForKey:@"file_urlencode"];
            
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", strUrl).WHERE(@"userid", SHARED.userId).GET();
            
            NSString *downFileNameNew = [self downFileName:[dict objectForKey:@"file_urlencode"]];
          
            if (self.DB.resultArray.count > 0) {
                
                NSString *strTypeList = [[self.DB.resultArray objectAtIndex:0] objectForKey:@"type"];
                //删除旧的数据，添加新的数据
                
                self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", strUrl).WHERE(@"userid", SHARED.userId).DELETE();
                
                self.DB.FROM(kDATABANKDOWNDETAIL).WHERE(@"file_urlencode", strUrl).WHERE(@"userid", SHARED.userId).DELETE();
                
                
                NSString *encodeURL = [_dictInfo objectForKey:@"file_urlencode"];
                NSString *downFileNameOld = [MagicCommentMethod md5:encodeURL];
                downFileNameOld = [downFileNameOld stringByAppendingString:[NSString stringWithFormat:@".%@",[_dictInfo objectForKey:@"type"]]];
                NSString *downloadPathOld = [NSString stringWithFormat:@"%@%@", [MagicCommentMethod downloadPath], downFileNameOld];
                
                NSString *strType = [[_dictInfo objectForKey:@"type"] lowercaseString];
                
                if ([strType isEqualToString:@"jpg"]||[strType isEqualToString:@"png"]||[strType isEqualToString:@"bmp"]) {
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                    NSString * diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
                    NSString *encoderUrl= [[_dictInfo objectForKey:@"file_url"] stringByAddingPercentEscapesUsingEncoding];
                    NSString *md5 =  [MagicCommentMethod dataBankMD5:encoderUrl];
                    NSString *pathtt = [diskCachePath stringByAppendingPathComponent:md5];
                    
                    NSFileManager* fm=[NSFileManager defaultManager];
                    if([fm fileExistsAtPath:pathtt]){
                        
                        NSString *md5New =  [MagicCommentMethod dataBankMD5:[dict objectForKey:@"file_url"]];
                        NSString *pathttNew = [diskCachePath stringByAppendingPathComponent:md5New];
                        NSData *data = [fm contentsAtPath:pathtt];
                        [data writeToFile:pathttNew atomically:YES];
                        
                        [fm removeItemAtPath:pathtt error:nil];
                        
                    }
                    
                }else{
                
                    
                    NSFileManager* fm=[NSFileManager defaultManager];
                    if([fm fileExistsAtPath:downloadPathOld]){
                        
                        NSString *downloadPathNew = [NSString stringWithFormat:@"%@%@", [MagicCommentMethod downloadPath], downFileNameNew];
                        NSData *data = [fm contentsAtPath:downloadPathOld];
                        [data writeToFile:downloadPathNew atomically:YES];
                        
                        [fm removeItemAtPath:downloadPathOld error:nil];
                    }
          
                }
                self.DB.FROM(KDATABANKDOWNLIST)
                .SET(@"url",[dict objectForKey:@"file_urlencode"] )
                .SET(@"filename", downFileNameNew)
                .SET(@"type", strTypeList)
                .SET(@"strType", [dict objectForKey:@"type"])
                .SET(@"show", @"1")
                .SET(@"userid", SHARED.userId)
                .SET(@"filelength", @"0")
                .SET(@"stopDowning", @"0")
                .SET(@"downprogress", @"0")
                .INSERT();
                
                
                NSString *count = [dict objectForKey:@"count"];
                NSString *isSysFolder = [dict objectForKey:@"is_sys_folder"];
                NSString *isDir = [dict objectForKey:@"is_dir"];
                
                self.DB.FROM(kDATABANKDOWNDETAIL)
                .SET(@"author", [dict objectForKey:@"author"])
                .SET(@"count", count)
                .SET(@"create_time", [dict objectForKey:@"create_time"])
                .SET(@"dir", [dict objectForKey:@"dir"])
                .SET(@"file_path", [dict objectForKey:@"file_path"])
                .SET(@"file_url", [dict objectForKey:@"file_url"])
                .SET(@"file_urlencode", [dict objectForKey:@"file_urlencode"])
                .SET(@"icon", [dict objectForKey:@"icon"])
                .SET(@"id", [dict objectForKey:@"id"])
                .SET(@"is_dir", isDir)
                .SET(@"is_sys_folder", isSysFolder)
                .SET(@"size", [dict objectForKey:@"size"])
                .SET(@"title", [dict objectForKey:@"title"])
                .SET(@"type", [dict objectForKey:@"type"])
                .SET(@"userid", SHARED.userId)
                .INSERT();

            }
            
            
           
            DYBDataBankListController *list = [DYBDataBankListController creatShareInstance];
            
            [self sendViewSignal:[DYBDataBankChildrenListViewController REFRESH] withObject:nil from:self target:list];
            
            DYBUITabbarViewController *tb = [DYBUITabbarViewController sharedInstace];
            DLogInfo(@"self.drNavigationController.childViewControllers -- %@",self.drNavigationController.childViewControllers);
            
            if ([_popController isKindOfClass:[DYBDataBankListController class]] || _popController == nil) {

                [self.drNavigationController popToViewController:tb animated:YES];
            }else{
            
                [self.drNavigationController popToViewController:_popController animated:YES];
            }            
        }
            NSString *name = [response.data objectForKey:@"msg"];
            [DYBShareinstaceDelegate popViewText:name target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        
    }else if (request.tag == 13){ // yidong zhuancun
        
        if ([[response.data objectForKey:@"result"] boolValue])
        {
            DYBDataBankListController *list = [DYBDataBankListController creatShareInstance];
            
            [self sendViewSignal:[DYBDataBankChildrenListViewController REFRESH] withObject:nil from:self target:list];
            
            DYBUITabbarViewController *tb = [DYBUITabbarViewController sharedInstace];
            [self.drNavigationController popToViewController:tb animated:YES];
        }
        NSString *name = [response.data objectForKey:@"msg"];
        [DYBShareinstaceDelegate popViewText:name target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
    }
}

- (NSString *)downFileName:(NSString *)url
{
    NSArray *typeArr = [url componentsSeparatedByString:@"."];
    NSString *type = [typeArr lastObject];
    
    NSString *downFileName = [NSString stringWithFormat:@"%@.%@", [MagicCommentMethod md5:url], type];
    
    return downFileName;
}


-(void)addNOresultImageView:(NSString *)strMsg{
    
    
    UIView *view = [self.view viewWithTag:NORESULTVIEW];
    if (!view) {
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0.0f,  SEARCHBAT_HIGH, 300.0f, 400.0f)];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setTag:NORESULTVIEW];
        [tbDataBank insertSubview:view atIndex:0];
        RELEASE(view);
        
        UIImage *image = [UIImage imageNamed:@"ybx_big.png"];
        float BearHeadStartX = (CGRectGetWidth(self.view.frame)-image.size.width/2)/2;
        float BearHeadStartY = (self.frameHeight-self.headHeight-image.size.height/2 - 70)/2 - 150;
        MagicUIImageView *viewBearHead = [[MagicUIImageView alloc] initWithFrame:CGRectMake(BearHeadStartX, BearHeadStartY, image.size.width/2, image.size.height/2)];
        [viewBearHead setBackgroundColor:[UIColor clearColor]];
        [viewBearHead setImage:image];
        [view addSubview:viewBearHead];
        RELEASE(viewBearHead);
        
        MagicUILabel *labelMsg = [[MagicUILabel alloc]initWithFrame:CGRectMake((320 - 250)/2, viewBearHead.frame.size.height + viewBearHead.frame.origin.y + 15, 250.0f, 40.0f)];
        [labelMsg setText:strMsg];
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



#pragma SearchView Delegate

-(void)changeSearchBarFrame{
    
    [self hideRightView];
    [searchView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, self.view.frame.size.height)];
    [searchView setBackgroundColor:[UIColor clearColor]];
    [searchView.tbDataBank setFrame:CGRectMake(0.0f, SEARCHBAT_HIGH , 320.0f, searchView.frame.size.height - SEARCHBAT_HIGH - 44 )];
}

-(void)recoverSearchBar{
    
    [searchView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH)];
    [searchView setBackgroundColor:[UIColor clearColor]];
    [searchView.tbDataBank setHidden:YES];
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
        
    }else if ([signal is:[DYBDtaBankSearchView BEGINEDITING]]){
        
        [self hideRightView];
        
    }
    else if ([signal is:[DYBDtaBankSearchView DELOBJ]]){
        
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


-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    DLogInfo(@"ddddd");
    if ([signal is:[DYBDataBankShotView LEFT]]) {
        
    }
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *text = [dict objectForKey:@"text"];
        NSString *type = [dict objectForKey:@"type"];
        NSNumber *row = [dict objectForKey:@"rowNum"];
        NSDictionary *dictResult = nil;
        if (arrayFolderList.count > 0 && arrayFolderList.count >= [row integerValue]) {
           dictResult = [arrayFolderList objectAtIndex:[row integerValue]];
        }
        NSString *fileURL = [dictResult objectForKey:@"file_path"];
        switch ([type integerValue]) {
            case BTNTAG_DEL:{
                
                MagicRequest *request = [DYBHttpMethod document_deldoc_doc:fileURL indexDataBack:[NSString stringWithFormat:@"%@",row] isAlert:YES receive:self];
                
                [request setTag:BTNTAG_DEL];
                
            }
                break;
                
            case BTNTAG_ADDFOLDER:
            {
                
                if (text.length == 0) {
                    
                    [DYBShareinstaceDelegate popViewText:@"文件名不能为空！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    return;
                }
                
                BOOL bOK = [DYBShareinstaceDelegate isOKName:text];
                
                int lenght = text.length;
                if (!bOK|| lenght > 255) {
                    
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"输入的名称不符合要求" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",0]];
                    
                    return;
                }
                
                MagicRequest *request = [DYBHttpMethod document_createdir_name:text dir:folderID isAlert:YES receive:self  ];
                
                [request setTag:BTNTAG_ADDFOLDER];            
            }
                break;
                
            case BTNTAG_RENAME:
            {
                                
                NSString *doc_id = [dictResult objectForKey:@"id"];
                NSString *dir = [dictResult objectForKey:@"dir"];
                
                BOOL bOK = [DYBShareinstaceDelegate isOKName:text];
                NSString *type = [dictResult objectForKey:@"type"];
                
                if (type.length > 0 && type) {
                    text= [NSString stringWithFormat:@"%@.%@",text,type];
                }

                
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

-(void)handleViewSignal_DYBDataBankSelectBtn:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankSelectBtn TOUCHSIGLEBTN]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UIButton *btn = (UIButton *)[dict objectForKey:@"btn"];
        NSLog(@"tag -- %d",btn.tag);
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
                childr.popController = self;
                childr.strFromDir = [NSString stringWithFormat:@"%@",[[arrayFolderList objectAtIndex:row] objectForKey:@"id"]];
                childr.bChangeFolder = YES; //移动，非转存
                childr.bChangeSave = NO;
                childr.dictInfo = [arrayFolderList objectAtIndex:row];
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
            case BTNTAG_SINGLE:{
                NSString *title = [[arrayFolderList objectAtIndex:row] objectForKey:@"title"];
                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:title targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",row]];
            }
                break;
            case BTNTAG_DEL:
            {
                
                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要删除吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",row]];
            }
                break;
            case BTNTAG_DOWNLOAD:{
                
                NSDictionary *dict = [arrayFolderList objectAtIndex:row];
                
                if ([MagicDevice hasInternetConnection] == NO/*无网络*/ || (SHARED.currentUserSetting.wifiForPush && ![[MagicDevice networkType] isEqualToString:@"wifi"]/*开了wifi下才能下载但不是wifi环境*/)) {//
                    
                    [self addOrHideDownIcan:[dict objectForKey:@"file_urlencode"] add:NO];
                    
                }else{
                    [self addOrHideDownIcan:[dict objectForKey:@"file_urlencode"] add:YES];
                }
                
                DYBDataBankDownloadManageViewController *downLoad = [DYBDataBankDownloadManageViewController shareDownLoadInstance];
                
                [downLoad insertCell:dict];
                
            }
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
-(void)handleViewSignal_DYBDataBankListCell:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankListCell FINISHSWIP]]) {
        [self hideRightView];
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


- (void)dealloc
{
//    [_current_dir release];
    RELEASE(_popController);
    _popController = nil;
    RELEASE(_strChangeType);
    RELEASE(_strFromDir);
    RELEASE(_strTitle);
    RELEASEOBJ(_current_dir)
    RELEASEDICTARRAYOBJ(arrayFolderList);
    RELEASEDICTARRAYOBJ(arrayCellView);
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
