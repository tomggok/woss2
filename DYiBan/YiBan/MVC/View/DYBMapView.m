//
//  DYBMapView.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-10.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBMapView.h"

@implementation DYBMapView

- (void)dealloc{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self InitBMKParameter];
    }
    return self;
}

#pragma mark- 百度地图Marker
-(void)InitBMKParameter{
//    _mapView = [[BMKMapView alloc]init];
//    _mapView.delegate = self;
//    _mapView.showsUserLocation = YES;
//    
//    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"LocationPrivacy"] isEqualToString:@"1"]){
//        _search = [[BMKSearch alloc]init];
//        _search.delegate = self;
//    }
}
/*
//更新坐标
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    
    DLogInfo(@"更新坐标");
    [mapView setShowsUserLocation:NO];
}

//定位失败
-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    DLogInfo(@"定位错误%@",error);
    [mapView setShowsUserLocation:NO];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_Signlng];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_Signlat];
    
    [self releaseBaiDuMap];
}

//定位停止
-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    
    DLogInfo(@"定位停止");

    BMKCoordinateRegion region;
    region.center.latitude  = mapView.userLocation.location.coordinate.latitude;
    region.center.longitude = mapView.userLocation.location.coordinate.longitude;
    
    DLogInfo(@"%f, %f",region.center.latitude , region.center.longitude);
    
    _lat = [NSString stringWithFormat:@"%f", region.center.latitude];
    _lng = [NSString stringWithFormat:@"%f", region.center.longitude];
    
    NSString *strlng = [[NSUserDefaults standardUserDefaults] stringForKey:@"Signlng"];
    NSString *strlat = [[NSUserDefaults standardUserDefaults] stringForKey:@"Signlat"];
    
    if ([strlng length] == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0.000000" forKey:@"Signlng"];
    }
    
    if ([strlat length] == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0.000000" forKey:@"Signlat"];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:_lng forKey:@"Signlng"];
    [[NSUserDefaults standardUserDefaults] setValue:_lat forKey:@"Signlat"];
    
    [self DYB_signPosition];
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"LocationPrivacy"] isEqualToString:@"1"]){
        if (![_search reverseGeocode:mapView.userLocation.location.coordinate]) {
            [self release];
        }
    }
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error{
    DLogInfo(@"%@", result.strAddr);

    NSString *strAdd = [[NSUserDefaults standardUserDefaults] stringForKey:@"SignAdd"];

    if ([strAdd length] == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:@"无法定位" forKey:@"SignAdd"];
    }
    
    _address = result.strAddr;
    [[NSUserDefaults standardUserDefaults] setValue:_address forKey:@"SignAdd"];
    
    [self DYB_signPosition];
}

- (void)DYB_signPosition{
    MagicRequest *request = [DYBHttpMethod user_sign_position:_lng lat:_lat address:nil isAlert:NO receive:self];
    request.tag = -1;
}
*/
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{
    if ([request succeed]){
        if (request.tag == -1){/*发送动态*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                [self releaseBaiDuMap];
            }
        }
    }else if ([request failed]){
        [self releaseBaiDuMap];
    }
}

- (void)releaseBaiDuMap{
    RELEASE(_lat);
    RELEASE(_lng);
    RELEASE(_address);
    
//    _mapView.delegate = nil;/*百度地图Marker*/
//    RELEASEOBJ(_mapView);/*百度地图Marker*/
    
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"LocationPrivacy"] isEqualToString:@"1"]){
//        _search.delegate = nil;/*百度地图Marker*/
//        RELEASEOBJ(_search);/*百度地图Marker*/
    }
}

@end
