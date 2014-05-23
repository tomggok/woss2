//
//  UITableView+CellH.h
//  ShangJiaoYuXin
//
//  Created by zhangchao on 13-5-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kH_tbvForHeaderViewInSection 22 //tbv某section的titleView的默认高,可通过 - (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 及 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 改变样式和高
#define kH_cellDefault 44 //默认cell的高

@interface UITableView (property)//tbv动态属性

@property (nonatomic,assign) CGFloat _cellH;//cell高
@property (nonatomic,assign) NSInteger _i_endSection/*上次被选中的section*/,_i_didSection/*本次被选中的section*/;
@property (nonatomic,assign) BOOL _b_ifOpen/*本次操作是展开还是收缩tbv*/,_b_isNeedResizeCell/*在viewDidAppear后是否需要重新计算cell的frame*/,_b_isNeedReloadFromDB/*在viewDidAppear后是否需要根据DB里的数据reload*/,_b_isAutoRefresh/*在viewDidAppear后是否自动刷新数据*/,_b_isToObtainData/*在viewDidAppear后是否重新获取数据,而不是下拉刷新数据*/;
@property (nonatomic,assign) NSIndexPath *_selectIndex_now/*当前被选中的cell的IndexPath*/,*_selectIndex_last/*上次被选中的cell的IndexPath*/,*indexAfterRequest/*网络回调后被操作的cell*/;
@property (nonatomic,retain) NSMutableArray *_muA_differHeightCellView/*装不同高度的cell的view,下标与tbv的indexPath.row对应*/,*muA_allSectionKeys/*所有section名字,用于section>1&&需要A--#排序显示时*/,*muA_allCompareWord/*保存A--#这27个字符*/,*muA_singelSectionData/*单section的数据源,和多section数据源同时只存在一种*/,*muA_singelSectionDataCopy/*单section的数据源的深拷贝,用于搜索*/;
@property (nonatomic,assign) int _page/*需要加载第几页数据源*/,i_pageNums/*每页请求多少数据*/;
@property (nonatomic,retain) NSMutableDictionary *muD_allSectionValues/*所有section里边的值(每个section里有几个数据对象),每个key是section名字,用于section>1&&需要A--#排序显示时*/,*muD_allSectionValueCopy/*搜索前把[muD_allSectionValues mutableDeepCopy],搜素完成后重置tbv的数据源*/;


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert/*本次是否插入cell*/ nextDo:(BOOL)nextDoInsert/*下次是否插入cell*/ dataSourceCount:(NSInteger)dataSourceCount/*总section数量*/ firstDoInsertCellNums:(NSInteger)firstDoInsertCellNums/*第一次要插入或删除的cell*/ nextDoInsertCellNums:(NSInteger)nextDoInsertCellNums/*第2次要插入或删除的cell*/;

- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation NS_AVAILABLE_IOS(3_0);
-(void)release_muA_differHeightCellView;
-(void)releaseDataResource;
- (void)resetSectionData ;
-(BOOL)isOneSection;
@end
