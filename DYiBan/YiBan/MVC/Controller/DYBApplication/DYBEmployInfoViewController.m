//
//  DYBEmployInfoViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBEmployInfoViewController.h"
#import "DYBMenuView.h"
#import "UIView+MagicCategory.h"
#import "UITableView+property.h"
#import "EmployInfo.h"
#import "DYBCellForEmployAndMyCollect.h"
#import "DYBDynamicViewController.h"
#import "DYBEmployInfoDetailViewController.h"

@interface DYBEmployInfoViewController ()
{
    DYBMenuView *_tbv_dropDown;//下拉列表
    MagicUIButton *_bt_DropDown/*下拉按钮*/,*_bt_fullTime/*全职*/,*_bt_practice/*实习*/ ;
    BOOL bPullDown;
    MagicUITableView *_tbv;
    MagicUISearchBar *_search;
    UIView *_v_btBack;
    NSMutableArray *_muA_editorRecommend/*小编推荐数据源*/,*_muA_newOffer/*最新职位数据源*/,*_muA_myCollect/*我的收藏数据源*//*,*_muA_searchResult搜索结果*/;
    DYBCustomLabel *_lb_ViewNums/*按浏览量*/,*_lb_collectNums/*按收藏量*/,*_lb_publishTime/*按发布时间*/;
    int _i_order/*1、点击量排序；2、收藏量排序；3、发布时间排序。默认3*/,_i_cellType/*0:就业信息cell 1:我的收藏cell 2:搜索结果cell*/;
    int nSelMenu;
    MagicUIButton *TraparentView;

}
@end

@implementation DYBEmployInfoViewController

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        [self creatTbv];
        
        if (!_search) {
            _search=[[MagicUISearchBar alloc]initWithFrame:CGRectMake(0, self.headHeight, self.view.frame.size.width, 50) backgroundColor:ColorNav placeholder:@"" isHideOutBackImg:YES isHideLeftView:NO];
            _search._originFrame=CGRectMake(CGRectGetMinX(_search.frame), CGRectGetMinY(_search.frame), CGRectGetWidth(_search.frame), CGRectGetHeight(_search.frame));
            [_search customBackGround:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_search"]] autorelease]];
            _search.tag=-1;
            [self.view addSubview:_search];
            [_search release];
        }
        
        _i_order=3;
        
        {//HTTP请求
            [self.view setUserInteractionEnabled:NO];
            
            MagicRequest *request = [DYBHttpMethod job_list_page:1 num:_tbv.i_pageNums order:[NSString stringWithFormat:@"%d",_i_order] isAlert:YES receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
                //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
            }
        }
        
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"就业信息"];
        [self backImgType:0];
        
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
            
            [self.headview setTitleArrow];
            
        }
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        RELEASEDICTARRAYOBJ(_muA_editorRecommend);
        RELEASEDICTARRAYOBJ(_muA_myCollect);

        RELEASEDICTARRAYOBJ(_muA_newOffer);

        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv release_muA_differHeightCellView];
        
        REMOVEFROMSUPERVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}

#pragma mark- creatTbv
-(void)creatTbv{
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight+50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headHeight-50-kH_StateBar) isNeedUpdate:YES];
        _tbv._originFrame=CGRectMake(0, CGRectGetMinY(_tbv.frame), CGRectGetWidth(_tbv.frame), CGRectGetHeight(_tbv.frame));
        _tbv._cellH=42;
        [self.view addSubview:_tbv];
        _tbv.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
        _tbv.tag=-1;
        _tbv._page=1;
        _tbv.i_pageNums=10;
//        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tbv setTableViewType:DTableViewSlime];
        RELEASE(_tbv);
        
        _tbv.muA_allSectionKeys=[[NSMutableArray alloc]initWithObjects:@"小编推荐",@"最新职位", nil];
        _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSMutableArray arrayWithCapacity:10],[_tbv.muA_allSectionKeys objectAtIndex:0],[NSMutableArray arrayWithCapacity:10],[_tbv.muA_allSectionKeys objectAtIndex:1], nil];

    }
    
}

#pragma mark- 创建sectionHeaderView
-(void)createSectionHeaderView:(MagicViewSignal *)signal
{
    NSDictionary *dict = (NSDictionary *)[signal object];
    UITableView *tableView = [dict objectForKey:@"tableView"];
    NSInteger section = [[dict objectForKey:@"section"] integerValue];
    
    UIImage *img=[UIImage imageNamed:@"graybar_blank.png.png"];
    MagicUIImageView *_imgV_Back = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:nil Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    
    switch (section) {
        case 0://小编推荐   
        {
            UIImage *img1=[UIImage imageNamed:@"icon_rec.png"];

            MagicUIImageView *_imgV = [[MagicUIImageView alloc] initWithFrame:CGRectMake(10, 0, img1.size.width/2,img1.size.height/2) backgroundColor:[UIColor clearColor] image:img1 isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_imgV_Back Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            RELEASE(_imgV);
        }
            break;
        case 1://最新职位
        {
            {//最新职位
                DYBCustomLabel *_lb_content=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(10, 0, 0,0)];
                _lb_content.backgroundColor=[UIColor clearColor];
                _lb_content.textAlignment=NSTextAlignmentLeft;
                _lb_content.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
                _lb_content.text=@"最新职位";
                _lb_content.textColor=ColorGray;
                _lb_content.numberOfLines=1;
                _lb_content.lineBreakMode=NSLineBreakByTruncatingTail;
                [_lb_content sizeToFitByconstrainedSize:CGSizeMake(_imgV_Back.frame.size.width-_lb_content.frame.origin.x-30,1000)];
                [_imgV_Back addSubview:_lb_content];
                [_lb_content changePosInSuperViewWithAlignment:1];
                _lb_content.shadowColor = [UIColor whiteColor];
                _lb_content.shadowOffset = CGSizeMake(1, 1);
                RELEASE(_lb_content);
                
                {//按 浏览量
                    _lb_ViewNums=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lb_content.frame)+20, 0, 0,0)];
                    _lb_ViewNums.backgroundColor=[UIColor clearColor];
                    _lb_ViewNums.textAlignment=NSTextAlignmentLeft;
                    _lb_ViewNums.font=[DYBShareinstaceDelegate DYBFoutStyle:12];
                    _lb_ViewNums.text=@"按浏览量";
                    _lb_ViewNums.textColor=((_i_order==1)?(ColorBlue):(ColorBlack));
                    _lb_ViewNums.numberOfLines=1;
                    _lb_ViewNums.lineBreakMode=NSLineBreakByTruncatingTail;
                    [_lb_ViewNums sizeToFitByconstrainedSize:CGSizeMake(_imgV_Back.frame.size.width-_lb_ViewNums.frame.origin.x-30,1000)];
                    [_imgV_Back addSubview:_lb_ViewNums];
                    [_lb_ViewNums changePosInSuperViewWithAlignment:1];
                    RELEASE(_lb_ViewNums);
                    _lb_ViewNums.clipsToBounds=NO;
                    [_lb_ViewNums addSignal:[UIView TAP] object:nil];
                    
                    UIImage *img2=[UIImage imageNamed:((_i_order==1)?(@"arrow_down"):(@"arrow_down_a"))];//下箭头
                    MagicUIImageView *_imgV2 = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_lb_ViewNums.frame), 0, img2.size.width/2,img2.size.height/2) backgroundColor:[UIColor clearColor] image:img2 isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_lb_ViewNums Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    _imgV2.tag=1;
                    RELEASE(_imgV2);
                }
                
                {//按 收藏
                    _lb_collectNums=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lb_ViewNums.frame)+20, 0, 0,0)];
                    _lb_collectNums.backgroundColor=[UIColor clearColor];
                    _lb_collectNums.textAlignment=NSTextAlignmentLeft;
                    _lb_collectNums.font=[DYBShareinstaceDelegate DYBFoutStyle:12];
                    _lb_collectNums.text=@"按收藏量";
                    _lb_collectNums.textColor=((_i_order==2)?(ColorBlue):(ColorBlack));
                    _lb_collectNums.numberOfLines=1;
                    _lb_collectNums.lineBreakMode=NSLineBreakByTruncatingTail;
                    [_lb_collectNums sizeToFitByconstrainedSize:CGSizeMake(_imgV_Back.frame.size.width-_lb_collectNums.frame.origin.x-30,1000)];
                    [_imgV_Back addSubview:_lb_collectNums];
                    [_lb_collectNums changePosInSuperViewWithAlignment:1];
                    RELEASE(_lb_collectNums);
                    _lb_collectNums.clipsToBounds=NO;
                    [_lb_collectNums addSignal:[UIView TAP] object:nil];

                    UIImage *img2=[UIImage imageNamed:((_i_order==2)?(@"arrow_down"):(@"arrow_down_a"))];//黑色下箭头
                    MagicUIImageView *_imgV2 = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_lb_collectNums.frame), 0, img2.size.width/2,img2.size.height/2) backgroundColor:[UIColor clearColor] image:img2 isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_lb_collectNums Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    _imgV2.tag=1;
                    RELEASE(_imgV2);
                }
                
                {//按 发布时间
                    _lb_publishTime=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lb_collectNums.frame)+20, 0, 0,0)];
                    _lb_publishTime.backgroundColor=[UIColor clearColor];
                    _lb_publishTime.textAlignment=NSTextAlignmentLeft;
                    _lb_publishTime.font=[DYBShareinstaceDelegate DYBFoutStyle:12];
                    _lb_publishTime.text=@"按发布时间";
                    _lb_publishTime.textColor=((_i_order==3)?(ColorBlue):(ColorBlack));
                    _lb_publishTime.numberOfLines=1;
                    _lb_publishTime.lineBreakMode=NSLineBreakByTruncatingTail;
                    [_lb_publishTime sizeToFitByconstrainedSize:CGSizeMake(_imgV_Back.frame.size.width-_lb_collectNums.frame.origin.x-30,1000)];
                    [_imgV_Back addSubview:_lb_publishTime];
                    [_lb_publishTime changePosInSuperViewWithAlignment:1];
                    RELEASE(_lb_publishTime);
                    _lb_publishTime.clipsToBounds=NO;
                    [_lb_publishTime addSignal:[UIView TAP] object:nil];

                    UIImage *img2=[UIImage imageNamed:((_i_order==3)?(@"arrow_down"):(@"arrow_down_a"))];//下箭头
                    MagicUIImageView *_imgV2 = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_lb_publishTime.frame), 0, img2.size.width/2,img2.size.height/2) backgroundColor:[UIColor clearColor] image:img2 isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_lb_publishTime Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    _imgV2.tag=1;
                    RELEASE(_imgV2);
                }
            }
            
        }
            break;
        default:
            break;
    }
        [signal setReturnValue:_imgV_Back];
    
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
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
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
            
            DYBCellForEmployAndMyCollect *cell = [[[DYBCellForEmployAndMyCollect alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            cell.type=_i_cellType;
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
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForEmployAndMyCollect *)[(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
            [signal setReturnValue:s];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSInteger section = [[dict objectForKey:@"section"] integerValue];
        
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
        
        UIImage *img=[UIImage imageNamed:@"graybar_blank.png"];
        [signal setReturnValue:[NSNumber numberWithFloat:((tableView.muA_allSectionKeys.count==0/*一个section模式*/)?(0):(img.size.height/2))]];
        
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
        
        EmployInfo *model=nil;
        
        if ([tableview isOneSection]) {
            model=[tableview.muA_singelSectionData objectAtIndex:indexPath.row];
        }else{
            model=[[tableview.muD_allSectionValues objectForKey:[tableview.muA_allSectionKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        }
        
        DYBEmployInfoDetailViewController *con=[[DYBEmployInfoDetailViewController alloc]init];
        con.i_id=[model.id intValue];
        [self.drNavigationController pushViewController:con animated:YES];
        RELEASE(con);
        
        [tableview deselectRowAtIndexPath:indexPath animated:YES];

    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        switch (_i_cellType) {
            case 0://就业信息
            {
                {//HTTP请求  
                    [self.view setUserInteractionEnabled:NO];
                    
                    MagicRequest *request = [DYBHttpMethod job_list_page:++_tbv._page num:_tbv.i_pageNums order:[NSString stringWithFormat:@"%d",_i_order] isAlert:YES receive:self];
                    [request setTag:2];
                    
                    if (!request) {//无网路
                        //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                    }
                }
            }
                break;
            case 1://我的收藏
            {
                {//HTTP请求|刷新 我关注的
                    [self.view setUserInteractionEnabled:NO];
                    
                    MagicRequest *request = [DYBHttpMethod job_collectLsit_page:++_tbv._page num:_tbv.i_pageNums order:[NSString stringWithFormat:@"%d",_i_order] isAlert:YES receive:self];
                    [request setTag:4];
                    
                    if (!request) {//无网路
//                        [_tbv.footerView changeState:VIEWTYPEFOOTER];
                    }
                }
            }
                break;
            case 2://搜索结果
            {
                {//HTTP请求
                    [self.view setUserInteractionEnabled:NO];
                    
                    MagicRequest *request = [DYBHttpMethod job_search_page:++_tbv._page num:10 keywork:_search.text type:((_bt_fullTime.selected)?(1):(2)) isAlert:YES receive:self];
                    [request setTag:4];
                    
                    if (!request) {//无网路
                        //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                    }
                }
            }
            default:
                break;
        }
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        switch (_i_cellType) {
            case 0://就业信息
            {
                {//HTTP请求
                    [self.view setUserInteractionEnabled:NO];
                    
                    MagicRequest *request = [DYBHttpMethod job_list_page:_tbv._page=1 num:_tbv.i_pageNums order:[NSString stringWithFormat:@"%d",_i_order] isAlert:YES receive:self];
                    [request setTag:1];
                    
                    if (!request) {//无网路
                        //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                    }
                }
            }
                break;
            case 1://我的收藏
            {
                {//HTTP请求|刷新 我关注的
                    [self.view setUserInteractionEnabled:NO];
                    
                    MagicRequest *request = [DYBHttpMethod job_collectLsit_page:_tbv._page=1 num:_tbv.i_pageNums order:[NSString stringWithFormat:@"%d",_i_order] isAlert:YES receive:self];
                    [request setTag:5];
                    
                    if (!request) {//无网路
//                        [_tbv.footerView changeState:VIEWTYPEFOOTER];
                    }
                }
            }
                break;
            case 2://搜索结果
            {
                {//HTTP请求
                    [self.view setUserInteractionEnabled:NO];
                    
                    MagicRequest *request = [DYBHttpMethod job_search_page:_tbv._page=1 num:10 keywork:_search.text type:((_bt_fullTime.selected)?(1):(2)) isAlert:YES receive:self];
                    [request setTag:3];
                    
                    if (!request) {//无网路
                        //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                    }
                }
            }
                break;
            default:
                break;
        }
        
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
        NSInteger index = [[dict objectForKey:@"index"] integerValue];
        
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
        
        [_tbv StretchingUpOrDown:0];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [_tbv StretchingUpOrDown:1];
        
    }
    
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
                    if ([_search cancelSearch]) {
                        [_search sendViewSignal:[MagicUISearchBar CANCEL] withObject:_search];
                        
                        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            [_v_btBack setFrame:CGRectMake(CGRectGetMinX(_v_btBack.frame), CGRectGetMinY(_search.frame), CGRectGetWidth((_v_btBack.frame)), CGRectGetHeight((_v_btBack.frame)))];
                        }completion:^(BOOL b){
                            REMOVEFROMSUPERVIEW(_bt_fullTime);
                            REMOVEFROMSUPERVIEW(_bt_practice);
                            REMOVEFROMSUPERVIEW(_v_btBack);
                        }];
                        
                    }

                    
                    
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
                        NSArray *arrBtnLable =[[NSArray alloc] initWithObjects:@"就业信息", @"我的收藏",nil] ;
                        _tbv_dropDown = [[DYBMenuView alloc]initWithData:arrBtnLable selectRow:nSelMenu];
                        [_tbv_dropDown setHidden:YES];
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
                    
                    
                    
                    bPullDown = !bPullDown;
                    
                }
                    break;
                    
                case k_tag_fadeBt://取消search的背景按钮
                {
                    if ([_search cancelSearch]) {
                        [_search sendViewSignal:[MagicUISearchBar CANCEL] withObject:_search];
                        
                        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            [_v_btBack setFrame:CGRectMake(CGRectGetMinX(_v_btBack.frame), CGRectGetMinY(_search.frame), CGRectGetWidth((_v_btBack.frame)), CGRectGetHeight((_v_btBack.frame)))];
                        }completion:^(BOOL b){
                            REMOVEFROMSUPERVIEW(_bt_fullTime);
                            REMOVEFROMSUPERVIEW(_bt_practice);
                            REMOVEFROMSUPERVIEW(_v_btBack);
                        }];

                    }
                    
                }
                    break;
                case -2://全职
                {
                    _bt_fullTime.selected=YES;
                    _bt_practice.selected=NO;
                    [_bt_fullTime setTitleColor:[UIColor whiteColor]];
                    [_bt_practice setTitleColor:ColorBlue];
                    
                    [_tbv setFrame:CGRectMake(CGRectGetMinX(_tbv.frame), CGRectGetMaxY(_v_btBack.frame), CGRectGetWidth(_tbv.frame), CGRectGetHeight(self.view.bounds)-self.headHeight-CGRectGetHeight(_search.frame)-CGRectGetHeight(_v_btBack.frame))];
                    [_tbv release_muA_differHeightCellView];
                    [_tbv releaseDataResource];
//                    [_search releaseShadeBt];
                    
                    {//HTTP请求
                        [self.view setUserInteractionEnabled:NO];
                        
                        MagicRequest *request = [DYBHttpMethod job_search_page:_tbv._page=1 num:10 keywork:_search.text type:((_bt_fullTime.selected)?(1):(2)) isAlert:YES receive:self];
                        [request setTag:3];
                        
                        if (!request) {//无网路
                            //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                }
                    break;
                case -3://实习
                {
                    _bt_fullTime.selected=NO;
                    _bt_practice.selected=YES;
                    [_bt_practice setTitleColor:[UIColor whiteColor]];
                    [_bt_fullTime setTitleColor:ColorBlue];
                    
                    [_tbv setFrame:CGRectMake(CGRectGetMinX(_tbv.frame), CGRectGetMaxY(_v_btBack.frame), CGRectGetWidth(_tbv.frame), CGRectGetHeight(self.view.bounds)-self.headHeight-CGRectGetHeight(_search.frame)-CGRectGetHeight(_v_btBack.frame))];
                    [_tbv release_muA_differHeightCellView];
                    [_tbv releaseDataResource];
                    //                    [_search releaseShadeBt];
                    
                    {//HTTP请求
                        [self.view setUserInteractionEnabled:NO];
                        
                        MagicRequest *request = [DYBHttpMethod job_search_page:_tbv._page=1 num:10 keywork:_search.text type:((_bt_fullTime.selected)?(1):(2)) isAlert:YES receive:self];
                        [request setTag:3];
                        
                        if (!request) {//无网路
                            //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                }
                    break;
                case -1000://去掉弹出框
                {
                    [_bt_DropDown didTouchUpInside];
                    
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}

#pragma mark- 初始并改变列表section的数据源
-(void)initSectionOrder:(NSMutableArray *)array tbv:(UITableView *)tbv
{
//    [tbv releaseDataResource];
    
    if (array==_muA_editorRecommend) {
        NSMutableArray *muA=((NSMutableArray *)[_tbv.muD_allSectionValues objectForKey:[_tbv.muA_allSectionKeys objectAtIndex:0]]);
        if (muA) {//小编推荐的数据源
            for (EmployInfo *model in array) {
                [muA addObject:model.retain];
            }
        }
    
    }else if (array==_muA_newOffer){
        NSMutableArray *muA=((NSMutableArray *)[_tbv.muD_allSectionValues objectForKey:[_tbv.muA_allSectionKeys objectAtIndex:1]]);
        if (muA) {//添加最新职位的数据源
            for (EmployInfo *model in array) {
                if (![muA containsObject:model]) {
                    [muA addObject:model.retain];
                }
            }
        }
    }
    
}

#pragma mark- DYBPullDownMenuView消息
- (void)handleViewSignal_DYBDynamicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBDynamicViewController MENUSELECT]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        int  nSection = [[dict objectForKey:@"section"] intValue];
        nSelMenu=nSection;

        switch (nSection) {
            case 0://就业信息
            {              
                
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_search setFrame:CGRectMake(0, CGRectGetMinY(_search._originFrame), CGRectGetWidth(_search.frame), CGRectGetHeight(_search.frame))];
                    [_v_btBack setFrame:CGRectMake(CGRectGetMinX(_v_btBack.frame), CGRectGetMinY(_search.frame), CGRectGetWidth((_v_btBack.frame)), CGRectGetHeight((_v_btBack.frame)))];
                    [_tbv setFrame:_tbv._originFrame];
                }completion:^(BOOL b){
                    REMOVEFROMSUPERVIEW(_bt_fullTime);
                    REMOVEFROMSUPERVIEW(_bt_practice);
                    REMOVEFROMSUPERVIEW(_v_btBack);
                }];
                
                if (!_muA_editorRecommend || !_muA_newOffer) {
                    [_tbv release_muA_differHeightCellView];
                    [_tbv releaseDataResource];
                    _tbv.muA_allSectionKeys=[[NSMutableArray alloc]initWithObjects:@"小编推荐",@"最新职位", nil];
                    _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSMutableArray arrayWithCapacity:10],[_tbv.muA_allSectionKeys objectAtIndex:0],[NSMutableArray arrayWithCapacity:10],[_tbv.muA_allSectionKeys objectAtIndex:1], nil];
                    
                    {//HTTP请求
                        [self.view setUserInteractionEnabled:NO];
                        
                        MagicRequest *request = [DYBHttpMethod job_list_page:_tbv._page=1 num:_tbv.i_pageNums order:[NSString stringWithFormat:@"%d",_i_order] isAlert:YES receive:self];
                        [request setTag:1];
                        
                        if (!request) {//无网路
                            //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                        }
                    }
                }else{
                    [_tbv release_muA_differHeightCellView];
                    [_tbv releaseDataResource];
                    _tbv.muA_allSectionKeys=[[NSMutableArray alloc]initWithObjects:@"小编推荐",@"最新职位", nil];
                    _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSMutableArray arrayWithCapacity:10],[_tbv.muA_allSectionKeys objectAtIndex:0],[NSMutableArray arrayWithCapacity:10],[_tbv.muA_allSectionKeys objectAtIndex:1], nil];
                    [self initSectionOrder:_muA_editorRecommend tbv:_tbv];
                    [self initSectionOrder:_muA_newOffer tbv:_tbv];
                    [_tbv reloadData];
                }
                
                [self.headview setTitle:[_tbv_dropDown.arrMenu objectAtIndex:nSection]];
               
            }
                break;
            case 1://我的 收藏
            {
               
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_search setFrame:CGRectMake(0, CGRectGetMinY(_search.frame)-CGRectGetHeight(_search.frame), CGRectGetWidth(_search.frame), CGRectGetHeight(_search.frame))];
                    [_v_btBack setFrame:CGRectMake(CGRectGetMinX(_v_btBack.frame), CGRectGetMinY(_search.frame), CGRectGetWidth((_v_btBack.frame)), CGRectGetHeight((_v_btBack.frame)))];
                    [_tbv setFrame:CGRectMake(0, CGRectGetMaxY(_search.frame), CGRectGetWidth(_tbv.frame), CGRectGetHeight(_tbv.frame)+CGRectGetHeight(_search.frame))];
                }completion:^(BOOL b){
                    REMOVEFROMSUPERVIEW(_bt_fullTime);
                    REMOVEFROMSUPERVIEW(_bt_practice);
                    REMOVEFROMSUPERVIEW(_v_btBack);
                }];
                
                [_search cancelSearch];
                [_tbv release_muA_differHeightCellView];
                [_tbv releaseDataResource];
                
                {//HTTP请求|刷新 
                    [self.view setUserInteractionEnabled:NO];
                    
                    MagicRequest *request = [DYBHttpMethod job_collectLsit_page:_tbv._page=1 num:_tbv.i_pageNums order:[NSString stringWithFormat:@"%d",_i_order] isAlert:YES receive:self];
                    [request setTag:5];
                    
                    if (!request) {//无网路
//                        [_tbv.footerView changeState:VIEWTYPEFOOTER];
                    }
                }
                
                [self.headview setTitle:[_tbv_dropDown.arrMenu objectAtIndex:nSection]];
                
            }
                break;
            default:
                break;
        }
        
//        [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:nil from:self target:_tbv_dropDown];
        //        [self sendViewSignal:[MagicUISearchBar CANCEL] withObject:_search];
//        [_search cancelSearch];
        
        [self.headview setTitleArrow];
        [_bt_DropDown didTouchUpInside];

    }
}


#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal
{
    if ([signal is:[UIView TAP]]) {//单击信号
        NSDictionary *d=(NSDictionary *)signal.object;
        DYBCustomLabel *lb=(DYBCustomLabel *)signal.source;
        
        if (lb==_lb_ViewNums) {//浏览
            _lb_ViewNums.textColor=ColorBlue;
            UIImageView *imgv=(UIImageView *)[_lb_ViewNums viewWithTag:1];
            imgv.image=[UIImage imageNamed:@"arrow_down"];
            
            {
                _lb_publishTime.textColor=ColorBlack;
                UIImageView *imgv=(UIImageView *)[_lb_publishTime viewWithTag:1];
                imgv.image=[UIImage imageNamed:@"arrow_down_a"];
            }
            
            {
                _lb_collectNums.textColor=ColorBlack;
                UIImageView *imgv=(UIImageView *)[_lb_collectNums viewWithTag:1];
                imgv.image=[UIImage imageNamed:@"arrow_down_a"];
            }
            
            {//HTTP请求
                [self.view setUserInteractionEnabled:NO];
                
                MagicRequest *request = [DYBHttpMethod job_list_page:_tbv._page=1 num:_tbv.i_pageNums order:[NSString stringWithFormat:@"%d",_i_order=1] isAlert:YES receive:self];
                [request setTag:1];
                
                if (!request) {//无网路
                    //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                }
            }
           
        }else if (lb==_lb_collectNums) {//收藏
            _lb_collectNums.textColor=ColorBlue;
            UIImageView *imgv=(UIImageView *)[_lb_collectNums viewWithTag:1];
            imgv.image=[UIImage imageNamed:@"arrow_down"];
            
            {
                _lb_publishTime.textColor=ColorBlack;
                UIImageView *imgv=(UIImageView *)[_lb_publishTime viewWithTag:1];
                imgv.image=[UIImage imageNamed:@"arrow_down_a"];
            }
            
            {
                _lb_ViewNums.textColor=ColorBlack;
                UIImageView *imgv=(UIImageView *)[_lb_ViewNums viewWithTag:1];
                imgv.image=[UIImage imageNamed:@"arrow_down_a"];
            }
            
            {//HTTP请求
                [self.view setUserInteractionEnabled:NO];
                
                MagicRequest *request = [DYBHttpMethod job_list_page:_tbv._page=1 num:_tbv.i_pageNums order:[NSString stringWithFormat:@"%d",_i_order=2] isAlert:YES receive:self];
                [request setTag:1];
                
                if (!request) {//无网路
                    //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                }
            }
            
        }else if (lb==_lb_publishTime) {//时间
            _lb_publishTime.textColor=ColorBlue;
            UIImageView *imgv=(UIImageView *)[_lb_publishTime viewWithTag:1];
            imgv.image=[UIImage imageNamed:@"arrow_down"];
            
            {
                _lb_collectNums.textColor=ColorBlack;
                UIImageView *imgv=(UIImageView *)[_lb_collectNums viewWithTag:1];
                imgv.image=[UIImage imageNamed:@"arrow_down_a"];
            }
            
            {
                _lb_ViewNums.textColor=ColorBlack;
                UIImageView *imgv=(UIImageView *)[_lb_ViewNums viewWithTag:1];
                imgv.image=[UIImage imageNamed:@"arrow_down_a"];
            }
            
            {//HTTP请求
                [self.view setUserInteractionEnabled:NO];
                
                MagicRequest *request = [DYBHttpMethod job_list_page:_tbv._page=1 num:_tbv.i_pageNums order:[NSString stringWithFormat:@"%d",_i_order=3] isAlert:YES receive:self];
                [request setTag:1];
                
                if (!request) {//无网路
                    //                [_tbv_friends_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
                }
            }
            
        }

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
        
        {
            if(!_v_btBack){
                _v_btBack=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_search.frame), self.view.frame.size.width, 57)];
                _v_btBack.backgroundColor=[MagicCommentMethod color:255 green:255 blue:255 alpha:0.3];
                
                [self.view addSubview:_v_btBack];
                [self.view insertSubview:_v_btBack aboveSubview:_search.bt_Shade];
                [self.view bringSubviewToFront:_search];
                RELEASE(_v_btBack);
                
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_v_btBack setFrame:CGRectMake(CGRectGetMinX(_v_btBack.frame), CGRectGetMaxY(_search.frame), CGRectGetWidth((_v_btBack.frame)), CGRectGetHeight((_v_btBack.frame)))];
                }completion:^(BOOL b){
                    
                }];
            }else{
                [self.view insertSubview:_v_btBack aboveSubview:_search.bt_Shade];
            }
            
            if (!_bt_fullTime) {
                UIImage *img= [UIImage imageNamed:@"2tabs_left_def"];
                _bt_fullTime = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0,img.size.width/2, img.size.height/2)];
                _bt_fullTime.tag=-2;
                _bt_fullTime.showsTouchWhenHighlighted=YES;
                _bt_fullTime.backgroundColor=[UIColor clearColor];
                [_bt_fullTime addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_fullTime setBackgroundImage:img forState:UIControlStateNormal];
                [_bt_fullTime setBackgroundImage:[UIImage imageNamed:@"2tabs_left_sel"] forState:UIControlStateSelected];
                [_bt_fullTime setTitle:@"全职"];
                [_bt_fullTime setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:14]];
                [_v_btBack addSubview:_bt_fullTime];
                [_bt_fullTime changePosInSuperViewWithAlignment:1];
                RELEASE(_bt_fullTime);
                _bt_fullTime.selected=YES;
                //            [_bt_mayKnow changeStateImg:UIControlStateSelected];
            }
            
            if (!_bt_practice) {
                UIImage *img= [UIImage imageNamed:@"2tabs_right_def"];
                _bt_practice = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_fullTime.frame.origin.x+_bt_fullTime.frame.size.width, _bt_fullTime.frame.origin.y,_bt_fullTime.frame.size.width, _bt_fullTime.frame.size.height)];
                _bt_practice.tag=-3;
                _bt_practice.showsTouchWhenHighlighted=YES;
                _bt_practice.backgroundColor=[UIColor clearColor];
                [_bt_practice addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_practice setBackgroundImage:img forState:UIControlStateNormal];
                [_bt_practice setBackgroundImage:[UIImage imageNamed:@"2tabs_right_sel"] forState:UIControlStateSelected];
                [_bt_practice setTitle:@"实习"];
                [_bt_practice setTitleColor:ColorBlue];
                [_bt_practice setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:14]];
                [_v_btBack addSubview:_bt_practice];
                //            [_bt_mayKnow changePosInSuperViewWithAlignment:1];
                RELEASE(_bt_practice);
                
                [_bt_fullTime setFrame:CGRectMake((_v_btBack.frame.size.width-_bt_fullTime.frame.size.width-_bt_practice.frame.size.width)/2, _bt_fullTime.frame.origin.y, _bt_fullTime.frame.size.width, _bt_fullTime.frame.size.height)];
                [_bt_practice setFrame:CGRectMake(_bt_fullTime.frame.origin.x+_bt_fullTime.frame.size.width, _bt_fullTime.frame.origin.y,_bt_fullTime.frame.size.width, _bt_fullTime.frame.size.height)];
            }

        }
        
    }else if ([signal is:[MagicUISearchBar CANCEL]]){//取消搜索
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
        [_tbv release_muA_differHeightCellView];
        [_tbv releaseDataResource];
        [_tbv setFrame:_tbv._originFrame];
        _tbv.muA_allSectionKeys=[[NSMutableArray alloc]initWithObjects:@"小编推荐",@"最新职位", nil];
        _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSMutableArray arrayWithCapacity:10],[_tbv.muA_allSectionKeys objectAtIndex:0],[NSMutableArray arrayWithCapacity:10],[_tbv.muA_allSectionKeys objectAtIndex:1], nil];
        [self initSectionOrder:_muA_editorRecommend tbv:_tbv];
        [self initSectionOrder:_muA_newOffer tbv:_tbv];
        [_tbv reloadData];
        [search setShowsCancelButton:NO animated:YES];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_v_btBack setFrame:CGRectMake(CGRectGetMinX(_v_btBack.frame), CGRectGetMinY(_search.frame), CGRectGetWidth((_v_btBack.frame)), CGRectGetHeight((_v_btBack.frame)))];
        }completion:^(BOOL b){
            REMOVEFROMSUPERVIEW(_bt_fullTime);
            REMOVEFROMSUPERVIEW(_bt_practice);
            REMOVEFROMSUPERVIEW(_v_btBack);
        }];

    }else if ([signal is:[MagicUISearchBar SEARCH]]){//按下搜索按钮
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
//        [_search cancelSearch];       
        
        [_tbv setFrame:CGRectMake(CGRectGetMinX(_tbv.frame), CGRectGetMaxY(_v_btBack.frame), CGRectGetWidth(_tbv.frame), CGRectGetHeight(self.view.bounds)-self.headHeight-CGRectGetHeight(_search.frame)-CGRectGetHeight(_v_btBack.frame))];
        [_tbv release_muA_differHeightCellView];
        [_tbv releaseDataResource];
        //                    [_search releaseShadeBt];
        
        {//HTTP请求
            [self.view setUserInteractionEnabled:NO];
            
            MagicRequest *request = [DYBHttpMethod job_search_page:_tbv._page=1 num:5 keywork:_search.text type:((_bt_fullTime.selected)?(1):(2)) isAlert:YES receive:self];
            [request setTag:3];
            
            if (!request) {//无网路
                //                [_tbv_frienrrds_myConcern_RecentContacts.footerView changeState:VIEWTYPEFOOTER];
            }
        }

        
    }else if ([signal is:[MagicUISearchBar CHANGEWORD]]){//内容改变
        NSString *str=(NSString *)signal.object;
        MagicUISearchBar *search=(MagicUISearchBar *)signal.source;
        
        if ([str length] == 0) {//删除完search里的内容
          
            return;
        }
        
        //        [search sendViewSignal:[MagicUISearchBar SEARCHING] withObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"searchContent",((!_tbv_mayKnow.hidden)?(_tbv_mayKnow):(_tbv_nearBy)),@"tbv", nil]];
        
        
    }else if ([signal is:[MagicUISearchBar SEARCHING]]){
        
    }
}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取|刷新 就业信息
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
//                    NSDictionary *d=[response.data objectForKey:@"user_list"];
                    NSArray *list=[response.data objectForKey:@"top"];//0号section 小编推荐 的数据
                    if (_muA_editorRecommend.count>0 /*&& ((NSArray *)[_tbv.muD_allSectionValues objectForKey:[_tbv.muA_allSectionKeys objectAtIndex:0]]).count >0/*0号section有数据*/&& list.count>0) {//刷新  小编推荐 section数据
                        
                        [_muA_editorRecommend removeAllObjects];
                        [((NSMutableArray *)[_tbv.muD_allSectionValues objectForKey:[_tbv.muA_allSectionKeys objectAtIndex:0]]) removeAllObjects];
                        [_tbv release_muA_differHeightCellView];
                        
                    }
                    
                    for (NSDictionary *d in list) {
                        EmployInfo *model = [EmployInfo JSONReflection:d];
                        if (!_muA_editorRecommend) {
                            _muA_editorRecommend=[NSMutableArray arrayWithObject:model];
                            [_muA_editorRecommend retain];
                        }else{
                            [_muA_editorRecommend addObject:model];
                        }
                    }
                    
                    NSArray *list_1=[response.data objectForKey:@"list"];//1号section 最新职位 的数据
                    if (_muA_newOffer.count>1 /*&& ((NSArray *)[_tbv.muD_allSectionValues objectForKey:[_tbv.muA_allSectionKeys objectAtIndex:1]]).count >0/*1号section有数据*/&& list_1.count>0) {
                        
                        [_muA_newOffer removeAllObjects];
                        [((NSMutableArray *)[_tbv.muD_allSectionValues objectForKey:[_tbv.muA_allSectionKeys objectAtIndex:1]]) removeAllObjects];
                        [_tbv release_muA_differHeightCellView];
                        
                    }
                    
                    for (NSDictionary *d in list_1) {
                        EmployInfo *model = [EmployInfo JSONReflection:d];
                        if (!_muA_newOffer) {
                            _muA_newOffer=[NSMutableArray arrayWithObject:model];
                            [_muA_newOffer retain];
                        }else{
                            [_muA_newOffer addObject:model];
                        }
                    }
                    
                    {
                        if ((_muA_editorRecommend.count>0 || _muA_newOffer.count>0) && (list.count>0 || list_1.count>0)) {
                            [self creatTbv];
                            [self initSectionOrder:_muA_editorRecommend tbv:_tbv];
                            [self initSectionOrder:_muA_newOffer tbv:_tbv];
                            [_tbv release_muA_differHeightCellView];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
                        }
                        
                    }
                    
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
//                [_tbv.footerView changeState:PULLSTATEEND];
                
            }
                break;
                
            case 2://就业信息加载更多
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"list"];
                    for (NSDictionary *d in list) {
                        EmployInfo *model = [EmployInfo JSONReflection:d];
                        if (!_muA_newOffer) {
                            _muA_newOffer=[NSMutableArray arrayWithObject:model];
                            [_muA_newOffer retain];
                        }else{
                            [_muA_newOffer addObject:model];
                        }
                    }
                    
                    {//加载更多
                        if (_muA_newOffer.count>0 && list.count>0) {
                            [self initSectionOrder:_muA_newOffer tbv:_tbv];
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
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
            case 3://获取|刷新 搜索结果
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"list"];
                    
                    if (list.count>0&&_tbv.muA_singelSectionData.count>0) {
                        [_tbv releaseDataResource];
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        EmployInfo *model = [EmployInfo JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                        }else{
                            [_tbv.muA_singelSectionData addObject:model];
                        }
                    }
                    
                    {
                        _i_cellType=2;
//                        [_search cancelSearch];
//                        [_search initCancelBt:[UIImage imageNamed:@"btn_search_cancel_def"] HighlightedImg:[UIImage imageNamed:@"btn_search_cancel_high"]];
                        
                        {
                            [_search resignFirstResponder];
                            [_search setShowsCancelButton:YES animated:YES];
                            [_search releaseShadeBt];
                            
                        }

                        if (list.count>0) {
                            [_tbv release_muA_differHeightCellView];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
                        }
                        
                    }
                    
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
//                [_tbv.footerView changeState:PULLSTATEEND];
                
            }
                break;
            case 4://搜索结果|我的收藏 加载更多
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"list"];
                    for (NSDictionary *d in list) {
                        EmployInfo *model = [EmployInfo JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                        }else{
                            [_tbv.muA_singelSectionData addObject:model];
                        }
                    }
                    
                    {//加载更多
                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
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
            case 5://获取|刷新 我的收藏
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"list"];
                    
                    if (list.count>0&&_tbv.muA_singelSectionData.count>0) {
                        [_tbv releaseDataResource];
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        EmployInfo *model = [EmployInfo JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                        }else{
                            [_tbv.muA_singelSectionData addObject:model];
                        }
                    }
                    
                    {
                        _i_cellType=1;
                        
                        if (list.count>0) {
                            [_tbv release_muA_differHeightCellView];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
                        }
                        
                    }
                    
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
//                [_tbv.footerView changeState:PULLSTATEEND];
                
            }
                break;
            default:
                break;
        }
    }
}
@end
