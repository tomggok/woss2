//
//  DYBXinHuaViewController.h
//  DYiBan
//
//  Created by Song on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface DYBXinHuaViewController : DYBBaseViewController {
    
    NSMutableArray *items;
    NSMutableArray *items_temp;
    
    NSMutableDictionary *arrayDict;
    NSMutableArray *arrayIndexKey;
    MagicUITableView *_tableView;
    
    int Page;
}

@property(nonatomic, retain) NSMutableArray *items;
@property(nonatomic, retain) NSMutableDictionary *arrayDict;
@property(nonatomic, retain) NSMutableArray *arrayIndexKey;

-(void)preesTitleButton:(id)sender;


@end
