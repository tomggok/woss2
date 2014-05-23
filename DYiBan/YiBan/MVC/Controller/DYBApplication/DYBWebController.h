//
//  DYBWebViewController.h
//  DYiBan
//
//  Created by Song on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface DYBWebController : DYBBaseViewController<UIWebViewDelegate>
@property(nonatomic,retain)NSString* url;

@end
