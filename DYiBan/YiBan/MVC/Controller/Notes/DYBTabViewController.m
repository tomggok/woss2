//
//  DYBTabViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-10-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBTabViewController.h"
#import "tag_list_info.h"
#import "DYBCellForTagList.h"
#import "DYBTagManageViewController.h"
#import "Magic_Device.h"
#import "ChineseToPinyin.h"
#import "pinyin.h"
#import "DYBTagNotesViewController.h"

#import "DYBListSelViewController.h"
#import "DYBGuideView.h"
@interface DYBTabViewController ()

@end

@implementation DYBTabViewController

DEF_SIGNAL(REFLIST)

-(void)dealloc{
    RELEASEDICTARRAYOBJ(_arrayTagList);
    RELEASEDICTARRAYOBJ(_arrayTagListCell);
    RELEASE(_Tlist);
    
    [super dealloc];
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        nPage = 1;
        nPageSize = 1000;
        

        
        _arrayTagList = [[NSMutableArray alloc] init];
        _arrayTagListCell = [[NSMutableArray alloc] init];
        
        MagicUIImageView *_viewBKG = [[MagicUIImageView alloc] initWithFrame:self.view.bounds];
        [_viewBKG setBackgroundColor:[UIColor clearColor]];
        [_viewBKG setUserInteractionEnabled:YES];
        
        if ([MagicDevice boundSizeType]==1) {
            [_viewBKG setImage:[UIImage imageNamed:@"bg_note_ip5.png"]];
        }else{
            [_viewBKG setImage:[UIImage imageNamed:@"bg_note.png"]];
        }
        
        [self.view addSubview:_viewBKG];
        RELEASE(_viewBKG);
        
        
        if (!_Tagsearch) {
            _Tagsearch=[[MagicUISearchBar alloc]initWithFrame:CGRectMake(0, self.headHeight+1, self.view.frame.size.width, 50) backgroundColor:ColorNav placeholder:@"标签" isHideOutBackImg:YES isHideLeftView:NO];
            [_Tagsearch customBackGround:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_search"]] autorelease]];
            _Tagsearch.tag=-1;
            [_viewBKG addSubview:_Tagsearch];
            [_Tagsearch release];
        }
        
        _tabTagList = [[DYBUITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_Tagsearch.frame), self.view.frame.size.width, self.frameHeight-self.headHeight-50) isNeedUpdate:YES];
        [_tabTagList setBackgroundColor:[UIColor clearColor]];
        [_tabTagList setTableViewType:DTableViewSlime];
        [_tabTagList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_viewBKG addSubview:_tabTagList];
        RELEASE(_tabTagList);
        
        MagicRequest *request = [DYBHttpMethod notes_taglist:nil showcount:@"1" page:[NSString stringWithFormat:@"%d", nPage] num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
        request.tag = -1;
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"标签"];
        [self.rightButton setTitle:@"管理" forState:UIControlStateNormal];
        [self.rightButton setTitleColor:ColorBlue forState:UIControlStateNormal];
        
        if (![[NSUserDefaults standardUserDefaults] stringForKey:@"DYBTabViewController_DYBGuideView"] || [[[NSUserDefaults standardUserDefaults] stringForKey:@"DYBTabViewController_DYBGuideView"] intValue]==0) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DYBTabViewController_DYBGuideView"];
            
            {
                DYBGuideView *guideV=[[DYBGuideView alloc]initWithFrame:self.view.frame];
                guideV.AddImgByName(@"noteteaching05",nil);
                [self.drNavigationController.view addSubview:guideV];
                RELEASE(guideV);
            }
        }
    }
}

- (void)handleViewSignal_DYBTabViewController:(MagicViewSignal *)signal{
    if ([signal is:[DYBTabViewController REFLIST]]) {
        _Tlist = (tag_list *)[signal object];
        
        if ([_arrayTagList count] > 0) {
            [_arrayTagList removeAllObjects];
            [_arrayTagListCell removeAllObjects];
        }
        
        for (NSDictionary *dic in _Tlist.result) {
            tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
            [_arrayTagList addObject:(tag_list_info *)_tlInfo];
        }
        
        [_arrayTagList sortUsingFunction:DYBSortList context:NULL];
        
        
        if (_viewWarning) {
            REMOVEFROMSUPERVIEW(_viewWarning);
        }
        
        if ([_Tlist.havenext isEqualToString:@"1"]) {
            [_tabTagList reloadData:NO];
        }else{
            [_tabTagList reloadData:YES];
        }
        
        if ([_arrayTagList count] == 0) {
            [self addGuidePage];
        }
        
        [_Tlist retain];
    }
    
}

#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        DYBUITabbarViewController *dync = [DYBUITabbarViewController sharedInstace];
        [dync scrollMainView:1];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
//        NSArray *arrList = [[NSArray alloc] initWithObjects:[_arrayTagList objectAtIndex:0], [_arrayTagList objectAtIndex:1], [_arrayTagList objectAtIndex:2], [_arrayTagList objectAtIndex:3],nil];
//        DYBListSelViewController *vc = [[DYBListSelViewController alloc] initwithTagList:nil];
        
        DYBTagManageViewController *vc = [[DYBTagManageViewController alloc] initwithTagList:_Tlist page:nPage];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
        
    }
    
}

#pragma mark- 只接受UITableView信号
static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        NSNumber *s = [NSNumber numberWithInteger:_arrayTagList.count];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
 
        if (indexPath.row >= [_arrayTagListCell count]) {
            
            DYBCellForTagList *cell = [[[DYBCellForTagList alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[_arrayTagList objectAtIndex:indexPath.row] indexPath:indexPath tbv:tableView];
            
            if (![_arrayTagListCell containsObject:cell]){
                [_arrayTagListCell addObject:cell];
            }
        }
        
        NSNumber *s = [NSNumber numberWithInteger:((DYBCellForTagList *)[_arrayTagListCell objectAtIndex:indexPath.row]).frame.size.height];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        [signal setReturnValue:nil];
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell=((UITableViewCell *)[_arrayTagListCell objectAtIndex:indexPath.row]);
        if (!cell)
        {
            cell=((UITableViewCell *)[_arrayTagListCell objectAtIndex:indexPath.row]);
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        DLogInfo(@"123");
        tag_list_info *_tlInfo = (tag_list_info *)[_arrayTagList objectAtIndex:indexPath.row];
        DYBTagNotesViewController *vc = [[DYBTagNotesViewController alloc] initwithTaginfo:_tlInfo];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        nPage = 1;
        
        [self.view setUserInteractionEnabled:NO];
        
        MagicRequest *request = [DYBHttpMethod notes_taglist:nil showcount:@"1" page:[NSString stringWithFormat:@"%d", nPage] num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
        request.tag = -1;
        
        if (!request) {//无网路
            [_tabTagList reloadData:NO];
        }
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
        nPage ++;
        
        [self.view setUserInteractionEnabled:NO];
        
        MagicRequest *request = [DYBHttpMethod notes_taglist:nil showcount:@"1" page:[NSString stringWithFormat:@"%d", nPage] num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
        request.tag = -2;
        
        if (!request) {//无网路
            [_tabTagList reloadData:NO];
        }
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
        [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [[DYBUITabbarViewController sharedInstace] hideTabBar:NO animated:YES];
        
    }
    
}

#pragma mark- 只接受searchBar信号
- (void)handleViewSignal_MagicUISearchBar:(MagicViewSignal *)signal{
    if ([signal is:[MagicUISearchBar BEGINEDITING]]) {//第一次按下搜索框
        
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        {
            search.showsScopeBar = YES;//控制搜索栏下部的选择栏是否显示出来
            [search setShowsCancelButton:YES animated:YES];
            [search initShadeBt];
            [search initCancelBt:[UIImage imageNamed:@"btn_search_cancel"] HighlightedImg:[UIImage imageNamed:@"btn_search_cancel"]];
            
        }
        
    }else if ([signal is:[MagicUISearchBar CANCEL]]){//

        [_Tagsearch cancelSearch];
        
        if (_Tlist) {
            if ([_arrayTagList count] > 0) {
                [_arrayTagList removeAllObjects];
                [_arrayTagListCell removeAllObjects];
            }
            
            for (NSDictionary *dic in _Tlist.result) {
                tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
                [_arrayTagList addObject:(tag_list_info *)_tlInfo];
            }
            
            [_arrayTagList sortUsingFunction:DYBSortList context:NULL];
            
            if ([_Tlist.havenext isEqualToString:@"1"]) {
                [_tabTagList reloadData:NO];
            }else{
                [_tabTagList reloadData:YES];
            }
        }else{
            nPage = 1;
            
            MagicRequest *request = [DYBHttpMethod notes_taglist:nil showcount:@"1" page:[NSString stringWithFormat:@"%d", nPage] num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
            request.tag = -1;
        }
        
    }else if ([signal is:[MagicUISearchBar SEARCH]]){//按下搜索按钮
        MagicUISearchBar *search=(MagicUISearchBar *)signal.object;
        
        MagicRequest *request = [DYBHttpMethod notes_taglist:search.text showcount:@"1" page:@"1" num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
        request.tag = -10;
        
    }else if ([signal is:[MagicUISearchBar CHANGEWORD]]){//内容改变
        
    }else if ([signal is:[MagicUISearchBar SEARCHING]]){
        
    }
}

#pragma mark- 标签排序算法
NSInteger DYBSortList(id tinfo1, id tinfo2, void *context)
{
    tag_list_info *t1 = (tag_list_info *)tinfo1;
    tag_list_info *t2 = (tag_list_info *)tinfo2;
    
    if ([t1.tag length] > 0 && [t2.tag length] > 0) {
        NSRange range = NSMakeRange(0, 1);
        NSString *strTaf1 = t1.tag;
        NSString *strTaf2 = t2.tag;
        
        if ([t1.sys isEqualToString:@"2"] && [t2.sys isEqualToString:@"2"]) {
            return NSOrderedSame;
        }else if ([t1.sys isEqualToString:@"2"]){
            return NSOrderedAscending;
        }else if ([t2.sys isEqualToString:@"2"]){
            return NSOrderedDescending;
        }else{
            NSString *subString1 = [strTaf1 substringWithRange:range];
            const char *cString1 = [subString1 UTF8String];
            
            NSString *subString2 = [strTaf2 substringWithRange:range];
            const char *cString2 = [subString2 UTF8String];
            
            if (strlen(cString1) == 3 && strlen(cString2) == 3) {
                return  [t2.tag localizedCompare:t1.tag];
            }else if (strlen(cString1) == 3 || strlen(cString2) == 3){
                NSString *str11stLetter = nil;
                NSString *str21stLetter = nil;
                
                if (strlen(cString1) == 3) {
                    str11stLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([strTaf1 characterAtIndex:0])] uppercaseString];
                    str21stLetter = [[strTaf2 substringWithRange:NSMakeRange(0, 1)] uppercaseString];
                }else{
                    str11stLetter = [[strTaf1 substringWithRange:NSMakeRange(0, 1)] uppercaseString];
                    str21stLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([strTaf2 characterAtIndex:0])] uppercaseString];
                }
                
                return [str11stLetter compare:str21stLetter];
                
            }else{
                return  [t1.tag localizedCompare:t2.tag];
            }
        }
        
        
    }
    
    return  [t1.tag localizedCompare:t2.tag];
}

#pragma mark- NSString 测试排序算法
NSInteger DYBSortStr(id tinfo1, id tinfo2, void *context)
{
    NSString *t1 = (NSString *)tinfo1;
    NSString *t2 = (NSString *)tinfo2;
    
    if ([t1 length] > 0 && [t2 length] > 0) {
        NSRange range = NSMakeRange(0, 1);
        NSString *strTaf1 = t1;
        NSString *strTaf2 = t2;
        
        NSString *subString1 = [strTaf1 substringWithRange:range];
        const char *cString1 = [subString1 UTF8String];
        
        NSString *subString2 = [strTaf2 substringWithRange:range];
        const char *cString2 = [subString2 UTF8String];
        
        if (strlen(cString1) == 3 && strlen(cString2) == 3) {
            return  [t2 localizedCompare:t1];
        }else if (strlen(cString1) == 3 || strlen(cString2) == 3){
            NSString *str11stLetter = nil;
            NSString *str21stLetter = nil;
            
            if (strlen(cString1) == 3) {
                str11stLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([strTaf1 characterAtIndex:0])] uppercaseString];
                str21stLetter = [[strTaf2 substringWithRange:NSMakeRange(0, 1)] uppercaseString];
            }else{
                str11stLetter = [[strTaf1 substringWithRange:NSMakeRange(0, 1)] uppercaseString];
                str21stLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([strTaf2 characterAtIndex:0])] uppercaseString];
            }
            
            return [str11stLetter compare:str21stLetter];
            
        }else{
            return  [t1 localizedCompare:t2];
        }

    }
    return  [t1 localizedCompare:t2];
}

#pragma mark- 消息返回处理
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{
    
    [self.view setUserInteractionEnabled:YES];
    
    if (_Tagsearch) {
        [_Tagsearch cancelSearch];
    }

    if ([request succeed]){
        if (request.tag == -1){/*初始化*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                _Tlist = [tag_list JSONReflection:respose.data];
                
                if ([_arrayTagList count] > 0) {
                    [_arrayTagList removeAllObjects];
                    [_arrayTagListCell removeAllObjects];
                }

                for (NSDictionary *dic in _Tlist.result) {
                    tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];                 
                    [_arrayTagList addObject:(tag_list_info *)_tlInfo];
                }

               [_arrayTagList sortUsingFunction:DYBSortList context:NULL];
                
                
                if (_viewWarning) {
                    REMOVEFROMSUPERVIEW(_viewWarning);
                }
                
                if ([_Tlist.havenext isEqualToString:@"1"]) {
                    [_tabTagList reloadData:NO];
                }else{
                    [_tabTagList reloadData:YES];
                }
                
                if ([_arrayTagList count] == 0) {
                    [self addGuidePage];
                }
                
                [_Tlist retain];

            }
        }else if (request.tag == -2){
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                tag_list *tMorelist = [tag_list JSONReflection:respose.data];
                
                for (NSDictionary *dic in tMorelist.result) {
                    tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
                    [_arrayTagList addObject:(tag_list_info *)_tlInfo];
                }
                
                if (_viewWarning) {
                    REMOVEFROMSUPERVIEW(_viewWarning);
                }
                
                [_arrayTagList sortUsingFunction:DYBSortList context:NULL];
                
                if ([tMorelist.havenext isEqualToString:@"1"]) {
                    [_tabTagList reloadData:NO];
                }else{
                    [_tabTagList reloadData:YES];
                }
                
                if ([_arrayTagList count] == 0) {
                    [self addGuidePage];
                }
            }
            
        }else if (request.tag == -10){/*初始化*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                tag_list *_TSlist = [tag_list JSONReflection:respose.data];
                
                if ([_arrayTagList count] > 0) {
                    [_arrayTagList removeAllObjects];
                    [_arrayTagListCell removeAllObjects];
                }
                
                for (NSDictionary *dic in _TSlist.result) {
                    tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
                    [_arrayTagList addObject:(tag_list_info *)_tlInfo];
                }
                
                if (_viewWarning) {
                    REMOVEFROMSUPERVIEW(_viewWarning);
                }
                
                [_arrayTagList sortUsingFunction:DYBSortList context:NULL];
                
                if ([_TSlist.havenext isEqualToString:@"1"]) {
                    [_tabTagList reloadData:NO];
                }else{
                    [_tabTagList reloadData:YES];
                }
                
                if ([_arrayTagList count] == 0) {
                    [self addGuidePage];
                }
            }
        }
        
    }else if ([request failed]){
        [self.view setUserInteractionEnabled:YES];


    }
}


-(void)addGuidePage{
    if(!_viewWarning){
        _viewWarning= [[UIView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(_tabTagList.frame), self.frameHeight-self.headHeight)];
        [_viewWarning setBackgroundColor:[UIColor clearColor]];
        [_tabTagList addSubview:_viewWarning];
        RELEASE(_viewWarning);
        
        MagicUILabel *labWarning = [[MagicUILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-250)/2, 0, 250, 60)];
        [labWarning setBackgroundColor:[UIColor clearColor]];
        [labWarning setText:@"一条标签也没有\n请猛戳右上角的按钮来新建"];
        [labWarning setNumberOfLines:2];
        [labWarning setTextColor:ColorGray];
        [labWarning setFont:[DYBShareinstaceDelegate DYBFoutStyle:20]];
        [labWarning setTextAlignment:NSTextAlignmentCenter];
        [labWarning setUserInteractionEnabled:YES];
        
        UIImage *image = [UIImage imageNamed:@"ybx_big.png"];
        float BearHeadStartX = (CGRectGetWidth(self.view.frame)-image.size.width/2)/2;
        float BearHeadStartY = (self.frameHeight-self.headHeight-image.size.height/2 - 150)/2-44;
        MagicUIImageView *viewBearHead = [[MagicUIImageView alloc] initWithFrame:CGRectMake(BearHeadStartX, BearHeadStartY, image.size.width/2, image.size.height/2)];
        [viewBearHead setBackgroundColor:[UIColor clearColor]];
        [viewBearHead setImage:image];
        [viewBearHead setUserInteractionEnabled:YES];
        
        [labWarning setFrame:CGRectMake(CGRectGetMinX(labWarning.frame), CGRectGetMaxY(viewBearHead.frame)+10, CGRectGetWidth(labWarning.frame), CGRectGetHeight(labWarning.frame))];
        
        [_viewWarning addSubview:labWarning];
        [_viewWarning addSubview:viewBearHead];
        RELEASE(viewBearHead);
        RELEASE(labWarning);
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapScreenWithGesture:)];
        [_viewWarning addGestureRecognizer:tapGestureRecognizer];
        RELEASE(tapGestureRecognizer);
    }
}

- (void)didTapScreenWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
        DLogInfo(@"%d", tappedView.tag);
        
        [self sendViewSignal:[DYBBaseViewController NEXTSTEPBUTTON]];
        
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

@end
