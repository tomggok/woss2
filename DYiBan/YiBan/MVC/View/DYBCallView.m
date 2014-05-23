//
//  DYBCallView.m
//  DYiBan
//
//  Created by zhangchao on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCallView.h"
#import "NSString+Count.h"
#import "UIImageView+WebCache.h"
#import "UIView+MagicCategory.h"

@implementation DYBCallView

- (id)initWithFrame:(CGRect)frame model:(friends *)model superV:(UIView *)superV
{
    self = [super initWithFrame:frame];
    if (self) {//初始化 子视图
        
//        friends *model=(friends *)signal.object;

        {//头像
            MagicUIImageView *_imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0,15, 50,50) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:0 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            _imgV_showImg.needRadius=YES;
            RELEASE(_imgV_showImg);
            
            NSString *encondeUrl= [model.pic stringByAddingPercentEscapesUsingEncoding];//把str里的 "" ,‘:’, ‘/’, ‘%’, ‘#’, ‘;’, and ‘@’. Note that ‘%’转成 UTF-8. 避免服务器发的url里有这些特殊字符从而导致 ([NSURL URLWithString:encondeUrl] == nil)
            
            if ([NSURL URLWithString:encondeUrl] == nil) {
                [_imgV_showImg setImage:[UIImage imageNamed:@"no_pic.png"]];
            }else
            {
                _imgV_showImg._b_isShade=NO;
                [_imgV_showImg setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic.png"]];
            }
            
//            {//圆形遮盖
//                UIImage *img=[UIImage imageNamed:@"midface_mask_def"];
//                MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_imgV_showImg Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
//                RELEASE(imgV);
//            }
            
            {//昵称
                MagicUILabel *_lb_nickName=[[MagicUILabel alloc]initWithFrame:CGRectMake(0, _imgV_showImg.frame.origin.y+_imgV_showImg.frame.size.height+10, 0, 0)];
                _lb_nickName.backgroundColor=[UIColor clearColor];
                _lb_nickName.textAlignment=NSTextAlignmentLeft;
                _lb_nickName.font=[DYBShareinstaceDelegate DYBFoutStyle:20];
                _lb_nickName.text=model.name;
                [_lb_nickName setNeedCoretext:NO];
                _lb_nickName.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
                _lb_nickName.numberOfLines=1;
                _lb_nickName.lineBreakMode=NSLineBreakByTruncatingTail;
                [_lb_nickName sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_nickName.frame.origin.x, 1000)];
                [self addSubview:_lb_nickName];
                [_lb_nickName changePosInSuperViewWithAlignment:0];
                //                                    [_lb_nickName setFrame:CGRectMake(_lb_nickName.frame.origin.x, _imgV_showImg.center.y-_lb_nickName.frame.size.height/2, _lb_nickName.frame.size.width, _lb_nickName.frame.size.height)];
                RELEASE(_lb_nickName);
                
                {//电话号
                    MagicUILabel *_lb_number=[[MagicUILabel alloc]initWithFrame:CGRectMake(0, _lb_nickName.frame.origin.y+_lb_nickName.frame.size.height+30, /*self.frame.size.width-_lb_nickName.frame.origin.x-80, _lb_nickName.frame.size.height*/ 0,0)];
                    _lb_number.backgroundColor=[UIColor clearColor];
                    _lb_number.textAlignment=NSTextAlignmentCenter;
                    _lb_number.font=[DYBShareinstaceDelegate DYBFoutStyle:40];
                    NSMutableString *phone=[NSMutableString stringWithString:model.phone];
                    if (phone.length>=11) {
                        [phone insertString:@" " atIndex:3];
                        [phone insertString:@" " atIndex:8];
                    }
                    
                    _lb_number.text=phone;
                    _lb_number.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
                    _lb_number.numberOfLines=1;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
                    
                    _lb_number.lineBreakMode=NSLineBreakByTruncatingTail;
                    [_lb_number sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_number.frame.origin.x-10, 1000)];
                    
                    [self addSubview:_lb_number];
                    [_lb_number setNeedCoretext:NO];
                    
                    [_lb_number changePosInSuperViewWithAlignment:0];
                    RELEASE(_lb_number);
                }
                
            }
        }
        
        {//底部BT
            {//取消
                UIImage *img= [UIImage imageNamed:@"btn_call_no_def"];
                MagicUIButton *_bt_cancel = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-img.size.height/2,img.size.width/2, img.size.height/2)];
                _bt_cancel.tag=k_tag_bt_cancelViews;
                //                                    _bt_cancelViews.backgroundColor=[UIColor blackColor];//self.headview.backgroundColor;
                //                                    _bt_cancelViews.alpha=0;
                [_bt_cancel addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                [_bt_cancel setImage:img forState:UIControlStateNormal];
                [_bt_cancel setImage:[UIImage imageNamed:@"btn_call_no_high"] forState:UIControlStateHighlighted];
                //                        [_bt_DropDown setTitle:@"好友"];
                //                        [_bt_DropDown setTitleColor:[UIColor blackColor]];
                //                        [_bt_DropDown setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
                [self addSubview:_bt_cancel];
                //                        [_bt_DropDown changePosInSuperViewWithAlignment:2];
                RELEASE(_bt_cancel);
            }
            
            {//确认
                UIImage *img= [UIImage imageNamed:@"btn_call_yes_def"];
                MagicUIButton *_bt_yes = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height-img.size.height/2,img.size.width/2, img.size.height/2)];
                _bt_yes.tag=k_tag_bt_ensurelViews;
                //                                    _bt_cancelViews.backgroundColor=[UIColor blackColor];//self.headview.backgroundColor;
                //                                    _bt_cancelViews.alpha=0;
                [_bt_yes addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:model.phone];
                [_bt_yes setImage:img forState:UIControlStateNormal];
                [_bt_yes setImage:[UIImage imageNamed:@"btn_call_yes_high"] forState:UIControlStateHighlighted];
                //                        [_bt_DropDown setTitle:@"好友"];
                //                        [_bt_DropDown setTitleColor:[UIColor blackColor]];
                //                        [_bt_DropDown setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
                [self addSubview:_bt_yes];
                //                        [_bt_DropDown changePosInSuperViewWithAlignment:2];
                RELEASE(_bt_yes);
            }
        }
    
            if (!_bt_cancelViews) {
                //            UIImage *img= [UIImage imageNamed:@"btn_mainmenu_default"];
                _bt_cancelViews = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0,superV.frame.size.width, superV.frame.size.height)];
                _bt_cancelViews.tag=k_tag_bt_cancelViews;
                _bt_cancelViews.backgroundColor=[UIColor blackColor];//self.headview.backgroundColor;
                _bt_cancelViews.alpha=0;
                [_bt_cancelViews addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                //            [_bt_mayKnow setBackgroundImage:img forState:UIControlStateNormal];
                //                        //            [_bt_sendNotice setBackgroundImage:[UIImage imageNamed:@"btn_mainmenu_hilight"] forState:UIControlStateHighlighted];
                //                        [_bt_DropDown setTitle:@"好友"];
                //                        [_bt_DropDown setTitleColor:[UIColor blackColor]];
                //                        [_bt_DropDown setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
                [superV addSubview:_bt_cancelViews];
                //                        [_bt_DropDown changePosInSuperViewWithAlignment:2];
                RELEASE(_bt_cancelViews);
            }
        
    }
    return self;
}



@end
