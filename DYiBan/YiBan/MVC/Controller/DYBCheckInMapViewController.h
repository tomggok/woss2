//
//  DYBCheckInMapViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-4.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
//#import "BMapKit.h"/*百度地图Marker*/

@interface DYBCheckInMapViewController : DYBBaseViewController/*<BMKMapViewDelegate, BMKSearchDelegate>*//*百度地图Marker*/{
//    BMKMapView* _mapView;/*百度地图Marker*/
//    BMKSearch* _search;/*百度地图Marker*/
//    BMKPointAnnotation *_annotation;/*百度地图Marker*/
    
    MagicUITableView *_tabMapAddress;
    MagicUIImageView *_viewPrivateBKG;
    MagicUIImageView *_ICONPrivate;
    
    MagicUIButton *_btnPrivate;
    MagicUIButton *_btnPrivateSelected;
    MagicUIButton *_btnSelPrivate;
    MagicUIButton *_btnSelUnPrivate;
    MagicUIButton *_btnSelFriends;
    
    NSMutableArray *_arrAnnotation;
    NSString *_address;
    
    NSInteger nSelRow;
}

@property(nonatomic, retain) NSString *lng;
@property(nonatomic, retain) NSString *lat;
@property(nonatomic, retain) NSMutableArray *arrPlaceList;

AS_SIGNAL(SELFLOCATION)
AS_SIGNAL(LOCATIONPRIVATE)
AS_SIGNAL(LOCATIONPRIVATEFOLD)
AS_SIGNAL(BTNPRIVATE)
AS_SIGNAL(BTNPRIVATESELECTED)

AS_NOTIFICATION(CHECKINMAINVIEWREFREASH)
@end
