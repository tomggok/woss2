//
//  DYBVariableTbvView.h
//  DYiBan
//
//  Created by zhangchao on 13-10-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"

//封装可变tbv
@interface DYBVariableTbvView : DYBBaseView
{
}

@property (nonatomic,retain) Class cellClass;
@property (nonatomic,retain) MagicUITableView *tbv;
@property (nonatomic,retain) UIView *v_headerVForHide;//上滑时此view上边需要被上移的view

AS_SIGNAL(createSectionHeaderView);//创建 定制的 SectionHeaderView 消息
AS_SIGNAL(createCell);//创建 cell 消息


#pragma mark- 释放数据源
-(void)releaseDataSource;
#pragma mark- 释放cell
-(void)releaseCell;
-(void)addDataSource:(NSMutableArray *)muA key:(NSString *)key/*将不同数据源归到一组的key*/;
-(void)addDataSource:(id )ob;
-(int)dataSourceCount;
-(void)reloadData:(BOOL)b;
- (id)initWithFrame:(CGRect)frame cellClass:(Class)cellClass/**/;
-(void)creatTbv;
-(NSMutableArray *)DataSourceArray;
-(NSMutableArray *)CellArray;

@end
