//
//  DYBSNSSyncViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-10.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface DYBSNSSyncViewController : DYBBaseViewController{
    NSString *_strURL;
    NSInteger _snsType;
}

- (id)init:(NSInteger)snsType; // 1 QQ 2 人人

@end
