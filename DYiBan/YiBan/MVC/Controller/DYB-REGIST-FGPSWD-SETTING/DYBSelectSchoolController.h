//
//  DYBSelectSchoolController.h
//  DYiBan
//
//  Created by Song on 13-9-3.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "scrollerData.h"
@interface DYBSelectSchoolController : DYBBaseViewController {
    
//    MagicUITableView *_tbv;
    MagicUISearchBar *_search;
    
    int oldIndex;
    int newIndex;
    
    scrollerData *medelData;
}
@property(retain,nonatomic)id father;
@end
