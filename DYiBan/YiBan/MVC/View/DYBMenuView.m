//
//  DYBMenuView.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-29.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBMenuView.h"
#import "DYBDynamicViewController.h"
#import "UIView+MagicCategory.h"
#import "DYBDataBankShareViewController.h"
#import "DYBDataBankDownloadManageViewController.h"
#import "DYBDataBankSearchViewController.h"

@implementation DYBMenuView

DEF_SIGNAL(MENUDOWN)
DEF_SIGNAL(MENUSHRINK)
DEF_SIGNAL(MENUSELECTCELL)

@synthesize bPullDown=_bPullDown,row=_row,arrMenu=_arrMenu,sendTargetObj = _sendTargetObj;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithData:(NSArray *)arrMenu selectRow:(NSInteger)nRow{
    if ([arrMenu count] > 3) {
        self = [super initWithFrame:CGRectMake(0, 44-[arrMenu count]*60, 320, 210+4)];
    }else{
        self = [super initWithFrame:CGRectMake(0, 44-[arrMenu count]*60, 320, [arrMenu count]*60+4)];
    }
    
    if (self) {
        // Initialization code
        _arrMenu = [[NSArray alloc] initWithArray:arrMenu];
        _arrSignal = [[NSArray alloc] initWithObjects: nil];  
        bDown = YES;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAlpha:0.9f];
        
        _tableMenu = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) isNeedUpdate:NO];
        [_tableMenu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableMenu setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_tableMenu];
        RELEASE(_tableMenu);
        
        nSelRow = nRow;
        _row=nSelRow;

        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:nSelRow inSection:0];
        [_tableMenu selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
        UITableViewCell *cell = [_tableMenu cellForRowAtIndexPath:indexPath];
        [self selectCell:cell];
        
        UIImage *img = [UIImage imageNamed:@"slide_shadow.png"];
        MagicUIImageView *imgLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 4)];
        [imgLine setBackgroundColor:[UIColor clearColor]];
        [imgLine setImage:img];
        [self addSubview:imgLine];
        RELEASE(imgLine);
        
    }
    return self;
}

-(void)changeArrowStatus:(BOOL)key{
    

    [((DYBBaseViewController *)[self  superCon]).headview setTitleArrowStatus:key];
    
}

- (void)handleViewSignal_DYBMenuView:(MagicViewSignal *)signal{
    if ([signal is:[DYBMenuView MENUDOWN]]){
        DYBBaseViewController *vc = (DYBBaseViewController *)[signal object];
        bDown = YES;
        
        [self setHidden:NO];
        [self setAlpha:0];
        
        [self setFrame:CGRectMake(0, 44-CGRectGetHeight(self.frame), 320, 60)];
        
        float fHeight = [_arrMenu count]*60+4;
        
        if (fHeight > 214) {
            fHeight = 214;
        }
        
        [vc.headview setTitleArrowStatus:YES];

        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.5f];
        [vc.view bringSubviewToFront:vc.headview];
        [self setFrame:CGRectMake(0, 44, 320, fHeight)];
        [self setAlpha:0.9];
        [UIView commitAnimations];

        _bPullDown=!_bPullDown;
    }else if ([signal is:[DYBMenuView MENUSHRINK]]){
        DYBBaseViewController *vc = (DYBBaseViewController *)[signal object];
        bDown = NO;
 
        [self setHidden:NO];
        [self setFrame:CGRectMake(0, 44, 320, CGRectGetHeight(self.frame))];
        
        [vc.headview setTitleArrowStatus:NO];

        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.5f];
        [vc.view bringSubviewToFront:vc.headview];
        [self setFrame:CGRectMake(0, 44-CGRectGetHeight(self.frame), 320, 60)];
        [self setAlpha:0];
        [UIView commitAnimations];
        
//        [self performSelector:@selector(HiddenMenu) withObject:nil afterDelay:0.5f];
        
        _bPullDown=!_bPullDown;
    }
}


- (void)HiddenMenu{
    [self setHidden:YES];
}

#pragma mark- 只接受UITableView信号
- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        NSNumber *nRow = [NSNumber numberWithInteger:[_arrMenu count]];
        [signal setReturnValue:nRow];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *nSection = [NSNumber numberWithInteger:1];
        [signal setReturnValue:nSection];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        NSNumber *nRowHeight = [NSNumber numberWithInteger:60];
        [signal setReturnValue:nRowHeight];
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        [signal setReturnValue:nil];
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        [signal setReturnValue:nil];
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        static NSString *reuseIdentifier = @"reuseIdentifier";
        
        UITableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        if (!cell) {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }else{
            for (UIView *view  in [cell subviews]) {
                [view removeFromSuperview];
            }
        }
        

        
        MagicUIImageView *_BKGView = [[MagicUIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 290, 45)];
        [_BKGView setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:_BKGView];
        RELEASE(_BKGView);
        
        if (indexPath.row == nSelRow) {
            [_BKGView setImage:[UIImage imageNamed:@"bg_slidemenu.png"]];
        }
        
        MagicUILabel *_lbText = [[MagicUILabel alloc] initWithFrame:CGRectMake(10, 10, 270, 25)];
        [_lbText setFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
        [_lbText setBackgroundColor:[UIColor clearColor]];
        [_lbText setTextColor:ColorBlack];
        [_lbText setLineBreakMode:NSLineBreakByCharWrapping];
        [_lbText setText:[_arrMenu objectAtIndex:indexPath.row]];
        [_BKGView addSubview:_lbText];
        RELEASE(_lbText);
        
        if (nSelRow == indexPath.row) {
            [_lbText setTextColor:[UIColor whiteColor]];
        }
        
        [signal setReturnValue:cell];
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        nSelRow = indexPath.row;
        
        for (int i = 0; i < [_arrMenu count]; i++) {
             UITableViewCell *cell = [_tableMenu cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            for (UIView *view in cell.subviews) {
                if ([view isKindOfClass:[MagicUIImageView class]]) {
                    [(MagicUIImageView *)view setImage:nil];
                    
                    for (UIView *viewSub in view.subviews) {
                        if([viewSub isKindOfClass:[MagicUILabel class]]){
                            [(MagicUILabel *)viewSub setTextColor:ColorBlack];
                            break;
                        }
                    }
                }
            }
                
        }
        
        UITableViewCell *cell = [_tableMenu cellForRowAtIndexPath:indexPath];
        [self selectCell:cell];
        
        if (indexPath.row!=_row || _row==-1) {
            
            _row=indexPath.row;
            
            NSMutableDictionary *mutabledict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableview, @"tableView", [NSString stringWithFormat:@"%d", indexPath.row], @"section", nil];
            
            DLogInfo(@"controller --- %@",[self superCon]);
            
            if ([[self superCon] isKindOfClass:[DYBDataBankShareViewController class]]
                ||[[self superCon] isKindOfClass:[DYBDataBankDownloadManageViewController class]]
                ||[[self superCon] isKindOfClass:[DYBDataBankSearchViewController class]]) {
                
                [self sendViewSignal:[DYBMenuView MENUSELECTCELL] withObject:mutabledict from:self target:[self superCon]];
            }else{
                
                [self sendViewSignal:[DYBDynamicViewController MENUSELECT] withObject:mutabledict];
            }
            
        }else{//避免重复点某个cell
//            [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:nil from:self target:self];
            return;
        }
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
//        [_tableMenu tableViewDidDragging];
    }
}

-(void)selectCell:(UITableViewCell *)cell{
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:[MagicUIImageView class]]) {
            [(MagicUIImageView *)view setImage:[UIImage imageNamed:@"bg_slidemenu.png"]];
            
            for (UIView *viewSub in view.subviews) {
                if([viewSub isKindOfClass:[MagicUILabel class]]){
                    [(MagicUILabel *)viewSub setTextColor:[UIColor whiteColor]];
                    break;
                }
            }
        }
    }
}

- (void)dealloc
{
//    RELEASE(_sendTargetObj);
    [super dealloc];
}
@end
