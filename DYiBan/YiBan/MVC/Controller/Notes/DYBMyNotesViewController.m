//
//  DYBMyNotesViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-10-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBMyNotesViewController.h"
#import "DYBDynamicViewController.h"
#import "DYBNoteDetailViewController.h"
#import "UITableView+property.h"
#import "user.h"
#import "status.h"
#import "NSString+Count.h"
#import "noteModel.h"
#import "DYBCellForNotes.h"
#import "Magic_Runtime.h"
#import "UIView+MagicCategory.h"
#import "DYBSelectContactViewController.h"
#import "UserSettingMode.h"
#import "DYBNoteDetailViewController.h"
#import "UIViewController+MagicCategory.h"
#import "DYBGuideView.h"
@interface DYBMyNotesViewController ()
{
    NSString *_str_CalendarContent;//请求日历的年月
//    BOOL _isCalendar;//是否请求日历筛选
}
@end

@implementation DYBMyNotesViewController

@synthesize isGotoNewDote=_isGotoNewDote;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        self.view.backgroundColor=[UIColor redColor];
        
        if (!_search) {
            _search=[[MagicUISearchBar alloc]initWithFrame:CGRectMake(0, self.headHeight+1, self.view.frame.size.width, 50) backgroundColor:ColorNav placeholder:@"标签" isHideOutBackImg:YES isHideLeftView:NO];
            [_search customBackGround:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_search"]] autorelease]];
            _search.tag=-1;
            [self.view addSubview:_search];
            [_search release];
        }
        
        [self creatTbv];
        
//        _muA_AllNoteData=[[NSMutableArray alloc]initWithCapacity:10];
//        _muA_favoriteNoteData=[[NSMutableArray alloc]initWithCapacity:10];

        
        {//HTTP请求,笔记列表
            MagicRequest *request = [DYBHttpMethod notes_listByKeywords:@"" tagid:@"" favorite:((_tbv_dropDown.row==0)?(@"0"):(@"1")) page:@"1" num:@"10" searchmonth:@"" delnum:@"" isAlert:YES receive:self];
            [request setTag:1];
        }
        
        [self observeNotification:[DYBNoteDetailViewController AutoRefreshTbvInViewWillAppear]];

        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        
//        if (_isGotoNewDote) {
//            DYBNoteDetailViewController *vc = [[DYBNoteDetailViewController alloc] init];
//            
//            [self.drNavigationController pushViewController:vc animated:YES];
//            RELEASE(vc);
//            
//            _isGotoNewDote=NO;
//
//        }
        
        self.rightButton.hidden=YES;
        
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

            [self.headview setTitle:@"所有笔记"];
            [self.headview setTitleArrow];
            
        }
        
        if (!_bt_creatNote) {
            UIImage *img= [UIImage imageNamed:@"btn_addtag_def"];
            _bt_creatNote = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.headview.frame.size.width-img.size.width/2, 0, img.size.width/2, img.size.height/2)];
            _bt_creatNote.backgroundColor=[UIColor clearColor];
            _bt_creatNote.tag=-2;
            [_bt_creatNote addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_creatNote setImage:img forState:UIControlStateNormal];
            [_bt_creatNote setImage:[UIImage imageNamed:@"btn_addtag_press"] forState:UIControlStateHighlighted];
//            [_bt_creatNote setTitle:@"更多"];
//            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
//            [_bt_creatNote setTitleColor:ColorBlue];
            [self.headview addSubview:_bt_creatNote];
            [_bt_creatNote changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_creatNote);
        }
        
        if (!_bt_date) {
            UIImage *img= [UIImage imageNamed:@"btn_date_def"];
            _bt_date = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_bt_creatNote.frame)-img.size.width/2, 0, img.size.width/2, img.size.height/2)];
            _bt_date.backgroundColor=[UIColor clearColor];
            _bt_date.tag=-7;
            [_bt_date addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_date setImage:img forState:UIControlStateNormal];
            [_bt_date setImage:[UIImage imageNamed:@"btn_date_press"] forState:UIControlStateHighlighted];
            //            [_bt_creatNote setTitle:@"更多"];
            //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
            //            [_bt_creatNote setTitleColor:ColorBlue];
            [self.headview addSubview:_bt_date];
            [_bt_date changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_date);
        }
        
        if (self.b_isAutoRefreshTbvInViewWillAppear) {
            {//HTTP请求,笔记列表
                MagicRequest *request = [DYBHttpMethod notes_listByKeywords:@"" tagid:@"" favorite:((_tbv_dropDown.row==0)?(@"0"):(@"1")) page:@"1" num:@"10" searchmonth:@"" delnum:@""  isAlert:YES receive:self];
                [request setTag:1];
            }
            self.b_isAutoRefreshTbvInViewWillAppear=NO;
        }
        
//        if (_d_toBeRefreshCell) {
//            int i=0;
//            for (noteModel *model in [_tbvView DataSourceArray]) {
//                if ([model.nid isEqualToString:[_d_toBeRefreshCell objectForKey:@"nid"]]) {
//                    model.favorite=[_d_toBeRefreshCell objectForKey:@"favorite"];
//                    
//                    DYBCellForNotes *cell=[[_tbvView CellArray] objectAtIndex:i];
//                    [cell changeStar:[model.favorite intValue]];
//                    break;
//                }
//                i++;
//            }
//            
//            RELEASE(_d_toBeRefreshCell);
//        }
        
        if (![[NSUserDefaults standardUserDefaults] stringForKey:@"DYBMyNotesViewController_DYBGuideView"] || [[[NSUserDefaults standardUserDefaults] stringForKey:@"DYBMyNotesViewController_DYBGuideView"] intValue]==0) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DYBMyNotesViewController_DYBGuideView"];
            
            {
                DYBGuideView *guideV=[[DYBGuideView alloc]initWithFrame:self.view.frame];
                guideV.AddImgByName(@"noteteaching02",@"noteteaching01",nil);
                [self.drNavigationController.view addSubview:guideV];
                RELEASE(guideV);
            }
        }

        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
//        RELEASEDICTARRAYOBJ(_muA_favoriteNoteData);
//        RELEASEDICTARRAYOBJ(_muA_AllNoteData);

    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        REMOVEFROMSUPERVIEW(_tbvView);
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

#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        DYBUITabbarViewController *dync = [DYBUITabbarViewController sharedInstace];
        [dync scrollMainView:1];
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
        if (model.type==0) {
            DYBNoteDetailViewController *vc = [[DYBNoteDetailViewController alloc] init];
            
            vc.str_nid=model.nid;
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
        }
        
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        MagicUITableView *tableView = ((DYBVariableTbvView *)[signal source]).tbv;
        {//HTTP请求
            MagicRequest *request = [DYBHttpMethod notes_listByKeywords:@"" tagid:@"" favorite:((_tbv_dropDown.row==0)?(@"0"):(@"1")) page:[NSString stringWithFormat:@"%d",++tableView._page ]num:[NSString stringWithFormat:@"%d",tableView.i_pageNums ] searchmonth:@"" delnum:[NSString stringWithFormat:@"%d",delnum]  isAlert:YES receive:self];
            [request setTag:2];
        }
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        MagicUITableView *tableView = ((DYBVariableTbvView *)[signal source]).tbv;
        
        {//HTTP请求,笔记列表
            MagicRequest *request = [DYBHttpMethod notes_listByKeywords:@"" tagid:@"" favorite:((_tbv_dropDown.row==0)?(@"0"):(@"1")) page:[NSString stringWithFormat:@"%d",tableView._page=1 ] num:[NSString stringWithFormat:@"%d",tableView.i_pageNums ] searchmonth:_str_CalendarContent delnum:@"" isAlert:YES receive:self];
            [request setTag:1];
            delnum=0;
        }
        
    }
    
    else if ([signal is:[MagicUITableView TABLESECTIONINDEXTITLESFORTABLEVIEW]])//右侧索引列表
    {

    }else if ([signal is:[MagicUITableView TABLESECTIONFORSECTIONINDEXTITLE]])//点击右测是索引列表上的某个字母时回调,参数index和title是 右侧索引列表上被点击的字母在 索引列表的下标和名字,返回被点击的字母对应的section的下标
    {
      
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
        [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [[DYBUITabbarViewController sharedInstace] hideTabBar:NO animated:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){//点击事件
        
        [self cancelPagePicker];
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
        //        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
        [self changeTbv];
        
    }else if ([signal is:[MagicUISearchBar SEARCH]]){//按下搜索按钮
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
        {//HTTP请求
            MagicRequest *request = [DYBHttpMethod notes_listByKeywords:search.text tagid:@"" favorite:@"" page:[NSString stringWithFormat:@"%d",_tbvView.tbv._page ]num:[NSString stringWithFormat:@"%d",_tbvView.tbv.i_pageNums ] searchmonth:@"" delnum:@"" isAlert:YES receive:self];
            [request setTag:1];
        }
        
    }else if ([signal is:[MagicUISearchBar CHANGEWORD]]){//内容改变
        NSString *str=(NSString *)signal.object;
        MagicUISearchBar *search=(MagicUISearchBar *)signal.source;
        
        if ([str length] == 0) {//删除完search里的内容
            //            if (!_tbv_mayKnow.hidden) {
            //                [_tbv_mayKnow release_muA_differHeightCellView];
            //                [_tbv_mayKnow resetSectionData];
            //                [_tbv_mayKnow reloadData:YES];
            //            }else{
            //                [_tbv_nearBy release_muA_differHeightCellView];
            //                [_tbv_nearBy resetSectionData];
            //                [_tbv_nearBy reloadData:YES];
            //            }
            return;
        }
        
        //        [search sendViewSignal:[MagicUISearchBar SEARCHING] withObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"searchContent",((!_tbv_mayKnow.hidden)?(_tbv_mayKnow):(_tbv_nearBy)),@"tbv", nil]];
        
        
    }else if ([signal is:[MagicUISearchBar SEARCHING]]){
        
    }
}


#pragma mark- 按钮信号
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
                    
                    if (!_tbv_dropDown) {
                        NSArray *arrBtnLable =[[NSArray alloc] initWithObjects:@"所有笔记", @"星标笔记",nil] ;
                        _tbv_dropDown = [[DYBMenuView alloc]initWithData:arrBtnLable selectRow:nSelRow];
                        [_tbv_dropDown setHidden:YES];
                        //                        [self.view insertSubview:_tbv_dropDown belowSubview:self.headview];
                        
                        [self.view addSubview:_tbv_dropDown];
                    }
                    
                    if (bPullDown) {
                        //            [_tabMenu setFrame:CGRectMake(120, 44-CGRectGetHeight(_tabMenu.frame), 100, CGRectGetHeight(_tabMenu.frame))];
                        //            [_tabMenu setHidden:YES];
                        
                        [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:self from:self target:_tbv_dropDown];
                    }else{
                        //            [_tabMenu setFrame:CGRectMake(120, 44, 100, CGRectGetHeight(_tabMenu.frame))];
                        //            [_tabMenu setHidden:NO];
                        
                        [self sendViewSignal:[DYBMenuView MENUDOWN] withObject:self from:self target:_tbv_dropDown];
                    }
                    
                    
                    
                    _tbv_dropDown.bPullDown = !bPullDown;
                    
                }
                    break;
                    
                case -2://新建笔记
                {
                    DYBNoteDetailViewController *vc = [[DYBNoteDetailViewController alloc] init];                    
                    [self.drNavigationController pushViewController:vc animated:YES];
                    vc.isEditing=YES;

                    RELEASE(vc);
                }
                    break;
                case -3://删除笔记
                {
                     NSIndexPath *index=(NSIndexPath *)signal.object;
                    
                  DYBDataBankShotView *delShotVeiw = [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要删除吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",0]];
                    delShotVeiw.indexPath = index;
                }
                    break;
                case -4://星标
                {
                    NSIndexPath *index=(NSIndexPath *)signal.object;
                    _tbvView.tbv.indexAfterRequest=index;
                    noteModel *model=[_tbvView.tbv.muA_singelSectionData objectAtIndex:index.row];
                    
                    DYBCellForNotes *cell=[[_tbvView CellArray] objectAtIndex:index.row];
                    [cell resetContentView];

                    if ([model.favorite intValue]==0) {//HTTP请求,收藏
                        MagicRequest *request = [DYBHttpMethod notes_addfavorite:model.nid isAlert:YES receive:self];
                        [request setTag:3];
                    }else{
                        MagicRequest *request = [DYBHttpMethod notes_delfavorite:model.nid isAlert:YES receive:self];
                        [request setTag:4];
                    }
                }
                    break;
                case -5://转存
                {
                    NSIndexPath *index=(NSIndexPath *)signal.object;
                    
                    noteModel *model=[_tbvView.tbv.muA_singelSectionData objectAtIndex:index.row];

                    if (SHARED.currentUserSetting.notesSaveForPush) {//删除原笔记
                        DYBDataBankShotView *delShotVeiw = [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"转存至资料库，原笔记将自动删除" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",0]];
                        delShotVeiw.indexPath = index;
                        delShotVeiw.tag=-1;
                    }else{
                    _tbvView.tbv.indexAfterRequest=index;
                    noteModel *model=[_tbvView.tbv.muA_singelSectionData objectAtIndex:index.row];

                    DYBCellForNotes *cell=[[_tbvView CellArray] objectAtIndex:index.row];
                    [cell resetContentView];

                    {//HTTP请求
                        MagicRequest *request = [DYBHttpMethod notes_dumpnote:model.nid del:((SHARED.currentUserSetting.notesSaveForPush)?(@"1"):(@"2")) isAlert:YES receive:self];
                        [request setTag:6];
                    }
                    }
                    
                }
                    break;
                case -6://共享
                {
                    NSIndexPath *index=(NSIndexPath *)signal.object;
                    if (_tbvView.tbv.muA_singelSectionData.count>index.row) {
                        noteModel *model=[_tbvView.tbv.muA_singelSectionData objectAtIndex:index.row];

                        
                        DYBSelectContactViewController *classM = [[DYBSelectContactViewController alloc]init];
                        classM.nid=model.nid;
                        classM.bEnterDataBank=YES;
                        //                    classM.docAddr = [_dictFileInfo objectForKey:@"file_path"];
                        [self.drNavigationController pushViewController:classM animated:YES];
                        
                        double delayInSeconds = .3;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            DYBCellForNotes *cell=[[_tbvView CellArray] objectAtIndex:index.row];
                            [cell resetContentView];
                        });
                        
                        RELEASE(classM);
                    }
                }
                    break;
                    
                case k_tag_fadeBt://取消search的背景按钮
                {
                    if ([_search cancelSearch]) {
                        [_search sendViewSignal:[MagicUISearchBar CANCEL] withObject:_search];
                        
                    }
                    
                }
                    break;
                case -7://日历
                {
                    [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];
                    
                    NSDateComponents *date=[NSString getDateComponentsByNow];
                    
                    _pickerView = [[DYBPagePickerView alloc] initWithdelegate:CGRectMake(0, 50, screenShows.size.width, 200) style:PagePickerViewWithNote delegate:self];
                    [_pickerView showInView:self.view initString:[NSString stringWithFormat:@"%d-%d",date.year,date.month]];
                }
                    break;
                case k_tag_releaseBT:
                case k_tag_OKBT:
                {
                    if (bt.tag==k_tag_OKBT) {//HTTP请求,笔记列表
                        
                        MagicRequest *request = [DYBHttpMethod notes_listByKeywords:@"" tagid:@"" favorite:((_tbv_dropDown.row==0)?(@"0"):(@"1")) page:@"1" num:@"10" searchmonth:_str_CalendarContent=[_pickerView result] delnum:@"" isAlert:YES receive:self];
                        [request setTag:1];
//                        _isCalendar=YES;
                    }
                    
                    [_pickerView releaseSelf];
                    
                    [[DYBUITabbarViewController sharedInstace] hideTabBar:NO animated:YES];

                }
                    break;
                case -8://取消日历筛选
                {
                    {//HTTP请求,笔记列表
                        MagicRequest *request = [DYBHttpMethod notes_listByKeywords:@"" tagid:@"" favorite:((_tbv_dropDown.row==0)?(@"0"):(@"1")) page:[NSString stringWithFormat:@"%d",_tbvView.tbv._page=1 ] num:[NSString stringWithFormat:@"%d",_tbvView.tbv.i_pageNums ] searchmonth:_str_CalendarContent=@"" delnum:@"" isAlert:YES receive:self];
                        [request setTag:1];
                    }
                }
                    break;
                default:
                    break;
            }
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
                _tbvView.tbv.indexAfterRequest=[d valueForKeyPath:@"object.indexPath"];

                noteModel *model=[d valueForKeyPath:@"object.model"];
                if ([model.favorite intValue]==0) {//HTTP请求,收藏
                    MagicRequest *request = [DYBHttpMethod notes_addfavorite:model.nid isAlert:YES receive:self];
                    [request setTag:3];
                }else{
                    MagicRequest *request = [DYBHttpMethod notes_delfavorite:model.nid isAlert:YES receive:self];
                    [request setTag:4];
                }
            }
        break;
        }
    }
}


#pragma mark- 处理tbv切换
-(void)changeTbv
{
    [_search cancelSearch];
    
    if (_tbv_dropDown) {
        [self.headview setTitle:[_tbv_dropDown.arrMenu objectAtIndex:(_tbv_dropDown.row)]];
        [self.headview setTitleArrow];
    }
    
            {//HTTP请求,笔记列表
                MagicRequest *request = [DYBHttpMethod notes_listByKeywords:@"" tagid:@"" favorite:((_tbv_dropDown.row==0)?(@"0"):(@"1")) page:[NSString stringWithFormat:@"%d",_tbvView.tbv._page=1 ] num:[NSString stringWithFormat:@"%d",_tbvView.tbv.i_pageNums ] searchmonth:_str_CalendarContent=@""  delnum:@"" isAlert:YES receive:self];
                [request setTag:1];
            }
}

#pragma mark- DYBPullDownMenuView 信号
- (void)handleViewSignal_DYBDynamicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBDynamicViewController MENUSELECT]]) {
        
        [self.headview setTitle:[_tbv_dropDown.arrMenu objectAtIndex:_tbv_dropDown.row]];
        [self.headview setTitleArrow];

        [self changeTbv];
        
        [_bt_DropDown didTouchUpInside];
        
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

#pragma mark- 通知中心回调
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification is:[DYBNoteDetailViewController AutoRefreshTbvInViewWillAppear]]){
        if ([self.view window]) {//已显示
            {//HTTP请求,笔记列表
                MagicRequest *request = [DYBHttpMethod notes_listByKeywords:@"" tagid:@"" favorite:((_tbv_dropDown.row==0)?(@"0"):(@"1")) page:@"1" num:@"10" searchmonth:@"" delnum:@""  isAlert:YES receive:self];
                [request setTag:1];
            }
        }else{
            self.b_isAutoRefreshTbvInViewWillAppear=YES;
            _str_CalendarContent=nil;
        }
        

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
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
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
                    
                    }
                    
                    int month=-1,day=-1,index=0;
                    NSMutableArray *arr=nil;
                    for (NSDictionary *d in list) {
                        noteModel *model = [noteModel JSONReflection:d];
                        
                        if (_str_CalendarContent && ![_str_CalendarContent isEqualToString:@""]) {//只要请求日历,就加一个显示 @"以下是*月之前的所有笔记"
//                            NSArray *arr=[_str_CalendarContent separateStrToArrayBySeparaterChar:@"-"];
//                            if (([[arr objectAtIndex:0] intValue]!=[NSString getDateComponentsByTimeStamp:[model.create_time intValue]].year) || ([[arr objectAtIndex:1] intValue]!=[NSString getDateComponentsByTimeStamp:[model.create_time intValue]].month))
                            {//请求的年月和返回的第一个model的年月不一样
                                noteModel *temp=[[noteModel alloc]init];
                                temp.create_time=model.create_time;
                                temp.type=-2;
                                temp.str_CalendarContent=_str_CalendarContent;
                                temp.nid=model.nid;
                                temp.cellH=40;
                                [_tbvView addDataSource:temp];//添加"以下是*月之前的所有笔记cell的model
                                RELEASE(temp);
                                _str_CalendarContent=nil;
                            }
                            
//                            _isCalendar=NO;
                        }
                        
                        if([NSString getDateComponentsByTimeStamp:[model.create_time intValue]].month!=month){  //如果前一个model的月份和此model月份不一样,数据源里要先加一个显示年月份的model,再加此model,已和cell的顺序一致
                            month=[NSString getDateComponentsByTimeStamp:[model.create_time intValue]].month;
                            noteModel *temp=[[noteModel alloc]init];
                            temp.create_time=model.create_time;
                            temp.type=-1;
                            temp.nid=model.nid;
                            temp.cellH=30;
                            [_tbvView addDataSource:temp];//添加月份cell的model
                            
                            RELEASE(temp);
                            
                            [_tbvView addDataSource:model];//添加笔记cell的model
                            model.cellH=140;
                            
                        }else{
                            [_tbvView addDataSource:model];//添加笔记cell的model
                            model.cellH=140;
                        
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
                        
                        {
                            
                            [_tbvView releaseCell];
                            [_tbvView releaseDataSource];
                            [_tbvView creatTbv];
                        }
                        
                        if (_str_CalendarContent && ![_str_CalendarContent isEqualToString:@""]) {//未请求到日历数据
                            noteModel *temp=[[noteModel alloc]init];
                            temp.type=-3;
                            temp.str_CalendarContent=_str_CalendarContent;
                            temp.cellH=40;
                            [_tbvView addDataSource:temp];//添加月份cell的model
                            RELEASE(temp);
                        }
                        [_tbvView reloadData:YES];
                    }
                    
                }
                
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                if (_search.b_isSearching) {
                    [self initNoDataView:@"   没有搜到笔记..."];
                }else{
                    [self initNoDataView:@"   一条笔记也没有\n请猛戳右上角的加号"];
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

                            RELEASE(temp);

                            [_tbvView addDataSource:model];//添加笔记cell的model
                            model.cellH=140;
                        }else{
                            [_tbvView addDataSource:model];//添加笔记cell的model
                            model.cellH=140;

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
            case 3://收藏
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功
//
                        DYBCellForNotes *cell=[_tbvView.tbv._muA_differHeightCellView objectAtIndex: _tbvView.tbv.indexAfterRequest.row];
                        [cell changeStar:[[response.data objectForKey:@"result"] intValue]];
                        
                        noteModel *model=[_tbvView.tbv.muA_singelSectionData objectAtIndex: _tbvView.tbv.indexAfterRequest.row];
                        model.favorite=[response.data objectForKey:@"result"];
                        
                        [DYBShareinstaceDelegate loadFinishAlertView:@"收藏成功" target:self];
                    }
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                 _tbvView.tbv.indexAfterRequest=nil;
                
                //                [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                
            }
                break;
            case 4://取消收藏
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功
                        //
                        DYBCellForNotes *cell=[_tbvView.tbv._muA_differHeightCellView objectAtIndex: _tbvView.tbv.indexAfterRequest.row];
                        [cell changeStar:0];
                        
                        noteModel *model=[_tbvView.tbv.muA_singelSectionData objectAtIndex: _tbvView.tbv.indexAfterRequest.row];
                        model.favorite=0;
                    }
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                 _tbvView.tbv.indexAfterRequest=nil;
                
                //                [_tbv_friends_myConcern_RecentContacts reloadData:YES];
                
            }
                break;
            case 5://删除笔记
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功
                        [_tbvView.tbv.muA_singelSectionData removeObjectAtIndex:_tbvView.tbv.indexAfterRequest.row];//删数据源
                        
                        [_tbvView.tbv._muA_differHeightCellView removeObjectAtIndex:_tbvView.tbv.indexAfterRequest.row];
                        
                        //                        [_tbv beginUpdates];
                        [_tbvView.tbv deleteRowsAtIndexPaths:[NSArray arrayWithObject:_tbvView.tbv.indexAfterRequest] withRowAnimation:UITableViewRowAnimationFade];
                        //                        [_tbv endUpdates];
                        
                        [_tbvView releaseCell];
                        
                        if (_tbvView.dataSourceCount==1) {//删完数据源
                            
                            _tbvView.tbv.indexAfterRequest=Nil;

                            {//HTTP请求,笔记列表
                                MagicRequest *request = [DYBHttpMethod notes_listByKeywords:@"" tagid:@"" favorite:((_tbv_dropDown.row==0)?(@"0"):(@"1")) page:[NSString stringWithFormat:@"%d",_tbvView.tbv._page=1 ] num:[NSString stringWithFormat:@"%d",_tbvView.tbv.i_pageNums ] searchmonth:_str_CalendarContent delnum:@"" isAlert:YES receive:self];
                                [request setTag:1];
                                delnum=0;
                            }
                            return;
                        }
                        [_tbvView reloadData:YES];
                        
                        //                        [_tbv._selectIndex_now release];
                        _tbvView.tbv.indexAfterRequest=Nil;
                        
                        delnum++;
                    }
                }else if ([response response] ==khttpfailCode){
                    {
                        MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                        [pop setDelegate:self];
                        [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                        [pop setText:@"删除失败"];
                        [pop alertViewAutoHidden:.5f isRelease:YES];
                    }
                }
                
                _tbvView.tbv.indexAfterRequest=nil;
            }
                break;
            case 6://转存
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功

                        if (!SHARED.currentUserSetting) {
                            DLogInfo(@"");
                        }
                        
                        if (!SHARED.currentUserSetting.notesSaveForPush) {
                            DLogInfo(@"");
                        }
                        if (SHARED.currentUserSetting.notesSaveForPush && SHARED.currentUserSetting) {//删除原笔迹
//                            [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"成功转存至资料库,原笔记已自动删除" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
                            
                            {
                                MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                                [pop setDelegate:self];
                                [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                                [pop setText:@"成功转存至资料库,原笔记已自动删除"];
                                [pop alertViewAutoHidden:.5f isRelease:YES];
                            }
                            
                            {
                                [_tbvView.tbv.muA_singelSectionData removeObjectAtIndex:_tbvView.tbv.indexAfterRequest.row];//删数据源
                                
                                [_tbvView.tbv._muA_differHeightCellView removeObjectAtIndex:_tbvView.tbv.indexAfterRequest.row];
                                
                                //                        [_tbv beginUpdates];
                                [_tbvView.tbv deleteRowsAtIndexPaths:[NSArray arrayWithObject:_tbvView.tbv.indexAfterRequest] withRowAnimation:UITableViewRowAnimationFade];
                                //                        [_tbv endUpdates];
                                
                                [_tbvView releaseCell];
                                [_tbvView reloadData:YES];
                                
                                //                        [_tbv._selectIndex_now release];
                                _tbvView.tbv.indexAfterRequest=Nil;
                                
                                delnum++;

                            }
                        }else{

                            {
                                MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                                [pop setDelegate:self];
                                [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                                [pop setText:@"成功转存至资料库,原笔记已保留"];
                                [pop alertViewAutoHidden:.5f isRelease:YES];
                            }

                        }
                        return;
                    }
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                {
                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                    [pop setDelegate:self];
                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                    [pop setText:@"转存失败"];
                    [pop alertViewAutoHidden:.5f isRelease:YES];
                }
            }
                break;
            case 7://
//            
                break;
            default:
                break;
        }
    }
}

#pragma mark- 二次确认框
-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    DLogInfo(@"ddddd");
    if ([signal is:[DYBDataBankShotView LEFT]]) {
        
    }
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        
        DYBDataBankShotView *source = (DYBDataBankShotView *)[signal source];
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        switch (source.tag) {
            case -1://转存并删除源笔记
            {
                NSIndexPath *index=((DYBDataBankShotView *)source).indexPath;
                    _tbvView.tbv.indexAfterRequest=index;
                    noteModel *model=[_tbvView.tbv.muA_singelSectionData objectAtIndex:index.row];

                    DYBCellForNotes *cell=[[_tbvView CellArray] objectAtIndex:index.row];
                    [cell resetContentView];

                    {//HTTP请求
                        MagicRequest *request = [DYBHttpMethod notes_dumpnote:model.nid del:((SHARED.currentUserSetting.notesSaveForPush)?(@"1"):(@"2")) isAlert:YES receive:self];
                        [request setTag:6];
                    }
                return;
            }
                break;
                
            default:
                break;
        }
        
        
//        NSString *text = [dict objectForKey:@"text"];
        NSString *type = [dict objectForKey:@"type"];
//        NSNumber *row = [dict objectForKey:@"rowNum"];
        switch ([type integerValue]) {
            case BTNTAG_DEL:{
                
                NSIndexPath *index=(NSIndexPath *)source.indexPath;
                _tbvView.tbv.indexAfterRequest=index;
                noteModel *model=[_tbvView.tbv.muA_singelSectionData objectAtIndex:index.row];
                
                {//HTTP请求
                    MagicRequest *request = [DYBHttpMethod notes_delnote:model.nid isAlert:YES receive:self];
                    [request setTag:5];
                }
            }
                break;

            default:
                break;
        }
    }
}


@end
