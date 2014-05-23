//
//  DYBCellForPrivateMsgList.m
//  DYiBan
//
//  Created by zhangchao on 13-8-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForPrivateMsgList.h"
#import "contact.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "UIImageView+WebCache.h"
#import "UITableView+property.h"
#import "UIView+Gesture.h"
#import "UITableViewCell+MagicCategory.h"
#import "DYBUITabbarViewController.h"
#import "Magic_Device.h"

@implementation DYBCellForPrivateMsgList

@synthesize v_UnreadMsgView=_v_UnreadMsgView;

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
//    self.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, tbv._cellH)];
    self.index=[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] retain];
//    self.clipsToBounds=YES;
    
    if (data) {
        contact *model=data;
        
        if (!_bt_delete) {
            UIImage *img= [UIImage imageNamed:@"msg_del_def"];
            _bt_delete = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-img.size.width/2, 0,img.size.width/2, img.size.height/2)];
            _bt_delete.tag=-7;
            _bt_delete.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
            //            _bt_DropDown.alpha=0.9;
            [_bt_delete addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
            [_bt_delete setImage:img forState:UIControlStateNormal];
            [_bt_delete setImage:[UIImage imageNamed:@"msg_del_press"] forState:UIControlStateHighlighted];
            //            [_bt_delete setTitle:@"删除"];
            //            [_bt_delete setTitleColor:[UIColor blackColor]];
            //            [_bt_delete setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
            //            [_bt_delete setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
            [self addSubview:_bt_delete];
            [_bt_delete changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_delete);
            _bt_delete.hidden=YES;
            
            {
                UIView *v_line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, CGRectGetHeight(_bt_delete.frame))];
                v_line.backgroundColor=ColorDivLine;
                [_bt_delete addSubview:v_line];
                RELEASE(v_line);
            }
        }
        
        if (!_v_toBeSlidingView) {
            _v_toBeSlidingView=[[UIView alloc]initWithFrame:self.bounds];
            _v_toBeSlidingView._originFrame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            _v_toBeSlidingView.backgroundColor=tbv.backgroundColor;
            [self addSubview:_v_toBeSlidingView];
            RELEASE(_v_toBeSlidingView);
            
            [self addSignal:[UIView PAN] object:[NSDictionary dictionaryWithObjectsAndKeys:tbv,@"tbv",[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],@"indexPath", nil] target:self];
            [self addSignal:[UIView TAP] object:[NSDictionary dictionaryWithObjectsAndKeys:tbv,@"tbv",[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],@"indexPath", nil] target:self];//此句执行完后,self.retainCount=3
//
        }
        
        if (!_imgV_showImg) {
            _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15,0, 50,50) backgroundColor:[UIColor clearColor] image:_imgV_showImg.image isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            [_imgV_showImg setNeedRadius:YES];
            RELEASE(_imgV_showImg);
            
            [_imgV_showImg setImgWithUrl:model.user_info.pic defaultImg:no_pic_50];

        }
        
    if (!_lb_nickName) {
        _lb_nickName=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_imgV_showImg.frame.origin.x+_imgV_showImg.frame.size.width+10, 10, 0, 0)];
        _lb_nickName.backgroundColor=[UIColor clearColor];
        _lb_nickName.textAlignment=NSTextAlignmentLeft;
        _lb_nickName.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
//        _lb_nickName._constrainedSize=CGSizeMake(screenShows.size.width-20, 100);
        _lb_nickName.text=model.user_info.name;
        [_lb_nickName setNeedCoretext:NO];
        _lb_nickName.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
        _lb_nickName.numberOfLines=1;
        
        _lb_nickName.lineBreakMode=NSLineBreakByTruncatingTail;
        [_lb_nickName sizeToFitByconstrainedSize:CGSizeMake(screenShows.size.width-_lb_nickName.frame.origin.x-60, 100)];
        
        [_v_toBeSlidingView addSubview:_lb_nickName];
        
        [_lb_nickName changePosInSuperViewWithAlignment:1];
        [_lb_nickName setFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_nickName.frame.origin.y-10, _lb_nickName.frame.size.width, _lb_nickName.frame.size.height)];
        RELEASE(_lb_nickName);
    }
        
        if (!_lb_newContent) {
            _lb_newContent=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_nickName.frame.origin.y+_lb_nickName.frame.size.height+3, 180, _lb_nickName.frame.size.height-10)];
            _lb_newContent.backgroundColor=[UIColor clearColor];
            _lb_newContent.textAlignment=NSTextAlignmentLeft;
            _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
            _lb_newContent.text=/*@"[敲打][敲打][难过][敲打]带我去打网球地区温度我带我去的[难过][难过][难过][难过][难过][敲打][敲打][难过][敲打]";// @"dqdqwdqwdwqdwqdqdwqdqwdqdwqdqwdqwdqwdqwdwqdwqd"; //*/  model.content;
            _lb_newContent.textColor=(model.view==0)?(_lb_nickName.textColor):([MagicCommentMethod color:170 green:170 blue:170 alpha:1]);
//            [_lb_newContent sizeToFit];
            _lb_newContent.maxLineNum=1;//只一行
            [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(175, 40)];
            _lb_newContent.lineBreakMode=NSLineBreakByCharWrapping;
            [_lb_newContent setImgType:-1];
            [_lb_newContent replaceEmojiandTarget:NO];
            
            if (![NSString isContainsEmoji:_lb_newContent.text]) {
                [_lb_newContent setFrame:CGRectMake(CGRectGetMinX(_lb_newContent.frame), CGRectGetMinY(_lb_newContent.frame)+3, CGRectGetWidth(_lb_newContent.frame), CGRectGetHeight(_lb_newContent.frame))];
            }

            [_v_toBeSlidingView addSubview:_lb_newContent];
//            [_lb_newContent setNeedCoretext:YES];

            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_newContent);
        }
        
        if (!_v_UnreadMsgView && [model.new_message intValue]>0) {
            UIImage *img=[UIImage imageNamed:@"msgtip"];
            _v_UnreadMsgView=[[DYBUnreadMsgView alloc]initWithFrame:CGRectMake(self.frame.size.width-60, 15, 0, 0) img:img nums:model.new_message arrowDirect:-1];
            [_v_toBeSlidingView addSubview:_v_UnreadMsgView];
            RELEASE(_v_UnreadMsgView);
        }
        
        if (!_lb_time) {
            _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(self.frame.size.width-60, _lb_newContent.frame.origin.y+5, _v_UnreadMsgView.frame.size.width, _lb_newContent.frame.size.height)];
            _lb_time.backgroundColor=[UIColor clearColor];
            _lb_time.textAlignment=NSTextAlignmentLeft;
            _lb_time.font=_lb_newContent.font;
            _lb_time.text=[NSString transFormTimeStamp:[model.time intValue]];
            _lb_time.textColor=(model.view==0)?(_lb_newContent.textColor):([MagicCommentMethod color:170 green:170 blue:170 alpha:1]);
            _lb_time.numberOfLines=1;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
            _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
            [_v_toBeSlidingView addSubview:_lb_time];
            [_lb_time setNeedCoretext:NO];
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_time);
        }

    }
    
    {//分割线
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, (tbv._cellH-1), self.frame.size.width, 0.5)];
        [v setBackgroundColor:ColorDivLine];
        [self addSubview:v];
        RELEASE(v);
    }
    
    {//选中色
        UIView *v=[[UIView alloc]initWithFrame:self.bounds];
        v.backgroundColor=BKGGray;
        self.selectedBackgroundView=v;
        RELEASE(v);
    }
}

#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal{
    if ([signal is:[UIView PAN]]) {//拖动信号
        NSDictionary *d=(NSDictionary *)signal.object;
        UIPanGestureRecognizer *recognizer=[d objectForKey:@"sender"];
        
        {
            _bt_delete.hidden=NO;
            
            if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
                
                CGPoint translation = [(UIPanGestureRecognizer *)panRecognizer translationInView:self];//移动距离及方向 x>0:右移
                
                if (translation.x>0&& self.initialTouchPositionX!=0 &&CGRectEqualToRect(_v_toBeSlidingView.frame, _v_toBeSlidingView._originFrame) && !(((UITableView *)(self.superview))._selectIndex_now)/*避免 朝右拖动未关闭的cell时 把viewCon.view朝右拖动*/ ) {/*此cell是否是在未展开状态右划*/
                    
                    DYBUITabbarViewController *tabbar=[DYBUITabbarViewController sharedInstace];
                    [[tabbar getThreeview] oneViewSwipe:panRecognizer];
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
                        CGFloat panAmount = currentTouchPositionX - self.initialTouchPositionX;
                        self.initialTouchPositionX = currentTouchPositionX;
                        CGFloat minOriginX = -_bt_delete.frame.size.width - 30;
                        CGFloat maxOriginX = 0.;
                        CGFloat originX = CGRectGetMinX(_v_toBeSlidingView.frame) + panAmount;
                        originX = MIN(maxOriginX, originX);
                        originX = MAX(minOriginX, originX);
                        
                        if (originX>-_bt_delete.frame.size.width/*-17*/) {//
                            _v_toBeSlidingView.frame = CGRectMake(originX, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
                        }
                    }
                } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
                    [UIView animateWithDuration:0.3
                                          delay:0.
                                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                                     animations:^
                     {
                         _v_toBeSlidingView.frame = CGRectMake(((fabs(_v_toBeSlidingView.frame.origin.x)>_bt_delete.frame.size.width/2/*+17*/)?(-_bt_delete.frame.size.width/*-17*/):(0)), 0, CGRectGetWidth(_v_toBeSlidingView.bounds), CGRectGetHeight(_v_toBeSlidingView.bounds));
                     } completion:^(BOOL finished) {
                         UITableView *tbv=((UITableView *)(self.superview));
                         
                         if (_v_toBeSlidingView.frame.origin.x<0) {//此cell被展开
                                                          
                             //关闭上次展开的cell
                             if (tbv._selectIndex_now&&tbv._selectIndex_now!=self.index) {
                                 UITableViewCell *cell=[tbv._muA_differHeightCellView objectAtIndex:tbv._selectIndex_now.row];
                                 [cell resetContentView];
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
        
        UITableView *tbv=[d objectForKey:@"tbv"];
        
        //关闭上次展开的cell
        if (tbv._selectIndex_now) {
            if ([MagicDevice sysVersion]<6) {//IOS 6.0以下
                UITapGestureRecognizer *tap=[object objectForKey:@"sender"];
                CGPoint p=[tap locationInView:self];
                if (p.x>CGRectGetMinX(_bt_delete.frame) && p.y>CGRectGetMinY(_bt_delete.frame)) {
                    [_bt_delete didTouchUpInside];
                    return;
                }
            }
            UITableViewCell *cell=[tbv._muA_differHeightCellView objectAtIndex:tbv._selectIndex_now.row];
            [cell resetContentView];
            //            [tbv._selectIndex_now release];
            tbv._selectIndex_now=nil;
        }else{//选中cell
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tbv, @"tableView", [d objectForKey:@"indexPath"], @"indexPath", nil];
            [self sendViewSignal:[MagicUITableView TABLEDIDSELECT] withObject:dict];
        }
        
        [self resetContentView];
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
-(void)resetContentView
{
    if (_v_toBeSlidingView.frame.origin.x<0) {
        [UIView animateWithDuration:0.3
                              delay:0.
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             _v_toBeSlidingView.frame=_v_toBeSlidingView._originFrame;
         } completion:^(BOOL finished) {
             _bt_delete.hidden=YES;
         }];
    }
    
}

-(void)dealloc
{
//    [self removeAllSignal];
    
    [super dealloc];
}

@end
