//
//  DYBCellForEmployAndMyCollect.m
//  DYiBan
//
//  Created by zhangchao on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForEmployAndMyCollect.h"
#import "EmployInfo.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"

@interface DYBCellForEmployAndMyCollect ()
{
    MagicUIImageView *_imgV_icon;
    DYBCustomLabel *_lbTitle,*_lb_content,*_lb_time,*_lb_collectNums/*收藏量*/,*_lb_click_num/*浏览量*/;
    UIView *_vBack;
    MagicUIButton *_btIcon;
    MagicUITextField *_nameInput;
}


@end

@implementation DYBCellForEmployAndMyCollect

@synthesize type=_type;


-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    EmployInfo *model=data;
    
    switch (_type) {
        case 0://就业信息cell
        {
            self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            switch (indexPath.section) {
                case 0://小编推荐cell
                {
                    if (!_lb_content) {//
                        _lb_content=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(10, 0, 0,0)];
                        _lb_content.backgroundColor=[UIColor clearColor];
                        _lb_content.textAlignment=NSTextAlignmentLeft;
                        _lb_content.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
                        _lb_content.text=model.title;
                        _lb_content.textColor=ColorBlue;
                        _lb_content.numberOfLines=0;
                        _lb_content.lineBreakMode=NSLineBreakByTruncatingTail;
                        [_lb_content sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_content.frame.origin.x-30,1000)];
                        //                        [_lb_sign setNeedCoretext:YES];
                        [self addSubview:_lb_content];
                        RELEASE(_lb_content);
                        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(_lb_content.frame)+20)];
                        [_lb_content changePosInSuperViewWithAlignment:1];
                    }
                }
                    break;
                case 1://最新职位cell
                {
                    [self newOffer:model];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1://我的收藏cell
        {
            [self newOffer:model];
        }
            break;
        case 2://搜索结果cell
        {
            [self newOffer:model];
        }
            break;
        case 3://就业信息详情cell
        {
            if (!_lbTitle) {//
                _lbTitle=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(10, 20, 0,0)];
                _lbTitle.backgroundColor=[UIColor clearColor];
                _lbTitle.textAlignment=NSTextAlignmentLeft;
                _lbTitle.font=[DYBShareinstaceDelegate DYBFoutStyle:16];
                _lbTitle.text=model.title;
                _lbTitle.textColor=ColorBlack;
                _lbTitle.numberOfLines=0;
                _lbTitle.lineBreakMode=NSLineBreakByTruncatingTail;
                [_lbTitle sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-40,1000)];
                //                        [_lb_sign setNeedCoretext:YES];
                [self addSubview:_lbTitle];
                RELEASE(_lbTitle);
                [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMaxY(_lbTitle.frame)+20)];
                [_lbTitle changePosInSuperViewWithAlignment:0];
            }
            
            if (!_lb_time) {//
                _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(60, CGRectGetMaxY(_lbTitle.frame)+10, 0,0)];
                _lb_time.backgroundColor=[UIColor clearColor];
                _lb_time.textAlignment=NSTextAlignmentLeft;
                _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                _lb_time.text=model.pubtime;
                _lb_time.textColor=ColorGray;
                _lb_time.numberOfLines=0;
                _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
                [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_content.frame.origin.x-30,1000)];
                //                        [_lb_sign setNeedCoretext:YES];
                [self addSubview:_lb_time];
                RELEASE(_lb_time);
                [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMaxY(_lb_time.frame)+20)];
                
                {//竖线
                    UIImage *img=[UIImage imageNamed:@"dotted_info_line.png"];
                    MagicUIImageView *imgV = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lb_time.frame)+10, CGRectGetMinY(_lb_time.frame), img.size.width/2,img.size.height/2) backgroundColor:[UIColor whiteColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(imgV);
                    
                    if (!_lb_click_num) {//浏览量
                        _lb_click_num=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+10, CGRectGetMinY(_lb_time.frame), 0,0)];
                        _lb_click_num.backgroundColor=[UIColor clearColor];
                        _lb_click_num.textAlignment=NSTextAlignmentLeft;
                        _lb_click_num.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                        _lb_click_num.text=[NSString stringWithFormat:@"浏览: %@",model.click_num];
                        _lb_click_num.textColor=ColorGray;
                        _lb_click_num.numberOfLines=0;
                        _lb_click_num.lineBreakMode=NSLineBreakByTruncatingTail;
                        [_lb_click_num sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_content.frame.origin.x-30,1000)];
                        //                        [_lb_sign setNeedCoretext:YES];
                        [self addSubview:_lb_click_num];
                        RELEASE(_lb_click_num);
                    }
                    
                    {//竖线
                        UIImage *img=[UIImage imageNamed:@"dotted_info_line.png"];
                        MagicUIImageView *imgV = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lb_click_num.frame)+10, CGRectGetMinY(_lb_click_num.frame), img.size.width/2,img.size.height/2) backgroundColor:[UIColor whiteColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                        RELEASE(imgV);
                        
                        if (!_lb_collectNums) {//收藏
                            _lb_collectNums=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+10, CGRectGetMinY(_lb_click_num.frame), 0,0)];
                            _lb_collectNums.backgroundColor=[UIColor clearColor];
                            _lb_collectNums.textAlignment=NSTextAlignmentLeft;
                            _lb_collectNums.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                            _lb_collectNums.text=[NSString stringWithFormat:@"收藏: %@",model.collect_num];
                            _lb_collectNums.textColor=ColorGray;
                            _lb_collectNums.numberOfLines=0;
                            _lb_collectNums.lineBreakMode=NSLineBreakByTruncatingTail;
                            [_lb_collectNums sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_content.frame.origin.x-30,1000)];
                            //                        [_lb_sign setNeedCoretext:YES];
                            [self addSubview:_lb_collectNums];
                            RELEASE(_lb_collectNums);
                        }
                        
                    }
                }
            }
            
            if (!_lb_content) {//
                _lb_content=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_lb_time.frame)+10, 0,0)];
                _lb_content.backgroundColor=[UIColor clearColor];
                _lb_content.textAlignment=NSTextAlignmentLeft;
                _lb_content.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
                _lb_content.text=model.content;
                _lb_content.textColor=ColorBlack;
                _lb_content.numberOfLines=0;
                _lb_content.lineBreakMode=NSLineBreakByTruncatingTail;
                [_lb_content sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-20,10000000)];
                //                        [_lb_sign setNeedCoretext:YES];
                [self addSubview:_lb_content];
                RELEASE(_lb_content);
                [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMaxY(_lb_content.frame)+20)];
                [_lb_content changePosInSuperViewWithAlignment:0];
            }
        }
            break;
        default:
            break;
    }
    
    {//选中色
        UIView *v=[[UIView alloc]initWithFrame:self.bounds];
        v.backgroundColor=BKGGray;
        self.selectedBackgroundView=v;
        RELEASE(v);
    }
}

-(void)newOffer:(EmployInfo *)model
{
    if (!_lb_content) {//
        _lb_content=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(10, 20, 0,0)];
        _lb_content.backgroundColor=[UIColor clearColor];
        _lb_content.textAlignment=NSTextAlignmentLeft;
        _lb_content.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
        _lb_content.text=model.title;
        _lb_content.textColor=ColorBlack;
        _lb_content.numberOfLines=0;
        _lb_content.lineBreakMode=NSLineBreakByTruncatingTail;
        [_lb_content sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_content.frame.origin.x-30,1000)];
        //                        [_lb_sign setNeedCoretext:YES];
        [self addSubview:_lb_content];
        RELEASE(_lb_content);
        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMaxY(_lb_content.frame)+20)];
        //                        [_lb_content changePosInSuperViewWithAlignment:1];
    }
    
    if (!_lb_time) {//
        _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_lb_content.frame)+10, 0,0)];
        _lb_time.backgroundColor=[UIColor clearColor];
        _lb_time.textAlignment=NSTextAlignmentLeft;
        _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
        _lb_time.text=model.pubtime;
        _lb_time.textColor=ColorGray;
        _lb_time.numberOfLines=0;
        _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
        [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_content.frame.origin.x-30,1000)];
        //                        [_lb_sign setNeedCoretext:YES];
        [self addSubview:_lb_time];
        RELEASE(_lb_time);
        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMaxY(_lb_time.frame)+20)];
    }
    
    {//竖线
        UIImage *img=[UIImage imageNamed:@"dotted_info_line.png"];
        MagicUIImageView *imgV = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lb_time.frame)+10, CGRectGetMinY(_lb_time.frame), img.size.width/2,img.size.height/2) backgroundColor:[UIColor whiteColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        RELEASE(imgV);
        
        if (!_lb_click_num) {//浏览量
            _lb_click_num=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+10, CGRectGetMinY(_lb_time.frame), 0,0)];
            _lb_click_num.backgroundColor=[UIColor clearColor];
            _lb_click_num.textAlignment=NSTextAlignmentLeft;
            _lb_click_num.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
            _lb_click_num.text=[NSString stringWithFormat:@"浏览: %@",model.click_num];
            _lb_click_num.textColor=ColorGray;
            _lb_click_num.numberOfLines=0;
            _lb_click_num.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_click_num sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_content.frame.origin.x-30,1000)];
            //                        [_lb_sign setNeedCoretext:YES];
            [self addSubview:_lb_click_num];
            RELEASE(_lb_click_num);
        }
        
        {//竖线
            UIImage *img=[UIImage imageNamed:@"dotted_info_line.png"];
            MagicUIImageView *imgV = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lb_click_num.frame)+10, CGRectGetMinY(_lb_click_num.frame), img.size.width/2,img.size.height/2) backgroundColor:[UIColor whiteColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            RELEASE(imgV);
            
            if (!_lb_collectNums) {//收藏
                _lb_collectNums=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+10, CGRectGetMinY(_lb_click_num.frame), 0,0)];
                _lb_collectNums.backgroundColor=[UIColor clearColor];
                _lb_collectNums.textAlignment=NSTextAlignmentLeft;
                _lb_collectNums.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                _lb_collectNums.text=[NSString stringWithFormat:@"收藏: %@",model.collect_num];
                _lb_collectNums.textColor=ColorGray;
                _lb_collectNums.numberOfLines=0;
                _lb_collectNums.lineBreakMode=NSLineBreakByTruncatingTail;
                [_lb_collectNums sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_content.frame.origin.x-30,1000)];
                //                        [_lb_sign setNeedCoretext:YES];
                [self addSubview:_lb_collectNums];
                RELEASE(_lb_collectNums);
            }
            
        }
    }
    
}
@end
