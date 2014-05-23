//
//  DYBCheckInMapViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-4.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCheckInMapViewController.h"
#import "DYBCheckInMainViewController.h"
#import "UIView+MagicCategory.h"
@interface DYBCheckInMapViewController ()

@end

@implementation DYBCheckInMapViewController
@synthesize arrPlaceList = _arrPlaceList;
@synthesize lat = _lat;
@synthesize lng = _lng;

DEF_SIGNAL(SELFLOCATION)
DEF_SIGNAL(LOCATIONPRIVATE)
DEF_SIGNAL(LOCATIONPRIVATEFOLD)
DEF_SIGNAL(BTNPRIVATE)
DEF_SIGNAL(BTNPRIVATESELECTED)

DEF_NOTIFICATION(CHECKINMAINVIEWREFREASH)

- (void)dealloc{
    [super dealloc];

//    [_mapView removeOverlays:_mapView.overlays];/*百度地图Marker*/
    
//    _mapView.delegate = nil;/*百度地图Marker*/
//    RELEASEOBJ(_mapView);/*百度地图Marker*/
    
//    _search.delegate = nil;/*百度地图Marker*/
//    RELEASEOBJ(_search);/*百度地图Marker*/

}

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.headview setTitle:@"我的位置"];
        [self backImgType:0];
        [self backImgType:3];
        
    }else if ([signal is:[MagicViewController CREATE_VIEWS]]){
        _arrAnnotation = [[NSMutableArray alloc] init];
        nSelRow = 0;

        /*************************************************************/
        /*******************百度地图Marker*****************************/
        /*************************************************************/
//        if (!_mapView) {
//            _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 216)];
//            _mapView.showsUserLocation = YES;
//            _mapView.delegate = self;
//            _search = [[BMKSearch alloc]init];
//            _search.delegate = self;
//            [self.view addSubview:_mapView];
//            
//            _annotation = [[BMKPointAnnotation alloc]init];
//            [_mapView setTag:100];
//            [_mapView addAnnotation:_annotation];
//            
//            [self initFonctionButton];      
//        }
        /*************************************************************/
        
        
//        _tabMapAddress = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame), self.view.frame.size.width, self.frameHeight-self.headHeight-CGRectGetHeight(_mapView.frame)) isNeedUpdate:NO];
        [_tabMapAddress setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_tabMapAddress];
        RELEASE(_tabMapAddress);
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:nSelRow inSection:0];
        UITableViewCell *cell = [_tabMapAddress cellForRowAtIndexPath:indexPath];
        [self selectCell:cell];
    }
}

-(void)initFonctionButton{
    UIImage *imgLoca = [UIImage imageNamed:@"btn_selflocation.png"];
    MagicUIButton *_btnLocate = [[MagicUIButton alloc] initWithFrame:CGRectMake(8, 10, imgLoca.size.width/2, imgLoca.size.height/2)];
    [_btnLocate setImage:imgLoca forState:UIControlStateNormal];
    [_btnLocate addSignal:[DYBCheckInMapViewController SELFLOCATION] forControlEvents:UIControlEventTouchUpInside];
//    [_mapView addSubview:_btnLocate];/*百度地图Marker*/
//    [_mapView bringSubviewToFront:_btnLocate];/*百度地图Marker*/
    RELEASE(_btnLocate);
    
    UIImage *imgprivate = [UIImage imageNamed:@"btn_loctionprivate.png"];
    _btnPrivate = [[MagicUIButton alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_btnLocate.frame)+10, imgLoca.size.width/2, imgLoca.size.height/2)];
    [_btnPrivate setImage:imgprivate forState:UIControlStateNormal];
    [_btnPrivate addSignal:[DYBCheckInMapViewController LOCATIONPRIVATE] forControlEvents:UIControlEventTouchUpInside];
//    [_mapView addSubview:_btnPrivate];/*百度地图Marker*/
//    [_mapView bringSubviewToFront:_btnPrivate];/*百度地图Marker*/
    [_btnPrivate setSelected:NO];
    RELEASE(_btnPrivate);
    
    
    UIImage *imgICOC = [self GetPrivacyStatus];
    _ICONPrivate= [[MagicUIImageView alloc] initWithFrame:CGRectMake(8.5, 8.5, 38, 38)];
    [_ICONPrivate setBackgroundColor:[UIColor clearColor]];
    [_ICONPrivate setImage:imgICOC];
    [_ICONPrivate setUserInteractionEnabled:NO];
    [_btnPrivate addSubview:_ICONPrivate];
    RELEASE(_ICONPrivate);
    
    UIImage *imgprivateBKG = [UIImage imageNamed:@"bkg_loctionprivate.png"];
    _viewPrivateBKG= [[MagicUIImageView alloc] initWithFrame:CGRectMake(8, 44+10+10+imgLoca.size.height/2, imgLoca.size.width/2, imgLoca.size.height/2)];
    [_viewPrivateBKG setBackgroundColor:[UIColor clearColor]];
    [_viewPrivateBKG setImage:imgprivateBKG];
    [_viewPrivateBKG setHidden:YES];
    [_viewPrivateBKG setAlpha:0];
    [_viewPrivateBKG setUserInteractionEnabled:YES];
    [self.view addSubview:_viewPrivateBKG];
    RELEASE(_viewPrivateBKG);
    
    UIImage *imgunprivate = [UIImage imageNamed:@"btn_private_unlock.png"];
    _btnSelUnPrivate = [[MagicUIButton alloc] initWithFrame:CGRectMake(41, 11, imgunprivate.size.width/2, imgunprivate.size.height/2)];
    [_btnSelUnPrivate setImage:imgunprivate forState:UIControlStateNormal];
    [_btnSelUnPrivate setTag:-1];
    [_btnSelUnPrivate addSignal:[DYBCheckInMapViewController BTNPRIVATE] forControlEvents:UIControlEventTouchUpInside];
    [_viewPrivateBKG addSubview:_btnSelUnPrivate];
    RELEASE(_btnSelUnPrivate);
    
    UIImage *imgprivatefriend = [UIImage imageNamed:@"btn_private_friend.png"];
    _btnSelFriends = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnSelUnPrivate.frame)+3, CGRectGetMinY(_btnSelUnPrivate.frame)+1, imgprivatefriend.size.width/2, imgprivatefriend.size.height/2)];
    [_btnSelFriends setImage:imgprivatefriend forState:UIControlStateNormal];
    [_btnSelFriends setTag:-2];
    [_btnSelFriends addSignal:[DYBCheckInMapViewController BTNPRIVATE] forControlEvents:UIControlEventTouchUpInside];
    [_viewPrivateBKG addSubview:_btnSelFriends];
    RELEASE(_btnSelFriends);
    
    UIImage *imgselprivate = [UIImage imageNamed:@"btn_private_self.png"];
    _btnSelPrivate = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnSelFriends.frame)+1, CGRectGetMinY(_btnSelFriends.frame), imgselprivate.size.width/2, imgselprivate.size.height/2)];
    [_btnSelPrivate setImage:imgselprivate forState:UIControlStateNormal];
    [_btnSelPrivate setTag:-3];
    [_btnSelPrivate addSignal:[DYBCheckInMapViewController BTNPRIVATE] forControlEvents:UIControlEventTouchUpInside];
    [_viewPrivateBKG addSubview:_btnSelPrivate];
    RELEASE(_btnSelPrivate);
    
    _btnPrivateSelected = [[MagicUIButton alloc] initWithFrame:CGRectMake(8.5, 8.5, 38, 38)];
    [_btnPrivateSelected setImage:imgICOC forState:UIControlStateNormal];
    [_btnPrivateSelected addSignal:[DYBCheckInMapViewController BTNPRIVATESELECTED] forControlEvents:UIControlEventTouchUpInside];
    [_viewPrivateBKG addSubview:_btnPrivateSelected];
    RELEASE(_btnPrivateSelected);
}

#pragma mark - 返回Button处理
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
//        BMKPointAnnotation* ann;/*百度地图Marker*/
//        NSInteger nIndex = [_tabMapAddress indexPathForSelectedRow].row;
//        NSString *strRefulse = nil;
//        
//        if (nIndex == 0) {
//            ann = _annotation;/*百度地图Marker*/
//        }
//        else
//            ann = [_arrAnnotation objectAtIndex:nIndex-1];
//        
//        NSString *strPrivacy = [[NSUserDefaults standardUserDefaults] stringForKey:@"SignPrivacy"];
//        
//        if ([strPrivacy intValue] == 0) {
//            strRefulse = @"0";
//        }
//        else if ([strPrivacy intValue] == 1){
//            strRefulse = @"1, 2, 3, 4";
//        }
//        else{
//            strRefulse = @"5";
//        }
//        
//        NSString *strPlace = [_arrPlaceList objectAtIndex:nIndex];
//        
//        if ([strPlace isEqualToString:@"我在这里"] || [strPlace isEqualToString:@"暂时无法解析地址"]) {
//            strPlace = nil;
//        }
//        
//        MagicRequest *request = [DYBHttpMethod user_sign_add:[NSString stringWithFormat:@"%f", ann.coordinate.longitude] lat:[NSString stringWithFormat:@"%f", ann.coordinate.latitude] address:strPlace refulse:strRefulse isAlert:YES receive:self];
//        request.tag = -1;        
    }else if ([signal is:[DYBBaseViewController BACKBUTTON]]){
        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }
    
}

- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{
    if ([request succeed]){
        if (request.tag == -1){/*初始化*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                NSString *strResult = [respose.data objectForKey:@"result"];
                
                if ([strResult isEqualToString:@"1"]){
                    [self.drNavigationController popVCAnimated:YES];
                    [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
                    [self sendViewSignal:[DYBCheckInMainViewController REFREASHINFO] withObject:nil from:self target:[[DYBUITabbarViewController sharedInstace] getFirstViewVC]];
//                    [self postNotification:[DYBCheckInMapViewController CHECKINMAINVIEWREFREASH]];
                }
                else{
                       [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:respose.message targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
                }
            }
        }
    }else if ([request failed]){
        [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"签到失败！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
    }
}

#pragma mark- 接受其他信号
- (void)handleViewSignal_DYBCheckInMapViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBCheckInMapViewController SELFLOCATION]]){
//        BMKCoordinateRegion region;
//        region.center.latitude  = [self.lat floatValue];
//        region.center.longitude = [self.lng floatValue];
//        [_mapView setRegion:region animated:YES];/*百度地图Marker*/
    }else if ([signal is:[DYBCheckInMapViewController LOCATIONPRIVATE]]){

        [self.view bringSubviewToFront:_viewPrivateBKG];
        [_btnPrivate setHidden:YES];
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.3f];
        
        [_viewPrivateBKG setHidden:NO];
        [_viewPrivateBKG setAlpha:1];
        [_viewPrivateBKG setFrame:CGRectMake(CGRectGetMinX(_viewPrivateBKG.frame), CGRectGetMinY(_viewPrivateBKG.frame), 200, 55)];
        
        [UIView commitAnimations];

    }else if ([signal is:[DYBCheckInMapViewController BTNPRIVATESELECTED]]){
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.5f];
        [_viewPrivateBKG setFrame:CGRectMake(CGRectGetMinX(_viewPrivateBKG.frame), CGRectGetMinY(_viewPrivateBKG.frame), CGRectGetWidth(_btnPrivate.frame), CGRectGetHeight(_btnPrivate.frame))];
        [_viewPrivateBKG setAlpha:0];
        [UIView commitAnimations];
        
        [self performSelector:@selector(HiddenPrivateBKG) withObject:nil afterDelay:0.3f];
    }else if ([signal is:[DYBCheckInMapViewController BTNPRIVATE]]){
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        if (bt){
            switch (bt.tag) {
                case -1:
                    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"SignPrivacy"];
                    break;
                case -2:
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"SignPrivacy"];
                    break;
                case -3:
                    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"SignPrivacy"];
                    break;
                default:
                    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"SignPrivacy"];
                    break;
            }
        }
        
        UIImage *imgICOC = [self GetPrivacyStatus];
        [_btnPrivateSelected setImage:imgICOC forState:UIControlStateNormal];
        [self sendViewSignal:[DYBCheckInMapViewController BTNPRIVATESELECTED]];
    }

}

-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
    }
}


- (UIImage *)GetPrivacyStatus{
    // SignPrivacy key: 0,公开；1, 易友可见；2, 仅自己可见
    NSString *strPrivacy = [[NSUserDefaults standardUserDefaults] stringForKey:@"SignPrivacy"];
    if ([strPrivacy length] == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"SignPrivacy"];
    }
    
    UIImage *imgStatus = nil;

    switch([strPrivacy intValue]){
        case 0:
            imgStatus = [UIImage imageNamed:@"btn_Selprivate_open.png"];
            break;
        case 1:
            imgStatus = [UIImage imageNamed:@"btn_Selprivate_friend.png"];
            break;
        case 2:
            imgStatus = [UIImage imageNamed:@"btn_Selprivate_self.png"];
            break;
        default:
            break;
    }

    return imgStatus;
}

- (void)HiddenPrivateBKG{
    UIImage *imgICOC = [self GetPrivacyStatus];
    [_ICONPrivate setImage:imgICOC];
    
    [_viewPrivateBKG setHidden:NO];
    [_btnPrivate setHidden:NO];
    [self.view bringSubviewToFront:_btnPrivate];
}

#pragma mark- 只接受UITableView信号
- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        NSNumber *s = [NSNumber numberWithInteger:_arrPlaceList.count];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        NSNumber *s = [NSNumber numberWithInteger:45];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        [signal setReturnValue:nil];
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        static NSString *reuseIdentifier = @"reuseIdentifier";
        
        UITableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        if (!cell) {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }else{
            for (UIView *view  in [cell subviews]) {
                [view removeFromSuperview];
            }
        }
        
        UIImage *imgRound = nil;
        
        if (indexPath.row == nSelRow) {
            imgRound = [UIImage imageNamed:@"radio_on.png"];
        }else{
            imgRound = [UIImage imageNamed:@"radio_off.png"];
        }
        
        MagicUIImageView *_selStatus = [[MagicUIImageView alloc] initWithFrame:CGRectMake(15, 10, imgRound.size.width/2, imgRound.size.height/2)];
        [_selStatus setBackgroundColor:[UIColor clearColor]];
        [_selStatus setImage:imgRound];
        [cell addSubview:_selStatus];
        RELEASE(_selStatus);
        
        MagicUILabel *_lbText = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selStatus.frame)+15, 10, 270, 25)];
        [_lbText setFont:[DYBShareinstaceDelegate DYBFoutStyle:17]];
        [_lbText setBackgroundColor:[UIColor clearColor]];
        [_lbText setTextColor:ColorBlack];
        [_lbText setLineBreakMode:NSLineBreakByCharWrapping];
        [_lbText setText:[_arrPlaceList objectAtIndex:indexPath.row]];
        [cell addSubview:_lbText];
        RELEASE(_lbText);
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(cell.frame) , 1)];
        [viewLine setBackgroundColor:ColorDivLine];
        [cell addSubview:viewLine];
        [cell bringSubviewToFront:viewLine];
        RELEASE(viewLine);
        
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        nSelRow = indexPath.row;
        
        [self SelectAnn:nSelRow];
        
        UIImage *imgRound = [UIImage imageNamed:@"radio_off.png"];
        
        for (int i = 0; i < [_arrPlaceList count]; i++) {
            UITableViewCell *cell = [_tabMapAddress cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            for (UIView *view in cell.subviews) {
                if ([view isKindOfClass:[MagicUIImageView class]]) {
                    [(MagicUIImageView *)view setImage:imgRound];
                }
            }
            
        }
        
        UITableViewCell *cell = [_tabMapAddress cellForRowAtIndexPath:indexPath];
        [self selectCell:cell];
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{

    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }
}

-(void)selectCell:(UITableViewCell *)cell{
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:[MagicUIImageView class]]) {
            [(MagicUIImageView *)view setImage:[UIImage imageNamed:@"radio_on.png"]];
        }
    }
}
/*
#pragma mark -  百度地图Marker
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        //初始化一个大头针标注
        //        NSLog(@"I'm coming!");
        
        if (mapView.tag == 100)
            newAnnotation.pinColor = BMKPinAnnotationColorRed;
        else if (mapView.tag == 101)
            newAnnotation.pinColor = BMKPinAnnotationColorGreen;
        
        newAnnotation.animatesDrop = YES;
        newAnnotation.draggable = NO;
        return newAnnotation;
    }
    return nil;
}

//更新坐标
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    DLogInfo(@"更新坐标");
    [mapView setShowsUserLocation:NO];
    
    if (userLocation != nil) {
        //大头针摆放的坐标，必须从这里进行赋值，否则取不到值，这里可能涉及到委托方法执行顺序的问题
        CLLocationCoordinate2D coor;
        coor.latitude = userLocation.location.coordinate.latitude;
        coor.longitude = userLocation.location.coordinate.longitude;
        _annotation.coordinate = coor;
//        _annotation.title = address;
        
        CLLocationDistance radiusMeters = 500; //设置搜索范围
        [_search poiMultiSearchNearBy:@[@"学校", @"美食", @"小区", @"交通"] center:_mapView.centerCoordinate radius:radiusMeters pageIndex:0];
//        [Static addAlertView:_tableView];
    }
    
    
}

//定位失败
-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{ 
    DLogInfo(@"定位错误%@",error);
    [mapView setShowsUserLocation:NO];
}

- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
	if (error == BMKErrorOk) {
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
		for (int i = 0; i < result.poiInfoList.count; ++i) {
			BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
			BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
			item.coordinate = poi.pt;
			item.title = poi.name;
            DLogInfo(@"place name:%@", poi.name);
            
            [_mapView setTag:101];
			[_mapView addAnnotation:item];
            [_arrPlaceList addObject:poi.name];
            [_arrAnnotation addObject:item];
            
			[item release];
		}
        
//        [Static removeAlertView:_tableView];
        [_tabMapAddress reloadData:YES];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [_tabMapAddress cellForRowAtIndexPath:indexPath];
        [self selectCell:cell];
    }
    
//    [[header rightButton] setHidden:NO];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tabMapAddress selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
}

-(void)SelectAnn:(int)index{
    BMKPointAnnotation* ann;
    
    if (index == 0) {
        ann = _annotation;
    }
    else
        ann = [_arrAnnotation objectAtIndex:index-1];
    
    [_mapView selectAnnotation:ann animated:YES];
    [_mapView setCenterCoordinate:ann.coordinate animated:YES];
}

//定位停止
-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    
    DLogInfo(@"定位停止");
    
    BMKCoordinateRegion region;
    region.center.latitude  = mapView.userLocation.location.coordinate.latitude;
    region.center.longitude = mapView.userLocation.location.coordinate.longitude;
    
    DLogInfo(@"%f, %f",region.center.latitude , region.center.longitude);
    
    self.lat = [NSString stringWithFormat:@"%f", region.center.latitude];
    self.lng = [NSString stringWithFormat:@"%f", region.center.longitude];
    
    [_mapView setRegion:region];
    
    DLogInfo(@"lng:%@, lat:%@", self.lng, self.lat);
    if ([[_arrPlaceList objectAtIndex:0] isEqualToString:@"我在这里"])
        [_search reverseGeocode:mapView.userLocation.location.coordinate];
    
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error{
    DLogInfo(@"%@", result.strAddr);
    _address = [NSString stringWithFormat:@"%@",result.strAddr];

}
*/

@end
