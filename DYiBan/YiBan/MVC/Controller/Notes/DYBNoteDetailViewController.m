//
//  DYBNoteDetailViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-10-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//


#import "DYBNoteDetailViewController.h"
#import "UIView+MagicCategory.h"
#import "UIView+Animations.h"
#import "DYBCustomLabel.h"
#import "Tag.h"
#import "NSString+Count.h"
#import "notesUserinfo.h"
#import "UserSettingMode.h"
#import "UIViewController+MagicCategory.h"
#import "DYBSelectContactViewController.h"
#import "DYBCellForNotesDetail.h"
#import "UITableView+property.h"
#import "NSObject+GCD.h"
#import "UIImage+MagicCategory.h"
#import "file_list.h"
#import "NSString+Count.h"
#import "SpeexCodec.h"
#import "DYBListSelViewController.h"
#import "tag_list_info.h"
#import "Magic_Device.h"
#import "DYBSelectContactViewController.h"
#import "UIView+MagicViewSignal.h"
#import "UIImage+MagicCategory.h"
#import "UITableViewCell+MagicCategory.h"
#import "NSObject+MagicDatabase.h"
#import "user.h"
#import "JSON.h"
#import "AVAudioPlayer+MagicCategory.h"
#import "UITextView+Property.h"
#import "NSObject+GCD.h"
#import "Magic_Device.h"
#import "DYBGuideView.h"
#import "NSObject+KVO.h"
#import "DYBTagNotesViewController.h"

@interface DYBNoteDetailViewController ()

@end

@implementation DYBNoteDetailViewController

DEF_SIGNAL(SELTAG)       //选择标签成功回调
DEF_SIGNAL(DELNOTE)

@synthesize str_nid=_str_nid,isEditing=_isEditing,str_favorite=_str_favorite,typeTop,userId,shareId;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
                
        [self observeNotification:[DYBPhotoEditorView DOSAVEIMAGE]];
        
        {//整体背景图
            UIImage *img=[UIImage imageNamed:@"bg_note_ip5"];
            UIImageView *imgV=[[UIImageView alloc]initWithFrame:self.view.bounds backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self.view Alignment:-1 contentMode:UIViewContentModeScaleAspectFill stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            RELEASE(imgV);
        }
        
        [self creatTbv];

        if(!_isEditing && _str_nid){//HTTP请求,笔记详情
            MagicRequest *request = [DYBHttpMethod notes_detail:_str_nid isAlert:YES receive:self];
            [request setTag:1];
        }
        
        {
            if (!_str_nid) {//新建笔记进来读取数据库里笔记表里的未编辑完成笔记那条数据
                self.DB.FROM(k_NoteListDateBase).WHERE(k_Note_NID, k_Note_EditingNoteName).GET();//判断表里是否有某条数据
                if ([self.DB.resultArray count] > 0)//有
                {
                    [self creatTbvData:[[[self.DB.resultArray objectAtIndex:0] objectForKey:k_Note_JsonStr] JSONValue]];
                    
                }
            }
        }

    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        self.rightButton.hidden=YES;
        
        [self.headview setTitle:((_isEditing)?((_str_nid)?(@"笔记编辑"):(@"新建笔记")):(@"笔记详情"))];
        [self backImgType:0];
        
        [self init_bt_Right];
        
        if (!_v_dropUp && !_isEditing) {//底部上拉view
            _v_dropUp=[[DYBBaseView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-30, CGRectGetWidth(self.view.frame), 230)];
            _v_dropUp._originFrame=CGRectMake(0, CGRectGetHeight(self.view.frame)-30, CGRectGetWidth(self.view.frame), 230);
            _v_dropUp.backgroundColor=ColorWhite;
            _v_dropUp.alpha=0.9;
            _v_dropUp.tag=1;
            [self.view addSubview:_v_dropUp];
            RELEASE(_v_dropUp);
            [_v_dropUp addSignal:[UIView TAP] object:nil target:nil];
            
        }
        
        if (!_str_nid) {
            if (![[NSUserDefaults standardUserDefaults] stringForKey:@"DYBNoteDetailViewController_DYBGuideView"] || [[[NSUserDefaults standardUserDefaults] stringForKey:@"DYBNoteDetailViewController_DYBGuideView"] intValue]==0) {
                
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DYBNoteDetailViewController_DYBGuideView"];
                
                {
                    DYBGuideView *guideV=[[DYBGuideView alloc]initWithFrame:self.view.frame];
                    guideV.AddImgByName(@"noteteaching03",nil);
                    [self.drNavigationController.view addSubview:guideV];
                    RELEASE(guideV);
                }
            }

        }
        
    }else if ([signal is:MagicViewController.WILL_DISAPPEAR]){
        if (![_str_favorite isEqualToString:_model.favorite]  && _str_favorite) {
            [self postNotification:[DYBNoteDetailViewController AutoRefreshTbvInViewWillAppear] withObject:/*[NSDictionary dictionaryWithObjectsAndKeys:_model.nid,@"nid",_model.favorite,@"favorite", nil]*/ nil userInfo:nil];
            
            for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
                if ([vc isKindOfClass:[DYBTagNotesViewController class]]) {
                    [self sendViewSignal:[DYBTagNotesViewController REFRESHTB] withObject:nil from:self target:(DYBTagNotesViewController *)vc];
                    break;
                }
            }
        }
        
        [self audioRecordeOver];
        
        [self stopAudioPlayer];
        
        [self cacheUnEdittedNote];


    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        RELEASEDICTARRAYOBJ(_muA_audioData);
        RELEASEDICTARRAYOBJ(_muA_audioView);
//        RELEASEDICTARRAYOBJ(_muA_fid);
        
        [self unobserveAllNotification];
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        REMOVEFROMSUPERVIEW(_tbvView);
        if (_model) {
            RELEASE(_model);
            _model=nil;
        }
    }
    
}

-(void)creatTbv{
    if (!_tbvView) {
        _tbvView=[[DYBVariableTbvView alloc]initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-kH_StateBar-self.headHeight) cellClass:[DYBCellForNotesDetail class]];
//        [_tbvView.tbv setTableViewType:DTableViewNomal];
        _tbvView.tbv.i_pageNums=10;
        [self.view addSubview:_tbvView];
        RELEASE(_tbvView);
        _tbv=_tbvView.tbv;
        
        {//tableFooterView
            UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tbv.frame), 50)];
            v.backgroundColor=[UIColor clearColor];
            _tbv.tableFooterView=v;
            RELEASE(v);
        }
    }
}

#pragma mark- 返回上一页
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self cacheUnEdittedNote];
        
        //        RELEASE(_tbv);
        _tbv=nil;
        
//        if (_model) {
//            RELEASE(_model);
//            _model=nil;
//        }
        
        if (_str_favorite) {
            RELEASE(_str_favorite);
        }
        
//        while ([self retainCount]>1) {
//            RELEASE(self);
//        }
        
//        for (UITableViewCell *cell in [_tbvView CellArray]) {
//            [self removeObserverObj:cell forKeyPath:@"isEditing"];
//            DLogInfo(@"");
//        }
        
//        [self dealloc_observer];
        
//        RELEASE(_tbvView.tbv);
        
        [self.drNavigationController popVCAnimated:YES];
    }
    
}

#pragma mark- 初始化时有标签
-(void)initWithTags:(NSArray *)tag_list_info
{//标签cell数据源
    noteModel *model1 = [[noteModel alloc]init];
    model1.type=-4;
    model1.taglist=tag_list_info;
    
    [[_tbvView DataSourceArray ] removeObjectAtIndex:0];
    [[_tbvView DataSourceArray ] insertObject:model1 atIndex:0];
    
    [_tbvView releaseCell];
    [_tbvView reloadData:YES];
    RELEASE(model1);
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
        
        if (indexPath.row==0 ) {
            
            [self setIsEditing:YES];
            
            noteModel *model=[[_tbvView DataSourceArray] objectAtIndex:0];
            
            NSMutableArray *muA=[[NSMutableArray alloc]initWithCapacity:1];
            
            for (NSDictionary *d in model.taglist) {
                if ([d isKindOfClass:[NSDictionary class]]) {
                    d=[tag_list_info JSONReflection:d];
                    [muA addObject:d];
                }else{
                    [muA addObject:d];
                }
            }

            DYBListSelViewController *vc = [[DYBListSelViewController alloc] initwithTagList:muA];
            
            RELEASE(muA);
            
            [self.drNavigationController pushViewController:vc animated:YES];
        }
        
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
       
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        MagicUITableView *tableView = ((DYBVariableTbvView *)[signal source]).tbv;

        [tableView reloadData:YES];

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
        
    }
}

#pragma mark- 只接受UITextView信号
- (void)handleViewSignal_MagicUITextView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITextView TEXTVIEWSHOULDBEGINEDITING]])//textViewShouldBeginEditing
    {
        NSMutableDictionary *muD = (NSMutableDictionary *)[signal object];
        MagicUITextView *textV=[muD objectForKey:@"textView"];
        
        if (_model && _model.user_id && ![_model.user_id isEqualToString:SHARED.curUser.userid]) {//他人笔记不能编辑
            return [signal returnNO];
        }
        
        [_tbvView.tbv setContentOffset:CGPointMake(0, 0) animated:YES];

        [self setIsEditing:YES];
        
        _textView=textV;
        
//        NSLog(@"_tbvView.tbv.contentOffset.y==============================%f",);
        
        return [signal returnYES];
        
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDBEGINEDITING]])//textViewDidBeginEditing
    {
        
        int i=0;
        for (UITableViewCell *cell in [_tbvView CellArray]) {
            if (i==1) {
                [(DYBCellForNotesDetail *)cell changeTextView:1];
            }else{
                cell.hidden=YES;
            }
            
            i++;
        }
        
        _tbvView.tbv.scrollEnabled=NO;
        
        [_tbvView reloadData:YES];
        
    }else  if ([signal is:[MagicUITextView TEXT_OVERFLOW]])//文字超长
    {
        [signal returnNO];
    }else  if ([signal is:[MagicUITextView TEXTVIEW]])//shouldChangeTextInRange
    {
        NSMutableDictionary *muD = (NSMutableDictionary *)[signal object];
        MagicUITextView *textV=[muD objectForKey:@"textView"];
        NSString *emString=[muD objectForKey:@"text"];
        
        if ([emString isEqualToString:@"\n"]) {//收键盘
            [signal returnNO];
//            [_textView setActive:NO];
            
            [self closeKeyBoard];
            
        }else if([NSString isContainsEmoji:emString]){//禁止表情
            [signal returnNO];
        }

    }
    else  if ([signal is:[MagicUITextView TEXTVIEWDIDCHANGE]])//textViewDidChange
    {
        
        NSMutableDictionary *muD = (NSMutableDictionary *)[signal object];
        MagicUITextView *textV=[muD objectForKey:@"textView"];
        
        ((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:1]).content=[textV.text TrimmingStringBywhitespaceCharacterSet];
        [textV freshLbTextLengthText:[NSString stringWithFormat:@"%d / %d",textV.text.length,textV.maxLength]];

        
    }
    
//    }
}

#pragma mark- 缓存未编辑完的笔记(只缓存最新的一份未编辑完的)
-(void)cacheUnEdittedNote
{
    if (!_str_nid && ([self couldAddnote]|| /*只有标签也缓存*/ ((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:0]).taglist.count>0)) {
        //创建所有账号公用的笔记数据缓存表
        self.DB.
        TABLE(k_NoteListDateBase).
        FIELD(@"id", @"INTEGER").PRIMARY_KEY().AUTO_INREMENT().
        FIELD(k_Note_UserID, @"TEXT").
        FIELD(k_Note_NID, @"TEXT").
        FIELD(k_Note_CreaTime, @"TEXT").
        FIELD(k_Note_isUpdatedToServer, @"TEXT").
        FIELD(k_Note_JsonStr, @"TEXT").
        CREATE_IF_NOT_EXISTS();
        
        noteModel *model=[[noteModel alloc]init];
        model.create_time=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        model.nid=k_Note_EditingNoteName;
        model.str_UserID=SHARED.curUser.userid;
        model.taglist=((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:0]).taglist;
        model.content=((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:1]).content;
        
        NSMutableArray *muA=[NSMutableArray arrayWithCapacity:10];
        for (file_list *file in [_tbvView DataSourceArray]) {
            if ([file isKindOfClass:[file_list class]] && ![muA containsObject:file]) {
//                if (file.img) {
//                    [[file.img saveToNSDataByCompressionQuality:1] writeToFile:file.str_filePath=[NSString cachePathForfileName:[NSString stringWithFormat:@"%p",file.img] fileType:@"ImageCache" dir:NSCachesDirectory] atomically:YES];//把img写到沙盒
//                    file.img=Nil;
//                    
//                }
                [muA addObject:file];
            }
        }
        model.file_list=muA;
        
        NSString *jsonStr=[model OJBTOJSON];
        
        self.DB.FROM(k_NoteListDateBase).WHERE(k_Note_NID, k_Note_EditingNoteName).GET();//判断表里是否有某条数据
        if ([self.DB.resultArray count] > 0)//有
        {
            self.DB.FROM(k_NoteListDateBase).SET(k_Note_CreaTime,[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]).SET(k_Note_NID,k_Note_EditingNoteName).SET(k_Note_JsonStr,jsonStr).UPDATE();
        }else
        {
            self.DB.FROM(k_NoteListDateBase).SET(k_Note_CreaTime,[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]).SET(k_Note_NID,k_Note_EditingNoteName).SET(k_Note_JsonStr,jsonStr).INSERT();
        }
    }
}

#pragma mark- 收起键盘
-(void)closeKeyBoard
{
    int i=0;
    for (UITableViewCell *cell in [_tbvView CellArray]) {
        if (i==1) {
            [(DYBCellForNotesDetail *)cell changeTextView:0];
        }else{
            cell.hidden=NO;
        }
        
        i++;
    }
    
    _tbvView.tbv.scrollEnabled=YES;
    
    [_tbvView reloadData:YES];
}

#pragma mark- 上传笔记前判断至少要有图片，音频，文字其中的一样,标签可以空。
-(BOOL)couldAddnote
{
    if (((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:1]).content && ![((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:1]).content isEqualToString:@""]) {
        return YES;
    }else if ([_tbvView DataSourceArray].count>2){
        return YES;
    }
    
    return NO;
}

#pragma mark- 进度条走完回调
- (void)handleViewSignal_DYBAudioProgressView:(MagicViewSignal *)signal
{
    if (([signal is:[DYBAudioProgressView LoadDown]])) {
//        _recodeTime++;
        _isSaveRecordData=YES;
        [self audioRecordeOver];
    }
}

#pragma mark- 录音完毕执行的操作
-(void)audioRecordeOver
{
    if ([_t_recodeTime isValid]) {
        [_t_recodeTime invalidate];
        RELEASE(_t_recodeTime);
        _t_recodeTime=nil;
    }
    
    [self changeSoundRecordingState:0];
    
    if(recorder){
        [recorder stop];
        [recorder release];
        recorder  = nil;
        //recorder释放后系统回调 audioRecorderDidFinishRecording 方法
        
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
                    if (_isEditing){
                        [self clickSaveBt];
                    }else{
                        [self clickMoreBt];
                    }

                }
                    break;
                case -10://转存到笔记
                {
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"确认要复制到我的笔记么" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_CANCELSHARE];
                }
                    break;
                case -11://修改共享
                {
                    DYBSelectContactViewController *classM = [[DYBSelectContactViewController alloc]init];
                    classM.nid=_str_nid;
                    classM.bEnterDataBank=YES;
                    [self.drNavigationController pushViewController:classM animated:YES];
                    RELEASE(classM);
                }
                    break;
                case -12://取消共享
                {
                    
                    DYBDataBankShotView *showView = [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"该笔记已经共享，取消将同时删除笔记！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_CANCELSHARE];
                    showView.tag = 2;
                

                }
                    break;
                case 1://编辑
                {
                    [self setIsEditing:YES];
                }
                    break;
                case 2://共享
                {
                    DYBSelectContactViewController *classM = [[DYBSelectContactViewController alloc]init];
                    classM.nid=_model.nid;
                    classM.bEnterDataBank=YES;
                    [self.drNavigationController pushViewController:classM animated:YES];
                    RELEASE(classM);
                }
                    break;
                case 3://转存到资料库
                {
                    if (SHARED.currentUserSetting.notesSaveForPush) {//删除原笔记
                        DYBDataBankShotView *delShotVeiw = [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"转存至资料库，原笔记将自动删除" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",0]];
                        delShotVeiw.tag=-2;
                    }else{
                        {//HTTP请求
                            MagicRequest *request = [DYBHttpMethod notes_dumpnote:_model.nid del:((SHARED.currentUserSetting.notesSaveForPush)?(@"1"):(@"2")) isAlert:YES receive:self];
                            [request setTag:2];
                        }
                    }
                    
                    
                }
                    break;
                case 4://星标
                {
                    
                    if ([_model.favorite intValue]==0) {//HTTP请求,收藏
                        MagicRequest *request = [DYBHttpMethod notes_addfavorite:_model.nid isAlert:YES receive:self];
                        [request setTag:3];
                    }else{
                        MagicRequest *request = [DYBHttpMethod notes_delfavorite:_model.nid isAlert:YES receive:self];
                        [request setTag:4];
                    }
                }
                    break;
                case 5://删除笔记
                {
                    
                   [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要删除吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",0]];
                    
//                    {//HTTP请求
//                        MagicRequest *request = [DYBHttpMethod notes_delnote:_model.nid isAlert:YES receive:self];
//                        [request setTag:5];
//                    }
                }
                    break;
                case 6://添加标签
                {
                    
                }
                    break;
                case 7://删除语音或图片
                {
//                    file_list *index=(NSIndexPath *)signal.object;
                    file_list *model=[signal.object valueForKeyPath:@"model"];
                    if (model.fid) {//有文件ID的文件都是服务器发来的,删除时调 notes_delfile 接口
                        {//HTTP请求
                            MagicRequest *request = [DYBHttpMethod notes_delfile:model.fid isAlert:YES receive:self];
                            [request setTag:10];
                        }
                    }
        //                    [[_tbvView DataSourceArray] removeObjectAtIndex:index.row];
                    [model.location deleteFile];
                    
//                    if ( _audioPlayer && [model.file_type isEqualToString:@"2"] ) { // 播放器停止播放
//                        [_audioPlayer stop];
//                        [_audioPlayer release];
//                        _audioPlayer = nil;
//                    }
                    
                    if ([model.file_type isEqualToString:@"2"]) {
                        [self stopAudioPlayer];
                    }
                    
                    [[_tbvView DataSourceArray] removeObject:model];
                    
                    DYBCellForNotesDetail *cell=[signal.object valueForKeyPath:@"cell"];
                    NSIndexPath *index=cell.index;
                    [[_tbvView CellArray] removeObject:cell];
                    
//                    [[_tbvView CellArray] removeObjectAtIndex:index.row];
                    
                    //                        [_tbv beginUpdates];
                    [_tbvView.tbv deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
                    //                        [_tbv endUpdates];
                    
                    [_tbvView releaseCell];
                    [_tbvView reloadData:YES];
                }
                    break;
                case 8://语音
                {
                    int i=0;
                    for (id model in [_tbvView DataSourceArray]) {
                        if ([model isKindOfClass:[file_list class]] && ((file_list *)model).type==-6) {//音频model
                            i++;
                        }
                    }
                    
                    if (i>2) {
                        MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                        [pop setDelegate:self];
                        [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                        [pop setText:@"您最多能添加3个音频文件"];
                        [pop alertViewAutoHidden:.5f isRelease:YES];
                        break;
                    }
                    
                    [self changeSoundRecordingState:1];
                }
                    break;
                case 9://拍照
                {
                    int i=0;
                    for (id model in [_tbvView DataSourceArray]) {
                        if ([model isKindOfClass:[file_list class]] && ((file_list *)model).type==-7) {//相册model
                            i++;
                        }
                    }
                    
                    if (i>5) {
                        MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                        [pop setDelegate:self];
                        [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                        [pop setText:@"您最多能添加6张图片"];
                        [pop alertViewAutoHidden:.5f isRelease:YES];
                        break;
                    }
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [self.drNavigationController presentModalViewController:imagePicker animated:YES];
                    [imagePicker release];
                }
                    break;
                case 10://相册
                {
                    int i=0;
                    for (id model in [_tbvView DataSourceArray]) {
                        if ([model isKindOfClass:[file_list class]] && ((file_list *)model).type==-7) {//相册model
                            i++;
                        }
                    }
                    if (i>5) {
                        MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                        [pop setDelegate:self];
                        [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                        [pop setText:@"您最多能添加6张图片"];
                        [pop alertViewAutoHidden:.5f isRelease:YES];
                        break;
                    }
                    
                    DYBImagePickerController *_imgPicker = [[DYBImagePickerController alloc] init];
                    [_imgPicker setFather:self];
                    _imgPicker.delegate = self;
                    _imgPicker.allowsMultipleSelection = YES;//是否是多图上传
                    _imgPicker.limitsMaximumNumberOfSelection = YES;// 最大图片数量
                    _imgPicker.maximumNumberOfSelection = 6 - i;
                    [self.drNavigationController pushViewController:_imgPicker animated:YES];
                    RELEASE(_imgPicker);
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}

#pragma mark- 点右上角保存按钮
-(void)clickSaveBt
{//保存上传笔记
    if (_textView.isFirstResponder) {//收起键盘
        [self closeKeyBoard];
        return;
    }
    
    [self audioRecordeOver];
    
    if (![self couldAddnote]) {
        {
            MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
            [pop setDelegate:self];
            [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
            [pop setText:@"请添加笔记内容"];
            [pop alertViewAutoHidden:.5f isRelease:YES];
        }
        return;
    }
    
    if ([[MagicDevice networkType] isEqualToString:@"-1"]) {
        {
            MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
            [pop setDelegate:self];
            [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
            [pop setText:@"请检测网络"];
            [pop alertViewAutoHidden:.5f isRelease:YES];
        }
        return;
    }
    
    if (![[MagicDevice networkType] isEqualToString:@"wifi"] ) {
         DYBDataBankShotView *delShotVeiw = [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"2G/3G网络同步会消耗你的数据流量，是否继续操作？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",0]];
        delShotVeiw.tag=-1;
        return;
    }
    
    [self addNewNoteOrEditNote];
    
}

#pragma mark- 添加新笔记或修改笔记
-(void)addNewNoteOrEditNote
{
    if (!_str_nid) {//添加新笔记
        
//        if (![self couldAddnote]) {
//            {
//                MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
//                [pop setDelegate:self];
//                [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
//                [pop setText:@"请添加笔记内容"];
//                [pop alertViewAutoHidden:.5f isRelease:YES];
//            }
//            return;
//        }
        
        NSString *str_tagid=@"";
        for (tag_list_info *model in ((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:0]).taglist) {
            if (![model isKindOfClass:[tag_list_info class]]) {
                model=[tag_list_info JSONReflection:model];
            }
            if ([str_tagid isEqualToString:@""]) {
                str_tagid=[str_tagid stringByAppendingFormat:@"%@",model.tag_id];
            }else{
                str_tagid=[str_tagid stringByAppendingFormat:@",%@",model.tag_id];
            }
        }
        
        {//HTTP请求,添加新笔记,获取笔记id
            MagicRequest *request = [DYBHttpMethod notes_addnoteBylng:@"" lat:@"" address:@"" title:@"" content:((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:1]).content tagid:(([str_tagid isEqualToString:@""])?(@""):(str_tagid)) isAlert:YES receive:self];
            [request setTag:6];
            
        }
        
        
    }else{//修改笔记
        
//        if (![self couldAddnote]) {
//            {
//                MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
//                [pop setDelegate:self];
//                [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
//                [pop setText:@"请添加笔记内容"];
//                [pop alertViewAutoHidden:.5f isRelease:YES];
//            }
//            return;
//        }
        
        NSString *str_tagid=@"";
        for (tag_list_info *model in ((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:0]).taglist) {
            if (![model isKindOfClass:[tag_list_info class]]) {
                model=[tag_list_info JSONReflection:model];
            }
            if ([str_tagid isEqualToString:@""]) {
                str_tagid=[str_tagid stringByAppendingFormat:@"%@",model.tag_id];
            }else{
                str_tagid=[str_tagid stringByAppendingFormat:@",%@",model.tag_id];
            }
        }
        
        {//HTTP请求,笔记修改
            MagicRequest *request = [DYBHttpMethod notes_editnote:_str_nid content:((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:1]).content tagid:str_tagid isAlert:YES receive:self];
            [request setTag:11];
        }
        
        [self upLoadFile:11];

        
//        {//文件上传
//            NSString *duration=@"";
//            int i=0;
//            for (id ob in _tbvView.DataSourceArray) {
//                if ([ob isKindOfClass:[file_list class]] /*&& !((file_list *)ob).fid*/) {
//                    if (((file_list *)ob).type==-6) {//音频modle
//                        duration=[duration stringByAppendingFormat:@"%@,",((file_list *)ob).duration];
//                    }else{//图片model
//                        if (i==_tbvView.DataSourceArray.count-1) {
//                            duration=[duration stringByAppendingString:@"0"];
//                        }else{
//                            duration=[duration stringByAppendingString:@"0,"];
//                        }
//                    }
//                }
//                i++;
//            }
//            
//            if (![duration isEqualToString:@""]) {
//                duration=[duration substringToIndex:duration.length-1];
//            }
//            
//            if (![duration isEqualToString:@""]){//上传文件
//                
//                NSMutableArray *muA_arr = [NSMutableArray arrayWithCapacity:1];
//                
//                NSMutableDictionary *mud=[NSMutableDictionary dictionaryWithCapacity:1];
//                
//                for (id ob in _tbvView.DataSourceArray) {
//                    if ([ob isKindOfClass:[file_list class]] && !((file_list *)ob).fid ) {
//                        
//                        if (((file_list *)ob).type==-6) {//音频
//                            
//                            NSMutableDictionary *mud_audio=[NSMutableDictionary dictionaryWithCapacity:1];
//                            [mud_audio setValue:[NSData dataWithContentsOfFile:((file_list *)ob).location] forKey:POSTDFILEDATA];
//                            [mud_audio setValue:[NSString stringWithFormat:@"%@.spx",[[((file_list *)ob).location separateStrToArrayBySeparaterChar:@"/"] lastObject]] forKey:POSTDATAFILENAME];
//                            [mud_audio setValue:POSTSPX forKey:POSTDATAFILETYPE];
//                            
//                            [muA_arr addObject:mud_audio];
//                            
//                        }else if (((file_list *)ob).type==-7)//图片
//                        {
//                            //                                        NSData *data=[((file_list *)ob).img saveToNSDataByCompressionQuality:1];
//                            //                                        [muA_img addObject:data];
//                            
//                            NSMutableDictionary *muD=[NSMutableDictionary dictionaryWithCapacity:2];
//                            
//                            [muD setValue:[NSData dataWithContentsOfFile:((file_list *)ob).location] forKey:POSTDFILEDATA];
//                            [muD setValue:[NSString stringWithFormat:@"%@.img",[[((file_list *)ob).location separateStrToArrayBySeparaterChar:@"/"] lastObject]] forKey:POSTDATAFILENAME];
//                            [muD setValue:POSTIMG forKey:POSTDATAFILETYPE];
//                            
//                            [muA_arr addObject:muD];
//                        }
//                    }
//                }
//                
//                [mud setObject:muA_arr forKey:POSTFILE];
//                
//                NSMutableDictionary *muD2 = [DYBHttpInterface notes_uploadfile:_str_nid duration:duration];
//                DYBRequest *request = AUTORELEASE([[DYBRequest alloc] init]);
//                MagicRequest *dre = [request DYBPOSTFILE:muD2 isAlert:YES receive:self fileData:mud];
//                dre.tag =  11;
//                
//            }
//        }
        
    }
    
    _bt_Right.enabled=NO;

}

#pragma mark- 点右上角更多按钮
-(void)clickMoreBt
{
    
    if (!_v_dropDown) {
        
        _v_dropDown=[[DYBBaseView alloc]initWithFrame:CGRectMake(0, -205, CGRectGetWidth(self.view.frame), 205)];
        _v_dropDown._originFrame=CGRectMake(0, -205, CGRectGetWidth(self.view.frame), 205);
        _v_dropDown.backgroundColor=ColorWhite;
        _v_dropDown.alpha=0.9;
        
        if (typeTop == 1) {
            
            if (!_bt_moveToDataBase) {
                UIImage *img= [UIImage imageNamed:@"note_tomynote_def"];
                _bt_moveToDataBase = [[MagicUIButton alloc] initWithFrame:CGRectMake((320-img.size.width/2)/2 , (205-img.size.height/2)/2, img.size.width/2, img.size.height/2)];
                _bt_moveToDataBase.backgroundColor=[UIColor clearColor];
                _bt_moveToDataBase.tag=-10;
                [_bt_moveToDataBase addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_moveToDataBase setImage:img forState:UIControlStateNormal];
                [_bt_moveToDataBase setImage:img forState:UIControlStateHighlighted];
                //            [_bt_creatNote setTitle:@"更多"];
                //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
                //            [_bt_creatNote setTitleColor:ColorBlue];
                [_v_dropDown addSubview:_bt_moveToDataBase];
                //                            [_bt_Right changePosInSuperViewWithAlignment:1];
                RELEASE(_bt_moveToDataBase);
            }
            
        }else if (typeTop == 2) {
            //修改共享
            
            if (!_bt_edit) {
                UIImage *img= [UIImage imageNamed:@"note_editshare_def"];
                _bt_edit = [[MagicUIButton alloc] initWithFrame:CGRectMake(60, (205-img.size.height/2)/2, img.size.width/2, img.size.height/2)];
                _bt_edit.backgroundColor=[UIColor clearColor];
                _bt_edit.tag=-11;
                [_bt_edit addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_edit setImage:img forState:UIControlStateNormal];
                [_bt_edit setImage:img forState:UIControlStateHighlighted];
                [_v_dropDown addSubview:_bt_edit];
                RELEASE(_bt_edit);
            }
            
            //取消共享
            if (!_bt_del) {
                UIImage *img= [UIImage imageNamed:@"note_cancelshare_def"];
                _bt_del = [[MagicUIButton alloc] initWithFrame:CGRectMake(320-img.size.width/2-60, (205-img.size.height/2)/2, img.size.width/2, img.size.height/2)];
                _bt_del.backgroundColor=[UIColor clearColor];
                _bt_del.tag=-12;
                [_bt_del addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_del setImage:img forState:UIControlStateNormal];
                [_bt_del setImage:img forState:UIControlStateHighlighted];
                [_v_dropDown addSubview:_bt_del];
                RELEASE(_bt_del);
            }
            
            
        }else {
            
            if (!_bt_edit) {
                UIImage *img= [UIImage imageNamed:@"note_edit_def"];
                _bt_edit = [[MagicUIButton alloc] initWithFrame:CGRectMake(33, 20, img.size.width/2, img.size.height/2)];
                _bt_edit.backgroundColor=[UIColor clearColor];
                _bt_edit.tag=1;
                [_bt_edit addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_edit setImage:img forState:UIControlStateNormal];
                [_bt_edit setImage:img forState:UIControlStateHighlighted];
                //            [_bt_creatNote setTitle:@"更多"];
                //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
                //            [_bt_creatNote setTitleColor:ColorBlue];
                [_v_dropDown addSubview:_bt_edit];
                //                            [_bt_Right changePosInSuperViewWithAlignment:1];
                RELEASE(_bt_edit);
            }
            
            if (!_bt_share) {
                UIImage *img= [UIImage imageNamed:@"note_share_def"];
                _bt_share = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bt_edit.frame)+55, CGRectGetMinY(_bt_edit.frame), img.size.width/2, img.size.height/2)];
                _bt_share.backgroundColor=[UIColor clearColor];
                _bt_share.tag=2;
                [_bt_share addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_share setImage:img forState:UIControlStateNormal];
                [_bt_share setImage:img forState:UIControlStateHighlighted];
                //            [_bt_creatNote setTitle:@"更多"];
                //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
                //            [_bt_creatNote setTitleColor:ColorBlue];
                [_v_dropDown addSubview:_bt_share];
                //                            [_bt_Right changePosInSuperViewWithAlignment:1];
                RELEASE(_bt_share);
            }
            
            if (!_bt_moveToDataBase) {
                UIImage *img= [UIImage imageNamed:@"note_move_def"];
                _bt_moveToDataBase = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bt_share.frame)+35 , CGRectGetMinY(_bt_edit.frame), img.size.width/2, img.size.height/2)];
                _bt_moveToDataBase.backgroundColor=[UIColor clearColor];
                _bt_moveToDataBase.tag=3;
                [_bt_moveToDataBase addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_moveToDataBase setImage:img forState:UIControlStateNormal];
                [_bt_moveToDataBase setImage:img forState:UIControlStateHighlighted];
                //            [_bt_creatNote setTitle:@"更多"];
                //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
                //            [_bt_creatNote setTitleColor:ColorBlue];
                [_v_dropDown addSubview:_bt_moveToDataBase];
                //                            [_bt_Right changePosInSuperViewWithAlignment:1];
                RELEASE(_bt_moveToDataBase);
            }
            
            if (!_bt_star) {
                UIImage *img= [UIImage imageNamed:@"note_star_def"];
                _bt_star = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_bt_edit.frame), CGRectGetMaxY(_bt_edit.frame)+25, img.size.width/2, img.size.height/2)];
                _bt_star.backgroundColor=[UIColor clearColor];
                _bt_star.tag=4;
                [_bt_star addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_star setImage:img forState:UIControlStateNormal];
                [_bt_star setImage:img forState:UIControlStateHighlighted];
                //            [_bt_creatNote setTitle:@"更多"];
                //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
                //            [_bt_creatNote setTitleColor:ColorBlue];
                [_v_dropDown addSubview:_bt_star];
                //                            [_bt_Right changePosInSuperViewWithAlignment:1];
                RELEASE(_bt_star);
            }
            
            if (!_bt_del) {
                UIImage *img= [UIImage imageNamed:@"note_del_def"];
                _bt_del = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bt_star.frame)+55, CGRectGetMinY(_bt_star.frame), img.size.width/2, img.size.height/2)];
                _bt_del.backgroundColor=[UIColor clearColor];
                _bt_del.tag=5;
                [_bt_del addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_del setImage:img forState:UIControlStateNormal];
                [_bt_del setImage:img forState:UIControlStateHighlighted];
                //            [_bt_creatNote setTitle:@"更多"];
                //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
                //            [_bt_creatNote setTitleColor:ColorBlue];
                [_v_dropDown addSubview:_bt_del];
                //                            [_bt_Right changePosInSuperViewWithAlignment:1];
                RELEASE(_bt_del);
            }
            
            
        }
        
        
        {//底线
            UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_v_dropDown.frame)-1, CGRectGetWidth(_v_dropDown.frame), 1)];
            v.backgroundColor=[MagicCommentMethod colorWithHex:@"e5e5e5"];
            [_v_dropDown addSubview:v];
            RELEASE(v);
        }
        
        [self.view insertSubview:_v_dropDown belowSubview:self.headview];
        RELEASE(_v_dropDown);
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
            [_v_dropDown setFrame:CGRectMake(CGRectGetMinX(_v_dropDown.frame), self.headHeight+1, CGRectGetWidth(_v_dropDown.frame), CGRectGetHeight(_v_dropDown.frame))];
        }completion:^(BOOL b){
            
        }];
    }else{
        if (_v_dropDown.hidden) {
            _v_dropDown.hidden=NO;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                [_v_dropDown setFrame:CGRectMake(CGRectGetMinX(_v_dropDown.frame), self.headHeight+1, CGRectGetWidth(_v_dropDown.frame), CGRectGetHeight(_v_dropDown.frame))];
                //                                _bt_cancelDropDown.alpha=0.8;
            }completion:^(BOOL b){
                
            }];
        }else{
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                [_v_dropDown setFrame:_v_dropDown._originFrame];
                //                                _bt_cancelDropDown.alpha=0;
            }completion:^(BOOL b){
                if (b) {
                    _v_dropDown.hidden=YES;
                }
            }];
        }
    }
    
    //收底部tabbar
    {
        MagicUIImageView *_v=(MagicUIImageView *)[_v_dropUp viewWithTag:-1];//
        _v.image=[UIImage imageNamed:@"qt_10_z"];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
            [_v_dropUp setFrame:_v_dropUp._originFrame];
        }completion:^(BOOL b){
            
        }];
    }
}

//-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
//    
//    if ([signal is:[DYBDataBankShotView RIGHT]]) {
//        
//        if (![MagicDevice hasInternetConnection]){
//            DLogInfo(@"确定是否网络连接");
//            return;
//        }
//        {//转存到资笔记
//            MagicRequest *request = [DYBHttpMethod notes_savesharenote:userId nid:_str_nid isAlert:YES receive:self];
//            [request setTag:7];
//            if (!request) {//无网路
//                
//            }
//        }
//        
//    }
//    
//}


#pragma mark - DYBNoteDetailViewController自己消息
- (void)handleViewSignal_DYBNoteDetailViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBNoteDetailViewController SELTAG]])//选择标签
    {
//        [[_tbvView CellArray] removeObjectAtIndex:0];
        [_tbvView releaseCell];
        
        NSArray *arr = (NSArray *)[signal object];

        noteModel *model=[[_tbvView DataSourceArray] objectAtIndex:0];
        model.taglist=arr;
        
        [_tbvView reloadData:YES];

    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
            if ([vc isKindOfClass:[DYBNoteDetailViewController class]]) {
                //                [self sendViewSignal:[DYBNoteDetailViewController SELTAG] withObject:_arrayTagSelected from:self target:(ƒ *)vc];
                break;
            }
        }
    }
    
}

#pragma mark- 进入|退出录音状态
-(void)changeSoundRecordingState:(int)state
{
    switch (state) {
        case 0://正常状态
        {
            _bt_audio.hidden=NO;
            _bt_camera.hidden=NO;
            _bt_photo.hidden=NO;
            
            _bt_StartRecording.hidden=YES;
            _bt_StartRecording.v_expandGestureArea.hidden=YES;
            _bt_stopRecording.hidden=YES;
            _bt_stopRecording.v_expandGestureArea.hidden=YES;
            REMOVEFROMSUPERVIEW(_v_Progress);
            REMOVEFROMSUPERVIEW(_lb_ProgressTime);

        }
            break;
        case 1://录音状态
        {
            _bt_audio.hidden=YES;
            _bt_camera.hidden=YES;
            _bt_photo.hidden=YES;
            
            if (!_bt_StartRecording) {
                UIImage *img= [UIImage imageNamed:@"h_start"];
                _bt_StartRecording = [[MagicUIButton alloc] initWithFrame:CGRectMake(20, 0, img.size.width/2, img.size.height/2)];
                _bt_StartRecording.backgroundColor=[UIColor clearColor];
//                _bt_StartRecording.tag=11;
//                [_bt_StartRecording addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_StartRecording setImage:img forState:UIControlStateNormal];
                [_bt_StartRecording setImage:img forState:UIControlStateHighlighted];
                //            [_bt_creatNote setTitle:@"更多"];
                //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
                //            [_bt_creatNote setTitleColor:ColorBlue];
                [_v_dropUpInEditing addSubview:_bt_StartRecording];
                [_bt_StartRecording changePosInSuperViewWithAlignment:1];
                [_bt_StartRecording creatExpandGestureAreaView];
                _bt_StartRecording.v_expandGestureArea.tag=3;
                [_bt_StartRecording.v_expandGestureArea addSignal:[UIView TAP] object:nil target:self];
                RELEASE(_bt_StartRecording);
            }else{
                _bt_StartRecording.hidden=NO;
                _bt_StartRecording.v_expandGestureArea.hidden=NO;
            }
            
            if (!_bt_stopRecording) {
                UIImage *img= [UIImage imageNamed:@"h_stop"];
                _bt_stopRecording = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_v_dropUpInEditing.frame)-20-img.size.width/2, 0, img.size.width/2, img.size.height/2)];
                _bt_stopRecording.backgroundColor=[UIColor clearColor];
                _bt_stopRecording.tag=12;
//                [_bt_stopRecording addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_stopRecording setImage:img forState:UIControlStateNormal];
                [_bt_stopRecording setImage:img forState:UIControlStateHighlighted];
                //            [_bt_creatNote setTitle:@"更多"];
                //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
                //            [_bt_creatNote setTitleColor:ColorBlue];
                [_v_dropUpInEditing addSubview:_bt_stopRecording];
                [_bt_stopRecording changePosInSuperViewWithAlignment:1];
                RELEASE(_bt_stopRecording);
                
                [_bt_stopRecording creatExpandGestureAreaView];
                _bt_stopRecording.v_expandGestureArea.tag=4;
                [_bt_stopRecording.v_expandGestureArea addSignal:[UIView TAP] object:nil target:self];
            }else{
                _bt_stopRecording.hidden=NO;
                _bt_stopRecording.v_expandGestureArea.hidden=NO;

            }
            
            if (!_v_Progress) {
                _v_Progress=[[DYBAudioProgressView alloc]initWithFrame:CGRectMake(55, 0, 160, 20)];
                _v_Progress.layer.masksToBounds=YES;
                _v_Progress.layer.cornerRadius=10;
                _v_Progress.layer.borderColor=ColorBlue.CGColor;
                _v_Progress.layer.borderWidth=1.0;
                _v_Progress.backgroundColor=[UIColor clearColor];
                _v_Progress.A_color=@[[NSNumber numberWithFloat:((CGFloat)(30/255))] , [NSNumber numberWithFloat:(CGFloat)144/255],  [NSNumber numberWithFloat:(CGFloat)255/255], [NSNumber numberWithFloat:1]];
                [_v_dropUpInEditing addSubview:_v_Progress];
                _v_Progress.MaxTime=180;
                [_v_Progress changePosInSuperViewWithAlignment:1];
                RELEASE(_v_Progress);
                
            }
            
            if (!_lb_ProgressTime) {
                DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_v_Progress.frame)+10, 0, 0,0)];
                _lb_ProgressTime=lb;
                lb.backgroundColor=[UIColor clearColor];
                lb.textAlignment=NSTextAlignmentLeft;
                lb.font=[UIFont systemFontOfSize:14];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                lb.text=@"00:00";
                lb.textColor=ColorBlack;
                lb.numberOfLines=1;
                lb.lineBreakMode=NSLineBreakByCharWrapping;
                [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_v_dropUpInEditing.frame), CGRectGetHeight(_v_dropUpInEditing.frame))];
                //                        [lb replaceEmojiandTarget:NO];
                [_v_dropUpInEditing addSubview:lb];
                //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                //                        [_lb_time setNeedCoretext:YES];
                [lb changePosInSuperViewWithAlignment:1];
                
                RELEASE(lb);
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal{
    if ([signal is:[UIView TAP]]) {
        UIView *v=signal.source;
        switch (v.tag) {
            case 1://底部上拉view
            {
                if (CGRectEqualToRect(_v_dropUp.frame, _v_dropUp._originFrame)) {
                    MagicUIImageView *_v=(MagicUIImageView *)[_v_dropUp viewWithTag:-1];//
                    _v.image=[UIImage imageNamed:@"qt_10"];
                    
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                        [_v_dropUp setFrame:CGRectMake(CGRectGetMinX(_v_dropUp.frame), CGRectGetHeight(self.view.frame)-CGRectGetHeight(_v_dropUp.frame), CGRectGetWidth(_v_dropUp.frame), CGRectGetHeight(_v_dropUp.frame))];
                    }completion:^(BOOL b){
                        
                    }];
                    
                    //收顶部下拉view
                    {
                        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                            [_v_dropDown setFrame:_v_dropDown._originFrame];
                            //                                _bt_cancelDropDown.alpha=0;
                        }completion:^(BOOL b){
                            if (b) {
                                _v_dropDown.hidden=YES;
                            }
                        }];
                    }
                }else{
                    MagicUIImageView *_v=(MagicUIImageView *)[_v_dropUp viewWithTag:-1];//
                    _v.image=[UIImage imageNamed:@"qt_10_z"];
                    
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                        [_v_dropUp setFrame:_v_dropUp._originFrame];
                    }completion:^(BOOL b){
                        
                    }];
                }
             

            }
                break;
            case 2://标签cell的scrollview
            {
//                [self addSignal:[MagicUITableView TABLEDIDSELECT] object:signal.object target:self];
                [self sendViewSignal:[MagicUITableView TABLEDIDSELECT] withObject:[signal object] from:self target:self];
            }
                break;
            case 3://开始录音
            {
                _bt_StartRecording.hidden=YES;
                _bt_StartRecording.v_expandGestureArea.hidden=YES;
                
//                if ( _audioPlayer ) { // 播放器停止播放
//                    [_audioPlayer stop];
//                    [_audioPlayer release];
//                    _audioPlayer = nil;
//                }
                
                [self stopAudioPlayer];
                
                {
                    if (_str_curRecordFilePath) {
                        RELEASE(_str_curRecordFilePath);
                        _str_curRecordFilePath=nil;
                    }
                    
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",_recodeTime] forKey:k_recodeTimeKey];

                    NSError *error = nil;
                    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                    [audioSession setActive:NO error:&error];
                    usleep(100);
                    
                    NSDateComponents *dateCom=[NSString getDateComponentsByNow];
//                    NSLog(@"dateCom========================================%@",dateCom);

                    
                    NSURL* recordedTmpFile = [NSURL fileURLWithPath:(_str_curRecordFilePath=[NSString cachePathForfileName:([NSString stringWithFormat:@"%d%d%d%d%d%d",dateCom.year,[NSString getDateComponentsByNow].month,dateCom.day,dateCom.hour,dateCom.minute,dateCom.second]) fileType:@"ImageCache" dir:NSCachesDirectory])];
                    [_str_curRecordFilePath retain];
//                    NSLog(@"_str_curRecordFilePath========================================%@",_str_curRecordFilePath);
//                    [_str_curRecordFileName retain];
                    
                    if (recorder) {
                        [recorder stop];
                        [recorder release];
                        recorder = nil;
                    }
                    
                    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
                    [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
                    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
                    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
                    
                    recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
                    
                    if ([recorder prepareToRecord]) {
                        
                        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
                        [audioSession setActive:YES error:&error];
                        
                        [recorder peakPowerForChannel:0];
                        [recorder setDelegate:self];
                        recorder.meteringEnabled = YES;
                        [recorder record];
                        
                        _recodeTime=0;
                        if ([_t_recodeTime isValid]) {
                            [_t_recodeTime invalidate];
                            RELEASE(_t_recodeTime);
                            _t_recodeTime=nil;
                        }
                        _t_recodeTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recodeTime) userInfo:nil repeats:YES];
                        [_t_recodeTime retain];
                        [_t_recodeTime fire];
                        
                    }

                }
              
            }
            break;
            case 4://停止录音
            {
//                if ([_t_recodeTime isValid]) {
//                    [_t_recodeTime invalidate];
//                    RELEASE(_t_recodeTime); 
//                    _t_recodeTime=nil;
//                }
//                
//                
//                [self changeSoundRecordingState:0];
//                
//                if(recorder){
//                    [recorder stop];
//                    [recorder release];
//                    recorder  = nil;
//                    //recorder释放后系统回调 audioRecorderDidFinishRecording 方法
//                    
//                }
                _recodeTime++;
                _isSaveRecordData=YES;
                [self audioRecordeOver];
            }
            break;
            case  5://播放音频
            {
                
//                if ( _audioPlayer ) { // 播放器停止播放
//                    [_audioPlayer stop];
//                    [_audioPlayer release];
//                    _audioPlayer = nil;
//                    
//                    {//喇叭动画
//                        DYBCellForNotesDetail *cell=[signal.object valueForKeyPath:@"object.cell"];
//                        [cell PlayOrStopAudio:0];
//                    }
//                    
//                    return; 
//                }
                
                if ([self stopAudioPlayer]) {
//                    {//喇叭动画
//                        DYBCellForNotesDetail *cell=[signal.object valueForKeyPath:@"object.cell"];
//                        [cell PlayOrStopAudio:0];
//                    }
                    
                    return;
                }
                
                if ([recorder isRecording]) {//停止录音
                    _recodeTime++;
                    _isSaveRecordData=YES;
                    [self audioRecordeOver];
                }
                
                //                if ([[UIDevice currentDevice] proximityState] == YES)
//                {
//                    
//                    YBLogInfo(@"Device is not close to user");
//                    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//                }
//                
//                [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
                
                NSError *error;
                
                AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
                [audioSession setActive:YES error:&error];
                
                
                UInt32 doChangeDefaultRoute = 1;
                AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
                
//                [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
                
                
                NSData *vodio =Nil /*[NSData dataWithContentsOfFile:[signal.object valueForKeyPath:@"object.str_filePath"]]*/;//找本地创建的文件
                if (!vodio) {//找 从服务器发来的文件
                    vodio=[NSData dataWithContentsOfFile:[signal.object valueForKeyPath:@"object.model.location"]  ];
                }
                if (vodio == nil) {
                    
//                    [Static alertView:theApp.window msg:@"没找到音频文件"];
                    
                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                    [pop setDelegate:self];
                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                    [pop setText:@"没找到音频文件"];
                    [pop alertViewAutoHidden:.5f isRelease:YES];
                }
                
                if ([vodio length] < 700.0f) { // 1s 文件最小值
                    
//                    [Static alertView:theApp.window msg:@"音频文件有损"];
                    
                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                    [pop setDelegate:self];
                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                    [pop setText:@"音频文件有损"];
                    [pop alertViewAutoHidden:.5f isRelease:YES];
                    
                    return;
                }
                
                NSData * wavData = DecodeSpeexToWAVE(vodio);

                _audioPlayer = [[AVAudioPlayer alloc]initWithData:wavData error:nil];

                [_audioPlayer setDelegate:self];
                [_audioPlayer play];
                
                {//喇叭动画
                    DYBCellForNotesDetail *cell=[signal.object valueForKeyPath:@"object.cell"];
//                    [cell PlayOrStopAudio:1];
                    
//                    _audioPlayer.ob=cell;
                    [_audioPlayer addObserverObj:cell forKeyPath:@"b_isPlaying" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:[_audioPlayer class]];
                    _audioPlayer.b_isPlaying=YES;

                }
                
            }
                break;
            default:
            break;
        }
    }
}

-(void)recodeTime
{
    _recodeTime++;

    [_v_Progress changeRect];
    
    _lb_ProgressTime.text=[NSString stringWithFormat:@"0%d:%d",_recodeTime/60,_recodeTime%60];


}

#pragma mark- AVAudioRecorderDelegate  录音结束回调
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)_recorder successfully:(BOOL)flag{
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    [audioSession setActive:NO error:&error];
    
    if (!_isSaveRecordData) {
        return;
    }
    
    {//编码并缓存
        NSFileManager *manager = [NSFileManager defaultManager];
        
        NSData *vodio = [NSData dataWithContentsOfFile:_str_curRecordFilePath ];
        NSData *speexData =  EncodeWAVEToSpeex(vodio, 1, 16);//编码
        //编码完成后删除原文件
        [manager removeItemAtPath:_str_curRecordFilePath error:nil];
        //将新的压缩音频数据写入文件
        
        [speexData writeToFile:_str_curRecordFilePath atomically:YES];
    }
    
    [self creatAudioModelByFileName];
    
}

-(void)creatAudioModelByFileName
{
    file_list *model=[[file_list alloc]init];
    model.type=-6;
    model.file_type=@"2";
    model.location=_str_curRecordFilePath;
    model.state=1;
    model.duration=[NSString stringWithFormat:@"%d",--_recodeTime];
    
    int i=0;
    for (id ob in _tbvView.DataSourceArray) {
        if ([ob isKindOfClass:[file_list class]] && ((file_list *)ob).type==-7) {//插入到第一个图片model前边
            [_tbvView.DataSourceArray insertObject:model atIndex:i];
            break;
        }
        i++;
    }
    
    if (i==_tbvView.DataSourceArray.count) {//没图片model,添加到数组最后
        [_tbvView addDataSource:model];
    }
    
    RELEASE(model);
    
    [_tbvView releaseCell];
    [_tbvView reloadData:YES];
    
    RELEASE(_str_curRecordFilePath);
    _str_curRecordFilePath=nil;
}

#pragma mark- 播放音频完毕
-(BOOL)stopAudioPlayer
{
    if ([_audioPlayer isPlaying]) {
        [_audioPlayer stop];
        _audioPlayer.b_isPlaying=NO;
        [_audioPlayer release];
        _audioPlayer = nil;
        return YES;
    }
    return NO;
}

#pragma mark- AVAudioPlayerDelegate  播放音频完毕回调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)_player successfully:(BOOL)flag{
//    {//喇叭动画
//        DYBCellForNotesDetail *cell=_audioPlayer.ob;
//        [cell PlayOrStopAudio:0];
//    }
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
//    RELEASE(_audioPlayer)
//    _audioPlayer = nil;
//    [self stopAudioPlayer];
    
    _player.b_isPlaying=NO;
    
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    [audioSession setActive:NO error:nil];
    
}

#pragma mark- 切换编辑与非编辑模式的UI
-(void)setIsEditing:(BOOL)isEditing
{
    if (_model && _model.user_id && ![_model.user_id isEqualToString:SHARED.curUser.userid]) {//他人笔记不能编辑
        return;
    }
    
    _isEditing=isEditing;
    [self.headview setTitle:((_isEditing)?((_str_nid)?(@"笔记编辑"):(@"新建笔记")):(@"笔记详情"))];
    
    if (_isEditing) {//初始编辑模式UI
        if (!_v_dropUpInEditing && _isEditing) {//编辑状态底部view
            UIImage *img=[UIImage imageNamed:@"bg_whitefooter"];
            _v_dropUpInEditing=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-img.size.height/2, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self.view Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            _v_dropUpInEditing._originFrame=CGRectMake(0, CGRectGetHeight(self.view.frame)-30, CGRectGetWidth(self.view.frame), 230);
            RELEASE(_v_dropUpInEditing);
            
            if (_isEditing && !_str_nid && [_tbvView DataSourceArray].count==0) {//新建笔记进来
                {//空标签cell数据源
                    noteModel *model1 = [[noteModel alloc]init];
                    model1.type=-4;
                    model1._state=1;
                    
                    [_tbvView addDataSource:model1];
                    RELEASE(model1);
                    
                }
                
                {//空文本cell数据源
                    noteModel *model = [[noteModel alloc]init];
                    model.type=-5;
                    model._state=1;
                    [_tbvView addDataSource:model];
                    RELEASE(model);
                }
                
                [_tbvView reloadData:YES];
                
            }
            
        }else{
            _v_dropUpInEditing.hidden=NO;
        }
        
        if (!_bt_audio) {
            UIImage *img= [UIImage imageNamed:@"btn_voice_def"];
            _bt_audio = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 3, img.size.width/2, img.size.height/2)];
            _bt_audio.backgroundColor=[UIColor clearColor];
            _bt_audio.tag=8;
            [_bt_audio addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_audio setImage:img forState:UIControlStateNormal];
            [_bt_audio setImage:[UIImage imageNamed:@"btn_voice_press"] forState:UIControlStateHighlighted];
            //            [_bt_creatNote setTitle:@"更多"];
            //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
            //            [_bt_creatNote setTitleColor:ColorBlue];
            [_v_dropUpInEditing addSubview:_bt_audio];
//            [_bt_audio changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_audio);
        }
        
        if (!_bt_camera) {
            UIImage *img= [UIImage imageNamed:@"btn_camera_def"];
            _bt_camera = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bt_audio.frame), 3, img.size.width/2, img.size.height/2)];
            _bt_camera.backgroundColor=[UIColor clearColor];
            _bt_camera.tag=9;
            [_bt_camera addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_camera setImage:img forState:UIControlStateNormal];
            [_bt_camera setImage:[UIImage imageNamed:@"btn_camera_press"] forState:UIControlStateHighlighted];
            //            [_bt_creatNote setTitle:@"更多"];
            //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
            //            [_bt_creatNote setTitleColor:ColorBlue];
            [_v_dropUpInEditing addSubview:_bt_camera];
//            [_bt_camera changePosInSuperViewWithAlignment:2];
            RELEASE(_bt_camera);
        }
        
        if (!_bt_photo) {
            UIImage *img= [UIImage imageNamed:@"btn_album_def"];
            _bt_photo = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_v_dropUpInEditing.frame)-img.size.width/2, 3, img.size.width/2, img.size.height/2)];
            _bt_photo.backgroundColor=[UIColor clearColor];
            _bt_photo.tag=10;
            [_bt_photo addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_photo setImage:img forState:UIControlStateNormal];
            [_bt_photo setImage:[UIImage imageNamed:@"btn_album_press"] forState:UIControlStateHighlighted];
            //            [_bt_creatNote setTitle:@"更多"];
            //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
            //            [_bt_creatNote setTitleColor:ColorBlue];
            [_v_dropUpInEditing addSubview:_bt_photo];
//            [_bt_photo changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_photo);
        }
        
//        [_bt_Right setImage:[UIImage imageNamed:@"btn_addtag_def"] forState:UIControlStateNormal];
//        [_bt_Right setImage:[UIImage imageNamed:@"btn_addtag_def"] forState:UIControlStateHighlighted];
        REMOVEFROMSUPERVIEW(_bt_Right);
        [self init_bt_Right];
        
        _v_dropUp.hidden=YES;
        
        //收顶部下拉view
        {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                [_v_dropDown setFrame:_v_dropDown._originFrame];
                //                                _bt_cancelDropDown.alpha=0;
            }completion:^(BOOL b){
                if (b) {
                    _v_dropDown.hidden=YES;
                }
            }];
        }
        
        int i=0;
        for (DYBCellForNotesDetail *cell in [_tbvView CellArray]) {//所有cell进入编辑状态
            [cell changeState:1];
            
            if (i>=2) {
                file_list *model=[[_tbvView DataSourceArray] objectAtIndex:i];
                model.state=1;
            }else{
                noteModel *model=[[_tbvView DataSourceArray] objectAtIndex:i];
                model._state=1;
            }
            i++;
        }
        
//        _bt_AddTag.hidden=NO;
        
//        {//显示删除按钮
//            for (UIView *v in _muA_audioView) {
//                UIView *subV=[v viewWithTag:7];
//                subV.hidden=NO;
//            }
//        }
        
    }else{//初始非编辑模式UI
//        [self.headview setTitle:@"笔记详情"];
//        [_bt_Right setImage:[UIImage imageNamed:@"btn_morecontrol_def"] forState:UIControlStateNormal];
//        [_bt_Right setImage:[UIImage imageNamed:@"btn_morecontrol_def"] forState:UIControlStateHighlighted];
        REMOVEFROMSUPERVIEW(_bt_Right);
        [self init_bt_Right];

        _v_dropUp.hidden=NO;
        _v_dropUpInEditing.hidden=YES;

        int i=0;
        for (DYBCellForNotesDetail *cell in [_tbvView CellArray]) {//所有cell进入非编辑状态
            [cell changeState:0];
            
            if (i>=2) {
                file_list *model=[[_tbvView DataSourceArray] objectAtIndex:i];
                model.state=0;
            }else{
                noteModel *model=[[_tbvView DataSourceArray] objectAtIndex:i];
                model._state=0;
            }
            i++;
        }
    }
}

-(void)init_bt_Right
{
    if (!_bt_Right) {
        UIImage *img= [UIImage imageNamed:((_isEditing)?(@"btn_save_def"):(@"btn_morecontrol_def"))];
        _bt_Right = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.headview.frame.size.width-img.size.width/2, 0, img.size.width/2, /*img.size.height/2*/ CGRectGetHeight(self.headview.frame))];
        _bt_Right.backgroundColor=[UIColor clearColor];
        _bt_Right.tag=-1;
        [_bt_Right addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
        [_bt_Right setImage:img forState:UIControlStateNormal];
        [_bt_Right setImage:[UIImage imageNamed:((_isEditing)?(@"btn_save_press"):(@"btn_morecontrol_high"))] forState:UIControlStateHighlighted];
        //            [_bt_creatNote setTitle:@"更多"];
        //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
        //            [_bt_creatNote setTitleColor:ColorBlue];
        [self.headview addSubview:_bt_Right];
        [_bt_Right changePosInSuperViewWithAlignment:1];
        RELEASE(_bt_Right);
    }
}

#pragma mark- 刷新_scrV_back里的内容数据
-(void)refreshScrV_back
{
    for (int i=0; i<_model.taglist.count; i++) {//标签
        Tag *model2=[Tag JSONReflection:[_model.taglist objectAtIndex:i]];
        
        {
            DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_scrV_Tip.contentSize.width+10, 0, 0,0)];
            lb.backgroundColor=[UIColor clearColor];
            lb.textAlignment=NSTextAlignmentLeft;
            lb.font=[UIFont systemFontOfSize:14];//[DYBShareinstaceDelegate DYBFoutStyle:18];
            lb.text=model2.tag;
            lb.textColor=ColorWhite;
            lb.numberOfLines=1;
            lb.lineBreakMode=NSLineBreakByCharWrapping;
            [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_scrV_Tip.frame), CGRectGetHeight(_scrV_Tip.frame))];
            //                        [lb replaceEmojiandTarget:NO];
            [_scrV_Tip addSubview:lb];
            //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
            //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
            //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
            //                        [_lb_time setNeedCoretext:YES];
            [lb changePosInSuperViewWithAlignment:1];
            
            RELEASE(lb);
            
            {//蓝色背景
                UIView *v_lbBack=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(lb.frame)-3, CGRectGetMinY(lb.frame)-3, CGRectGetWidth(lb.frame)+6, CGRectGetHeight(lb.frame)+6)];
                v_lbBack.layer.masksToBounds=YES;
                v_lbBack.layer.cornerRadius=4;
                v_lbBack.backgroundColor=ColorBlue;
                [_scrV_Tip addSubview:v_lbBack];
                RELEASE(v_lbBack);
                [_scrV_Tip bringSubviewToFront:lb];
            }
            
            _scrV_Tip.contentSize=CGSizeMake(CGRectGetMaxX(lb.frame)+10, CGRectGetHeight(_scrV_Tip.frame));
            if (_scrV_Tip.contentSize.width>CGRectGetWidth(_scrV_Tip.frame)) {
                _scrV_Tip.scrollEnabled=YES;
            }
        }
        
    }
    
//    CGFloat H=[self refresh_textView:@"而且的完全订位确定当前当前的去外地但我却期望但我却期望大青蛙大青蛙大青蛙大青蛙大青蛙大青蛙大青蛙dwqdwqdwqdqdqwdqwdwqdwqdwqdwqdwqdqwdwqdwqdwqdqdqwdqwdwqdwqdwqdwqdwqdqwdwqdwqdwqdqdqwdqwdwqdwqdwqdwqdwqdqwdwqdwqdwqdqdqwdqwdwqdwqdwqdwqdwqdqw我却期望但我却期望大青蛙大青蛙大青蛙大青蛙大青我却期望但我却期望大青蛙大青蛙大青蛙大青蛙大青我却期望但我却期望大青蛙大"];
    
//    H=[self refreshAudioViewsH:H];
    
//    for (file_list *model in _model.file_list) {
//        if ([model.file_type isEqualToString:@"2"]) {
//            H=[self addAudioData:model startY:H];
//        }else if ([model.file_type isEqualToString:@"1"]){
//            H=[self addImg:model startY:_scrV_back.contentSize.height];
//        }
//    }
    
//    H=[self refreshImgViewsH:H+50];

//    [self resetContentSize:H];
}

//#pragma mark- 添加音频数据源
//-(void)addImgOrAudioData:(file_list *)model
//{
//    switch (model.type) {
//        case -6://音频
//        {
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
//}


#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController: (DYBImagePickerController *)picker
didFinishPickingMediaWithInfo: (NSDictionary *)info
{
    if([picker isKindOfClass:[DYBImagePickerController class]]){
        if(picker.allowsMultipleSelection) {
            NSArray *mediaInfoArray = (NSArray *)info;
            
            CGFloat h=0;
            for (int i = 0; i < [mediaInfoArray count]; i++) {
                NSDictionary *dic = [mediaInfoArray objectAtIndex:i];
                UIImage *img = (UIImage *)[dic objectForKey:@"UIImagePickerControllerOriginalImage"];
                
//                h=[self addImg:img startY:_scrV_back.contentSize.height];
                
                file_list *model=[[file_list alloc]init];
                model.type=-7;
                model.file_type=@"1";
//                model.img=img;
                [[img saveToNSDataByCompressionQuality:1] writeToFile:model.location=[NSString cachePathForfileName:[NSString stringWithFormat:@"%p",img] fileType:@"ImageCache" dir:NSCachesDirectory] atomically:YES];
                if (_isEditing) {
                    model.state=1;
                }
                
//                [self addImgOrAudioData:model];
                [_tbvView addDataSource:model];

            }
            
            if (mediaInfoArray.count>0) {
                [_tbvView reloadData:YES];
            }
            
//            [self resetContentSize:h-kH_photoEditoredImgCutSize];
         
        } else {
            NSDictionary *mediaInfo = (NSDictionary *)info;

        }
    }else if ([picker isKindOfClass:[UIImagePickerController class]]){
        
        _photoEditor = [[DYBPhotoEditorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, screenShows.size.width, self.view.bounds.size.height)];
        _photoEditor.ntype = 4;
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
        if (((UIImagePickerController *)picker).sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将拍到的图片保存到相册
        }
        
        if ((((UIImagePickerController *)picker).sourceType == UIImagePickerControllerSourceTypeCamera)) {
            [self manageImage:image];
            
        }
        
        [_photoEditor.imgRootView setCenter:CGPointMake(160.0f,self.view.bounds.size.height/2-25)];
        
        _photoEditor.imgRootView.image = _photoEditor.curImage;
        [self.view addSubview:_photoEditor];
        
        [DYBUITabbarViewController sharedInstace].containerView.tabBar.hidden=YES;
        [DYBUITabbarViewController sharedInstace].v_totalNumOfUnreadMsg.hidden=YES;
        
        [self.drNavigationController dismissViewControllerAnimated:YES completion:NULL];
        
        RELEASE(_photoEditor);
        
    }
    
}

-(void)manageImage:(UIImage*)image{
    
    float ratX = image.size.width/320;
    float ratY = image.size.height/self.view.bounds.size.height;
    float lastRat =  1;
    
    if (ratX>ratY) {
        lastRat = ratX;
        [_photoEditor.imgRootView setFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, image.size.height*320/image.size.width)];
        UIImage *smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(self.view.bounds.size.width*2, image.size.height*320/image.size.width*2) interpolationQuality:kCGInterpolationDefault];
        _photoEditor.curImage = smallImage;
        
    }else{
        lastRat = ratY;
        [_photoEditor.imgRootView setFrame:CGRectMake(0.0f, 0.0f, image.size.width*self.view.bounds.size.height/image.size.height, self.view.bounds.size.height)];
        UIImage *smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(image.size.width*self.view.bounds.size.height/image.size.height*2, self.view.bounds.size.height*2) interpolationQuality:kCGInterpolationDefault];
        _photoEditor.curImage = smallImage;
        
    }
    
    _photoEditor.imgRootView.contentMode = UIViewContentModeScaleAspectFit;
    
}

//#pragma mark- 添加一个音频的数据源并创建对应的view并加高contentsize
//-(CGFloat)addAudioData:(file_list *)ob startY:(CGFloat)startY
//{
//    if (!_muA_audioData) {
//        _muA_audioData=[[NSMutableArray alloc]initWithObjects:ob, nil];
//    }else if (![_muA_audioData containsObject:ob]){
//        [_muA_audioData addObject:ob];
//    }
//    
//    UIView *imgV=[self creatAudioView:ob startY:startY];
//    if (!_muA_audioView) {
//        _muA_audioView=[[NSMutableArray alloc]initWithObjects:imgV, nil];
//    }else if(![_muA_audioView containsObject:imgV]){
//        [_muA_audioView addObject:imgV];
//    }
//    
////    [self resetContentSize:CGRectGetMaxY(imgV.frame)];
//    return CGRectGetMaxY(imgV.frame);
//}

//#pragma mark- 刷新音频区域的高
//-(CGFloat)refreshAudioViewsH:(CGFloat)startY
//{
//    CGFloat h=startY;
//    
//    if (_muA_audioView) {
//        for (UIView *v in _muA_audioView) {
//            [v removeFromSuperview];
//        }
//        RELEASEDICTARRAYOBJ(_muA_audioView);
//    }
//    
////    _muA_audioView=[[NSMutableArray alloc] initWithCapacity:1];
//    
//    for (NSObject *ob in _muA_audioData) {
//        if (ob) {
//            [self addAudioData:ob startY:h];
////            [_muA_audioView addObject:v];
//            h=CGRectGetMaxY(((UIView *)_muA_audioView.lastObject).frame);
//        }
//    }
//    
//    return h;
//}

//#pragma mark- 刷新图片区域的高
//-(CGFloat)refreshImgViewsH:(CGFloat)startY
//{
//    CGFloat h=startY;
//    
//    if (_muA_showImgView) {//释放之前的图片view
//        for (UIView *v in _muA_showImgView) {
//            [v removeFromSuperview];
//        }
//        RELEASEDICTARRAYOBJ(_muA_showImgView);
//    }
//    
//    for (NSObject *ob in _muA_ImgViewData) {
//        if (ob) {
//            
////            UIImageView *imgV=[self creatShowImgView:[NSNull null] startY:startY img:(UIImage *)ob];
////            if (!_muA_showImgView) {
////                _muA_showImgView=[[NSMutableArray alloc]initWithObjects:imgV, nil];
////            }else if(![_muA_showImgView containsObject:imgV]){
////                [_muA_showImgView addObject:imgV];
////            }
////            
////            [self resetContentSize:CGRectGetMaxY(imgV.frame)-kH_photoEditoredImgCutSize];
//            
//            h=[self addImg:(UIImage *)ob startY:_scrV_back.contentSize.height];
////            h=CGRectGetMaxY(((UIView *)_muA_showImgView.lastObject).frame);
//        }
//    }
//    
//    return h;
//}

//#pragma mark- 创建一个音频view
//-(UIView *)creatAudioView:(file_list *)ob startY:(CGFloat)startY
//{
//    UIImage *img=[UIImage imageNamed:@"audiobox.png"];
//    MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_scrV_Tip.frame), startY+10, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_scrV_back Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
//    RELEASE(imgV);
//    
//    {//删除按钮
//        UIImage *img= [UIImage imageNamed:@"star_note"];
//        MagicUIButton *bt = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(imgV.frame)-img.size.width/4, -img.size.height/4, img.size.width/2, img.size.height/2)];
//        bt.backgroundColor=[UIColor clearColor];
//        bt.tag=7;
//        [bt addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:nil];
//        [bt setImage:img forState:UIControlStateNormal];
//        [bt setImage:img forState:UIControlStateHighlighted];
//        //            [_bt_creatNote setTitle:@"更多"];
//        //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
//        //            [_bt_creatNote setTitleColor:ColorBlue];
//        [imgV addSubview:bt];
//        //            [_bt_AddTag changePosInSuperViewWithAlignment:1];
//        RELEASE(bt);
//        if (!_isEditing) {
//            bt.hidden=YES;
//        }
//    }
//    return imgV;
//}

//#pragma mark- 创建一个图片view
//-(MagicUIImageView *)creatShowImgView:(file_list *)ob startY:(CGFloat)startY img:(UIImage *)img
//{
//    
//    MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_scrV_Tip.frame), startY-20-kH_photoEditoredImgCutSize/*图片经过滤镜后上下各被裁减黑了*/, screenShows.size.width-CGRectGetMinX(_scrV_Tip.frame)*2, screenShows.size.height) backgroundColor:[UIColor clearColor] image:(([img isKindOfClass:[UIImage class]])?(img):(nil)) isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_scrV_back Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
//    RELEASE(imgV);
//    if (![img isKindOfClass:[UIImage class]] && [ob isKindOfClass:[file_list class]]) {
//        [imgV setImgWithUrl:ob.location defaultImg:nil];
//    }
//    
//    {//删除按钮
//        UIImage *img= [UIImage imageNamed:@"star_note"];
//        MagicUIButton *bt = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(imgV.frame)-img.size.width/4, kH_photoEditoredImgCutSize, img.size.width/2, img.size.height/2)];
//        bt.backgroundColor=[UIColor clearColor];
//        bt.tag=7;
//        [bt addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:nil];
//        [bt setImage:img forState:UIControlStateNormal];
//        [bt setImage:img forState:UIControlStateHighlighted];
//        //            [_bt_creatNote setTitle:@"更多"];
//        //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
//        //            [_bt_creatNote setTitleColor:ColorBlue];
//        [imgV addSubview:bt];
//        //            [_bt_AddTag changePosInSuperViewWithAlignment:1];
//        RELEASE(bt);
//        if (!_isEditing) {
//            bt.hidden=YES;
//        }
//    }
//    return imgV;
//}

//#pragma mark- 刷新_textView的高
//-(CGFloat)refresh_textView:(NSString *)str
//{
//    _textView.text=str;
//    [_textView sizeFitByText];
//    
//    CGFloat maxH=CGRectGetHeight(_scrV_back.frame)-CGRectGetMinY(_textView.frame)-/*CGRectGetHeight(_v_dropUpInEditing.frame)*/45/*底部语音等功能栏的高45*/-60;
//    if (CGRectGetHeight(_textView.frame)>maxH) {//设_textView的高上限
//        [_textView setFrame:CGRectMake(CGRectGetMinX(_textView.frame), CGRectGetMinY(_textView.frame), CGRectGetWidth(_textView.frame),maxH)];
//    }
//    
//    return CGRectGetMaxY(_textView.frame);
//}

//#pragma mark- 重设_scrV_back的ContentSize
//-(void)resetContentSize:(CGFloat)maxY
//{
//    
//    [_scrV_back setContentSize:CGSizeMake(_scrV_back.frame.size.width,maxY+50)];
//    
//    if (CGRectGetHeight(_scrV_back.frame)<maxY) {
//        _scrV_back.scrollEnabled=YES;
//    }else{
//        _scrV_back.scrollEnabled=NO;
//    }
//}

#pragma mark- 组装tbv数据源
-(void)creatTbvData:(NSDictionary *)d
{
    noteModel *model = [noteModel JSONReflection:d];
    if (_model) {
        RELEASE(_model);
        _model=nil;
    }
    _model=model;
    [_model retain];
    
    _str_favorite=_model.favorite;
    [_str_favorite retain];
    
    //                    [self refreshScrV_back];
    
    {//标签cell数据源
        noteModel *model1 = [noteModel JSONReflection:d];
        model1.type=-4;
        [_tbvView addDataSource:model1];
    }
    
    {//文本cell数据源
        _model.type=-5;
        [_tbvView addDataSource:_model];
    }
    
    {//图片和音频数据源
        for (file_list *file in _model.file_list) {
            if ([file.file_type isEqualToString:@"1"] && file.location) {//图片
                file.type=-7;
                [_tbvView addDataSource:file];
                //                                if (![_muA_fid containsObject:file.fid]) {
                //                                    [_muA_fid addObject:file.fid];
                //                                }
            }else if ([file.file_type isEqualToString:@"2"] && file.location) {//音频
                file.type=-6;
                [_tbvView addDataSource:file];
                //                                if (![_muA_fid containsObject:file.fid]) {
                //                                    [_muA_fid addObject:file.fid];
                //                                }
            }
        }
    }
    
    [_tbvView reloadData:YES];
}

#pragma mark- 刷底部面板
-(void)refreshTabBar
{
    RELEASEALLSUBVIEW(_v_dropUp);
    
    {//顶部阴影
        UIImage *img=[UIImage imageNamed:@"line_padshadow"];
        MagicUIImageView *imgV_line_padshadow=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0, -img.size.height/2, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_v_dropUp Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        RELEASE(imgV_line_padshadow);
    }
    
    {//箭头
        UIImage *img=[UIImage imageNamed:@"qt_10_z"];
        MagicUIImageView *imgV_arrow=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_v_dropUp Alignment:0 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        //                RELEASE(imgV_arrow);
        imgV_arrow.tag=-1;
    }
    
    //标签
    DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(20, 40, 100,100)];
    lb.backgroundColor=[UIColor clearColor];
    lb.textAlignment=NSTextAlignmentLeft;
    lb.font=[UIFont systemFontOfSize:16];//[DYBShareinstaceDelegate DYBFoutStyle:18];
    lb.text=@"标签:";
    if (_model.taglist.count==0) {
        lb.text=[lb.text stringByAppendingString:@"  无"];
    }
    lb.textColor=ColorBlack;
    lb.numberOfLines=1;
    lb.lineBreakMode=NSLineBreakByCharWrapping;
    [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(lb.frame), CGRectGetHeight(lb.frame))];
    //        [_lb_content replaceEmojiandTarget:NO];
    [_v_dropUp addSubview:lb];
    //                int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
    //                _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
    //                _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
    //                [_lb_time setNeedCoretext:YES];
    //                [_lb_time changePosInSuperViewWithAlignment:1];
    
    RELEASE(lb);
    
    {/*标签的背景滚动*/
        MagicUIScrollView *_scrV_Tip = [[MagicUIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lb.frame)+10, CGRectGetMinY(lb.frame)-3, 240, CGRectGetHeight(lb.frame)+6)];
        [_scrV_Tip setBackgroundColor:[UIColor clearColor]];
        [_scrV_Tip setContentSize:CGSizeMake(0, CGRectGetHeight(_scrV_Tip.frame))];
        [_scrV_Tip setShowsHorizontalScrollIndicator:NO];
        [_scrV_Tip setScrollEnabled:NO];
        [_v_dropUp addSubview:_scrV_Tip];
        RELEASE(_scrV_Tip);
        
        for (int i=0; i<((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:0]).taglist.count; i++) {
//            tag_list_info *model2=[tag_list_info JSONReflection:[((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:0]).taglist objectAtIndex:i]];
            tag_list_info *model2=[((noteModel *)[[_tbvView DataSourceArray] objectAtIndex:0]).taglist objectAtIndex:i];
            if (![model2 isKindOfClass:[tag_list_info class]]) {
                model2=[tag_list_info JSONReflection:model2];
            }
            {
                DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_scrV_Tip.contentSize.width+10, 0, 0,0)];
                lb.backgroundColor=[UIColor clearColor];
                lb.textAlignment=NSTextAlignmentLeft;
                lb.font=[UIFont systemFontOfSize:14];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                lb.text=model2.tag;
                lb.textColor=ColorBlack;
                lb.numberOfLines=1;
                lb.lineBreakMode=NSLineBreakByCharWrapping;
                [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_scrV_Tip.frame), CGRectGetHeight(_scrV_Tip.frame))];
                //                        [lb replaceEmojiandTarget:NO];
                [_scrV_Tip addSubview:lb];
                //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                //                        [_lb_time setNeedCoretext:YES];
                [lb changePosInSuperViewWithAlignment:1];
                
                RELEASE(lb);
                
                _scrV_Tip.contentSize=CGSizeMake(CGRectGetMaxX(lb.frame)+10, CGRectGetHeight(_scrV_Tip.frame));
                if (_scrV_Tip.contentSize.width>CGRectGetWidth(_scrV_Tip.frame)) {
                    _scrV_Tip.scrollEnabled=YES;
                }
            }
            
        }
    }
    
    {//创建时间
        DYBCustomLabel *lb_creatTime=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(lb.frame), CGRectGetMaxY(lb.frame)+10, 400,100)];
        lb_creatTime.backgroundColor=[UIColor clearColor];
        lb_creatTime.textAlignment=NSTextAlignmentLeft;
        lb_creatTime.font=[UIFont systemFontOfSize:16];//[DYBShareinstaceDelegate DYBFoutStyle:18];
        lb_creatTime.text=[NSString stringWithFormat:@"创建时间:  %d-%d-%d",[NSString getDateComponentsByTimeStamp:[_model.create_time integerValue]].year,[NSString getDateComponentsByTimeStamp:[_model.create_time integerValue]].month,[NSString getDateComponentsByTimeStamp:[_model.create_time integerValue]].day];
        lb_creatTime.textColor=ColorBlack;
        lb_creatTime.numberOfLines=1;
        lb_creatTime.lineBreakMode=NSLineBreakByCharWrapping;
        [lb_creatTime sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(lb_creatTime.frame), CGRectGetHeight(lb_creatTime.frame))];
        //        [_lb_content replaceEmojiandTarget:NO];
        [_v_dropUp addSubview:lb_creatTime];
        //                int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
        //                _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
        //                _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
        //                [_lb_time setNeedCoretext:YES];
        //                [_lb_time changePosInSuperViewWithAlignment:1];
        
        RELEASE(lb_creatTime);
        
        {//更新时间
            DYBCustomLabel *lb_upTime=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(lb.frame), CGRectGetMaxY(lb_creatTime.frame)+10, 400,100)];
            lb_upTime.backgroundColor=[UIColor clearColor];
            lb_upTime.textAlignment=NSTextAlignmentLeft;
            lb_upTime.font=[UIFont systemFontOfSize:16];//[DYBShareinstaceDelegate DYBFoutStyle:18];
            lb_upTime.text=[NSString stringWithFormat:@"更新时间:  %d-%d-%d",[NSString getDateComponentsByTimeStamp:[_model.update_time integerValue]].year,[NSString getDateComponentsByTimeStamp:[_model.update_time integerValue]].month,[NSString getDateComponentsByTimeStamp:[_model.update_time integerValue]].day];
            lb_upTime.textColor=ColorBlack;
            lb_upTime.numberOfLines=1;
            lb_upTime.lineBreakMode=NSLineBreakByCharWrapping;
            [lb_upTime sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(lb_creatTime.frame), CGRectGetHeight(lb_creatTime.frame))];
            //        [_lb_content replaceEmojiandTarget:NO];
            [_v_dropUp addSubview:lb_upTime];
            //                int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
            //                _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
            //                _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
            //                [_lb_time setNeedCoretext:YES];
            //                [_lb_time changePosInSuperViewWithAlignment:1];
            
            RELEASE(lb_upTime);
            
            {//共享时间
                DYBCustomLabel *lb_shareTime=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(lb.frame), CGRectGetMaxY(lb_upTime.frame)+10, 400,100)];
                lb_shareTime.backgroundColor=[UIColor clearColor];
                lb_shareTime.textAlignment=NSTextAlignmentLeft;
                lb_shareTime.font=[UIFont systemFontOfSize:16];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                if (_model.share_time) {
                    lb_shareTime.text=[NSString stringWithFormat:@"共享时间:  %d-%d-%d",[NSString getDateComponentsByTimeStamp:[_model.share_time integerValue]].year,[NSString getDateComponentsByTimeStamp:[_model.share_time integerValue]].month,[NSString getDateComponentsByTimeStamp:[_model.share_time integerValue]].day];
                }else{
                    lb_shareTime.text=@"共享时间:  无";
                }
                lb_shareTime.textColor=ColorBlack;
                lb_shareTime.numberOfLines=1;
                lb_shareTime.lineBreakMode=NSLineBreakByCharWrapping;
                [lb_shareTime sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(lb_shareTime.frame), CGRectGetHeight(lb_shareTime.frame))];
                //        [_lb_content replaceEmojiandTarget:NO];
                [_v_dropUp addSubview:lb_shareTime];
                //                int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                //                _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                //                _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                //                [_lb_time setNeedCoretext:YES];
                //                [_lb_time changePosInSuperViewWithAlignment:1];
                
                RELEASE(lb_shareTime);
                
                {//共享对象
                    DYBCustomLabel *lb_shareTar=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(lb.frame), CGRectGetMaxY(lb_shareTime.frame)+10, 400,100)];
                    lb_shareTar.backgroundColor=[UIColor clearColor];
                    lb_shareTar.textAlignment=NSTextAlignmentLeft;
                    lb_shareTar.font=[UIFont systemFontOfSize:16];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                    if (_model.share_user_list.count==0) {
                        lb_shareTar.text=@"共享对象:  无";
                    }else{
                        lb_shareTar.text=[NSString stringWithFormat:@"共享对象%d人:",_model.share_user_list.count];
                    }
                    lb_shareTar.textColor=ColorBlack;
                    lb_shareTar.numberOfLines=1;
                    lb_shareTar.lineBreakMode=NSLineBreakByCharWrapping;
                    [lb_shareTar sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(lb_shareTar.frame), CGRectGetHeight(lb_shareTar.frame))];
                    //        [_lb_content replaceEmojiandTarget:NO];
                    [_v_dropUp addSubview:lb_shareTar];
                    //                int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                    //                _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                    //                _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                    //                [_lb_time setNeedCoretext:YES];
                    //                [_lb_time changePosInSuperViewWithAlignment:1];
                    
                    RELEASE(lb_shareTar);
                    
                    {/*共享对象的背景滚动*/
                        MagicUIScrollView *_scrV_Tip = [[MagicUIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lb_shareTar.frame)+10, CGRectGetMinY(lb_shareTar.frame)-3, CGRectGetWidth(self.view.frame)-(CGRectGetMaxX(lb_shareTar.frame)+10)-10, CGRectGetHeight(lb_shareTar.frame)+6)];
                        [_scrV_Tip setBackgroundColor:[UIColor clearColor]];
                        [_scrV_Tip setContentSize:CGSizeMake(0, CGRectGetHeight(_scrV_Tip.frame))];
                        [_scrV_Tip setShowsHorizontalScrollIndicator:NO];
                        [_scrV_Tip setScrollEnabled:NO];
                        [_v_dropUp addSubview:_scrV_Tip];
                        RELEASE(_scrV_Tip);
                        
                        for (int i=0; i<_model.share_user_list.count; i++) {
                            notesUserinfo *model2=[notesUserinfo JSONReflection:[_model.share_user_list objectAtIndex:i]];
                            
                            {
                                DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_scrV_Tip.contentSize.width+10, 0, 0,0)];
                                lb.backgroundColor=[UIColor clearColor];
                                lb.textAlignment=NSTextAlignmentLeft;
                                lb.font=[UIFont systemFontOfSize:14];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                                lb.text=model2.name;
                                lb.textColor=ColorBlack;
                                lb.numberOfLines=1;
                                lb.lineBreakMode=NSLineBreakByCharWrapping;
                                [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_scrV_Tip.frame), CGRectGetHeight(_scrV_Tip.frame))];
                                //                        [lb replaceEmojiandTarget:NO];
                                [_scrV_Tip addSubview:lb];
                                //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                                //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                                //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                                //                        [_lb_time setNeedCoretext:YES];
                                [lb changePosInSuperViewWithAlignment:1];
                                
                                RELEASE(lb);
                                
                                _scrV_Tip.contentSize=CGSizeMake(CGRectGetMaxX(lb.frame)+10, CGRectGetHeight(_scrV_Tip.frame));
                                if (_scrV_Tip.contentSize.width>CGRectGetWidth(_scrV_Tip.frame)) {
                                    _scrV_Tip.scrollEnabled=YES;
                                }
                            }
                            
                        }
                    }
                    
                    {//来源
                        DYBCustomLabel *lb_from=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(lb.frame), CGRectGetMaxY(lb_shareTar.frame)+10, 400,100)];
                        lb_from.backgroundColor=[UIColor clearColor];
                        lb_from.textAlignment=NSTextAlignmentLeft;
                        lb_from.font=[UIFont systemFontOfSize:16];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                        lb_from.text=[NSString stringWithFormat:@"来源:  %@",((_model.user_info.name)?(_model.user_info.name):(@""))];
                        lb_from.textColor=ColorBlack;
                        lb_from.numberOfLines=1;
                        lb_from.lineBreakMode=NSLineBreakByCharWrapping;
                        [lb_from sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(lb_from.frame), CGRectGetHeight(lb_from.frame))];
                        //        [_lb_content replaceEmojiandTarget:NO];
                        [_v_dropUp addSubview:lb_from];
                        //                int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                        //                _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                        //                _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                        //                [_lb_time setNeedCoretext:YES];
                        //                [_lb_time changePosInSuperViewWithAlignment:1];
                        
                        RELEASE(lb_from);
                    }
                }
            }
        }
    }
}

//#pragma mark- 添加一张图片的数据源并创建对应的view并加高contentsize
//-(CGFloat)addImg:(id )ob startY:(CGFloat)startY
//{
//    if (!_muA_ImgViewData) {
//        _muA_ImgViewData=[[NSMutableArray alloc]initWithObjects:ob, nil];
//    }else if(![_muA_ImgViewData containsObject:ob]){
//        [_muA_ImgViewData addObject:ob];
//    }
//    
//    UIImageView *imgV=[self creatShowImgView:ob startY:startY img:ob];
//    if (!_muA_showImgView) {
//        _muA_showImgView=[[NSMutableArray alloc]initWithObjects:imgV, nil];
//    }else if(![_muA_showImgView containsObject:imgV]){
//        [_muA_showImgView addObject:imgV];
//    }
//    
////    [self resetContentSize:CGRectGetMaxY(imgV.frame)-kH_photoEditoredImgCutSize];
//    return CGRectGetMaxY(imgV.frame);
//}

//#pragma mark- 添加一张图片的ulr并创建对应的view并加高contentsize
//-(CGFloat)addImgByUlr:(NSString *)url startY:(CGFloat)startY
//{
//    if (!_muA_ImgViewData) {
//        _muA_ImgViewData=[[NSMutableArray alloc]initWithObjects:img, nil];
//    }else if(![_muA_ImgViewData containsObject:img]){
//        [_muA_ImgViewData addObject:img];
//    }
//    
//    UIImageView *imgV=[self creatShowImgView:[NSNull null] startY:startY img:img];
//    if (!_muA_showImgView) {
//        _muA_showImgView=[[NSMutableArray alloc]initWithObjects:imgV, nil];
//    }else if(![_muA_showImgView containsObject:imgV]){
//        [_muA_showImgView addObject:imgV];
//    }
//    
//    //    [self resetContentSize:CGRectGetMaxY(imgV.frame)-kH_photoEditoredImgCutSize];
//    return CGRectGetMaxY(imgV.frame);
//}

#pragma mark- 文件上传
-(BOOL)upLoadFile:(int)MagicRequest_tag
{//文件上传
    NSString *duration=@"";
    int i=0;
    for (id ob in _tbvView.DataSourceArray) {
        if ([ob isKindOfClass:[file_list class]] && !((file_list *)ob).fid /*新增文件才调上传接口*/) {
            if (((file_list *)ob).type==-6) {//音频modle
                if (i==_tbvView.DataSourceArray.count-1) {
                    duration=[duration stringByAppendingFormat:@"%@",((file_list *)ob).duration];
                }else{
                    duration=[duration stringByAppendingFormat:@"%@,",((file_list *)ob).duration];
                }
            }else{//图片model
                if (i==_tbvView.DataSourceArray.count-1) {
                    duration=[duration stringByAppendingString:@"0"];
                }else{
                    duration=[duration stringByAppendingString:@"0,"];
                }
            }
        }
        i++;
    }
    
//    if (![duration isEqualToString:@""]) {
//        duration=[duration substringToIndex:duration.length-1];
//    }
    
    if (![duration isEqualToString:@""]){//上传文件
        
        NSMutableArray *muA_arr = [NSMutableArray arrayWithCapacity:1];
        
        NSMutableDictionary *mud=[NSMutableDictionary dictionaryWithCapacity:1];
        
        for (id ob in _tbvView.DataSourceArray) {
            if ([ob isKindOfClass:[file_list class]] && !((file_list *)ob).fid ) {
                
                if (((file_list *)ob).type==-6) {//音频
                    
                    NSMutableDictionary *mud_audio=[NSMutableDictionary dictionaryWithCapacity:1];
                    [mud_audio setValue:[NSData dataWithContentsOfFile:((file_list *)ob).location] forKey:POSTDFILEDATA];
                    [mud_audio setValue:[NSString stringWithFormat:@"%@.spx",[[((file_list *)ob).location separateStrToArrayBySeparaterChar:@"/"] lastObject]] forKey:POSTDATAFILENAME];
                    [mud_audio setValue:POSTSPX forKey:POSTDATAFILETYPE];
                    
                    [muA_arr addObject:mud_audio];
                    
                }else if (((file_list *)ob).type==-7)//图片
                {
                    //                                        NSData *data=[((file_list *)ob).img saveToNSDataByCompressionQuality:1];
                    //                                        [muA_img addObject:data];
                    
                    NSMutableDictionary *muD=[NSMutableDictionary dictionaryWithCapacity:2];
                    
                    [muD setValue:[NSData dataWithContentsOfFile:((file_list *)ob).location] forKey:POSTDFILEDATA];
                    [muD setValue:[NSString stringWithFormat:@"%@.jpg",[[((file_list *)ob).location separateStrToArrayBySeparaterChar:@"/"] lastObject]] forKey:POSTDATAFILENAME];
                    [muD setValue:POSTIMG forKey:POSTDATAFILETYPE];
                    
                    [muA_arr addObject:muD];
                }
            }
        }
        
        [mud setObject:muA_arr forKey:POSTFILE];
        
        NSMutableDictionary *muD2 = [DYBHttpInterface notes_uploadfile:_str_nid duration:duration];
        DYBRequest *request = AUTORELEASE([[DYBRequest alloc] init]);
        MagicRequest *dre = [request DYBPOSTFILE:muD2 isAlert:YES receive:self fileData:mud];
        
        dre.tag =  MagicRequest_tag;
        
        return YES;
    }
    return NO;
}


#pragma mark- 通知中心回调
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification is:[DYBPhotoEditorView DOSAVEIMAGE]]){//保存图片
        
        NSDictionary *dic = (NSDictionary *)[notification userInfo];
        NSInteger nType = [[dic objectForKey:@"type"] intValue];
        if (nType != 4) {
            return;
        }
        
        UIImage *img = (UIImage*)[notification object];
        
//        [self addImg:img startY:_scrV_back.contentSize.height];
        
//        [self resetContentSize:[self addImg:img startY:_scrV_back.contentSize.height]-kH_photoEditoredImgCutSize];
        
        file_list *model=[[file_list alloc]init];
        model.type=-7;
        model.file_type=@"1";
//        model.img=img;
        [[img saveToNSDataByCompressionQuality:1] writeToFile:model.location=[NSString cachePathForfileName:[NSString stringWithFormat:@"%p",img] fileType:@"ImageCache" dir:NSCachesDirectory] atomically:YES];
        
        if (_isEditing) {
            model.state=1;
        }
        
        [_tbvView addDataSource:model];
        
        [_tbvView reloadData:YES];
        
    }else if ([notification is:[UIViewController AutoRefreshTbvInViewWillAppear]]){
        self.b_isAutoRefreshTbvInViewWillAppear=YES;
    }
}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取|刷新
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                  
                    [self creatTbvData:response.data];
                    
                    [self refreshTabBar];
                    
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.drNavigationController popVCAnimated:YES];
            
            }
                break;
            case 2://转存到资料库
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功
                        
                        if (SHARED.currentUserSetting.notesSaveForPush) {//删除原笔迹

//                            [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"成功转存至资料库,原笔记已自动删除" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
                            
                            {
                                MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                                [pop setDelegate:self];
                                [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                                [pop setText:@"成功转存至资料库,原笔记已自动删除"];
                                [pop alertViewAutoHidden:.5f isRelease:YES];
                            }
                            
                            [self postNotification:[DYBNoteDetailViewController AutoRefreshTbvInViewWillAppear] withObject:Nil userInfo:Nil];
                            
                            for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
                                if ([vc isKindOfClass:[DYBTagNotesViewController class]]) {
                                    [self sendViewSignal:[DYBTagNotesViewController REFRESHTB] withObject:nil from:self target:(DYBTagNotesViewController *)vc];
                                    break;
                                }
                            }
                            
                            [self.drNavigationController popViewControllerAnimated:YES];

                        }else{

//                            [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"成功转存至资料库,原笔记已保留" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
                            
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
            case 3://收藏
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([[response.data objectForKey:@"result"] intValue]==1) {//成功
                        _model.favorite=@"1";
                {
                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                    [pop setDelegate:self];
                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                    [pop setText:@"收藏成功"];
                    [pop alertViewAutoHidden:.5f isRelease:YES];
                }
                    
                        return;
                }
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                {
                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                    [pop setDelegate:self];
                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                    [pop setText:@"收藏失败"];
                    [pop alertViewAutoHidden:.5f isRelease:YES];
                }
                
            }
                break;
            case 4://取消收藏
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功
                        _model.favorite=@"0";
                        {
                            MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                            [pop setDelegate:self];
                            [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                            [pop setText:@"取消收藏成功"];
                            [pop alertViewAutoHidden:.5f isRelease:YES];
                        }
                        
                        return;
                    }
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                {
                    MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                    [pop setDelegate:self];
                    [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                    [pop setText:@"取消收藏失败"];
                    [pop alertViewAutoHidden:.5f isRelease:YES];
                }
            }
                break;
            case 5://删除笔记
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功
                        
                        [self postNotification:[DYBNoteDetailViewController AutoRefreshTbvInViewWillAppear] withObject:Nil userInfo:Nil];
                        
                        for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
                            if ([vc isKindOfClass:[DYBTagNotesViewController class]]) {
                                [self sendViewSignal:[DYBTagNotesViewController REFRESHTB] withObject:nil from:self target:(DYBTagNotesViewController *)vc];
                                break;
                            }
                        }
                        
                        [self.drNavigationController popViewControllerAnimated:YES];

                    }else{
                    
                        
                        MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                        [pop setDelegate:self];
                        [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                        [pop setText:@"删除笔记失败"];
                        [pop alertViewAutoHidden:.5f isRelease:YES];
                    

                    }
                }else if ([response response] ==khttpfailCode){
                    
                }
                
            }
                break;
            case 6://添加新笔记,获取到笔记的nid
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功
                        
                        _str_nid=[response.data objectForKey:@"nid"];

                        self.DB.FROM(k_NoteListDateBase).DROP();
                        
//                        NSString *duration=@"";
//                        for (id ob in _tbvView.DataSourceArray) {
//                            if ([ob isKindOfClass:[file_list class]]) {
//                                if (((file_list *)ob).type==-6) {//音频modle
//                                    duration=[duration stringByAppendingFormat:@"%@,",((file_list *)ob).duration];
//                                }else{//图片model
//                                    duration=[duration stringByAppendingString:@"0,"];
//                                }
//                            }
//                        }
//                        
//                        if (![duration isEqualToString:@""]) {
//                            duration=[duration substringToIndex:duration.length-1];
//                        }
//                        
//                        if(![duration isEqualToString:@""]){//上传文件
//                            
//                            NSMutableArray *muA_arr = [NSMutableArray arrayWithCapacity:1];
//
//                            NSMutableDictionary *mud=[NSMutableDictionary dictionaryWithCapacity:1];
//
//                            for (id ob in _tbvView.DataSourceArray) {
//                                if ([ob isKindOfClass:[file_list class]]) {
//                                    
//                                    if (((file_list *)ob).type==-6) {//音频
//                                        
//                                        NSMutableDictionary *mud_audio=[NSMutableDictionary dictionaryWithCapacity:1];
//                                        [mud_audio setValue:[NSData dataWithContentsOfFile:((file_list *)ob).location] forKey:POSTDFILEDATA];
//                                        [mud_audio setValue:[NSString stringWithFormat:@"%@.spx",[[((file_list *)ob).location separateStrToArrayBySeparaterChar:@"/"] lastObject]] forKey:POSTDATAFILENAME];
//                                        [mud_audio setValue:POSTSPX forKey:POSTDATAFILETYPE];
//
//                                        [muA_arr addObject:mud_audio];
//                                        
//                                    }else if (((file_list *)ob).type==-7)//图片
//                                    {
////                                        NSData *data=[((file_list *)ob).img saveToNSDataByCompressionQuality:1];
////                                        [muA_img addObject:data];
//                                        
//                                        NSMutableDictionary *muD=[NSMutableDictionary dictionaryWithCapacity:2];
//
//                                        [muD setValue:[NSData dataWithContentsOfFile:((file_list *)ob).location] forKey:POSTDFILEDATA];
//                                        [muD setValue:[NSString stringWithFormat:@"%@.jpg",[[((file_list *)ob).location separateStrToArrayBySeparaterChar:@"/"] lastObject]] forKey:POSTDATAFILENAME];//内存地址作为名字
//                                        [muD setValue:POSTIMG forKey:POSTDATAFILETYPE];
//                                        
//                                        [muA_arr addObject:muD];
//                                    }
//                                }
//                            }
//                            
//                            [mud setObject:muA_arr forKey:POSTFILE];
//
//                            NSMutableDictionary *muD2 = [DYBHttpInterface notes_uploadfile:_str_nid duration:duration];
//                            DYBRequest *request = AUTORELEASE([[DYBRequest alloc] init]);
//                            MagicRequest *dre = [request DYBPOSTFILE:muD2 isAlert:YES receive:self fileData:mud];
//                            dre.tag =  9;
//                            
//                        }
                        
                        if(![self upLoadFile:9])
                        {//上传一个没有文件的纯文本的笔记
                            {
                                MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                                [pop setDelegate:self];
                                [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                                [pop setText:@"保存成功"];
                                [pop alertViewAutoHidden:.5f isRelease:YES];
                            }
                            
                            [self postNotification:[DYBNoteDetailViewController AutoRefreshTbvInViewWillAppear] withObject:Nil userInfo:Nil];
                            
                            for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
                                if ([vc isKindOfClass:[DYBTagNotesViewController class]]) {
                                    [self sendViewSignal:[DYBTagNotesViewController REFRESHTB] withObject:nil from:self target:(DYBTagNotesViewController *)vc];
                                    break;
                                }
                            }
                            
                            [self.drNavigationController popViewControllerAnimated:YES];
                            
                        }
                        
                    }else{
                        _bt_Right.enabled=YES;
                    }
                }else if ([response response] ==khttpfailCode){
                    _bt_Right.enabled=YES;
                }
                
            }
                break;
            case 7://转存到笔记
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    DLogInfo(@"======%@",response.data);
                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功
                        
                        [DYBShareinstaceDelegate loadFinishAlertView:@"转存成功" target:self];
                    }
                    
                }else if ([response response] ==khttpfailCode){
                    
                    [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                }
                
                
            }
                break;
            case 8://取消共享
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    DLogInfo(@"======%@",response.data);
                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功
                        
                        [DYBShareinstaceDelegate loadFinishAlertView:@"取消成功" target:self];
                        
                        [self postNotification:[DYBNoteDetailViewController AutoRefreshTbvInViewWillAppear] withObject:Nil userInfo:Nil];
                        
                        for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
                            if ([vc isKindOfClass:[DYBTagNotesViewController class]]) {
                                [self sendViewSignal:[DYBTagNotesViewController REFRESHTB] withObject:nil from:self target:(DYBTagNotesViewController *)vc];
                                break;
                            }
                        }
                        
                        [self.drNavigationController popViewControllerAnimated:YES];
                    }
                    
                }else if ([response response] ==khttpfailCode){
                    
                    [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                }
                
            }
                break;
            case 9://文件上传
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功
                        
                        {
                            MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                            [pop setDelegate:self];
                            [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                            [pop setText:@"保存成功"];
                            [pop alertViewAutoHidden:.5f isRelease:YES];
                        }
                        
                        [self postNotification:[DYBNoteDetailViewController AutoRefreshTbvInViewWillAppear] withObject:Nil userInfo:Nil];
                        
                        for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
                            if ([vc isKindOfClass:[DYBTagNotesViewController class]]) {
                                [self sendViewSignal:[DYBTagNotesViewController REFRESHTB] withObject:nil from:self target:(DYBTagNotesViewController *)vc];
                                break;
                            }
                        }
                        
                        [self.drNavigationController popViewControllerAnimated:YES];
                        
                    }else{
                        {
                            MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                            [pop setDelegate:self];
                            [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                            [pop setText:[[response.data objectForKey:@"error"] objectAtIndex:0]];
                            [pop alertViewAutoHidden:.5f isRelease:YES];
                        }
                        
                        _bt_Right.enabled=YES;

                    }
                    
                }else if ([response response] ==khttpfailCode){
                    
                    [DYBShareinstaceDelegate loadFinishAlertView:response.message target:self];
                    _bt_Right.enabled=YES;

                }
                
            }
                break;
            case 10://文件删除
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功
                        {
                            MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                            [pop setDelegate:self];
                            [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                            [pop setText:@"删除成功"];
                            [pop alertViewAutoHidden:.5f isRelease:YES];
                        }
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
                
            }
                break;
            case 11://笔记修改|新文件上传
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {

                    if ([response.data isKindOfClass:[NSDictionary class]] && [[response.data objectForKey:@"result"] intValue]==1) {//成功
                        
//                        NSArray *a=[response.data objectForKey:@"fid"];
//                        int index=0;
//                        if (!a)
                        {
//                            [self setIsEditing:NO];
                            [self postNotification:[DYBNoteDetailViewController AutoRefreshTbvInViewWillAppear] withObject:Nil userInfo:Nil];
                            
                            for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
                                if ([vc isKindOfClass:[DYBTagNotesViewController class]]) {
                                    [self sendViewSignal:[DYBTagNotesViewController REFRESHTB] withObject:nil from:self target:(DYBTagNotesViewController *)vc];
                                    break;
                                }
                            }
                            
//                            [self refreshTabBar];
                            
                            {
                                MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                                [pop setDelegate:self];
                                [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                                [pop setText:@"修改成功"];
                                [pop alertViewAutoHidden:.5f isRelease:YES];
                            }
                            
                            [self.drNavigationController popViewControllerAnimated:YES];
                            
                            break;
                        }
//                        else{
////                            for (int i=2; i<[_tbvView DataSourceArray].count; i++) {//新model加上fid
////                                if (!((file_list *)[[_tbvView DataSourceArray] objectAtIndex:i]).fid) {
////                                    ((file_list *)[[_tbvView DataSourceArray] objectAtIndex:i]).fid=[a objectAtIndex:index];
////                                    index++;
////                                }
////                            }
////                            
////                            [self setIsEditing:NO];
//                        }
                       
                    }else{
                        _bt_Right.enabled=YES;
                        {
                            MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                            [pop setDelegate:self];
                            [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                            [pop setText:@"修改失败"];
                            [pop alertViewAutoHidden:.5f isRelease:YES];
                        }

                    }
                }else if ([response response] ==khttpfailCode){
                    {
                        MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
                        [pop setDelegate:self];
                        [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
                        [pop setText:@"删除失败"];
                        [pop alertViewAutoHidden:.5f isRelease:YES];
                    }
                    _bt_Right.enabled=YES;

                }
                
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark- 二次确认框
-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankShotView LEFT]]) {
        
    }
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        
        DYBDataBankShotView *source = (DYBDataBankShotView *)[signal source];
        
        switch (source.tag) {
            case -1://非wifi时点保存
            {
                [self addNewNoteOrEditNote];
                return;
            }
                break;
            case -2://转存
            {
                
                {//HTTP请求
                    MagicRequest *request = [DYBHttpMethod notes_dumpnote:_model.nid del:((SHARED.currentUserSetting.notesSaveForPush)?(@"1"):(@"2")) isAlert:YES receive:self];
                    [request setTag:2];
                }
                
                return;
            }
                break;
            default:
                break;
        }
        
        if (source.tag == 2) {
            
            MagicRequest *request = [DYBHttpMethod notes_delsharenote:shareId isAlert:YES receive:self];
            [request setTag:8];
            if (!request) {//无网路
                
            }
            return;
        }
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        //        NSString *text = [dict objectForKey:@"text"];
        NSString *type = [dict objectForKey:@"type"];
        //        NSNumber *row = [dict objectForKey:@"rowNum"];
        switch ([type integerValue]) {
            case BTNTAG_DEL:{//删除笔记
                
                NSIndexPath *index=(NSIndexPath *)source.indexPath;
                _tbvView.tbv.indexAfterRequest=index;
                noteModel *model=[_tbvView.tbv.muA_singelSectionData objectAtIndex:index.row];
                
                {//HTTP请求
                    MagicRequest *request = [DYBHttpMethod notes_delnote:model.nid isAlert:YES receive:self];
                    [request setTag:5];
                }
            }
                break;
            case BTNTAG_CANCELSHARE:{
            
            
                if (![MagicDevice hasInternetConnection]){
                    DLogInfo(@"确定是否网络连接");
                    return;
                }
                {//转存到资笔记
                    MagicRequest *request = [DYBHttpMethod notes_savesharenote:userId nid:_str_nid isAlert:YES receive:self];
                    [request setTag:7];
                    if (!request) {//无网路
                        
                    }
                }

            
            }
                break;
            default:
                break;
        }
    }
}


@end
