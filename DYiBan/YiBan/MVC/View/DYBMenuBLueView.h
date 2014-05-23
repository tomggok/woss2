//
//  DYBMenuBLueView.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"

@interface DYBMenuBLueView : DYBBaseView{
    MagicUITableView *_tableMenu;
    NSArray *_arrMenu;
    NSInteger _nSelRow;
    NSInteger _nCellType;
}

//cellType 0:lable 有选中状态 1:button 无选中状态
- (id)initWithFrame:(CGRect)frame menuArray:(NSArray *)arrMenu selectRow:(NSInteger)nSelRow cellType:(NSInteger)nCellType;

AS_SIGNAL(SELCELL)
@end
