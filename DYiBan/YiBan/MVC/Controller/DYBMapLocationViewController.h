//
//  DYBMapLocationViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

//#import "BMapKit.h"/*百度地图Marker*/

@interface DYBMapLocationViewController : DYBBaseViewController/*<BMKMapViewDelegate, BMKSearchDelegate>*//*百度地图Marker*/{
//    BMKMapView *_mapView;/*百度地图Marker*/
//    BMKSearch *_search;/*百度地图Marker*/
//    BMKPointAnnotation *_annotation;/*百度地图Marker*/
    
    NSString *_lng;
    NSString *_lat;
    NSString *_address;
}

@property(nonatomic, assign)BOOL bAutoLocation;

- (id)initMapLocation:(BOOL)bLocal;
- (void)ShowMulitAnnotation:(NSString *)pointlat lng:(NSString *)pointlng address:(NSString *)pointaddress;
@end
