//
//  UIViewController+MagicCategory.h
//  DYiBan
//
//  Created by zhangchao on 13-10-17.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MagicCategory)

AS_SIGNAL(AutoRefreshTbvInViewWillAppear)

@property (nonatomic,retain) UITableView * tbv;//公用tbv
@property (nonatomic,assign) BOOL b_isAutoRefreshTbvInViewWillAppear;//在 viewWillAppear时是否自动刷新tbv数据源

@end
