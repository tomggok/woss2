//
//  CellForDYBMsgViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForDYBMsgViewController.h"
#import "UIView+MagicCategory.h"
#import "msg_count.h"

@implementation DYBCellForDYBMsgViewController

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    self.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    
    if (!_imgV_showImg) {
        UIImage *img=nil;
        switch (indexPath.row) {
            case 0://提到我的
            {
                img=[UIImage imageNamed:@"btn_mainmenu_default"];
            }
                break;
            case 1://评论我的
            {
                img=[UIImage imageNamed:@"btn_mainmenu_default"];
            }
                break;
            case 2://通知
            {
                img=[UIImage imageNamed:@"btn_mainmenu_default"];
            }
                break;
            case 3://系统消息
            {
                img=[UIImage imageNamed:@"btn_mainmenu_default"];
            }
                break;
            default:
                break;
        }
        _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(10,0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        RELEASE(_imgV_showImg);
    }
    
    if (!_lb_content) {
        _lb_content=[[MagicUILabel alloc]initWithFrame:CGRectMake(_imgV_showImg.frame.origin.x+_imgV_showImg.frame.size.width+20, 0, 0, 0)];
        _lb_content.backgroundColor=[UIColor clearColor];
//        _lb_content.textAlignment=UITextAlignmentLeft;
        _lb_content.font=[UIFont systemFontOfSize:18];
//        _lb_content._constrainedSize=CGSizeMake(screenShows.size.width-20, 100);
        switch (indexPath.row) {
            case 0://提到我的
            {
                _lb_content.text=@"提到我的";
            }
                break;
            case 1://评论我的
            {
                _lb_content.text=@"评论我的";
            }
                break;
            case 2://通知
            {
                _lb_content.text=@"通知";
            }
                break;
            case 3://系统消息
            {
                _lb_content.text=@"系统消息";
            }
                break;
            default:
                break;
        }
        [_lb_content setNeedCoretext:NO];
        _lb_content.textColor=[UIColor blackColor];
        _lb_content.numberOfLines=0;
        
        _lb_content.lineBreakMode=NSLineBreakByCharWrapping;
        [_lb_content sizeToFitByconstrainedSize:CGSizeMake(screenShows.size.width-20, 100)];
        
        [self addSubview:_lb_content];
        
        [_lb_content changePosInSuperViewWithAlignment:1];
        RELEASE(_lb_content);
    }
    
    if (data) {
        msg_count *model=data;
        switch (indexPath.row) {
            case 0://提到我的
            {
                _lb_content.text=model.new_at;
            }
                break;
            case 1://评论我的
            {
                _lb_content.text=model.new_comment;
            }
                break;
            case 2://通知
            {
                _lb_content.text=model.new_notice;
            }
                break;
            case 3://系统消息
            {
                _lb_content.text=model.new_message;
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
