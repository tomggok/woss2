//
//  DYBMapView.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-10.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"
//#import "BMapKit.h"/*百度地图Marker*/

#define k_Signlng @"Signlng"
#define k_Signlat @"Signlat"
#define k_SignAdd @"SignAdd"

@interface DYBMapView : DYBBaseView/*<BMKMapViewDelegate, BMKSearchDelegate>*//*百度地图Marker*/{
//    BMKMapView* _mapView;/*百度地图Marker*/
//    BMKSearch* _search;/*百度地图Marker*/
    
    NSString *_lat;
    NSString *_lng;
    NSString *_address;
}

@end
