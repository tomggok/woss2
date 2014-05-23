//
//  DYBPersonalProfileViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBPersonalProfileViewController.h"
#import "UITableView+property.h"
#import "DYBCellForPersonalProfile.h"
#import "UIView+MagicCategory.h"
#import "user.h"
#import "DYBPagePickerView.h"
#import "PagePickerModel.h"
#import "scrollerData.h"
#import "school_list_all.h"
#import "NSDictionary+JSON.h"
#import "RegexKitLite.h"
#import "Magic_CommentMethod.h"
#import "DYBForgetPassWordViewController.h"
#import "DYBContributionValueViewController.h"
#import "UILabel+ReSize.h"

@interface DYBPersonalProfileViewController ()<PagePickDelegate>{
    
    
    DYBPagePickerView *pickerView;//pickerview
}

@end

@implementation DYBPersonalProfileViewController

@synthesize model=_model;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        //        {//HTTP请求
        //            [self.view setUserInteractionEnabled:NO];
        //            MagicRequest *request = [DYBHttpMethod user_perguest:[_d_model objectForKey:@"userid"] isAlert:YES receive:self];
        //            [request setTag:1];
        //
        //            if (!request) {//无网路
        //                [_tbv.footerView changeState:VIEWTYPEFOOTER];
        //            }
        //        }
        [self creatTbv];
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"个人资料"];
        [self backImgType:0];
        
        
//        [_tbv release_muA_differHeightCellView];
//        [_tbv releaseDataResource];
//        
//        
//        _tbv.muA_allSectionKeys=(([_model.userid isEqualToString:SHARED.curUser.userid])?([[NSMutableArray alloc]initWithObjects:@"基本资料",@"教育信息",@"个人隐私",@"社区信息", nil]):([[NSMutableArray alloc]initWithObjects:@"基本资料",@"教育信息",@"社区信息", nil]));
//        
//        if (([_model.userid isEqualToString:SHARED.curUser.userid])) {//自己的个人资料
//            _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@[_model,_model,_model,_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:0],@[_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:1],@[_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:2],(([_model.points intValue]>0/*贡献值==0时不显示此cell*/)?(@[_model,_model,_model,_model]):(@[_model,_model,_model])),[_tbv.muA_allSectionKeys objectAtIndex:3], nil];
//
//        }else{
//            _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@[_model,_model,_model,_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:0],@[_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:1],(([_model.points intValue]>0/*贡献值==0时不显示此cell*/)?(@[_model,_model,_model,_model]):(@[_model,_model,_model])),[_tbv.muA_allSectionKeys objectAtIndex:2], nil];
//        }
//        
//        [_tbv reloadData];
        
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv release_muA_differHeightCellView];

        REMOVEFROMSUPERVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}

#pragma mark- creatTbv
-(void)creatTbv{
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headHeight-kH_StateBar) isNeedUpdate:YES];
        _tbv._cellH=50;
        _tbv.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
        _tbv.tag=-1;
        _tbv._page=1;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tbv setTableViewType:DTableViewSlime];
//        _tbv.muA_allSectionKeys=[[NSMutableArray alloc]initWithObjects:@"基本资料",@"教育信息",@"个人隐私",@"社区信息", nil];
//        
//        _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@[_model,_model,_model,_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:0],@[_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:1],@[_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:2],(([_model.points intValue]>0/*贡献值==0时不显示此cell*/)?(@[_model,_model,_model,_model]):(@[_model,_model,_model])),[_tbv.muA_allSectionKeys objectAtIndex:3], nil];
        
        _tbv.muA_allSectionKeys=(([_model.userid isEqualToString:SHARED.curUser.userid])?([[NSMutableArray alloc]initWithObjects:@"基本资料",@"教育信息",@"个人隐私",@"社区信息", nil]):([[NSMutableArray alloc]initWithObjects:@"基本资料",@"教育信息",@"社区信息", nil]));
        
        if (([_model.userid isEqualToString:SHARED.curUser.userid])) {//自己的个人资料
            _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@[_model,_model,_model,_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:0],@[_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:1],@[_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:2],(([_model.points intValue]>INT32_MAX/*贡献值==0时不显示此cell*/)?(@[_model,_model,_model,_model]):(@[_model,_model,_model])),[_tbv.muA_allSectionKeys objectAtIndex:3], nil];
            
        }else{
            _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@[_model,_model,_model,_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:0],@[_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:1],(([_model.points intValue]>INT32_MAX/*贡献值==0时不显示此cell*/)?(@[_model,_model,_model,_model]):(@[_model,_model,_model])),[_tbv.muA_allSectionKeys objectAtIndex:2], nil];
        }
        
        [self.view addSubview:_tbv];
        RELEASE(_tbv);
        
        //        _tbv_friends_myConcern_RecentContacts.v_footerVForHide=[[DYBUITabbarViewController sharedInstace] containerView].tabBar;
        
    }
    
}

#pragma mark- 接受tbv信号

static NSString *cellName = @"cellName";//

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
//        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
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
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        NSMutableArray *arr_curSectionForCell=nil;
        NSMutableArray *arr_curSectionForModel=nil;
        
        if (![tableView isOneSection]) {//
            //多section时 _muA_differHeightCellView变成2维数组,第一维是 有几个section,第二维是每个section里有几个cell
            if (!tableView._muA_differHeightCellView) {
                tableView._muA_differHeightCellView=[[NSMutableArray alloc]initWithCapacity:[tableView.muD_allSectionValues allKeys].count];
            }
            
            if (tableView._muA_differHeightCellView.count==0) {
                for (int i=0; i<[tableView.muD_allSectionValues allKeys].count; i++) {
                    [tableView._muA_differHeightCellView addObject:[[NSMutableArray alloc]initWithCapacity:3]];
                }
            }
            
            //保存cell的当前section对应的array
            arr_curSectionForCell=(((NSMutableArray *)([tableView._muA_differHeightCellView objectAtIndex:indexPath.section])));
            
            //保存数据模型的当前section对应的array
            arr_curSectionForModel=[tableView.muD_allSectionValues objectForKey:[tableView.muA_allSectionKeys objectAtIndex:indexPath.section]];
        }
        
        if(indexPath.row==((([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)).count/*只创建没计算过的cell*/) || !tableView._muA_differHeightCellView || ((([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)).count/*只创建没计算过的cell*/)==0)
        {
            
            DYBCellForPersonalProfile *cell = [[[DYBCellForPersonalProfile alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[(([tableView isOneSection])?(tableView.muA_singelSectionData):(arr_curSectionForModel)) objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if (!tableView._muA_differHeightCellView) {
                tableView._muA_differHeightCellView=[[NSMutableArray alloc]initWithCapacity:[tableView.muD_allSectionValues allKeys].count];
            }
            
            if (![(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) containsObject:cell]) {
                [(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) addObject:cell];
            }
            
            NSNumber *s = [NSNumber numberWithInteger:cell.frame.size.height];
            [signal setReturnValue:s];
            
        }else{//之前计算过的cell
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForPersonalProfile *)[(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
            [signal setReturnValue:s];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
//        NSInteger section = [[dict objectForKey:@"section"] integerValue];
        
        if ([tableView isOneSection]) {/*一个section模式*/
            
        }else{
//            [signal setReturnValue:[tableView.muA_allSectionKeys objectAtIndex:section]];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if ([tableView isOneSection]) {/*一个section模式*/
        }else{
            [self createSectionHeaderView:signal];
        }
        
    }//
    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        [signal setReturnValue:[NSNumber numberWithFloat:((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(0):(50))]];
        
    }
    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell  只返回显示的cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if ([tableView isOneSection]) {/*一个section模式*/
            cell=((UITableViewCell *)[tableView._muA_differHeightCellView objectAtIndex:indexPath.row]);
        }else{
            //保存cell的当前section对应的array
            NSMutableArray *arr_curSectionForCell=(((NSMutableArray *)([tableView._muA_differHeightCellView objectAtIndex:indexPath.section])));
            cell=((UITableViewCell *)[arr_curSectionForCell objectAtIndex:indexPath.row]);
        }
        
        [signal setReturnValue:cell];
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row==6  && [_model.userid isEqualToString:SHARED.curUser.userid]) {//修改手机
                    DYBForgetPassWordViewController *con=[[DYBForgetPassWordViewController alloc]init];
                    [con setFather:self];
                    [con setType:1];
                    [self.drNavigationController pushViewController:con animated:YES];
                    RELEASE(con);
                }
            }
                break;
            case 3:
            {
//                if (indexPath.row==0) {//贡献值
//                    DYBContributionValueViewController *con=[[DYBContributionValueViewController alloc]init];
//                    [self.drNavigationController pushViewController:con animated:YES];
//                    RELEASE(con);
//                }
            }
                break;
            default:
                break;
        }
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
        
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
//        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
//        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        [_tbv reloadData:YES];
        
    }
    
    else if ([signal is:[MagicUITableView TABLESECTIONINDEXTITLESFORTABLEVIEW]])//右侧索引列表
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if (![tableView isOneSection]) {/*多个section模式*/
//            [signal setReturnValue:tableView.muA_allSectionKeys];
        }
    }else if ([signal is:[MagicUITableView TABLESECTIONFORSECTIONINDEXTITLE]])//点击右测是索引列表上的某个字母时回调,参数index和title是 右侧索引列表上被点击的字母在 索引列表的下标和名字,返回被点击的字母对应的section的下标
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSString *title = [dict objectForKey:@"title"];
//        NSInteger index = [[dict objectForKey:@"index"] integerValue];
        
        //在数据源的下标
        NSInteger count = 0;
        
        for(NSString *character in tableview.muA_allSectionKeys)
        {
            if([character isEqualToString:title])
            {
                [signal setReturnValue:[NSNumber numberWithInteger:count]];
                break;
            }
            count ++;
        }
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
        [self cancelPagePicker];
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [self cancelPagePicker];
    }
    else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){//点击事件
        
        [self cancelPagePicker];
    }
}

#pragma mark- 取消pickerview
- (void)cancelPagePicker
{
    if (pickerView.isShowView) {
//        NSLog(@"======%d",pickerView.tag);
        
        [pickerView cancelPicker];
        [pickerView setDelegate:nil];
        RELEASEVIEW(pickerView);
        
    }
    
}

#pragma mark- 创建sectionHeaderView
-(void)createSectionHeaderView:(MagicViewSignal *)signal
{
    NSDictionary *dict = (NSDictionary *)[signal object];
    UITableView *tableView = [dict objectForKey:@"tableView"];
    NSInteger section = [[dict objectForKey:@"section"] integerValue];
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    v.backgroundColor=[MagicCommentMethod color:255 green:255 blue:255 alpha:1];
    
    {
        MagicUILabel *lb_title=[[MagicUILabel alloc]initWithFrame:CGRectMake(25,0, 0, 0)];
        lb_title.backgroundColor=[UIColor clearColor];
        lb_title.textAlignment=NSTextAlignmentLeft;
        lb_title.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
        lb_title.text=[_tbv.muA_allSectionKeys objectAtIndex:section];
        [lb_title setNeedCoretext:NO];
        lb_title.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
        lb_title.numberOfLines=1;
        lb_title.lineBreakMode=NSLineBreakByCharWrapping;
        [lb_title sizeToFitByconstrainedSize:CGSizeMake(screenShows.size.width-20, 100)];
        [v addSubview:lb_title];
        [lb_title changePosInSuperViewWithAlignment:1];
        [lb_title setFrame:CGRectMake(CGRectGetMinX(lb_title.frame), CGRectGetMinY(lb_title.frame)+1, CGRectGetWidth(lb_title.frame), CGRectGetHeight(lb_title.frame))];

        RELEASE(lb_title);
    }
    
    [signal setReturnValue:v];
    //    [v release];
}

#pragma mark- UITextField
- (void)handleViewSignal_MagicUITextField:(MagicViewSignal *)signal
{
    if ([signal.source isKindOfClass:[MagicUITextField class]])//完成编辑
    {
        MagicUITextField *textField = [signal source];
        
        if ([signal is:[MagicUITextField TEXTFIELDDIDENDEDITING]])
        {
            
            
        }else if ([signal is:[MagicUITextField TEXTFIELD]])
        {
        }else if ([signal is:[MagicUITextField TEXTFIELDSHOULDRETURN]])
        {
            NSString *rex = @"[ ,，\\`,\\｀,\\~,\\～,\\!,\\！,\\@,\\@,\\#,\\＃,\\$,\\¥,\\%,\\％,\\^,\\⋯⋯,\\+,\\＋,\\*,\\＊,\\&,\\—,\\\\,\\、,\\/,\\／,\\?,\\？,\\|,\\｜,\\:,\\：,\\.,\\。,\\<,\\《,\\>,\\》,\\{,\\｛,\\},\\｝,\\(,\\（,\\),\\）,\\',\\‘,\\;,\\；,\\「,\\」,\\=,\\＝,\"]";
            BOOL isHaveSomg = [[nickTextField text] isMatchedByRegex:rex];
            
            if (isHaveSomg)
            {
                [DYBShareinstaceDelegate loadFinishAlertView:@"昵称不能含有特殊字符" target:self showTime:1.f];
            }else {
                
                NSInteger length = [MagicCommentMethod convertToInt:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                
                if (length > 16) {
                    [nickTextField setText:[_model name]];
                    [DYBShareinstaceDelegate loadFinishAlertView:@"账户字符长度超过16个字符" target:self showTime:1.f];
                }else if(length < 4){
                    [nickTextField setText:[_model name]];
                    [DYBShareinstaceDelegate loadFinishAlertView:@"账号字符长度少于4个字符" target:self showTime:1.f];
                }else{
                    if (![_model.name isEqualToString:[textField text]]) {
                        //修改昵称
                        MagicRequest *request = [DYBHttpMethod user_setnick:nickTextField.text isAlert:YES receive:self];
                        [request setTag:2];
                        [textField resignFirstResponder];
                        
                    }else {
                        
                        [textField resignFirstResponder];

                    }
                    
                    _tbv.userInteractionEnabled = YES;
                }
            }
            
            
            
        }
        
    }
    
    
}

//drangonuibutton  点击事件
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal
{
    
    NSDictionary *dict = (NSDictionary *)[signal object];
    nickTextField = [dict objectForKey:@"textfeild"];
    
    MagicUIButton *btn = signal.source;
    
    if (pickerView) {
        RELEASEVIEW(pickerView);
    }
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        
        //修改昵称
        if (btn.tag == 02) {
            
            nickTextField.userInteractionEnabled = YES;
            _tbv.userInteractionEnabled = NO;
            [nickTextField becomeFirstResponder];
            if (_tbv.contentOffset.y < 50) {
                
                [_tbv setContentOffset:CGPointMake(0, 50) animated:YES];
                
            }
            
        
        }
        //修改生日
        else if (btn.tag == 04) {
        
            pickerView = [[DYBPagePickerView alloc] initWithdelegate:CGRectMake(0, 50, 320, 200) style:PagePickerViewWithDate delegate:self];
            [pickerView showInView:self.view initString:/*messageUser*/[SHARED curUser].birthday];
            
        }
        //修改家乡
        if (btn.tag == 05) {
            pickerView = [[DYBPagePickerView alloc] initWithdelegate:CGRectMake(0, 50, 320, 200) style:PagePickerViewWithAreas delegate:self];
            [pickerView showInView:self.view initString:/*messageUser*/[SHARED curUser].hometown];
            
            
        }
        //修改手机
        if (btn.tag == 06) {
            DYBForgetPassWordViewController *vc = [[DYBForgetPassWordViewController alloc] init];
            [vc setType:1];
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
        }
        //修改学院
        if (btn.tag == 12) {
            
            MagicRequest *request = [DYBHttpMethod school_collegelist:@"123" isAlert:YES receive:self];
            [request setTag:-1];
            pickerView = [[DYBPagePickerView alloc] initWithdelegate:CGRectMake(0, 50, 320, 200) style:PagePickerViewWithCollege delegate:self];
            
            
        }
        //修改学入学年份
        if (btn.tag == 13) {
            
            pickerView = [[DYBPagePickerView alloc] initWithdelegate:CGRectMake(0, 50, 320, 200) style:PagePickerViewWithGetInSchool delegate:self];
            [pickerView showInView:self.view initString:/*messageUser*/_model.joinyear];
        }
        //修改主页对谁
        if (btn.tag == 20) {
            
            NSString *type = PICKERPRIVATEAP;
            if ([_model.visit_private isEqualToString:@"0"]) {
                type = PICKERPRIVATEAP;
            }else if ([_model.visit_private isEqualToString:@"1"]){
                type = PICKERPRIVATEOF;
            }else if ([_model.visit_private isEqualToString:@"2"]){
                type = PICKERPRIVATEOM;
            }else if ([_model.visit_private isEqualToString:@"3"]){
                type = PICKERPRIVATEFSS;
            }
            
            pickerView = [[DYBPagePickerView alloc] initWithdelegate:CGRectMake(0, 50, 320, 200) style:PagePickerViewWithPageWhoCanSee delegate:self];
            [pickerView showInView:self.view initString:type];
        }
        //修改生日对谁
        if (btn.tag == 21){
            
            
            NSString *type = PICKERPRIVATEOM;
            if ([_model.birthday_private isEqualToString:@"0"]) {
                type = PICKERPRIVATEOM;
            }else if ([_model.birthday_private isEqualToString:@"1"]){
                type = PICKERPRIVATEAP;
            }else if ([_model.birthday_private isEqualToString:@"2"]){
                type = PICKERPRIVATESM;
            }else if ([_model.birthday_private isEqualToString:@"3"]){
                type = PICKERPRIVATESD;
            }
            
            pickerView = [[DYBPagePickerView alloc] initWithdelegate:CGRectMake(0, 50, 320, 200) style:PagePickerViewWithBirthdayWhoCanSee delegate:self];
            [pickerView showInView:self.view initString:type];
        }
        //修改家乡对谁
        if (btn.tag == 22){
            
            NSString *type = PICKERPRIVATEOM;
            if ([[SHARED curUser].hometown_private isEqualToString:@"0"]) {
                type = PICKERPRIVATEOM;
            }else if ([_model.hometown_private isEqualToString:@"1"]){
                type = PICKERPRIVATEAP;
            }else if ([_model.hometown_private isEqualToString:@"2"]){
                type = PICKERPRIVATEFSS;
            }else if ([_model.hometown_private isEqualToString:@"3"]){
                type = PICKERPRIVATEOF;
            }
            
            pickerView = [[DYBPagePickerView alloc] initWithdelegate:CGRectMake(0, 50, 320, 200) style:PagePickerViewWithHometownWhoCanSee delegate:self];
            [pickerView showInView:self.view initString:type];
            
        }
        //修改家乡对谁
        if (btn.tag == 23){
            
            NSString *type = PICKERPRIVATEOM;
            if ([_model.phone_private isEqualToString:@"0"]) {
                
                type = PICKERPRIVATEOM;
            }else if ([_model.phone_private isEqualToString:@"1"]){
                type = PICKERPRIVATEAP;
            }else if ([_model.phone_private isEqualToString:@"2"]){
                type = PICKERPRIVATEFSS;
            }else if ([_model.phone_private isEqualToString:@"3"]){
                type = PICKERPRIVATEOF;
            }
            
            
            pickerView = [[DYBPagePickerView alloc] initWithdelegate:CGRectMake(0, 50, 320, 200) style:PagePickerViewWithMobileWhoCansee delegate:self];
            [pickerView showInView:self.view initString:type];
            
        }
    
    }
}

#pragma mark- 
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark - pagepickerDelegate
- (void)pickerDidEnd:(DYBPagePickerView *)picker pagePickertype:(PagePickerViewStyle)type{
    DLogInfo(@"picker === %@", picker.pageModel);
    DLogInfo(@"picker.pageModel.privateType === %@", picker.pageModel.privateType);
    /*self.pickerModel*/
    _pickerModel=picker.pageModel;
    [_pickerModel retain];//因为picker被removeFromSuperView了
    NSString *stringType = @"0";
    switch (type) {
        case 0:
            [self changeMyMessage:picker.pageModel.allCity type:1 tag:@"3"];
            break;
        case 1:
            [self changeMyMessage:picker.pageModel.yyyymmdd type:0 tag:@"4"];
            break;
        case 2:
            [self changeMyMessage:picker.pageModel.college type:2 tag:@"5"];
            break;
        case 3:
            [self changeMyMessage:picker.pageModel.getInYear type:3 tag:@"6"];
            break;
        case 4:
            
            if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEAP]) {
                stringType = @"0";
            }else if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEFSS]){
                stringType = @"3";
            }else if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEOF]){
                stringType = @"1";
            }else if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEOM]){
                stringType = @"2";
            }//个人主页
            /*picker.pageModel*/_pickerModel.privateType = stringType;
            [self changePrivate:stringType type:0 tag:@"7"];
            break;
        case 5:
            if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEAP]) {
                stringType = @"1";
            }else if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATESM]){
                stringType = @"2";
            }else if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATESD]){
                stringType = @"3";
            }else if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEOM]){
                stringType = @"0";
            }//生日
            /*picker.pageModel*/_pickerModel.privateType = stringType;
            [self changePrivate:stringType type:1 tag:@"8"];
            break;
        case 6:
            if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEAP]) {
                stringType = @"1";
            }else if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEFSS]){
                stringType = @"2";
            }else if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEOF]){
                stringType = @"3";
            }else if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEOM]){
                stringType = @"0";
            }//家乡
            /*picker.pageModel*/_pickerModel.privateType = stringType;
            [self changePrivate:stringType type:2 tag:@"9"];
            break;
        case 7:
            if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEAP]) {
                stringType = @"1";
            }else if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEFSS]){
                stringType = @"2";
            }else if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEOF]){
                stringType = @"3";
            }else if ([picker.pageModel.privateType isEqualToString:PICKERPRIVATEOM]){
                stringType = @"0";
            }//手机
            /*picker.pageModel*/_pickerModel.privateType = stringType;
            [self changePrivate:stringType type:3 tag:@"10"];
            break;
            
        default:
            break;
    }
    
}


//- (void)


//修改个人资料
- (void)changeMyMessage:(NSString *)value type:(NSInteger)type tag:(NSString *)tag{
    if (type == 3)
    {
        
        NSArray *arr = [[SHARED curUser].birthday componentsSeparatedByString:@"-"];
        if ([arr count] > 0)
        {
            if ([[arr objectAtIndex:0] integerValue] > [value integerValue])
            {
                [DYBShareinstaceDelegate loadFinishAlertView:@"入学年份早于生日年份，请重新选择" target:self showTime:1.f];
            }else
            {
                MagicRequest *request = [DYBHttpMethod user_setbase:value type:type isAlert:YES receive:self];
                [request setTag:[tag intValue]];
            }
        }
    }else
    {
        MagicRequest *request = [DYBHttpMethod user_setbase:value type:type isAlert:YES receive:self];
        [request setTag:[tag intValue]];
    }
   
//    [self addHttpHelpObjToArray:help];
    
}

//修改个人隐私
- (void)changePrivate:(NSString *)value type:(NSInteger)type tag:(NSString *)tag{
    
    MagicRequest *request = [DYBHttpMethod user_setdesc:value type:type isAlert:YES receive:self];
    [request setTag:[tag intValue]];
    
    
    //[self addHttpHelpObjToArray:help];
    
}


- (void)changPhone:(NSString *)phoneNum {
    
    
    [_model setPhone:phoneNum];
    
    [_tbv release_muA_differHeightCellView];
    [_tbv releaseDataResource];
    
    
    _tbv.muA_allSectionKeys=[[NSMutableArray alloc]initWithObjects:@"基本资料",@"教育信息",@"个人隐私",@"社区信息", nil];
    
    _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@[_model,_model,_model,_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:0],@[_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:1],@[_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:2],(([_model.points intValue]>0/*贡献值==0时不显示此cell*/)?(@[_model,_model,_model,_model]):(@[_model,_model,_model])),[_tbv.muA_allSectionKeys objectAtIndex:3], nil];
    
    
    [_tbv reloadData];
    
}


#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        
        //获取学院
        if (request.tag == -1) {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                collegeList = (college_list_all *)[response.data initDictionaryTo:[college_list_all class]];
                [pickerView setCollegeList:collegeList];
                [pickerView showInView:self.view initString:/*messageUser*/[SHARED curUser].college];
                [collegeList release];
                
            }
            else if ([response response] ==khttpfailCode){
                
                DLogInfo(@"=======%@",response.message);
                
            }
        }
        if (request.tag == 2 ||request.tag == 3 || request.tag == 4|| request.tag == 5|| request.tag == 6|| request.tag == 7|| request.tag == 8|| request.tag == 9|| request.tag == 10) {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode){
                //修改昵称
                if (request.tag == 2) {
                    [_model setName:nickTextField.text];
                }
                //修改家乡
                if (request.tag == 3) {
                    [_model setHometown:_pickerModel.allCity];
                }
                //修改生日
                if (request.tag == 4) {
                    [_model setBirthday:_pickerModel.yyyymmdd];
                    [_model setSx:_pickerModel.monthValue];
                }
                //修改学院
                if (request.tag == 5) {
                    [_model setCollege:_pickerModel.college];
                }
                //修改入学时间
                if (request.tag == 6) {
                    [_model setJoinyear:_pickerModel.getInYear];
                }
                //修改主页权限
                if (request.tag == 7) {
                    [_model setVisit_private:_pickerModel.privateType];
                }
                //修改生日权限
                if (request.tag == 8) {
                    [_model setBirthday_private:_pickerModel.privateType];
                }
                //修改家乡权限
                if (request.tag == 9) {
                    [_model setHometown_private:_pickerModel.privateType];
                }
                //修改手机权限
                if (request.tag == 10) {
                    [_model setPhone_private:_pickerModel.privateType];
                }
                
                
                
                
                [_tbv release_muA_differHeightCellView];
                [_tbv releaseDataResource];

                
                _tbv.muA_allSectionKeys=[[NSMutableArray alloc]initWithObjects:@"基本资料",@"教育信息",@"个人隐私",@"社区信息", nil];
                
                _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@[_model,_model,_model,_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:0],@[_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:1],@[_model,_model,_model,_model],[_tbv.muA_allSectionKeys objectAtIndex:2],(([_model.points intValue]>0/*贡献值==0时不显示此cell*/)?(@[_model,_model,_model,_model]):(@[_model,_model,_model])),[_tbv.muA_allSectionKeys objectAtIndex:3], nil];
                
                
                [_tbv reloadData];
                [self.view setUserInteractionEnabled:YES];
            }
            else if ([response response] ==khttpfailCode){
                
                DLogInfo(@"=======%@",response.message);
                [self.view setUserInteractionEnabled:YES];
                
            }
            
        }
        
    }
    
}




@end
