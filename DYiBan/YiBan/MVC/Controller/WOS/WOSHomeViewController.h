//
//  WOSHomeViewController.h
//  DYiBan
//
//  Created by tom zeng on 13-12-4.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "SGFocusImageItem.h"
#import "SGFocusImageFrame.h"
#import "MapViewController.h"
@interface WOSHomeViewController : DYBBaseViewController<SGFocusImageFrameDelegate,MapViewControllerDidSelectDelegate>

AS_SIGNAL(TOUCHBUTTON)
@end
