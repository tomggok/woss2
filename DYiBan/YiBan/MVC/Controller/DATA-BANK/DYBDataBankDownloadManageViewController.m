//
//  DYBDataBankDownloadManageViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankDownloadManageViewController.h"
#import "DYBHttpMethod.h"
//#import "DYBDataBankListCell.h"
#import "DYBSideSwipeTableViewCell.h"
#import "DYBDataBankSearchViewController.h"
#import "databanklist.h"
#import "DYBDataBankListController.h"
#import "DYBDataBankChildrenListViewController.h"
#import "DYBDataBankShotView.h"
#import <Accelerate/Accelerate.h>
#import "DYBMenuView.h"
#import "UITableView+property.h"
#import "NSObject+MagicRequestResponder.h"
#import "DYBDataBankSelectBtn.h"
#import "NSObject+MagicDatabase.h"
#import "DYBDataBankListCell.h"
#import "DYBDataBankFileDetailViewController.h"
#import "Magic_Sandbox.h"
#import "UserSettingMode.h"
#import "Magic_Device.h"
#import "NSString+Count.h"

#define NORESULTVIEW 1000


@interface DYBDataBankDownloadManageViewController (){
    
    MagicUITableView *tbDowningDataBank;
    MagicUITableView *tbFinishDataBank;
    
    NSMutableArray *arrayFolderList;
    NSMutableArray *arrayCellView;
    
    NSMutableArray *arrayFolderFinishList;
    NSMutableArray *arrayFinishCellView;
    
    DYBMenuView *_tabMenu;

    NSMutableDictionary *dictDictCellURL;
    BOOL bPullDown;
    
    
//    NSMutableDictionary *dictStartDowningSource; //正在下载的文件
    
//    NSMutableDictionary *downLoadedDict;//已经下载文件的大小
    
    int iState ; // 0,传送页面 1.已经离线页面
}

@end

@implementation DYBDataBankDownloadManageViewController
@synthesize dictCellDown = _dictCellDown,cellDown = _cellDown;

DEF_SIGNAL(SHOWCHOOSE)
DEF_SIGNAL(SWITCHDYBAMICBUTTON)
DEF_SIGNAL(MENUSELECT)

@synthesize tabbarView = _tabbarView,sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

static DYBDataBankDownloadManageViewController *shareInstance = nil;

+(DYBDataBankDownloadManageViewController *)shareDownLoadInstance{

    if (!shareInstance) {
        
        shareInstance = [[DYBDataBankDownloadManageViewController alloc]init];

    }
    return shareInstance;
}

-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {

        if (tbDowningDataBank.hidden) {
            [self.headview setTitle:@"离线浏览"];
        }else{
        
        [self.headview setTitle:@"传送中"];
        
        }
        
        iState = 0;
        
        [self setButtonImage:self.rightButton setImage:@"btn_delall_def" setHighString:@"btn_delall_perss"];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        MagicUIButton *_btnSwichDybamic = [[MagicUIButton alloc] initWithFrame:CGRectMake(110, 0, 100, 44)];
        [_btnSwichDybamic addSignal:[DYBDataBankDownloadManageViewController SWITCHDYBAMICBUTTON] forControlEvents:UIControlEventTouchUpInside];
        [self.headview addSubview:_btnSwichDybamic];
        
        [_btnSwichDybamic setBackgroundColor:[UIColor clearColor]];
        [self.headview bringSubviewToFront:_btnSwichDybamic];
        RELEASE(_btnSwichDybamic);
        [tbDowningDataBank reloadData];
        
        
        [self.headview setTitleArrow];
        
    }
    if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        //初始化
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goOnDown) name:@"backApp" object:nil];
        
        dictDictCellURL = [[NSMutableDictionary alloc]init];
//        downLoadedDict = [[NSMutableDictionary alloc] initWithCapacity:3];
        
        arrayCellView = [[NSMutableArray alloc]init];
        
        arrayFolderList = [[NSMutableArray alloc]init];
        
        arrayFolderFinishList = [[NSMutableArray alloc]init];
        
        arrayFinishCellView = [[NSMutableArray alloc]init];
        
//        dictStartDowningSource = [[NSMutableDictionary alloc]init];
        
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        tbDowningDataBank = [[MagicUITableView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44.0f -20)isNeedUpdate:YES];
        [tbDowningDataBank.headerView setHidden:YES];
        [tbDowningDataBank setTableViewType:DTableViewSlime];
        [self.view addSubview:tbDowningDataBank];
        [tbDowningDataBank setTag:1];
        [tbDowningDataBank setBackgroundColor:[UIColor clearColor]];
        [tbDowningDataBank setSeparatorColor:[UIColor clearColor]];
        [tbDowningDataBank release];   
        
//        
        tbFinishDataBank = [[MagicUITableView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44.0f -20)isNeedUpdate:YES];
        [tbFinishDataBank.headerView setHidden:YES];
        [tbFinishDataBank setHidden:YES];
        [tbFinishDataBank setTag:2];
        [tbFinishDataBank setTableViewType:DTableViewSlime];
        [self.view addSubview:tbFinishDataBank];
        [tbFinishDataBank setBackgroundColor:[UIColor whiteColor]];
        [tbFinishDataBank setSeparatorColor:[UIColor clearColor]];
        [tbFinishDataBank release];
        
        
        self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET();
        [self initCellListView:self.DB.resultArray cellType:5 btType:5 choseType:0 opeartionTableView:tbDowningDataBank arrayList:arrayFolderList arrayCellView:arrayCellView];
        
        bPullDown = NO;
    
        if (arrayFolderList.count == 0) {
            
            [self addNOresultImageView:@"在这里管理资料的上传下载，随时暂停取消" addView:tbDowningDataBank];
        }else{
        
            UIView *view = [self.view viewWithTag:NORESULTVIEW + tbDowningDataBank.tag];
            if (view) {
                [view removeFromSuperview];
            }
        
        }
        
        
    if ([signal is:[MagicViewController LAYOUT_VIEWS]]) {

        [self.view setBackgroundColor:[UIColor whiteColor]];
//         [self.headview setTitle:@"传送中"];
        
      }
    }
}

-(void)goOnDown{

    self.DB.FROM(KDATABANKDOWNLIST)
        .WHERE(@"type", @"1")
        .WHERE(@"userid", SHARED.userId)
        .WHERE(@"stopDowning",@"0").GET();
    
    for (NSDictionary *dict in self.DB.resultArray) {
        
        NSString *url = [dict objectForKey:@"url"];
        
        if (url.length > 0) {
            
             self.HTTP_GET_DOWN(url);
        }      
    }
}

//初始化celllistview
- (void)initCellListView:(NSArray *)resultArray cellType:(NSInteger)cellType btType:(NSInteger)btType choseType:(int)choseType opeartionTableView:(UITableView *)tableView arrayList:(NSMutableArray *)arrLost arrayCellView:(NSMutableArray *)arrayView
{
    [arrLost removeAllObjects];
    [arrayView removeAllObjects];
    
 
    NSArray *resultSql = [resultArray copy];
    for (int i = 0; i < [resultSql count]; i++)
    {
        NSDictionary *dictSql = [resultSql objectAtIndex:i];
        NSString *url = [dictSql objectForKey:@"url"];
        NSString *name = [dictSql objectForKey:@"filename"];

        CGFloat progress = 0.0f;
        if ([[dictSql objectForKey:@"downprogress"] isKindOfClass:[NSNull class] ]){
           
            DLogInfo(@"downprogress  ---- >  null");

        }else{
        
         progress = [[dictSql objectForKey:@"downprogress"] floatValue];
        }
        
        
        self.DB.FROM(kDATABANKDOWNDETAIL).WHERE(@"file_urlencode", url).WHERE(@"userid", SHARED.userId).GET(); //详细信息
        
        
        if (self.DB.resultArray.count == 0) {
            
            NSLog(@"self.DB.resultArray.count == 0");
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", url).WHERE(@"userid", SHARED.userId).DELETE();
            return;
        }
        
        NSDictionary *dict = [[self.DB.resultArray objectAtIndex:0] copy];
        [self initCellView:dict url:url cellType:cellType btType:btType bOrP:[[dictSql objectForKey:@"stopDowning"] boolValue] opeartionTableView:tableView arrayList:arrLost arrayCellView:arrayView];
        
        if (btType == 5) {
            
            [self setCellDownProgress:name progress:progress chose:choseType];
        }
        
        
        
        RELEASEOBJ(dict);
        
    }
    
    [tableView reloadData];
    
    tableView._muA_differHeightCellView = [[NSMutableArray alloc]initWithArray:arrayView];
    
    RELEASEOBJ(resultSql);

}

-(void)addOrHideDownIcan:(NSString *)key add:(BOOL)bAdd{

    DYBDataBankListController *list = [DYBDataBankListController creatShareInstance];
    for (DYBDataBankListCell *cell in list.arrayCellView) {
        if ([cell.strTag isEqualToString:key]) {
            [cell.imageViewDown setHidden:!bAdd];
        }
    }
    
    DYBDataBankSearchViewController *searchInstance = [DYBDataBankSearchViewController creatShare];
    for (DYBDataBankListCell *cell in searchInstance.arrayCellView) {
        if ([cell.strTag isEqualToString:key]) {
            [cell.imageViewDown setHidden:!bAdd];
        }
    }
}

- (void)handleViewSignal_MagicUIImageView_WEBDOWNSUCCESS:(MagicViewSignal *)signal
{

    MagicUIImageView *tttt = (MagicUIImageView *)[signal source];

    NSString *downloadName  = tttt.strTag;
    
//     DYBDataBankListCell *cell = (DYBDataBankListCell *)[dictDictCellURL objectForKey:downloadName];
//        
//        
//        [cell.progressView setProgress:1];
//        //        [cell.progressView setInnerColor:[MagicCommentMethod colorWithHex:@"aaaaaa"]];
//        
//        [cell.labelProgress setText:@"100%100"];
//        
//        self.DB.FROM(KDATABANKDOWNLIST)
//        .SET(@"type", @"2").SET(@"downprogress", @"1")
//        .WHERE(@"filename", downloadName).WHERE(@"userid", SHARED.userId).UPDATE();
//        
//        
//        
//        self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET(); //正在下载
//        
//        NSInteger current = self.DB.resultArray.count;
//        [[DYBUITabbarViewController sharedInstace] addAndRefreshTotalMsgView:current];
//        [[DYBUITabbarViewController sharedInstace] changeMsgTotalFrame];
//    
//        //重新load 下载tabelview
//        self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET(); //正在下载
//        [self initCellListView:self.DB.resultArray cellType:5 btType:5 choseType:0 opeartionTableView:tbDowningDataBank arrayList:arrayFolderList arrayCellView:arrayCellView];
//        
//        [tbDowningDataBank reloadData];
    
        
//    if (self.DB.resultArray.count == 0) {
//        
//        [self addNOresultImageView:@"在这里管理资料的上传下载，随时暂停取消" addView :tbDowningDataBank];
//    }else{
//        
//        UIView *view = [self.view viewWithTag:NORESULTVIEW +tbDowningDataBank.tag];
//        if (view) {
//            [view removeFromSuperview];
//        }
//    }
}
-(void)insertCell:(NSDictionary *)dict{
    
//    [dict copy]; //防止
    NSString *url = [dict objectForKey:@"file_urlencode"];
  
//    self.strDownloadURL = [self.dictInsetInfo objectForKey:@"file_urlencode"];
    //如果是图片，就转到另外的下载文件夹下
    
    self.DB.FROM(kDATABANKDOWNDETAIL).WHERE(@"file_urlencode", url).WHERE(@"userid", SHARED.userId).GET();
    if ([self.DB.resultArray count] > 0)
    {
    
        self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", url).WHERE(@"userid", SHARED.userId).GET();
        
        if ([self.DB.resultArray count] > 0)
        {
           
            NSDictionary *sqlDict = [self.DB.resultArray objectAtIndex:0];
            NSString *type = [sqlDict objectForKey:@"type"];//下载状态1，下载中2，下载完成，3离线中，4离线完成
            
            NSString *state = @"";
            if ([type isEqualToString:@"1"])
            {
                state = @"下载中";
                [DYBShareinstaceDelegate loadFinishAlertView:state target:self];
                return;
            }else if ([type isEqualToString:@"2"])
            {
                state = @"已下载";
                [DYBShareinstaceDelegate loadFinishAlertView:state target:self];
                return;
            }else if ([type isEqualToString:@"3"] || [type isEqualToString:@"4"])
            {
                //删除离线并下载
                self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", url).WHERE(@"userid", SHARED.userId).DELETE();
                NSString *downName = [self downPathFileNameWithUrl:url];
                BOOL isFinish = [MagicSandbox deleteFile:downName];
                if (!isFinish)
                {
                    [MagicSandbox deleteFile:[NSString stringWithFormat:@"%@.download", downName]];
                }
            }
            
            
        }else{
            
            if (SHARED.currentUserSetting.wifiForPush && ![[MagicDevice networkType] isEqualToString:@"wifi"] && [[MagicDevice networkType] isEqualToString:@"2g"]) {
                [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"您当前为2G/3G网络，需要消耗流量，是否继续操作？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_GOONDOWNLOAD dic:[NSMutableDictionary dictionaryWithDictionary:dict] ];
                return;
                
            }else if ([MagicDevice hasInternetConnection] == NO) {
                MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                [pop setDelegate:self];
                [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                [pop setText:@"检测不到网络连接！"];
                [pop alertViewAutoHidden:.5f isRelease:YES];
                
                [self postNotification:[DYBBaseViewController NoInternetConnection] withObject:nil];
                return ;
            }
            
            NSString *state = @"开始下载";
            [DYBShareinstaceDelegate loadFinishAlertView:state target:self];
        }

    }else{
        
        if (SHARED.currentUserSetting.wifiForPush &&![[MagicDevice networkType] isEqualToString:@"wifi"] && [[MagicDevice networkType] isEqualToString:@"2g"]) {
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"您当前为2G/3G网络，需要消耗流量，是否继续操作？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_GOONDOWNLOAD dic:[NSMutableDictionary dictionaryWithDictionary:dict] ];
            return;
            
        }else if ([MagicDevice hasInternetConnection] == NO) {
            MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
            [pop setDelegate:self];
            [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
            [pop setText:@"检测不到网络连接！"];
            [pop alertViewAutoHidden:.5f isRelease:YES];
            
            [self postNotification:[DYBBaseViewController NoInternetConnection] withObject:nil];
            return ;
        }
        
        NSString *state = @"开始下载";
        [DYBShareinstaceDelegate loadFinishAlertView:state target:self];
    }

    
    iState = 0; //正在下载的tableView
        
    NSLog(@"url -- %@",url);
    if (url != nil) { //开始下载
        
         [self addOrHideDownIcan:url add:YES];
        
        if (_cellDown) {
            [_cellDown.imageViewDown setHidden:NO];
        }
        
        MagicRequest *request = self.HTTP_GET_DOWN(url);
        
       
        
        NSString *downFileName = [request downloadName];
        
        
                
        self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", url).WHERE(@"userid", SHARED.userId).GET();
       
        if ([self.DB.resultArray count] == 0) {
            
            self.DB.FROM(KDATABANKDOWNLIST)
            .SET(@"url",url )
            .SET(@"filename", downFileName)
            .SET(@"type", @"1")
            .SET(@"strType", [dict objectForKey:@"type"])
            .SET(@"show", @"1")
            .SET(@"deCodeUerl",[dict objectForKey:@"file_url"])
            .SET(@"userid", SHARED.userId)
            .SET(@"filelength", @"0")
            .SET(@"stopDowning", @"0")
            .SET(@"downprogress", @"0")
            .INSERT();
        }
        
        
        
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
        .SET(@"file_urlencode", url)
        .SET(@"icon", [dict objectForKey:@"icon"])
        .SET(@"id", [dict objectForKey:@"id"])
        .SET(@"is_dir", isDir)
        .SET(@"is_sys_folder", isSysFolder)
        .SET(@"size", [dict objectForKey:@"size"])
        .SET(@"title", [dict objectForKey:@"title"])
        .SET(@"type", [dict objectForKey:@"type"])
        .SET(@"userid", SHARED.userId)
        .INSERT();
        
        self.DB.FROM(kDATABANKOFFLINELISTTABLE)
        .SET(@"file_urlencode",url)
        .SET(@"userid",SHARED.userId)
        .INSERT();
        
         [self setDownNum];
        
        self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET(); //正在下载
        [self initCellListView:self.DB.resultArray cellType:5 btType:5 choseType:0 opeartionTableView:tbDowningDataBank arrayList:arrayFolderList arrayCellView:arrayCellView];
        
        [tbDowningDataBank reloadData];
        
        if (arrayFolderList.count == 0) {
            
            [self addNOresultImageView:@"在这里管理资料的上传下载，随时暂停取消" addView :tbDowningDataBank];
        }else{
            
            UIView *view = [self.view viewWithTag:NORESULTVIEW + tbDowningDataBank.tag];
            if (view) {
                [view removeFromSuperview];
            }
        }
        
        
        NSString *strType = [[dict objectForKey:@"type"] lowercaseString];
        if ([strType isEqualToString:@"jpg"]||[strType isEqualToString:@"png"]||[strType isEqualToString:@"bmp"]) {

            
            NSString *file_url = [dict objectForKey:@"file_url"];
            MagicUIImageView *image = [[MagicUIImageView alloc]init];
            image.strTag = downFileName;
            [self.view addSubview:image];
            [image setImgWithUrl:file_url defaultImg:nil];
           
            [image release];
        }
    }
}

//创建一个cell
- (void)initCellView:(NSDictionary *)dict url:(NSString *)url cellType:(NSInteger)cellType btType:(NSInteger)btType bOrP:(BOOL)bOrP opeartionTableView:(UITableView *)tableView arrayList:(NSMutableArray *)arrLost arrayCellView:(NSMutableArray *)arrayView
{

    [tableView release_muA_differHeightCellView];
    int i = arrayView.count;
    [arrLost addObject:dict];
    
   DYBDataBankListCell *cell = [[DYBDataBankListCell alloc] initWithFrame:CGRectZero object:nil];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
    [cell setIndexPath:indexPath];
    [cell setTb:tableView];
    [cell setBeginOrPause:bOrP];
    [cell setCellType:cellType];
    [cell setBtnType:btType];
    [cell initViewCell_dict:dict];
    
    [arrayView addObject:cell];
    RELEASE(cell);
    
    NSString *strType = [[url componentsSeparatedByString:@"."] lastObject];
    
    NSString *md5 = [MagicCommentMethod md5:url];
    
    [dictDictCellURL setValue:cell forKey:[md5 stringByAppendingFormat:@".%@",strType]];
//    tableView._muA_differHeightCellView = [[NSMutableArray alloc]initWithArray:arrayView];
}

//设置cellview上的进度
- (void)setCellDownProgress:(NSString *)downloadName progress:(CGFloat)newProgress chose:(int)choseType
{
    DYBDataBankListCell *cell = (DYBDataBankListCell *)[dictDictCellURL objectForKey:downloadName];
    [cell.progressView setProgress:newProgress];
    [cell.labelProgress setText:[NSString stringWithFormat:@"%.1f/100",newProgress*100]];
    DLogInfo(@"newProgress -- %f",newProgress);
    
    
       
    if (newProgress == 1.0f) {
        
        self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"filename", downloadName).WHERE(@"userid", SHARED.userId).GET();
        
            if (self.DB.resultArray.count != 0) {
                
                NSDictionary *dict = [self.DB.resultArray objectAtIndex:0];
                NSString *type = [[dict objectForKey:@"strType"] lowercaseString];
                if ([type isEqualToString:@"jpg"]||[type isEqualToString:@"bmp"]||[type isEqualToString:@"png"]) {
                    
    //                return;
                }
            }
        
            [cell.progressView setProgress:1];        
            [cell.labelProgress setText:@"100%"];
            
            self.DB.FROM(KDATABANKDOWNLIST)
            .SET(@"type", @"2").SET(@"downprogress", @"1")
            .WHERE(@"filename", downloadName).WHERE(@"userid", SHARED.userId).UPDATE();
            
            
            
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET(); //正在下载
            
            NSInteger current = self.DB.resultArray.count;
            NSString *strKey = [NSString stringWithFormat:@"downingNUM_%@",SHARED.userId];
            [[NSUserDefaults standardUserDefaults] setInteger:current forKey:strKey];
            [[DYBUITabbarViewController sharedInstace] addAndRefreshTotalMsgView:current];
            [[DYBUITabbarViewController sharedInstace] changeMsgTotalFrame];
            
            
            if (choseType == 4) {
                
                [arrayCellView removeObject:cell];
                
            }
            
            //重新load 下载tabelview
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET(); //正在下载
            [self initCellListView:self.DB.resultArray cellType:5 btType:5 choseType:0 opeartionTableView:tbDowningDataBank arrayList:arrayFolderList arrayCellView:arrayCellView];
            
            [tbDowningDataBank reloadData];
            
            if (arrayFolderList.count == 0) {
                
            [self addNOresultImageView:@"在这里管理资料的上传下载，随时暂停取消" addView :tbDowningDataBank];
                
        }else{
            
            UIView *view = [self.view viewWithTag:NORESULTVIEW +tbDowningDataBank.tag];
            if (view) {
                [view removeFromSuperview];
            }
            
        }
        
    }
}

-(void)setDownNum{
    
    self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET(); //正在下载
    NSInteger current = self.DB.resultArray.count;
    
    NSString *strKey = [NSString stringWithFormat:@"downingNUM_%@",SHARED.userId];
    [[NSUserDefaults standardUserDefaults] setInteger:current forKey:strKey];
    DLogInfo(@"downging --- %d",current);
    [[DYBUITabbarViewController sharedInstace] addAndRefreshTotalMsgView:current];
    [[DYBUITabbarViewController sharedInstace] changeMsgTotalFrame];
    
}

- (NSString *)getStringTitle:(int)type{
    
        
    switch (type) {
        case 0:{
            
            iState = 0;
            
            [tbDowningDataBank setHidden:NO];
            [tbFinishDataBank setHidden:YES];
            
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET();
            [self initCellListView:self.DB.resultArray cellType:5 btType:5 choseType:0 opeartionTableView:tbDowningDataBank arrayList:arrayFolderList arrayCellView:arrayCellView];
            
            if (arrayFolderList.count == 0) {
                
                [self addNOresultImageView:@"在这里管理资料的上传下载，随时暂停取消" addView :tbDowningDataBank];
            }else{
                
                UIView *view = [self.view viewWithTag:NORESULTVIEW + tbDowningDataBank.tag];
                if (view) {
                    [view removeFromSuperview];
                }
                
            }
            return @"传送中";
        }
            break;
        case 1:{
            
            iState = 1;
            
            [tbDowningDataBank setHidden:YES];
            [tbFinishDataBank setHidden:NO];
            
//            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"2").WHERE(@"userid", SHARED.userId).GET();
            
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"2").WHERE(@"userid", SHARED.userId).GET();
            [self initCellListView:self.DB.resultArray cellType:0 btType:4 choseType:1 opeartionTableView:tbFinishDataBank arrayList:arrayFolderFinishList arrayCellView:arrayFinishCellView];
            
            if (arrayFolderFinishList.count == 0) {
                
                [self addNOresultImageView:@"离线成功的资料放在这里，没网络也可以查看"addView :tbFinishDataBank];
            }else{
                
                UIView *view = [self.view viewWithTag:NORESULTVIEW +tbFinishDataBank.tag];
                if (view) {
                    [view removeFromSuperview];
                }
                
            }
            return @"离线浏览";
        }
            break;
            
        default:
            break;
    }
    return @"共享给我";
}


-(void)handleViewSignal_DYBMenuView:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBMenuView MENUSELECTCELL]]) {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *section = [dict objectForKey:@"section"];
        NSString *strType = [self getStringTitle:[section integerValue]];
        
        
        
        [self.headview setTitle:strType];
        
        [self.headview setTitleArrow];
        
        [self initDYBMenuView];
        
    }
    
    
}

-(void)initDYBMenuView{
    
    if (!_tabMenu) {
        
        
        NSArray *_arrTitleLable =[[NSArray alloc]initWithObjects:@"传送中",@"离线浏览", nil];
        _tabMenu = [[DYBMenuView alloc]initWithData:_arrTitleLable selectRow:0];
//        _tabMenu.sendTargetObj =self;
        [self.view addSubview:_tabMenu];
        [_tabMenu setHidden:YES];
        RELEASE(_tabMenu);
        RELEASE(_arrTitleLable)
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

- (void)handleViewSignal_DYBDataBankDownloadManageViewController:(MagicViewSignal *)signal{

    if ([signal is:[DYBDataBankDownloadManageViewController SWITCHDYBAMICBUTTON]]) {
        
        
         [self initDYBMenuView];
        
    }else if ([signal is:[DYBDataBankDownloadManageViewController MENUSELECT]]){
//        NSDictionary *dict = (NSDictionary *)[signal object];
//        NSNumber *nSection = [dict objectForKey:@"section"];
    
//        NSLog(@"%d", [nSection intValue]);
    }if ([signal is:[MagicUIImageView WEBDOWNSUCCESS]]) {
        
        
        NSLog(@"ffff");
    }

}
#pragma mark- 
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
//        [self.navigationController popViewControllerAnimated:YES];
        DYBUITabbarViewController *dync = [DYBUITabbarViewController sharedInstace];
        [dync scrollMainView:1];
    }
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        
        if (_tabMenu && _tabMenu.row == 1)
        {//离线浏览
            DYBDataBankShotView *deleteBt = [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要全部删除吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",0]];
            [deleteBt setTag:3];
        }else
        {//传送中
            DYBDataBankShotView *deleteBt = [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要全部删除吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",0]];
            [deleteBt setTag:4];
        }
        DLogInfo(@"_tabMenu === %@", _tabMenu);
        DLogInfo(@"不能为空");
//        [self creatRightDownView];
        
    }
}





#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request
{
    
    NSString *strURL = request.downloadName;

    
    if (request.succeed)
    {
        [self setCellDownProgress:request.downloadName progress:1.0f chose:4];

    }else if (request.failed)
    {
    
    }else if (request.recving)
    {
        self.DB.FROM(KDATABANKDOWNLIST)
            .SET(@"filelength", [NSString stringWithFormat:@"%d", request.downloadTotalBytes])
            .WHERE(@"filename", strURL).WHERE(@"userid", SHARED.userId)
            .UPDATE();
    }
    
}

//下载进度回调
bool istest;
CGFloat test = 0;
- (void)downloadProgress:(CGFloat)newProgress request:(MagicRequest *)request
{

    DLogInfo(@"request -- %@",request.downloadName);
    if (newProgress  == 1.0f) {
     
    

        
        [self setCellDownProgress:request.downloadName progress:newProgress chose:4];
        
//下载中，转到下载完成列表
        self.DB.FROM(KDATABANKDOWNLIST)
        .SET(@"downprogress", [NSString stringWithFormat:@"%.1f", 1.0f])
        .SET(@"show",@"2")
        .WHERE(@"url", request.downloadName).WHERE(@"userid", SHARED.userId)
        .UPDATE();


        
    }else{
        
        [self setCellDownProgress:request.downloadName progress:newProgress chose:0];
    
    }
    
    
}


-(void)setCellBtnStats:(UIView *)cell strEncodeUrl:(NSString *)strEncode{


}

#pragma mark- 只接受tbv信号
//static NSString *reuseIdentifier = @"reuseIdentifier";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        
        NSDictionary  *dict = (NSDictionary *)[signal object];
        
        UITableView *table = (UITableView *)[dict objectForKey:@"tableView"];
        
        NSNumber *s = nil;
        
        switch (table.tag) {
            case 1:{
                
                s = [NSNumber numberWithInteger:arrayCellView.count];
                    }
                break;
            case 2:
                    {
                s = [NSNumber numberWithInteger:arrayFinishCellView.count];
                    
                    }
                break;

        }
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
        
        
        DYBDataBankListCell *cell  = nil;
                
        UITableView *table = (UITableView *)[dict objectForKey:@"tableView"];
        
        
        switch (table.tag)
        
         {
            case 1:{
                
                cell = [arrayCellView objectAtIndex:indexPath.row];;
                [self resetBtRow:arrayCellView];
                
            }
                break;
            case 2:
            {
                cell = [arrayFinishCellView objectAtIndex:indexPath.row];;
                [self resetBtRow:arrayFinishCellView];
            }
                break;
        }        
        
        if (indexPath.row%2 == 0) {
            [cell setSwipViewBackColor:[UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1.0f]];
        }else{
            [cell setSwipViewBackColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
            
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];        
        UITableView *table = (UITableView *)[dict objectForKey:@"tableView"];
        NSDictionary *dictResult = nil;
        
        switch (table.tag){
            case 1:{
                return; //正在下载不可以查看
                dictResult = [arrayFolderList objectAtIndex:indexPath.row];
            }
                break;
            case 2:
            {
                dictResult = [arrayFolderFinishList objectAtIndex:indexPath.row];
                
            }
                break;
        }
        
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
        RELEASE(childerListController);           
    
    
    }else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])
    {
//        [tbDowningDataBank tableViewDidDragging];
    }
    else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])
    {
//        NSLog(@"1111");
//        [tbDowningDataBank reloadData:NO];
//        [tbFinishDataBank reloadData:NO];
        
    }else if ([signal is:[MagicUITableView TABELVIEWBEGAINSCROLL]]){
    
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){
        
        [DYBShareinstaceDelegate opeartionTabBarShow:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){
        
        [DYBShareinstaceDelegate opeartionTabBarShow:NO];
    } else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])
    {
       
        UITableView *tableView = (UITableView *)[signal source];
        
        switch (tableView.tag) {
            case 1:
            {
            
                self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET(); //正在下载
                [self initCellListView:self.DB.resultArray cellType:5 btType:5 choseType:0 opeartionTableView:tbDowningDataBank arrayList:arrayFolderList arrayCellView:arrayCellView];
                
                if (arrayFolderList.count == 0) {
                    
                    [self addNOresultImageView:@"在这里管理资料的上传下载，随时暂停取消" addView :tbDowningDataBank];
                }else{
                    
                    UIView *view = [self.view viewWithTag:NORESULTVIEW + tbDowningDataBank.tag];
                    if (view) {
                        [view removeFromSuperview];
                    }
                    
                }
                [tbDowningDataBank reloadData:YES];
            }
                break;
            case 2:
            {
                
                self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"2").WHERE(@"userid", SHARED.userId).GET();
                [self initCellListView:self.DB.resultArray cellType:0 btType:4 choseType:1 opeartionTableView:tbFinishDataBank arrayList:arrayFolderFinishList arrayCellView:arrayFinishCellView];
                
                if (arrayFolderFinishList.count == 0) {
                    
                    [self addNOresultImageView:@"离线成功的资料放在这里，没网络也可以查看" addView:tbFinishDataBank];
                }else{
                    
                    UIView *view = [self.view viewWithTag:NORESULTVIEW +tbFinishDataBank.tag];
                    if (view) {
                        [view removeFromSuperview];
                    }
                    
                }
                [tbFinishDataBank reloadData:YES];
            }
                break;
                
            default:{
                [tbDowningDataBank reloadData:YES];
            
                [tbFinishDataBank reloadData:YES];
            }
                break;
        }
        
    }else if([signal is:[MagicUITableView TAbLEVIEWLODATA]])
    {
//        MagicUITableView *tableview = (MagicUITableView *)[signal source];
//        [tableview reloadData:NO];
    }
    
}

-(void)handleViewSignal_DYBDataBankSelectBtn:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankSelectBtn TOUCHSIGLEBTN]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UIButton *btn = (UIButton *)[dict objectForKey:@"btn"];

        int row = [[dict objectForKey:@"row"] integerValue];

        
        switch (btn.tag) {
                
            case BTNTAG_SHARE:
            {
                DLogInfo(@"暂停下载");//暂停下载
                
                [self handleDownloadState:1 signal:signal opeartionTabelView:tbDowningDataBank arrayList:arrayFolderList arrayView:arrayCellView];
            }
                break;
            case BTNTAG_CHANGE:
            {//重新下载弹框
                
              [self handleDownloadState:5 signal:signal opeartionTabelView:tbDowningDataBank arrayList:arrayFolderList arrayView:arrayCellView];

            }
                
                break;
            case BTNTAG_RENAME:
            {//删除传送中弹框
               DYBDataBankShotView *deleteBt = [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要删除吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",row]];
                [deleteBt setTag:1];
            }
                break;
            case BTNTAG_RESTART:
            {//继续下载
                DLogInfo(@"重新下载");
                [self handleDownloadState:2 signal:signal opeartionTabelView:tbDowningDataBank arrayList:arrayFolderList arrayView:arrayCellView];
                
            }
                break;
            case BTNTAG_DEL:
            {//删除离线浏览文件
                
                [self handleDownloadState:3 signal:signal opeartionTabelView:tbFinishDataBank arrayList:arrayFolderFinishList arrayView:arrayFinishCellView];

            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark- 选择提示框按键回调
-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    DLogInfo(@"ddddd");
    MagicUIButton *bt = (MagicUIButton *)[signal source];
    if ([signal is:[DYBDataBankShotView LEFT]]) {
        
    }else if ([signal is:[DYBDataBankShotView RIGHT]]) {
        
        NSDictionary *dict = (NSDictionary *)[signal object];

        NSString *type = [dict objectForKey:@"type"];
//        NSNumber *row = [dict objectForKey:@"rowNum"];

        switch ([type integerValue]) {
            case BTNTAG_DEL:
            {
                
//                NSDictionary *cellParam = nil;
                NSString *encodeUrl = nil;
                
                BOOL needDelete = NO;
                
                if (bt.tag == 1)
                {//删除  ???

                    needDelete = [self handleDownloadState:4 signal:signal opeartionTabelView:tbDowningDataBank arrayList:arrayFolderList arrayView:arrayCellView];
                    
                }else if (bt.tag == 2)
                {//重新下载
                    needDelete = [self handleDownloadState:5 signal:signal opeartionTabelView:tbDowningDataBank arrayList:arrayFolderList arrayView:arrayCellView];
                }else if (bt.tag == 3)
                {//离线浏览删除 删除全部
                    [self handleDownloadState:6 signal:signal opeartionTabelView:tbFinishDataBank arrayList:arrayFolderFinishList arrayView:arrayFinishCellView];
                }else if (bt.tag == 4)
                {//传送中浏览删除 删除全部
                    [self handleDownloadState:7 signal:signal opeartionTabelView:tbDowningDataBank arrayList:arrayFolderList arrayView:arrayCellView];
                }
                
                if (needDelete)
                {
                    if (encodeUrl.length == 0) {
                        return;
                    }
                    NSString *downName = [self downPathFileNameWithUrl:encodeUrl];
//                    BOOL isFinish = [MagicSandbox deleteFile:downName];
//                    if (!isFinish)
                    {
                        [MagicSandbox deleteFile:[NSString stringWithFormat:@"%@.download", downName]];
                    }
                    
                    self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", encodeUrl).WHERE(@"userid", SHARED.userId).DELETE();
                    self.DB.FROM(kDATABANKDOWNDETAIL).WHERE(@"file_urlencode", encodeUrl).WHERE(@"userid", SHARED.userId).DELETE();
                }
                
                
            }
                break;

                case BTNTAG_GOONDOWNLOAD://
            {
                DYBDataBankShotView *ob=(DYBDataBankShotView *)[signal source];
                dict=ob.userInfo;
                
                NSString *state = @"开始下载";
                [DYBShareinstaceDelegate loadFinishAlertView:state target:self];
                
                NSString *url = [dict objectForKey:@"file_urlencode"];

                [self initCellView:dict url:url cellType:5 btType:5 bOrP:NO opeartionTableView:tbDowningDataBank arrayList:arrayFolderList arrayCellView:arrayCellView];
                
                iState = 0; //正在下载的tableView
                
                [tbDowningDataBank reloadData];

                
                NSLog(@"url -- %@",url);
                if (url != nil) { //开始下载
                    MagicRequest *request = self.HTTP_GET_DOWN(url);
                    
                    
                    [self addOrHideDownIcan:url add:YES];
                    
                    NSString *downFileName = [request downloadName];
                    
                    self.DB.FROM(KDATABANKDOWNLIST)
                    .SET(@"url",url )
                    .SET(@"filename", downFileName)
                    .SET(@"type", @"1")
                    .SET(@"show", @"1")
                    .SET(@"userid", SHARED.userId)
                    .SET(@"strType", [dict objectForKey:@"type"])
                    .SET(@"filelength", @"0")
                    .SET(@"deCodeUerl",[dict objectForKey:@"file_url"])
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
                    .SET(@"file_urlencode", url)
                    .SET(@"icon", [dict objectForKey:@"icon"])
                    .SET(@"id", [dict objectForKey:@"id"])
                    .SET(@"is_dir", isDir)
                    .SET(@"is_sys_folder", isSysFolder)
                    .SET(@"size", [dict objectForKey:@"size"])
                    .SET(@"title", [dict objectForKey:@"title"])
                    .SET(@"userid", SHARED.userId)
                    .SET(@"type", [dict objectForKey:@"type"])
                    .INSERT();
                    
                    self.DB.FROM(kDATABANKOFFLINELISTTABLE)
                    .SET(@"file_urlencode",url)
                    .SET(@"userid",SHARED.userId)
                    .INSERT();
                    
                    [self setDownNum];
                    
                     self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET();
                    
                    if (self.DB.resultArray.count == 0) {
                        
                        [self addNOresultImageView:@"在这里管理资料的上传下载，随时暂停取消" addView :tbDowningDataBank];
                    }else{
                        
                        UIView *view = [self.view viewWithTag:NORESULTVIEW + tbDowningDataBank.tag];
                        if (view) {
                            [view removeFromSuperview];
                        }
                        
                    }
                }

            }
                break;
            default:
                break;
        }
    }
    
//    RELEASEOBJ(bt);
}

//处理下载页面
- (BOOL)handleDownloadState:(NSInteger)state signal:(id)signal opeartionTabelView:(UITableView *)tabelView arrayList:(NSMutableArray *)arrayList arrayView:(NSMutableArray *)arrayView
{
    NSDictionary *dict;
    UIButton     *btn;
    int          row = 0;
    UIView       *viewCell = nil;
//    NSString     *type;
    if(state < 4 || state == 5)
    {
        dict = (NSDictionary *)[signal object];
        btn = (UIButton *)[dict objectForKey:@"btn"];
        row = [[dict objectForKey:@"row"] integerValue];
        viewCell = (UIView *)[dict objectForKey:@"cell"];
    }else
    {
        dict = (NSDictionary *)[signal object];
        
//        type = [dict objectForKey:@"type"];
        row = [[dict objectForKey:@"rowNum"] integerValue];
    }
    

    NSString *encodeUrl = nil;
    NSString *decodeUel = nil;
    DYBDataBankListCell *selectCell = nil;
    
    if (state == 1 ||state == 2 ||state == 5 ||state == 4 ||state == 7 ) { //对正在传送中数据操作
        if (arrayFolderList.count > row ) {
            
            encodeUrl = [[arrayList objectAtIndex:row] objectForKey:@"file_urlencode"];
            decodeUel = [[arrayList objectAtIndex:row] objectForKey:@"file_url"];
            selectCell = [arrayView objectAtIndex:row];
            
            [selectCell resetContentView];
        }
    }else{
    
        if (arrayFolderFinishList.count > row ) { //对已经离线数据操作
            
            encodeUrl = [[arrayList objectAtIndex:row] objectForKey:@"file_urlencode"];
            decodeUel = [[arrayList objectAtIndex:row] objectForKey:@"file_url"];
            selectCell = [arrayView objectAtIndex:row];
            
            [selectCell resetContentView];
        }
    
    }

    switch (state)
    {
        case 1:
        {//暂停下载
            DYBDataBankListCell *selectCell = [arrayView objectAtIndex:row];
            
            [selectCell resetContentView];
            
            [selectCell.labelProgress setBackgroundColor:[MagicCommentMethod colorWithHex:@"aaaaaa"]];

            UIImageView *image = selectCell.imageViewStats;
            
            if (selectCell.progressView.progress == 1.0f)
            {
                return NO;
            }
            
            [self cancelRequestWithUrl:encodeUrl];
            
            [btn setHidden:YES];
            UIView *view = [viewCell viewWithTag:BTNTAG_RESTART];
            [view setHidden:NO];
            
            
            [image setImage:[UIImage imageNamed:@"下载--3"]];
            DLogInfo(@"selectCell.progressView.progress === %@", [NSString stringWithFormat:@"%.2f", selectCell.progressView.progress]);

            self.DB.FROM(KDATABANKDOWNLIST)
            .SET(@"downprogress", [NSString stringWithFormat:@"%.1f", selectCell.progressView.progress])
            .SET(@"stopDowning",@"1")
            .WHERE(@"url", encodeUrl).WHERE(@"userid", SHARED.userId)
            .UPDATE();
            
            [selectCell.labelProgress setBackgroundColor:[MagicCommentMethod colorWithHex:@"aaaaaa"]];
            DLogInfo(@"progressview --- %@",selectCell.progressView);
        }
            break;
        case 2:
        {//继续下载
                       
            [selectCell.labelProgress setBackgroundColor:[MagicCommentMethod colorWithHex:@"6eab44"]];
            
            if (selectCell.progressView.progress == 1.0f)
                
            {
                return NO;
            }
            
            self.HTTP_GET_DOWN(encodeUrl);
            
            [btn setHidden:YES];
            UIView *view = [viewCell viewWithTag:BTNTAG_SHARE];
            [view setHidden:NO];
                      
            UIImageView *image = selectCell.imageViewStats;
            [image setImage:[UIImage imageNamed:@"下载--1"]];
            
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", encodeUrl).WHERE(@"userid", SHARED.userId).GET();
            
            NSArray *result = self.DB.resultArray;

            float fileLength = 0;
            if ([result count] > 0)
            {
                fileLength = [[[result objectAtIndex:0] objectForKey:@"downprogress"] floatValue];
            }

            [selectCell.progressView setProgress:fileLength];
            
            self.DB.FROM(KDATABANKDOWNLIST)
            .SET(@"stopDowning",@"0")
            .WHERE(@"url", encodeUrl).WHERE(@"userid", SHARED.userId)
            .UPDATE();
            
            istest = NO;
        }
            break;
        case 3:
        {//删除离线浏览
            
            [self addOrHideDownIcan:encodeUrl add:NO];
            [self delPicCache:decodeUel];
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", encodeUrl).WHERE(@"userid", SHARED.userId).DELETE();
            self.DB.FROM(kDATABANKDOWNDETAIL).WHERE(@"file_urlencode", encodeUrl).SET(@"userid", SHARED.userId).DELETE();
            
            NSString *downName = [self downPathFileNameWithUrl:encodeUrl];
            
            [MagicSandbox deleteFile:downName];
            
            [arrayList removeObjectAtIndex:row];
            [arrayView removeAllObjects];
            
            for (int i = 0; i < arrayList.count ; i++) {
                
                DYBDataBankListCell *cell = [[DYBDataBankListCell alloc] initWithFrame:CGRectZero object:nil];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [cell setIndexPath:indexPath];
                [cell setTb:tabelView];
                [cell setBeginOrPause:YES];
                [cell setCellType:0];
                [cell setBtnType:4];
                [cell initViewCell_dict:[arrayList objectAtIndex:i]];
                
                [arrayView addObject:cell];
                RELEASE(cell);

            }          
            
            tabelView._selectIndex_now = nil;
            RELEASEDICTARRAYOBJ( tabelView._muA_differHeightCellView);
            tabelView._muA_differHeightCellView = [[NSMutableArray alloc]initWithArray:arrayView];
            
            if (arrayList == 0) {
                
                [self addNOresultImageView:@"离线成功的资料放在这里，没网络也可以查看" addView :tbFinishDataBank];
            }else{
                
                UIView *view = [self.view viewWithTag:NORESULTVIEW +tbFinishDataBank.tag];
                if (view) {
                    [view removeFromSuperview];
                }
            }
            
              [tabelView reloadData];
            return NO;
        }
            break;
        case 4:
        {//删除传送中
            
            tabelView._selectIndex_now = nil;
            
            
            [self addOrHideDownIcan:encodeUrl add:NO];
            [self delPicCache:decodeUel];
            BOOL needDelete = NO;
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", encodeUrl).WHERE(@"downprogress", @"1").WHERE(@"userid", SHARED.userId).GET();
            if (self.DB.resultCount > 0)
            {//下载完成的标注为不显示
                self.DB.FROM(KDATABANKDOWNLIST).SET(@"show", @"0").WHERE(@"url", encodeUrl).WHERE(@"userid", SHARED.userId).UPDATE();
            }else
            {//未下载完成的删除
                needDelete = YES;
                self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", encodeUrl).WHERE(@"userid", SHARED.userId).DELETE();
                self.DB.FROM(kDATABANKDOWNDETAIL).WHERE(@"file_urlencode", encodeUrl).WHERE(@"userid", SHARED.userId).DELETE();
                
               [self cancelRequestWithUrl:encodeUrl];
            }
            
            
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET(); //正在下载
            
             NSString *strKey = [NSString stringWithFormat:@"downingNUM_%@",SHARED.userId];
            
            NSInteger current = self.DB.resultArray.count;
            [[NSUserDefaults standardUserDefaults] setInteger:current forKey:strKey];
            [[DYBUITabbarViewController sharedInstace] addAndRefreshTotalMsgView:current];
            [[DYBUITabbarViewController sharedInstace] changeMsgTotalFrame];
            
            [self initCellListView:self.DB.resultArray cellType:5 btType:5 choseType:0 opeartionTableView:tbDowningDataBank arrayList:arrayFolderList arrayCellView:arrayCellView];
            
            if (arrayFolderList == 0) {
                
                [self addNOresultImageView:@"在这里管理资料的上传下载，随时暂停取消" addView :tbDowningDataBank];
            }else{
                
                UIView *view = [self.view viewWithTag:NORESULTVIEW +tbDowningDataBank.tag];
                if (view) {
                    [view removeFromSuperview];
                }
            }
            
            return needDelete;
        
        }
            break;
        case 5:
        {//重新下载
            
            [self cancelRequestWithUrl:encodeUrl];
            
            DYBDataBankListCell *cell = (DYBDataBankListCell *)[arrayView objectAtIndex:row];
            [cell.progressView setProgress:0];
            [cell.labelProgress setText:[NSString stringWithFormat:@"0/100"]];
            
            [cell.labelProgress setBackgroundColor:[MagicCommentMethod colorWithHex:@"6eab44"]];
            
            UIView *viewStart = [viewCell viewWithTag:BTNTAG_RESTART];
            [viewStart setHidden:YES];
            
            UIView *viewStop = [viewCell viewWithTag:BTNTAG_SHARE];
            [viewStop setHidden:NO];

            
            UIImageView *image = selectCell.imageViewStats;
            [image setImage:[UIImage imageNamed:@"下载--1"]];

            NSString *downName = [self downPathFileNameWithUrl:encodeUrl];
            [MagicSandbox deleteFile:downName];
            [MagicSandbox deleteFile:[NSString stringWithFormat:@"%@.download", downName]];
            
            self.HTTP_GET_DOWN(encodeUrl);
            
            self.DB.FROM(KDATABANKDOWNLIST) 
            .SET(@"stopDowning",@"0")
            .WHERE(@"url", encodeUrl).WHERE(@"userid", SHARED.userId)
            .UPDATE();
        }
            
            break;
        case 6:
        {//离线浏览删除
            
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"2").WHERE(@"userid", SHARED.userId).GET();
            NSArray *sqlResutl = [self.DB.resultArray copy];
            
            for (int i = 0; i < [sqlResutl count]; i++)
            {
                NSDictionary *dict = [sqlResutl objectAtIndex:i];
                NSString *encodeUrl2 = [dict objectForKey:@"url"];
                NSString *deCodeUrl = [dict objectForKey:@"deCodeUerl"];
                
                self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", encodeUrl2).WHERE(@"userid", SHARED.userId).DELETE();
                self.DB.FROM(kDATABANKDOWNDETAIL).WHERE(@"file_urlencode", encodeUrl2).WHERE(@"userid", SHARED.userId).DELETE();
                NSString *downName = [self downPathFileNameWithUrl:encodeUrl2];
                [MagicSandbox deleteFile:downName];
                
                [self addOrHideDownIcan:encodeUrl2 add:NO];
                [self delPicCache:deCodeUrl];
            }
            
            [self addNOresultImageView:@"离线成功的资料放在这里，没网络也可以查看" addView :tbFinishDataBank];
            
            tbFinishDataBank._selectIndex_now = nil; //设置删除selectindex 为空
            
            [arrayView removeAllObjects];
            [arrayList removeAllObjects];
            
            [tabelView reloadData];
            return NO;
        }
            break;
        case 7:
        {//传送中删除

            tabelView._selectIndex_now = nil;
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).GET();
            NSArray *sqlResutl = self.DB.resultArray;
            
            for (int i = 0; i < [sqlResutl count]; i++)
            {
                NSDictionary *dict = [sqlResutl objectAtIndex:i];
                NSString *encodeUrl2 = [dict objectForKey:@"url"];
                NSString *deCodeUrl = [dict objectForKey:@"deCodeUerl"];
                
                [self addOrHideDownIcan:encodeUrl2 add:NO];
                
                self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).DELETE();
                self.DB.FROM(kDATABANKDOWNDETAIL).WHERE(@"file_urlencode", encodeUrl2).DELETE();
                NSString *downName = [self downPathFileNameWithUrl:encodeUrl2];
                [MagicSandbox deleteFile:downName];
                [MagicSandbox deleteFile:[NSString stringWithFormat:@"%@.download", downName]];
                usleep(500);
                DLogInfo(@"encodeUrl ----- %@",encodeUrl2);
                [self cancelRequestWithUrl:encodeUrl2];
                
                [self delPicCache:deCodeUrl];
            }
            [arrayList removeAllObjects];
            [arrayView removeAllObjects];
            
            [tabelView reloadData];
            
            self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"type", @"1").WHERE(@"userid", SHARED.userId).DELETE();
            
            NSInteger current = self.DB.resultArray.count;
            NSString *strKey = [NSString stringWithFormat:@"downingNUM_%@",SHARED.userId];
            [[NSUserDefaults standardUserDefaults] setInteger:current forKey:strKey];
             [[DYBUITabbarViewController sharedInstace] addAndRefreshTotalMsgView:current];
            
            
            if (self.DB.resultArray.count == 0) {
                
                [self addNOresultImageView:@"在这里管理资料的上传下载，随时暂停取消" addView :tbDowningDataBank];
            }else{
                
                UIView *view = [self.view viewWithTag:NORESULTVIEW +tbDowningDataBank.tag];
                if (view) {
                    [view removeFromSuperview];
                }
            }
            
            return NO;
        }
            break;
        default:
            break;
    }    
    return NO;
}




-(void)addNOresultImageView:(NSString *)strMsg addView:(UIView*)tabeview{
    
    
    UIView *view = [self.view viewWithTag:NORESULTVIEW + tabeview.tag];
    if (!view) {
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0.0f,  SEARCHBAT_HIGH, 300.0f, 400.0f)];
        [view setBackgroundColor:[UIColor clearColor]];
        
        [view setTag:NORESULTVIEW + tabeview.tag];
        
        [tabeview insertSubview:view atIndex:0];
        RELEASE(view);
        
        
        UIImage *image = [UIImage imageNamed:@"ybx_big.png"];
        float BearHeadStartX = (CGRectGetWidth(self.view.frame)-image.size.width/2)/2;
        float BearHeadStartY = (self.frameHeight-self.headHeight-image.size.height/2 - 70)/2-44 - SEARCHBAT_HIGH;
        MagicUIImageView *viewBearHead = [[MagicUIImageView alloc] initWithFrame:CGRectMake(BearHeadStartX, BearHeadStartY - 44, image.size.width/2, image.size.height/2)];
        [viewBearHead setBackgroundColor:[UIColor clearColor]];
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


- (void)resetBtRow:(NSMutableArray *)arrayCell
{
    for (int i = 0; i < [arrayCell count]; i++)
    {
        DYBDataBankListCell *cellView = [arrayCell objectAtIndex:i];
        if (cellView && cellView.btnBottom && cellView.btnBottom.touchCellIndexPath)
        {
            cellView.btnBottom.touchCellIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [cellView.btnBottom resetBtRow];
        }
    }
}

-(void)delPicCache:(NSString *)strEncode{

//    if ([strType isEqualToString:@"jpg"]||[strType isEqualToString:@"png"]||[strType isEqualToString:@"bmp"]) {
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString * diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
        NSString *encoderUrl= [strEncode stringByAddingPercentEscapesUsingEncoding];
        NSString *md5 =  [MagicCommentMethod dataBankMD5:encoderUrl];
        NSString *pathtt = [diskCachePath stringByAppendingPathComponent:md5];
        
        NSFileManager* fm=[NSFileManager defaultManager];
        if([fm fileExistsAtPath:pathtt]){
                    
            [fm removeItemAtPath:pathtt error:nil];
            
//        }
        
    }


}

- (void)dealloc
{
    

    
    for (UIView *view  in arrayFinishCellView) {
        [view release];
        view = nil;
    }
    RELEASEDICTARRAYOBJ(arrayFinishCellView)
    
    for (UIView *view  in arrayCellView) {
        [view release];
        view = nil;
    }
    RELEASEDICTARRAYOBJ(arrayCellView);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    RELEASEDICTARRAYOBJ(arrayFolderList);
    RELEASEDICTARRAYOBJ(arrayFolderFinishList);
    
    [shareInstance release];
    shareInstance = nil;
    
    [super dealloc];
}

@end
