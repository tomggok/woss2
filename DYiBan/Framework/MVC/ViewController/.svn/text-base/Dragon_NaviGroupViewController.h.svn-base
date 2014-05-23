//
//  Dragon_NaviGroupViewController.h
//  DragonFramework
//
//  Created by NewM on 13-3-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_ViewController.h"

@class DragonNavigationController;

@interface DragonNaviGroupViewController : DragonViewController
{
    NSInteger       _int_index;
    NSMutableArray* _arr_stacks;
}
AS_SIGNAL(INDEX_CHANGEN);//显示顺序变了

@property (nonatomic, retain)NSMutableArray *arr_statcks;
@property (nonatomic, readonly)NSInteger    int_topIndex;
@property (nonatomic, readonly)DragonNavigationController *topStack;

+ (DragonNaviGroupViewController *)naviStatckGroup;
+ (DragonNaviGroupViewController *)naviStatckGroupWithFirstStack:(DragonNavigationController *)navigation;

- (void)present:(DragonNavigationController *)nav;
- (void)append:(DragonNavigationController *)nav;
- (void)remove:(DragonNavigationController *)nav;

@end
