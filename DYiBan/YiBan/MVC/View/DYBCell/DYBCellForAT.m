//
//  DYBCellForAT.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForAT.h"
#import "friends.h"
#import "UITableView+property.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "UIImageView+WebCache.h"
#import "UILabel+ReSize.h"

@implementation DYBCellForAT

DEF_SIGNAL(CHECK)

#pragma mark- 设置整体Cell
-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, tbv._cellH)];
    
    if (data) {
        friends *model=data;
        
        if (!_imgV_showImg) {
            _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15,0, 50,50) backgroundColor:[UIColor clearColor] image:_imgV_showImg.image isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            _imgV_showImg.needRadius=YES;
            RELEASE(_imgV_showImg);
            [_imgV_showImg setImgWithUrl:model.pic defaultImg:no_pic_50];
        }
        
        
        if (!_lb_nickName) {
            _lb_nickName=[[MagicUILabel alloc]initWithFrame:CGRectMake(_imgV_showImg.frame.origin.x+_imgV_showImg.frame.size.width+10, 0, 0, 0)];
            _lb_nickName.backgroundColor=[UIColor clearColor];
            _lb_nickName.textAlignment=NSTextAlignmentLeft;
            _lb_nickName.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
            //            _lb_nickName._constrainedSize=CGSizeMake(screenShows.size.width-20, 100);
            _lb_nickName.text=model.name;
            [_lb_nickName setNeedCoretext:NO];
            _lb_nickName.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
            _lb_nickName.numberOfLines=1;
            
            _lb_nickName.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_nickName sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-150, 100)];
            
            [self addSubview:_lb_nickName];
            
            [_lb_nickName changePosInSuperViewWithAlignment:1];
            
            RELEASE(_lb_nickName);
        }
        
        if (!_lb_newContent) {
            _lb_newContent=[[MagicUILabel alloc]initWithFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_nickName.frame.origin.y+_lb_nickName.frame.size.height+2, /*self.frame.size.width-_lb_nickName.frame.origin.x-80, _lb_nickName.frame.size.height*/ 0,0)];
            _lb_newContent.backgroundColor=[UIColor clearColor];
            _lb_newContent.textAlignment=NSTextAlignmentLeft;
            _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
            //            _lb_newContent._constrainedSize=CGSizeMake(screenShows.size.width-40, 100);
            _lb_newContent.text=model.desc;
            _lb_newContent.textColor=[MagicCommentMethod color:170 green:170 blue:170 alpha:1];
            _lb_newContent.numberOfLines=1;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
            
            _lb_newContent.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-150, 100)];
            
            [self addSubview:_lb_newContent];
            [_lb_newContent setNeedCoretext:NO];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_newContent);
        }
        
        if (!_btn_check) {
            _btn_check = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-18-45, _lb_nickName.frame.origin.y+5, 18, 18)];
            [_btn_check setBackgroundColor:[UIColor clearColor]];
            [_btn_check setBackgroundImage:[UIImage imageNamed:@"btn_check_no.png"] forState:UIControlStateNormal];
            [_btn_check setBackgroundImage:[UIImage imageNamed:@"btn_check_yes.png"] forState:UIControlStateSelected];
            [_btn_check setSelected:NO];
            [_btn_check setUserInteractionEnabled:NO];
//            [_btn_check addSignal:[DYBCellForAT CHECK] forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_btn_check];
            RELEASE(_btn_check);
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, tbv._cellH, self.frame.size.width, 0.5)];
        [view setBackgroundColor:ColorDivLine];
        [self addSubview:view];
        RELEASE(view);

    }
}

#pragma mark- 接受其他信号
- (void)handleViewSignal_DYBCellForAT:(MagicViewSignal *)signal
{
    if ([signal is:[DYBCellForAT CHECK]]){
        _btn_check.selected = !_btn_check.selected;
    }
}

@end
