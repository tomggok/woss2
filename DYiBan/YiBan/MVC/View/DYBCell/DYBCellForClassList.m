//
//  DYBCellForClassList.m
//  DYiBan
//
//  Created by zhangchao on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForClassList.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "eclass.h"
#import "UITableView+property.h"
#import "UIView+Gesture.h"
#include "DYBClassListViewController.h"

@implementation DYBCellForClassList

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    DYBClassListViewController *superCon=(DYBClassListViewController *)[tbv superCon];
    
    switch (superCon.type) {
        case 0:
        {
//            self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        default:
            break;
    }
    
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, tbv._cellH)];
    if (data) {
        eclass *model=data;
        
        if (!_lb_newContent) {
            _lb_newContent=[[MagicUILabel alloc]initWithFrame:CGRectMake(10, 0, 0,0)];
            _lb_newContent.backgroundColor=[UIColor clearColor];
            _lb_newContent.textAlignment=NSTextAlignmentLeft;
            _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
            _lb_newContent.text=[NSString stringWithFormat:@"%@",/*((model.year)?(model.year):(@"")),((model.college)?(model.college):(@"")),*/((model.name)?(model.name):(@""))];
            _lb_newContent.textColor=ColorBlack;
            _lb_newContent.numberOfLines=2;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
            
            _lb_newContent.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_newContent.frame.origin.x-80, 200)];
            
            [self addSubview:_lb_newContent];
            [_lb_newContent setNeedCoretext:NO];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_newContent);
        }
        
        switch (superCon.type) {
            case 0:
            {
                if (!_imgV_star) {
                    UIImage *img=([model.active isEqualToString:@"1"])?([UIImage imageNamed:@"favclass_yes"]):([UIImage imageNamed:@"favclass_no"]);
                    _imgV_star=[[MagicUIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-55,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(_imgV_star);
                    [_imgV_star addSignal:[UIView TAP] object:indexPath];
                }
            }
                break;
            case 1:
            {
                if (!_imgV_YES) {
                    UIImage *img=[UIImage imageNamed:@"ftz11"];
                    _imgV_YES=[[MagicUIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-20-img.size.width/2,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    _imgV_YES.hidden=YES;
                    RELEASE(_imgV_YES);
                }
            }
                break;
            default:
                break;
        }
       
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, _lb_newContent.frame.size.height+30)];
        [_lb_newContent changePosInSuperViewWithAlignment:1];
        [_imgV_star changePosInSuperViewWithAlignment:1];
        [_imgV_YES changePosInSuperViewWithAlignment:1];

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;                     // animate between regular and selected state
{
    if (selected) {
        _imgV_YES.hidden=!_imgV_YES.hidden;
    }
}

@end
