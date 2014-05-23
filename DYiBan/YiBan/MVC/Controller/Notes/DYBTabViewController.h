//
//  DYBTabViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-10-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "tag_list.h"

//标签页
@interface DYBTabViewController : DYBBaseViewController{
    MagicUITableView *_tabTagList;
    MagicUISearchBar *_Tagsearch;
    tag_list *_Tlist;
    
    int nPage;
    int nPageSize;
    
    NSMutableArray *_arrayTagList;
    NSMutableArray *_arrayTagListCell;
    UIView *_viewWarning;
}

AS_SIGNAL(REFLIST)

@end
