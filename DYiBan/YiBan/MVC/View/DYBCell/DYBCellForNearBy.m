//
//  DYBCellForNearBy.m
//  DYiBan
//
//  Created by zhangchao on 13-8-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForNearBy.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "UIImageView+WebCache.h"
#import "nearByFriends.h"
#import "UITableView+property.h"

@implementation DYBCellForNearBy

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, tbv._cellH)];
    if (data) {
        nearByFriends *model=data;
        
        if (!_imgV_showImg) {
            _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15,0, 50,50) backgroundColor:[UIColor clearColor] image:_imgV_showImg.image isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            _imgV_showImg.needRadius=YES;
            RELEASE(_imgV_showImg);
            
            [_imgV_showImg setImgWithUrl:model.pic defaultImg:no_pic_50];
            
//            NSString *encondeUrl= [model.pic stringByAddingPercentEscapesUsingEncoding];//把str里的 "" ,‘:’, ‘/’, ‘%’, ‘#’, ‘;’, and ‘@’. Note that ‘%’转成 UTF-8. 避免服务器发的url里有这些特殊字符从而导致 ([NSURL URLWithString:encondeUrl] == nil)
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
            _lb_nickName.font=[DYBShareinstaceDelegate DYBFoutStyle:20];
            _lb_nickName.text=model.name;
            [_lb_nickName setNeedCoretext:NO];
            _lb_nickName.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
            _lb_nickName.numberOfLines=1;
            
            _lb_nickName.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_nickName sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_newContent.frame.origin.x-50, 100)];
            
            [self addSubview:_lb_nickName];
            
            [_lb_nickName changePosInSuperViewWithAlignment:1];
            [_lb_nickName setFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_nickName.frame.origin.y-5, _lb_nickName.frame.size.width, _lb_nickName.frame.size.height)];

            RELEASE(_lb_nickName);
        }
        
        if (!_lb_newContent) {
            _lb_newContent=[[MagicUILabel alloc]initWithFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_nickName.frame.origin.y+_lb_nickName.frame.size.height+3, self.frame.size.width-_lb_nickName.frame.origin.x-40, _lb_nickName.frame.size.height)];
            _lb_newContent.backgroundColor=[UIColor clearColor];
            _lb_newContent.textAlignment=NSTextAlignmentLeft;
            _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
            _lb_newContent.text=model.address;
            _lb_newContent.textColor=[MagicCommentMethod color:170 green:170 blue:170 alpha:1];
            _lb_newContent.numberOfLines=1;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
            
            _lb_newContent.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_newContent.frame.origin.x-50, 100)];
            
            [self addSubview:_lb_newContent];
            [_lb_newContent setNeedCoretext:NO];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_newContent);
        }
        
        if (!_lb_distance) {
            _lb_distance=[[MagicUILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-80, _lb_nickName.frame.origin.y, 150,50)];
            _lb_distance.backgroundColor=[UIColor clearColor];
            _lb_distance.textAlignment=NSTextAlignmentRight;
            _lb_distance.font=[DYBShareinstaceDelegate DYBFoutStyle:20];
            _lb_distance.text=model.distance;
            _lb_distance.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
            _lb_distance.numberOfLines=1;//
            
            _lb_distance.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_distance sizeToFitByconstrainedSize:CGSizeMake(100, 100)];
            
            [self addSubview:_lb_distance];
            [_lb_distance setNeedCoretext:NO];
            
            //右对齐
            [_lb_distance setFrame:CGRectMake(self.frame.size.width-15-_lb_distance.frame.size.width, _lb_distance.frame.origin.y, _lb_distance.frame.size.width, _lb_distance.frame.size.height)];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_distance);
        }
        
        if (!_lb_time) {
            _lb_time=[[MagicUILabel alloc]initWithFrame:CGRectMake(0, _lb_newContent.frame.origin.y, 0,0)];
            _lb_time.backgroundColor=[UIColor clearColor];
            _lb_time.textAlignment=NSTextAlignmentRight;
            _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
            _lb_time.text=model.sign_time;
            _lb_time.textColor=[MagicCommentMethod color:170 green:170 blue:170 alpha:1];
            _lb_time.numberOfLines=1;//
            
            _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_time sizeToFitByconstrainedSize:CGSizeMake(screenShows.size.width-20, 100)];
            //右对齐
            [_lb_time setFrame:CGRectMake(self.frame.size.width-15-_lb_time.frame.size.width, _lb_time.frame.origin.y, _lb_time.frame.size.width, _lb_time.frame.size.height)];
            [self addSubview:_lb_time];
            [_lb_time setNeedCoretext:NO];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_time);
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

@end
