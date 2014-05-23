//
//  DYBVariableTbvView.m
//  DYiBan
//
//  Created by zhangchao on 13-10-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBVariableTbvView.h"
#import "UITableView+property.h"
#import "UITableViewCell+MagicCategory.h"
#import "Magic_Runtime.h"
#import "UIView+MagicCategory.h"

@implementation DYBVariableTbvView

DEF_SIGNAL(createSectionHeaderView);//创建 定制的 SectionHeaderView 消息
DEF_SIGNAL(createCell);//创建 cell 消息

@synthesize cellClass=_cellClass;
@synthesize tbv=_tbv,v_headerVForHide=_v_headerVForHide;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatTbv];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame cellClass:(Class)cellClass/*tbv里只有一个类型的cell时传进来,多类型cell时在外部创建cell */
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        [self creatTbv];
        _cellClass=cellClass;
    }
    return self;
}


#pragma mark-
-(void)creatTbv{
    
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:self.bounds isNeedUpdate:YES];
        _tbv._cellH=kH_cellDefault*2;
        [_tbv setTableViewType:DTableViewSlime];
        [self addSubview:_tbv];
        _tbv.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
        _tbv.tag=-1;
        _tbv._page=1;
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
        RELEASE(_tbv);
    }
    
    [self creatAllSectionKeys];
    [self creatAllSectionValues];
    [self creatSingelSectionData];
}

-(void)creatAllSectionKeys
{
    if (!_tbv.muA_allSectionKeys) {
        _tbv.muA_allSectionKeys=[[NSMutableArray alloc]initWithCapacity:10];
    }
}

-(void)creatAllSectionValues
{
    if (!_tbv.muD_allSectionValues) {
        _tbv.muD_allSectionValues=[[NSMutableDictionary alloc]initWithCapacity:10];
    }
}


#pragma mark- 创建单section数据源
-(void)creatSingelSectionData
{
    if (!_tbv.muA_singelSectionData) {
        _tbv.muA_singelSectionData=[[NSMutableArray alloc]initWithCapacity:10];
    }
}

-(void)setV_headerVForHide:(UIView *)v
{
//    RELEASE(_v_headerVForHide);
//    _v_headerVForHide=[v retain];
    _tbv.v_headerVForHide=v;
}

#pragma mark- 接受tbv信号

static NSString *cellName = @"cellName";//

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSInteger section = [[dict objectForKey:@"section"] integerValue];
        
        if ([tableView isOneSection]) {/*一个section模式*/
            NSNumber *s = [NSNumber numberWithInteger:tableView.muA_singelSectionData.count];
            [signal setReturnValue:s];
        }else if(tableView.muA_allSectionKeys.count>section){
            NSString *key = [tableView.muA_allSectionKeys objectAtIndex:section];
            NSArray *array = [tableView.muD_allSectionValues objectForKey:key];
            NSNumber *s = [NSNumber numberWithInteger:array.count];
            [signal setReturnValue:s];
        }
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if ([tableView isOneSection]) {/*一个section模式*/
            NSNumber *s = [NSNumber numberWithInteger:1];
            [signal setReturnValue:s];
        }else{
            NSNumber *s = [NSNumber numberWithInteger:tableView.muA_allSectionKeys.count];
            [signal setReturnValue:s];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath  暂时把每个cell保存,后期有时间优化为只保存高度,返回cell时再异步计算cell的视图,目前刷新后所有cell的view都要重新创建
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        NSMutableArray *arr_curSectionForCell=nil;
        NSMutableArray *arr_curSectionForModel=nil;
        
        if (![tableView isOneSection]) {//
            //多section时 _muA_differHeightCellView变成2维数组,第一维是 有几个section,第二维是每个section里有几个cell
            if (!tableView._muA_differHeightCellView) {
                tableView._muA_differHeightCellView=[[NSMutableArray alloc]initWithCapacity:[tableView.muD_allSectionValues allKeys].count];
            }
            
            if (tableView._muA_differHeightCellView.count==0) {
                for (int i=0; i<[tableView.muD_allSectionValues allKeys].count; i++) {
                    [tableView._muA_differHeightCellView addObject:[[NSMutableArray alloc]initWithCapacity:3]];
                }
            }
            
            //保存cell的当前section对应的array
            arr_curSectionForCell=(((NSMutableArray *)([tableView._muA_differHeightCellView objectAtIndex:indexPath.section])));
            
            //保存数据模型的当前section对应的array
            arr_curSectionForModel=[tableView.muD_allSectionValues objectForKey:[tableView.muA_allSectionKeys objectAtIndex:indexPath.section]];
        }
        
        if(indexPath.row==((([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)).count/*只创建没计算过的cell*/) || !tableView._muA_differHeightCellView || ((([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)).count/*只创建没计算过的cell*/)==0)
        {
            UITableViewCell *cell=Nil;
            
            if (_cellClass) {
                cell = [[((UITableViewCell *)[MagicRuntime allocByClass:_cellClass]) initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
                [cell setContent:[(([tableView isOneSection])?(tableView.muA_singelSectionData):(arr_curSectionForModel)) objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
                
            }else{
                MagicViewSignal *viewSignal=[self sendViewSignal:[MagicUITableView TABLEHEIGHTFORROW] withObject:dict from:self target:[self superCon]];//外部创建自己的cell
                cell = (UITableViewCell *)[viewSignal returnValue];
            }

            
            if (!tableView._muA_differHeightCellView) {
                tableView._muA_differHeightCellView=[[NSMutableArray alloc]initWithCapacity:[tableView.muD_allSectionValues allKeys].count];
            }
            
            if (![(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) containsObject:cell]) {
                [(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) addObject:cell];
            }
            
            NSNumber *s = [NSNumber numberWithInteger:cell.frame.size.height];
            [signal setReturnValue:s];
            
        }else{//之前计算过的cell
            NSNumber *s = [NSNumber numberWithInteger:((UITableViewCell *)[(([tableView isOneSection])?(tableView._muA_differHeightCellView):(arr_curSectionForCell)) objectAtIndex:indexPath.row]).frame.size.height];
            [signal setReturnValue:s];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSInteger section = [[dict objectForKey:@"section"] integerValue];
        
        if ([tableView isOneSection]) {/*一个section模式*/
            
        }else{
            [signal setReturnValue:[tableView.muA_allSectionKeys objectAtIndex:section]];
        }
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        if ([tableView isOneSection]) {/*一个section模式*/
        }else{
//            [self createSectionHeaderView:signal]; 
            
//            MagicViewSignal *viewSignal = [self sendViewSignal:[DYBVariableTbvView createSectionHeaderView] withObject:dict];
//            UIView *v = (UIView *)[viewSignal returnValue];
//            [signal setReturnValue:v];
        }
        
    }//
    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        [signal setReturnValue:[NSNumber numberWithFloat:(([tableView isOneSection]/*一个section模式*/)?(0):(kH_tbvForHeaderViewInSection))]];
        
    }
    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell  只返回显示的cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if ([tableView isOneSection]) {/*一个section模式*/
            cell=((UITableViewCell *)[tableView._muA_differHeightCellView objectAtIndex:indexPath.row]);
        }else{
            //保存cell的当前section对应的array
            NSMutableArray *arr_curSectionForCell=(((NSMutableArray *)([tableView._muA_differHeightCellView objectAtIndex:indexPath.section])));
            cell=((UITableViewCell *)[arr_curSectionForCell objectAtIndex:indexPath.row]);
        }
        
        [signal setReturnValue:cell];
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
        [self sendViewSignal:[MagicUITableView TABLEDIDSELECT] withObject:[signal object] from:self target:[self superCon]];

        
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        [self sendViewSignal:[MagicUITableView TAbLEVIEWLODATA] withObject:dict from:self target:[self superCon]];
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        [self sendViewSignal:[MagicUITableView TABLEVIEWUPDATA] withObject:dict from:self target:[self superCon]];

    }
    
    else if ([signal is:[MagicUITableView TABLESECTIONINDEXTITLESFORTABLEVIEW]])//右侧索引列表
    {
//        NSDictionary *dict = (NSDictionary *)[signal object];
//        UITableView *tableView = [dict objectForKey:@"tableView"];
//        
//        if (![tableView isOneSection]) {/*多个section模式*/
//            [signal setReturnValue:tableView.muA_allSectionKeys];
//        }
    }else if ([signal is:[MagicUITableView TABLESECTIONFORSECTIONINDEXTITLE]])//点击右测是索引列表上的某个字母时回调,参数index和title是 右侧索引列表上被点击的字母在 索引列表的下标和名字,返回被点击的字母对应的section的下标
    {
//        NSDictionary *dict = (NSDictionary *)[signal object];
//        UITableView *tableview = [dict objectForKey:@"tableView"];
//        NSString *title = [dict objectForKey:@"title"];
//        NSInteger index = [[dict objectForKey:@"index"] integerValue];
//        
//        //在数据源的下标
//        NSInteger count = 0;
//        
//        for(NSString *character in tableview.muA_allSectionKeys)
//        {
//            if([character isEqualToString:title])
//            {
//                [signal setReturnValue:[NSNumber numberWithInteger:count]];
//                break;
//            }
//            count ++;
//        }
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        [self sendViewSignal:[MagicUITableView TAbLEVIEWSCROLLUP] withObject:dict from:self target:[self superCon]];

        [_tbv StretchingUpOrDown:0];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        [self sendViewSignal:[MagicUITableView TAbLEVIEWSCROLLDOWN] withObject:dict from:self target:[self superCon]];

        [_tbv StretchingUpOrDown:1];
        
    }
}

#pragma mark- 添加数据源(用于多section)
-(void)addDataSource:(NSMutableArray *)muA key:(NSString *)keyPath/*model里区别其它model已分组的属性*/
{
    NSString *lastkeyPath/*上个数据源的keyPath*/=nil;
    for (NSObject *ob in muA) {
        NSString *curkeyPath=[ob valueForKeyPath:keyPath];
        if (![curkeyPath isEqualToString:lastkeyPath]) {
            if (![_tbv.muA_allSectionKeys containsObject:curkeyPath]) {//添加一个新的sectionTitle
                [_tbv.muA_allSectionKeys addObject:curkeyPath];
            }
            
            NSMutableArray *muA=[_tbv.muD_allSectionValues objectForKey:curkeyPath];
            if (!muA) {
                
            }
        }
    }
    
}

#pragma mark- 添加数据源(用于单section)
-(void)addDataSource:(id )ob
{
    if (![_tbv.muA_singelSectionData containsObject:ob]) {
        [_tbv.muA_singelSectionData addObject:ob];
    }
}

#pragma mark- 数据源数量
-(int)dataSourceCount
{
    if ([_tbv isOneSection]) {
        return _tbv.muA_singelSectionData.count;
    }else{
        int count=0;
        for (int i=0;i<_tbv.muA_allSectionKeys.count;i++) {
            NSString *sectionKey=[_tbv.muA_allSectionKeys objectAtIndex:i];
            count+=((NSArray *)[_tbv.muD_allSectionValues objectForKey:sectionKey]).count;
        }
        return count;
    }
}

#pragma mark- 单section时数据源数组
-(NSMutableArray *)DataSourceArray
{
    return _tbv.muA_singelSectionData;
}

#pragma mark- 单section时Cell数组
-(NSMutableArray *)CellArray
{
    return _tbv._muA_differHeightCellView;
}

#pragma mark- 释放数据源
-(void)releaseDataSource
{
    [_tbv releaseDataResource];
}

#pragma mark- 释放cell
-(void)releaseCell
{
    [_tbv release_muA_differHeightCellView];
}

-(void)reloadData:(BOOL)b
{
    [_tbv reloadData:b];
}

-(void)dealloc
{
    [self releaseCell];
    [self releaseDataSource];
    
    REMOVEFROMSUPERVIEW(_tbv);
   
    [super dealloc];
}
@end
