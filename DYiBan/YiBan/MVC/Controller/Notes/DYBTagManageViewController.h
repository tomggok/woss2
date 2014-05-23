//
//  DYBTagManageViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "tag_list.h"

@interface DYBTagManageViewController : DYBBaseViewController{
    MagicUITableView *_tabTagManage;
    MagicUISearchBar *_Tagsearch;
    tag_list *_Tlist;
    
    int nPage;
    int nPageSize;
    
    NSMutableArray *_arrayTagManage;
    NSMutableArray *_arrayTagManageCell;
    NSString *_strTagID;
    NSString *_strNewTag;
    UIView *_viewWarning;
}

-(id)initwithTagList:(tag_list *)tag_list page:(int)page;

AS_SIGNAL(DELTAG)
@end
