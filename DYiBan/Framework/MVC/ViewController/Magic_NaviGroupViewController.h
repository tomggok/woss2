//
//  Magic_NaviGroupViewController.h
//  MagicFramework
//
//  Created by NewM on 13-3-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_ViewController.h"

@class MagicNavigationController;

@interface MagicNaviGroupViewController : MagicViewController
{
    NSInteger       _int_index;
    NSMutableArray* _arr_stacks;
}
AS_SIGNAL(INDEX_CHANGEN);//显示顺序变了

@property (nonatomic, retain)NSMutableArray *arr_statcks;
@property (nonatomic, readonly)NSInteger    int_topIndex;
@property (nonatomic, readonly)MagicNavigationController *topStack;

+ (MagicNaviGroupViewController *)naviStatckGroup;
+ (MagicNaviGroupViewController *)naviStatckGroupWithFirstStack:(MagicNavigationController *)navigation;

- (void)present:(MagicNavigationController *)nav;
- (void)append:(MagicNavigationController *)nav;
- (void)remove:(MagicNavigationController *)nav;

@end
