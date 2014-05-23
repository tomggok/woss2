//
//  DYBMapLocationViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBMapLocationViewController.h"

@interface DYBMapLocationViewController ()

@end

@implementation DYBMapLocationViewController
@synthesize bAutoLocation = _bAutoLocation;

-(void)dealloc{
    [super dealloc];
    
    RELEASE(_lat);
    RELEASE(_lng);
    
//    [_mapView removeOverlays:_mapView.overlays];/*百度地图Marker*/
    
//    _mapView.delegate = nil;/*百度地图Marker*/
//    RELEASEOBJ(_mapView);/*百度地图Marker*/
    
//    _search.delegate = nil;/*百度地图Marker*/
//    RELEASEOBJ(_search);/*百度地图Marker*/
}

- (id)initMapLocation:(BOOL)bLocal{
    self = [super init];
    if (self) {
        // Initialization code
        _bAutoLocation = bLocal;
        [self InitBMKParameter:_bAutoLocation];
    }
    return self;
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]]){
        [self.headview setTitle:@"位置信息"];
        [self backImgType:0];
        if (_bAutoLocation == YES) {
            [self backImgType:3];
        }
    }else if ([signal is:[MagicViewController CREATE_VIEWS]]){

    }
}

#pragma mark - 返回Button处理
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        if ([_address isEqualToString:@"(null)"]){
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"无法获得当前位置！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
            return;
        }else if ([_address length] == 0) {
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"正在定位，请稍等。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
            return;
        }
        
        NSDictionary *_dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:_address, @"address", _lat, @"lat", _lng, @"lng", nil];
        [self sendViewSignal:nil withObject:[_dicInfo retain]];
        RELEASE(_dicInfo);
        
        
        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];

    }else if ([signal is:[DYBBaseViewController BACKBUTTON]]){
        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }
    
}

#pragma mark- 百度地图Marker
-(void)InitBMKParameter:(BOOL)bAutoLoc{
//    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.frameHeight-self.headHeight)];
//    _mapView.delegate = self;
//    if (bAutoLoc)
//        _mapView.showsUserLocation = YES;
//    else
//        _mapView.showsUserLocation = NO;
//    
//    _mapView.zoomLevel = 18;
//    [self.view addSubview:_mapView];
//    
//    _search = [[BMKSearch alloc]init];
//    _search.delegate = self;
}
/*
- (void)ShowMulitAnnotation:(NSString *)pointlat lng:(NSString *)pointlng address:(NSString *)pointaddress{
    
    BMKPointAnnotation* AnnPoint = [[BMKPointAnnotation alloc]init];
    
    CLLocationCoordinate2D coor;
    coor.latitude = [pointlat floatValue];
    coor.longitude = [pointlng floatValue];
    
    AnnPoint.coordinate = coor;
    AnnPoint.title = pointaddress;
    
    BMKCoordinateRegion region;
    region.center.latitude  = AnnPoint.coordinate.latitude;
    region.center.longitude = AnnPoint.coordinate.longitude;
    [_mapView setRegion:region];
    
    [_mapView addAnnotation:AnnPoint];
    [_mapView selectAnnotation:AnnPoint animated:YES];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];

        if (mapView.tag == 100)
            newAnnotation.pinColor = BMKPinAnnotationColorRed;
        else if (mapView.tag == 101)
            newAnnotation.pinColor = BMKPinAnnotationColorGreen;
        
        newAnnotation.animatesDrop = NO;
        newAnnotation.draggable = NO;
        newAnnotation.canShowCallout = YES;
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
        
    }
    
    
}

//定位失败
-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    DLogInfo(@"定位错误%@",error);
    
    [mapView setShowsUserLocation:NO];
    
}

//定位停止
-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    
    DLogInfo(@"定位停止");
    if (_bAutoLocation) {
        BMKCoordinateRegion region;
        region.center.latitude  = mapView.userLocation.location.coordinate.latitude;
        region.center.longitude = mapView.userLocation.location.coordinate.longitude;
        
        DLogInfo(@"%f, %f",region.center.latitude , region.center.longitude);
        
        _lat = [NSString stringWithFormat:@"%f", region.center.latitude];
        _lng = [NSString stringWithFormat:@"%f", region.center.longitude];
        
        
        [_mapView setRegion:region];
        [_search reverseGeocode:mapView.userLocation.location.coordinate];
        
        _annotation = [[BMKPointAnnotation alloc]init];
        [_mapView setTag:100];
        [_mapView addAnnotation:_annotation];
    }
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error{
    DLogInfo(@"%@", result.strAddr);
    
    _address = [NSString stringWithFormat:@"%@",result.strAddr];
    _annotation.title = _address;
    [_mapView selectAnnotation:_annotation animated:YES];
    
//    if([[[UIDevice currentDevice] systemVersion] floatValue] <= 5.1 && self.superview !=nil)
//        [self release];
}

-(void)selectAnnontation{
    [_mapView selectAnnotation:_annotation animated:NO];
}

- (void)sendSelfLocation{
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    
    CLLocationCoordinate2D coor;
    coor.latitude = [_lat floatValue];
    coor.longitude = [_lng floatValue];
    
    item.coordinate = coor;
    [item release];
}

-(void)setlocate{
    BMKCoordinateRegion region;
    region.center.latitude  = [_lat floatValue];
    region.center.longitude = [_lng floatValue];
    
    [_mapView setRegion:region animated:NO];
}
*/

@end
