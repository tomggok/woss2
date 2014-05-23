//
//  DYBSendPrivateLetterViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSendPrivateLetterViewController.h"
#import "UITableView+property.h"
#import "DYBCellForSendPrivateLetter.h"
#import "chat.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "UIView+Animations.h"
#import "ext.h"
#import "UIImage+MagicCategory.h"
#import "Magic_UIUpdateView.h"
#import "UserSettingMode.h"
#import "Magic_Device.h"
#import "DYBRequest.h"
#import "NSString+Count.h"
#import "DYBCheckImageViewController.H"
#import "DYBMapLocationViewController.h"
#import "DYBPersonalHomePageViewController.h"
#import "DYBCheckMultiImageViewController.h"
#import "XiTongFaceCode.h"
#import "DYBWebViewController.h"

@interface DYBSendPrivateLetterViewController ()
{
    CGRect _originFrameForbottomView;//键盘抬起后_v_bottomView的originFrame
    BOOL _b_isCountingOriginFrame;//键盘变化后是否正在计算新的_v_bottomView.originFrame
    CGRect _originFrameAfterHideKeyBoard;//键盘收起前的高度为一行时的oriFrame
//    BOOL _b_isCountingOriginFrame;//键盘变化后是否正在计算新的_v_bottomView.originFrame
    BOOL b_isNeedScrollDownTbv;//是否需要把tbv滚到底部
}
@end

@implementation DYBSendPrivateLetterViewController

@synthesize model=_model,faceView = _faceView;

DEF_SIGNAL(SENDLOCATION);
DEF_SIGNAL(OPENURL);//打开链接

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        bONface = NO;
        cell_list = [[NSMutableArray alloc]init];
        
        NSString *_strContent = [self convertSystemEmoji:_v_inputV.textV.text];
        _strContent = [_strContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                       
        {
            _v_bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frameHeight-50, self.view.frame.size.width, 50)];
            _v_bottomView.backgroundColor=[UIColor whiteColor];//[MagicCommentMethod color:255 green:255 blue:255 alpha:0.8];
            _v_bottomView.alpha = 0.9;
//            _v_bottomView._originFrame=CGRectMake(CGRectGetMinX(_v_bottomView.frame), CGRectGetMinY(_v_bottomView.frame), CGRectGetWidth(_v_bottomView.frame), CGRectGetHeight(_v_bottomView.frame));
            [self.view addSubview:_v_bottomView];
            RELEASE(_v_bottomView);
            
        if (CGRectIsEmpty(_originFrameForbottomView)) {
            _originFrameForbottomView=CGRectMake(_v_bottomView.frame.origin.x, CGRectGetHeight(self.view.frame)-keyBoardSizeForIp.height-CGRectGetHeight(_v_bottomView.frame)-kH_StateBar, _v_bottomView.frame.size.width, _v_bottomView.frame.size.height);
            DLogInfo(@"%f",_originFrameForbottomView.origin.y);
            DLogInfo(@"%f",_originFrameForbottomView.size.height);

        }
            
        {
            UIImage *img=[UIImage imageNamed:@"txtbox_shadow"];
            UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, -(img.size.height/2), (img.size.width/2), (img.size.height/2)) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_bottomView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            [_v_bottomView addSubview:imgV];
            RELEASE(imgV);
        }
        }
        
        {
            UIImage *img= [UIImage imageNamed:@"sx_02"];
            _bt_add = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2)];
            _bt_add.tag=-1;
            [_bt_add addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_add setImage:img forState:UIControlStateNormal];
//            [_bt_add setImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
            [_v_bottomView addSubview:_bt_add];
            [_bt_add changePosInSuperViewWithAlignment:1];
            _bt_add.showsTouchWhenHighlighted=YES;
            _bt_add.backgroundColor=[UIColor clearColor];
            RELEASE(_bt_add);
        }
        
        {
            UIImage *img= [UIImage imageNamed:@"btn_quick_send_dis"];
            _bt_send = [[MagicUIButton alloc] initWithFrame:CGRectMake(_v_bottomView.frame.size.width-img.size.width/2, 0, img.size.width/2, img.size.height/2)];
            _bt_send.tag=-2;
            [_bt_send addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_send setImage:img forState:UIControlStateNormal];
            //            [_bt_add setImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
            [_v_bottomView addSubview:_bt_send];
            [_bt_send changePosInSuperViewWithAlignment:1];
            _bt_send.showsTouchWhenHighlighted=YES;
            _bt_send.backgroundColor=[UIColor clearColor];

            RELEASE(_bt_send);
        }
        
        {
            _v_inputV=[[DYBCustomInputView alloc]initWithFrame:CGRectMake(_bt_add.frame.origin.x+_bt_add.frame.size.width, 0, 220, _v_bottomView.frame.size.height-10) placeHolder:@""];
            _v_inputV.backgroundColor=[UIColor whiteColor];
            _v_inputV.layer.masksToBounds=YES;
            _v_inputV.layer.cornerRadius=3;
            _v_inputV.layer.borderWidth=1;
            _v_inputV.layer.borderColor=ColorCellSepL.CGColor;
            [_v_bottomView addSubview:_v_inputV];
            [_v_inputV changePosInSuperViewWithAlignment:1];
            _v_inputV._originFrame=CGRectMake(_v_inputV.frame.origin.x, _v_inputV.frame.origin.y, _v_inputV.frame.size.width, _v_inputV.frame.size.height);
            RELEASE(_v_inputV);
            [_v_inputV addkeyboardNotice];
//            [_v_inputV.textV becomeFirstResponder];
            
            lastLineNums=1;
        }
        [self creatTbv];
        
        [self.view bringSubviewToFront:_v_bottomView];
                
//        [MagicUIKeyboard sharedInstace];
//        [self observeNotification:[MagicUIKeyboard HEIGHT_CHANGED]];
//        [self observeNotification:[MagicUIKeyboard SHOWN]];
//        [self observeNotification:[MagicUIKeyboard HIDDEN]];
        
        {//HTTP
            [self.view setUserInteractionEnabled:YES];
            
            MagicRequest *request = [DYBHttpMethod message_chat_sixin:1 pageNum:_tbv.i_pageNums type:@"0" userid:[_model objectForKey:@"userid"] maxid:@"0" last_id:@"0" isAlert:YES receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
                //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
            }
        }
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle: [_model objectForKey:@"name"]];
        [self backImgType:0];
        
        if(!_imgV_headView){
            _imgV_headView = [[MagicUIImageView alloc] initWithFrame:CGRectMake(self.headview.frame.size.width-45, 15, 30, 30) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self.headview Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            [_imgV_headView setNeedRadius:YES];
            
            [_imgV_headView setImgWithUrl:[_model objectForKey:@"pic"] defaultImg:no_pic_50];
            RELEASE(_imgV_headView);
            
            chat *model1= [[[chat alloc]init] autorelease];
            NSDictionary *_dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:model1, @"model", @"我是点击的头像", @"type", nil];
            [_imgV_headView addSignal:[UIView TAP] object:_dicInfo];
        
            
//            {//遮罩
//                UIImage *img=[UIImage imageNamed:@"midface_mask_high"];
//                MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0,0, 30,30) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_imgV_headView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
//                RELEASE(imgV);
//            }
           
        }
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        REMOVEFROMSUPERVIEW(_imgV_headView);
        
        [_tbv release_muA_differHeightCellView];
        
//        REMOVEFROMSUPERVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}

#pragma mark-
-(void)creatTbv{
    
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headHeight-kH_StateBar-_v_bottomView.frame.size.height) isNeedUpdate:YES];//创建后_tbv.retainCount=5
//        _tbv._cellH=65;
        [_tbv setTableViewType:DTableViewSlime];//此句会让_tbv.retainCount++
        RELEASE(_tbv);
        [self.view addSubview:_tbv];
        _tbv.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
        _tbv.tag=-1;
        _tbv.i_pageNums=10;
        _tbv._page=1;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
//        {
//            UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _tbv.frame.size.width, _v_bottomView.frame.size.height)];
//            v.backgroundColor=[UIColor clearColor];
//            _tbv.tableFooterView=v;
//            RELEASE(v);
//
//        }
    }
    
}

#pragma mark- 接受tbv信号

static NSString *cellName = @"cellName";//前4个cell

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSInteger section = [[dict objectForKey:@"section"] integerValue];
        
        if ([tableView isOneSection]) {/*一个section模式*/
            NSNumber *s = [NSNumber numberWithInteger:tableView.muA_singelSectionData.count];
            [signal setReturnValue:s];
        }else if(tableView.muA_allSectionKeys.count>section){
            NSString *key = [tableView.muA_allSectionKeys objectAtIndex:section];
            NSArray *array = [tableView.muD_allSectionValues objectForKey:key];
            NSNumber *s = [NSNumber numberWithInteger:array.count];
            [signal setReturnValue:s];
        }
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if ([tableView isOneSection]) {/*一个section模式*/
            NSNumber *s = [NSNumber numberWithInteger:1];
            [signal setReturnValue:s];
        }else{
            NSNumber *s = [NSNumber numberWithInteger:tableView.muA_allSectionKeys.count];
            [signal setReturnValue:s];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath  暂时把每个cell保存,后期有时间优化为只保存高度,返回cell时再异步计算cell的视图,目前刷新后所有cell的view都要重新创建
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        MagicUITableView *tableView = [dict objectForKey:@"tableView"];
        
        DLogInfo(@"%@",indexPath);
        
        if(indexPath.row==tableView._muA_differHeightCellView.count/*只创建没计算过的cell*/ || !tableView._muA_differHeightCellView || [tableView._muA_differHeightCellView count]==0 || [[tableView._muA_differHeightCellView objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]/*反序插入cell*/)
        {//私信列表的cell
            
            DYBCellForSendPrivateLetter *cell = [[[DYBCellForSendPrivateLetter alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[_tbv.muA_singelSectionData objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if (!tableView._muA_differHeightCellView) {
                tableView._muA_differHeightCellView=[NSMutableArray arrayWithCapacity:10];
            }
            if (![tableView._muA_differHeightCellView containsObject:cell]) {
                if (tableView._muA_differHeightCellView.count==indexPath.row) {//
                    [tableView._muA_differHeightCellView addObject:cell];
                }else if([[tableView._muA_differHeightCellView objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]){//替换之前插入的null对象
                    [tableView._muA_differHeightCellView replaceObjectAtIndex:indexPath.row withObject:cell];
                }
                
                if ([tableView isOneSection]&&indexPath.row==tableView.i_pageNums-1 && !tableView.b_isreloadOver /*&& tableView._page==1*/) {//判断 单section下 新页是否reload完毕,如果完毕就滚到新页的最下边的cell
//                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView", indexPath, @"indexPath", nil];
//                    [tableView sendViewSignal:[MagicUITableView TAbLEVIERELOADOVER] withObject:dict];
                    tableView.b_isreloadOver=YES;

                    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                }
            }
            
            NSNumber *s = [NSNumber numberWithInteger:cell.frame.size.height];
            [signal setReturnValue:s];//cell.retainCount=2 才能被释放
        }else{//之前计算过的cell
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForSendPrivateLetter *)[tableView._muA_differHeightCellView objectAtIndex:indexPath.row]).frame.size.height];
            [signal setReturnValue:s];
        }
        
        if ([tableView isOneSection]&&indexPath.row==tableView.muA_singelSectionData.count-1 && !tableView.b_isreloadOver) {//加载完最后一个cell
            //                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView", indexPath, @"indexPath", nil];
            //                [tableView sendViewSignal:[MagicUITableView TAbLEVIERELOADOVER] withObject:dict];
            tableView.b_isreloadOver=YES;
            
            if (!b_isNeedScrollDownTbv) {
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }else{
                b_isNeedScrollDownTbv=NO;
            }
        
        }
        
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
    {
        //        NSDictionary *dict = (NSDictionary *)[signal object];
        //        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        [signal setReturnValue:nil];
        
    }//
    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
    {
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        
    }
    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell  只返回显示的cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:cellName];
        cell=((UITableViewCell *)[tableview._muA_differHeightCellView objectAtIndex:indexPath.row]);
        
        [signal setReturnValue:cell];
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//
    {
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        [tableView reloadData:YES];//避免 获取第一页后 滚动到最下边时 收到 加载更多信号后 没重置顶部刷新view
        tableView.b_isreloadOver=YES;
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//
    {
        
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        {//HTTP请求已加入的班级列表
            [self.view setUserInteractionEnabled:NO];
            
            MagicRequest *request = [DYBHttpMethod message_chat_sixin:++tableView._page pageNum:tableView.i_pageNums type:@"0" userid:[_model objectForKey:@"userid"] maxid:@"0" last_id:((chat *)[_tbv.muA_singelSectionData objectAtIndex:0]).id isAlert:YES receive:self];
            [request setTag:2];
            
            if (!request) {//无网路
                [tableView reloadData:NO];
            }
        }
    }
    
    else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
//        [self setVbottomView];

//        [_tbv StretchingUpOrDown:0];
//        [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];
//        if(tableView.b_isreloadOver && tableView.b_Dragging){//tbv被拖拽时才隐藏键盘
//            [_v_inputV.textV resignFirstResponder];
//        }
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
//        [self setVbottomView];
        
        if(tableView.b_isreloadOver && tableView.b_Dragging){//tbv被拖拽时才隐藏键盘
            
            if (_v_inputV.textV.isFirstResponder) {
                
                _originFrameAfterHideKeyBoard=CGRectMake(CGRectGetMinX(_v_bottomView._originFrame), /*CGRectGetMinY(_v_bottomView._originFrame)*/ CGRectGetHeight(self.view.frame)-keyBoardSizeForIp.height- CGRectGetHeight(_v_bottomView._originFrame), CGRectGetWidth(_v_bottomView._originFrame), CGRectGetHeight(_v_bottomView._originFrame));
                
                DLogInfo(@"%f",_originFrameAfterHideKeyBoard.origin.y);
                DLogInfo(@"%f",_originFrameAfterHideKeyBoard.size.height);

                [_v_inputV.textV resignFirstResponder];
                                
            }else {
                
                [self setVbottomView];
            }
    
        
        }
    }else if ([signal is:[MagicUITableView TAbLEVIERELOADOVER]])//reload完毕
    {

    }
    else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]])//reload完毕
    {
        if (_v_inputV.textV.isFirstResponder == YES) {
            [_v_inputV.textV resignFirstResponder];
        }else {
            
            [self setVbottomView];
        }
    }
    
    
}


//重设输入框的的frame
-(void)setVbottomView {
    
    if (_faceView) {
        REMOVEFROMSUPERVIEW(_faceView);
    }
    
    
    [_v_bottomView moveViewToFrame:CGRectMake(_v_bottomView.frame.origin.x, SCREEN_HEIGHT-_v_bottomView.frame.size.height-20, _v_bottomView.frame.size.width, _v_bottomView.frame.size.height) Duration:0.3 target:self AnimationsID:Nil AnimationDidStopSelector:Nil];
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_v_threeBtView setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) -kH_StateBar/*表情背景的Y固定*/, _v_threeBtView.frame.size.width, _v_threeBtView.frame.size.height)];
        
    }completion:^(BOOL b){//
        
        if (b) {
            if (_v_threeBtView) {
                REMOVEFROMSUPERVIEW(_bt_face);
                REMOVEFROMSUPERVIEW(_bt_photo);
                REMOVEFROMSUPERVIEW(_bt_location);
                
                REMOVEFROMSUPERVIEW(_v_threeBtView);
                if (_faceView) {
                    REMOVEFROMSUPERVIEW(_faceView);
                }
            }
            
            
        }
        
        
    }];
    
    
    
    
    
}




#pragma mark- 只接受UITextView信号
- (void)handleViewSignal_MagicUITextView:(MagicViewSignal *)signal
{
    keyboardY = NO;
    keyboardChange = 0;
    keyboardChangeNOW= 0;
    if ([signal is:[MagicUITextView TEXTVIEWSHOULDBEGINEDITING]])//textViewShouldBeginEditing
    {
        if (_v_threeBtView) {
            REMOVEFROMSUPERVIEW(_bt_face);
            REMOVEFROMSUPERVIEW(_bt_photo);
            REMOVEFROMSUPERVIEW(_bt_location);
            
            REMOVEFROMSUPERVIEW(_v_threeBtView);
            REMOVEFROMSUPERVIEW(_faceView);
        }
        if (_faceView) {
            REMOVEFROMSUPERVIEW(_faceView);
        }
        
//        _originFrameAfterHideKeyBoard=CGRectZero;
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDBEGINEDITING]])//textViewDidBeginEditing
    {
   
    }else  if ([signal is:[MagicUITextView TEXT_OVERFLOW]])//文字超长
    {
        [signal returnNO];
    }else  if ([signal is:[MagicUITextView TEXTVIEW]])//shouldChangeTextInRange
    {
        NSMutableDictionary *muD = (NSMutableDictionary *)[signal object];
        NSString *emString=[muD objectForKey:@"text"];
        
        if ([NSString isContainsEmoji:emString]) {
            
//            [signal setReturnValue:[MagicViewSignal NO_VALUE]];
        }else if ([emString isEqualToString:@"\\"]){
            
        }
        
        [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(sizeStatusSend) userInfo:nil repeats:NO];
       
        _originFrameAfterHideKeyBoard=CGRectZero;

    }
    else  if ([signal is:[MagicUITextView TEXTVIEWDIDCHANGE]])//textViewDidChange
    {
        if (_bt_add.selected) {
            keyboardChange = 1;
        }
        
      
        NSString *_strContent = [self convertSystemEmoji:_v_inputV.textV.text];
        _strContent = [_strContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        if(!_b_isCountingOriginFrame){
            
            
            CGSize size = [_v_inputV.textV.text sizeWithFont:[_v_inputV.textV font]];
            
            // 2. 取出文字的高度
            int length = size.height;
            
            //3. 计算行数
            
            int colomNumber = _v_inputV.textV.contentSize.height/length;
            
            if (length==0) {
                colomNumber=1;
            }
                        
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                if (colomNumber<=2 ) {//最多高度扩展3行,重置输入背景的frame
                    [_v_bottomView setFrame:CGRectMake(_v_bottomView.frame.origin.x, /*_v_bottomView._originFrame.origin.y CGRectGetMinY(_v_bottomView._originFrame) CGRectGetMinY(_originFrameForbottomView)*/ CGRectGetMinY(_v_bottomView._originFrame)-(colomNumber-1)*length, _v_bottomView.frame.size.width, CGRectGetHeight(_v_bottomView._originFrame)+(colomNumber-1)*length)];
                    
//                    if (lastLineNums>colomNumber) {//行数递减
//                        
//                        [_v_bottomView setFrame:CGRectMake(_v_bottomView.frame.origin.x, /*_v_bottomView._originFrame.origin.y CGRectGetMinY(_v_bottomView._originFrame) CGRectGetMinY(_originFrameForbottomView)*/ CGRectGetMinY(_v_bottomView._originFrame)+(colomNumber-1)*length, _v_bottomView.frame.size.width, CGRectGetHeight(_v_bottomView._originFrame)-(colomNumber-1)*length)];
//                        
//                    }else if(lastLineNums<colomNumber)
//                    {
//                        [_v_bottomView setFrame:CGRectMake(_v_bottomView.frame.origin.x, /*_v_bottomView._originFrame.origin.y CGRectGetMinY(_v_bottomView._originFrame) CGRectGetMinY(_originFrameForbottomView)*/ CGRectGetMinY(_v_bottomView._originFrame)+(colomNumber-1)*length, _v_bottomView.frame.size.width, CGRectGetHeight(_v_bottomView._originFrame)+(colomNumber-1)*length)];
//                    }
                    
                    [_bt_add setFrame:CGRectMake(_bt_add.frame.origin.x, _v_bottomView.frame.size.height-_bt_add.frame.size.height, _bt_add.frame.size.width, _bt_add.frame.size.height)];
                    [_bt_send setFrame:CGRectMake(_bt_send.frame.origin.x, _v_bottomView.frame.size.height-_bt_send.frame.size.height, _bt_send.frame.size.width, _bt_send.frame.size.height)];
                    
                    [_v_inputV setFrame:CGRectMake(_v_inputV.frame.origin.x, _v_inputV._originFrame.origin.y, _v_inputV.frame.size.width, _v_bottomView.frame.size.height-10)];
                    
                    //                sizeOfchange = _v_bottomView.frame.size.height - CGRectGetHeight(_originFrameForbottomView);
                    
                    //        DLogInfo(@"=========变化%d",sizeOfchange);
                }
            }completion:^(BOOL b){
                
                if (b) {
                    lastLineNums=colomNumber;
                }
                
            }];
            
        }
       
    }
}

- (void)sizeStatusSend {
    

    UIImage *img= [UIImage imageNamed:@"btn_quick_send"];
    UIImage *img1= [UIImage imageNamed:@"btn_quick_send_dis"];
    if (_v_inputV.textV.text.length < 1) {
        [_bt_send setImage:img1 forState:UIControlStateNormal];
    }else {
        [_bt_send setImage:img forState:UIControlStateNormal];
    }
    
    
}

//#pragma mark- 键盘改变前计算行数和input背景的frame
//-(void)countInputFrameBeforeKeyBoardChange:(int)timeInterval newFrame:(CGRect)newFrame
//{
//    CGSize size = [[_v_inputV.textV text] sizeWithFont:[_v_inputV.textV font]];
//    
//    // 2. 取出文字的高度
//    int length = size.height;
//    
//    //3. 计算行数
//    
//    int colomNumber = _v_inputV.textV.contentSize.height/length;
//    
//    if (length==0) {
//        colomNumber=1;
//    }
//    
//    [UIView animateWithDuration:timeInterval delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        
//        if (colomNumber<=2) {//最多高度扩展3行,重置输入背景的frame
//            [_v_bottomView setFrame:CGRectMake(_v_bottomView.frame.origin.x, /*_v_bottomView._originFrame.origin.y CGRectGetMinY(_v_bottomView._originFrame) CGRectGetMinY(_originFrameForbottomView)*/ CGRectGetMinY(newFrame)-(colomNumber-1)*length, _v_bottomView.frame.size.width, CGRectGetHeight(_originFrameForbottomView)+(colomNumber-1)*length)];
//            [_bt_add setFrame:CGRectMake(_bt_add.frame.origin.x, _v_bottomView.frame.size.height-_bt_add.frame.size.height, _bt_add.frame.size.width, _bt_add.frame.size.height)];
//            [_bt_send setFrame:CGRectMake(_bt_send.frame.origin.x, _v_bottomView.frame.size.height-_bt_send.frame.size.height, _bt_send.frame.size.width, _bt_send.frame.size.height)];
//            
//            [_v_inputV setFrame:CGRectMake(_v_inputV.frame.origin.x, _v_inputV._originFrame.origin.y, _v_inputV.frame.size.width, _v_bottomView.frame.size.height-10)];
//            
//        }
//    }completion:^(BOOL b){
//
//    }];
//    
//}

-(void)keyboardWillChangeFrame:(NSNotification*)notif{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
    NSValue *keyboardBoundsValue = [[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
#else
    NSValue *keyboardBoundsValue = [[notif userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
#endif
    CGRect keyboardEndRect = [keyboardBoundsValue CGRectValue];//键盘改变后的frame
    
    _b_isCountingOriginFrame=YES;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{//改变 _v_bottomView.y
        [_v_bottomView setFrame:CGRectMake(_v_bottomView.frame.origin.x, keyboardEndRect.origin.y-_v_bottomView.frame.size.height-kH_StateBar/*-2*/, _v_bottomView.frame.size.width, /*50+(colomNumber-1)*length*/ CGRectGetHeight(_v_bottomView.frame))];
    }completion:^(BOOL b){
        if (b ) {//每次键盘变化后改变_originFrame
            if (CGRectIsEmpty(_originFrameAfterHideKeyBoard))
            {
                DLogInfo(@"s  === %f", _v_bottomView.frame.origin.y);
                DLogInfo(@"w === %f", _originFrameForbottomView.origin.y-k_H_ChineseItems);
                CGFloat oY = (_v_bottomView.frame.origin.y>/*158*/ _originFrameForbottomView.origin.y-k_H_ChineseItems)?(/*194*/ _originFrameForbottomView.origin.y):(/*158*/ _originFrameForbottomView.origin.y-k_H_ChineseItems);
                
                oY = _v_bottomView.frame.origin.y;
                _v_bottomView._originFrame=CGRectMake(_v_bottomView.frame.origin.x, (oY), _v_bottomView.frame.size.width, /*_v_bottomView.frame.size.height*/50);//键盘中英文切换后都重置_originFrame
                DLogInfo(@"%f",_originFrameForbottomView.origin.y);
                DLogInfo(@"%f",_originFrameForbottomView.size.height);

            }
            else{
                _v_bottomView._originFrame=CGRectMake(_originFrameAfterHideKeyBoard.origin.x, _originFrameAfterHideKeyBoard.origin.y, _originFrameAfterHideKeyBoard.size.width,_originFrameAfterHideKeyBoard.size.height);
                if ((_v_inputV.textV.isFirstResponder)) {
                    _originFrameAfterHideKeyBoard=CGRectZero;
                }

            }
            _b_isCountingOriginFrame=NO;
            DLogInfo(@"%f",_v_bottomView._originFrame.origin.y);
            DLogInfo(@"%f",_v_bottomView._originFrame.size.height);

        }
    }];
    
    
}


#pragma mark- 接受按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        
        if (bt)
        {
            switch (bt.tag) {
                case -1://加号
                {
                    
                    if (_v_threeBtView) {
                        
                        if (_v_inputV.textV.isFirstResponder == YES) {
                            REMOVEFROMSUPERVIEW(_bt_face);
                            REMOVEFROMSUPERVIEW(_bt_photo);
                            REMOVEFROMSUPERVIEW(_bt_location);
                            
                            REMOVEFROMSUPERVIEW(_v_threeBtView);
                            REMOVEFROMSUPERVIEW(_faceView);
                        }
                        
                        
                    }
                    
                    if (_faceView) {
                         REMOVEFROMSUPERVIEW(_faceView);
                    }
                    
//                    if (bt.selected) {
                        [_v_inputV.textV resignFirstResponder];
                        
                        if (!_v_threeBtView) {
                            _v_threeBtView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frameHeight, self.view.frame.size.width, /*self.frameHeight-(_v_bottomView.frame.origin.y+_v_bottomView.frame.size.height*/ 80) ];
                            _v_threeBtView.backgroundColor=/*_v_bottomView.backgroundColor*/ColorWhite;
                            [self.view addSubview:_v_threeBtView];
                            RELEASE(_v_threeBtView);
                            
                            if (!_bt_face) {
                                UIImage *img= [UIImage imageNamed:@"sx_04"];
                                UIImage *img1= [UIImage imageNamed:@"sx_04_press"];
                                _bt_face = [[MagicUIButton alloc] initWithFrame:CGRectMake(25, 12, img.size.width/2, img.size.height/2)];
                                _bt_face.tag=-3;
                                [_bt_face addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                                [_bt_face setImage:img forState:UIControlStateNormal];
                                [_bt_face setImage:img1 forState:UIControlStateHighlighted];
                                //            [_bt_add setImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
                                [_v_threeBtView addSubview:_bt_face];
//                                [_bt_face changePosInSuperViewWithAlignment:1];
                                _bt_face.showsTouchWhenHighlighted=YES;
                                _bt_face.backgroundColor=[UIColor clearColor];
                                
                                RELEASE(_bt_face);
                            }
                            
                            if (!_bt_photo) {
                                UIImage *img= [UIImage imageNamed:@"sx_05"];
                                UIImage *img1= [UIImage imageNamed:@"sx_05_press"];
                                _bt_photo = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_face.frame.origin.x+_bt_face.frame.size.width+40, _bt_face.frame.origin.y, img.size.width/2, img.size.height/2)];
                                _bt_photo.tag=-4;
                                [_bt_photo addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                                [_bt_photo setImage:img forState:UIControlStateNormal];
                                [_bt_photo setImage:img1 forState:UIControlStateHighlighted];
                                //            [_bt_add setImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
                                [_v_threeBtView addSubview:_bt_photo];
                                //                                [_bt_face changePosInSuperViewWithAlignment:1];
                                _bt_photo.showsTouchWhenHighlighted=YES;
                                _bt_photo.backgroundColor=[UIColor clearColor];
                                
                                RELEASE(_bt_photo);
                            }
                            
                            if (!_bt_location) {
                                UIImage *img= [UIImage imageNamed:@"sx_06"];
                                UIImage *img1= [UIImage imageNamed:@"sx_06_press"];
                                _bt_location = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_photo.frame.origin.x+_bt_photo.frame.size.width+40, _bt_face.frame.origin.y, img.size.width/2, img.size.height/2)];
                                _bt_location.tag=-5;
                                [_bt_location addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                                [_bt_location setImage:img forState:UIControlStateNormal];
                                [_bt_location setImage:img1 forState:UIControlStateHighlighted];
                                //            [_bt_add setImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
                                [_v_threeBtView addSubview:_bt_location];
                                //                                [_bt_face changePosInSuperViewWithAlignment:1];
                                _bt_location.showsTouchWhenHighlighted=YES;
                                _bt_location.backgroundColor=[UIColor clearColor];
                                
                                RELEASE(_bt_location);
                            }
                            
                            //避免键盘收回后_v_bottomView移到底部
                            [_v_bottomView moveViewToFrame:CGRectMake(CGRectGetMinX(_v_bottomView.frame), CGRectGetHeight(self.view.frame)-CGRectGetHeight(_v_threeBtView.frame)-CGRectGetHeight(_v_bottomView.frame)-kH_StateBar /*CGRectGetMinY(_v_threeBtView.frame)-CGRectGetHeight(_v_bottomView.frame)*/, CGRectGetWidth(_v_bottomView.frame), CGRectGetHeight(_v_bottomView.frame)) Duration:0.3 target:self AnimationsID:Nil AnimationDidStopSelector:Nil];
                            _v_bottomView._originFrame=CGRectMake(CGRectGetMinX(_v_bottomView.frame), CGRectGetMinY(_v_bottomView.frame), CGRectGetWidth(_v_bottomView.frame), CGRectGetHeight(_v_bottomView.frame));
                            
                            
                            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                [_v_threeBtView setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - /*  keyBoardSizeForIp.height*/ CGRectGetHeight(_v_threeBtView.frame) -kH_StateBar/*表情背景的Y固定*/, _v_threeBtView.frame.size.width, _v_threeBtView.frame.size.height)];
                                
                            }completion:^(BOOL b){//
                            }];
                            
                            
                           
                        }
                    
                }
                    break;
                    
                case -2://发送
                if([_v_inputV couldSend]){//HTTP请求
//                    bt.selected=!bt.selected;
                    
//                    [self.view setUserInteractionEnabled:NO];
                    chat *model=nil;
                    {
                        model=[[chat alloc]init];
                        model.str_time=[NSString crearDateFormatter:1];
                        
                        DLogInfo(@"=====%@",model.str_time); 
                        
                        model.user_info=SHARED.curUser;
                        model.content=[_v_inputV.textV.text restoreEscapeCharacter];
                       
                        {
                            ext *_ext=[[ext alloc]init];
                            _ext.type=@"1";
                            model.ext=_ext;
                            RELEASE(_ext);
                        }
                        
                        DLogInfo(@"=====%d",[_tbv.muA_singelSectionData count]);
                        
                        if (!_tbv.muA_singelSectionData) {
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                        }else{
                            [_tbv.muA_singelSectionData addObject:model];
                        }
                        [model release];
                    }
                    
                    DLogInfo(@"=====%d",[_tbv.muA_singelSectionData count]);
                    
//                    [_v_inputV initShadeBt];
                    [_tbv reloadData:YES];
                    
                    indexRow = [_tbv.muA_singelSectionData count]-1;
                    
                    DYBCellForSendPrivateLetter *cell = (DYBCellForSendPrivateLetter *)[_tbv._muA_differHeightCellView objectAtIndex:indexRow];
                    cell._lb_time.hidden = YES;
                    cell._imagV_fail.hidden = YES;

                    
//                    if ([model.content isEqualToString:@"¥"]) {
//                        model.SucessSend=0;
//                        cell._imagV_fail.hidden = NO;
//                        [_v_inputV sendSuccess];
//                        return;
//                    }
                    
                    NSString *_strContent = [self convertSystemEmoji:_v_inputV.textV.text];
                    _strContent = [_strContent stringByReplacingOccurrencesOfString: @"\r" withString:@""];
                    _strContent = [_strContent stringByReplacingOccurrencesOfString: @"\n" withString:@""];
                    _strContent = [_strContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    MagicRequest *request = [DYBHttpMethod sendmessage:_strContent userid:[_model objectForKey:@"userid"] isAlert:YES receive:self];
                    [request setTag:3];
                    model.SucessSend=1;
                    
                    //避免发送中文后输入框降低
                    _originFrameForbottomView=CGRectMake(CGRectGetMinX(_v_bottomView.frame), CGRectGetMinY(_v_bottomView.frame), CGRectGetWidth(_v_bottomView.frame), CGRectGetHeight(_v_bottomView.frame));
                    
                    DLogInfo(@"%f",_originFrameForbottomView.origin.y);
                    DLogInfo(@"%f",_originFrameForbottomView.size.height);

                    if (!request) {//无网路
                        cell._imagV_fail.hidden = NO;
                        model.SucessSend=0;
                        
                        [self.view setUserInteractionEnabled:YES];
                        
                        if (_v_inputV.textV.isFirstResponder == YES) {
                            [_v_inputV.textV resignFirstResponder];
                        }
                        
                        //重新设置bottomView
                        [self setFramebottomView];
                        
//                        [_tbv setUpdateState:DUpdateStateNomal];
                    }
                    
                }
                    break;
                    
                case -3://表情
                {
                    
                    
                    [self show_face];
                }
                    break;
                case -4://拍照
                {
                    UIActionSheet *actionView = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"立刻拍照" otherButtonTitles:@"相册选择", nil];
                    [actionView showInView:self.view];
                    [actionView release];
                    
                }
                    break;
                case -5://订位
                {
                    
                    DYBMapLocationViewController *map = [[DYBMapLocationViewController alloc]init];
                    [map initMapLocation:YES];
                    [self.drNavigationController pushViewController:map animated:YES];
                }
                    break;
                case k_tag_fadeBt:
                {
                    DYBCustomInputView *intput=(DYBCustomInputView *)signal.object;
                    [intput cancelInput];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
    }
    
}

- (void)handleViewSignal_DYBSendPrivateLetterViewController:(MagicViewSignal *)signal{
    
    
    if ([signal is:[DYBSendPrivateLetterViewController OPENURL]]){
        
        NSString *streURL  = (NSString *)[signal object];
        DYBWebViewController *vc = [[DYBWebViewController alloc] init:streURL];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
    }
    if ([signal is:[DYBSendPrivateLetterViewController SENDLOCATION]]) {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *_address = [dict objectForKey:@"address"];
        NSString *_lat = [dict objectForKey:@"lat"];
        NSString *_lng = [dict objectForKey:@"lng"];
        
        chat *model=nil;
        {
            model=[[chat alloc]init];
            model.str_time=[NSString crearDateFormatter:1];
            model.user_info=SHARED.curUser;
            model.content =@"";
            model.photoImage=[UIImage imageNamed:@"map_mini.png"];
            model.SucessSend=1;
            {
                ext *_ext=[[ext alloc]init];
                _ext.type=@"2";
                _ext.address=_address;
                _ext.lat = _lat;
                _ext.lon = _lng;
                model.ext=_ext;
                RELEASE(_ext);
            }
            
            if (!_tbv.muA_singelSectionData) {
                _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                [_tbv.muA_singelSectionData retain];
            }else{
                [_tbv.muA_singelSectionData addObject:model];
            }
            [model release];
        }
        
        DLogInfo(@"=====%d",[_tbv.muA_singelSectionData count]);
        
        //                    [_v_inputV initShadeBt];
        [_tbv reloadData:YES];
        
        indexRow = [_tbv.muA_singelSectionData count]-1;
        
        DYBCellForSendPrivateLetter *cell = (DYBCellForSendPrivateLetter *)[_tbv._muA_differHeightCellView objectAtIndex:indexRow];
        cell._lb_time.hidden = YES;
        cell._imagV_fail.hidden = YES;
        
        
        MagicRequest *request = [DYBHttpMethod sendmessage2:[_model objectForKey:@"userid"] content:@"定位" type:@"2" lng:_lng lat:_lat address:_address speech_length:0 isAlert:YES receive:self];
        [request setTag:5];
        
        if (!request) {//无网路
            model.SucessSend=0;
            cell._imagV_fail.hidden = NO;
            [self.view setUserInteractionEnabled:YES];
            if (_v_inputV.textV.isFirstResponder == YES) {
                [_v_inputV.textV resignFirstResponder];
            }
            
            //重新设置bottomView
            [self setFramebottomView];

            //                        [_tbv setUpdateState:DUpdateStateNomal];
        }
    }

    
}

//弹出视图
-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    //文字删除和重新发送
    if (_showTag == 1) {
        if ([signal is:[DYBDataBankShotView RIGHT]]) {
            indexRow = saveExt.indexRow;
            MagicRequest *request = [DYBHttpMethod sendmessage:saveExt.content userid:[_model objectForKey:@"userid"] isAlert:YES receive:self];
            [request setTag:3];
            
            if (!request) {//无网路
                [self.view setUserInteractionEnabled:YES];
            }
            
        }
        if ([signal is:[DYBDataBankShotView LEFT]]) {
            indexRow = saveExt.indexRow;
            DLogInfo(@"=====第几行========%d",indexRow);
            
            [_tbv.muA_singelSectionData removeObjectAtIndex:indexRow];
            [_tbv release_muA_differHeightCellView];

            [_tbv reloadData:YES];
            
        }
    }
    //图片删除和重新发送
    if (_showTag == 2) {
        
        if ([signal is:[DYBDataBankShotView RIGHT]]) {
            
            indexRow = saveExt.indexRow;
            
            NSString *strTag = [self getRandomCode];
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(160.0f, 8.0f, 75.0f, 100.0f)];
            [imageview setImage:saveExt.photoImage];
            [imageview setTag:[strTag intValue]];
            [self.view addSubview:imageview];
            //    [imageview release];
            imageview.contentMode = UIViewContentModeScaleAspectFit;
            
            NSMutableDictionary  *params = [DYBHttpInterface sendmessage2:[_model objectForKey:@"userid"] content:@"图片" type:@"3" lng:nil lat:nil address:nil speech_length:nil];
            NSData *data = [self zipImg:imageview.image];
            RELEASEVIEW(imageview);
            
            NSArray *a = @[data];
            DYBRequest *request1 = [[DYBRequest alloc]init];;
            MagicRequest *request = [request1 DYBPOSTIMG:params isAlert:YES receive:self imageData:a];
            [request setTag:4];
            
            if (!request) {//无网路
                [self.view setUserInteractionEnabled:YES];
                //                        [_tbv setUpdateState:DUpdateStateNomal];
            }

            
        }
        
        if ([signal is:[DYBDataBankShotView LEFT]]) {
            indexRow = saveExt.indexRow;
            DLogInfo(@"=====第几行========%d",indexRow);
            
            [_tbv.muA_singelSectionData removeObjectAtIndex:indexRow];
            [_tbv release_muA_differHeightCellView];
            
            [_tbv reloadData:YES];
            
        }
    }
    //定位删除和重新发送v
    if (_showTag == 3) {
        
        if ([signal is:[DYBDataBankShotView RIGHT]]) {
            
            indexRow = saveExt.indexRow;
            MagicRequest *request = [DYBHttpMethod sendmessage2:[_model objectForKey:@"userid"] content:@"定位" type:@"2" lng:saveExt.ext.lon lat:saveExt.ext.lat address:saveExt.ext.address speech_length:0 isAlert:YES receive:self];
            [request setTag:5];
            
            if (!request) {//无网路
                [self.view setUserInteractionEnabled:YES];
                //                        [_tbv setUpdateState:DUpdateStateNomal];
            }
            
        }
        
        if ([signal is:[DYBDataBankShotView LEFT]]) {
            
            indexRow = saveExt.indexRow;
            DLogInfo(@"=====第几行========%d",indexRow);
            
            [_tbv.muA_singelSectionData removeObjectAtIndex:indexRow];
            [_tbv release_muA_differHeightCellView];
            
            
            [_tbv reloadData:YES];
        }
    }
    
    
}

#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal{
    if ([signal is:[UIView TAP]]) {
        [_v_inputV.textV resignFirstResponder];
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        [dict retain];
        
        chat *model = [[dict objectForKey:@"object"] objectForKey:@"model"];
        [model retain];
        saveExt = model;
        indexRow = saveExt.indexRow;
        NSString *type = [[dict objectForKey:@"object"] objectForKey:@"type"];
        
        DLogInfo(@"=======%@",model.content);
        DLogInfo(@"=======%@",type);
        
        
        DLogInfo(@"==model.ext.img_url=====%@",model.ext.img_url);
        
        if ([type isEqualToString:@"我是成功的-11111图片"]) {
            
            
            if (!model.ext.img_url &&model.photoImage) {
                
                DYBCheckImageViewController *vc = [[DYBCheckImageViewController alloc] initWithImage:model.photoImage];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
                
            }else {
                
                NSMutableArray *a = [[NSMutableArray alloc]init];;
                NSString *dict = model.ext.img_url;
                [a addObject:dict];
                
                DYBCheckMultiImageViewController *vc = [[DYBCheckMultiImageViewController alloc] initWithMultiImage:a nCurSel:0];
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
            }
            
        }else if([type isEqualToString:@"我是失败的-11111文字"]) {
            
            [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"重新发送" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
            _showTag = 1;
            
        }
        else if([type isEqualToString:@"我是失败的-11111图片"]) {
            
            [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"重新发送" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
            _showTag = 2;
            
            
        }
        else if([type isEqualToString:@"我是失败的-11111定位"]) {
            
            [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"重新发送" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL];
            _showTag = 3;
            
        }else if([type isEqualToString:@"我是点击的头像"]) {
            
            DYBPersonalHomePageViewController *vc = [[DYBPersonalHomePageViewController alloc] init];
            vc.d_model=[NSMutableDictionary dictionaryWithObjectsAndKeys:[_model objectForKey:@"name"],@"name",[_model objectForKey:@"userid"],@"userid", nil];
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
            
        }
        else if([type isEqualToString:@"我是成功的-11111定位"]){
            
            DYBMapLocationViewController *map = [[DYBMapLocationViewController alloc]initMapLocation:NO];
            [map ShowMulitAnnotation:model.ext.lat lng:model.ext.lon address:model.ext.address];
            [self.drNavigationController pushViewController:map animated:YES];
            RELEASE(map)
        }
    }
}

#pragma mark- 表情界面
-(void)show_face{
    
    if (!_faceView) {
        _faceView = [[DYBFaceView alloc]initWithFrame:CGRectMake(0, 600, 320, 200)];
        _faceView.delegate = self;
        [self.view addSubview:_faceView];
        RELEASE(_faceView)
    }
    
//    [self stopRecordPlay];
    bONface = YES;
//    [self hideKeyBoard];
    [self performSelector:@selector(face_start) withObject:nil afterDelay:0.2f];
//    [viewMoreFunction setHidden:YES];
//    input.morefunction.selected = NO;
}

-(void)hideKeyBoard{
    [_v_inputV.textV resignFirstResponder];
}

#pragma mark- 得到系统表情的key 集合

-(BOOL)checkIncludeString_string:(NSString*)str include_str:(NSString*)include_str{
    NSRange range = [str rangeOfString:include_str];
    if (range.length > 0) {
        return YES;
    }else{
        return NO;
    }
}

-(NSString *)convertSystemEmoji:(NSString *)orgString{
    NSString *strConvert = [NSString stringWithFormat:@"%@", orgString];
    
    if ([self checkIncludeString_string:strConvert include_str:@"\xe2\x98\xba"])
    {
        strConvert = [strConvert stringByReplacingOccurrencesOfString:@"\xe2\x98\xba" withString:@"[小嘴微笑]"];
    }
    
    if ([self checkIncludeString_string:strConvert include_str:@"\xe2\x9c\x8c"]) {
        strConvert = [strConvert stringByReplacingOccurrencesOfString:@"\xe2\x9c\x8c" withString:@"[胜利]"];
    }
    if ([self checkIncludeString_string:strConvert include_str:@"\xe2\x9c\x8a"]) {
        strConvert = [strConvert stringByReplacingOccurrencesOfString:@"\xe2\x9c\x8a" withString:@"[掌心拳]"];
    }
    
    if (strConvert.length > 0) {
        
        XiTongFaceCode * faceCode = [[XiTongFaceCode alloc]init];
        NSMutableDictionary* dictFace = [faceCode ServerToXiTong];
        for (int i = 0; i < [strConvert length] - 1; i++) {
            NSRange range = NSMakeRange(i, 2);
            NSString *tempStr = [strConvert substringWithRange:range];
            NSString *temp = [dictFace objectForKey:tempStr];
            if (temp) {
                strConvert = [strConvert stringByReplacingOccurrencesOfString:tempStr withString:temp];
            }
        }
        
        [faceCode release];
    }
    
    return strConvert;
}






-(void)face_start{
    
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_v_bottomView setFrame:CGRectMake(CGRectGetMinX(_v_bottomView.frame), CGRectGetHeight(self.view.frame)-CGRectGetHeight(_faceView.frame)-CGRectGetHeight(_v_bottomView.frame)-kH_StateBar /*CGRectGetMinY(_v_threeBtView.frame)-CGRectGetHeight(_v_bottomView.frame)*/, CGRectGetWidth(_v_bottomView.frame), CGRectGetHeight(_v_bottomView.frame))];
        
        [_faceView setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-CGRectGetHeight(_faceView.frame)-kH_StateBar, 320, 200)];
        
        
    }completion:^(BOOL b){
        if (b) {
            _v_bottomView._originFrame=CGRectMake(CGRectGetMinX(_v_bottomView.frame), CGRectGetMinY(_v_bottomView.frame), CGRectGetWidth(_v_bottomView.frame), CGRectGetHeight(_v_bottomView.frame));
            
            if (_v_threeBtView) {
                REMOVEFROMSUPERVIEW(_bt_face);
                REMOVEFROMSUPERVIEW(_bt_photo);
                REMOVEFROMSUPERVIEW(_bt_location);
                
                REMOVEFROMSUPERVIEW(_v_threeBtView);
            }
        }
        
    }];
}

-(void)selectFace:(id)sender{
    UIButton *tempbtn = (UIButton *)sender;
    NSMutableDictionary *tempdic = [_faceView.faces objectAtIndex:tempbtn.tag];
    NSArray *temparray = [tempdic allKeys];
    NSString *faceStr= [NSString stringWithFormat:@"%@",[temparray objectAtIndex:0]];
    NSArray *arrayTemp = [faceStr componentsSeparatedByString:@"/"];
    NSString *tempStr = [[[arrayTemp objectAtIndex:1] componentsSeparatedByString:@"]"] objectAtIndex:0];
    NSString *last = [[self getFaceCode] objectForKey:tempStr];
    //    NSString *Str = [view.text stringByAppendingString:last];
    
    NSString *beforeString = [self beforeString:_v_inputV.textV subString:last];
    _v_inputV.textV.text = [self subStringOperat:_v_inputV.textV subString:last beforeString:beforeString] ;
    
    int leng = _v_inputV.textV.text.length;
    if (leng > 140) {
        NSString *textTemp = [_v_inputV.textV.text substringWithRange:NSMakeRange(0, 140)];
        _v_inputV.textV.text = textTemp;
    }
    
    [self sizeStatusSend];
    
    //光标位置
    
    NSRange range = [_v_inputV.textV.text rangeOfString:beforeString];
    NSRange ragne1 = NSMakeRange(range.location+beforeString.length, 0);
    _v_inputV.textV.selectedRange = ragne1;
    
    
    CGSize size = [[_v_inputV.textV text] sizeWithFont:[_v_inputV.textV font]];
    
    // 2. 取出文字的高度
    int length = size.height;
    
    //3. 计算行数
    int colomNumber = _v_inputV.textV.contentSize.height/length;
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.1f];
    
    if (colomNumber<=2) {//最多高度扩展3行
//        [_v_bottomView setFrame:CGRectMake(_v_bottomView.frame.origin.x, /*_v_bottomView._originFrame.origin.y*/ CGRectGetMinY(_originFrameForbottomView)-(colomNumber-1)*length, _v_bottomView.frame.size.width, 50+(colomNumber-1)*length)];
        
        [_v_bottomView setFrame:CGRectMake(_v_bottomView.frame.origin.x, /*_v_bottomView._originFrame.origin.y*/ CGRectGetMinY(_v_bottomView._originFrame)-(colomNumber-1)*length, _v_bottomView.frame.size.width, CGRectGetHeight(_originFrameForbottomView)+(colomNumber-1)*length)];
        DLogInfo(@"%f",_originFrameForbottomView.origin.y);
        DLogInfo(@"%f",_originFrameForbottomView.size.height);

        [_bt_add setFrame:CGRectMake(_bt_add.frame.origin.x, _v_bottomView.frame.size.height-_bt_add.frame.size.height, _bt_add.frame.size.width, _bt_add.frame.size.height)];
        [_bt_send setFrame:CGRectMake(_bt_send.frame.origin.x, _v_bottomView.frame.size.height-_bt_send.frame.size.height, _bt_send.frame.size.width, _bt_send.frame.size.height)];
        
        [_v_inputV setFrame:CGRectMake(_v_inputV.frame.origin.x, _v_inputV._originFrame.origin.y, _v_inputV.frame.size.width, _v_bottomView.frame.size.height-10)];
        
        
//        sizeOfchange = _v_bottomView.frame.size.height - 50;
    }
    
    [UIView commitAnimations];
    
}

-(NSDictionary*)getFaceCode{
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"]];
    return dic ;
}

-(NSString* )beforeString:(UITextView* )textView subString :(NSString *)string{
    
    int location;
    if (textView.text.length < 1) {
        
        location = 0;
        
    }else {
        
        location = textView.selectedRange.location;
    }
    
    NSString*  beforeString = [textView.text substringToIndex:location];
    if (beforeString.length > 0) {
        beforeString = [beforeString stringByAppendingString:string];
    }else{
        beforeString = string;
    }
    
    return beforeString;
}

//操作字符串
-(NSString* )subStringOperat:(UITextView *)textView subString:(NSString*)string beforeString:(NSString *)beforeString{
    
    int location;
    if (textView.text.length < 1) {
        
        location = 0;
        
    }else {
        
        location = textView.selectedRange.location;
    }
    
    //    NSString *beforeString = [self beforeString:textView subString:string];
    NSString *afterSacn = [textView.text substringFromIndex:location];
    if (afterSacn.length > 0) {
        afterSacn = [beforeString stringByAppendingString:afterSacn];
    }else{
        
        afterSacn = beforeString;
        
    }
    
    return afterSacn;
    
}

#pragma mark- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:imagePicker animated:YES];
                [imagePicker release];
//                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyBoard) name:@"photoShowKeyBoard" object:nil];
                
            }
            break;
        case 1:{
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            [self presentModalViewController:imagePicker animated:YES];
            [imagePicker release];
//            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyBoard) name:@"photoShowKeyBoard" object:nil];
        }
            break;
        case 2:{
        }
    }
}

#pragma mark- UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissModalViewControllerAnimated:YES];
}

-(NSString *)getRandomCode{
    NSString *strRandom = nil;
    
    int value = arc4random()%200000;
    strRandom = [NSString stringWithFormat:@"%d", value];
    
    return strRandom;
    
}

//在滤镜页点击确定后回调
- (void)sendPhotoImage:(UIImage *)image {
    
    NSString *strTag = [self getRandomCode];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(160.0f, 8.0f, 75.0f, 100.0f)];
    [imageview setImage:image];
    [imageview setTag:[strTag intValue]];
    [self.view addSubview:imageview];
//    [imageview release];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    
    
    DLogInfo(@"=====userid====%@",[_model objectForKey:@"userid"]);
    
    NSMutableDictionary  *params = [DYBHttpInterface sendmessage2:[_model objectForKey:@"userid"] content:@"图片" type:@"3" lng:nil lat:nil address:nil speech_length:nil];
    NSData *data = [self zipImg:imageview.image];

//    NSData *data = UIImagePNGRepresentation(image);
    
    RELEASEVIEW(imageview);
    
    chat *model=nil;
    {
        model=[[chat alloc]init];
        model.str_time=[NSString crearDateFormatter:1];
        model.user_info=SHARED.curUser;
        model.content =@"";
        model.photoImage=image;
        model.SucessSend=1;

        {
            ext *_ext=[[ext alloc]init];
            _ext.type=@"3";
            model.ext=_ext;
            RELEASE(_ext);
        }
        
        if (!_tbv.muA_singelSectionData) {
            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
            [_tbv.muA_singelSectionData retain];
        }else{
            [_tbv.muA_singelSectionData addObject:model];
        }
        [model release];
    }
    
    
    DLogInfo(@"=====%d",[_tbv.muA_singelSectionData count]);
    
    //                    [_v_inputV initShadeBt];
    [_tbv reloadData:YES];
    
    indexRow = [_tbv.muA_singelSectionData count]-1;
    
    DYBCellForSendPrivateLetter *cell = (DYBCellForSendPrivateLetter *)[_tbv._muA_differHeightCellView objectAtIndex:indexRow];
    cell._lb_time.hidden = YES;
    cell._imagV_fail.hidden = YES;
    
    
    
    NSArray *a = @[data];
    DYBRequest *request1 = AUTORELEASE([[DYBRequest alloc] init]);
    MagicRequest *request = [request1 DYBPOSTIMG:params isAlert:YES receive:self imageData:a];
    [request setTag:4];
    
    if (!request) {//无网路
        model.SucessSend=0;
        cell._imagV_fail.hidden = NO;
        [self.view setUserInteractionEnabled:YES];
        
        if (_v_inputV.textV.isFirstResponder == YES) {
            [_v_inputV.textV resignFirstResponder];
        }
        
        //重新设置bottomView
        [self setFramebottomView];

        
        //                        [_tbv setUpdateState:DUpdateStateNomal];
    }
    
}

- (void) imagePickerController:(UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary*)info{
    _v_filter = [[DYBPhotoView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [_v_filter setFather:self];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
    if (reader.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将拍到的图片保存到相册
    }
    
    if ((reader.sourceType == UIImagePickerControllerSourceTypeCamera)) {
        [self manageImage:image];
        
    }else if((reader.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)){
        
        if (image.size.height<=self.view.bounds.size.height&&image.size.width<=self.view.bounds.size.width) {
            [_v_filter.rootImageView setFrame:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height)];
            [_v_filter.rootImageView setContentMode:UIViewContentModeScaleAspectFit];
            
            _v_filter.currentImage = image;
            
        }else if(!(image.size.height<=self.view.bounds.size.height)&&(image.size.width<=self.view.bounds.size.width))
        {
            [_v_filter.rootImageView setFrame:CGRectMake(0.0f, 0.0f, image.size.width*self.view.bounds.size.height/image.size.height, self.view.bounds.size.height)];
            [_v_filter.rootImageView setContentMode:UIViewContentModeScaleAspectFit];
            _v_filter.currentImage = image;
            
        }else if ((image.size.height<=self.view.bounds.size.height)&&!(image.size.width<=self.view.bounds.size.width)){
            
            [_v_filter.rootImageView setFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, image.size.height*320/image.size.width)];
            
            _v_filter.currentImage = image;
            
        }else{
            [self manageImage:image];
        }
    }
    [_v_filter.rootImageView setCenter:CGPointMake(160.0f,self.view.bounds.size.height/2-25)];
    
    
    _v_inputV.i_contentType = 3;
    
    _v_filter.rootImageView.image = _v_filter.currentImage;
    [self dismissModalViewControllerAnimated:YES];
    [self.view addSubview:_v_filter];
    
}

-(void)manageImage:(UIImage*)image{
    
    float ratX = image.size.width/320;
    float ratY = image.size.height/self.view.bounds.size.height;
    float lastRat =  1;
    
    if (ratX>ratY) {
        lastRat = ratX;
        [_v_filter.rootImageView setFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, image.size.height*320/image.size.width)];
        UIImage *smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(self.view.bounds.size.width*2, image.size.height*320/image.size.width*2) interpolationQuality:kCGInterpolationDefault];
        _v_filter.currentImage = smallImage;
        
    }else{
        lastRat = ratY;
        [_v_filter.rootImageView setFrame:CGRectMake(0.0f, 0.0f, image.size.width*self.view.bounds.size.height/image.size.height, self.view.bounds.size.height)];
        UIImage *smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(image.size.width*self.view.bounds.size.height/image.size.height*2, self.view.bounds.size.height*2) interpolationQuality:kCGInterpolationDefault];
        _v_filter.currentImage = smallImage;
        
    }
    _v_filter.rootImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
}
-(UIImage *)newImage:(UIImage*)iamge newSize:(CGSize)newSize{
    UIImageView *view  = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
    [view setImage:iamge];
    return view.image;
    
    
}

-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);//根据当前大小创建一个基于位图图形的环境
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];//根据新的尺寸画出传过来的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
    UIGraphicsEndImageContext();//关闭当前环境
    return newImage;
}

- (void)setFramebottomView {
    
    if (_faceView) {
        RELEASEALLSUBVIEW(_faceView);
    }
    
    if (_v_threeBtView) {
        REMOVEFROMSUPERVIEW(_bt_face);
        REMOVEFROMSUPERVIEW(_bt_photo);
        REMOVEFROMSUPERVIEW(_bt_location);
        if (_faceView) {
            RELEASEALLSUBVIEW(_faceView);
        }
        REMOVEFROMSUPERVIEW(_v_threeBtView);
    }
    
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_v_bottomView setFrame:CGRectMake(_v_bottomView.frame.origin.x, CGRectGetHeight(self.view.frame)-50, _v_bottomView.frame.size.width, 50)];
    }completion:^(BOOL b){
        if (b) {
            _v_bottomView._originFrame=CGRectMake(CGRectGetMinX(_v_bottomView.frame), CGRectGetMinY(_v_bottomView.frame), CGRectGetWidth(_v_bottomView.frame), CGRectGetHeight(_v_bottomView.frame));
            _originFrameForbottomView=CGRectMake(CGRectGetMinX(_v_bottomView.frame), CGRectGetMinY(_v_bottomView.frame), CGRectGetWidth(_v_bottomView.frame), CGRectGetHeight(_v_bottomView.frame));
            DLogInfo(@"%f",_originFrameForbottomView.origin.y);
            DLogInfo(@"%f",_originFrameForbottomView.size.height);

        }
    }];
    
    
    [_bt_add setFrame:CGRectMake(_bt_add.frame.origin.x, _v_bottomView.frame.size.height-_bt_add.frame.size.height, _bt_add.frame.size.width, _bt_add.frame.size.height)];
    [_bt_send setFrame:CGRectMake(_bt_send.frame.origin.x, _v_bottomView.frame.size.height-_bt_send.frame.size.height, _bt_send.frame.size.width, _bt_send.frame.size.height)];
    [_v_inputV setFrame:CGRectMake(_v_inputV.frame.origin.x, _v_inputV._originFrame.origin.y, _v_inputV.frame.size.width, _v_bottomView.frame.size.height-10)];
    
    {
        [_v_inputV sendSuccess];
        [_v_inputV cancelInput];
        
        
    }
    
    [self sizeStatusSend];

}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    DLogInfo(@"==========%@",response.data);
                    
                    NSArray *list=[response.data objectForKey:@"chat"];
                    
                    if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                        [_tbv.muA_singelSectionData removeAllObjects];
                        
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        chat *model = [[chat JSONReflection:d] autorelease/*避免_tbv.muA_singelSectionData释放时model没释放*/];
                        model.SucessSend=1;
                        if (!_tbv.muA_singelSectionData) {
                            [self creatTbv];
                            
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];//此句执行后 model.retainCount=2
                            [_tbv.muA_singelSectionData retain];
                        }else{
                            [_tbv.muA_singelSectionData addObject:model];
                        }
                        
//                        RELEASE(model);//避免model不被释放
                    }
                    
                    {
                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                            [_tbv._muA_differHeightCellView removeAllObjects];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
                        }
                        
                    }
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
                
            }
                
                break;
                
            case 2://加载更多
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"chat"];
                    int index=0;
                    for (NSDictionary *d in list) {
                        chat *model = [[chat JSONReflection:d] autorelease/*避免_tbv.muA_singelSectionData释放时model没释放*/];
                        model.SucessSend=1;

                        if (!_tbv.muA_singelSectionData) {
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                        }else{
                            [_tbv.muA_singelSectionData insertObject:model atIndex:index];
                            [_tbv._muA_differHeightCellView insertObject:[NSNull null] atIndex:index];//先把cell占着,在计算高度时被真正的cell替换
                        }
                        
                        index++;
                    }
                    
                    {//加载更多
                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
//                            [_tbv release_muA_differHeightCellView];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                b_isNeedScrollDownTbv=YES;
                                [_tbv reloadData:YES];

                            }
                        }else{//没获取到数据,恢复headerView
//                            [_tbv reloadData:YES];
                            [_tbv changeSmlimeUpdateState:DUpdateStateNomal];

                            [DYBShareinstaceDelegate loadFinishAlertView:@"加载全部" target:self showTime:1.f];
                        }
                        
                    }
                    
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode)
                {
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
//                [_tbv.footerView changeState:PULLSTATEEND];
                
                
            }
                break;
            case 3://发私信
            {
                
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    if ([[response.data objectForKey:@"send"] isEqualToString:@"1"]) {//成功
                        
                        //重新设置bottomView
                        [self setFramebottomView];
                        
                        DYBCellForSendPrivateLetter *cell = (DYBCellForSendPrivateLetter *)[_tbv._muA_differHeightCellView objectAtIndex:indexRow];
                        cell._lb_time.hidden = NO;
                        cell._imagV_fail.hidden = YES;
                        
                        [_tbv reloadData:YES];
                        return;
                    }else{
                        [_tbv.muA_singelSectionData removeLastObject];
                    }
                    
                    
                }else if ([response response] ==khttpfailCode)
                {
                    
                    DYBCellForSendPrivateLetter *cell = (DYBCellForSendPrivateLetter *)[_tbv._muA_differHeightCellView objectAtIndex:indexRow];
                    cell._lb_time.hidden = YES;
//                    [_tbv]; [_tbv.muA_singelSectionData objectAtIndex:[[_tbv.muA_singelSectionData count]-1]];
                    return;
                    
                }else if ([response response] ==khttpWrongfulCode){//参数不合法,修正 不能发¥ 符号
                    
                    {
                        chat *model=[_tbv.muA_singelSectionData lastObject];
                        model.SucessSend=0;
                        [_v_inputV sendSuccess];
                    }
                }
                
                DYBCellForSendPrivateLetter *cell = (DYBCellForSendPrivateLetter *)[_tbv._muA_differHeightCellView objectAtIndex:indexRow];
                cell._lb_time.hidden = YES;
                cell._imagV_fail.hidden = NO;
                [_tbv reloadData:YES];
//                [_tbv.muA_singelSectionData removeLastObject];

                [self.view setUserInteractionEnabled:YES];
                
            }
                break;
            case 4://发图片
            case 5://定位
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    DLogInfo(@"=======%@",response.message);
                    if ([[response.data objectForKey:@"send"] isEqualToString:@"1"]) {//成功
                        
                        
                        //重新设置bottomView
                        [self setFramebottomView];
                        
                        DYBCellForSendPrivateLetter *cell = (DYBCellForSendPrivateLetter *)[_tbv._muA_differHeightCellView objectAtIndex:indexRow];
                        cell._lb_time.hidden = NO;
                        cell._imagV_fail.hidden = YES;
                        
                        chat *model=[_tbv.muA_singelSectionData lastObject];
                        model.ext.img_url=[response.data objectForKey:@"url"];
                        
//                        [_tbv release_muA_differHeightCellView];
                        [_tbv reloadData:YES];
                        //                        [self.view setUserInteractionEnabled:YES];
                        return;
                    }else{
                        [_tbv.muA_singelSectionData removeLastObject];
                    }
                    
                    
                }else if ([response response] ==khttpfailCode)
                {
                    DLogInfo(@"=======%@",response.message);
                    DYBCellForSendPrivateLetter *cell = (DYBCellForSendPrivateLetter *)[_tbv._muA_differHeightCellView objectAtIndex:indexRow];
                    cell._lb_time.hidden = YES;
                    return;
                    
//                    DLogInfo(@"=======%@",response.message);
                }
                
//                [_tbv.muA_singelSectionData removeLastObject];
                
                
                DYBCellForSendPrivateLetter *cell = (DYBCellForSendPrivateLetter *)[_tbv._muA_differHeightCellView objectAtIndex:indexRow];
                cell._lb_time.hidden = YES;
                cell._imagV_fail.hidden = NO;
                [_tbv reloadData:YES];
                //                [_tbv.muA_singelSectionData removeLastObject];
                
                [self.view setUserInteractionEnabled:YES];
                
                
            }
                break;
                
            default:
                break;
        }
    }
}

@end
