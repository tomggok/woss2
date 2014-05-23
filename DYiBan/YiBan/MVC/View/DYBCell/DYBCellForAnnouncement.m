//
//  DYBCellForAnnouncement.m
//  DYiBan
//
//  Created by zhangchao on 13-8-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForAnnouncement.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "eclass_notice.h"
#import "target.h"
#import "UITableViewCell+MagicCategory.h"
#import "eclass_topiclist.h"

@implementation DYBCellForAnnouncement

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    //    self.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    if (data) {
        switch (self.i_type) {
            case 0://公告
            {
                eclass_notice *model=data;
                
                if (!_lb_newContent) {
                    _lb_newContent=[[MagicUILabel alloc]initWithFrame:CGRectMake(10, 0, 0,0)];
                    _lb_newContent.backgroundColor=[UIColor clearColor];
                    _lb_newContent.textAlignment=NSTextAlignmentLeft;
                    _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
                    _lb_newContent.text=((model.target.count>0)?(((target *)[model.target objectAtIndex:0]).targetname):(@""));
                    _lb_newContent.textColor=ColorBlack;
                    _lb_newContent.numberOfLines=2;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
                    
                    _lb_newContent.lineBreakMode=NSLineBreakByTruncatingTail;
                    [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_newContent.frame.origin.x-90, 200)];
                    
                    [self addSubview:_lb_newContent];
                    [_lb_newContent setNeedCoretext:NO];
                    
                    //        [_lb_nickName changePosInSuperViewWithAlignment:1];
                    RELEASE(_lb_newContent);
                }
                
                if (!_lb_time) {
                    _lb_time=[[MagicUILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-90, 5, 0, 0)];
                    _lb_time.backgroundColor=[UIColor clearColor];
                    _lb_time.textAlignment=NSTextAlignmentLeft;
                    _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                    //            _lb_time._constrainedSize=CGSizeMake(screenShows.size.width-20, 100);
                    _lb_time.text=[NSString stringWithFormat:@"%d-%d-%d",[NSString getDateComponentsByTimeStamp:[model.time intValue]].year,[NSString getDateComponentsByTimeStamp:[model.time intValue]].month,[NSString getDateComponentsByTimeStamp:[model.time intValue]].day];
                    
                    [_lb_time setNeedCoretext:NO];
                    _lb_time.textColor=ColorGray;
                    _lb_time.numberOfLines=1;
                    
                    _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
                    [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_time.frame.origin.x, 100)];
                    
                    [self addSubview:_lb_time];
                    
                    [_lb_time changePosInSuperViewWithAlignment:1];
                    RELEASE(_lb_time);
                }
                
                [self setFrame:CGRectMake(0, 0, self.frame.size.width, _lb_newContent.frame.size.height+30)];
                [_lb_time changePosInSuperViewWithAlignment:1];
                [_lb_newContent changePosInSuperViewWithAlignment:1];
                
                if(!_imgV_sepline){//分割线
                    UIImage *img=[UIImage imageNamed:@"sepline2"];
                    _imgV_sepline=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-img.size.height/2, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:0 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(_imgV_sepline);
                    [_imgV_sepline setFrame:CGRectMake(CGRectGetMinX(_imgV_sepline.frame)-15, CGRectGetMinY(_imgV_sepline.frame), CGRectGetWidth(_imgV_sepline.frame), CGRectGetHeight(_imgV_sepline.frame))];
                }
            }
                break;
            case 1://话题
            {
                eclass_topiclist *model=data;
                
                if (!_lb_newContent) {
                    _lb_newContent=[[MagicUILabel alloc]initWithFrame:CGRectMake(10, 0, 0,0)];
                    _lb_newContent.backgroundColor=[UIColor clearColor];
                    _lb_newContent.textAlignment=NSTextAlignmentLeft;
                    _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
                    _lb_newContent.text=model.title;
                    _lb_newContent.textColor=ColorBlack;
                    _lb_newContent.numberOfLines=2;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
                    
                    _lb_newContent.lineBreakMode=NSLineBreakByTruncatingTail;
                    [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_newContent.frame.origin.x-90, 200)];
                    
                    [self addSubview:_lb_newContent];
                    [_lb_newContent setNeedCoretext:NO];
                    
                    //        [_lb_nickName changePosInSuperViewWithAlignment:1];
                    RELEASE(_lb_newContent);
                }
                
                if (!_lb_time) {
                    _lb_time=[[MagicUILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-90, 5, 0, 0)];
                    _lb_time.backgroundColor=[UIColor clearColor];
                    _lb_time.textAlignment=NSTextAlignmentLeft;
                    _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                    //            _lb_time._constrainedSize=CGSizeMake(screenShows.size.width-20, 100);
                    _lb_time.text=[[model.pubtime separateStrToArrayBySeparaterChar:@" "] objectAtIndex:0];
                    
                    [_lb_time setNeedCoretext:NO];
                    _lb_time.textColor=ColorGray;
                    _lb_time.numberOfLines=1;
                    
                    _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
                    [_lb_time sizeToFitByconstrainedSize:CGSizeMake(1000, 100)];
                    
//                    [_lb_time setFrame:CGRectMake(CGRectGetWidth(self.frame)-40-CGRectGetWidth(_lb_newContent.frame), CGRectGetMinY(_lb_newContent.frame), CGRectGetWidth(_lb_newContent.frame), CGRectGetHeight(_lb_newContent.frame))];
                    [self addSubview:_lb_time];
                    
                    [_lb_time changePosInSuperViewWithAlignment:1];
                    RELEASE(_lb_time);
                }
                
                [self setFrame:CGRectMake(0, 0, self.frame.size.width, _lb_newContent.frame.size.height+30)];
                [_lb_time changePosInSuperViewWithAlignment:1];
                [_lb_newContent changePosInSuperViewWithAlignment:1];
                
                if(!_imgV_sepline){//分割线
                    UIImage *img=[UIImage imageNamed:@"sepline2"];
                    _imgV_sepline=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-img.size.height/2, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:0 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(_imgV_sepline);
                    [_imgV_sepline setFrame:CGRectMake(CGRectGetMinX(_imgV_sepline.frame)-15, CGRectGetMinY(_imgV_sepline.frame), CGRectGetWidth(_imgV_sepline.frame), CGRectGetHeight(_imgV_sepline.frame))];
                }
            }
                break;
            default:
                break;
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
