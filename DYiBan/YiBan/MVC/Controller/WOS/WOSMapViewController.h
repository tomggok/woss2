//
//  WOSMapViewController.h
//  DYiBan
//
//  Created by tom zeng on 13-12-25.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "MapViewController.h"
@interface WOSMapViewController : DYBBaseViewController<MapViewControllerDidSelectDelegate>{
    
    int iType;
}
@property (nonatomic,assign) int iType; //地图类型；
@property (nonatomic,retain) NSDictionary *dictMap;
@end
