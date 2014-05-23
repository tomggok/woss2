//
//  DYYBClassHomePageViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYYBClassHomePageViewController.h"
#import "UITableView+property.h"
#import "UIImageView+WebCache.h"
#import "NSString+Count.h"
#import "user.h"
#import "eclass_notice.h"
#import "DYBCellForAnnouncement.h"
#import "UIView+MagicCategory.h"
#import "DYBClassListViewController.h"
#import "DYBClassMemberViewController.h"
#import "eclass_topiclist.h"
#import "UITableViewCell+MagicCategory.h"
#import "UILabel+ReSize.h"
#import "target.h"
#import "DYBClassNoticeDetailsViewController.h"
#import "DYBGuideView.h"

@interface DYYBClassHomePageViewController () {
    
    UIView *bgview;
}

@end

@implementation DYYBClassHomePageViewController

@synthesize str_userid=_str_userid,modelClass=_modelClass,muA_data_classList=_muA_data_classList,b_isRefresh=_b_isRefresh;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        if (!_str_userid) {
            _str_userid=SHARED.curUser.userid;
        }
        _b_isRefresh=YES;
        
        [self refreshClassInfo];
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"班级主页"];
//        [self backImgType:0];
        self.rightButton.hidden=YES;
        
        if (!_bt_classList) {
            UIImage *img= [UIImage imageNamed:@"btn_classlist_def"];
            _bt_classList = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.headview.frame.size.width-img.size.width/2, 0, img.size.width/2, img.size.height/2)];
            _bt_classList.backgroundColor=[UIColor clearColor];
            _bt_classList.tag=-4;
            [_bt_classList addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
//            [_bt_classList setImage:img forState:UIControlStateNormal];
//            [_bt_classList setImage:[UIImage imageNamed:@"btn_classlist_high"] forState:UIControlStateHighlighted];
            [_bt_classList setTitle:@"更多"];
            [_bt_classList setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
            [_bt_classList setTitleColor:ColorBlue];
            [self.headview addSubview:_bt_classList];
            [_bt_classList changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_classList);
        }
        
        if (_b_isRefresh) {
            [_muA_data_announcement removeAllObjects];
            _muA_data_announcement=Nil;
            [_muA_data_topic removeAllObjects];
            _muA_data_topic=Nil;
            [_tbv release_muA_differHeightCellView];
            //        _bt_announcement.selected=YES;
            //        _bt_topic.selected=NO;
            
            {//HTTP请求已加入的班级列表
                [self.view setUserInteractionEnabled:NO];
                
                MagicRequest *request = [DYBHttpMethod user_myeclass_list:_str_userid isAlert:YES receive:self];
                [request setTag:1];
                
            (_b_isRefresh)=NO;
            }
        }
        
        if (![[NSUserDefaults standardUserDefaults] stringForKey:@"classHome"] || [[[NSUserDefaults standardUserDefaults] stringForKey:@"classHome"] intValue]==0) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"classHome"];
            
            {
                DYBGuideView *guideV=[[DYBGuideView alloc]initWithFrame:self.view.frame];
                guideV.AddImgByName(@"classHome",nil);
                [self.drNavigationController.view addSubview:guideV];
                RELEASE(guideV);
            }
        }
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
      
        RELEASEDICTARRAYOBJ(_muA_data_announcement);
        RELEASEDICTARRAYOBJ(_muA_data_classList);
        RELEASEDICTARRAYOBJ(_muA_data_classSize);
        RELEASEDICTARRAYOBJ(_muA_data_topic);

    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv release_muA_differHeightCellView];

        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
        REMOVEFROMSUPERVIEW(_bt_classList);
        
    }
    
}


#pragma mark- 初始化无数据提示view
-(void)initNoDataView:(NSString *)text
{
    if (bgview) {
        for (UIView *v in bgview.subviews) {
            [v removeFromSuperview];
            v=nil;
        }
        [bgview removeFromSuperview];
        bgview = nil;
    }
    
    if ([text isEqualToString:@""]) {
        return;
    }
    
    int height = _v_announcement_topic.frame.size.height;
    UIImage *img=[UIImage imageNamed:@"ybx_small"];
    bgview = [[UIView alloc]initWithFrame:CGRectMake(0,  _imgV_classImg.frame.origin.y+_imgV_classImg.frame.size.height+15+(height-img.size.height/2)/2, SCREEN_WIDTH, img.size.height/2)];
    [self.view addSubview:bgview];
    RELEASE(bgview);
    
    UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2)];
    [imgV setImage:img];
    [bgview addSubview:imgV];
    RELEASE(imgV);
    
    {
        MagicUILabel *lb=[[MagicUILabel alloc]initWithFrame:CGRectMake(imgV.frame.origin.x+imgV.frame.size.width+10, imgV.frame.origin.y, 0, 0)];
        lb.backgroundColor=[UIColor clearColor];
        lb.textAlignment=NSTextAlignmentLeft;
        lb.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
        lb.text=text;
        lb.textColor=ColorGray;
        lb.numberOfLines=2;
        lb.lineBreakMode=NSLineBreakByWordWrapping;
        [lb sizeToFitByconstrainedSize:CGSizeMake(240, 1000)];
        [bgview addSubview:lb];
        [lb changePosInSuperViewWithAlignment:1];
        
        lb.linesSpacing=20;
        [lb setNeedCoretext:YES];
        RELEASE(lb);
        
        [bgview setFrame:CGRectMake((SCREEN_WIDTH-(img.size.width/2+lb.frame.size.width))/2, bgview.frame.origin.y, (img.size.width/2+lb.frame.size.width), img.size.height/2)];

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

#pragma mark-
-(void)creatTbv{
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, _bt_topic.frame.size.height, _v_announcement_topic.frame.size.width, _v_announcement_topic.frame.size.height-_bt_topic.frame.size.height) isNeedUpdate:YES];
        _tbv._cellH=45;
        //        [_tbv setTableViewType:DTableViewSlime];
        [_v_announcement_topic addSubview:_tbv];
        _tbv.backgroundColor=BKGGray;
        _tbv.tag=-1;
        _tbv._page=1;
        _tbv.i_pageNums=10;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tbv setTableViewType:DTableViewSlime];
        [_tbv setSlimeViewRefreshHeight:MagicReHeightMiddle];
    }
    
}

#pragma mark- 初始化无数据提示view
-(void)initNoDataView
{
    _bt_classList.hidden=YES;
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [v setBackgroundColor:ColorWhite];
    [self.view addSubview:v];
    RELEASE(v);
    
    UIImage *img=[UIImage imageNamed:@"ybx_big"];
    UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:v Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    [imgV setFrame:CGRectMake(CGRectGetMinX(imgV.frame), CGRectGetMinY(imgV.frame)-50, CGRectGetWidth(imgV.frame), CGRectGetHeight(imgV.frame))];
    RELEASE(imgV);
    
    {
        MagicUILabel *lb=[[MagicUILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame)+20, 0, 0)];
        lb.backgroundColor=[UIColor clearColor];
        lb.textAlignment=NSTextAlignmentLeft;
        lb.font=[DYBShareinstaceDelegate DYBFoutStyle:20];
        lb.text=@"哎...一个班级都没有";
        lb.textColor=ColorGray;
        lb.numberOfLines=1;
        lb.lineBreakMode=NSLineBreakByWordWrapping;
        [lb sizeToFitByconstrainedSize:CGSizeMake(240, 1000)];
        [v addSubview:lb];
        [lb changePosInSuperViewWithAlignment:0];
        RELEASE(lb);
    }
        
}

#pragma mark- 刷新当前显示的班级的信息
-(void)refreshClassInfo
{
    //    [self.headview setTitle:_modelClass.name];
    
    if (!_imgV_classImg) {
        _imgV_classImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15,self.headHeight+15, 125,125) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self.view Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        RELEASE(_imgV_classImg);
        [_imgV_classImg setImgWithUrl:_modelClass.pic  defaultImg:@"bg_class"];

    }else{

        [_imgV_classImg setImgWithUrl:_modelClass.pic  defaultImg:@"bg_class"];

    }
    
    if (!_lb_name) {
        _lb_name=[[MagicUILabel alloc]initWithFrame:CGRectMake(_imgV_classImg.frame.origin.x+_imgV_classImg.frame.size.width+10, _imgV_classImg.frame.origin.y, 160, 1000)];
        _lb_name.backgroundColor=[UIColor clearColor];
        _lb_name.textAlignment=NSTextAlignmentLeft;
        _lb_name.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
//        _modelClass.name=@"2010级_软件学院_F额鹅鹅鹅班";
//        NSArray *array=[_modelClass.name componentsSeparatedByString:@"_"];
        NSString *muS=[NSString stringWithFormat:@"%@\n\%@\n\%@",((_modelClass.year)?(_modelClass.year):(@"")),((_modelClass.college)?(_modelClass.college):(@"")),((_modelClass.name)?(_modelClass.name):(@""))];
        _lb_name.text=muS;
        _lb_name.textColor=[MagicCommentMethod colorWithHex:@"0x333333"];
        _lb_name.numberOfLines=5;
        _lb_name.lineBreakMode=NSLineBreakByTruncatingTail;
        _lb_name.linesSpacing=10;
        
        [_lb_name sizeToFitByconstrainedSize:CGSizeMake(160, 1000)];
        
        [_lb_name setNeedCoretext:YES];
        
        [self.view addSubview:_lb_name];
        
        //        [_lb_nickName changePosInSuperViewWithAlignment:1];
        
        RELEASE(_lb_name);
    }else{
        _lb_name.text=[NSString stringWithFormat:@"%@\n\%@\n\%@",((_modelClass.year)?(_modelClass.year):(@"")),((_modelClass.college)?(_modelClass.college):(@"")),((_modelClass.name)?(_modelClass.name):(@""))];

        [_lb_name sizeToFitByconstrainedSize:CGSizeMake(160, 1000)];

        [_lb_name setNeedCoretext:YES];

//        [_lb_name sizeToFitByconstrainedSize:CGSizeMake(160, 100)];

    }
    
    if (!_imgV_dashed) {//虚线
        UIImage *img=[UIImage imageNamed:@"class_dotline"];
        _imgV_dashed=[[MagicUIImageView alloc]initWithFrame:CGRectMake(_lb_name.frame.origin.x,self.headHeight+110, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self.view Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        RELEASE(_imgV_dashed);
    }
    
    if (!_lb_classSizeTab) {//班级人数标签
        _lb_classSizeTab=[[MagicUILabel alloc]initWithFrame:CGRectMake(_lb_name.frame.origin.x, _imgV_dashed.frame.origin.y+5, 0, 0)];
        _lb_classSizeTab.backgroundColor=[UIColor clearColor];
        _lb_classSizeTab.textAlignment=NSTextAlignmentLeft;
        _lb_classSizeTab.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
        _lb_classSizeTab.textColor=[MagicCommentMethod colorWithHex:@"0x333333"];
        _lb_classSizeTab.numberOfLines=1;
        //        _lb_classSize.lineBreakMode=NSLineBreakByTruncatingTail;
        _lb_classSizeTab.text=@"班级人数";
        
        [_lb_classSizeTab sizeToFitByconstrainedSize:CGSizeMake(self.view.frame.size.width-_lb_name.frame.origin.x, 100)];
        
        [_lb_classSizeTab setNeedCoretext:NO];
        
        [self.view addSubview:_lb_classSizeTab];
        
        //        [_lb_nickName changePosInSuperViewWithAlignment:1];
        
        [_lb_classSizeTab setFrame:CGRectMake(_lb_classSizeTab.frame.origin.x, _imgV_classImg.frame.origin.y+_imgV_classImg.frame.size.height-_lb_classSizeTab.frame.size.height+2, _lb_classSizeTab.frame.size.width, _lb_classSizeTab.frame.size.height)];
        RELEASE(_lb_classSizeTab);
    }
    
    if (!_lb_classSize) {//实际人数
        _lb_classSize=[[MagicUILabel alloc]initWithFrame:CGRectMake(_lb_classSizeTab.frame.origin.x+_lb_classSizeTab.frame.size.width+5/**/, 0, 0, 0)];
        _lb_classSize.backgroundColor=[UIColor clearColor];
        _lb_classSize.textAlignment=NSTextAlignmentLeft;
        _lb_classSize.font=[DYBShareinstaceDelegate DYBFoutStyle:30];
        _lb_classSize.textColor=ColorBlue;
        _lb_classSize.numberOfLines=1;
        //        _lb_classSize.lineBreakMode=NSLineBreakByTruncatingTail;
        _lb_classSize.text=[NSString stringWithFormat:@"%d",_muA_data_classSize.count];
        [_lb_classSize sizeToFitByconstrainedSize:CGSizeMake(/*self.view.frame.size.width-_lb_classSize.frame.origin.x*/100, 100.f)];
        //        [_lb_classSize sizeToFit];
        [_lb_classSize setNeedCoretext:NO];
        
        [self.view addSubview:_lb_classSize];
        
        //        [_lb_nickName changePosInSuperViewWithAlignment:1];
        
        [_lb_classSize setFrame:CGRectMake(_lb_classSize.frame.origin.x, _imgV_classImg.frame.origin.y+_imgV_classImg.frame.size.height-_lb_classSize.frame.size.height+7, _lb_classSize.frame.size.width, _lb_classSize.frame.size.height)];
        RELEASE(_lb_classSize);
    }else{
        _lb_classSize.text=[NSString stringWithFormat:@"%d",_muA_data_classSize.count];
        [_lb_classSize sizeToFitByconstrainedSize:CGSizeMake(/*self.view.frame.size.width-_lb_classSize.frame.origin.x*/100, 100.f)];
    }
    
    if (!_imgV_arrow) {//右箭头
        UIImage *img=[UIImage imageNamed:@"doublearrow_left"];
        _imgV_arrow=[[MagicUIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-15-img.size.width/2,_lb_classSizeTab.frame.origin.y+_lb_classSizeTab.frame.size.height-img.size.height/2-2, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self.view Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        RELEASE(_imgV_arrow);
    }
    
    if (!_bt_gotoClassDetail) {
        //        UIImage *img= [UIImage imageNamed:@"info_notes_def"];
        _bt_gotoClassDetail = [[MagicUIButton alloc] initWithFrame:CGRectMake(_lb_classSizeTab.frame.origin.x, _imgV_dashed.frame.origin.y, self.view.frame.size.width-_lb_classSizeTab.frame.origin.x, 35)];
        _bt_gotoClassDetail.backgroundColor=[UIColor clearColor];
        _bt_gotoClassDetail.tag=-1;
        [_bt_gotoClassDetail addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
        //        [_bt_gotoClassDetail setImage:img forState:UIControlStateNormal];
        //        [_bt_notice setImage:[UIImage imageNamed:@"info_notes_high"] forState:UIControlStateHighlighted];
        [self.view addSubview:_bt_gotoClassDetail];
        //        [_bt_notice changePosInSuperViewWithAlignment:1];
        RELEASE(_bt_gotoClassDetail);
    }
    
    if (!_v_announcement_topic) {//公告和话题全局背景
        _v_announcement_topic=[[UIView alloc]initWithFrame:CGRectMake(_imgV_classImg.frame.origin.x, _imgV_classImg.frame.origin.y+_imgV_classImg.frame.size.height+15, self.view.frame.size.width-_imgV_classImg.frame.origin.x*2, 250)];
        _v_announcement_topic.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_v_announcement_topic];
        RELEASE(_v_announcement_topic);
        
        [_v_announcement_topic setFrame:CGRectMake(CGRectGetMinX(_v_announcement_topic.frame), CGRectGetMinY(_v_announcement_topic.frame), CGRectGetWidth(_v_announcement_topic.frame), CGRectGetHeight(self.view.frame)-CGRectGetMinY(_v_announcement_topic.frame)-kH_StateBar-self.headHeight/2+10)];
        
        {
        UIImage *img=[UIImage imageNamed:@"bg_details_tab.png"];
        UIImageView *imgv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_v_announcement_topic Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        RELEASE(imgv);
        }
    }
    
    if (!_bt_announcement) {//公告
        //        UIImage *img= [UIImage imageNamed:@"info_notes_def"];
        _bt_announcement = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0, 95, 37)];
        _bt_announcement.backgroundColor=[UIColor clearColor];
        _bt_announcement.tag=-2;
        [_bt_announcement setTitle:@"公告"];
        [_bt_announcement setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:15]];
        [_bt_announcement setTitleColor:ColorBlack];
        [_bt_announcement addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
        //        [_bt_gotoClassDetail setImage:img forState:UIControlStateNormal];
        //        [_bt_notice setImage:[UIImage imageNamed:@"info_notes_high"] forState:UIControlStateHighlighted];
        [_v_announcement_topic addSubview:_bt_announcement];
        //        [_bt_notice changePosInSuperViewWithAlignment:1];
        RELEASE(_bt_announcement);
        _bt_announcement.selected=YES;
    }
    
    if (!_imgv_verticalDashedLine) {//竖虚线
        UIImage *img=[UIImage imageNamed:@"dotsepline"];
        _imgv_verticalDashedLine=[[MagicUIImageView alloc]initWithFrame:CGRectMake(_bt_announcement.frame.origin.x+_bt_announcement.frame.size.width+img.size.width/2,_bt_announcement.frame.origin.y+_bt_announcement.frame.size.height/2-img.size.height/4, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_announcement_topic Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        _imgv_verticalDashedLine.hidden=YES;
        RELEASE(_imgv_verticalDashedLine);
    }
    if (!_bt_topic) {//话题
        //        UIImage *img= [UIImage imageNamed:@"info_notes_def"];
        _bt_topic = [[MagicUIButton alloc] initWithFrame:CGRectMake(_imgv_verticalDashedLine.frame.origin.x+_imgv_verticalDashedLine.frame.size.width+2, 0, _bt_announcement.frame.size.width, _bt_announcement.frame.size.height)];
        _bt_topic.backgroundColor=[UIColor clearColor];
        _bt_topic.tag=-3;
        [_bt_topic setTitle:@"话题"];
        [_bt_topic setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:15]];
        [_bt_topic setTitleColor:ColorGray];
        [_bt_topic addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
        //        [_bt_gotoClassDetail setImage:img forState:UIControlStateNormal];
        //        [_bt_notice setImage:[UIImage imageNamed:@"info_notes_high"] forState:UIControlStateHighlighted];
        [_v_announcement_topic addSubview:_bt_topic];
        //        [_bt_notice changePosInSuperViewWithAlignment:1];
        RELEASE(_bt_topic);
    }
    
    [self creatTbv];
    
    if (!_imgV_arrowUp) {//tbv顶部的箭头
        UIImage *img=[UIImage imageNamed:@"icon_arrow_up"];
        _imgV_arrowUp=[[MagicUIImageView alloc]initWithFrame:CGRectMake(_bt_announcement.frame.origin.x+_bt_announcement.frame.size.width/2-img.size.width/4,_tbv.frame.origin.y-img.size.height/2, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_announcement_topic Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        
        RELEASE(_imgV_arrowUp);
    }
}

#pragma mark- 接受tbv信号

static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSNumber *s = [NSNumber numberWithInteger:((_bt_announcement.selected)?(_muA_data_announcement.count):(_muA_data_topic.count))];
        [signal setReturnValue:s];
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath  暂时把每个cell保存,后期有时间优化为只保存高度,返回cell时再异步计算cell的视图,目前刷新后所有cell的view都要重新创建
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        DLogInfo(@"%@",indexPath);
        
        if(indexPath.row==tableView._muA_differHeightCellView.count/*只创建没计算过的cell*/ || !tableView._muA_differHeightCellView || [tableView._muA_differHeightCellView count]==0)
        {//
            DYBCellForAnnouncement *cell = [[[DYBCellForAnnouncement alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            
//            cell.i_type=(_bt_announcement.selected)?0:1;
            [cell setContent:[((_bt_announcement.selected)?(_muA_data_announcement):(_muA_data_topic)) objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if (!tableView._muA_differHeightCellView) {
                tableView._muA_differHeightCellView=[NSMutableArray arrayWithCapacity:10];
            }
            if (![tableView._muA_differHeightCellView containsObject:cell]) {
                [tableView._muA_differHeightCellView addObject:cell];
            }
            
            NSNumber *s = [NSNumber numberWithInteger:cell.frame.size.height];
            [signal setReturnValue:s];
        }else{//之前计算过的cell
            NSNumber *s = [NSNumber numberWithInteger:((DYBCellForAnnouncement *)[tableView._muA_differHeightCellView objectAtIndex:indexPath.row]).frame.size.height];
            [signal setReturnValue:s];
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
        if (indexPath.row<tableview._muA_differHeightCellView.count) {
            cell=((UITableViewCell *)[tableview._muA_differHeightCellView objectAtIndex:indexPath.row]);
            cell.hidden=NO;
        }
        
        [signal setReturnValue:cell];
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        if (_bt_announcement.selected) {
            eclass_notice *model=[_muA_data_announcement objectAtIndex:indexPath.row];
            NSString *URL = ((target *)[model.target objectAtIndex:0]).targetlink;
            
            DYBClassNoticeDetailsViewController *web = [[DYBClassNoticeDetailsViewController alloc]init];
            web.str_url = URL;
            [self.drNavigationController pushViewController:web animated:YES];
            [web release];
        }else{
            eclass_notice *model=[_muA_data_topic objectAtIndex:indexPath.row];
            NSString *URL = ((target *)[model.target objectAtIndex:0]).targetlink;
            
            DYBClassNoticeDetailsViewController *web = [[DYBClassNoticeDetailsViewController alloc]init];
            web.str_url = URL;
            [self.drNavigationController pushViewController:web animated:YES];
            [web release];
        }
        
        [tableview deselectRowAtIndexPath:indexPath animated:YES];

        
    }    
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        if (_bt_announcement.selected) {
            
        }else{
            {//HTTP请求,话题
                [self.view setUserInteractionEnabled:NO];
                
                MagicRequest *request = [DYBHttpMethod eclass_topiclist:_modelClass.id offset:[NSString stringWithFormat:@"%d",_muA_data_topic.count] limit:[NSString stringWithFormat:@"%d",_tbv.i_pageNums] isAlert:NO receive:self];
                [request setTag:5];
                
                if (!request) {//无网路
                    [_tbv reloadData:NO];
                }
            }
        }
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        {//HTTP请求,班级公告|话题
            
            if (_bt_announcement.selected) {
                [self.view setUserInteractionEnabled:NO];
                
                MagicRequest *request = [DYBHttpMethod classNoticeList_id:_modelClass.id isAlert:NO receive:self];
                [request setTag:3];
                
                if (!request) {//无网路
                    [tableView reloadData:NO];
                }
                
            }else{
                {//HTTP请求,话题
                    [self.view setUserInteractionEnabled:NO];
                    
                    MagicRequest *request = [DYBHttpMethod eclass_topiclist:_modelClass.id offset:@"0" limit:[NSString stringWithFormat:@"%d",_tbv.i_pageNums] isAlert:NO receive:self];
                    [request setTag:4];
                    
                    if (!request) {//无网路
                        [_tbv reloadData:NO];
                    }
                
                    
                    
                }
            }
            
        }
    }

}

#pragma mark- 接受按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        if (bt)
        {
            switch (bt.tag) {
                case -1://进班级成员详情
                {
                    DYBClassMemberViewController *con=[[DYBClassMemberViewController alloc]init];
                    con.str_classID=_modelClass.id;
                    
                    [self.drNavigationController pushViewController:con animated:YES];
                    RELEASE(con);
                }
                    break;
                case -2://公告
                {
                    _bt_announcement.selected=YES;
                    _bt_topic.selected=NO;
                    if (_bt_announcement.selected) {
                        [_bt_announcement setTitleColor:ColorBlack];
                        [_bt_topic setTitleColor:ColorGray];
                    }
                    
                    [UIView animateWithDuration:0.5f animations:^{
                        [_imgV_arrowUp setCenter:CGPointMake(_bt_announcement.center.x,_imgV_arrowUp.center.y)];
                    }completion:^(BOOL b){
                        
                    }];
                    
                    if (!_muA_data_announcement) {
//                        [_tbv release_muA_differHeightCellView];
                        
                        {//HTTP请求,班级公告
                            [self.view setUserInteractionEnabled:NO];
                            
                            MagicRequest *request = [DYBHttpMethod classNoticeList_id:_modelClass.id isAlert:YES receive:self];
                            [request setTag:3];
                            
                            
                            if (!request) {//无网路
                                [self initNoDataView:@"暂无班级公告"];
                                [_tbv reloadData:NO];
                            }
                            
                        }
                    }else{
                        [_tbv release_muA_differHeightCellView];
                        [_tbv reloadData];
                        [self initNoDataView:@""];
                    }
                    
                 
                }
                    break;
                case -3://话题
                {
                    
                    _bt_topic.selected=YES;
                    _bt_announcement.selected=NO;
                    if (_bt_topic.selected) {
                        [_bt_announcement setTitleColor:ColorGray];
                        [_bt_topic setTitleColor:ColorBlack];
                    }
                    [UIView animateWithDuration:0.5f animations:^{
                        [_imgV_arrowUp setCenter:CGPointMake(_bt_topic.center.x,_imgV_arrowUp.center.y)];
                    }completion:^(BOOL b){
                        
                    }];
                    
                    if (!_muA_data_topic) {
                        [_tbv release_muA_differHeightCellView];
                        [_tbv reloadData];
                        
                        {//HTTP请求,话题
                            [self.view setUserInteractionEnabled:NO];
                            
                            MagicRequest *request = [DYBHttpMethod eclass_topiclist:_modelClass.id offset:@"0" limit:[NSString stringWithFormat:@"%d",_tbv.i_pageNums] isAlert:YES receive:self];
                            [request setTag:4];
                            
                            
                            
                            if (!request) {//无网路
                                [self initNoDataView:@"暂无班级话题"];
                                [_tbv reloadData:NO];
                            }
                            
                        }

                    }else{
                        [_tbv release_muA_differHeightCellView];
                        [_tbv reloadData];
                        [self initNoDataView:@""];
                    }

                }
                    break;
                case -4://班级列表
                {
                    DYBClassListViewController *con=[[DYBClassListViewController alloc]init];
//                    con.muA_classList=[NSMutableArray arrayWithArray:_muA_data_classList];
                    con.i_classIDByClassHome=[_modelClass.id intValue];
                    
                    [self.drNavigationController pushViewController:con animated:YES];
                    RELEASE(con);
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取已加入的班级列表
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    //                    NSDictionary *d=[response.data objectForKey:@"user_list"];
                    NSArray *list=[response.data objectForKey:@"eclass"];
                    if (_muA_data_classList.count>0 && list.count>0) {
                        [_muA_data_classList removeAllObjects];
                        
                        //                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        eclass *model = [eclass JSONReflection:d];
                        if (!_muA_data_classList) {
                            _muA_data_classList=[NSMutableArray arrayWithObject:model];
                            [_muA_data_classList retain];
                            
                            if ([model.active intValue]==1) {//设置活跃班级,默认加到0号下标
                                if (!_modelClass) {
                                    _modelClass=model;
                                }
                            }
                            
                        }else{
                            if ([model.active intValue]==1) {//设置活跃班级,插入到0号下标
                                
                                if (!_modelClass)
                                {
                                    _modelClass=model;
                                }
                                [_muA_data_classList addObject:model];

//                                [_muA_data_classList insertObject:model atIndex:0];
                            }else{
                                [_muA_data_classList addObject:model];
                            }
                        }
                    }
                    
                    {
                        if (_muA_data_classList.count>0 && list.count>0) {
                            if (!_modelClass) {//没有设置活跃班级,则当前显示最新加入的班级
                                _modelClass=[_muA_data_classList objectAtIndex:0];
                            }else{//找到当前要显示的班级
                            }
                            [self refreshClassInfo];
                            if (_muA_data_classList.count<=1) {
                                _bt_classList.hidden=YES;
                            }
                            
                            {//HTTP请求,班级(人数)详情
                                [self.view setUserInteractionEnabled:NO];
                                
                                MagicRequest *request = [DYBHttpMethod eclass_detail:_modelClass.id num:10000 page:1 isAlert:YES receive:self];
                                [request setTag:2];
                                
//                                if (!request) {//无网路
//                                    [_tbv reloadData:NO];
//                                }
                            }
                            
                            if(_bt_announcement.selected){//HTTP请求,班级公告
                                [self.view setUserInteractionEnabled:NO];
                                
                                MagicRequest *request = [DYBHttpMethod classNoticeList_id:_modelClass.id isAlert:YES receive:self];
                                [request setTag:3];
                                
//                                if (!request) {//无网路
//                                    [_tbv reloadData:NO];
//                                }
                            }else{//请求话题
                                {//HTTP请求,话题
                                    [self.view setUserInteractionEnabled:NO];
                                    
                                    MagicRequest *request = [DYBHttpMethod eclass_topiclist:_modelClass.id offset:@"0" limit:[NSString stringWithFormat:@"%d",_tbv.i_pageNums] isAlert:YES receive:self];
                                    [request setTag:4];
                                    
                                    if (!request) {//无网路
//                                        [self initNoDataView:@"暂无班级话题"];
                                    }
                                    
                                }
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
                            
                            [self initNoDataView];
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
            case 2://获取 班级(人数)详情
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    {//获取成员列表数据源
                        NSDictionary *d=[response.data objectForKey:@"user_list"];
                        NSArray *list=[d objectForKey:@"user"];
                        if (_muA_data_classSize.count>0 && list.count>0) {
                            [_muA_data_classSize removeAllObjects];
                            
//                            [_tbv release_muA_differHeightCellView];
                        }
                        
                        for (NSDictionary *d in list) {
                            user *model = [user JSONReflection:d];
                            if (!_muA_data_classSize) {
                                _muA_data_classSize=[NSMutableArray arrayWithObject:model];
                                [_muA_data_classSize retain];
                            }else{
                                [_muA_data_classSize addObject:model];
                            }
                        }
                    }
                    
                    {//刷新活跃班级model,因为在1号接口里返回的此model的pic字段没发
                        _modelClass=nil;
                        
                        NSDictionary *d=[response.data objectForKey:@"eclass"];
                        _modelClass = [eclass JSONReflection:d];
                        [_modelClass retain];
                    }
                 
                    
                    [self refreshClassInfo];
                    
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
//                    [_tbv reloadData:YES];
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
//                [_tbv.footerView changeState:PULLSTATEEND];
                
            }
                break;
            case 3://获取|刷新 公告
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    //                    NSDictionary *d=[response.data objectForKey:@"user_list"];
                    NSArray *list=[response.data objectForKey:@"notice_list"];
                    
                    if (_muA_data_announcement.count<1 && list.count<1) {
                        [self initNoDataView:@"暂无班级公告"];
                    }else {
                        if (bgview) {
                            for (UIView *v in bgview.subviews) {
                                [v removeFromSuperview];
                                v=nil;
                            }
                            [bgview removeFromSuperview];
                            bgview = nil;
                        }
                    }
                    
                    
                    if (_muA_data_announcement.count>0 || list.count>0) {
                        [_muA_data_announcement removeAllObjects];
                        
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        eclass_notice *model = [eclass_notice JSONReflection:d];
                        if (!_muA_data_announcement) {
                            _muA_data_announcement=[NSMutableArray arrayWithObject:model];
                            [_muA_data_announcement retain];
                        }else{
                            [_muA_data_announcement addObject:model];
                        }
                    }
                    
                    {
                        
                        if (_muA_data_announcement.count>0 && list.count>0) {
                            [self creatTbv];
                            [_tbv release_muA_differHeightCellView];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                            
                            [self.view setUserInteractionEnabled:YES];
                            return;
                        }else{//没获取到数据,恢复headerView

                        }
                        
                    }
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [_tbv release_muA_differHeightCellView];
                [_tbv reloadData:YES];
                [self initNoDataView:@"暂无班级公告"];
                
                [self.view setUserInteractionEnabled:YES];
                //                [_tbv.footerView changeState:PULLSTATEEND];
                
            }
                break;
            case 4://获取|刷新 话题
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"topicList"];
                    
                    if (_muA_data_announcement.count<1 && list.count<1) {
                        [self initNoDataView:@"暂无班级话题"];
                    }else {
                        if (bgview) {
                            for (UIView *v in bgview.subviews) {
                                [v removeFromSuperview];
                                v=nil;
                            }
                            [bgview removeFromSuperview];
                            bgview = nil;
                        }
                    }
                    
                    if (_muA_data_topic.count>0 || list.count>0) {
                        [_muA_data_topic removeAllObjects];
                        
                        [_tbv release_muA_differHeightCellView];
                    }
                    
                    for (NSDictionary *d in list) {
                        eclass_notice *model = [eclass_notice JSONReflection:d];
                        if (!_muA_data_topic) {
                            _muA_data_topic=[NSMutableArray arrayWithObject:model];
                            [_muA_data_topic retain];
                        }else{
                            [_muA_data_topic addObject:model];
                        }
                    }
                    
                    {
                        if (_muA_data_topic.count>0 && list.count>0) {
                            [self creatTbv];
                            [_tbv._muA_differHeightCellView removeAllObjects];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                [_tbv reloadData:NO];
                            }else{
                                [_tbv reloadData:YES];
                            }
                            
                            [self.view setUserInteractionEnabled:YES];
                            return;
                        }else{//没获取到数据,恢复headerView
                           
                        }
                        
                    }
                    
                                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [_tbv reloadData:YES];
                [self initNoDataView:@"暂无班级话题"];
                
                [self.view setUserInteractionEnabled:YES];
                //                [_tbv.footerView changeState:PULLSTATEEND];
                
            }
                break;
            case 5://加载更多 话题
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    NSArray *list=[response.data objectForKey:@"topicList"];
                    
                    for (NSDictionary *d in list) {
                        eclass_notice *model = [eclass_notice JSONReflection:d];
                        if (!_muA_data_topic) {
                            _muA_data_topic=[NSMutableArray arrayWithObject:model];
                            [_muA_data_topic retain];
                        }else{
                            [_muA_data_topic addObject:model];
                        }
                    }
                    
                    {
                        if (_muA_data_topic.count>0 && list.count>0) {
                            [self creatTbv];
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
