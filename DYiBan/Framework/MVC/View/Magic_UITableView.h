//
//  Magic_UITableView.h
//  MagicFramework
//
//  Created by NewM on 13-3-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Magic_ViewSignal.h"
#import "UIView+MagicViewSignal.h"
#import "UIViewController+MagicViewSignal.h"

#define PULLSTATENORMAL         0     //  状态标识：下拉可以刷新/上拖加载更多
#define PULLSTATEDOWN           1     //  状态标识：释放可以刷新
#define PULLSTATELOAD           2     //  状态标识：正在加载
#define PULLSTATEUP             3     //  状态标识：释放加载更多
#define PULLSTATEEND            4     //  状态标识：已加载全部数据

#define RETURNDONOTHING         0     //  返回值：不执行
#define RETURNREFRESH           1     //  返回值：下拉刷新
#define RETURNLOADMORE          2     //  返回值：加载更多

#define VIEWTYPEHEADER          0     //  视图标识：下拉刷新视图
#define VIEWTYPEFOOTER          1     //  视图标识：上拖加载视图

#define STATEVIEWHEIGHT         40    //  视图窗体：视图高度
#define STATEVIEWINDICATEWIDTH  60    //  视图窗体：视图箭头指示器宽度


@interface StateView : UIView {
@private
    UIActivityIndicatorView * indicatorView;  //  加载指示器（菊花圈）
    UIImageView             * arrowView;      //  箭头视图
    UILabel                 * stateLabel;     //  状态文本
    UILabel                 * timeLabel;      //  时间文本
    int                       viewType;       //  标识是下拉还是上拖视图
    int                       currentState;   //  标识视图当前状态
}

@property (nonatomic, retain) UIActivityIndicatorView * indicatorView;
@property (nonatomic, retain) UIImageView             * arrowView;
@property (nonatomic, retain) UILabel                 * stateLabel;
@property (nonatomic, retain) UILabel                 * timeLabel;
@property (nonatomic)         int                       viewType;
@property (nonatomic)         int                       currentState;

/**
 *  初始化视图
 *  type : 下拉/上拖视图标识  VIEWTYPEHEADER 或 VIEWTYPEFOOTER
 **/
- (id)initWithFrame:(CGRect)frame viewType:(int)type;

/**
 *  改变视图状态
 *  state : 视图状态 PULLSTATEXXX
 **/
- (void)changeState:(int)state;

/**
 *  更新时间文本（当前时间）
 **/
- (void)updateTimeLabel;

@end

typedef enum {
    DTableViewNomal =0,
    DTableViewSlime =1
}MagicUITableViewType;

typedef enum
{
    MagicReHeightNomal = 0,
    MagicReHeightMiddle = 1
    
}MagicSlimeRefreshHeightType;


@class MagicUITableViewAgent;
@class MagicUIUpdateView;

@interface MagicUITableView : UITableView<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    StateView *headerView;
    StateView *footerView;
    
//    MagicUITableViewAgent *_agent;

}
AS_SIGNAL(TABELVIEWBEGAINSCROLL) //开始滑动
AS_SIGNAL(TABLENUMROWINSEC)//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
AS_SIGNAL(TABLECELLFORROW)//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
AS_SIGNAL(TABLEDIDSELECT)//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
AS_SIGNAL(TABLENUMOFSEC)//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
AS_SIGNAL(TABLEHEIGHTFORROW)//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
AS_SIGNAL(TABLESCROLLVIEWDIDSCROLL)//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
AS_SIGNAL(TABLESCROLLVIEWDIDENDDRAGGING)//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
AS_SIGNAL(TABLEVIEWFORHEADERINSECTION)//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
AS_SIGNAL(TABLETITLEFORHEADERINSECTION)//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
AS_SIGNAL(TABLETHEIGHTFORHEADERINSECTION)//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
AS_SIGNAL(TABLESECTIONINDEXTITLESFORTABLEVIEW)  //- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;return list of section titles to display in section index view (e.g. "ABCD...Z#")  右侧索引列表
AS_SIGNAL(TABLESECTIONFORSECTIONINDEXTITLE)//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index

AS_SIGNAL(TABLEVIEWUPDATA)//DTableViewSlime 刷新数据
AS_SIGNAL(TAbLEVIEWLODATA)//DTableViewSlime 读取新的数据

AS_SIGNAL(TAbLEVIEWSCROLLUP)//table向上滑动
AS_SIGNAL(TAbLEVIEWSCROLLDOWN)//table向下滑动
AS_SIGNAL(TAbLEVIERELOADOVER)//reload完毕
AS_SIGNAL(TAbLEVIERETOUCH)//touch事件



@property (nonatomic, assign)StateView *headerView;
@property (nonatomic, assign)StateView *footerView;
@property (nonatomic, assign)MagicUITableViewType tableViewType;
@property (nonatomic, assign)BOOL b_isreloadOver;/*调用reload方法后是否reload完毕数据源*/
@property (nonatomic, assign)BOOL b_Dragging;//是否正在被拖拽

//默认没有上拉下拉
- (id)initWithFrame:(CGRect)frame;
//是否需要实现上拉和下拉
- (id)initWithFrame:(CGRect)frame isNeedUpdate:(BOOL)isNeedUpdate;

//设置slime刷新下拉高度响应刷新的type
- (void)setSlimeViewRefreshHeight:(MagicSlimeRefreshHeightType)refreshType;

/**
 *  当表视图拖动时的执行方法
 *  使用方法：设置表视图的delegate，实现- (void)scrollViewDidScroll:(UIScrollView *)scrollView方法，在垓方法中直接调用本方法
 **/
- (void)tableViewDidDragging;

/**
 *  当表视图结束拖动时的执行方法
 *  使用方法：设置表视图的delegate，实现- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate方法，在垓方法中直接调用本方法
 **/
- (int)tableViewDidEndDragging;

/**
 *  刷新表视图数据
 *  dataIsAllLoaded 标识数据是否已全部加载（即“上拖加载更多”是否可用）
 **/
- (void)reloadData:(BOOL)dataIsAllLoaded;

//更改tableview的加载状态
- (void)changeSmlimeUpdateState:(NSInteger)updateState;

- (void)launchRefreshing;


@end
