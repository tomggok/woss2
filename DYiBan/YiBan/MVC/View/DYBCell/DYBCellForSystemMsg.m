//
//  DYBCellForSystemMsg.m
//  DYiBan
//
//  Created by zhangchao on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForSystemMsg.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "UIImageView+WebCache.h"
#import "UITableView+property.h"
#import "DYBSystemMsgViewController.h"

@implementation DYBCellForSystemMsg

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, tbv._cellH)];
    if (data) {
        model=data;
        
        if (!_imgV_showImg) {
            _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15,10, 50,50) backgroundColor:[UIColor clearColor] image:_imgV_showImg.image isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            _imgV_showImg.needRadius=YES;
            RELEASE(_imgV_showImg);
            
            [_imgV_showImg setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserWithGesture:)];
            [_imgV_showImg addGestureRecognizer:tapGestureRecognizer];
            
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
            _lb_nickName=[[MagicUILabel alloc]initWithFrame:CGRectMake(_imgV_showImg.frame.origin.x+_imgV_showImg.frame.size.width+10, 5, 0, 0)];
            _lb_nickName.backgroundColor=[UIColor clearColor];
            _lb_nickName.textAlignment=NSTextAlignmentLeft;
            _lb_nickName.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
            _lb_nickName.text=model.user_info.name;
            [_lb_nickName setNeedCoretext:NO];
            _lb_nickName.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
            _lb_nickName.numberOfLines=0;
            
            _lb_nickName.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_nickName sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_nickName.frame.origin.x, 100)];
            
            [self addSubview:_lb_nickName];
            
            [_lb_nickName changePosInSuperViewWithAlignment:1];
            [_lb_nickName setFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_nickName.frame.origin.y-5, _lb_nickName.frame.size.width, _lb_nickName.frame.size.height)];

            RELEASE(_lb_nickName);
        }
        
        if (!_lb_time) {
            _lb_time=[[MagicUILabel alloc]initWithFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_nickName.frame.origin.y+_lb_nickName.frame.size.height+3, 0, 0)];
            _lb_time.backgroundColor=[UIColor clearColor];
            _lb_time.textAlignment=NSTextAlignmentLeft;
            _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
            if ([model.kind isEqualToString:@"118"]) {
                _lb_time.text=model.content;
                _lb_time.numberOfLines=0;
            }else{
                _lb_time.text=[NSString stringWithFormat:@"%@ %@",[NSString transFormTimeStamp:model.time],(([model.kind isEqualToString:@"1"])?(@"申请成为你的好友"):(@"已同意您的好友请求")/*kind : 消息类型 1 为加好友请求 2 已同意请求*/)];
                _lb_time.numberOfLines=1;
            }
            
            [_lb_time setNeedCoretext:NO];
            _lb_time.textColor=(([model.kind isEqualToString:@"1"]))?([MagicCommentMethod colorWithHex:@"0xde341a"]):([MagicCommentMethod color:170 green:170 blue:170 alpha:1])  ;
            
            _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_time.frame.origin.x-20, 1000)];
            
            [self addSubview:_lb_time];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_time);
            
            if (CGRectGetMaxY(_lb_time.frame)>CGRectGetHeight(self.frame)) {
                [self setFrame:CGRectMake(0, 0, self.frame.size.width, CGRectGetMaxY(_lb_time.frame)+10)];
                
//                {//分割线
//                    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-1), self.frame.size.width, 0.5)];
//                    [v setBackgroundColor:ColorDivLine];
//                    [self addSubview:v];
//                    RELEASE(v);
//                }
            }
        }
        
        if ([model.kind isEqualToString:@"1"]) {//申请成为你的好友
            if (!_bt_ignore) {
//                UIImage *img= [UIImage imageNamed:@"noinfo.png"];
                _bt_ignore = [[MagicUIButton alloc] initWithFrame:CGRectMake(_lb_time.frame.origin.x, _lb_time.frame.origin.y+_lb_time.frame.size.height+15, 100, 30)];
                _bt_ignore.tag=0;
                [_bt_ignore addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[[NSDictionary dictionaryWithObjectsAndKeys:model.user_info.userid, @"userId",nil] retain]];
//                [_bt_noInfo setBackgroundImage:img forState:UIControlStateNormal];
                [_bt_ignore setTitle:@"忽略"];
                [_bt_ignore setTitleColor:[MagicCommentMethod colorWithHex:@"0x999999"]];
                [_bt_ignore setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:15]];
                _bt_ignore.layer.masksToBounds=YES;
                _bt_ignore.layer.cornerRadius=6;
                _bt_ignore.backgroundColor=[MagicCommentMethod colorWithHex:@"0xeeeeee"];
                [self addSubview:_bt_ignore];
//                [_bt_noInfo changePosInSuperViewWithAlignment:2];
                RELEASE(_bt_ignore);
            }
            
            if (!_bt_agree) {
                //                UIImage *img= [UIImage imageNamed:@"noinfo.png"];
                _bt_agree = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_ignore.frame.origin.x+_bt_ignore.frame.size.width+20, _bt_ignore.frame.origin.y, _bt_ignore.frame.size.width, _bt_ignore.frame.size.height)];
                _bt_agree.tag=1;
                [_bt_agree addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[[NSDictionary dictionaryWithObjectsAndKeys:model.user_info.userid, @"userId",nil] retain]];
                //                [_bt_noInfo setBackgroundImage:img forState:UIControlStateNormal];
                [_bt_agree setTitle:@"同意"];
                [_bt_agree setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:15]];
                [_bt_agree setTitleColor:[UIColor whiteColor]];
                _bt_agree.layer.masksToBounds=YES;
                _bt_agree.layer.cornerRadius=6;
                _bt_agree.backgroundColor=ColorBlue;
                [self addSubview:_bt_agree];
                //                [_bt_noInfo changePosInSuperViewWithAlignment:2];
                RELEASE(_bt_agree);
            }
            
            [self setFrame:CGRectMake(0, 0, self.frame.size.width, /*_bt_agree.frame.origin.y+_bt_agree.frame.size.height+15*/ 120)];

        }else{//已同意您的好友请求
//            if (!_lb_newContent) {
//                _lb_newContent=[[MagicUILabel alloc]initWithFrame:CGRectMake(_lb_time.frame.origin.x, _lb_time.frame.origin.y+_lb_time.frame.size.height+5, 0,0)];
//                _lb_newContent.backgroundColor=[UIColor clearColor];
//                _lb_newContent.textAlignment=NSTextAlignmentLeft;
//                _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
////                _lb_newContent._constrainedSize=CGSizeMake(self.frame.size.width-_lb_newContent.frame.origin.x-10, 1000);
//                _lb_newContent.text=model.content;//内容里有[大笑]字符的借鉴老易班里的review_ControllerView类的heightForRowAtIndexPath方法
//                _lb_newContent.textColor=[UIColor blackColor];
//                _lb_newContent.numberOfLines=0;
//                
//                _lb_newContent.lineBreakMode=NSLineBreakByWordWrapping;
//                [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(screenShows.size.width-20, 100)];
//                
//                [self addSubview:_lb_newContent];
//                [_lb_newContent setNeedCoretext:NO];
//                
//                //        [_lb_nickName changePosInSuperViewWithAlignment:1];
//                RELEASE(_lb_newContent);
//                
//                [self setFrame:CGRectMake(0, 0, self.frame.size.width, _lb_newContent.frame.origin.y+_lb_newContent.frame.size.height+5)];
//
//            }
        }
        
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

- (void)didTapUserWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
        DLogInfo(@"%d", tappedView.tag);
        
        NSDictionary *dicUser = [[NSDictionary alloc] initWithObjectsAndKeys:model.user_info.userid, @"userid", model.user_info.name, @"username", nil];
        [self sendViewSignal:[DYBSystemMsgViewController PERSONALPAGE] withObject:[dicUser retain]];
        RELEASE(dicUser);
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

@end
