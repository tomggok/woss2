 //
//  DYBShareInNotesViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-10-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBShareInNotesViewController.h"
#import "DYBDynamicViewController.h"
#import "UIView+MagicCategory.h"
#import "DYBCellForNotes.h"
#import "UITableView+property.h"
#import "user.h"
#import "status.h"
#import "NSString+Count.h"
#import "noteModel.h"
#import "Magic_Runtime.h"
#import "notesUserinfo.h"
#import "Magic_Device.h"
#import "DYBSelectContactViewController.h"
#import "DYBNoteDetailViewController.h"
#import "UIViewController+MagicCategory.h"
#import "ChineseToPinyin.h"
#import "DYBGuideView.h"
@interface DYBShareInNotesViewController ()

@end

@implementation DYBShareInNotesViewController
#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        if (!_search) {
            _search=[[MagicUISearchBar alloc]initWithFrame:CGRectMake(0, self.headHeight+1, self.view.frame.size.width, 50) backgroundColor:ColorNav placeholder:@"标签" isHideOutBackImg:YES isHideLeftView:NO];
            [_search customBackGround:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_search"]] autorelease]];
            _search.tag=-1;
            [self.view addSubview:_search];
            [_search release];
        }
        
        _muA_ShareMeData=[[NSMutableArray alloc]initWithCapacity:10];
        _muA_MyShareData=[[NSMutableArray alloc]initWithCapacity:10];
        [self creatTbv];
        
        shareMePage = 1;
        mySharePage = 1;
        
        {//HTTP请求,笔记列表
            MagicRequest *request = [DYBHttpMethod notes_sharenotelist:@"1" num:@"10" keywords:@"" isAlert:YES receive:self];
            [request setTag:1];
            if (!request) {//无网路
                
            }
        }
        
        [self observeNotification:[DYBNoteDetailViewController AutoRefreshTbvInViewWillAppear]];
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        //        self.rightButton.hidden=YES;
        
        if (!_bt_DropDown) {
            //            UIImage *img= [UIImage imageNamed:@"btn_mainmenu_default"];
            _bt_DropDown = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0,90, self.headHeight)];
            _bt_DropDown.tag=-1;
            _bt_DropDown.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
            //            _bt_DropDown.alpha=0.9;
            [_bt_DropDown addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            //            [_bt_mayKnow setBackgroundImage:img forState:UIControlStateNormal];
            //            [_bt_sendNotice setBackgroundImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
            //            [_bt_DropDown setTitle:@"好友"];
            [_bt_DropDown setTitleColor:[UIColor blackColor]];
            [_bt_DropDown setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
            [self.headview addSubview:_bt_DropDown];
            [_bt_DropDown changePosInSuperViewWithAlignment:2];
            RELEASE(_bt_DropDown);
            
            
        }
        
        if (_tbv_dropDown.row == 0) {
            [self.headview setTitle:@"共享给我"];
        }else{
            [self.headview setTitle:@"我共享的"];
        }
        
        
        [self.headview setTitleArrow];
        
        if (self.b_isAutoRefreshTbvInViewWillAppear) {
            [self requestNotes:1 page:[NSString stringWithFormat:@"%d",1] num:[NSString stringWithFormat:@"%d",10] keywords:_search.text];
            self.b_isAutoRefreshTbvInViewWillAppear=NO;
        }
        
        if (![[NSUserDefaults standardUserDefaults] stringForKey:@"DYBShareInNotesViewController_DYBGuideView"] || [[[NSUserDefaults standardUserDefaults] stringForKey:@"DYBShareInNotesViewController_DYBGuideView"] intValue]==0) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DYBShareInNotesViewController_DYBGuideView"];
            
            {
                DYBGuideView *guideV=[[DYBGuideView alloc]initWithFrame:self.view.frame];
                guideV.AddImgByName(@"noteteaching04",nil);
                [self.drNavigationController.view addSubview:guideV];
                RELEASE(guideV);
            }
        }

        
        

    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        RELEASEDICTARRAYOBJ(_muA_ShareMeData);
        RELEASEDICTARRAYOBJ(_muA_MyShareData);
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        DLogInfo(@"");

    }
    
}

- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        DYBUITabbarViewController *dync = [DYBUITabbarViewController sharedInstace];
        [dync scrollMainView:1];
    }
}

-(void)creatTbv{
    if (!_tbvView) {
        _tbvView=[[DYBVariableTbvView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_search.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(_search.frame)-kH_StateBar) cellClass:[DYBCellForNotes class]];
        _tbvView.v_headerVForHide=_search;//上滑时隐藏search
        _tbvView.tbv.i_pageNums=10;
        [self.view addSubview:_tbvView];
        RELEASE(_tbvView);
        _tbv=_tbvView.tbv;
    }
}


//notesType 请求类型 加载还是刷新 
- (void)requestNotes:(int)notesType page:(NSString*)page num:(NSString*)num keywords:(NSString*)keywords{
    
    if (_tbv_dropDown.row == 0) {
        MagicRequest *request = [DYBHttpMethod notes_sharenotelist:page num:num keywords:keywords isAlert:YES receive:self];
        [request setTag:notesType];
        if (!request) {//无网路
            
        }
    }else {
        MagicRequest *request = [DYBHttpMethod notes_mysharelist:page num:num keywords:keywords isAlert:YES receive:self];
        [request setTag:notesType];
        if (!request) {//无网路
            
        }
    }

}


#pragma mark- 通知中心回调
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification is:[DYBNoteDetailViewController AutoRefreshTbvInViewWillAppear]]){
        self.b_isAutoRefreshTbvInViewWillAppear=YES;
        
    }
}
#pragma mark- 接受tbv信号

//static NSString *cellName = @"cellName";//
//
- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath  暂时把每个cell保存,后期有时间优化为只保存高度,返回cell时再异步计算cell的视图,目前刷新后所有cell的view都要重新创建
    {
        
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
    {
        
        
    }//
    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
    {
        
        
    }
    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell  只返回显示的cell
    {
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        noteModel *model=[[_tbvView DataSourceArray] objectAtIndex:indexPath.row];
        DYBNoteDetailViewController *vc = [[DYBNoteDetailViewController alloc] init];
        
        if (_tbv_dropDown.row == 0) {
            vc.typeTop = 1;
        }else {
            vc.typeTop = 2;
            vc.shareId = model.shareid;
        }
        vc.str_nid=model.nid;
        vc.userId = model.id;
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        MagicUITableView *tableView = ((DYBVariableTbvView *)[signal source]).tbv;
        {//HTTP请求,笔记列表
        
            [self requestNotes:2 page:[NSString stringWithFormat:@"%d",++shareMePage] num:[NSString stringWithFormat:@"%d",tableView.i_pageNums] keywords:_search.text];
            
        }
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        MagicUITableView *tableView = ((DYBVariableTbvView *)[signal source]).tbv;
        
        {//HTTP请求,笔记列表
            [self requestNotes:1 page:[NSString stringWithFormat:@"%d",tableView._page=1] num:[NSString stringWithFormat:@"%d",tableView.i_pageNums=10] keywords:_search.text];
        }
        
    }
    
    else if ([signal is:[MagicUITableView TABLESECTIONINDEXTITLESFORTABLEVIEW]])//右侧索引列表
    {
        //        }
    }else if ([signal is:[MagicUITableView TABLESECTIONFORSECTIONINDEXTITLE]])//点击右测是索引列表上的某个字母时回调,参数index和title是 右侧索引列表上被点击的字母在 索引列表的下标和名字,返回被点击的字母对应的section的下标
    {
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
        
    }else if ([signal is:[MagicUISearchBar CANCEL]]){//取消搜索
        //        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        [self changeTbv];
    }else if ([signal is:[MagicUISearchBar SEARCH]]){//按下搜索按钮
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
       [self requestNotes:1 page:[NSString stringWithFormat:@"%d",1] num:[NSString stringWithFormat:@"%d",10] keywords:search.text];
        
        
    }else if ([signal is:[MagicUISearchBar CHANGEWORD]]){//内容改变
        NSString *str=(NSString *)signal.object;
        if ([str length] == 0) {
            return;
        }
        
        
    }else if ([signal is:[MagicUISearchBar SEARCHING]]){//正在搜索
    }
}

-(void)changeTbv
{
    [_search cancelSearch];
    
    if (!_tbv_dropDown) {
        return;
    }
    
    [self.headview setTitle:[_tbv_dropDown.arrMenu objectAtIndex:(_tbv_dropDown.row)]];
    [self.headview setTitleArrow];
    
    [self requestNotes:1 page:[NSString stringWithFormat:@"%d",1] num:[NSString stringWithFormat:@"%d",10] keywords:@""];
}


#pragma mark- 接受按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        
        if (bt)
        {
            switch (bt.tag) {
                    
                case -1://顶部打开下拉列表按钮
                {
                    int nSelRow=_tbv_dropDown.row;
                    BOOL bPullDown=_tbv_dropDown.bPullDown;
                    RELEASEVIEW(_tbv_dropDown);
                    
                    if (TraparentView) {
                        RELEASEVIEW(TraparentView);
                    }
                    
                    TraparentView = [[MagicUIButton alloc]initWithFrame:CGRectMake(0, self.headHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.headHeight)];
                    TraparentView.tag = -1000;
                    [TraparentView addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                    TraparentView.backgroundColor = [UIColor clearColor];
                    [self.view addSubview:TraparentView];
                    
                    
                    if (!_tbv_dropDown) {
                        NSArray *arrBtnLable =[[NSArray alloc] initWithObjects:@"共享给我", @"我共享的",nil] ;
                        _tbv_dropDown = [[DYBMenuView alloc]initWithData:arrBtnLable selectRow:nSelRow];
                        [_tbv_dropDown setHidden:YES];
                        //                        [self.view insertSubview:_tbv_dropDown belowSubview:self.headview];
                        
                        [self.view addSubview:_tbv_dropDown];
                    }
                    
                    if (bPullDown) {
                        //            [_tabMenu setFrame:CGRectMake(120, 44-CGRectGetHeight(_tabMenu.frame), 100, CGRectGetHeight(_tabMenu.frame))];
                        //            [_tabMenu setHidden:YES];
                        
                        [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:self from:self target:_tbv_dropDown];
                        if (TraparentView) {
                            RELEASEVIEW(TraparentView);
                        }
                    }else{
                        //            [_tabMenu setFrame:CGRectMake(120, 44, 100, CGRectGetHeight(_tabMenu.frame))];
                        //            [_tabMenu setHidden:NO];
                        
                        [self sendViewSignal:[DYBMenuView MENUDOWN] withObject:self from:self target:_tbv_dropDown];
                    }
                    
                    
                    
                    _tbv_dropDown.bPullDown = !bPullDown;
                    
                }
                    break;
                case -3://转存到我的笔记
                {
                   
                    NSIndexPath *index=(NSIndexPath *)signal.object;
                    DYBDataBankShotView *showView  = [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"确认要复制到我的笔记么" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",index.row]];
                    showView.tag = 1;
                }
                    break;
                case -4://取消共享
                {
                    
                    NSIndexPath *index=(NSIndexPath *)signal.object;
                    _tbvView.tbv.indexAfterRequest=index;
                    DYBDataBankShotView *showView = [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"该笔记已经共享，取消将同时删除笔记！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",index.row]];
                    showView.tag = 2;
                }
                    break;
                case -5://修改共享
                {
                    NSIndexPath *index=(NSIndexPath *)signal.object;
                    if (_tbvView.tbv.muA_singelSectionData.count>index.row) {
                        noteModel *model=[_tbvView.tbv.muA_singelSectionData objectAtIndex:index.row];
                        
                        DYBSelectContactViewController *classM = [[DYBSelectContactViewController alloc]init];
                        classM.nid=model.nid;
                        classM.bEnterDataBank=YES;
                        //                    classM.docAddr = [_dictFileInfo objectForKey:@"file_path"];
                        [self.drNavigationController pushViewController:classM animated:YES];
                        RELEASE(classM);
                    }
                    
                }
                    break;
                case -1000://去掉弹出框
                {
                    [_bt_DropDown didTouchUpInside];
                    
                }
                    break;
                case k_tag_fadeBt://取消search的背景按钮
                {
                    if ([_search cancelSearch]) {
                        [_search sendViewSignal:[MagicUISearchBar CANCEL] withObject:_search];
                        
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}

-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        
        if (![MagicDevice hasInternetConnection]){
            DLogInfo(@"确定是否网络连接");
            return;
        }
        DYBDataBankShotView *show = signal.source;
        NSDictionary *dicType = (NSDictionary *)[signal object];
        int row = [[dicType objectForKey:@"rowNum"] intValue];
        
        
        if (show.tag == 1) {
            //转存到资笔记
            noteModel *model=[_tbvView.tbv.muA_singelSectionData objectAtIndex:row];
            MagicRequest *request = [DYBHttpMethod notes_savesharenote:model.id nid:model.nid isAlert:YES receive:self];
            [request setTag:3];
            if (!request) {//无网路
                
            }
        }else {
            if (_tbvView.tbv.muA_singelSectionData.count>row) {
                noteModel *model=[_tbvView.tbv.muA_singelSectionData objectAtIndex:row];
                MagicRequest *request = [DYBHttpMethod notes_delsharenote:model.shareid isAlert:YES receive:self];
                [request setTag:4];
                if (!request) {//无网路
                    
                }
            }
            
        }

        
    }
    
    
}

#pragma mark- 初始化无数据提示view
-(void)initNoDataView:(NSString *)str{
    if (_imgV_noDataTip) {
        REMOVEFROMSUPERVIEW(_imgV_noDataTip);
        REMOVEFROMSUPERVIEW(_lb_noDataTip);
    }
    
    if ([str isEqualToString:@""]) {
        return;
    }
    
    UIImage *img=[UIImage imageNamed:@"ybx_big"];
    _imgV_noDataTip=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self.view Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    [_imgV_noDataTip setFrame:CGRectMake(CGRectGetMinX(_imgV_noDataTip.frame), CGRectGetMinY(_imgV_noDataTip.frame)-20, CGRectGetWidth(_imgV_noDataTip.frame), CGRectGetHeight(_imgV_noDataTip.frame))];
    RELEASE(_imgV_noDataTip);
    [self.view sendSubviewToBack:_imgV_noDataTip];
    
    {
        _lb_noDataTip=[[MagicUILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imgV_noDataTip.frame)+20, 0, 0)];
        _lb_noDataTip.backgroundColor=[UIColor clearColor];
        _lb_noDataTip.textAlignment=NSTextAlignmentLeft;
        _lb_noDataTip.font=[DYBShareinstaceDelegate DYBFoutStyle:20];
        _lb_noDataTip.text=str;
        _lb_noDataTip.textColor=ColorGray;
        _lb_noDataTip.numberOfLines=2;
        _lb_noDataTip.lineBreakMode=NSLineBreakByWordWrapping;
        [_lb_noDataTip sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        [self.view addSubview:_lb_noDataTip];
        [_lb_noDataTip changePosInSuperViewWithAlignment:0];
        
        _lb_noDataTip.linesSpacing=15;
        [_lb_noDataTip setNeedCoretext:YES];
        RELEASE(_lb_noDataTip);
    }
    
}




#pragma mark- DYBPullDownMenuView消息
- (void)handleViewSignal_DYBDynamicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBDynamicViewController MENUSELECT]]) {
        
        [self.headview setTitle:[_tbv_dropDown.arrMenu objectAtIndex:_tbv_dropDown.row]];
        [self.headview setTitleArrow];
        
        
        switch (_tbv_dropDown.row) {
            case 0://共享给我
            {
                
                if (_muA_ShareMeData.count==0) {
                    
                    {//HTTP请求,/共享给我列表
                        MagicRequest *request = [DYBHttpMethod notes_sharenotelist:@"1" num:@"10" keywords:@"" isAlert:YES receive:self];
                        [request setTag:1];
                        if (!request) {//无网路
                            
                        }
                    }
                }else{
                    [self initNoDataView:@""];
                    [_tbvView releaseCell];
                    [_tbvView releaseDataSource];
                    [_tbvView creatTbv];
                    
                    for (noteModel *model in _muA_ShareMeData) {
                        [_tbvView addDataSource:model];
                    }
                    [_tbvView reloadData:NO];
                }
                
            }
                break;
            case 1://我共享的
            {
                
                if (_muA_MyShareData.count==0) {
                    
                    {//HTTP请求,我共享的笔记列表
                        MagicRequest *request = [DYBHttpMethod notes_mysharelist:@"1" num:@"10" keywords:@"" isAlert:YES receive:self];
                        [request setTag:1];
                        if (!request) {//无网路
                            
                        }
                    }
                }else{
                    [self initNoDataView:@""];
                    [_tbvView releaseCell];
                    [_tbvView releaseDataSource];
                    [_tbvView creatTbv];
                    
                    for (noteModel *model in _muA_MyShareData) {
                        [_tbvView addDataSource:model];
                    }
                    [_tbvView reloadData:NO];
                }

                
            }
                break;
            default:
                break;
        }
        
        [_bt_DropDown didTouchUpInside];
        
    }
}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取|刷新 笔记列表
            {
                switch (_tbv_dropDown.row) {
                case 0://全部笔记
                {
                    shareMePage = 1;
                }
                    break;
                case 1://星标笔记
                {
                    mySharePage = 1;
                }
                    break;
                default:
                    break;
            }

                
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    DLogInfo(@"========%@",response.data);
                    if (_search.b_isSearching) {//搜索结果
                        [_search resignFirstResponder];
                        [_search releaseShadeBt];
                        [_search releaseCancelBt];
                    }
                    
                    NSArray *list=[response.data objectForKey:@"result"];
                    if ([_tbvView dataSourceCount]>0 && list.count>0) {
                        
                        [_tbvView releaseCell];
                        [_tbvView releaseDataSource];
                        [_tbvView creatTbv];
                        
                        switch (_tbv_dropDown.row) {
                            case 0://全部笔记
                            {
                                [_muA_ShareMeData removeAllObjects];
                            }
                                break;
                            case 1://星标笔记
                            {
                                [_muA_MyShareData removeAllObjects];
                            }
                                break;
                            default:
                                break;
                        }

                    }
                    
                    
                    
                    int month=-1,day=-1,index=0;
                    NSMutableArray *arr=nil;
                    for (NSDictionary *d in list) {
                        noteModel *model = [noteModel JSONReflection:d];
                        
                        if([NSString getDateComponentsByTimeStamp:[model.create_time intValue]].month!=month){  //如果前一个model的月份和此model月份不一样,数据源里要先加一个显示年月份的model,再加此model,已和cell的顺序一致
                            month=[NSString getDateComponentsByTimeStamp:[model.create_time intValue]].month;
                            noteModel *temp=[[noteModel alloc]init];
                            temp.create_time=model.create_time;
                            temp.type= -1;
                            temp.nid=model.nid;
                            temp.cellH=30;
                            [_tbvView addDataSource:temp];//添加月份cell的model
                            
                            
                            if (_tbv_dropDown.row == 0) {
                                model.type= 1;
                            }else {
                                model.type= 2;
                            }
                            [_tbvView addDataSource:model];//添加笔记cell的model
                            model.cellH=140;
                            
                            switch (_tbv_dropDown.row) {
                                case 0://全部笔记
                                {
                                    [_muA_ShareMeData addObject:temp];
                                    [_muA_ShareMeData addObject:model];
                                }
                                    break;
                                case 1://星标笔记
                                {
                                    [_muA_MyShareData addObject:temp];
                                    [_muA_MyShareData addObject:model];
                                    
                                }
                                    break;
                                default:
                                    break;
                            }

                            
                            RELEASE(temp);
                        }else{
                            model.cellH=140;
                            if (_tbv_dropDown.row == 0) {
                                model.type= 1;
                            }else {
                                model.type= 2;
                            }
                            
                            [_tbvView addDataSource:model];//添加笔记cell的model
                            
                            switch (_tbv_dropDown.row) {
                                case 0://全部笔记
                                {
                                    [_muA_ShareMeData addObject:model];
                                }
                                    break;
                                case 1://星标笔记
                                {
                                    [_muA_MyShareData addObject:model];
                                }
                                    break;
                                default:
                                    break;
                            }
                        }
                        
                    }
                    
                    {
                        if ([_tbvView dataSourceCount]>0 && list.count>0) {
                            //                            [self creatTbv];
                            //                            [self initSectionOrder:_muA_data_friends tbv:_tbv_friends_myConcern_RecentContacts];
                            //                            [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                            [self initNoDataView:@""];
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbvView reloadData:NO];
                            }else{
                                [_tbvView reloadData:YES];
                            }
                            return;
                        }else{//没获取到数据,恢复headerView
                            
                            {//避免有 好友等数据但没动态数据的用户刷新不到 好友等数据
                                {
                                    
                                    [_tbvView releaseCell];
                                    [_tbvView releaseDataSource];
                                    [_tbvView creatTbv];
                                }
                            }
                            [_tbvView reloadData:YES];
                        }
                        
                    }
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                if (_search.b_isSearching) {
                    [self initNoDataView:@"   没有搜到笔记..."];
                }else{
                    [self initNoDataView:@"   一条笔记也没有"];
                }
                
                //                [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                
            }
                break;
            case 2://加载更多
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    
                    NSArray *list=[response.data objectForKey:@"result"];
                    noteModel *lastModel=[_tbvView.tbv.muA_singelSectionData lastObject];
                    
                    int month=[NSString getDateComponentsByTimeStamp:[lastModel.create_time intValue]].month,day=[NSString getDateComponentsByTimeStamp:[lastModel.create_time intValue]].day,index=0;
                    
                    //                    NSMutableArray *arr=nil;
                    for (NSDictionary *d in list) {
                        noteModel *model = [noteModel JSONReflection:d];
                        
                        if([NSString getDateComponentsByTimeStamp:[model.create_time intValue]].month!=month){  //如果前一个model的月份和此model月份不一样,数据源里要先加一个显示年月份的model,再加此model,已和cell的顺序一致
                            month=[NSString getDateComponentsByTimeStamp:[model.create_time intValue]].month;
                            noteModel *temp=[[noteModel alloc]init];
                            temp.create_time=model.create_time;
                            temp.type=-1;
                            temp.nid=model.nid;
                            temp.cellH=30;
                            [_tbvView addDataSource:temp];//添加月份cell的model
                            
                            if (_tbv_dropDown.row == 0) {
                                model.type= 1;
                            }else {
                                model.type= 2;
                            }
                            [_tbvView addDataSource:model];//添加笔记cell的model
                            model.cellH=140;
                            
                            switch (_tbv_dropDown.row) {
                                case 0://全部笔记
                                {
                                    [_muA_ShareMeData addObject:temp];
                                    [_muA_ShareMeData addObject:model];
                                }
                                    break;
                                case 1://星标笔记
                                {
                                    [_muA_MyShareData addObject:temp];
                                    [_muA_MyShareData addObject:model];
                                    
                                }
                                    break;
                                default:
                                    break;
                            }

                            
                            RELEASE(temp);
                        }else{
                            model.cellH=140;
                            if (_tbv_dropDown.row == 0) {
                                model.type= 1;
                            }else {
                                model.type= 2;
                            }
                            [_tbvView addDataSource:model];//添加笔记cell的model
                            
                            switch (_tbv_dropDown.row) {
                                case 0://全部笔记
                                {
                                    [_muA_ShareMeData addObject:model];
                                }
                                    break;
                                case 1://星标笔记
                                {
                                    [_muA_MyShareData addObject:model];
                                }
                                    break;
                                default:
                                    break;
                            }

                        }
                        
                    }
                    
                    {
                        if ([_tbvView dataSourceCount]>0 && list.count>0) {
                            //                            [self creatTbv];
                            //                            [self initSectionOrder:_muA_data_friends tbv:_tbv_friends_myConcern_RecentContacts];
                            //                            [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbvView reloadData:NO];
                            }else{
                                [_tbvView reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbvView reloadData:YES];
                        }
                        
                    }
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                
                //                [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                
            }
                break;
            case 3://转存到笔记
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    DLogInfo(@"======%@",response.data);
                     if ([[response.data objectForKey:@"result"] intValue]==1) {//成功
                         
                         [DYBShareinstaceDelegate loadFinishAlertView:@"转存成功" target:self];
                     }
                    
                }else if ([response response] ==khttpfailCode){
                    
                    [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                }
                
                
            }
                break;
            case 4://取消共享
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    DLogInfo(@"======%@",response.data);
                    if ([[response.data objectForKey:@"result"] intValue]==1) {//成功
                        
                        [DYBShareinstaceDelegate loadFinishAlertView:@"取消成功" target:self];
                    }
                    
                    [_tbvView.tbv.muA_singelSectionData removeObjectAtIndex:_tbvView.tbv.indexAfterRequest.row];//删数据源
                    [_muA_MyShareData removeObjectAtIndex:_tbvView.tbv.indexAfterRequest.row];
                    
                    [_tbvView.tbv._muA_differHeightCellView removeObjectAtIndex:_tbvView.tbv.indexAfterRequest.row];
                    
                    //                        [_tbv beginUpdates];
                    [_tbvView.tbv deleteRowsAtIndexPaths:[NSArray arrayWithObject:_tbvView.tbv.indexAfterRequest] withRowAnimation:UITableViewRowAnimationFade];
                    //                        [_tbv endUpdates];
                    
                    [_tbvView releaseCell];
                    [_tbvView reloadData:YES];
                    
                    //                        [_tbv._selectIndex_now release];
                    _tbvView.tbv.indexAfterRequest=Nil;
                    
                }else if ([response response] ==khttpfailCode){
                    
                    
                    
                    [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                }
                _tbvView.tbv.indexAfterRequest=nil;
                
            }
                break;

                    default:
                break;
        }
    }
}


@end
