//
//  DYBMenuBLueView.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBMenuBLueView.h"
#import "DYBPublishViewController.h"

@implementation DYBMenuBLueView

DEF_SIGNAL(SELCELL)

- (id)initWithFrame:(CGRect)frame menuArray:(NSArray *)arrMenu selectRow:(NSInteger)nSelRow cellType:(NSInteger)nCellType
{
    if ([arrMenu count] > 4) {
        self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame)-[arrMenu count]*45, 140, 190)];
    }else{
        self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame)-[arrMenu count]*45, 140, [arrMenu count]*45+10)];
    }
    
    if (self) {
        // Initialization code
        [self setBackgroundColor:ColorBlue];
        _arrMenu = [[NSArray alloc] initWithArray:arrMenu];
        _nSelRow = nSelRow;
        _nCellType = nCellType;
        
        CALayer *lay  = self.layer;//获取ImageView的层
        [lay setMasksToBounds:YES];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:5.0f];//值越大，角度越圆
        [self.layer setShadowOffset:CGSizeMake(3.0f, 3.0f)];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        
        
        _tableMenu = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) isNeedUpdate:NO];
        [_tableMenu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableMenu setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_tableMenu];
        RELEASE(_tableMenu);
    }
    return self;
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
        NSNumber *nRowHeight = [NSNumber numberWithInteger:45];
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
        
        if (_nCellType == 1) {
            MagicUIButton *btnCell = [[MagicUIButton alloc] initWithFrame:CGRectMake(10, 2.5, 120, 40)];
            [btnCell setBackgroundImage:nil forState:UIControlStateNormal];
            [btnCell setBackgroundImage:[UIImage imageNamed:@"btn_private_highlight.png"] forState:UIControlStateHighlighted];
            [btnCell setBackgroundColor:[UIColor clearColor]];
            [btnCell setTitle:[_arrMenu objectAtIndex:indexPath.row]];
            [btnCell setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [btnCell setTitleColor:ColorBlue forState:UIControlStateHighlighted];
            [btnCell setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
            [btnCell addSignal:[DYBMenuBLueView SELCELL] forControlEvents:UIControlEventTouchUpInside];
            [btnCell setTag:indexPath.row];
            [cell addSubview:btnCell];
            RELEASE(btnCell);
        }else{
            MagicUILabel *lbCell = [[MagicUILabel alloc] initWithFrame:CGRectMake(10, 2.5, 120, 40)];
            [lbCell setBackgroundColor:[UIColor clearColor]];
            [lbCell setText:[_arrMenu objectAtIndex:indexPath.row]];
            [lbCell setTextColor:[UIColor whiteColor]];
            [lbCell setFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
            [lbCell setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:lbCell];
            RELEASE(lbCell);
            
            CALayer *lay  = lbCell.layer;//获取ImageView的层
            [lay setMasksToBounds:YES];
            [lbCell.layer setMasksToBounds:YES];
            [lbCell.layer setCornerRadius:5.0f];//值越大，角度越圆
            [lbCell.layer setShadowOffset:CGSizeMake(3.0f, 3.0f)];
            [lbCell.layer setShadowColor:[UIColor blackColor].CGColor];
        }
  
        [signal setReturnValue:cell];
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        _nSelRow = indexPath.row;
        
        
        if (_nCellType != 1) {
            for (int i = 0; i < [_arrMenu count]; i++) {
                UITableViewCell *cell = [_tableMenu cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                for (UIView *view in cell.subviews) {
                    if ([view isKindOfClass:[MagicUILabel class]]) {
                        [(MagicUILabel *)view setBackgroundColor:[UIColor clearColor]];
                        [(MagicUILabel *)view setTextColor:[UIColor whiteColor]];
                    }
                }
            }
            
            UITableViewCell *cell = [_tableMenu cellForRowAtIndexPath:indexPath];
            [self selectCell:cell];
        }

         NSMutableDictionary *mutabledict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", indexPath.row], @"row", nil];
         [self sendViewSignal:[DYBPublishViewController PRIVATESELECT] withObject:mutabledict];
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
//        [_tableMenu tableViewDidDragging];
    }
}

-(void)selectCell:(UITableViewCell *)cell{
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:[MagicUILabel class]]) {
            [(MagicUILabel *)view setBackgroundColor:[UIColor whiteColor]];
            [(MagicUILabel *)view setTextColor:ColorBlue];
        }
    }
}

#pragma mark- 接受其他信号
- (void)handleViewSignal_DYBMenuBLueView:(MagicViewSignal *)signal
{
    if ([signal is:[DYBMenuBLueView SELCELL]]){
      MagicUIButton *bt=(MagicUIButton *)signal.source;
        NSMutableDictionary *mutabledict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", bt.tag], @"row", nil];
        [self sendViewSignal:[DYBPublishViewController PRIVATESELECT] withObject:mutabledict];
    }
}


@end
