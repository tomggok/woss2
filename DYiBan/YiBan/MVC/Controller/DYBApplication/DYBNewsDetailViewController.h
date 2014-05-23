//
//  DYBNewsDetailViewController.h
//  DYiBan
//
//  Created by Song on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "news.h"
@interface DYBNewsDetailViewController : DYBBaseViewController {
    
    news *items;
    news *info;
    MagicUITableView *_tableView;
    int Page;
}

@property(nonatomic, retain) news *items;

- (void)initNewsDetail:(news *)news_info;

@end
