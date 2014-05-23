//
//  DYBCellForCommentMe.m
//  DYiBan
//
//  Created by zhangchao on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForCommentMe.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "UIImageView+WebCache.h"
#import "mc.h"
#import "UITableView+property.h"
#import "UIView+Gesture.h"
#import "UITableViewCell+MagicCategory.h"
#import "Magic_Device.h"

@implementation DYBCellForCommentMe

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    self.index=[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] retain];
    
    if (data) {
        mc *model=data;
        
        if (!_bt_delete) {
            UIImage *img= [UIImage imageNamed:@"msg_del_def"];
            _bt_delete = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-img.size.width/2/*-15*/, 0,img.size.width/2, img.size.height/2)];
            _bt_delete.tag=-1;
            _bt_delete.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
            //            _bt_DropDown.alpha=0.9;
            [_bt_delete addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:model.id];
            [_bt_delete setImage:img forState:UIControlStateNormal];
            [_bt_delete setBackgroundImage:[UIImage imageNamed:@"msg_del_press"] forState:UIControlStateHighlighted];
//            [_bt_delete setTitle:@"删除"];
//            [_bt_delete setTitleColor:[UIColor blackColor]];
//            [_bt_delete setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
//            [_bt_delete setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
            [self addSubview:_bt_delete];
            [_bt_delete changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_delete);
            _bt_delete.hidden=YES;
        }
        
        if (!_v_toBeSlidingView) {
            _v_toBeSlidingView=[[UIView alloc]initWithFrame:self.bounds];
            _v_toBeSlidingView._originFrame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            _v_toBeSlidingView.backgroundColor=tbv.backgroundColor;
            [self addSubview:_v_toBeSlidingView];
            RELEASE(_v_toBeSlidingView);
            
            [self addSignal:[UIView PAN] object:[NSDictionary dictionaryWithObjectsAndKeys:tbv,@"tbv",[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],@"indexPath", nil]];
            [self addSignal:[UIView TAP] object:[NSDictionary dictionaryWithObjectsAndKeys:tbv,@"tbv",[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],@"indexPath", nil]];
            
        }
        
        if (!_imgV_showImg) {
            _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15,5, 50,50) backgroundColor:[UIColor clearColor] image:_imgV_showImg.image isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            _imgV_showImg.needRadius=YES;
            RELEASE(_imgV_showImg);
            
            [_imgV_showImg setImgWithUrl:model.user_info.pic defaultImg:no_pic_50];
            
//            NSString *encondeUrl= [model.user_info.pic stringByAddingPercentEscapesUsingEncoding];//把str里的 "" ,‘:’, ‘/’, ‘%’, ‘#’, ‘;’, and ‘@’. Note that ‘%’转成 UTF-8. 避免服务器发的url里有这些特殊字符从而导致 ([NSURL URLWithString:encondeUrl] == nil)
//            
//            if ([NSURL URLWithString:encondeUrl] == nil) {
//                [_imgV_showImg setImage:[UIImage imageNamed:@"no_pic.png"]];
//            }else
//            {
//                _imgV_showImg._b_isShade=NO;
//                [_imgV_showImg setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic.png"]];
//                
//            }
            
//            {//圆形遮盖
//                UIImage *img=[UIImage imageNamed:@"midface_mask_def"];
//                MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_imgV_showImg Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
//                RELEASE(imgV);
//            }
        }
        
        if (!_lb_nickName) {
            _lb_nickName=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_imgV_showImg.frame.origin.x+_imgV_showImg.frame.size.width+10, 15, 0, 0)];
            _lb_nickName.backgroundColor=[UIColor clearColor];
            _lb_nickName.textAlignment=NSTextAlignmentLeft;
            _lb_nickName.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
            _lb_nickName.text=model.user_info.name;
            [_lb_nickName setNeedCoretext:NO];
            _lb_nickName.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
            _lb_nickName.numberOfLines=1;
            
            _lb_nickName.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_nickName sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_nickName.frame.origin.x, 100)];
            
            [_v_toBeSlidingView addSubview:_lb_nickName];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_nickName);
        }
        
        if (!_lb_time) {
            _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_nickName.frame.origin.y+_lb_nickName.frame.size.height+5, 0, 0)];
            _lb_time.backgroundColor=[UIColor clearColor];
            _lb_time.textAlignment=NSTextAlignmentLeft;
            _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
//            _lb_time._constrainedSize=CGSizeMake(screenShows.size.width-20, 100);
            _lb_time.text=[NSString stringWithFormat:@"%@ 评论了我",[NSString transFormTimeStamp:model.time]];
            
            [_lb_time setNeedCoretext:NO];
            _lb_time.textColor=(model.view==0/*未读*/)?([MagicCommentMethod colorWithHex:@"0xde341a"]):([MagicCommentMethod colorWithHex:@"0xaaaaaa"]);
            _lb_time.numberOfLines=1;
            
            _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_time.frame.origin.x, 100)];
            
            [_v_toBeSlidingView addSubview:_lb_time];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_time);
        }
        
        if (!_v_bigContent) {
            _v_bigContent=[[UIView alloc]initWithFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_time.frame.origin.y+_lb_time.frame.size.height+10, 230, 0)];
            _v_bigContent.backgroundColor=BKGGray;
            _v_bigContent.layer.masksToBounds=YES;
            _v_bigContent.layer.cornerRadius=5;
            
            {
                UIImage *img=[UIImage imageNamed:@"icon_arrow_up"];
                MagicUIImageView *imgV_Arrow=[[MagicUIImageView alloc]initWithFrame:CGRectMake(_v_bigContent.frame.origin.x+20, _v_bigContent.frame.origin.y-img.size.height/2, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                RELEASE(imgV_Arrow);
            }
            
            [_v_toBeSlidingView addSubview:_v_bigContent];
            RELEASE(_v_bigContent);
        }
        
        if (!_lb_newContent) {
            _lb_newContent=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(10, 0, 0,0)];
            _lb_newContent.backgroundColor=[UIColor clearColor];
            _lb_newContent.textAlignment=NSTextAlignmentLeft;
            _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
            _lb_newContent.text=model.content;//内容里有[大笑]字符的借鉴老易班里的review_ControllerView类的heightForRowAtIndexPath方法
            _lb_newContent.textColor=(model.view==0/*未读*/)?([MagicCommentMethod colorWithHex:@"0x333333"]):([MagicCommentMethod colorWithHex:@"0xaaaaaa"]);
            _lb_newContent.numberOfLines=0;
            
            _lb_newContent.lineBreakMode=NSLineBreakByCharWrapping;
            [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(_v_bigContent.frame.size.width-10, 1000)];
            [_lb_newContent replaceEmojiandTarget:NO];

            [_v_bigContent setFrame:CGRectMake(_v_bigContent.frame.origin.x, _v_bigContent.frame.origin.y, _v_bigContent.frame.size.width, _lb_newContent.frame.size.height+20)];
            [_v_bigContent addSubview:_lb_newContent];
//            [_lb_newContent setNeedCoretext:YES];
            
            [_lb_newContent changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_newContent);
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, _v_bigContent.frame.origin.y+_v_bigContent.frame.size.height+15)];
        [_bt_delete changePosInSuperViewWithAlignment:1];
        [_v_toBeSlidingView setFrame:self.bounds];
        _v_toBeSlidingView._originFrame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        
        {//分割线
            UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-1), self.frame.size.width, 0.5)];
            [v setBackgroundColor:ColorDivLine];
            [self addSubview:v];
            RELEASE(v);
        }
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
                
                if (translation.x>0&& self.initialTouchPositionX!=0 &&CGRectEqualToRect(_v_toBeSlidingView.frame, _v_toBeSlidingView._originFrame) && !(((UITableView *)(self.superview))._selectIndex_now)/*避免 朝右拖动未关闭的cell时 把viewCon.view朝右拖动*/  ) {/*此cell是否是在未展开状态右划*/
                    
                    MagicViewController *con=(MagicViewController *)[self superCon];
                    [con.drNavigationController handleSwitchView:recognizer];
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
                        
                        if (originX>-_bt_delete.frame.size.width-17) {//
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
                         
                         if (_v_toBeSlidingView.frame.origin.x<0) {//此cell已展开
                             
                             //                     [recognizer removeTarget:self action:@selector(handlePan:)];
                             
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
        
        if ([MagicDevice sysVersion]<6) {
            UITapGestureRecognizer *tap=[object objectForKey:@"sender"];
            CGPoint p=[tap locationInView:self];
            if (p.x>CGRectGetMinX(_bt_delete.frame) && p.y>CGRectGetMinY(_bt_delete.frame)) {
                [_bt_delete didTouchUpInside];
                return;
            }
        }
        
        //关闭上次展开的cell
        if (tbv._selectIndex_now) {
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
        return fabs(translation.x)/*浮点数的绝对值*/ > fabs(translation.y);//如果是拖动手势,判断是否是 左右而不是上下拖
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
    [super dealloc];
}

@end
