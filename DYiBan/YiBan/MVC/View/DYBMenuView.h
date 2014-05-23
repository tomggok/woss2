//
//  DYBMenuView.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-29.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"

@interface DYBMenuView : DYBBaseView{
    MagicUITableView *_tableMenu;
    
    NSArray *_arrMenu;
    NSArray *_arrSignal;
    int _row/*上次选择的index*/;
    
    NSInteger nSelRow;
    BOOL bDown;
}

@property (nonatomic,assign) BOOL bPullDown;//是否展开
@property (nonatomic,assign) int row;/*上次选择的index*/
@property (nonatomic,retain) NSArray *arrMenu;//外部可能改变数据源
@property (nonatomic,retain) id sendTargetObj;

- (id)initWithData:(NSArray *)arrMenu selectRow:(NSInteger)nRow;
-(void)changeArrowStatus:(BOOL)key;
AS_SIGNAL(MENUDOWN)
AS_SIGNAL(MENUSHRINK)
AS_SIGNAL(MENUSELECTCELL)
@end
