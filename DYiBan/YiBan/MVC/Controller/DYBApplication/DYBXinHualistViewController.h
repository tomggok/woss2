//
//  DYBXinHualistViewController.h
//  DYiBan
//
//  Created by Song on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "news_list.h"
@interface DYBXinHualistViewController : DYBBaseViewController {
    
    NSMutableArray *items;
    NSString *havenext;
    MagicUITableView *_tableView;
    news_list *info;
    
    int Page;
}

@property(nonatomic, retain) NSMutableArray *items;
@property(nonatomic, retain) NSString *havenext;

- (void)initNewsList:(news_list *)news_info;
@end
