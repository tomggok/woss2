//
//  DYBCheckInMainViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-3.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

//#import "BMapKit.h"/*百度地图Marker*/
#import "DYBBubbleView.h"

@interface DYBCheckInMainViewController : DYBBaseViewController/*<BMKMapViewDelegate, BMKSearchDelegate>*//*百度地图Marker*/{
    MagicUIButton *_btnMySelf;
    MagicUIButton *_btnFriends;
    MagicUIButton *_btnInfoViewFold;
    
    MagicUILabel *_lbContinuousCount;
    MagicUILabel *_lbTotalCount;
    
    DYBBaseView *_viewCheckinInfo;
    
//    BMKMapView *_mapView;/*百度地图Marker*/
//    BMKSearch *_search;/*百度地图Marker*/
    DYBBubbleView *_bubbleView;

    NSMutableArray *_arrAnnotation;
    NSMutableArray *_arrAnnInfo;
    NSMutableArray *_arrAnnView;

    NSMutableDictionary *_dicBubbleView;
    BOOL _bLocate;
    BOOL _bSigned;
}

@property(nonatomic, retain) NSString *address;

AS_SIGNAL(REFREASHINFO)

@end
