//
//  DYBSNS_Controller_webViewController.h
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface DYBSNS_Controller_webViewController : DYBBaseViewController<UIWebViewDelegate>
@property(assign,nonatomic)int tag;
@property(nonatomic,retain)id father;
@end
