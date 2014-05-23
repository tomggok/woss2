//
//  UITableView+CellH.m
//  ShangJiaoYuXin
//
//  Created by zhangchao on 13-5-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UITableView+property.h"
#import <objc/runtime.h>
#import "NSDictionary-MutableDeepCopy.h"
#import "UIView+DragonCategory.h"

@implementation UITableView (property)

@dynamic _cellH,_b_ifOpen,_i_didSection,_i_endSection,_selectIndex_now,_selectIndex_last,_muA_differHeightCellView,_b_isNeedResizeCell,_b_isNeedReloadFromDB,_b_isAutoRefresh,_b_isToObtainData,_page,muA_allCompareWord,muA_allSectionKeys,muD_allSectionValues,muD_allSectionValueCopy,muA_singelSectionData,muA_singelSectionDataCopy,i_pageNums,indexAfterRequest;

static char _c_cellH;
-(CGFloat)_cellH
{    
    return [objc_getAssociatedObject(self, &_c_cellH) floatValue];
    
}
-(void)set_cellH:(CGFloat)f
{
    objc_setAssociatedObject(self, &_c_cellH, [NSNumber numberWithFloat:f], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char _c_b_ifOpen;
-(BOOL)_b_ifOpen
{
    return [objc_getAssociatedObject(self, &_c_b_ifOpen) boolValue];
    
}
-(void)set_b_ifOpen:(BOOL)b
{
    objc_setAssociatedObject(self, &_c_b_ifOpen, [NSNumber numberWithBool:b], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char _c_i_didSection;
-(NSInteger)_i_didSection
{
    return [objc_getAssociatedObject(self, &_c_i_didSection) integerValue];
    
}
-(void)set_i_didSection:(NSInteger)i
{
    objc_setAssociatedObject(self, &_c_i_didSection, [NSNumber numberWithInteger:i], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char _c_i_endSection;
-(NSInteger)_i_endSection
{
    return [objc_getAssociatedObject(self, &_c_i_endSection) integerValue];
    
}
-(void)set_i_endSection:(NSInteger)i
{
    objc_setAssociatedObject(self, &_c_i_endSection, [NSNumber numberWithInteger:i], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char _c_selectIndex_now;
-(NSIndexPath *)_selectIndex_now
{
    return objc_getAssociatedObject(self, &_c_selectIndex_now);
    
}
-(void)set_selectIndex_now:(NSIndexPath *)index
{
    objc_setAssociatedObject(self, &_c_selectIndex_now, index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char _c_selectIndex_last;
-(NSIndexPath *)_selectIndex_last
{
    return objc_getAssociatedObject(self, &_c_selectIndex_last);
    
}
-(void)set_selectIndex_last:(NSIndexPath *)index
{
    objc_setAssociatedObject(self, &_c_selectIndex_last, index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char _c_muA_differHeightCellView;
-(NSMutableArray *)_muA_differHeightCellView
{
    return objc_getAssociatedObject(self, &_c_muA_differHeightCellView);
    
}
-(void)set_muA_differHeightCellView:(NSMutableArray *)muA
{
    objc_setAssociatedObject(self, &_c_muA_differHeightCellView, muA, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char _c_b_isNeedResizeCell;
-(BOOL)_b_isNeedResizeCell
{
    return [objc_getAssociatedObject(self, &_c_b_isNeedResizeCell) boolValue];
    
}
-(void)set_b_isNeedResizeCell:(BOOL)b
{
    objc_setAssociatedObject(self, &_c_b_isNeedResizeCell, [NSNumber numberWithBool:b], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char _c_b_isNeedReloadFromDB;
-(BOOL)_b_isNeedReloadFromDB
{
    return [objc_getAssociatedObject(self, &_c_b_isNeedReloadFromDB) boolValue];
    
}
-(void)set_b_isNeedReloadFromDB:(BOOL)b
{
    objc_setAssociatedObject(self, &_c_b_isNeedReloadFromDB, [NSNumber numberWithBool:b], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char _c_b_isToObtainData;
-(BOOL)_b_isToObtainData
{
    return [objc_getAssociatedObject(self, &_c_b_isToObtainData) boolValue];
    
}
-(void)set_b_isToObtainData:(BOOL)b
{
    objc_setAssociatedObject(self, &_c_b_isToObtainData, [NSNumber numberWithBool:b], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char _c_b_isAutoRefresh;
-(BOOL)_b_isAutoRefresh
{
    return [objc_getAssociatedObject(self, &_c_b_isAutoRefresh) boolValue];
    
}
-(void)set_b_isAutoRefresh:(BOOL)b
{
    objc_setAssociatedObject(self, &_c_b_isAutoRefresh, [NSNumber numberWithBool:b], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char _c_page;
-(int)_page
{
    return [objc_getAssociatedObject(self, &_c_page) intValue];
    
}
-(void)set_page:(int)i
{
    objc_setAssociatedObject(self, &_c_page, [NSNumber numberWithInt:i], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_muA_allSectionKeys;
-(NSMutableArray *)muA_allSectionKeys
{
    return objc_getAssociatedObject(self, &c_muA_allSectionKeys);
    
}

//当 成员变量的名字不已_开头时,其set方法后的名字的首字母要大写,已符合命名规则
-(void)setMuA_allSectionKeys:(NSMutableArray *)muA
{
    objc_setAssociatedObject(self, &c_muA_allSectionKeys, muA, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_muA_allCompareWord;
-(NSMutableArray *)muA_allCompareWord
{
    return objc_getAssociatedObject(self, &c_muA_allCompareWord);
    
}
-(void)setMuA_allCompareWord:(NSMutableArray *)muA
{
    objc_setAssociatedObject(self, &c_muA_allCompareWord, muA, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_muD_allSectionValues;
-(NSMutableArray *)muD_allSectionValues
{
    return objc_getAssociatedObject(self, &c_muD_allSectionValues);
    
}
-(void)setMuD_allSectionValues:(NSMutableArray *)muA
{
    objc_setAssociatedObject(self, &c_muD_allSectionValues, muA, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_muD_allSectionValueCopy;
-(NSMutableArray *)muD_allSectionValueCopy
{
    return objc_getAssociatedObject(self, &c_muD_allSectionValueCopy);
    
}
-(void)setMuD_allSectionValueCopy:(NSMutableArray *)muA
{
    objc_setAssociatedObject(self, &c_muD_allSectionValueCopy, muA, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_muA_singelSectionData;
-(NSMutableArray *)muA_singelSectionData
{
    return objc_getAssociatedObject(self, &c_muA_singelSectionData);
    
}

//当 成员变量的名字不已_开头时,其set方法后的名字的首字母要大写,已符合命名规则
-(void)setMuA_singelSectionData:(NSMutableArray *)muA
{
    objc_setAssociatedObject(self, &c_muA_singelSectionData, muA, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_muA_singelSectionDataCopy;
-(NSMutableArray *)muA_singelSectionDataCopy
{
    return objc_getAssociatedObject(self, &c_muA_singelSectionDataCopy);
    
}

//当 成员变量的名字不已_开头时,其set方法后的名字的首字母要大写,已符合命名规则
-(void)setMuA_singelSectionDataCopy:(NSMutableArray *)muA
{
    objc_setAssociatedObject(self, &c_muA_singelSectionDataCopy, muA, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_i_pageNums;
-(int)i_pageNums
{
    return [objc_getAssociatedObject(self, &c_i_pageNums) intValue];
    
}
-(void)setI_pageNums:(int)i
{
    objc_setAssociatedObject(self, &c_i_pageNums, [NSNumber numberWithInt:i], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_indexAfterRequest;
-(NSIndexPath *)indexAfterRequest
{
    return objc_getAssociatedObject(self, &c_indexAfterRequest);
    
}
-(void)setIndexAfterRequest:(NSIndexPath *)index
{
    objc_setAssociatedObject(self, &c_indexAfterRequest, index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark- 选中section后展开或收缩cell
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert/*第一次是否插入或删除cell*/ nextDo:(BOOL)nextDoInsert/*下次是否插入或删除cell*/ dataSourceCount:(NSInteger)dataSourceCount/*总section数量*/ firstDoInsertCellNums:(NSInteger)firstDoInsertCellNums/*第一次要插入或删除的cell*/ nextDoInsertCellNums:(NSInteger)nextDoInsertCellNums/*第2次要插入或删除的cell*/{
    [self beginUpdates];
    self._b_ifOpen = firstDoInsert;
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    
    for (int i=0; i<firstDoInsertCellNums; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:self._i_didSection];
        [rowToInsert addObject:indexPath];
    }
    
    if (!self._b_ifOpen) {
        self._i_didSection = -1;
        [self deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [self insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }
    [rowToInsert release];
    [self endUpdates];
    
    if (nextDoInsert) {//下次插入cell
        self._i_didSection = self._i_endSection;
        [self didSelectCellRowFirstDo:YES nextDo:NO dataSourceCount:dataSourceCount firstDoInsertCellNums:nextDoInsertCellNums nextDoInsertCellNums:0];
    }
    [self scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark-刷新section
- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation NS_AVAILABLE_IOS(3_0){
    NSRange range = NSMakeRange(section, 1);
    
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    
    [self reloadSections:sectionToReload withRowAnimation:animation];
}

#pragma mark-重置所有section的数据源并刷新所有section的key及单section的数据源
- (void)resetSectionData {
    if ([self isOneSection]) {//单section
        if (!self.muA_singelSectionDataCopy) {
            self.muA_singelSectionDataCopy=[[NSMutableArray alloc]initWithArray:self.muA_singelSectionData];
        }else{
//            [self releaseDataResource];

            RELEASEDICTARRAYOBJ(self.muA_singelSectionData);
            self.muA_singelSectionData=[[NSMutableArray alloc]initWithArray:self.muA_singelSectionDataCopy];
        }
        
    }else{
        if (!self.muD_allSectionValueCopy) {
            self.muD_allSectionValueCopy=[self.muD_allSectionValues mutableDeepCopy];
        }else{
//            [self releaseDataResource];
            RELEASEDICTARRAYOBJ(self.muD_allSectionValues);

            self.muD_allSectionValues=[self.muD_allSectionValueCopy mutableDeepCopy];
        }
        
        //    NSMutableDictionary *allNamesCopy = [_tbv_friends_myConcern_RecentContacts.muD_allSectionValues mutableDeepCopy];
        NSMutableArray *keyArray = [[NSMutableArray alloc] init];
        //    [keyArray addObject:UITableViewIndexSearch];
        [keyArray addObjectsFromArray:[[self.muD_allSectionValues allKeys]
                                       sortedArrayUsingSelector:@selector(compare:)]];
        
        if ([[keyArray objectAtIndex:0] isEqualToString:@"#"]) {//把#放数组最后
            [keyArray removeObjectAtIndex:0];
            [keyArray insertObject:@"#" atIndex:[keyArray count]];
        }
        
        RELEASEDICTARRAYOBJ(self.muA_allSectionKeys);
        self.muA_allSectionKeys = keyArray;
        //    [keyArray release];
    }
    
}

#pragma mark-释放_muA_differHeightCellView里的cell视图,用于 在释放tbv之前,释放tbv数据源之后回调
-(void)release_muA_differHeightCellView
{
    for (UITableViewCell *cell in self._muA_differHeightCellView) {
        if ([cell isKindOfClass:[UITableViewCell class]]) {
//            [cell removeFromSuperview];
            if (cell.superview) {//6个 显示出来的cell不能释放
                [cell removeFromSuperview];
            }else{
//                RELEASE(cell);
            }
            
            [cell removeAllSignal];
        }else if ([cell isKindOfClass:[NSMutableArray class]]){//当 多section时,_muA_differHeightCellView是二维数组
            NSMutableArray *array=(NSMutableArray *)cell;
            
            for (UITableViewCell *cell2 in array) {
                if ([cell2 isKindOfClass:[UITableViewCell class]]) {
                    [cell2 removeFromSuperview];
                    [cell2 removeAllSignal];
                }
            }
            
            [array removeAllObjects];
        }
    }
    [self._muA_differHeightCellView removeAllObjects];//此句只能释放数组里未被显示的cell,显示出来的cell在tbv的dealloc方法里自动被释放
    self._muA_differHeightCellView=Nil;
//    RELEASEDICTARRAYOBJ(self._muA_differHeightCellView);
    
    if (self._selectIndex_last) {
//        RELEASEOBJ(self._selectIndex_last);
//        [self._selectIndex_last release];
        self._selectIndex_last=nil;

    }
    
    if (self._selectIndex_now) {
//        RELEASEOBJ(self._selectIndex_now);
//        [self._selectIndex_now release];
        self._selectIndex_now=nil;
    }

}


-(BOOL)isOneSection{
    return (!self.muD_allSectionValues ||[self.muD_allSectionValues allValues].count==0 )&& (!self.muA_allSectionKeys || [self.muD_allSectionValues allKeys].count==0) && (self.muA_singelSectionData);
}


#pragma mark-释放tbv数据源,在 释放tbv的cell之前调
-(void)releaseDataResource
{
    if (self.muA_allCompareWord) {
        
        RELEASEDICTARRAYOBJ(self.muA_allCompareWord);
    }
   
    if (self.muA_allSectionKeys) {
        
        RELEASEDICTARRAYOBJ(self.muA_allSectionKeys);

    }
    
    if (self.muD_allSectionValues) {
        
        RELEASEDICTARRAYOBJ(self.muD_allSectionValues);

    }
    
    if (self.muD_allSectionValueCopy) {
        
        RELEASEDICTARRAYOBJ(self.muD_allSectionValueCopy);
        
    }
    
    if (self.muA_singelSectionData) {
        RELEASEDICTARRAYOBJ(self.muA_singelSectionData);

    }
    
    if (self.muA_singelSectionDataCopy) {
        RELEASEDICTARRAYOBJ(self.muA_singelSectionDataCopy);
        
    }
  
}
//-(void)dealloc
//{
//    DLogInfo(@"%d",self._muA_differHeightCellView.retainCount);
//    [self._muA_differHeightCellView release];
////    self._muA_differHeightCellView=Nil;
//    [super dealloc];
//}


@end