//
//  WOSCalculateOrder.h
//  DYiBan
//
//  Created by tom zeng on 13-12-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"

@interface WOSCalculateOrder : DYBBaseView

AS_SIGNAL(DOADD)
AS_SIGNAL(DOREDUCE)
@property(nonatomic,retain)UILabel *lableMid;
@property(nonatomic,retain)NSString *name;
@end
