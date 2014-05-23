//
//  DYBListSelViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-11-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBListSelViewController.h"
#import "DYBCellForTagManage.h"
#import "Magic_Device.h"
#import "UITableView+property.h"
#import "DYBInputView.h"
#import "ChineseToPinyin.h"
#import "pinyin.h"
#import "DYBCellForTagList.h"
#import "tag_list_info.h"
#import "DYBTabViewController.h"
#import "DYBNoteDetailViewController.h"

@interface DYBListSelViewController ()

@end

@implementation DYBListSelViewController
DEF_SIGNAL(DELTAG)

-(void)dealloc{
    RELEASEDICTARRAYOBJ(_arrayTagManage);
    RELEASEDICTARRAYOBJ(_arrayTagManageCell);
    RELEASEDICTARRAYOBJ(_arrayTagSelected);
    RELEASE(_Tlist);
    
    [super dealloc];
}

- (id)initwithTagList:(NSArray *)arrtagList{
    self = [super init];
    if (self) {
        
        while([arrtagList count] > 5) {
            [((NSMutableArray *)arrtagList) removeLastObject];
        }
        _arrayTagSelected = [[NSMutableArray alloc] initWithArray:arrtagList];
    }
    return self;
    
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        nPage = 1;
        nPageSize = 1000;
        
        _arrayTagManage = [[NSMutableArray alloc] init];
        _arrayTagManageCell = [[NSMutableArray alloc] init];
        
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
        
        
        if (!_viewSelBKG) {
            _viewSelBKG=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.headHeight+1, self.view.frame.size.width, 70)];
            [_viewSelBKG setBackgroundColor:[UIColor whiteColor]];
            [_viewSelBKG setShowsHorizontalScrollIndicator:NO];
            [_viewSelBKG setScrollEnabled:NO];
            [_viewSelBKG setUserInteractionEnabled:YES];
            [_viewBKG addSubview:_viewSelBKG];
            [_viewSelBKG release];
            
            
            _lbTagCount = [[MagicUILabel alloc] initWithFrame:CGRectMake(280, self.headHeight+51, 30, 15)];
            [_lbTagCount setBackgroundColor:[UIColor clearColor]];
            [_lbTagCount setFont:[DYBShareinstaceDelegate DYBFoutStyle:13]];
            [_lbTagCount setTextColor:ColorTextCount];
            [_lbTagCount setText:[NSString stringWithFormat:@"%d/5", [_arrayTagSelected count]]];
            [_lbTagCount setTextAlignment:NSTextAlignmentLeft];
            [_lbTagCount setNeedCoretext:YES];
            [_viewBKG addSubview:_lbTagCount];
            [_viewBKG bringSubviewToFront:_lbTagCount];
            RELEASE(_lbTagCount);
            
            _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_viewSelBKG.frame)-1, self.view.frame.size.width, .5f)];
            [_lineView setBackgroundColor:ColorDivLine];
            [_viewSelBKG addSubview:_lineView];
            RELEASE(_lineView);
        }
        
        _tabTagManage = [[DYBUITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewSelBKG.frame), self.view.frame.size.width, self.frameHeight-self.headHeight-70) isNeedUpdate:YES];
        [_tabTagManage setBackgroundColor:[UIColor clearColor]];
        [_tabTagManage setTableViewType:DTableViewSlime];
        [_tabTagManage setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_viewBKG addSubview:_tabTagManage];
        RELEASE(_tabTagManage);
        
        
        _bottomAddTag = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tabTagManage.frame)-50, self.view.frame.size.width, 50)];
        [_bottomAddTag setBackgroundColor:[UIColor whiteColor]];
        [_bottomAddTag setAlpha:0.9f];
        [_viewBKG addSubview:_bottomAddTag];
        RELEASE(_bottomAddTag);
        
        UIView *_lineAdd = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, self.view.frame.size.width, .5f)];
        [_lineAdd setBackgroundColor:ColorDivLine];
        [_bottomAddTag addSubview:_lineAdd];
        RELEASE(_lineAdd);
        
        UIImage *imgAdd = [UIImage imageNamed:@"footer_addtag.png"];
        MagicUIImageView *viewAdd = [[MagicUIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-imgAdd.size.width/2)/2, 0, imgAdd.size.width/2, imgAdd.size.height/2)];
        [viewAdd setBackgroundColor:[UIColor clearColor]];
        [viewAdd setUserInteractionEnabled:YES];
        [viewAdd setImage:imgAdd];
        [_bottomAddTag addSubview:viewAdd];
        RELEASE(viewAdd);
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapWithGesture:)];
        [_bottomAddTag addGestureRecognizer:tapGestureRecognizer];
        RELEASE(tapGestureRecognizer);
        
        MagicRequest *request = [DYBHttpMethod notes_taglist:nil showcount:@"1" page:@"1" num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
        request.tag = -1;
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"标签选择"];
        
        [self backImgType:0];
        [self backImgType:3];
    }
}

- (void)didTapWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        DYBDataBankShotView *view = [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_RENAME rowNum:@"1"];
        [view changePlaceText:@"新建标签"];
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        _strNewTag = [dict objectForKey:@"text"];
        NSString *type = [dict objectForKey:@"type"];
        
        if ([type intValue] == BTNTAG_RENAME) {
            BOOL bOK = [DYBShareinstaceDelegate isOKName:_strNewTag];
            
            int lenght = [_strNewTag length];
            if (!bOK|| lenght > 6) {
                
                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"输入的名称不符合要求" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",0]];
                
                return;
                
            }
            
            MagicRequest *request = [DYBHttpMethod notes_addtag:_strNewTag isAlert:YES receive:self];
            request.tag = -6;
            
        }
    }
}

#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
            if ([vc isKindOfClass:[DYBNoteDetailViewController class]]) {
                [self sendViewSignal:[DYBNoteDetailViewController SELTAG] withObject:_arrayTagSelected from:self target:(DYBNoteDetailViewController *)vc];
                
                [self.drNavigationController popVCAnimated:YES];

                break;
            }
        }
    }
    
}

#pragma mark- 只接受UITableView信号
static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        NSNumber *s = [NSNumber numberWithInteger:_arrayTagManage.count];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        
        if (indexPath.row >= [_arrayTagManageCell count]) {
            
            DYBCellForTagManage *cell = [[[DYBCellForTagManage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            [cell setContent:[_arrayTagManage objectAtIndex:indexPath.row] selected:NO indexPath:indexPath tbv:tableView];

            if (![_arrayTagManageCell containsObject:cell]){
                [_arrayTagManageCell addObject:cell];
                _tabTagManage._muA_differHeightCellView = _arrayTagManageCell;
            }
        }
        
        NSNumber *s = [NSNumber numberWithInteger:((DYBCellForTagList *)[_arrayTagManageCell objectAtIndex:indexPath.row]).frame.size.height];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        [signal setReturnValue:nil];
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell=((UITableViewCell *)[_arrayTagManageCell objectAtIndex:indexPath.row]);
        if (!cell)
        {
            cell=((UITableViewCell *)[_arrayTagManageCell objectAtIndex:indexPath.row]);
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        if ([_arrayTagSelected count] < 5) {
            DYBCellForTagManage *cell = [_arrayTagManageCell objectAtIndex:indexPath.row];
            [cell reColorCell];
            
            tag_list_info *tagAdd = [_arrayTagManage objectAtIndex:indexPath.row];
            if (![_arrayTagSelected containsObject:tagAdd]) {
                [_arrayTagSelected addObject:tagAdd];
                [self AddSelectedTag:tagAdd];
                [_lbTagCount setText:[NSString stringWithFormat:@"%d/5", [_arrayTagSelected count]]];
            }
        }
 
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        nPage = 1;
        
        [self.view setUserInteractionEnabled:NO];
        
        MagicRequest *request = [DYBHttpMethod notes_taglist:nil showcount:@"1" page:@"1" num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
        request.tag = -1;
        
        if (!request) {//无网路
            [_tabTagManage reloadData:NO];
        }
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
        nPage ++;
        
        [self.view setUserInteractionEnabled:NO];
        
        MagicRequest *request = [DYBHttpMethod notes_taglist:nil showcount:@"1" page:[NSString stringWithFormat:@"%d", nPage] num:[NSString stringWithFormat:@"%d", nPageSize] isAlert:YES receive:self];
        request.tag = -2;
        
        if (!request) {//无网路
            [_tabTagManage reloadData:NO];
        }
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
        [self hiddeBar:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
        
        [self hiddeBar:NO];
        
    }
}

-(void)hiddeBar:(BOOL)bhide{
    float fMaxY = CGRectGetMinY(_bottomAddTag.frame);
    DLogInfo(@"%f", CGRectGetMaxY(_tabTagManage.frame));
    
    if (!bhide && fMaxY == CGRectGetMaxY(_tabTagManage.frame)-50) {
        return;
    }else if (bhide && fMaxY == CGRectGetMaxY(_tabTagManage.frame)){
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3f];
    if (bhide) {
        [_bottomAddTag setFrame:CGRectMake(0, CGRectGetMaxY(_tabTagManage.frame), self.view.frame.size.width, 50)];
    }else{
        [_bottomAddTag setFrame:CGRectMake(0, CGRectGetMaxY(_tabTagManage.frame)-50, self.view.frame.size.width, 50)];
    }

    [UIView commitAnimations];
}


- (void)AddSelectedTag:(tag_list_info *)addTag{
    float fStartX = 8;
    
    for (int i = 0; i < [_arrayTagSelected count]; i++) {
        if (i > 0) {
            tag_list_info *tagAdd = [_arrayTagSelected objectAtIndex:i-1];
            
            if (![tagAdd.tag_id isEqualToString:addTag.tag_id]) {
                fStartX = fStartX + [tagAdd.tag sizeWithFont:[DYBShareinstaceDelegate DYBFoutStyle:18]].width+56;
            }else{
                break;
            }
        }
    }
 
    MagicUILabel *_lbTagName = [[MagicUILabel alloc] initWithFrame:CGRectMake(fStartX, 15, 100, 30)];
    [_lbTagName setBackgroundColor:ColorGreen];
    [_lbTagName setFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
    [_lbTagName setText:addTag.tag];
    [_lbTagName setTextColor:[UIColor whiteColor]];
    [_lbTagName setNumberOfLines:1];
    [_lbTagName.layer setCornerRadius:4.0f];
    [_lbTagName setLineBreakMode:NSLineBreakByTruncatingTail];
    [_lbTagName setUserInteractionEnabled:YES];
    [_viewSelBKG addSubview:_lbTagName];
    RELEASE(_lbTagName);
    
    CGFloat width = [_lbTagName.text sizeWithFont:_lbTagName.font].width+46;
    [_lbTagName setFrame:CGRectMake(CGRectGetMinX(_lbTagName.frame), CGRectGetMinY(_lbTagName.frame), width, CGRectGetHeight(_lbTagName.frame))];
    
    UIImage *imgDel = [UIImage imageNamed:@"tag_close.png"];
    MagicUIButton *_btnDel = [[MagicUIButton alloc] initWithFrame:CGRectMake([_lbTagName.text sizeWithFont:_lbTagName.font].width+23, 8, 13, 13)];
    [_btnDel setImage:imgDel forState:UIControlStateNormal];
    [_btnDel setBackgroundColor:[UIColor clearColor]];
    [_btnDel addSignal:[DYBListSelViewController DELTAG] forControlEvents:UIControlEventTouchUpInside];
    [_btnDel setTag:[addTag.tag_id intValue]];
    [_lbTagName addSubview:_btnDel];
    RELEASE(_btnDel);
    
    [_lbTagName setText:[NSString stringWithFormat:@"  %@", addTag.tag]]; //文本显示往左偏移点
    
    
    if (CGRectGetMaxX(_lbTagName.frame) > self.view.frame.size.width) {
        [_viewSelBKG setContentSize:CGSizeMake(CGRectGetMaxX(_lbTagName.frame)+8, 70)];
        [_viewSelBKG setContentOffset:CGPointMake(CGRectGetMinX(_lbTagName.frame)-160, 0)];
        [_viewSelBKG setScrollEnabled:YES];
    }else{
        [_viewSelBKG setContentSize:CGSizeMake(self.view.frame.size.width, 70)];
        [_viewSelBKG setContentOffset:CGPointMake(0, 0)];
        [_viewSelBKG setScrollEnabled:NO];
    }
    
    [_lineView setFrame:CGRectMake(0, CGRectGetMinY(_lineView.frame), CGRectGetWidth(_viewSelBKG.frame), .5f)];
    
}

#pragma mark- 接受其他信号
- (void)handleViewSignal_DYBListSelViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBListSelViewController DELTAG]]){
        MagicUIButton *btn = (MagicUIButton *)signal.source;
        
        for (tag_list_info *tag in _arrayTagSelected) {
            if ([tag.tag_id intValue] == btn.tag) {
                
                for (int i = 0; i < [_arrayTagManage count]; i++) {
                    tag_list_info *tagA = [_arrayTagManage objectAtIndex:i];
                    
                    if ([tagA.tag_id isEqualToString:tag.tag_id]) {
                        DYBCellForTagManage *cell = [_arrayTagManageCell objectAtIndex:i];
                        [cell deColorCell];
                        break;
                    }
                }
    
                [_arrayTagSelected removeObject:tag];
                [_lbTagCount setText:[NSString stringWithFormat:@"%d/5", [_arrayTagSelected count]]];
                break;
            }
        }
        
        
        for (UIView *lb in _viewSelBKG.subviews) {
            if ([lb isKindOfClass:[MagicUILabel class]]) {
                [lb removeFromSuperview];
            }
        }
        
        for (tag_list_info *tag in _arrayTagSelected) {
            [self AddSelectedTag:tag];
        }
    }
}

#pragma mark- 标签排序算法
NSInteger DYBSortTagList(id tinfo1, id tinfo2, void *context)
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

#pragma mark- 消息返回处理
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{
    
    [self.view setUserInteractionEnabled:YES];
    
    if ([request succeed]){
        if (request.tag == -1){/*初始化*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                _Tlist = [tag_list JSONReflection:respose.data];
                
                if ([_arrayTagManage count] > 0) {
                    [_arrayTagManage removeAllObjects];
                    [_arrayTagManageCell removeAllObjects];
                }
                
                for (NSDictionary *dic in _Tlist.result) {
                    tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
                    [_arrayTagManage addObject:(tag_list_info *)_tlInfo];
                }
                
                [_arrayTagManage sortUsingFunction:DYBSortTagList context:NULL];
                
                if ([_Tlist.havenext isEqualToString:@"1"]) {
                    [_tabTagManage reloadData:NO];
                }else{
                    [_tabTagManage reloadData:YES];
                }
                
                [_Tlist retain];
                
                if (_arrayTagSelected && [_arrayTagSelected count] > 0) {
                    for (tag_list_info *tag in _arrayTagSelected) {
                        [self AddSelectedTag:tag];
                        
                        for (int i = 0; i < [_arrayTagManage count]; i++) {
                            tag_list_info *tagA = [_arrayTagManage objectAtIndex:i];
                            
                            if ([tagA.tag_id isEqualToString:tag.tag_id]) {
                                DYBCellForTagManage *cell = [_arrayTagManageCell objectAtIndex:i];
                                [cell reColorCell];
                                break;
                            }
                        }
                    }
                }

            }
        }else if (request.tag == -2){
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                tag_list *tMorelist = [tag_list JSONReflection:respose.data];
                
                for (NSDictionary *dic in tMorelist.result) {
                    tag_list_info *_tlInfo = [tag_list_info JSONReflection:dic];
                    [_arrayTagManage addObject:(tag_list_info *)_tlInfo];
                }
                
                [_arrayTagManage sortUsingFunction:DYBSortTagList context:NULL];
                
                if ([tMorelist.havenext isEqualToString:@"1"]) {
                    [_tabTagManage reloadData:NO];
                }else{
                    [_tabTagManage reloadData:YES];
                }
                
            }
            
        }else if (request.tag == -6){/*新建Tag*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                DLogInfo(@"respose.data == %@", [respose.data objectForKey:@"result"]);
                int nResult = [[respose.data objectForKey:@"result"] intValue];
                if (nResult == 1) {
                    
                    tag_list_info *_tlInfo = [[[tag_list_info alloc] init] autorelease];
                    _tlInfo.count = @"0";
                    _tlInfo.tag = _strNewTag;
                    _tlInfo.tag_id = [respose.data objectForKey:@"tag_id"];
                    _tlInfo.sys = @"1";
                    
                    NSDictionary *dic = [[[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"count", _strNewTag, @"tag", [respose.data objectForKey:@"tag_id"], @"tag_id", @"1", @"sys", nil] autorelease];
                    
                    [((NSMutableArray *)_Tlist.result) addObject:dic];
                    [_arrayTagManage addObject:(tag_list_info *)_tlInfo];
                    [_arrayTagManage sortUsingFunction:DYBSortTagList context:NULL];
                    
                    [_arrayTagManageCell removeAllObjects];
                    
                    if ([_Tlist.havenext isEqualToString:@"1"]) {
                        [_tabTagManage reloadData:NO];
                    }else{
                        [_tabTagManage reloadData:YES];
                    }
                    
                    if (_arrayTagSelected && [_arrayTagSelected count] > 0) {
                        for (tag_list_info *tag in _arrayTagSelected) {
                            [self AddSelectedTag:tag];
                            
                            for (int i = 0; i < [_arrayTagManage count]; i++) {
                                tag_list_info *tagA = [_arrayTagManage objectAtIndex:i];
                                
                                if ([tagA.tag_id isEqualToString:tag.tag_id]) {
                                    DYBCellForTagManage *cell = [_arrayTagManageCell objectAtIndex:i];
                                    [cell reColorCell];
                                    break;
                                }
                            }
                        }
                    }
                    
                }else{
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"新建失败，请稍后再试。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
                }
            }
        }
    }else if ([request failed]){
        [self.view setUserInteractionEnabled:YES];
        
        
    }
}

@end
