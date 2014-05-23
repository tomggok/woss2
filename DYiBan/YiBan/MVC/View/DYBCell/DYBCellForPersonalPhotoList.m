//
//  DYBCellForPersonalPhotoList.m
//  DYiBan
//
//  Created by Song on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForPersonalPhotoList.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "UITableView+property.h"
#import "UIView+Gesture.h"
#import "photoList.h"
#import "UILabel+ReSize.h"


@implementation DYBCellForPersonalPhotoList

@synthesize _imgV_star;
-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    self.accessoryType = UITableViewCellAccessoryNone;
    
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, tbv._cellH)];
    if (data) {
        photoList *model = data;
        
        if (!_lb_newContent) {
            _lb_newContent = [[MagicUILabel alloc]initWithFrame:CGRectMake(66, 0, 0,0)];
            _lb_newContent.backgroundColor=[UIColor clearColor];
            _lb_newContent.textAlignment=NSTextAlignmentLeft;
            _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
            _lb_newContent.text=model.name;
            _lb_newContent.textColor=ColorBlack;
            _lb_newContent.numberOfLines=1;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
            
            
            
            _lb_newContent.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_newContent.frame.origin.x-80, 200)];
            
            [self addSubview:_lb_newContent];
            [_lb_newContent setNeedCoretext:NO];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_newContent);
        }
        
        if (!_imgV_star) {
            _imgV_star=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0,0, tbv._cellH/*-8*/,tbv._cellH/*-8*/)];
//            _imgV_star.contentMode=UIViewContentModeScaleToFill;
            [_imgV_star setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"btn_msg_high.png"]];
            [self addSubview:_imgV_star];
            
            
            RELEASE(_imgV_star);
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, _lb_newContent.frame.size.height+30)];
        [_imgV_star setFrame:CGRectMake(0,-1, CGRectGetHeight(self.frame),CGRectGetHeight(self.frame))];
        [_lb_newContent changePosInSuperViewWithAlignment:1];
        
        
        
        if (!_lb_photolistnum) {
            
            _lb_photolistnum = [[MagicUILabel alloc]initWithFrame:CGRectMake(_lb_newContent.frame.origin.x+_lb_newContent.frame.size.width+10, 0, 0,0)];
            _lb_photolistnum.backgroundColor=[UIColor clearColor];
            _lb_photolistnum.textAlignment=NSTextAlignmentLeft;
            _lb_photolistnum.font=[DYBShareinstaceDelegate DYBFoutStyle:17];
            _lb_photolistnum.text=[@"" stringByAppendingFormat:@"(%@)",model.pic_num];
            _lb_photolistnum.textColor=[UIColor colorWithWhite:0.498 alpha:1.0];
            _lb_photolistnum.numberOfLines=2;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
            
            _lb_photolistnum.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_photolistnum sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_newContent.frame.origin.x-80, 200)];
            
            [self addSubview:_lb_photolistnum];
            [_lb_photolistnum setNeedCoretext:NO];
            [_lb_photolistnum changePosInSuperViewWithAlignment:1];
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_photolistnum);

            
        }
        
        
        {//分割线
            UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-1), self.frame.size.width, 0.5)];
            [v setBackgroundColor:ColorDivLine];
            [self addSubview:v];
            RELEASE(v);
        }
        
        
        {
            UIImage *arrowImage = [UIImage imageNamed:@"list_arrow"];
            _arrowImv = [[MagicUIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-24, (self.frame.size.height-arrowImage.size.height/2)/2, arrowImage.size.width/2, arrowImage.size.height/2)];
            _arrowImv.image = arrowImage;
            [self addSubview:_arrowImv];
            RELEASE(_arrowImv);
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
