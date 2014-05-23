//
//  DYBListSelViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-11-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "tag_list.h"

@interface DYBListSelViewController : DYBBaseViewController{
    MagicUITableView *_tabTagManage;
    MagicUILabel *_lbTagCount;
    tag_list *_Tlist;
    UIScrollView *_viewSelBKG;
    
    int nPage;
    int nPageSize;
    
    NSMutableArray *_arrayTagManage;
    NSMutableArray *_arrayTagManageCell;
    NSMutableArray *_arrayTagSelected;
    NSString *_strTagID;
    NSString *_strNewTag;
    UIView *_lineView;
    UIView *_bottomAddTag;
}

AS_SIGNAL(DELTAG)

- (id)initwithTagList:(NSArray *)arrtagList;

@end
