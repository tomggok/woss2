//
//  DYBHelp-protocolViewController.h
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface DYBHelp_protocolViewController : DYBBaseViewController<UIWebViewDelegate>
@property(assign,nonatomic)int tag;
@property(retain,nonatomic)NSString *tle;
@end
