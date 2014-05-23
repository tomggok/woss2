//
//  DYBCellForSchoolList.m
//  DYiBan
//
//  Created by Song on 13-9-3.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForSchoolList.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "UITableView+property.h"
#import "UIView+Gesture.h"
#import "scrollerData.h"
#import "UILabel+ReSize.h"

@implementation DYBCellForSchoolList
@synthesize _imgV_star;
-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    self.accessoryType = UITableViewCellAccessoryNone;
    
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, tbv._cellH)];
    if (data) {
        scrollerData *model = data;
        
        if (!_lb_newContent) {
            _lb_newContent = [[MagicUILabel alloc]initWithFrame:CGRectMake(50, 0, 0,0)];
            _lb_newContent.backgroundColor=[UIColor clearColor];
            _lb_newContent.textAlignment=NSTextAlignmentLeft;
            _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
            _lb_newContent.text=model.name;
            _lb_newContent.textColor=ColorBlack;
            _lb_newContent.numberOfLines=2;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
            
            _lb_newContent.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_newContent.frame.origin.x-80, 200)];
            
            [self addSubview:_lb_newContent];
            [_lb_newContent setNeedCoretext:NO];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_newContent);
        }
        
        if (!_imgV_star) {
            UIImage *img = [UIImage imageNamed:@"radio_off"];
            _imgV_star=[[MagicUIImageView alloc]initWithFrame:CGRectMake(10,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            RELEASE(_imgV_star);
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, _lb_newContent.frame.size.height+30)];
        [_lb_newContent changePosInSuperViewWithAlignment:1];
        
        {//分割线
            UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-1), self.frame.size.width, 0.5)];
            [v setBackgroundColor:[MagicCommentMethod colorWithHex:@"0xeeeeee"]];
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
