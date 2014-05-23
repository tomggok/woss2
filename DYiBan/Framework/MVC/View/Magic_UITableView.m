//
//  Magic_UITableView.m
//  MagicFramework
//
//  Created by NewM on 13-3-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_UITableView.h"
#import <QuartzCore/QuartzCore.h>
#import "UITableView+property.h"

@implementation StateView

@synthesize indicatorView;
@synthesize arrowView;
@synthesize stateLabel;
@synthesize timeLabel;
@synthesize viewType;
@synthesize currentState;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000

#undef UITextAlignmentCenter
#define UITextAlignmentCenter NSTextAlignmentCenter

#else

#undef UITextAlignmentCenter
#define UITextAlignmentCenter UITextAlignmentCenter


#endif

- (id)initWithFrame:(CGRect)frame viewType:(int)type{
    CGFloat width = frame.size.width;
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width, STATEVIEWHEIGHT)];
    
    if (self) {
        //设置当前视图类型
        viewType = type == VIEWTYPEHEADER ? VIEWTYPEHEADER : VIEWTYPEFOOTER;
        self.backgroundColor = [UIColor clearColor];
        
        //初始化加载指示器（菊花圈）
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((STATEVIEWINDICATEWIDTH - 20) / 2+60, (STATEVIEWHEIGHT - 20) / 2, 20, 20)];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        indicatorView.hidesWhenStopped = YES;
        [self addSubview:indicatorView];
        
        //初始化箭头视图
        arrowView = [[UIImageView alloc] initWithFrame:CGRectMake((STATEVIEWINDICATEWIDTH - 32) / 2, (STATEVIEWHEIGHT - 32) / 2, 32, 32)];
        NSString * imageNamed = type == VIEWTYPEHEADER ? @"loading_arrow" : @"loading_arrow";
        arrowView.image = [UIImage imageNamed:imageNamed];
        arrowView.frame = CGRectMake((STATEVIEWINDICATEWIDTH - 32) / 2+70, (STATEVIEWHEIGHT - 32) / 2+5, 10, 20);
        [self addSubview:arrowView];
        
        //初始化状态提示文本
        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
        stateLabel.font = [UIFont systemFontOfSize:12.0f];
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.textAlignment = UITextAlignmentCenter;
        stateLabel.text = type == VIEWTYPEHEADER ? @"下拉可以刷新" : @"上拖加载更多";
        [self addSubview:stateLabel];
        
        //初始化更新时间提示文本
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, width, STATEVIEWHEIGHT - 20)];
        timeLabel.font = [UIFont systemFontOfSize:12.0f];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = UITextAlignmentCenter;
        timeLabel.text = @"-";
        [self addSubview:timeLabel];
        
    }
    return self;
}


- (void)changeState:(int)state{
    [indicatorView stopAnimating];
    arrowView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    switch (state) {
        case PULLSTATENORMAL:
            
            currentState = PULLSTATENORMAL;
            stateLabel.text = viewType == VIEWTYPEHEADER ? @"下拉可以刷新" : @"上拖加载更多";
            //  旋转箭头
            arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            ((UIScrollView *)self.superview).contentInset=UIEdgeInsetsZero;

            break;
        case PULLSTATEDOWN:
            currentState = PULLSTATEDOWN;
            stateLabel.text = @"释放刷新数据";
            arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            break;
            
        case PULLSTATEUP:
            currentState = PULLSTATEUP;
            stateLabel.text = @"释放加载数据";
            arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            break;
            
        case PULLSTATELOAD:
            currentState = PULLSTATELOAD;
            stateLabel.text = viewType == VIEWTYPEHEADER ? @"正在刷新.." : @"正在加载..";
            [indicatorView startAnimating];
            arrowView.hidden = YES;
            break;
            
        case PULLSTATEEND:
            currentState = PULLSTATEEND;
            stateLabel.text = viewType == VIEWTYPEHEADER ? stateLabel.text : @"已加载全部数据";
            arrowView.hidden = YES;
            break;
            
        default:
            currentState = PULLSTATENORMAL;
            stateLabel.text = viewType == VIEWTYPEHEADER ? @"下拉可以刷新" : @"上拖加载更多";
            arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            ((UIScrollView *)self.superview).contentInset=UIEdgeInsetsZero;
            break;
    }
    [UIView commitAnimations];
}

- (void)updateTimeLabel{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    timeLabel.text = [NSString stringWithFormat:@"更新于 %@", [formatter stringFromDate:date]];
    [formatter release];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [indicatorView release];
    [arrowView release];
    [stateLabel release];
    [timeLabel release];
    
    [super dealloc];
}

@end
/*
@interface MagicUITableViewAgent : NSObject<UITableViewDataSource, UITableViewDelegate>
{
    MagicUITableView *_target;
}
@property (nonatomic, assign)MagicUITableView *target;

@end
@implementation MagicUITableViewAgent
@synthesize target = _target;

@end*/

@interface MagicUITableView ()<MagicUIUpdateViewDelegate>
{
//    SRRefreshView *_slimeView;
    MagicUIUpdateView *_slimeView;
}

@end


@implementation MagicUITableView
DEF_SIGNAL(TABLENUMROWINSEC)
DEF_SIGNAL(TABLECELLFORROW)
DEF_SIGNAL(TABLEDIDSELECT)
DEF_SIGNAL(TABLENUMOFSEC)
DEF_SIGNAL(TABLESCROLLVIEWDIDSCROLL)
DEF_SIGNAL(TABLESCROLLVIEWDIDENDDRAGGING)
DEF_SIGNAL(TABLEHEIGHTFORROW)
DEF_SIGNAL(TABLEVIEWFORHEADERINSECTION)
DEF_SIGNAL(TABLETITLEFORHEADERINSECTION)
DEF_SIGNAL(TABLETHEIGHTFORHEADERINSECTION)
DEF_SIGNAL(TABLESECTIONINDEXTITLESFORTABLEVIEW)  //- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView; return list of section titles to display in section index view (e.g. "ABCD...Z#")  右侧索引列表
DEF_SIGNAL(TABLESECTIONFORSECTIONINDEXTITLE)    //- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index   点击右测是索引列表上的某个字母时回调,参数index和title是 右侧索引列表上被点击的字母在 索引列表的下标和名字,返回被点击的字母对应的section的下标


DEF_SIGNAL(TAbLEVIEWLODATA)//DTableViewSlime 读取新的数据
DEF_SIGNAL(TABLEVIEWUPDATA)//DTableViewSlime 刷新数据

DEF_SIGNAL(TABELVIEWBEGAINSCROLL)

DEF_SIGNAL(TAbLEVIEWSCROLLUP)//table向上滑动
DEF_SIGNAL(TAbLEVIEWSCROLLDOWN)//table向下滑动
DEF_SIGNAL(TAbLEVIERELOADOVER)//reload完毕
DEF_SIGNAL(TAbLEVIERETOUCH)//touch事件

@synthesize footerView,headerView, tableViewType = _tableViewType,b_Dragging=_b_Dragging;
@synthesize b_isreloadOver = _b_isreloadOver;
- (void)dealloc{
//    [_agent release];
    [super dealloc];
}

- (void)setTableViewType:(MagicUITableViewType)tableViewType
{
    if (_tableViewType == tableViewType)
    {
        return;
    }
    
    _tableViewType = tableViewType;
    if (_tableViewType == DTableViewNomal)
    {
        [_slimeView removeFromSuperview];
        [self initSignView:self.frame];
    }else
    {
        [self setTableFooterView:NULL];
        [headerView removeFromSuperview];
        [footerView removeFromSuperview];

        [self initSlimeView];
    }
    
}


- (id)initWithFrame:(CGRect)frame{
    
    self = [self initWithFrame:frame isNeedUpdate:NO];

    return self;
}


- (void)initSlimeView
{
    _slimeView = [[MagicUIUpdateView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.tag = self.tag;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [MagicCommentMethod colorWithHex:@"009cd5"];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 0;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor clearColor];
    [self addSubview:_slimeView];
    [_slimeView release];
}

- (void)initSignView:(CGRect)frame
{
    headerView = [[StateView alloc] initWithFrame:CGRectMake(0, -40, frame.size.width, frame.size.height) viewType:VIEWTYPEHEADER];
    [headerView setTag:11];
    
    footerView = [[StateView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) viewType:VIEWTYPEFOOTER];
    [footerView setTag:10];
    [footerView setBackgroundColor:[UIColor clearColor]];
    [self setTableFooterView:footerView];//有了superView后再给代理赋值,否则在没superView时就会回调代理方法
    [self addSubview:headerView];
    [headerView release];
    [footerView release];
}

- (id)initWithFrame:(CGRect)frame isNeedUpdate:(BOOL)isNeedUpdate
{
    self = [super initWithFrame:frame];
    if (self) {
//        _agent = [[MagicUITableViewAgent alloc] init];
        self.delegate = self;
        self.dataSource = self;
        
        if (isNeedUpdate)
        {
            [self initSignView:self.frame];
            [self.headerView setHidden:YES];
            [self.footerView setHidden:YES];
        }
        
        
    }
    return self;
}

- (void)tableViewDidDragging{
    CGFloat offsetY = self.contentOffset.y;
    //  判断是否正在加载
    if (headerView.currentState == PULLSTATELOAD ||
        footerView.currentState == PULLSTATELOAD) {
        return;
    }
    //  改变“下拉可以刷新”视图的文字提示
    if (offsetY < -STATEVIEWHEIGHT - 10) {
        [headerView changeState:PULLSTATEDOWN];
    } else {
        [headerView changeState:PULLSTATENORMAL];
    }
    //  判断数据是否已全部加载
    if (footerView.currentState == PULLSTATEEND) {
        return;
    }
    //  计算表内容大小与窗体大小的实际差距
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    //  改变“上拖加载更多”视图的文字提示
    if (offsetY > differenceY + STATEVIEWHEIGHT / 3 * 2) {
        [footerView changeState:PULLSTATEUP];
    } else {
        [footerView changeState:PULLSTATENORMAL];
    }
}

- (int)tableViewDidEndDragging{
    
    
    CGFloat offsetY = self.contentOffset.y;
    //  判断是否正在加载数据
    if (headerView.currentState == PULLSTATELOAD ||
        footerView.currentState == PULLSTATELOAD) {
        return RETURNDONOTHING;
    }
    //  改变“下拉可以刷新”视图的文字及箭头提示
    if (offsetY < -STATEVIEWHEIGHT - 10) {//下拉到能刷新时松开
        [headerView changeState:PULLSTATELOAD];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.contentInset = UIEdgeInsetsMake(STATEVIEWHEIGHT, 0, 0, 0);
        [UIView commitAnimations];
        
        return RETURNREFRESH;
    }
    
    //判断是否隐藏不执行加载
    if (footerView.isHidden) {
        return RETURNDONOTHING;
    }
    
    //  改变“上拉加载更多”视图的文字及箭头提示
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    if (footerView.currentState != PULLSTATEEND &&
        offsetY > differenceY + STATEVIEWHEIGHT / 3 * 2) {
        [footerView changeState:PULLSTATELOAD];
        return RETURNLOADMORE;
    }
    return RETURNDONOTHING;
}

//更改tableview的加载状态
- (void)changeSmlimeUpdateState:(NSInteger)updateState
{
    if (_slimeView.updateState == DUpdateStateDownLoad)
    {
        [_slimeView endRefresh];
    }
    [_slimeView setUpdateState:updateState];
}

- (void)reloadData:(BOOL)dataIsAllLoaded{
    self.b_isreloadOver = NO;
    
    [self reloadData];
    if (_tableViewType == DTableViewSlime)
    {
        if (_slimeView.updateState == DUpdateStateDownLoad)
        {
            [_slimeView endRefresh];
        }
        if (dataIsAllLoaded)
        {
            [_slimeView setUpdateState:DUpdateStateUpLoadEnd];
        }else
        {
            [_slimeView setUpdateState:DUpdateStateNomal];
        }
    
        
    }else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.contentInset = UIEdgeInsetsZero;
        [UIView commitAnimations];
        
        [headerView changeState:PULLSTATENORMAL];
        //  如果数据已全部加载，则禁用“上拖加载”
        if (dataIsAllLoaded) {
            [footerView changeState:PULLSTATEEND];
        } else {
            [footerView changeState:PULLSTATENORMAL];
        }
        //  更新时间提示文本
        [headerView updateTimeLabel];
        [footerView updateTimeLabel];
    }
    
}

- (void)setSlimeViewRefreshHeight:(MagicSlimeRefreshHeightType)refreshType
{
    if (refreshType == MagicReHeightNomal)
    {
        _slimeView.slime.refreshHeight = 0;
    }else if (refreshType == MagicReHeightMiddle)
    {
        _slimeView.slime.refreshHeight = 0.7f;
    }
    
}

//实现上拉加载动画
- (void)launchRefreshing {
    
    if (_tableViewType == DTableViewSlime)
    {
        [_slimeView setLoadingWithexpansion];
        double delayInSeconds = .5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self slimeRefreshStart:nil];
        });
        
    }else
    {
        [self setContentOffset:CGPointMake(0, -STATEVIEWHEIGHT-11)];
        
        [UIView animateWithDuration:1.f animations:^{
            
        } completion:^(BOOL bl){
            [self tableViewDidEndDragging];
        }];
    }
    
}

#pragma mark -
#pragma mark - uiscrollview
CGFloat scrollerBeginY;//判断scrollview滑动方向
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollerBeginY = scrollView.contentOffset.y;
    [self sendViewSignal:[MagicUITableView TABELVIEWBEGAINSCROLL]];
    _b_Dragging=YES;
    isScrollMoving = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:scrollView, @"scrollView", nil];
    [self sendViewSignal:[MagicUITableView TABLESCROLLVIEWDIDSCROLL] withObject:dict];
    if (_tableViewType == DTableViewSlime)
    {
        [_slimeView scrollViewDidScroll];
        
        //向上
        if (scrollView.contentOffset.y > scrollerBeginY)
        {
            CGFloat count = scrollView.contentOffset.y - scrollerBeginY;
            NSNumber *number = [NSNumber numberWithFloat:count];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:scrollView, @"scrollView", number, @"number", nil];
            if (count > 20 && !isScrollMoving)
            {
                [self sendViewSignal:[MagicUITableView TAbLEVIEWSCROLLUP] withObject:dict];
            }
            
        }else if (scrollView.contentOffset.y < scrollerBeginY)//向下
        {
            CGFloat count = scrollerBeginY - scrollView.contentOffset.y;
            NSNumber *number = [NSNumber numberWithFloat:count];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:scrollView, @"scrollView", number, @"number", nil];
            
            if (count > 20 && !isScrollMoving)
            {
                [self sendViewSignal:[MagicUITableView TAbLEVIEWSCROLLDOWN] withObject:dict];
            }
        }
        
        
        CGSize mainSize = MAINSIZE;
        CGFloat height = self.contentSize.height - mainSize.height - self.contentOffset.y;
        
        if (scrollView.contentOffset.y > scrollerBeginY && [_slimeView updateState] !=DUpdateStateUpLoadEnd &&
            height <= 20 &&
            [_slimeView updateState] == DUpdateStateNomal)
        {
            [_slimeView setUpdateState:DUpdateStateUpLoad];
            [self sendViewSignal:[MagicUITableView TAbLEVIEWLODATA]];
        }
        
        
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    NSNumber *nDecelerate = [NSNumber numberWithBool:decelerate];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:scrollView, @"scrollView", nDecelerate, @"decelerate",nil];
    [self sendViewSignal:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING] withObject:dict];
    if (_tableViewType == DTableViewSlime)
    {
        [_slimeView scrollViewDidEndDraging];
    }
    
    if (decelerate) {
        _b_Dragging=NO;
    }

}
BOOL isScrollMoving;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    isScrollMoving = YES;

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isScrollMoving = NO;
}

#pragma mark
#pragma mark - slimedelegate
- (void)slimeRefreshStart:(MagicUIImageView *)refreshView
{
    if ([_slimeView updateState] == DUpdateStateNomal || [_slimeView updateState] == DUpdateStateUpLoadEnd)
    {
        [_slimeView setUpdateState:DUpdateStateDownLoad];
        [self sendViewSignal:[MagicUITableView TABLEVIEWUPDATA] withObject:_slimeView];
    }
    

}

#pragma mark - uitouchdelegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self sendViewSignal:[MagicUITableView TAbLEVIERETOUCH] withObject:nil];
   
}



#pragma mark - tableviewdelete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section/*第一次回调时系统传的section是数据源里section数量的最大值-1*/
{
    NSInteger numOfRow = 0;
    NSNumber *nSection = [NSNumber numberWithInteger:section];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView", nSection, @"section", nil];
    MagicViewSignal *viewSignal = [self sendViewSignal:[MagicUITableView TABLENUMROWINSEC] withObject:dict];
    NSNumber *num = (NSNumber *)[viewSignal returnValue];
    numOfRow = [num integerValue];
    
    
    return numOfRow;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView", nil];
    MagicViewSignal *viewSignal = [self sendViewSignal:[MagicUITableView TABLENUMOFSEC] withObject:dict];
    
    NSNumber *num = (NSNumber *)[viewSignal returnValue];
    NSInteger numOfRow = [num integerValue];
    
    if (numOfRow == 0) {
        numOfRow = 1;
    }
    
    return numOfRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView", indexPath, @"indexPath", nil];
    MagicViewSignal *viewSignal = [self sendViewSignal:[MagicUITableView TABLEHEIGHTFORROW] withObject:dict];
    NSNumber *n = (NSNumber *)[viewSignal returnValue];
    NSInteger heightOfRow = [n integerValue];
    if (heightOfRow == 0)
    {
        return 40;
    }
    return heightOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView", indexPath, @"indexPath", nil];
    MagicViewSignal *viewSignal = [self sendViewSignal:[MagicUITableView TABLECELLFORROW] withObject:dict];
    UITableViewCell *cell = (UITableViewCell *)[viewSignal returnValue];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView", indexPath, @"indexPath", nil];
    [self sendViewSignal:[MagicUITableView TABLEDIDSELECT] withObject:dict];
}

//每个section头部的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView", [NSNumber numberWithInteger:section], @"section", nil];
    MagicViewSignal *viewSignal = [self sendViewSignal:[MagicUITableView TABLEVIEWFORHEADERINSECTION] withObject:dict];
    UIView *v = (UIView *)[viewSignal returnValue];
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView", [NSNumber numberWithInteger:section], @"section", nil];
    MagicViewSignal *viewSignal = [self sendViewSignal:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION] withObject:dict];
    NSNumber *num = (NSNumber *)[viewSignal returnValue];
    CGFloat heightForHeaderInSection = [num floatValue];

    return heightForHeaderInSection;
}


//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;  // return list of section titles to display in section index view (e.g. "ABCD...Z#")
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView", nil];
    MagicViewSignal *viewSignal = [self sendViewSignal:[MagicUITableView TABLESECTIONINDEXTITLESFORTABLEVIEW] withObject:dict];
    NSArray *array = (NSArray *)[viewSignal returnValue];
    
    return array;
}

//点击右测是索引列表上的某个字母时回调,参数index和title是 右侧索引列表上被点击的字母在 索引列表的下标和名字,返回被点击的字母对应的section的下标
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView",title,@"title",[NSNumber numberWithInteger:index],@"index", nil];
    MagicViewSignal *viewSignal = [self sendViewSignal:[MagicUITableView TABLESECTIONFORSECTIONINDEXTITLE] withObject:dict];
    
    NSNumber *num = (NSNumber *)[viewSignal returnValue];
    return [num integerValue];
}

//每个section头部的内容
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section    // fixed font style. use custom view (UILabel) if you want something different
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:tableView, @"tableView", [NSNumber numberWithInteger:section], @"section", nil];
    MagicViewSignal *viewSignal = [self sendViewSignal:[MagicUITableView TABLETITLEFORHEADERINSECTION] withObject:dict];
    NSString *str = (NSString *)[viewSignal returnValue];
    
    RELEASEDICTARRAYOBJ(dict);
    
    return str;
}
@end
