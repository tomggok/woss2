//
//  DYBCellForTagManage.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForTagManage.h"
#import "UIView+MagicCategory.h"
#import "DYBUITabbarViewController.h"
#import "UITableView+property.h"
#import "UITableViewCell+MagicCategory.h"
#import "Magic_Device.h"
#import "DYBTagManageViewController.h"

@implementation DYBCellForTagManage

DEF_SIGNAL(DELTAG)

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    if (data){
        fHeight = 50.0f;
        fMaxMove = 80.0f;
        _tlinfo = data;
        self.index=[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] retain];
        
        _viewDelBKG = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-80, 0, 80, fHeight)];
        [_viewDelBKG setBackgroundColor:[UIColor whiteColor]];
        [_viewDelBKG setAlpha:0.0f];
        [self addSubview:_viewDelBKG];
        RELEASE(_viewDelBKG);
        
        UIImage *iconDel = [UIImage imageNamed:@"more_del.png"];
        _btnDelete = [[MagicUIButton alloc] initWithFrame:CGRectMake(10, 0, iconDel.size.width/2, iconDel.size.height/2)];
        [_btnDelete setBackgroundColor:[UIColor clearColor]];
        [_btnDelete setImage:iconDel forState:UIControlStateNormal];
        [_btnDelete addSignal:[DYBCellForTagManage DELTAG] forControlEvents:UIControlEventTouchUpInside];
        [_viewDelBKG addSubview:_btnDelete];
        RELEASE(_btnDelete);
        
        _viewCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), fHeight)];
        [_viewCover setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_viewCover];
        RELEASE(_viewCover);
        
        _lbTagName = [[MagicUILabel alloc] initWithFrame:CGRectMake(10, 11, 100, 30)];
        [_lbTagName setBackgroundColor:ColorBlue];
        [_lbTagName setTextAlignment:NSTextAlignmentCenter];
        [_lbTagName setFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
        [_lbTagName setText:_tlinfo.tag];
        [_lbTagName setTextColor:[UIColor whiteColor]];
        [_lbTagName setNumberOfLines:1];
        [_lbTagName.layer setCornerRadius:4.0f];
        [_lbTagName setLineBreakMode:NSLineBreakByTruncatingTail];
        [_viewCover addSubview:_lbTagName];
        RELEASE(_lbTagName);
        
        
        if ([_tlinfo.sys intValue] == 1) {
            UIImage *iconMore = [UIImage imageNamed:@"arrow_more.png"];
            MagicUIButton *btnMore = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-15-iconMore.size.width/2, (fHeight-iconMore.size.height/2)/2, iconMore.size.width/2, iconMore.size.height/2)];
            [btnMore setBackgroundColor:[UIColor clearColor]];
            [btnMore setImage:iconMore forState:UIControlStateNormal];
            [_viewCover addSubview:btnMore];
            RELEASE(btnMore);
        }

        
        CGFloat width = [_lbTagName.text sizeWithFont:_lbTagName.font].width+20;
        [_lbTagName setFrame:CGRectMake(CGRectGetMinX(_lbTagName.frame), CGRectGetMinY(_lbTagName.frame), width, CGRectGetHeight(_lbTagName.frame))];

        [self addSignal:[UIView PAN] object:[NSDictionary dictionaryWithObjectsAndKeys:tbv,@"tbv",[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],@"indexPath", nil] target:self];
        [self addSignal:[UIView TAP] object:[NSDictionary dictionaryWithObjectsAndKeys:tbv,@"tbv",[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],@"indexPath", nil] target:self];//此句执行完后,self.retainCount=3
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, fHeight-1, self.frame.size.width, .5f)];
        [lineView setBackgroundColor:ColorDivLine];
        [self addSubview:lineView];
        RELEASE(lineView);
        
        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), fHeight)];
    }
}


-(void)setContent:(id)data selected:(BOOL)bSelected indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    if (data){
        fHeight = 50.0f;
        fMaxMove = 80.0f;
        
        _tlinfo = data;
        self.index=[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] retain];
        
        _lbTagName = [[MagicUILabel alloc] initWithFrame:CGRectMake(10, 11, 100, 30)];
        [_lbTagName setTextAlignment:NSTextAlignmentCenter];
        [_lbTagName setFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
        [_lbTagName setText:_tlinfo.tag];
        [_lbTagName setTextColor:[UIColor whiteColor]];
        [_lbTagName setNumberOfLines:1];
        [_lbTagName.layer setCornerRadius:4.0f];
        [_lbTagName setLineBreakMode:NSLineBreakByTruncatingTail];
        [_lbTagName setUserInteractionEnabled:YES];
        [self addSubview:_lbTagName];
        RELEASE(_lbTagName);
        
        if (bSelected) {
            [_lbTagName setBackgroundColor:ColorGreen];
        }else{
            [_lbTagName setBackgroundColor:ColorBlue];
        }

        CGFloat width = [_lbTagName.text sizeWithFont:_lbTagName.font].width+20;
        [_lbTagName setFrame:CGRectMake(CGRectGetMinX(_lbTagName.frame), CGRectGetMinY(_lbTagName.frame), width, CGRectGetHeight(_lbTagName.frame))];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, fHeight-1, self.frame.size.width, .5f)];
        [lineView setBackgroundColor:ColorDivLine];
        [self addSubview:lineView];
        RELEASE(lineView);
        
        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), fHeight)];
    }
}

-(void)reColorCell{
    [_lbTagName setBackgroundColor:ColorGreen];
}

-(void)deColorCell{
    [_lbTagName setBackgroundColor:ColorBlue];
}

- (void)handleViewSignal_DYBCellForTagManage:(MagicViewSignal *)signal{
    if ([signal is:[DYBCellForTagManage DELTAG]]) {
        DLogInfo(@"DELTAG");
        [self sendViewSignal:[DYBTagManageViewController DELTAG] withObject:_tlinfo.tag_id];
    }
    
}

#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal{
    if ([signal is:[UIView PAN]]) {//拖动信号
        NSDictionary *d=(NSDictionary *)signal.object;
        UIPanGestureRecognizer *recognizer=[d objectForKey:@"sender"];
        
        {     
            if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;

                CGPoint translation = [(UIPanGestureRecognizer *)panRecognizer translationInView:self];//移动距离及方向 x>0:右移
                
                if (translation.x>0&& self.initialTouchPositionX!=0 &&CGRectEqualToRect(_viewCover.frame, CGRectMake(0, 0, CGRectGetWidth(self.frame), fHeight)) && !(((UITableView *)(self.superview))._selectIndex_now)) {
                    
                    DYBUITabbarViewController *tabbar=[DYBUITabbarViewController sharedInstace];
                    [[tabbar getThreeview] oneViewSwipe:panRecognizer];
                    return;
                }

                if([_tlinfo.sys intValue] != 1){
                    return;
                }
                
                
                CGPoint currentTouchPoint = [panRecognizer locationInView:self.contentView];
                CGFloat currentTouchPositionX = currentTouchPoint.x;
                
                if (recognizer.state == UIGestureRecognizerStateBegan) {
                    self.initialTouchPositionX = currentTouchPositionX;
                    
                } else if (recognizer.state == UIGestureRecognizerStateChanged) {
                    //            CGPoint velocity = [recognizer velocityInView:self.contentView];//滑动速度
                    //            if (!self.contextMenuHidden || (velocity.x > 0. /*|| [self.delegate shouldShowMenuOptionsViewInCell:self]*/))
                    {
                        if (self.selected) {
                            [self setSelected:NO animated:NO];
                        }
                        //                self.contextMenuView.hidden = NO;
                        CGFloat panAmount = currentTouchPositionX - self.initialTouchPositionX;//移动的距离(正负表示方向)
                        self.moveDir=panAmount;
                        self.initialTouchPositionX = currentTouchPositionX;
                        CGFloat minOriginX = fMaxMove;//能左移到的最左位置
                        CGFloat maxOriginX = 0.;
                        CGFloat originX = CGRectGetMinX(_viewCover.frame) + panAmount;//被移动的view当前的x
                        originX = MIN(maxOriginX, originX);
                        originX = MAX(minOriginX, originX);
                        
                        if (panAmount<0) {//向左移
                            if(fabs(originX)<fMaxMove){//被移动view.x左移到多少后就不左移了
                                _viewCover.frame = CGRectMake(originX, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
                            }
                        }else{//右移
                            if((originX)<0){//被移动view.x右移到多少后就不右移了
                                _viewCover.frame = CGRectMake(originX, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
                            }
                        }
                        
                    }
                } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
                    [UIView animateWithDuration:0.3
                                          delay:0.
                                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                                     animations:^
                     {
                         if (self.moveDir<0) {//左移
                             _viewDelBKG.alpha = 1;
                             
                             _viewCover.frame = CGRectMake(-fMaxMove, 0, CGRectGetWidth(_viewCover.bounds), CGRectGetHeight(_viewCover.bounds));
                         }else{//右移
                             
                             _viewDelBKG.alpha = 0;
                             
                             _viewCover.frame = CGRectMake(0, 0, CGRectGetWidth(_viewCover.bounds), CGRectGetHeight(_viewCover.bounds));
                         }
                         
                     } completion:^(BOOL finished) {
                         UITableView *tbv=((UITableView *)(self.superview));
                         
                         if (_viewCover.frame.origin.x<0) {//此cell被展开
                             
                             //关闭上次展开的cell
                             if (tbv._selectIndex_now&&tbv._selectIndex_now!=self.index&&tbv._selectIndex_now.row<[tbv._muA_differHeightCellView count]) {
                                 DYBCellForTagManage *cell=[tbv._muA_differHeightCellView objectAtIndex:tbv._selectIndex_now.row];
                                 [cell resetContentView:NO];
                             }
                             
                             tbv._selectIndex_now=self.index;
                             
                         }else if(tbv._selectIndex_now==self.index){//关闭上次展开的cell
                             UITableView *tbv=((UITableView *)(self.superview));
                             [tbv set_selectIndex_now:nil];
                             
                         }
                     }];
                }
            }
        }
        
    }else if ([signal is:[UIView TAP]]) {
        NSDictionary *object=(NSDictionary *)signal.object;
        
        NSDictionary *d=[object objectForKey:@"object"];
        
        switch (((UIView *)signal.source).tag) {//区分点击了cell还是点击cell里的 添加了TAP事件的子视图
            case 0://默认点击cell
            {
                UITableView *tbv=[d objectForKey:@"tbv"];
                
                if (tbv) {//点击tbv
                    
                    //关闭上次展开的cell
                    if (tbv._selectIndex_now) {
                        if ([MagicDevice sysVersion]<6) {
                            UITapGestureRecognizer *tap=[object objectForKey:@"sender"];
                            CGPoint p=[tap locationInView:self];
                            if (p.x>CGRectGetMinX(_btnDelete.frame) && p.y>CGRectGetMinY(_btnDelete.frame)) {
                                [_btnDelete didTouchUpInside];
                                return;
                            }
                        }
                        DYBCellForTagManage *cell=[tbv._muA_differHeightCellView objectAtIndex:tbv._selectIndex_now.row];
                        [cell resetContentView:YES];
                        //            [tbv._selectIndex_now release];
                        tbv._selectIndex_now=nil;
                    }else{//选中cell
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tbv, @"tableView", [d objectForKey:@"indexPath"], @"indexPath", nil];
                        [self sendViewSignal:[MagicUITableView TABLEDIDSELECT] withObject:dict];
                    }
                }
                
                
                [self resetContentView:YES];
            }
                break;
            case 1://点击了收藏视图
            {
                [self sendViewSignal:[UIView TAP] withObject:object from:signal.source target:[self superCon]];
                
            }
                break;
            default:
                break;
        }
        
    }
    
}

#pragma mark - UIPanGestureRecognizer delegate

//不重写这个,tbv的滚动手势就被UIPanGestureRecognizer的手势覆盖了
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x)/*浮点数的绝对值*/ > fabs(translation.y);
    }
    return YES;
}


//恢复正常视图布局
-(void)resetContentView:(BOOL)bTap;
{
    if (bTap) {
        _viewDelBKG.alpha = 0;
    }
    
    if (_viewCover.frame.origin.x<0) {
        [UIView animateWithDuration:0.3
                              delay:0.
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             _viewCover.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), fHeight);
         } completion:^(BOOL finished) {
             
             if (!bTap) {
                 _viewDelBKG.alpha = 0;
             }
         }];
    }
    
}
@end
