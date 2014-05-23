//
//  DYBCellForVisitor.m
//  DYiBan
//
//  Created by zhangchao on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForVisitor.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "UIImageView+WebCache.h"
#import "guest_list.h"
#import "user.h"
#import "UITableView+property.h"
#import "UILabel+ReSize.h"
@implementation DYBCellForVisitor

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    //    self.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, tbv._cellH)];
    if (data) {
        guest_list *model=data;
        
        if (!_imgV_showImg) {
            _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15,0, 50,50) backgroundColor:[UIColor clearColor] image:_imgV_showImg.image isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            _imgV_showImg.needRadius=YES;
            RELEASE(_imgV_showImg);
            
            NSString *encondeUrl= [model.user.pic_s stringByAddingPercentEscapesUsingEncoding];//把str里的 "" ,‘:’, ‘/’, ‘%’, ‘#’, ‘;’, and ‘@’. Note that ‘%’转成 UTF-8. 避免服务器发的url里有这些特殊字符从而导致 ([NSURL URLWithString:encondeUrl] == nil)
            
            if ([NSURL URLWithString:encondeUrl] == nil) {
                [_imgV_showImg setImage:[UIImage imageNamed:@"no_pic_50.png"]];
            }else
            {
                _imgV_showImg._b_isShade=NO;
                [_imgV_showImg setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic_50.png"]];
                
            }
        }
        
        if (!_lb_nickName) {
            _lb_nickName=[[MagicUILabel alloc]initWithFrame:CGRectMake(_imgV_showImg.frame.origin.x+_imgV_showImg.frame.size.width+10, 15, 0, 0)];
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
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_nickName);
        }
        
        if (!_lb_newContent) {
            _lb_newContent=[[MagicUILabel alloc]initWithFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_nickName.frame.origin.y+_lb_nickName.frame.size.height+4, /*self.frame.size.width-_lb_nickName.frame.origin.x-80, _lb_nickName.frame.size.height*/ 0,0)];
            _lb_newContent.backgroundColor=[UIColor clearColor];
            _lb_newContent.textAlignment=NSTextAlignmentLeft;
            _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:13];

            if ([model.user.isFriend intValue]==1) {
                _lb_newContent.text=@"好友";
            }
            
            if ([model.user.usertype intValue] == 1) {
                _lb_newContent.text=[_lb_newContent.text stringByAppendingFormat:@" • 辅导员"];
                
            }else {
                if ([model.user.isSameClass intValue]==1) {
                    _lb_newContent.text=[_lb_newContent.text stringByAppendingFormat:@" • 同班同学"];
                    
                }else {
                    
                    if ([model.user.isSameSchool intValue]==1) {
                        _lb_newContent.text=[_lb_newContent.text stringByAppendingFormat:@" • 校友"];
                    }
                    
                }
            }
            
            if ([_lb_newContent.text isEqualToString:@""]|| !_lb_newContent.text) {
                
                _lb_newContent.text=@"陌生人";
            }
            
//            NSString *stringType = @"";
//            if ([model.user.usertype intValue] == 0) {
//                
//                stringType = @"(普通用户,学生)";
//                
//            }else if ([model.user.usertype intValue] == 1) {
//                
//                stringType = @"(辅导员)";
//                
//            }else if ([model.user.usertype intValue] == 2) {
//                
//                stringType = @"(老师)";
//                
//            }else if ([model.user.usertype intValue] == 3) {
//                
//                stringType = @"(领导)";
//                
//            }else {
//                
//                stringType = @"(施政老师)";
//                
//            }
//            
//            
//            _lb_newContent.text = [@"" stringByAppendingFormat:@"%@%@",_lb_newContent.text,stringType];
            
            _lb_newContent.textColor=ColorGray;
            _lb_newContent.numberOfLines=1;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
            
            _lb_newContent.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-180, 100)];
            
            [self addSubview:_lb_newContent];
            [_lb_newContent setNeedCoretext:NO];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_newContent);
        }
        
        if (!_lb_time) {
            _lb_time=[[MagicUILabel alloc]initWithFrame:CGRectMake(_lb_newContent.frame.origin.x+_lb_newContent.frame.size.width+5, _lb_newContent.frame.origin.y, 0, 0)];
            _lb_time.backgroundColor=[UIColor clearColor];
            _lb_time.textAlignment=NSTextAlignmentLeft;
            _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
            //            _lb_time._constrainedSize=CGSizeMake(screenShows.size.width-20, 100);
            _lb_time.text=[NSString stringWithFormat:@"%@",[NSString transFormTimeStamp:[model.time intValue]]];
            [_lb_time setNeedCoretext:NO];
            _lb_time.textColor=ColorGray;
            _lb_time.numberOfLines=0;
            
            _lb_time.lineBreakMode=NSLineBreakByCharWrapping;
            [_lb_time sizeToFitByconstrainedSize:CGSizeMake(screenShows.size.width-20, 100)];
            
            [self addSubview:_lb_time];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_time);
        }
        
    }
    
    {//分割线
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-1), self.frame.size.width, 0.5)];
        [v setBackgroundColor:ColorDivLine];
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
