//
//  DYBPersonalPhotoImageController.m
//  DYiBan
//
//  Created by Song on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBPersonalPhotoImageController.h"
#import "UITableView+property.h"
#import "albums.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "DYBPersonlPageImgSeeViewController.h"
#define imgBgWidth       79
#define imgBgHeight      79

#define imgWidth        75
#define imgHeight       75
#define imgSpaceBetT    4
#define imgSpeceBetL    4
#import "DYBCustomLabel.h"
#import "UILabel+ReSize.h"
#import "UIView+MagicCategory.h"
@interface DYBPersonalPhotoImageController (){
    
    BOOL isWillRead;//是否还要加载
    UIView *numBack;
    
    
}
@property (nonatomic, retain) DYBCustomLabel *numLabel;
@property (nonatomic, retain) MagicUILabel *numLabel1;
@end

@implementation DYBPersonalPhotoImageController
@synthesize userId = _userId,photoid = _photoid,allImgCount = _allImgCount,albumName= _albumName;
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        [self.view setUserInteractionEnabled:NO];
        
        DLogInfo(@"============%@",_allImgCount);
        
        UIImage *backImage = [UIImage imageNamed:@"bg_photo_number"];
        numBack = [[UIView alloc]initWithFrame:CGRectMake(0, self.headHeight, backImage.size.width/2, backImage.size.height/2)];
        [numBack setBackgroundColor:[UIColor colorWithPatternImage:backImage]];
        [self.view addSubview:numBack];
        
        RELEASE(numBack);
        
        
        _numLabel = [[DYBCustomLabel alloc]initWithFrame:CGRectMake(10, 0, 0, 57)];
        [self creatLabel:_numLabel fontSize:30];
        [numBack addSubview:_numLabel];
        RELEASE(_numLabel);
        
        _numLabel.textAlignment = NSTextAlignmentCenter;
        if ([_allImgCount intValue] < 1) {
            _numLabel.text = @"0";
        }
        _numLabel.text = _allImgCount;
        [_numLabel sizeToFitByconstrainedSize:CGSizeMake(100/*最宽*/, 57)];
        
        _numLabel1 = [[MagicUILabel alloc]initWithFrame:CGRectMake(_numLabel.frame.size.width, 0, SCREEN_WIDTH-_numLabel.frame.size.width, 57)];
        _numLabel1.text = @"张图片";
        _numLabel1.textAlignment = NSTextAlignmentLeft;
        _numLabel1.textColor = ColorBlack;
        _numLabel1.backgroundColor = [UIColor clearColor];
        [numBack addSubview:_numLabel1];
        
        _numLabel.frame = CGRectMake(_numLabel.frame.origin.x, (57-_numLabel.frame.size.height)/2+5, _numLabel.frame.size.width, _numLabel.frame.size.height);
        _numLabel1.frame = CGRectMake(_numLabel.frame.origin.x+_numLabel.frame.size.width, (57-_numLabel.frame.size.height)/2+5, SCREEN_WIDTH-_numLabel.frame.size.width, _numLabel.frame.size.height);
        
        RELEASE(_numLabel1);
        
        
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:_albumName];
        self.rightButton.hidden = YES;
        [self backImgType:0];

        DLogInfo(@"======_userId=====%@",_userId);
        DLogInfo(@"======_photoid=====%@",_photoid);
        
        MagicRequest *request = [DYBHttpMethod albumList:_userId albumId:_photoid num:24 page:1 isAlert:YES receive:self];
        [request setTag:1];
        
        if (!request) {//无网路
            [self initNoDataView];
//            [_tbv.footerView changeState:VIEWTYPEFOOTER];
        }
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv release_muA_differHeightCellView];
        
        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}


#pragma mark- 初始化无数据提示view
-(void)initNoDataView
{
    UIImage *img=[UIImage imageNamed:@"ybx_big"];
    UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self.view Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    [imgV setFrame:CGRectMake(CGRectGetMinX(imgV.frame), CGRectGetMinY(imgV.frame)-50, CGRectGetWidth(imgV.frame), CGRectGetHeight(imgV.frame))];
    RELEASE(imgV);
    
    {
        MagicUILabel *lb=[[MagicUILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame)+20, 0, 0)];
        lb.backgroundColor=[UIColor clearColor];
        lb.textAlignment=NSTextAlignmentLeft;
        lb.font=[DYBShareinstaceDelegate DYBFoutStyle:20];
        lb.text=@"一张照片都没有";
        lb.textColor=ColorGray;
        lb.numberOfLines=2;
        lb.lineBreakMode=NSLineBreakByWordWrapping;
        [lb sizeToFitByconstrainedSize:CGSizeMake(240, 1000)];
        [self.view addSubview:lb];
        [lb changePosInSuperViewWithAlignment:0];
        
        lb.linesSpacing=20;
        [lb setNeedCoretext:YES];
        RELEASE(lb);
    }
    
    numBack.hidden = !imgV.hidden;
    
}


#pragma mark- 接受tbv信号


- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSInteger section = [[dict objectForKey:@"section"] integerValue];
        
        if (tableView.muA_allSectionKeys.count==0) {/*一个section模式*/
            
            NSNumber *s;
            if ([_tbv.muA_singelSectionData count] == 0) {
                s = [NSNumber numberWithInteger:0];
            }
            else{
                s = [NSNumber numberWithInteger:[_tbv.muA_singelSectionData count]/4+1];
            }
            [signal setReturnValue:s];
        }else{
            NSString *key = [tableView.muA_allSectionKeys objectAtIndex:section];
            NSArray *array = [tableView.muD_allSectionValues objectForKey:key];
            NSNumber *s = [NSNumber numberWithInteger:array.count];
            [signal setReturnValue:s];
        }
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if (tableView.muA_allSectionKeys.count==0/*一个section模式*/) {/*一个section模式*/
            NSNumber *s = [NSNumber numberWithInteger:1];
            [signal setReturnValue:s];
        }else{
            NSNumber *s = [NSNumber numberWithInteger:tableView.muA_allSectionKeys.count];
            [signal setReturnValue:s];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath  暂时把每个cell保存,后期有时间优化为只保存高度,返回cell时再异步计算cell的视图,目前刷新后所有cell的view都要重新创建
    {
            
            NSNumber *s = [NSNumber numberWithInteger:imgBgHeight];
            [signal setReturnValue:s];
        
    }
    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell  只返回显示的cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
        
        UITableViewCell *cell = [_tbv cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            int row = [indexPath row]+1;
            int nTotal = 0;
            
            
            int nAll = [_tbv.muA_singelSectionData count];
            int nCur = row*4;
            
            if ((nAll - nCur) > 0) {
                nTotal = 4;
            }
            else{
                nTotal = [_tbv.muA_singelSectionData count] - (row-1)*4;
            }
            
            for (int i = 0 ; i < nTotal; i++)
            {
                
                albums *al = [_tbv.muA_singelSectionData objectAtIndex:(row-1)*4+i];
                
                UIImageView *imgBuBack = [[UIImageView alloc] initWithFrame:CGRectMake(imgSpeceBetL+i*(imgBgWidth), imgSpaceBetT, imgBgWidth, imgBgHeight)];
                [imgBuBack setUserInteractionEnabled:YES];
                [imgBuBack setImage:[UIImage imageNamed:@""]];
                UIButton *imgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgWidth, imgHeight)];
                [imgButton setBackgroundColor:[UIColor clearColor]];
                [imgButton setTag:(row-1)*4+i+1];
                [imgButton setImageWithURL:[NSURL URLWithString:al.pic_s] placeholderImage:[UIImage imageNamed:@"no_pic_50.png"]];
                [imgButton addTarget:self action:@selector(imgAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:imgBuBack];
                [imgBuBack addSubview:imgButton];
                [imgBuBack release];
                [imgButton release];
                UIImageView *onRealImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
//                [onRealImg setImage:[UIImage imageNamed:@"album_mask.png"]];
                [onRealImg setImage:[UIImage imageNamed:nil]];
                [imgButton addSubview:onRealImg];
                [onRealImg release];
            }
        }
        
        [signal setReturnValue:cell];
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        
        {//HTTP请求已加入的班级列表
            [self.view setUserInteractionEnabled:NO];
            
            MagicRequest *request = [DYBHttpMethod albumList:_userId albumId:_photoid num:24 page:++_tbv._page isAlert:YES receive:self];
            [request setTag:2];
            
            if (!request) {//无网路
                //                [tableView setUpdateState:DUpdateStateNomal];
            }
        }
        
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        //        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        {//HTTP请求已加入的班级列表
            [self.view setUserInteractionEnabled:NO];
            _tbv._page = 1;
            MagicRequest *request = [DYBHttpMethod albumList:_userId albumId:_photoid num:24 page:1 isAlert:YES receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
                //                [tableView setUpdateState:DUpdateStateNomal];
            }
        }
    }
}

//img事件
- (void)imgAction:(id)sender{
    
    NSMutableArray *newImgList = [[NSMutableArray alloc] initWithArray:_tbv.muA_singelSectionData];
    
    UIButton *bt = (UIButton *)sender;
    DYBPersonlPageImgSeeViewController *detail = [[DYBPersonlPageImgSeeViewController alloc] init];
    [detail setGetInObjectl:[_tbv.muA_singelSectionData objectAtIndex:[bt tag]-1]];
    [detail setImgArray:newImgList];
    [detail setAlbumId:_photoid];
    [detail setUserId:_userId];
    [detail setIswillred:isWillRead];

    [detail setAllImgCount:[_allImgCount integerValue]];
    [newImgList release];
    
    [self.drNavigationController pushViewController:detail animated:YES];
    RELEASE(detail);
}


- (void)creatLabel:(DYBCustomLabel*)label fontSize:(int)size {
    
    label.font = [DYBShareinstaceDelegate DYBFoutStyle:size];  //字体和大小设置
    label.textColor = ColorBlack;
    label.backgroundColor = [UIColor clearColor];
   
    
}


#pragma mark-
-(void)creatTbv{
    
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.headHeight-20) isNeedUpdate:YES];
        _tbv._cellH=50;
        [self.view addSubview:_tbv];
        _tbv.tag=-1;
        _tbv._page=1;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
//        [_tbv.footerView changeState:PULLSTATEEND];
        [_tbv setTableViewType:DTableViewSlime];
        _tbv.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 57)];
        _tbv.tableHeaderView.backgroundColor = [UIColor clearColor];
    }
    
    [self.view  bringSubviewToFront:numBack];
    
}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取|刷新 班级成员
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    
                    NSString *havenext = [response.data objectForKey:@"havenext"];
                    
                    DLogInfo(@"=======havenext====%@",havenext);
                    NSArray *list = [response.data objectForKey:@"albums"];
                    
                    
                    
                    if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                        [_tbv.muA_singelSectionData removeAllObjects];
                        
                        [_tbv release_muA_differHeightCellView];
                    }else if (_tbv.muA_singelSectionData.count<1 && list.count<1) {
                        
                        [self initNoDataView];
                        return;
                    }
                    
                    for (NSDictionary *d in list) {
                        albums *model = [albums JSONReflection:d];
                        if (!_tbv.muA_singelSectionData) {
                            [self creatTbv];
                            
                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
                            [_tbv.muA_singelSectionData retain];
                            
                        }else{
                            
                            [_tbv.muA_singelSectionData addObject:model];
                            
                        }
                    }
                    
                    DLogInfo(@"=======%d",[_tbv.muA_singelSectionData count]);
                    
                    {
                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                            [_tbv._muA_differHeightCellView removeAllObjects];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                isWillRead = YES;
                                [_tbv reloadData:NO];
                            }else{
                                isWillRead = NO;
                                [_tbv reloadData:YES];
                            }
                        }else{//没获取到数据,恢复headerView
                            [_tbv reloadData:YES];
                        }
                        
                    }
                    
                    [self.view setUserInteractionEnabled:YES];
                    return;
                    
                }else if ([response response] ==khttpfailCode){
                    
                    DLogInfo(@"==========%@",response.message);
                }
                
                [self.view setUserInteractionEnabled:YES];
                
            }
                break;
            case 2://加载
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                
                    NSArray *list = [response.data objectForKey:@"albums"];
                    
                    for (NSDictionary *d in list) {
                        albums *model = [albums JSONReflection:d];
                        [_tbv.muA_singelSectionData addObject:model];
                    }
                    
                    
                    
                    {
                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
                            [_tbv._muA_differHeightCellView removeAllObjects];
                            
                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
                                isWillRead = YES;
                                [_tbv reloadData:NO];
                                DLogInfo(@"===========list是否有下一页%d",isWillRead);
                            }else{
                                isWillRead = NO;
                                [_tbv reloadData:YES];
                                DLogInfo(@"===========list是否有下一页%d",isWillRead);
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
            }
                break;

        }
    }
}



@end
