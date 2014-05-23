//
//  DYBCellForFriendList.m
//  DYiBan
//
//  Created by zhangchao on 13-8-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForFriendList.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "UIImageView+WebCache.h"
#import "friends.h"
#import "UITableView+property.h"

@implementation DYBCellForFriendList

@synthesize imgV_showImg=_imgV_showImg,bEnterDataBank = _bEnterDataBank,indexPath = _indexPath ,arrayCollect = _arrayCollect,type=_type,dictSelectResult = _dictSelectResult;

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    //    self.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, tbv._cellH)];
    
    if (data) {
        friends *model=data;
        
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
//                [_imgV_showImg setFrame:CGRectMake(_imgV_showImg.frame.origin.x, tbv._cellH/2-_imgV_showImg.frame.size.height/2, _imgV_showImg.frame.size.width, _imgV_showImg.frame.size.height)];
//            }
            
            
//             MagicUIBlurView *blurView = [[MagicUIBlurView alloc] initWithFrame:_imgV_showImg.bounds];
//             blurView.originalImage = [UIImage imageNamed:@"midface_mask_def"];
//             blurView.isGlassEffectOn = YES;
//             [blurView setBlurLevel:.8f];
//             
//             [_imgV_showImg addSubview:blurView];
//             RELEASE(blurView);
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
            [_lb_nickName sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-200, 100)];
            
            [self addSubview:_lb_nickName];
            
            [_lb_nickName changePosInSuperViewWithAlignment:1];
            
            [_lb_nickName setFrame:CGRectMake(CGRectGetMinX(_lb_nickName.frame), CGRectGetMinY(_lb_nickName.frame)-5, CGRectGetWidth(_lb_nickName.frame), CGRectGetHeight(_lb_nickName.frame))];
            RELEASE(_lb_nickName);
        }
        
        if (!_lb_newContent && model.desc) {
            _lb_newContent=[[MagicUILabel alloc]initWithFrame:CGRectMake(_lb_nickName.frame.origin.x, _lb_nickName.frame.origin.y+_lb_nickName.frame.size.height+2, /*self.frame.size.width-_lb_nickName.frame.origin.x-80, _lb_nickName.frame.size.height*/ 0,0)];
            _lb_newContent.backgroundColor=[UIColor clearColor];
            _lb_newContent.textAlignment=NSTextAlignmentLeft;
            _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
//            _lb_newContent._constrainedSize=CGSizeMake(screenShows.size.width-40, 100);
            _lb_newContent.text=model.desc;
            _lb_newContent.textColor=[MagicCommentMethod color:170 green:170 blue:170 alpha:1];
            _lb_newContent.numberOfLines=1;//只一行时不能用 sizeToFitByconstrainedSize 方法,并要设置 宽高
            
            _lb_newContent.lineBreakMode=NSLineBreakByTruncatingTail;
            [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-200, 100)];
            
            [self addSubview:_lb_newContent];
            [_lb_newContent setNeedCoretext:NO];
            
            //        [_lb_nickName changePosInSuperViewWithAlignment:1];
            RELEASE(_lb_newContent);
        }
    
        if (!_bEnterDataBank) {
            
            switch (_type) {
                case 0://好友cell
                {
                    if(!_bt_private){
                        UIImage *img= [UIImage imageNamed:@"btn_list_msg_def"];
                        _bt_private = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-20-50-8-50, _imgV_showImg.frame.origin.y,/*img.size.width/4, img.size.height/4*/ 50,50)];
                        _bt_private.tag=-1;
                        _bt_private.backgroundColor=[UIColor clearColor];
                        [_bt_private addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:model];
                        [_bt_private setImage:img forState:UIControlStateNormal];
                        [_bt_private setImage:[UIImage imageNamed:@"btn_list_msg_high"] forState:UIControlStateHighlighted];
                        //        [_bt_private setImageEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
                        [self addSubview:_bt_private];
                        //        [_bt_private changePosInSuperViewWithAlignment:1];
                        RELEASE(_bt_private);
                    }
                    
                    if(!_bt_call){
                        UIImage *img=nil;
                        if (!model.phone||model.phone.length==1) {
                            img=[UIImage imageNamed:@"btn_list_call_dis"];
                        }else{
                            img=[UIImage imageNamed:@"btn_list_call_def"];
                        }
                        
                        _bt_call = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_private.frame.origin.x+_bt_private.frame.size.width, _bt_private.frame.origin.y,_bt_private.frame.size.width, _bt_private.frame.size.height)];
                        _bt_call.tag=-2;
                        _bt_call.backgroundColor=[UIColor clearColor];
                        [_bt_call setImage:img forState:UIControlStateNormal];
                        [_bt_call setImage:[UIImage imageNamed:@"btn_list_call_high"] forState:UIControlStateHighlighted];
                        
                        if (!model.phone||model.phone.length==1) {
                            [_bt_call setImage:[UIImage imageNamed:@"btn_list_call_dis"] forState:UIControlStateHighlighted];
                            
                        }else{
                            [_bt_call addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:model];
                        }
                       
                        //            [_bt_call setImageEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
                        [self.contentView addSubview:_bt_call];
                        //        [_bt_call changePosInSuperViewWithAlignment:1];
                        RELEASE(_bt_call);
                    }
                }
                    break;
                case 1://选择联系人cell
                {
//                    if (!_imgV_selectImg) {
//                        _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15,0, 50,50) backgroundColor:[UIColor clearColor] image:_imgV_showImg.image isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
//                        _imgV_showImg.needRadius=YES;
//                        RELEASE(_imgV_showImg);
//                    }
                }
                default:
                    break;
            }
        
  
                
        }else{//资料库 的共享cell
        
            UIButton *  btnisSelect = [[UIButton alloc]initWithFrame:CGRectMake(270.0f, (CGRectGetHeight(self.frame) - 16)/2, 16, 16.0f)];
            [btnisSelect setBackgroundImage:[UIImage imageNamed:@"btn_check_no"] forState:UIControlStateNormal];
            [btnisSelect setBackgroundImage:[UIImage imageNamed:@"btn_check_yes"] forState:UIControlStateSelected];
            [btnisSelect setBackgroundColor:[UIColor clearColor]];
            [btnisSelect setTag:88];
            [btnisSelect setUserInteractionEnabled:NO];
            
            if ([model.is_shared boolValue]) {
                
                [btnisSelect setSelected:YES];
                 int num = _indexPath.section * 1000 +_indexPath.row;
                [_dictSelectResult setValue:model.id forKey:[NSString stringWithFormat:@"%d",num]];
                
            }else{
                
                [btnisSelect setSelected:NO];
            }
            
            
            
            NSArray *array = _arrayCollect;
            
            for (NSIndexPath * i in array) {
                if ([i isEqual:_indexPath]) {
                    
                    [btnisSelect setSelected:YES];
                    
                }
            }
            
            [self addSubview:btnisSelect];
            [btnisSelect release];
        
        
        
        }
    {//分割线
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-1), self.frame.size.width, 0.5f)];
        [v setBackgroundColor:ColorCellSepL];
        [self addSubview:v];
        RELEASE(v);
    }
    
    }
    
//    {//选中色
//        UIView *v=[[UIView alloc]initWithFrame:self.bounds];
//        v.backgroundColor=BKGGray;
//        self.selectedBackgroundView=v;
//        RELEASE(v);
//    }
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
//    self.selectedBackgroundView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
//    self.selectedBackgroundView.backgroundColor = ColorGray;
    

}

-(void)dealloc
{
    [super dealloc];
}

@end
