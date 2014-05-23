//
//  DYBCheckInMainViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-3.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCheckInMainViewController.h"
#import "sign_datelog.h"
#import "sign_info.h"
#import "sgin_list.h"
#import "user.h"
#import "DYBPointAnnotation.h"
#import "DYBCheckInMapViewController.h"
#import "DYBMapLocationViewController.h"

@interface DYBCheckInMainViewController ()

@end

@implementation DYBCheckInMainViewController
@synthesize address= _address;

DEF_SIGNAL(REFREASHINFO)

- (void)dealloc{
    [super dealloc];
    
//    [self unobserveAllNotification];
    
    RELEASEDICTARRAYOBJ(_arrAnnotation);
    RELEASEDICTARRAYOBJ(_arrAnnInfo);
    RELEASEDICTARRAYOBJ(_arrAnnView);

//    [_mapView removeOverlays:_mapView.overlays];/*百度地图Marker*/
    
//    _mapView.delegate = nil;/*百度地图Marker*/
//    RELEASEOBJ(_mapView);/*百度地图Marker*/
    
//    _search.delegate = nil;/*百度地图Marker*/
//    RELEASEOBJ(_search);/*百度地图Marker*/

    RELEASE(_bubbleView);
}


#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.headview setTitle:@"签到"];
        [self backImgType:2];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]]){
        
        _arrAnnotation = [[NSMutableArray alloc] init];
        _arrAnnInfo = [[NSMutableArray alloc] init];
        _arrAnnView = [[NSMutableArray alloc] init];
        _dicBubbleView = [[NSMutableDictionary alloc] init];
        
        _bLocate = NO;
        _bSigned = NO;
        
//        [self observeNotification:[DYBCheckInMapViewController CHECKINMAINVIEWREFREASH]];

/*************************************************************/
/*******************百度地图Marker*****************************/
/*************************************************************/
//        if (!_mapView) {
//            _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.frameHeight-self.headHeight)];
//            _mapView.showsUserLocation = YES;
//            _mapView.delegate = self;
//            _search = [[BMKSearch alloc]init];
//            _search.delegate = self;
//            [self.view addSubview:_mapView];
//        }
/*************************************************************/
        
        if (!_btnMySelf) {
            UIImage *img= [UIImage imageNamed:@"2tabs_left_def"];
            _btnMySelf = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0,img.size.width/2, img.size.height/2)];
            _btnMySelf.tag=-1;
            _btnMySelf.showsTouchWhenHighlighted=YES;
            _btnMySelf.backgroundColor=[UIColor clearColor];
            [_btnMySelf addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_btnMySelf setBackgroundImage:img forState:UIControlStateNormal];
            [_btnMySelf setBackgroundImage:[UIImage imageNamed:@"2tabs_left_sel"] forState:UIControlStateSelected];
            [_btnMySelf setTitle:@"我"];
            [_btnMySelf setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:14]];
//            [_mapView addSubview:_btnMySelf];/*百度地图Marker*/
            RELEASE(_btnMySelf);
            _btnMySelf.selected=YES;
        }
        
        if (!_btnFriends) {
            UIImage *img= [UIImage imageNamed:@"2tabs_right_def"];
            _btnFriends = [[MagicUIButton alloc] initWithFrame:CGRectMake(_btnMySelf.frame.origin.x+_btnMySelf.frame.size.width, _btnMySelf.frame.origin.y,_btnMySelf.frame.size.width, _btnMySelf.frame.size.height)];
            _btnFriends.tag=-2;
            _btnFriends.showsTouchWhenHighlighted=YES;
            _btnFriends.backgroundColor=[UIColor clearColor];
            [_btnFriends addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_btnFriends setBackgroundImage:img forState:UIControlStateNormal];
            [_btnFriends setBackgroundImage:[UIImage imageNamed:@"2tabs_right_sel"] forState:UIControlStateSelected];
            [_btnFriends setTitle:@"好友"];
            [_btnFriends setTitleColor:ColorBlue];
            [_btnFriends setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:14]];
//            [_mapView addSubview:_btnFriends];/*百度地图Marker*/
            RELEASE(_btnFriends);
        }
        
        if (!_viewCheckinInfo) {
//            _viewCheckinInfo = [[DYBBaseView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_mapView.frame)-168, CGRectGetWidth(_mapView.frame), 170)];/*百度地图Marker*/
            [_viewCheckinInfo setBackgroundColor:[UIColor whiteColor]];
            [_viewCheckinInfo setAlpha:0.9];
//            [_mapView addSubview:_viewCheckinInfo];/*百度地图Marker*/
            RELEASE(_viewCheckinInfo);
            
            [self creatCheckinInfoView];
        }
        
        [self DYB_GetUserSignDatelog];
        [self DYB_GetUserSignMap];
    }
}

#pragma mark- 签到信息面板初始化
- (void)creatCheckinInfoView{
//    MagicUIImageView *_imgShadowLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
//    [_imgShadowLine setImage:[UIImage imageNamed:@"line_shadow.png"]];
//    [_imgShadowLine setBackgroundColor:[UIColor clearColor]];
//    [_viewCheckinInfo addSubview:_imgShadowLine];
//    RELEASE(_imgShadowLine);
 
    UIImage *imgContinuous= [UIImage imageNamed:@"icon_continuousdays.png"];
    MagicUIImageView *_imgContinuousdays = [[MagicUIImageView alloc] initWithFrame:CGRectMake(55, 34, imgContinuous.size.width/2, imgContinuous.size.height/2)];
    [_imgContinuousdays setImage:imgContinuous];
    [_imgContinuousdays setBackgroundColor:[UIColor clearColor]];
    [_viewCheckinInfo addSubview:_imgContinuousdays];
    RELEASE(_imgContinuousdays);
    
    MagicUILabel *lbContinuous = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imgContinuousdays.frame)-5, CGRectGetMaxY(_imgContinuousdays.frame)+6, 60, 16)];
    [lbContinuous setBackgroundColor:[UIColor clearColor]];
    [lbContinuous setTextAlignment:NSTextAlignmentCenter];
    [lbContinuous setText:@"连续天数"];
    [lbContinuous setFont:[DYBShareinstaceDelegate DYBFoutStyle:15]];
    [lbContinuous setTextColor:ColorCheckinFontColor];
    [_viewCheckinInfo addSubview:lbContinuous];
    RELEASE(lbContinuous);
    
    _lbContinuousCount = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbContinuous.frame)-15, CGRectGetMaxY(lbContinuous.frame)+15, 90, 40)];
    [_lbContinuousCount setBackgroundColor:[UIColor clearColor]];
    [_lbContinuousCount setTextAlignment:NSTextAlignmentCenter];
    [_lbContinuousCount setFont:[DYBShareinstaceDelegate DYBFoutStyle:40]];
    [_lbContinuousCount setTextColor:ColorCheckinFontColor];
    [_viewCheckinInfo addSubview:_lbContinuousCount];
    RELEASE(_lbContinuousCount);

    UIImage *imgTotal= [UIImage imageNamed:@"icon_totaldays.png"];
    MagicUIImageView *_imgTotaldays = [[MagicUIImageView alloc] initWithFrame:CGRectMake(111+CGRectGetMaxX(_imgContinuousdays.frame), 34, imgContinuous.size.width/2, imgContinuous.size.height/2)];
    [_imgTotaldays setImage:imgTotal];
    [_imgTotaldays setBackgroundColor:[UIColor clearColor]];
    [_viewCheckinInfo addSubview:_imgTotaldays];
    RELEASE(_imgTotaldays);
    
    MagicUILabel *lbTotal = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imgTotaldays.frame)-5, CGRectGetMaxY(_imgTotaldays.frame)+6, 60, 16)];
    [lbTotal setBackgroundColor:[UIColor clearColor]];
    [lbTotal setTextAlignment:NSTextAlignmentCenter];
    [lbTotal setText:@"累计天数"];
    [lbTotal setFont:[DYBShareinstaceDelegate DYBFoutStyle:15]];
    [lbTotal setTextColor:ColorCheckinFontColor];
    [_viewCheckinInfo addSubview:lbTotal];
    RELEASE(lbTotal);

    _lbTotalCount = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbTotal.frame)-15, CGRectGetMaxY(lbTotal.frame)+15, 90, 40)];
    [_lbTotalCount setBackgroundColor:[UIColor clearColor]];
    [_lbTotalCount setTextAlignment:NSTextAlignmentCenter];
    [_lbTotalCount setFont:[DYBShareinstaceDelegate DYBFoutStyle:40]];
    [_lbTotalCount setTextColor:ColorCheckinFontColor];
    [_viewCheckinInfo addSubview:_lbTotalCount];
    RELEASE(_lbTotalCount);
    
    UIImage *img= [UIImage imageNamed:@"btn_fold.png"];
    _btnInfoViewFold = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 2,img.size.width/2, img.size.height/2)];
    [_btnInfoViewFold setTag:-3];
    [_btnInfoViewFold setBackgroundColor:[UIColor clearColor]];
    [_btnInfoViewFold addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
    [_btnInfoViewFold setBackgroundImage:img forState:UIControlStateNormal];
    [_btnInfoViewFold setBackgroundImage:[UIImage imageNamed:@"btn_unfold.png"] forState:UIControlStateSelected];
    [_btnInfoViewFold setSelected:NO];
    [_viewCheckinInfo addSubview:_btnInfoViewFold];
    RELEASE(_btnInfoViewFold);
}

#pragma mark- 接受广播消息
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification is:[DYBCheckInMapViewController CHECKINMAINVIEWREFREASH]]){
        [self DYB_GetUserSignDatelog];
    }
}

#pragma mark- 接受其他信号
- (void)handleViewSignal_DYBCheckInMainViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBCheckInMainViewController REFREASHINFO]]){
        [self DYB_GetUserSignDatelog];
    }
}

#pragma mark- Button点击事件处理
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        if (bt){
            switch (bt.tag) {
                case -1:
                {
                    if (_btnMySelf.selected == NO) {
                        _btnMySelf.selected=YES;
                        _btnFriends.selected=NO;
                        [_btnMySelf setTitleColor:[UIColor whiteColor]];
                        [_btnFriends setTitleColor:ColorBlue];
                    }
                    
                    [self performSelector:@selector(DYB_GetUserSignMap) withObject:nil afterDelay:0.3f];
                }
                    break;
                case -2:
                {
                    if (_btnFriends.selected == NO){
                        _btnMySelf.selected=NO;
                        _btnFriends.selected=YES;
                        [_btnMySelf setTitleColor:ColorBlue];
                        [_btnFriends setTitleColor:[UIColor whiteColor]];
                    }
                    
                    [self performSelector:@selector(DYB_GetUserSignMap) withObject:nil afterDelay:0.3f];
                }
                    break;
                case -3:
                {
                    [_btnInfoViewFold setSelected:!_btnInfoViewFold.selected];
                    
                    [UIView beginAnimations: nil context: nil];
                    [UIView setAnimationBeginsFromCurrentState: YES];
                    [UIView setAnimationDuration: 0.3f];
                    if (_btnInfoViewFold.selected == YES) {
                        [_viewCheckinInfo setFrame:CGRectMake(0, self.frameHeight-self.headHeight-34, CGRectGetWidth(self.view.frame), 168)];
                    }else{
                        [_viewCheckinInfo setFrame:CGRectMake(0, self.frameHeight-self.headHeight-168, CGRectGetWidth(self.view.frame), 168)];
                    }
                    [UIView commitAnimations];
                }
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark - 返回Button处理
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        DYBUITabbarViewController *dync = [DYBUITabbarViewController sharedInstace];
        [dync scrollMainView:1];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        if ([_lbContinuousCount.text length] == 0) {
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"正在读取签到状态，请稍后再进行尝试！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
            return;
        }
        
        
        if (_bSigned == YES) {
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"您今天已经完成签到！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
        }else if (_bLocate == NO){
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"请在“定位”中开启“易班”后，重新尝试，谢谢！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
        }else{
            DYBCheckInMapViewController *vc = [[DYBCheckInMapViewController alloc] init];
            vc.arrPlaceList = [[NSMutableArray alloc] init];
            
            if ([_address length] > 0 && ![_address isEqualToString:@"(null)"])
                [vc.arrPlaceList addObject:_address];
            else if ([_address isEqualToString:@"(null)"])
                [vc.arrPlaceList addObject:@"暂时无法解析地址"];
            else
                [vc.arrPlaceList addObject:@"我在这里"];
            
            [self.drNavigationController pushViewController:vc animated:YES];
            RELEASE(vc);
        }
 
    }
    
}


-(void)DYB_GetUserSignDatelog{
    MagicRequest *request = [DYBHttpMethod user_sign_datelog:NO receive:self];
    request.tag = -1;
}


-(void)DYB_GetUserSignMap{
    NSString *strType = nil;
    
    if (_btnMySelf.selected == YES) {
        strType = [NSString stringWithFormat:@"0"];
    }
    else{
        strType = [NSString stringWithFormat:@"1"];
    }

    MagicRequest *request = [DYBHttpMethod user_sign_map:SHARED.curUser.userid type:strType isAlert:YES receive:self];
    request.tag = -2;
}


- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{
    if ([request succeed]){
        if (request.tag == -1){/*初始化*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                sign_datelog *Slog = [sign_datelog JSONReflection:respose.data];
                
                [_lbContinuousCount setText:Slog.sign_realline];
                [_lbTotalCount setText:Slog.sgin_allday];
                
                if ([Slog.result isEqualToString:@"1"]) {
                    _bSigned = YES;
                }
            }
        }else if (request.tag == -2){
             JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                sign_info *Sinfo = [sign_info JSONReflection:respose.data];
                
                DLogInfo(@"isSign ==== %@", Sinfo.is_sgin);
                
                if ([Sinfo.sgin_list count] <= 0) {
                    return;
                }
                
                DLogInfo(@"address ==== %@", ((sgin_list *)[Sinfo.sgin_list objectAtIndex:0]).address);
                
//                if ([Sinfo.sgin_list count] > 0) {
//                    [self cleanMap];
//                    
//                    NSMutableArray *arrAnn = [[NSMutableArray alloc] init];
//                    for (sgin_list *dic in Sinfo.sgin_list) {
//                        
//                        [_arrAnnInfo addObject:dic];
//                        DLogInfo(@"name:%@, time:%@", dic.user.name, dic.time);
//                        
//                        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
//                        
//                        CLLocationCoordinate2D coor;
//                        coor.latitude = [dic.lat floatValue];
//                        coor.longitude = [dic.lng floatValue];
//                        
//                        item.coordinate = coor;
//                        item.title = dic.user.fullname;
//                        
//                        [arrAnn addObject:item];
//                        [item release];
//                    }
//                    
//                    [self ShowMulitAnnotation:arrAnn];  
//                    RELEASEDICTARRAYOBJ(arrAnn);
//
//                }
            }
        }
    }else if ([request failed]){

    }
}

/*
#pragma mark -  百度地图Marker
//更新坐标
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    DLogInfo(@"更新坐标");
    [mapView setShowsUserLocation:NO];    
}

//定位失败
-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    DLogInfo(@"定位错误%@",error);
    [mapView setShowsUserLocation:NO];    
}

//定位停止
-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{    
    DLogInfo(@"定位停止");
    
    BMKCoordinateRegion region;
    region.center.latitude  = mapView.userLocation.location.coordinate.latitude;
    region.center.longitude = mapView.userLocation.location.coordinate.longitude;
    [_search reverseGeocode:mapView.userLocation.location.coordinate];

    if (region.center.latitude != 0 && region.center.latitude != 0) {
        _bLocate = YES;
    }
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error{
    DLogInfo(@"%@", result.strAddr);
    _address = [NSString stringWithFormat:@"%@",result.strAddr];
    [_address retain];
}

- (void)ShowMulitAnnotation:(NSArray *)arrAnn{
    
    for (int i = 0; i < [arrAnn count]; ++i) {
        BMKPointAnnotation* poi = [arrAnn objectAtIndex:i];
        DYBPointAnnotation* item = [[DYBPointAnnotation alloc]init];
        item.coordinate = poi.coordinate;
        item.title = poi.title;
        item.tag = i+100;
        DLogInfo(@"item tag: %d", item.tag);
        
        DYBBubbleView *subbubbleView = [[DYBBubbleView alloc] initWithFrame:CGRectMake(0, 0, 62.5, 62.5) BubbleInfo:[_arrAnnInfo objectAtIndex:i]];
        [_dicBubbleView setObject:subbubbleView forKey:[NSString stringWithFormat:@"%d", i]];
        [_arrAnnotation addObject:item];
        RELEASE(subbubbleView);
        
        if (i == 0) {
            BMKCoordinateRegion region;
            region.center.latitude  = item.coordinate.latitude;
            region.center.longitude = item.coordinate.longitude;
            [_mapView setRegion:region];
        }
        
        [item release];
    }
    
    for (DYBPointAnnotation* pitem in _arrAnnotation) {
        [_mapView addAnnotation:pitem];
    }
    
}

-(void)delaySelectAnnotation:(BMKPointAnnotation *)selann{
    [_mapView selectAnnotation:(BMKPointAnnotation *)selann animated:YES];
}


-(void)cleanMap
{
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_arrAnnotation];
    [_arrAnnotation removeAllObjects];
    [_arrAnnInfo removeAllObjects];
    
    for (BMKAnnotationView *anView in _arrAnnView) {
        if(anView){
            DYBBubbleView *bubView = [_dicBubbleView objectForKey:[NSString stringWithFormat:@"%d",anView.tag-100]];
            [bubView removeFromSuperview];
        }
        
    }
    
    [_arrAnnView removeAllObjects];
    [_dicBubbleView removeAllObjects];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[DYBPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotation.pinColor = BMKPinAnnotationColorRed;
        newAnnotation.canShowCallout = NO;
        newAnnotation.animatesDrop = NO;
        newAnnotation.draggable = NO;
        newAnnotation.tag = ((DYBPointAnnotation *)annotation).tag;
        [newAnnotation setHidden:YES];
        DLogInfo(@"%d", newAnnotation.tag);
        [_arrAnnView addObject:newAnnotation];
        
        [self performSelector:@selector(delaySelectAnnotation:) withObject:annotation afterDelay:0.2f];
        
        return newAnnotation;
    }
    return nil;
}

- (void)showBubble:(BOOL)show{
    for (BMKAnnotationView *anView in _arrAnnView) {
        if(anView){
            DYBBubbleView *bubView = [_dicBubbleView objectForKey:[NSString stringWithFormat:@"%d",anView.tag-100]];
            [bubView setHidden:YES];
        }
        
    }
}

- (void)changeBubblePosition{
    for (BMKAnnotationView *anView in _arrAnnView) {
        if(anView){
            DYBBubbleView *bubView = [_dicBubbleView objectForKey:[NSString stringWithFormat:@"%d",anView.tag-100]];
            CGRect rect = anView.frame;
            CGPoint center;
            center.x = rect.origin.x + rect.size.width/2;
            center.y = rect.origin.y;
            DLogInfo(@"view tag:%d, x:%f, y:%f", anView.tag, center.x, center.y);
            bubView.center = center;
            
//            RELEASE(_bubbleView);
            _bubbleView = bubView;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:kTransitionDuration/3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
            if (center.x < 0 || center.y < 0) {
                [bubView setHidden:YES];
            }
            else{
                [bubView setHidden:NO];
            }
            [UIView commitAnimations];
            
            _bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        }
        
    }
    
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    DLogInfo(@"选中标注");
    DYBPointAnnotation *pAnn = view.annotation;
    
    if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
        
        DYBBubbleView *bubView = [_dicBubbleView objectForKey:[NSString stringWithFormat:@"%d", pAnn.tag-100]];
        if (bubView.superview == nil) {
			//bubbleView加在BMKAnnotationView的superview(UIScrollView)上,且令zPosition为1
            [view.superview addSubview:bubView];
            [view.superview bringSubviewToFront:bubView];
        }
    }
    
    [self changeBubblePosition];
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    DLogInfo(@"取消选中标注");
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    [self showBubble:NO];
    DLogInfo(@"地图区域将要改变");
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self willchangeBubblePosition];
    
    DLogInfo(@"地图区域改变完成");
}

-(void)willchangeBubblePosition{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnAction:) object:nil];
    [self performSelector:@selector(changeBubblePosition) withObject:nil afterDelay:0.3];
}

- (void)bounce4AnimationStopped{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	_bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
	[UIView commitAnimations];
}

- (void)bounce3AnimationStopped{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce4AnimationStopped)];
	_bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
	[UIView commitAnimations];
}

- (void)bounce2AnimationStopped{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce3AnimationStopped)];
	_bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
	[UIView commitAnimations];
}

- (void)bounce1AnimationStopped{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	_bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
	[UIView commitAnimations];
}
*/


@end
