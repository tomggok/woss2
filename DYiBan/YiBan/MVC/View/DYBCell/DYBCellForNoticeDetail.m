//
//  DYBCellForNoticeDetail.m
//  DYiBan
//
//  Created by zhangchao on 13-9-20.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForNoticeDetail.h"
#import "DYBCustomLabel.h"
#import "status_notice_model.h"
#import "NSString+Count.h"
#import "UIView+MagicCategory.h"

@interface DYBCellForNoticeDetail ()
{
    MagicUIImageView *_imgV_showImg/*左边展示图*/,*_imgV_newMsgNums/*新消息数量图*/;
    DYBCustomLabel *_lb_newContent,*_lb_nickName,*_lb_time;
    UIView *_v_bigContent/*主要内容背景*/,*_v_toBeSlidingView/*要被滑动的view*/;
}
@end

@implementation DYBCellForNoticeDetail

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (data) {
        status_notice_model *model=data;
        
        if (!_imgV_showImg) {
            _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15,10, 50,50) backgroundColor:[UIColor clearColor] image:_imgV_showImg.image isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            _imgV_showImg.needRadius=YES;
            RELEASE(_imgV_showImg);
            
            [_imgV_showImg setImgWithUrl:model.status.user_info.pic defaultImg:no_pic_50];
        }
        
        if (!_lb_nickName) {
            _lb_nickName=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_imgV_showImg.frame.origin.x+_imgV_showImg.frame.size.width+10, 0, 0, 0)];
            _lb_nickName.backgroundColor=[UIColor clearColor];
            _lb_nickName.textAlignment=NSTextAlignmentLeft;
            _lb_nickName.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
            _lb_nickName.text=model.status.user_info.name;
            [_lb_nickName setNeedCoretext:NO];
            _lb_nickName.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
            _lb_nickName.numberOfLines=1;
            
            _lb_nickName.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_nickName sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_nickName.frame.origin.x, 100)];
            
            [self addSubview:_lb_nickName];
            _lb_nickName.center=CGPointMake(_lb_nickName.center.x, _imgV_showImg.center.y-5);
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_nickName);
        }
        
        if (!_lb_time) {
            _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_nickName.frame.origin.y+_lb_nickName.frame.size.height+5, 0, 0)];
            _lb_time.backgroundColor=[UIColor clearColor];
            _lb_time.textAlignment=NSTextAlignmentLeft;
            _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
            //            _lb_time._constrainedSize=CGSizeMake(screenShows.size.width-20, 100);
            _lb_time.text=[NSString stringWithFormat:@"%@",[NSString transFormTimeStamp:[model.status.time intValue]]/*,,*/];
            if (model.status.address) {
                _lb_time.text=[_lb_time.text stringByAppendingFormat:@" •%@",model.status.address];
            }
            if (model.status.from) {
                _lb_time.text=[_lb_time.text stringByAppendingFormat:@" •%@",model.status.from];
            }
            [_lb_time setNeedCoretext:NO];
            _lb_time.textColor=ColorGray;
            _lb_time.numberOfLines=1;
            
            _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_time.frame.origin.x, 100)];
            
            [self addSubview:_lb_time];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_time);
        }
        
        if (!_lb_newContent) {
            _lb_newContent=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_imgV_showImg.frame), CGRectGetMaxY(_imgV_showImg.frame)+20, 0,0)];
            _lb_newContent.backgroundColor=[UIColor clearColor];
            _lb_newContent.textAlignment=NSTextAlignmentLeft;
            _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
            _lb_newContent.text=model.status.content;//内容里有[大笑]字符的借鉴老易班里的review_ControllerView类的heightForRowAtIndexPath方法
            _lb_newContent.textColor=ColorBlack;
            _lb_newContent.numberOfLines=0;
            _lb_newContent.lineBreakMode=NSLineBreakByCharWrapping;
            [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-CGRectGetMinX(_lb_newContent.frame)*2, 1000)];
            [_lb_newContent replaceEmojiandTarget:NO];
            [self addSubview:_lb_newContent];
            RELEASE(_lb_newContent);
        }
        
        NSArray *arrIMG=model.status.pic_array;
        CGFloat fHeight=CGRectGetMaxY(_lb_newContent.frame)+10;
        
        if ([model.status.pic_array count] > 0) {
            NSInteger nIMAGECount  = [arrIMG count];
            
            for (int nIndex = 0; nIndex < nIMAGECount; nIndex ++) {
                MagicUIImageView *_imgDynamicIMAGE = [[MagicUIImageView alloc] initWithFrame:CGRectMake(_lb_newContent.frame.origin.x+70*nIndex, CGRectGetMaxY(_lb_newContent.frame)+15+nIndex/3*85, 60, 75) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleToFill stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                _imgDynamicIMAGE.tag=6;
                
                if (nIndex > 2) {
                    [_imgDynamicIMAGE setFrame:CGRectMake(_lb_newContent.frame.origin.x+70*(nIndex-3), CGRectGetMinY(_imgDynamicIMAGE.frame), CGRectGetWidth(_imgDynamicIMAGE.frame), CGRectGetHeight(_imgDynamicIMAGE.frame))];
                }
                
                [_imgDynamicIMAGE setImgWithUrl:[[arrIMG objectAtIndex:nIndex] objectForKey:@"pic_s"] defaultImg:no_pic_50];
                
                //            [_imgDynamicIMAGE setUserInteractionEnabled:YES];
                //            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapImageWithGesture:)];
                //            [_imgDynamicIMAGE addGestureRecognizer:tapGestureRecognizer];
                
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", nIndex], @"tag", [model.status retain], @"status", nil];
                [_imgDynamicIMAGE addSignal:[UIView TAP] object:dic];
                
                RELEASE(_imgDynamicIMAGE);
                
                fHeight =  CGRectGetMaxY(_imgDynamicIMAGE.frame);
            }
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, fHeight+15)];
    }
}

@end
