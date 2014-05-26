//
//  AppDelegate.h
//  DYiBan
//
//  Created by NewM on 13-7-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//
#define appDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

#import <UIKit/UIKit.h>

//#import "BMapKit.h" /*百度地图Marker*/

@interface AppDelegate : UIResponder <UIApplicationDelegate/*, BMKGeneralDelegate*/,UIScrollViewDelegate>{
//    BMKMapManager* _mapManager;/*百度地图Marker*/
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain)MagicNavigationController *navi;
@property (nonatomic, retain)UIButton *btnOrder;
@property (nonatomic, retain) NSMutableArray *arrayOrderList;

@end
