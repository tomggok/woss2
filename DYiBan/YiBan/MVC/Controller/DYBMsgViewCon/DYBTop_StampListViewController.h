//
//  DYBTop_StampListViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-9-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

//顶踩列表
@interface DYBTop_StampListViewController : DYBBaseViewController

@property (nonatomic,assign) int type;//0 顶我的人  1:踩我的人
@property (nonatomic,copy) NSString *str_userid;//

@end
