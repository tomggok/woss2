//
//  DYBWebViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-27.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface DYBWebViewController : DYBBaseViewController{
    NSString *_strURL;
}

- (id)init:(NSString *)webURL;

@end
