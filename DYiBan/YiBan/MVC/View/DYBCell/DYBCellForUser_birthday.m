//
//  DYBCellForUser_birthday.m
//  DYiBan
//
//  Created by zhangchao on 13-9-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForUser_birthday.h"
#import "DYBCustomLabel.h"
#import "user_birthday.h"
#import "UITableView+property.h"
#import "UIView+MagicCategory.h"

@interface DYBCellForUser_birthday ()
{
    MagicUIImageView *_imgV_icon,*_imgV_head;
    DYBCustomLabel *_lb_newContent,*_lb_nickName;
}


@end

@implementation DYBCellForUser_birthday

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    //    self.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, tbv._cellH)];
    if (data) {
        user_birthday *model=data;
        
        if (!_imgV_head) {
            _imgV_head=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15,0, 50,50) backgroundColor:[UIColor clearColor] image:_imgV_head.image isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            _imgV_head.needRadius=YES;
            RELEASE(_imgV_head);
            
            [_imgV_head setImgWithUrl:model.avatar defaultImg:no_pic_50];
        }
        
        if (!_lb_nickName) {
            _lb_nickName=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_imgV_head.frame.origin.x+_imgV_head.frame.size.width+10, 15, 0, 0)];
            _lb_nickName.backgroundColor=[UIColor clearColor];
            _lb_nickName.textAlignment=NSTextAlignmentLeft;
            _lb_nickName.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
            _lb_nickName.text=model.name;
            [_lb_nickName setNeedCoretext:NO];
            _lb_nickName.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
            _lb_nickName.numberOfLines=1;
            
            _lb_nickName.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_nickName sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_nickName.frame.origin.x-30, 100)];
            
            [self addSubview:_lb_nickName];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_nickName);
        }
        
        if (!_lb_newContent) {
            _lb_newContent=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_nickName.frame.origin.y+_lb_nickName.frame.size.height+4, /*self.frame.size.width-_lb_nickName.frame.origin.x-80, _lb_nickName.frame.size.height*/ 0,0)];
            _lb_newContent.backgroundColor=[UIColor clearColor];
            _lb_newContent.textAlignment=NSTextAlignmentLeft;
            _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
            if ([model.days intValue]<7) {
                if ([model.days intValue]<=0){
                    _lb_newContent.text=@"今天过生日";
                }else{
                    _lb_newContent.text=[NSString stringWithFormat:@"%@天后过生日",model.days];
                }
            }else{
                _lb_newContent.text=[NSString stringWithFormat:@"%@ 生日",model.birtyday];
            }
            _lb_newContent.textColor=ColorGray;
            _lb_newContent.numberOfLines=1;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
            
            _lb_newContent.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-200, 100)];
            
            [self addSubview:_lb_newContent];
            [_lb_newContent setNeedCoretext:NO];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_newContent);
        }
        
        if (!_imgV_icon) {
            UIImage *img=[UIImage imageNamed:@"grzy_14"];
            _imgV_icon=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-15-img.size.width/2,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            RELEASE(_imgV_icon);
            
            [_imgV_icon creatExpandGestureAreaView];
            [_imgV_icon.v_expandGestureArea addSignal:[UIView TAP] object:model target:nil];
            
//            {
//                UIView *v=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_imgV_icon.frame)-CGRectGetWidth(_imgV_icon.frame)/2, CGRectGetMinY(_imgV_icon.frame)-CGRectGetHeight(_imgV_icon.frame)/2, CGRectGetWidth(_imgV_icon.frame)*2, CGRectGetHeight(_imgV_icon.frame)*2)];
//                [self addSubview:v];
////                v.backgroundColor=[UIColor redColor];
////                v.alpha=0.5;
//                RELEASE(v);
//                [v addSignal:[UIView TAP] object:model target:nil];
//            }
//            [_imgV_icon addSignal:[UIView TAP] object:model target:nil];
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
