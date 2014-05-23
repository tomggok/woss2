//
//  DYBCellForReadedUser.m
//  DYiBan
//
//  Created by zhangchao on 13-9-20.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForReadedUser.h"
#import "DYBCustomLabel.h"
#import "notice.h"
#import "NSString+Count.h"
#import "UITableView+property.h"

@interface DYBCellForReadedUser ()
{
    MagicUIImageView *_imgV_showImg/*左边展示图*/,*_imgV_newMsgNums/*新消息数量图*/;
    DYBCustomLabel *_lb_newContent,*_lb_nickName,*_lb_time;
    UIView *_v_bigContent/*主要内容背景*/,*_v_toBeSlidingView/*要被滑动的view*/;
}
@end

@implementation DYBCellForReadedUser

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    if (data) {
        notice *model=data;
        
        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), tbv._cellH)];
        
        if (!_imgV_showImg) {
            _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15,0, 50,50) backgroundColor:[UIColor clearColor] image:_imgV_showImg.image isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            _imgV_showImg.needRadius=YES;
            RELEASE(_imgV_showImg);
            
            [_imgV_showImg setImgWithUrl:model.user.pic defaultImg:no_pic_50];
        }
        
        if (!_lb_nickName) {
            _lb_nickName=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_imgV_showImg.frame.origin.x+_imgV_showImg.frame.size.width+10, 0, 0, 0)];
            _lb_nickName.backgroundColor=[UIColor clearColor];
            _lb_nickName.textAlignment=NSTextAlignmentLeft;
            _lb_nickName.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
            _lb_nickName.text=model.user.name;
            [_lb_nickName setNeedCoretext:NO];
            _lb_nickName.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
            _lb_nickName.numberOfLines=1;
            
            _lb_nickName.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_nickName sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_nickName.frame.origin.x, 100)];
            
            [self addSubview:_lb_nickName];
            _lb_nickName.center=CGPointMake(_lb_nickName.center.x, _imgV_showImg.center.y);
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_nickName);
        }
                
        if (!_lb_newContent) {
            _lb_newContent=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lb_nickName.frame), CGRectGetMaxY(_lb_nickName.frame)+5, 0,0)];
            _lb_newContent.backgroundColor=[UIColor clearColor];
            _lb_newContent.textAlignment=NSTextAlignmentLeft;
            _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
            _lb_newContent.text=/*@"[敲打][敲打][难过][敲打]带我去打网球[难过][难过][难过][难过][难过][敲打][敲打][难过][敲打]";// @"dqdqwdqwdwqdwqdqdwqdqwdqdwqdqwdqwdqwdqwdwqdwqd"; // */ model.user.desc;
            _lb_newContent.textColor=([MagicCommentMethod color:170 green:170 blue:170 alpha:1]);
            //            [_lb_newContent sizeToFit];
            _lb_newContent.maxLineNum=1;//只一行
            [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(175, 40)];
            _lb_newContent.lineBreakMode=NSLineBreakByCharWrapping;
            [_lb_newContent setImgType:-1];
            [_lb_newContent replaceEmojiandTarget:NO];
            
            if (![NSString isContainsEmoji:_lb_newContent.text]) {
                [_lb_newContent setFrame:CGRectMake(CGRectGetMinX(_lb_newContent.frame), CGRectGetMinY(_lb_newContent.frame)+3, CGRectGetWidth(_lb_newContent.frame), CGRectGetHeight(_lb_newContent.frame))];
            }
            
            [self addSubview:_lb_newContent];            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_newContent);
        }
    }
    
    {//分割线
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-1), self.frame.size.width, 0.5)];
        [v setBackgroundColor:[MagicCommentMethod colorWithHex:@"0xeeeeee"]];
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

@end
