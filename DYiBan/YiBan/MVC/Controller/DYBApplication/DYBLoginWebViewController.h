//
//  DYBLoginWebViewController.h
//  DYiBan
//
//  Created by Song on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface DYBLoginWebViewController : DYBBaseViewController
AS_SIGNAL(LOGINWEBBUTTON);
AS_SIGNAL(CANCELBUTTON);
@property(retain,nonatomic)NSString* yibanURL;
@end
