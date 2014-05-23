//
//  DYBCellForPersonalHomePage.m
//  DYiBan
//
//  Created by zhangchao on 13-9-4.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForPersonalHomePage.h"
#import "UIView+MagicCategory.h"
#import "status.h"
#import "UITableView+property.h"
#import "NSString+Count.h"
#import "DYBCellForDynamic.h"
#import "DYBDynamicViewController.h"
#import "good_num_info.h"
#import "comment_num_info.h"
#import "UIView+Animations.h"
#import "UITableViewCell+MagicCategory.h"

@implementation DYBCellForPersonalHomePage

@synthesize imgV_head=_imgV_head,bt_pushUpNumsArea=_bt_pushUpNumsArea,bt_stamp=_bt_stamp;

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
//    self.index=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//    [self.index retain];
    
    switch (indexPath.row) {
        case 0://透明展示图
        {
            MagicUIScrollView *scrV=data;
            
            self.backgroundColor             = [UIColor clearColor];
            self.contentView.backgroundColor = [UIColor clearColor];
//
            [self setFrame:CGRectMake(0, 0, tbv.frame.size.width, CGRectGetHeight(scrV.frame))];
            [self.contentView addSubview:scrV];
//            RELEASE(scrV);
            
        }
            break;
        case 1://头像|顶等
        {
            [self setHeadArea:data tbv:tbv];
        }
            break;
            
            default://>=2号的cell
        {
            self.backgroundColor             = [UIColor whiteColor];
            self.contentView.backgroundColor = [UIColor whiteColor];
            
            if ([data isKindOfClass:[status class]] && ((status *)data).type==-1) {
                [self creatYearMonthCell:((status *)data)];
                
            }else if ([data isKindOfClass:[status class]] && ((status *)data).type==-2) {//生日提醒cell
                [self creatBirthdayCell:((status *)data)];
                
            }else if ([data isKindOfClass:[status class]] && ((status *)data).type==-3) {//无数据提示cell
                [self creatNodataCell:((status *)data)];
                
            }else{
                [self creatStatusCell:((NSMutableArray *)data) index:indexPath tbv:tbv];
            }
            

        }
            break;
    }
}

#pragma mark- 刷新头像等UI
-(void)refreshUi:(id)data tbv:(UITableView *)tbv{
    user *model_user=data;
    [_imgV_head setImgWithUrl:model_user.pic_s defaultImg:no_pic_50];
    
    _lb_sign.text=model_user.desc;
    [_lb_sign sizeToFitByconstrainedSize:CGSizeMake(_lb_sign.frame.size.width, _lb_sign.frame.size.height)];
    [_lb_sign replaceEmojiandTarget:NO];
//    [_lb_sign changePosInSuperViewWithAlignment:2];
    [_v_sepLine1 setFrame:CGRectMake(0, _lb_sign.frame.origin.y+_lb_sign.frame.size.height+15, _v_sepLine1.frame.size.width, _v_sepLine1.frame.size.height)];
    
    [_bt_friend setFrame:CGRectMake(_bt_friend.frame.origin.x, _v_sepLine1.frame.origin.y+_v_sepLine1.frame.size.height, _bt_friend.frame.size.width, _bt_friend.frame.size.height)];
    [_bt_visitor setFrame:CGRectMake(_bt_visitor.frame.origin.x, _bt_friend.frame.origin.y, _bt_visitor.frame.size.width, _bt_visitor.frame.size.height)];
    [_bt_PhotoAlbum setFrame:CGRectMake(_bt_PhotoAlbum.frame.origin.x, _bt_friend.frame.origin.y, _bt_PhotoAlbum.frame.size.width, _bt_PhotoAlbum.frame.size.height)];
    [_bt_datum setFrame:CGRectMake(_bt_datum.frame.origin.x, _bt_friend.frame.origin.y, _bt_datum.frame.size.width, _bt_datum.frame.size.height)];
    [_v_sepL setFrame:CGRectMake(0, _bt_datum.frame.origin.y+_bt_datum.frame.size.height, _v_sepLine1.frame.size.width, _v_sepLine1.frame.size.height)];

    [self setFrame:CGRectMake(0, 0, self.frame.size.width, _v_sepL.frame.origin.y+_v_sepL.frame.size.height)];
}


#pragma mark- 设置1号cell
-(void)setHeadArea:(id)data tbv:(UITableView *)tbv
{
    user *model_user=data;
    
//    if (self.clipsToBounds) {
//        self.clipsToBounds=NO;
//    }
    
    self.backgroundColor             = ColorWhite;
    self.contentView.backgroundColor = ColorWhite;
    [self setFrame:CGRectMake(0, 0, tbv.frame.size.width, 190)];
    
    if(!_imgV_headBack){//头像背景
//        UIImage *img=[UIImage imageNamed:@"no_pic_50.png"];
        _imgV_headBack = [[MagicUIImageView alloc] initWithFrame:CGRectMake(10, -30, 80,80) backgroundColor:[UIColor whiteColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        [_imgV_headBack setNeedRadius:YES];
//        _imgV_headBack.center=CGPointMake(self.center.x, 0);
        RELEASE(_imgV_headBack);
        
//        if (_imgV_headBack.clipsToBounds) {
//            _imgV_headBack.clipsToBounds=NO;
//        }
    }
    
    if(!_imgV_head){//头像
        UIImage *img=[UIImage imageNamed:@"no_pic_50.png"];
        _imgV_head = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, 0, 75,75) backgroundColor:[UIColor whiteColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_imgV_headBack Alignment:2 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        [_imgV_head setNeedRadius:YES];
//        _imgV_head.layer.borderWidth=4;
//        _imgV_head.layer.borderColor=ColorWhite.CGColor;
        
        _imgV_head.tag=7;
        [_imgV_head addSignal:[UIView TAP] object:nil];
//        {
//            MagicUIButton *bt=[[MagicUIButton alloc]initWithFrame:_imgV_head.bounds];
//            bt.backgroundColor=[UIColor redColor];
//            [bt addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
//            [_imgV_head addSubview:bt];
//            bt.tag=15;
//            RELEASE(bt);
//        }
        if ([data isKindOfClass:[user class]]) {
            [_imgV_head setImgWithUrl:model_user.pic_s defaultImg:no_pic_50];
        }
//        _imgV_head.center=CGPointMake(self.center.x, 0);
        RELEASE(_imgV_head);
        
        
//        if (_imgV_head.clipsToBounds) {
//            _imgV_head.clipsToBounds=NO;
//        }
        
//        [self pushUp_stampAnimation:model_user];

    }else if([data isKindOfClass:[user class]]){
        [_imgV_head setImgWithUrl:model_user.pic_s defaultImg:no_pic_50];
        
    }
    
    
//    if(!_bt_pushUpNumsArea){//顶的人数区域
//        UIImage *img= [UIImage imageNamed:@"grzy_5"];
//        _bt_pushUpNumsArea = [[MagicUIButton alloc] initWithFrame:CGRectMake(12, 11, img.size.width/2, img.size.height/2)];
//        _bt_pushUpNumsArea.tag=-8;
//        [_bt_pushUpNumsArea addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:nil];
//        [_bt_pushUpNumsArea setBackgroundImage:img forState:UIControlStateNormal];
//        [_bt_pushUpNumsArea setTitle:(([data isKindOfClass:[user class]])?(model_user.avatarTopCount):(@"0"))];
//        _bt_pushUpNumsArea.showsTouchWhenHighlighted=YES;
//        [_bt_pushUpNumsArea setTitleColor:[UIColor whiteColor]];
//        [_bt_pushUpNumsArea setTitleFont:/*[DYBShareinstaceDelegate DYBFoutStyle:15]*/ [UIFont systemFontOfSize:15]];
////        [_bt_pushUpNumsArea setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
//        _bt_pushUpNumsArea.backgroundColor=[UIColor clearColor];
//        [self addSubview:_bt_pushUpNumsArea];
//        //                [_bt_noInfo changePosInSuperViewWithAlignment:2];
//        RELEASE(_bt_pushUpNumsArea);
//    }
    
//    if(!_bt_pushUp){//顶
//        UIImage *img= [UIImage imageNamed:@"grzy_6"];
//        _bt_pushUp = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_pushUpNumsArea.frame.origin.x+_bt_pushUpNumsArea.frame.size.width-2, _bt_pushUpNumsArea.frame.origin.y, img.size.width/2,img.size.height/2)];
//        _bt_pushUp.tag=-6;
//        [_bt_pushUp addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:nil];
//        [_bt_pushUp setBackgroundImage:img forState:UIControlStateNormal];
//        [_bt_pushUp setTitle:@"顶"];
//        [_bt_pushUpNumsArea setTitleFont:/*[DYBShareinstaceDelegate DYBFoutStyle:15]*/ [UIFont systemFontOfSize:15]];
//        _bt_pushUp.showsTouchWhenHighlighted=YES;
//        [_bt_pushUp setTitleColor:[UIColor whiteColor]];
//        _bt_pushUp.backgroundColor=[UIColor clearColor];
//        [self addSubview:_bt_pushUp];
//        //                [_bt_noInfo changePosInSuperViewWithAlignment:2];
//        RELEASE(_bt_pushUp);
//    }
    
//    if(!_bt_stamp){//踩
//        UIImage *img= [UIImage imageNamed:@"grzy_7"];
//        _bt_stamp = [[MagicUIButton alloc] initWithFrame:CGRectMake(_imgV_headBack.frame.origin.x+_imgV_headBack.frame.size.width+5, _bt_pushUp.frame.origin.y, _bt_pushUp.frame.size.width, _bt_pushUp.frame.size.height)];
//        _bt_stamp.tag=-7;
//        [_bt_stamp addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:nil];
//        [_bt_stamp setBackgroundImage:img forState:UIControlStateNormal];
//        [_bt_stamp setTitle:@"踩"];
//        [_bt_stamp setTitleFont:/*[DYBShareinstaceDelegate DYBFoutStyle:15]*/ [UIFont systemFontOfSize:15]];
//        _bt_stamp.showsTouchWhenHighlighted=YES;
//        [_bt_stamp setTitleColor:[UIColor whiteColor]];
//        _bt_stamp.backgroundColor=[UIColor clearColor];
//        [self addSubview:_bt_stamp];
//        //                [_bt_noInfo changePosInSuperViewWithAlignment:2];
//        RELEASE(_bt_stamp);
//    }
    
//    if(!_bt_stampNumsArea){//踩的人数区域
//        UIImage *img= [UIImage imageNamed:@"grzy_8"];
//        _bt_stampNumsArea = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_stamp.frame.origin.x+_bt_stamp.frame.size.width-1, _bt_stamp.frame.origin.y, _bt_pushUpNumsArea.frame.size.width, _bt_pushUpNumsArea.frame.size.height)];
//        _bt_stampNumsArea.tag=-9;
//        [_bt_stampNumsArea addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:nil];
//        [_bt_stampNumsArea setBackgroundImage:img forState:UIControlStateNormal];
//        [_bt_stampNumsArea setTitle:(([data isKindOfClass:[user class]])?(model_user.avatarTreadCount):(@"0"))];
//        [_bt_stampNumsArea setTitleFont:/*[DYBShareinstaceDelegate DYBFoutStyle:15]*/ [UIFont systemFontOfSize:15]];
//        _bt_stampNumsArea.showsTouchWhenHighlighted=YES;
//        [_bt_stampNumsArea setTitleColor:[UIColor whiteColor]];
//        _bt_stampNumsArea.backgroundColor=[UIColor clearColor];
//        [self addSubview:_bt_stampNumsArea];
//        //                [_bt_noInfo changePosInSuperViewWithAlignment:2];
//        RELEASE(_bt_stampNumsArea);
//    }
    
    if (!_v_sign) {//心情签名背景
        UIImage *img=[UIImage imageNamed:@"bg_sign"];
        _v_sign=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imgV_head.frame)+5, 15, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleToFill stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        _v_sign.tag=-1;
        [_v_sign addSignal:[UIView TAP] object:nil];
        [self addSubview:_v_sign];
//        [_v_sign changePosInSuperViewWithAlignment:0];
        RELEASE(_v_sign);
    }
    
//    if (!_imgV_signRightView) {/*签名右边的图标*/
//        UIImage *img=[UIImage imageNamed:@"grzy_13"];
//        _imgV_signRightView=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_v_sign.frame)-img.size.width/2-5, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_v_sign Alignment:1 contentMode:UIViewContentModeScaleToFill stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
////        _imgV_signRightView.tag=0;
////        [_v_sign addSignal:[UIView TAP] object:nil];
////        [_v_sign addSubview:_imgV_signRightView];
//        //        [_v_sign changePosInSuperViewWithAlignment:0];
//        RELEASE(_imgV_signRightView);
//    }
    
    if (!_lb_sign) {//签名
        _lb_sign=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_v_sign.frame)+25, CGRectGetMinY(_v_sign.frame)+10, CGRectGetWidth(_v_sign.frame)-40,CGRectGetHeight(_v_sign.frame))];
        _lb_sign._originFrame=CGRectMake(15, 0, CGRectGetWidth(_v_sign.frame)-30,CGRectGetHeight(_v_sign.frame));
        _lb_sign.backgroundColor=[UIColor clearColor];
        _lb_sign.textAlignment=NSTextAlignmentLeft;
        _lb_sign.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
        _lb_sign.text=(([model_user isKindOfClass:[user class]] && ![[model_user.desc TrimmingStringBywhitespaceCharacterSet] isEqualToString:@""])?(model_user.desc):(@"签名就是用来随便写的"));
        _lb_sign.textColor=ColorGray;
        _lb_sign.numberOfLines=2;
        _lb_sign.maxLineNum=3;//只一行
        _lb_sign.lineBreakMode=NSLineBreakByWordWrapping;
        [_lb_sign sizeToFitByconstrainedSize:CGSizeMake(_lb_sign.frame.size.width, _lb_sign.frame.size.height)];
        [_lb_sign replaceEmojiandTarget:NO];
        //                        [_lb_sign setNeedCoretext:YES];
//        _lb_sign.tag=0;
//        [_lb_sign addSignal:[UIView TAP] object:nil];
        [self addSubview:_lb_sign];
//        [_lb_sign changePosInSuperViewWithAlignment:2];
        RELEASE(_lb_sign);
        
        [_v_sign setFrame:CGRectMake(CGRectGetMinX(_v_sign.frame), CGRectGetMinY(_lb_sign.frame)-5, CGRectGetWidth(_v_sign.frame), CGRectGetHeight(_lb_sign.frame)+10)];
//        [_imgV_signRightView setFrame:CGRectMake(CGRectGetMaxX(_imgV_head.frame)+5, 15, img.size.width/2, img.size.height/2)];
    }
    
    
    if (!_v_sepLine1) {/*签名下边的第一条横的分割线*/
        _v_sepLine1=[[UIView alloc]initWithFrame:CGRectMake(0, _v_sign.frame.origin.y+_v_sign.frame.size.height+15, self.frame.size.width, 2)];
        _v_sepLine1.backgroundColor=ColorCellSepL;
        [self addSubview:_v_sepLine1];
        RELEASE(_v_sepLine1);
    }
    
//    if (!_v_sepLine2) {/*头像下边的竖线*/
//        _v_sepLine2=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_imgV_head.frame)+CGRectGetWidth(_imgV_head.frame)/2, CGRectGetMaxY(_imgV_headBack.frame), 2, CGRectGetMinY(_v_sepLine1.frame)-CGRectGetMaxY(_imgV_headBack.frame))];
//        _v_sepLine2.backgroundColor=ColorCellSepL;
//        _v_sepLine2.center=CGPointMake(_imgV_headBack.center.x, _v_sepLine2.center.y);
//        [self addSubview:_v_sepLine2];
//        RELEASE(_v_sepLine2);
//    }
    
    if(!_bt_friend){//好友
        //                UIImage *img= [UIImage imageNamed:@"noinfo.png"];
        _bt_friend = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, _v_sepLine1.frame.origin.y+_v_sepLine1.frame.size.height, self.frame.size.width/4, 50)];
        _bt_friend.tag=-1;
        [_bt_friend addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:nil];
        //                [_bt_noInfo setBackgroundImage:img forState:UIControlStateNormal];
//        [_bt_friend setTitle:@"好友"];
//        [_bt_friend setTitleColor:[UIColor yellowColor]];
        _bt_friend.backgroundColor=[UIColor clearColor];
        [self addSubview:_bt_friend];
        //                [_bt_noInfo changePosInSuperViewWithAlignment:2];
        RELEASE(_bt_friend);
        
        {//
            DYBCustomLabel *lb_friends=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 7, 290,1000)];
            lb_friends._originFrame=CGRectMake(0, 5, 290,1000);
            lb_friends.backgroundColor=[UIColor clearColor];
            lb_friends.textAlignment=NSTextAlignmentLeft;
            lb_friends.font=[DYBShareinstaceDelegate DYBFoutStyle:16];
            lb_friends.text=@"好友";
            lb_friends.textColor=ColorBlack;
            lb_friends.numberOfLines=1;
            lb_friends.lineBreakMode=NSLineBreakByTruncatingTail;
            [lb_friends sizeToFitByconstrainedSize:CGSizeMake(lb_friends.frame.size.width, lb_friends.frame.size.height)];
//            [lb_friends replaceEmojiandTarget:NO];
            //                        [_lb_sign setNeedCoretext:YES];
//            lb_friends.tag=0;
//            [lb_friends addSignal:[UIView TAP] object:nil];
            [_bt_friend addSubview:lb_friends];
            [lb_friends changePosInSuperViewWithAlignment:0];
            RELEASE(lb_friends);
            
            
            {//好友数量
                DYBCustomLabel *lb_friendsNums=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, lb_friends.frame.origin.y+lb_friends.frame.size.height+5, 290,1000)];
                lb_friendsNums._originFrame=CGRectMake(0, 5, 290,1000);
                lb_friendsNums.backgroundColor=[UIColor clearColor];
                lb_friendsNums.textAlignment=NSTextAlignmentLeft;
                lb_friendsNums.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
                lb_friendsNums.text=(([model_user isKindOfClass:[user class]])?(model_user.friend_num):(@""));
                lb_friendsNums.textColor=ColorGray;
                lb_friendsNums.numberOfLines=1;
                lb_friendsNums.lineBreakMode=NSLineBreakByTruncatingTail;
                [lb_friendsNums sizeToFitByconstrainedSize:CGSizeMake(lb_friendsNums.frame.size.width, lb_friendsNums.frame.size.height)];
                //            [lb_friends replaceEmojiandTarget:NO];
                //                        [_lb_sign setNeedCoretext:YES];
                //            lb_friends.tag=0;
                //            [lb_friends addSignal:[UIView TAP] object:nil];
                [_bt_friend addSubview:lb_friendsNums];
                [lb_friendsNums changePosInSuperViewWithAlignment:0];
                RELEASE(lb_friendsNums);
            }
            
            
        }
        
    {//竖线
        UIImage *img=[UIImage imageNamed:@"grzy_15_03.png"];
        MagicUIImageView *imgV = [[MagicUIImageView alloc] initWithFrame:CGRectMake(_bt_friend.frame.size.width-img.size.width/4, 0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor whiteColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_bt_friend Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        //        _imgV_head.center=CGPointMake(self.center.x, 0);
        RELEASE(imgV);
    }
    }

    if(!_bt_visitor){//访客
        //                UIImage *img= [UIImage imageNamed:@"noinfo.png"];
        _bt_visitor = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_friend.frame.origin.x+_bt_friend.frame.size.width, _bt_friend.frame.origin.y, _bt_friend.frame.size.width, _bt_friend.frame.size.height)];
        _bt_visitor.tag=-2;
        [_bt_visitor addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:nil];
        //                [_bt_noInfo setBackgroundImage:img forState:UIControlStateNormal];
//        [_bt_visitor setTitle:@"访客"];
//        [_bt_visitor setTitleColor:[UIColor yellowColor]];
        _bt_visitor.backgroundColor=[UIColor clearColor];
        [self addSubview:_bt_visitor];
        //                [_bt_noInfo changePosInSuperViewWithAlignment:2];
        RELEASE(_bt_visitor);
        
        {//
            DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 7, 290,1000)];
            lb._originFrame=CGRectMake(0, 5, 290,1000);
            lb.backgroundColor=[UIColor clearColor];
            lb.textAlignment=NSTextAlignmentLeft;
            lb.font=[DYBShareinstaceDelegate DYBFoutStyle:16];
            lb.text=@"访客";
            lb.textColor=ColorBlack;
            lb.numberOfLines=1;
            lb.lineBreakMode=NSLineBreakByTruncatingTail;
            [lb sizeToFitByconstrainedSize:CGSizeMake(lb.frame.size.width, lb.frame.size.height)];
            //            [lb_friends replaceEmojiandTarget:NO];
            //                        [_lb_sign setNeedCoretext:YES];
            //            lb_friends.tag=0;
            //            [lb_friends addSignal:[UIView TAP] object:nil];
            [_bt_visitor addSubview:lb];
            [lb changePosInSuperViewWithAlignment:0];
            RELEASE(lb);
            
            
            {//访客数量
                DYBCustomLabel *lb_nums=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, lb.frame.origin.y+lb.frame.size.height+5, 290,1000)];
                lb_nums._originFrame=CGRectMake(0, 5, 290,1000);
                lb_nums.backgroundColor=[UIColor clearColor];
                lb_nums.textAlignment=NSTextAlignmentLeft;
                lb_nums.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
                lb_nums.text=(([model_user isKindOfClass:[user class]])?(model_user.visit_num):(@""));
                lb_nums.textColor=ColorGray;
                lb_nums.numberOfLines=1;
                lb_nums.lineBreakMode=NSLineBreakByTruncatingTail;
                [lb_nums sizeToFitByconstrainedSize:CGSizeMake(lb_nums.frame.size.width, lb_nums.frame.size.height)];
                //            [lb_friends replaceEmojiandTarget:NO];
                //                        [_lb_sign setNeedCoretext:YES];
                //            lb_friends.tag=0;
                //            [lb_friends addSignal:[UIView TAP] object:nil];
                [_bt_visitor addSubview:lb_nums];
                [lb_nums changePosInSuperViewWithAlignment:0];
                RELEASE(lb_nums);
            }
        }
        
        {//竖线
            UIImage *img=[UIImage imageNamed:@"grzy_15_03.png"];
            MagicUIImageView *imgV = [[MagicUIImageView alloc] initWithFrame:CGRectMake(_bt_visitor.frame.size.width-img.size.width/4, 0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor whiteColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_bt_visitor Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            //        _imgV_head.center=CGPointMake(self.center.x, 0);
            RELEASE(imgV);
        }
    }
    
    if(!_bt_PhotoAlbum){//相册
        //                UIImage *img= [UIImage imageNamed:@"noinfo.png"];
        _bt_PhotoAlbum = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_visitor.frame.origin.x+_bt_visitor.frame.size.width, _bt_visitor.frame.origin.y, _bt_visitor.frame.size.width, _bt_visitor.frame.size.height)];
        _bt_PhotoAlbum.tag=-3;
        [_bt_PhotoAlbum addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:nil];
        //                [_bt_noInfo setBackgroundImage:img forState:UIControlStateNormal];
//        [_bt_PhotoAlbum setTitle:@"相册"];
//        [_bt_PhotoAlbum setTitleColor:[UIColor yellowColor]];
//        _bt_PhotoAlbum.backgroundColor=[UIColor blackColor];
        [self addSubview:_bt_PhotoAlbum];
        //                [_bt_noInfo changePosInSuperViewWithAlignment:2];
        RELEASE(_bt_PhotoAlbum);
        
        {//
            DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 7, 290,1000)];
            lb._originFrame=CGRectMake(0, 5, 290,1000);
            lb.backgroundColor=[UIColor clearColor];
            lb.textAlignment=NSTextAlignmentLeft;
            lb.font=[DYBShareinstaceDelegate DYBFoutStyle:16];
            lb.text=@"相册";
            lb.textColor=ColorBlack;
            lb.numberOfLines=1;
            lb.lineBreakMode=NSLineBreakByTruncatingTail;
            [lb sizeToFitByconstrainedSize:CGSizeMake(lb.frame.size.width, lb.frame.size.height)];
            //            [lb_friends replaceEmojiandTarget:NO];
            //                        [_lb_sign setNeedCoretext:YES];
            //            lb_friends.tag=0;
            //            [lb_friends addSignal:[UIView TAP] object:nil];
            [_bt_PhotoAlbum addSubview:lb];
            [lb changePosInSuperViewWithAlignment:0];
            RELEASE(lb);
            
            
            {//相册数量
                DYBCustomLabel *lb_nums=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, lb.frame.origin.y+lb.frame.size.height+5, 290,1000)];
                lb_nums._originFrame=CGRectMake(0, 5, 290,1000);
                lb_nums.backgroundColor=[UIColor clearColor];
                lb_nums.textAlignment=NSTextAlignmentLeft;
                lb_nums.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
                lb_nums.text=(([model_user isKindOfClass:[user class]])?(model_user.album_num):(@""));
                lb_nums.textColor=ColorGray;
                lb_nums.numberOfLines=1;
                lb_nums.lineBreakMode=NSLineBreakByTruncatingTail;
                [lb_nums sizeToFitByconstrainedSize:CGSizeMake(lb_nums.frame.size.width, lb_nums.frame.size.height)];
                //            [lb_friends replaceEmojiandTarget:NO];
                //                        [_lb_sign setNeedCoretext:YES];
                //            lb_friends.tag=0;
                //            [lb_friends addSignal:[UIView TAP] object:nil];
                [_bt_PhotoAlbum addSubview:lb_nums];
                [lb_nums changePosInSuperViewWithAlignment:0];
                RELEASE(lb_nums);
            }
        }
        
        {//竖线
            UIImage *img=[UIImage imageNamed:@"grzy_15_03.png"];
            MagicUIImageView *imgV = [[MagicUIImageView alloc] initWithFrame:CGRectMake(_bt_PhotoAlbum.frame.size.width-img.size.width/4, 0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor whiteColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_bt_PhotoAlbum Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            //        _imgV_head.center=CGPointMake(self.center.x, 0);
            RELEASE(imgV);
        }
    }
    
    if(!_bt_datum){//资料
        //                UIImage *img= [UIImage imageNamed:@"noinfo.png"];
        _bt_datum = [[MagicUIButton alloc] initWithFrame:CGRectMake(_bt_PhotoAlbum.frame.origin.x+_bt_PhotoAlbum.frame.size.width, _bt_PhotoAlbum.frame.origin.y, _bt_PhotoAlbum.frame.size.width, _bt_PhotoAlbum.frame.size.height)];
        _bt_datum.tag=-4;
        [_bt_datum addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:nil];
        //                [_bt_noInfo setBackgroundImage:img forState:UIControlStateNormal];
//        [_bt_datum setTitle:@"资料"];
//        [_bt_datum setTitleColor:[UIColor yellowColor]];
//        _bt_datum.backgroundColor=[UIColor blackColor];
        [self addSubview:_bt_datum];
        //                [_bt_noInfo changePosInSuperViewWithAlignment:2];
        RELEASE(_bt_datum);
        
        {//
            DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 7, 290,1000)];
            lb._originFrame=CGRectMake(0, 5, 290,1000);
            lb.backgroundColor=[UIColor clearColor];
            lb.textAlignment=NSTextAlignmentLeft;
            lb.font=[DYBShareinstaceDelegate DYBFoutStyle:16];
            lb.text=@"资料";
            lb.textColor=ColorBlack;
            lb.numberOfLines=1;
            lb.lineBreakMode=NSLineBreakByTruncatingTail;
            [lb sizeToFitByconstrainedSize:CGSizeMake(lb.frame.size.width, lb.frame.size.height)];
            //            [lb_friends replaceEmojiandTarget:NO];
            //                        [_lb_sign setNeedCoretext:YES];
            //            lb_friends.tag=0;
            //            [lb_friends addSignal:[UIView TAP] object:nil];
            [_bt_datum addSubview:lb];
            [lb changePosInSuperViewWithAlignment:0];
            RELEASE(lb);
            
            
            {//资料数量
                DYBCustomLabel *lb_nums=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, lb.frame.origin.y+lb.frame.size.height+5, 290,1000)];
                lb_nums._originFrame=CGRectMake(0, 5, 290,1000);
                lb_nums.backgroundColor=[UIColor clearColor];
                lb_nums.textAlignment=NSTextAlignmentLeft;
                lb_nums.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
                lb_nums.text=(([model_user isKindOfClass:[user class]])?(model_user.info_rate):(@""));
                lb_nums.textColor=ColorGray;
                lb_nums.numberOfLines=1;
                lb_nums.lineBreakMode=NSLineBreakByTruncatingTail;
                [lb_nums sizeToFitByconstrainedSize:CGSizeMake(lb_nums.frame.size.width, lb_nums.frame.size.height)];
                //            [lb_friends replaceEmojiandTarget:NO];
                //                        [_lb_sign setNeedCoretext:YES];
                //            lb_friends.tag=0;
                //            [lb_friends addSignal:[UIView TAP] object:nil];
                [_bt_datum addSubview:lb_nums];
                [lb_nums changePosInSuperViewWithAlignment:0];
                RELEASE(lb_nums);
            }
        }
    }

    if(!_v_sepL){//分割线
        _v_sepL=[[UIView alloc]initWithFrame:CGRectMake(0, _bt_datum.frame.origin.y+_bt_datum.frame.size.height, _v_sepLine1.frame.size.width, _v_sepLine1.frame.size.height)];
        [_v_sepL setBackgroundColor:ColorCellSepL];
        [self addSubview:_v_sepL];
        RELEASE(_v_sepL);
    }
    
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, _v_sepL.frame.origin.y+_v_sepL.frame.size.height)];

}

#pragma mark- 创建只显示年月的cell
-(void)creatYearMonthCell:(status *)model
{
    self.backgroundColor             = ColorWhite;
    self.contentView.backgroundColor = ColorWhite;
    
    if(!_vVerticalLine){//竖线
        _vVerticalLine=[[UIView alloc]initWithFrame:CGRectMake(50, 0, 2, 0)];
        [_vVerticalLine setBackgroundColor:ColorCellSepL];
        [self addSubview:_vVerticalLine];
        RELEASE(_vVerticalLine);
    }
    
    if(!_imgV_icon){//
        UIImage *img=[UIImage imageNamed:@"grzy_4.png"];
        _imgV_icon = [[MagicUIImageView alloc] initWithFrame:CGRectMake(35, 20, img.size.width/2,img.size.height/2) backgroundColor:[UIColor whiteColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        //        _imgV_head.center=CGPointMake(self.center.x, 0);
        RELEASE(_imgV_icon);
    }
    
    if (!_lb_content) {
        _lb_content=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_imgV_icon.frame.origin.x+_imgV_icon.frame.size.width+15, _imgV_icon.frame.origin.y, 1000,110)];
        _lb_content.backgroundColor=[UIColor whiteColor];
        _lb_content.textAlignment=NSTextAlignmentLeft;
        _lb_content.font=[UIFont systemFontOfSize:18];//[DYBShareinstaceDelegate DYBFoutStyle:18];
        _lb_content.text=[NSString stringWithFormat:@"%d 月 • %d",[NSString getDateComponentsByTimeStamp:[model.time integerValue]].month,[NSString getDateComponentsByTimeStamp:[model.time integerValue]].year];
        _lb_content.textColor=ColorBlack;
        _lb_content.numberOfLines=0;
        _lb_content.lineBreakMode=NSLineBreakByCharWrapping;
//        [_lb_content sizeToFitByconstrainedSize:CGSizeMake(200/*最宽*/, 1000)];
//        [_lb_content replaceEmojiandTarget:NO];
        [self addSubview:_lb_content];
        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.time integerValue]].month)/10+1;//月份有几位
        _lb_content.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"30.f");
        _lb_content.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
        [_lb_content setNeedCoretext:YES];
//        [_lb_content changePosInSuperViewWithAlignment:1];
        
        RELEASE(_lb_content);
    }
    
    if(!_v_sepL){//分割线
        _v_sepL=[[UIView alloc]initWithFrame:CGRectMake(0, _imgV_icon.frame.origin.y+_imgV_icon.frame.size.height+20, self.frame.size.width, 1)];
        [_v_sepL setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_v_sepL];
        RELEASE(_v_sepL);
    }
    
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, _v_sepL.frame.origin.y+_v_sepL.frame.size.height)];
    [_vVerticalLine setFrame:CGRectMake(_vVerticalLine.frame.origin.x, 0, _vVerticalLine.frame.size.width, self.frame.size.height)];
    _vVerticalLine.center=CGPointMake(_imgV_icon.center.x, self.center.y);
    [_imgV_icon changePosInSuperViewWithAlignment:1];
    [_lb_content changePosInSuperViewWithAlignment:1];
}

#pragma mark- 创建无数据提示的cell
-(void)creatNodataCell:(status *)model{
    [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 160)];
    
    if (!_lb_content) {
        _lb_content=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0,0, 0,0)];
        _lb_content.backgroundColor=[UIColor clearColor];
        _lb_content.textAlignment=NSTextAlignmentLeft;
        _lb_content.font=[UIFont systemFontOfSize:16];//[DYBShareinstaceDelegate DYBFoutStyle:18];
        _lb_content.text=model.content;
        _lb_content.textColor=ColorGray;
        _lb_content.numberOfLines=1;
        _lb_content.lineBreakMode=NSLineBreakByCharWrapping;
        [_lb_content sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(self.frame),CGRectGetHeight(self.frame))];
        //        [_lb_content replaceEmojiandTarget:NO];
        [self addSubview:_lb_content];
//        _lb_content.FONT(@"0",@"1",@"30.f");
//        _lb_content.COLOR(@"4",@"1",ColorGray);
//        [_lb_content setNeedCoretext:YES];
        [_lb_content changePosInSuperViewWithAlignment:2];
        [_lb_content setFrame:CGRectMake(CGRectGetMinX(_lb_content.frame)+10, CGRectGetMinY(_lb_content.frame), CGRectGetWidth(_lb_content.frame), CGRectGetHeight(_lb_content.frame))];
        
        RELEASE(_lb_content);
    }
    
    
    {//
        UIImage *img=[UIImage imageNamed:@"ybx_small.png"];
        _imgV_icon = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_lb_content.frame)-5-img.size.width/2, CGRectGetMinY(_lb_content.frame), img.size.width/2,img.size.height/2) backgroundColor:[UIColor whiteColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        //        _imgV_head.center=CGPointMake(self.center.x, 0);
        RELEASE(_imgV_icon);
    }
}

#pragma mark- 创建生日提醒的cell
-(void)creatBirthdayCell:(status *)model
{
    self.backgroundColor             = ColorWhite;
    self.contentView.backgroundColor = ColorWhite;
    self.tag=8;
    [self addSignal:[UIView TAP] object:nil];
    
    if(!_vVerticalLine){//竖线
        _vVerticalLine=[[UIView alloc]initWithFrame:CGRectMake(50, 0, 2, 0)];
        [_vVerticalLine setBackgroundColor:ColorCellSepL];
        [self addSubview:_vVerticalLine];
        RELEASE(_vVerticalLine);
    }
    
    if(!_imgV_icon){//
        UIImage *img=[UIImage imageNamed:@"grzy_3.png"];
        _imgV_icon = [[MagicUIImageView alloc] initWithFrame:CGRectMake(35, 20, img.size.width/2,img.size.height/2) backgroundColor:[UIColor whiteColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        //        _imgV_head.center=CGPointMake(self.center.x, 0);
        RELEASE(_imgV_icon);
    }
    
    if (!_lb_content) {
        _lb_content=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_imgV_icon.frame.origin.x+_imgV_icon.frame.size.width+15, _imgV_icon.frame.origin.y, 100,110)];
        _lb_content.backgroundColor=[UIColor clearColor];
        _lb_content.textAlignment=NSTextAlignmentLeft;
        _lb_content.font=[UIFont systemFontOfSize:18];//[DYBShareinstaceDelegate DYBFoutStyle:18];
        _lb_content.text=model.content;
        _lb_content.textColor=ColorBlack;
        _lb_content.numberOfLines=0;
        _lb_content.lineBreakMode=NSLineBreakByCharWrapping;
        [_lb_content sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(self.frame)-CGRectGetMinX(_lb_content.frame), 1000)];
        //        [_lb_content replaceEmojiandTarget:NO];
        [self addSubview:_lb_content];
//        _lb_content.FONT(@"0",@"1",@"30.f");
//        _lb_content.COLOR(@"4",@"1",ColorGray);
//        [_lb_content setNeedCoretext:YES];
        //        [_lb_content changePosInSuperViewWithAlignment:1];
        
        RELEASE(_lb_content);
    }
    
    UIView *v_back=nil;
    
    {//整体背景
      v_back=[[UIView alloc]initWithFrame:CGRectMake(_imgV_icon.frame.origin.x+_imgV_icon.frame.size.width+10, CGRectGetMinY(_lb_content.frame)-10, 230, CGRectGetHeight(_lb_content.frame)+20)];
        v_back.backgroundColor=ColorSlightGray;
        v_back.layer.masksToBounds=YES;
        v_back.layer.cornerRadius=5;
        [self insertSubview:v_back belowSubview:_lb_content];
        RELEASE(v_back);
       
    }
    
//    if(!_v_sepL){//分割线
//        _v_sepL=[[UIView alloc]initWithFrame:CGRectMake(0, _imgV_icon.frame.origin.y+_imgV_icon.frame.size.height+20, self.frame.size.width, 1)];
//        [_v_sepL setBackgroundColor:[UIColor clearColor]];
//        [self addSubview:_v_sepL];
//        RELEASE(_v_sepL);
//    }
    
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(v_back.frame)+20)];
    [_vVerticalLine setFrame:CGRectMake(_vVerticalLine.frame.origin.x, 0, _vVerticalLine.frame.size.width, self.frame.size.height)];
    _vVerticalLine.center=CGPointMake(_imgV_icon.center.x, self.center.y);
    [_imgV_icon changePosInSuperViewWithAlignment:1];
    [_lb_content changePosInSuperViewWithAlignment:1];
    [v_back changePosInSuperViewWithAlignment:1];
}


#pragma mark- 创建动态列表cell  一个动态的cell就是 一个day里发的所有动态model
-(void)creatStatusCell:(NSMutableArray *)data index:(NSIndexPath *)index tbv:(UITableView *)tbv
{
    self.backgroundColor             = ColorWhite;
    self.contentView.backgroundColor = ColorWhite;
    [self setFrame:CGRectMake(0, 0, tbv.frame.size.width, tbv._cellH)];
    
//    float fHeight = 0;
    static float fTailHeight = 0;//时间地点区域部分的y
    
    if(!_vVerticalLine){//竖线
        _vVerticalLine=[[UIView alloc]initWithFrame:CGRectMake(50, 0, 2, tbv._cellH)];
        [_vVerticalLine setBackgroundColor:ColorCellSepL];
        [self addSubview:_vVerticalLine];
        RELEASE(_vVerticalLine);
    }
    
   float fHeight=_v_day.frame.origin.y+10;//第一个动态背景的y,每增加一个view,fHeight+=view.height
    
    _muA_allAddTapGestureView=[NSMutableArray arrayWithCapacity:10];
    [_muA_allAddTapGestureView retain];
    
//    _muA_allStatesModelInOneCell=data;
    
    for (status *model in data) {//一个cell里多个动态
        if ([model isKindOfClass:[status class]]){
            _dynamicStatus=nil;
            _dynamicStatus = model;
//            model.type=0;
            
//            if (![_muA_allStatesModelInOneCell containsObject:model]) {
//                [_muA_allStatesModelInOneCell addObject:model];
//            }
            
            [self addSignal:[UIView TAP] object:/*[_dynamicStatus retain]*/ _dynamicStatus];

            
            [self initDayView];

            UIView *v_back;
            {//动态cell里每个动态的整体背景
                v_back=[[UIView alloc]initWithFrame:CGRectMake(_v_day.frame.origin.x+_v_day.frame.size.width+10, fHeight, 230, 0)];
                v_back.backgroundColor=ColorSlightGray;
                v_back.layer.masksToBounds=YES;
                v_back.layer.cornerRadius=5;
                [self addSubview:v_back];
                RELEASE(v_back);
                v_back.tag=5;
                
                [v_back addSignal:[UIView TAP] object:/*[_dynamicStatus retain]*/ _dynamicStatus];
                
                if (![_muA_allAddTapGestureView containsObject:v_back]) {
                    [_muA_allAddTapGestureView addObject:v_back];
                }
            }
            
            NSMutableArray *arrIMG = [[NSMutableArray alloc] initWithObjects:nil];
            
//            if ([_dynamicStatus.pic_array length] > 0) {
//                [arrIMG addObjectsFromArray:@[_dynamicStatus.pic_array]];
//            }
            
            if ([_dynamicStatus.pic_array count] > 0) {
                for (NSDictionary *pics in _dynamicStatus.pic_array) {
                    [arrIMG addObject:[pics objectForKey:@"pic_s"]];
                }
            }
            
            //            fHeight = [self DynamicUserInfo:_dynamicStatus.user_info.name userPortraitURL:_dynamicStatus.user_info.pic];
            
            fHeight = [self DynamicContentInfo:_dynamicStatus.content target:(NSArray*)_dynamicStatus.target user:_dynamicStatus.user_info contentIMG:arrIMG StartY:fHeight bShare:NO backView:v_back];

            if ([_dynamicStatus.status isKindOfClass:[status class]]&& [_dynamicStatus.isfollow isEqualToString:@"1"]) {//是 转发微博
                if ([_dynamicStatus.status.pic_array count] > 0){
                    for (NSDictionary *pics in _dynamicStatus.status.pic_array) {
                        [arrIMG addObject:[pics objectForKey:@"pic_s"]];
                    }
                }
                
                //                fHeight = [self DynamicContentInfo:_dynamicStatus.status.content target:(NSArray*)_dynamicStatus.status.target user:_dynamicStatus.status.user_info contentIMG:arrIMG StartY:fHeight bShare:YES];
                
//                if ([_dynamicStatus.content isEqualToString:@"更改了TA的个性头像啦!"]) {
//                    DLogInfo(@"");
//                }
                
                fHeight = [self DynamicContentInfo:_dynamicStatus.status.content target:(NSArray*)_dynamicStatus.status.target user:_dynamicStatus.status.user_info contentIMG:arrIMG StartY:fHeight bShare:YES backView:v_back];
                
            }

            if ([arrIMG count] > 0) {
                RELEASE(arrIMG);
            }

            fHeight = /*fHeight +*/ [self DynamicTail:_dynamicStatus.time Location:_dynamicStatus.address From:_dynamicStatus.from StartY:fHeight backView:v_back];

            fTailHeight = fHeight+5;
            //
            if ([_dynamicStatus.good_num intValue] > 0 && _dynamicStatus.type !=15) {//赞

                float bHeightRec = fHeight;
                
                NSMutableArray *arrLikers = [[NSMutableArray alloc] init];
                
                for (good_num_info *likers in _dynamicStatus.good_num_info) {
                    [arrLikers addObject:likers.name];
                }

                fHeight = [self DynamicLikers:arrLikers likerCount:_dynamicStatus.good_num StartY:fHeight+5];

                UIView *viewCoverLike = [[UIView alloc] initWithFrame:CGRectMake(55, bHeightRec, 255, fHeight-bHeightRec)];
                viewCoverLike.tag=3;
                [viewCoverLike setBackgroundColor:[UIColor clearColor]];
                [self addSubview:viewCoverLike];
                [self bringSubviewToFront:viewCoverLike];
                RELEASE(viewCoverLike);

//                [viewCoverLike setUserInteractionEnabled:YES];
//                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapLikeWithGesture:)];
//                [viewCoverLike addGestureRecognizer:tapGestureRecognizer];
                [viewCoverLike addSignal:[UIView TAP] object:/*[_dynamicStatus retain]*/ _dynamicStatus];
                
//                if (!_muA_allAddTapGestureView) {
//                    _muA_viewCoverLike=[[NSMutableArray alloc]initWithObjects:viewCoverLike, nil];
//                }else{
//                    [_muA_viewCoverLike addObject:viewCoverLike];
//                }
                
                if (![_muA_allAddTapGestureView containsObject:viewCoverLike]) {
                    [_muA_allAddTapGestureView addObject:viewCoverLike];
                }
            }
            //
            if ([_dynamicStatus.comment_num intValue] > 0) {//评论

                if ([_dynamicStatus.good_num intValue] > 0 && _dynamicStatus.type !=15) {
                    fHeight = fHeight - 10;
                }

                if ([_dynamicStatus.good_num intValue] > 0 && _dynamicStatus.type !=15) {
                    MagicUIImageView *_imgDevingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(/*58*/ CGRectGetMinX(v_back.frame), fHeight+13, /*250*/ CGRectGetWidth(v_back.frame), 1) backgroundColor:[UIColor clearColor] image:[UIImage imageNamed:@"comment_sepline.png"] isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];

                    [self addSubview:_imgDevingLine];
                    RELEASE(_imgDevingLine);

                }

                float bHeightRec = fHeight;

                NSMutableArray *arrComments = [[NSMutableArray alloc] init];
                
                for (comment_num_info *comments in _dynamicStatus.comment_num_info) {
                    [arrComments addObject:comments.name];
                }
                
                fHeight = [self DynamicComments:arrComments commentCount:_dynamicStatus.comment_num StartY:fHeight+5];

                for (int i = 0; i < [_dynamicStatus.comment_num_info count]; i++) {
                    if (i == 2)
                        break;
                    
                    comment_num_info *comments = [_dynamicStatus.comment_num_info objectAtIndex:i];
                 
                    fHeight = [self DynamicCommetContent:comments.name commenterPortraitURL:comments.pic commentContent:comments.comment StartY:fHeight+5];
                }
                
                RELEASEDICTARRAYOBJ(arrComments);

                UIView *viewCoverComment = [[UIView alloc] initWithFrame:CGRectMake(55, bHeightRec, 255, fHeight-bHeightRec)];
                viewCoverComment.tag=4;
                [viewCoverComment setBackgroundColor:[UIColor clearColor]];
                [self addSubview:viewCoverComment];
                [self bringSubviewToFront:viewCoverComment];
                RELEASE(viewCoverComment);

//                [viewCoverComment setUserInteractionEnabled:YES];
//                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapCommentWithGesture:)];
//                [viewCoverComment addGestureRecognizer:tapGestureRecognizer];
                [viewCoverComment addSignal:[UIView TAP] object:/*[_dynamicStatus retain]*/ _dynamicStatus];
                
//                if (!_muA_viewCoverComment) {
//                    _muA_viewCoverComment=[[NSMutableArray alloc]initWithObjects:viewCoverComment, nil];
//                }else{
//                    [_muA_viewCoverComment addObject:viewCoverComment];
//                }

                if (![_muA_allAddTapGestureView containsObject:viewCoverComment]) {
                    [_muA_allAddTapGestureView addObject:viewCoverComment];
                }
            }
            //
            if (fHeight > fTailHeight) {//有评论或赞
                MagicUIImageView *viewBKG = [self DynamicLikeandCommentBackground:fTailHeight bottomHeight:fHeight :v_back];
                [self addSubview:viewBKG];
//                [self sendSubviewToBack:viewBKG];
                [self insertSubview:viewBKG aboveSubview:v_back];
                RELEASE(viewBKG);
                
                fHeight -= 10;
            }else{//没有评论或赞时,此动态的大背景变深灰色
//                v_back.backgroundColor=BKGGray;
            }

//            fHeight = fHeight+10;
            
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, fHeight-1, self.frame.size.width, .5f)];
//            [lineView setBackgroundColor:[MagicCommentMethod colorWithHex:@"e5e5e5"]];
//            [self addSubview:lineView];
//            RELEASE(lineView);
            
//            [self setUserInteractionEnabled:YES];
//            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapLabelWithGesture:)];
//            [self addGestureRecognizer:tapGestureRecognizer];
            
            [v_back setFrame:CGRectMake(v_back.frame.origin.x, v_back.frame.origin.y, v_back.frame.size.width, fHeight-v_back.frame.origin.y+10)];
            fHeight=CGRectGetMaxY(v_back.frame)+10;//下一个v_back.y
            [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMaxY(v_back.frame)+20)];
            [_vVerticalLine setFrame:CGRectMake(_vVerticalLine.frame.origin.x, _vVerticalLine.frame.origin.y, _vVerticalLine.frame.size.width, self.frame.size.height)];
            
            
        }
    }
}

#pragma mark- 设置动态列表用户头像和昵称
-(float)DynamicUserInfo:(NSString *)userName userPortraitURL:(NSString *)userPortraitURL{
    float fHeight = 50.0f;
    
    MagicUIImageView *_imgUserPortrait = [[MagicUIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    [_imgUserPortrait setNeedRadius:YES];
    
    NSString *encondeUrl= [userPortraitURL stringByAddingPercentEscapesUsingEncoding];
    if ([NSURL URLWithString:encondeUrl] == nil) {
        [_imgUserPortrait setImage:[UIImage imageNamed:@"no_pic_30a.png"]];
    }else
    {
        _imgUserPortrait._b_isShade=NO;
        [_imgUserPortrait setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic_30a.png"]];
        
    }
    RELEASE(_imgUserPortrait);
    
    MagicUILabel *_lbUserName = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgUserPortrait.frame)+10, CGRectGetMinY(_imgUserPortrait.frame), 200, 30)];
    [_lbUserName setBackgroundColor:[UIColor clearColor]];
    [_lbUserName setTextAlignment:NSTextAlignmentLeft];
    [_lbUserName setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [_lbUserName setText:userName];
    [_lbUserName setTextColor:ColorBlack];
    [_lbUserName setNumberOfLines:1];
    [_lbUserName setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self addSubview:_lbUserName];
    RELEASE(_lbUserName);
    
    return fHeight;
}

#pragma mark- 设置动态内容或转发内容 bShare判断：Yes为转发，NO为动态
-(float)DynamicContentInfo:(NSString *)dynamicContent target:(NSArray *)target user:(user *)user contentIMG:(NSArray *)arrIMG StartY:(float)fStartY bShare:(BOOL)bShare backView:(UIView *)backView/*此动态的整体背景*/{
    float fHeight = fStartY;
    UIImage *_imgDividingLine = [UIImage imageNamed:@"share_dotline.png"];//转的内容的上下的横分割线
    
    if (bShare) {//转发部分的顶部横虚线
        MagicUIImageView * _topDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(backView.frame)+10, fHeight+15 , /*backView.frame.size.width*/ backView.frame.size.width-20, /*2*/ _imgDividingLine.size.height) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        RELEASE(_topDividingLine);
        fHeight=CGRectGetMaxY(_topDividingLine.frame);
        
        dynamicContent = [NSString stringWithFormat:@"转: @%@ %@", user.name, dynamicContent];
    }
    
    //动态内容
    DYBCustomLabel *_lbSelfContent = [[DYBCustomLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(backView.frame)+10, fHeight+15, backView.frame.size.width-15, 1000) target:target];
    [_lbSelfContent setBackgroundColor:[UIColor clearColor]];
    [_lbSelfContent setTextAlignment:NSTextAlignmentLeft];
    [_lbSelfContent setFont:[DYBShareinstaceDelegate DYBFoutStyle:17]];
    [_lbSelfContent setText:dynamicContent];
    
    if ([target count] > 0) {
        [_lbSelfContent replaceEmojiandTarget:YES];
    }else
    {
        [_lbSelfContent setLineBreakMode:NSLineBreakByTruncatingTail];
//        [_lbSelfContent sizeToFit];
        [_lbSelfContent setNumberOfLines:0];
        [_lbSelfContent setFontFitToSize:CGSizeMake(_lbSelfContent.frame.size.width, _lbSelfContent.frame.size.height)];
        [_lbSelfContent replaceEmojiandTarget:NO];

    }
    
    if (bShare) {
//        [_lbSelfContent setFrame:CGRectMake(/*55*/ CGRectGetMinX(_lbSelfContent.frame), fHeight+25, /*255*/ CGRectGetWidth(_lbSelfContent.frame), CGRectGetHeight(_lbSelfContent.frame))];
        [_lbSelfContent setTextColor:ColorGray];
        _lbSelfContent.COLOR(@"3", [NSString stringWithFormat:@"%d", [user.name length]+1],ColorBlue);
        _lbSelfContent.CLICK(@"3", [NSString stringWithFormat:@"%d", [user.name length]+1],ColorBlack, [NSString stringWithFormat:@"1|%@|%@", user.userid, user.name]);
        fHeight = CGRectGetMaxY(_lbSelfContent.frame);

    }else{
        [_lbSelfContent setTextColor:ColorBlack];
        fHeight = CGRectGetMaxY(_lbSelfContent.frame);
        [_lbSelfContent setNumberOfLines:4];
    }
    
    {
        //给转的内容添加tap手势,已正常跳转到动态详情页
        _lbSelfContent.tag=5;
        [_lbSelfContent addSignal:[UIView TAP] object:_dynamicStatus];
        if (![_muA_allAddTapGestureView containsObject:_lbSelfContent]) {
            [_muA_allAddTapGestureView addObject:_lbSelfContent];
        }
    }
    
    if ([arrIMG count] > 0) {//动态或转发的图片
        NSInteger nIMAGECount  = [arrIMG count];
        
        for (int nIndex = 0; nIndex < nIMAGECount; nIndex ++) {
            MagicUIImageView *_imgDynamicIMAGE = [[MagicUIImageView alloc] initWithFrame:CGRectMake(_lbSelfContent.frame.origin.x+70*nIndex, CGRectGetMaxY(_lbSelfContent.frame)+15+nIndex/3*85, 60, 75) backgroundColor:[UIColor redColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleToFill stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            _imgDynamicIMAGE.tag=6;
            
            if (nIndex > 2) {
                [_imgDynamicIMAGE setFrame:CGRectMake(_lbSelfContent.frame.origin.x+70*(nIndex-3), CGRectGetMinY(_imgDynamicIMAGE.frame), CGRectGetWidth(_imgDynamicIMAGE.frame), CGRectGetHeight(_imgDynamicIMAGE.frame))];
            }
            
//            NSString *encondeUrl= [[arrIMG objectAtIndex:nIndex] stringByAddingPercentEscapesUsingEncoding];
//            if ([NSURL URLWithString:encondeUrl] == nil) {
//                [_imgDynamicIMAGE setImage:[UIImage imageNamed:@"no_pic.png"]];
//            }else{
//                _imgDynamicIMAGE._b_isShade=NO;
//                [_imgDynamicIMAGE setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic.png"]];
//                
//            }
            [_imgDynamicIMAGE setImgWithUrl:[arrIMG objectAtIndex:nIndex] defaultImg:no_pic_50];
            
//            [_imgDynamicIMAGE setUserInteractionEnabled:YES];
//            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapImageWithGesture:)];
//            [_imgDynamicIMAGE addGestureRecognizer:tapGestureRecognizer];
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", nIndex], @"tag", /*[_dynamicStatus retain]*/ _dynamicStatus, @"status", nil];
            [_imgDynamicIMAGE addSignal:[UIView TAP] object:dic];
            
            RELEASE(_imgDynamicIMAGE);
            RELEASE(dic);
            
            fHeight =  CGRectGetMaxY(_imgDynamicIMAGE.frame);
        }
    }
    
    if (bShare) {//转发部分的底部横虚线
        if ([arrIMG count] > 0) {
            MagicUIImageView *_bottomDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(backView.frame)+10, /*fStartY*/ fHeight+15, backView.frame.size.width-20, _imgDividingLine.size.height) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            RELEASE(_bottomDividingLine);
            fHeight = /*CGRectGetMaxY*/ CGRectGetMaxY(_bottomDividingLine.frame);
        }else{
            MagicUIImageView *_bottomDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(backView.frame)+10, /*fStartY*/ fHeight+15, backView.frame.size.width-20, _imgDividingLine.size.height) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            RELEASE(_bottomDividingLine);
            fHeight = /*CGRectGetMaxY*/ CGRectGetMaxY(_bottomDividingLine.frame);
        }
    }
    
    [self addSubview:_lbSelfContent];
    RELEASE(_lbSelfContent);
    
    return fHeight/*+fStartY*/;
}

#pragma mark- 动态赞的信息
-(float)DynamicLikers:(NSArray *)arrLikers likerCount:(NSString *)strCount StartY:(float)fStartY{
    float fHeight = 0.0f;
    
    UIImage *_imgLike = [UIImage imageNamed:@"icon_like.png"];
    NSString *_strLikeCount = [NSString stringWithFormat:@"共%@人赞过", strCount];
    NSString *_strLikers = @"";
    
    for (NSString *strLike in arrLikers) {
        _strLikers = [_strLikers stringByAppendingString:strLike];
        _strLikers = [_strLikers stringByAppendingString:@" "];
    }
    
    _strLikers = [_strLikers stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    MagicUIImageView *_iconLike = [[MagicUIImageView alloc] initWithFrame:CGRectMake(65+25, fStartY + 10, 20, 20) backgroundColor:[UIColor clearColor] image:_imgLike isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    
    
    MagicUILabel *_lbLikeCount = [[MagicUILabel alloc] initWithFrame:CGRectMake(/*247*/ CGRectGetMaxX(_iconLike.frame)+10, CGRectGetMinY(_iconLike.frame)+4, 59, 25)];
    [_lbLikeCount setBackgroundColor:[UIColor clearColor]];
    [_lbLikeCount setTextAlignment:NSTextAlignmentRight];
    [_lbLikeCount setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
    [_lbLikeCount setTextColor:ColorGray];
    [_lbLikeCount setText:_strLikeCount];
    //    [_lbLikeCount sizeToFit];
    [_lbLikeCount setNumberOfLines:1];
    [_lbLikeCount sizeToFitByconstrainedSize:CGSizeMake(255, 82)];
    //调整frame，保证离屏幕右边距20px
    [_lbLikeCount setFrame:CGRectMake(CGRectGetWidth(self.frame)-20-CGRectGetWidth(_lbLikeCount.frame), CGRectGetMinY(_lbLikeCount.frame), CGRectGetWidth(_lbLikeCount.frame), CGRectGetHeight(_lbLikeCount.frame))];
    
    MagicUILabel *_lbLiker = [[MagicUILabel alloc] initWithFrame:CGRectMake(/*93*/ CGRectGetMaxX(_iconLike.frame)+10, CGRectGetMinY(_iconLike.frame)-2, 125-5, 25)];
    [_lbLiker setBackgroundColor:[UIColor clearColor]];
    [_lbLiker setTextAlignment:NSTextAlignmentLeft];
    [_lbLiker setFont:[DYBShareinstaceDelegate DYBFoutStyle:13]];
    [_lbLiker setTextColor:ColorGray];
    [_lbLiker setText:_strLikers];
    
    [self addSubview:_lbLiker];
    [self addSubview:_iconLike];
    [self addSubview:_lbLikeCount];
    RELEASE(_lbLiker);
    RELEASE(_iconLike);
    RELEASE(_lbLikeCount);
    
    fHeight = CGRectGetMaxY(_lbLikeCount.frame)+10;
    
    return fHeight;
}

#pragma mark- 动态评论信息
-(float)DynamicComments:(NSArray *)arrComments commentCount:(NSString *)strCount StartY:(float)fStartY{
    float fHeight = 0.0f;
    
    UIImage *_imgComment = [UIImage imageNamed:@"icon_comment.png"];
    NSString *_strCommentCount = [NSString stringWithFormat:@"共%@人评论过", strCount];
    NSString *_strComments = @"";
    
    for (NSString *strComment in arrComments) {
        _strComments = [_strComments stringByAppendingString:strComment];
        _strComments = [_strComments stringByAppendingString:@" "];
    }
    
    _strComments = [_strComments stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    MagicUIImageView *_iconComment = [[MagicUIImageView alloc] initWithFrame:CGRectMake(65+25, fStartY+14, 20, 20) backgroundColor:[UIColor clearColor] image:_imgComment isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    
    
    MagicUILabel *_lbCommentCount = [[MagicUILabel alloc] initWithFrame:CGRectMake(/*247*/ CGRectGetMaxX(_iconComment.frame)+10, CGRectGetMinY(_iconComment.frame)+4, 59, 25)];
    [_lbCommentCount setBackgroundColor:[UIColor clearColor]];
    [_lbCommentCount setTextAlignment:NSTextAlignmentRight];
    [_lbCommentCount setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
    [_lbCommentCount setTextColor:ColorGray];
    [_lbCommentCount setText:_strCommentCount];
    [_lbCommentCount sizeToFit];
    [_lbCommentCount setNumberOfLines:1];
    [_lbCommentCount sizeToFitByconstrainedSize:CGSizeMake(255, 82)];
    //调整frame，保证离屏幕右边距20px
    [_lbCommentCount setFrame:CGRectMake(CGRectGetWidth(self.frame)-20-CGRectGetWidth(_lbCommentCount.frame), CGRectGetMinY(_lbCommentCount.frame), CGRectGetWidth(_lbCommentCount.frame), CGRectGetHeight(_lbCommentCount.frame))];
    
    MagicUILabel *_lbComment = [[MagicUILabel alloc] initWithFrame:CGRectMake(/*93*/ CGRectGetMaxX(_iconComment.frame)+10, CGRectGetMinY(_iconComment.frame)-2, 125-5, 25)];
    [_lbComment setBackgroundColor:[UIColor clearColor]];
    [_lbComment setTextAlignment:NSTextAlignmentLeft];
    [_lbComment setLineBreakMode:NSLineBreakByTruncatingTail];
    [_lbComment setNumberOfLines:1];
    [_lbComment setFont:[DYBShareinstaceDelegate DYBFoutStyle:13]];
    [_lbComment setTextColor:ColorGray];
    [_lbComment setText:_strComments];
    
    [self addSubview:_lbComment];
    [self addSubview:_lbCommentCount];
    RELEASE(_lbComment);
    RELEASE(_iconComment);
    RELEASE(_lbCommentCount);
    
    fHeight = CGRectGetMaxY(_lbComment.frame);
    
    return fHeight;
}

#pragma mark- 赞和评论的背景
-(MagicUIImageView *)DynamicLikeandCommentBackground:(float)fStartY bottomHeight:(float)fBotomY :(UIView *)v{
    
    MagicUIImageView *_imgArrow = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(v.frame)+25, fStartY-4, 11, 4) backgroundColor:[UIColor clearColor] image:[UIImage imageNamed:@"icon_arrow_up.png"] isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    RELEASE(_imgArrow);
    
    MagicUIImageView *_BKGView = [[MagicUIImageView alloc] initWithFrame:CGRectMake(/*55*/ CGRectGetMinX(v.frame), fStartY, /*255*/ CGRectGetWidth(v.frame), fBotomY - fStartY)];
    [_BKGView setBackgroundColor:BKGGray];
    CALayer *lay  = _BKGView.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [_BKGView.layer setMasksToBounds:YES];
    [_BKGView.layer setCornerRadius:5.0f];//值越大，角度越圆
    [_BKGView.layer setShadowOffset:CGSizeMake(3.0f, 3.0f)];
    [_BKGView.layer setShadowColor:[UIColor blackColor].CGColor];
    
    return _BKGView;
}

#pragma mark- 评论内容
-(float)DynamicCommetContent:(NSString *)commenterName commenterPortraitURL:(NSString *)portraitURL commentContent:(NSString *)content StartY:(float)fStartY{
    float fHeight = 0;
    
    MagicUIImageView *_imgUserPortrait = [[MagicUIImageView alloc] initWithFrame:CGRectMake(65+25, fStartY+8, 30, 30) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    [_imgUserPortrait setNeedRadius:YES];
    
    NSString *encondeUrl= [portraitURL stringByAddingPercentEscapesUsingEncoding];
    if ([NSURL URLWithString:encondeUrl] == nil) {
        [_imgUserPortrait setImage:[UIImage imageNamed:@"no_pic_30b.png"]];
    }else{
        _imgUserPortrait._b_isShade=NO;
        [_imgUserPortrait setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic_30b.png"]];
        
    }
    
    MagicUILabel *_lbUserName = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgUserPortrait.frame)+8, CGRectGetMinY(_imgUserPortrait.frame), 200, 30)];
    [_lbUserName setBackgroundColor:[UIColor clearColor]];
    [_lbUserName setTextAlignment:NSTextAlignmentLeft];
    [_lbUserName setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [_lbUserName setText:commenterName];
    [_lbUserName setTextColor:ColorBlack];
    [_lbUserName setNumberOfLines:1];
    [_lbUserName setLineBreakMode:NSLineBreakByTruncatingTail];
    //    [_lbUserName sizeToFit];
    
    
    DYBCustomLabel *_lbComment = [[DYBCustomLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgUserPortrait.frame)+8, CGRectGetMaxY(_lbUserName.frame)+3, 200-20, 30)];
    [_lbComment setBackgroundColor:[UIColor clearColor]];
    [_lbComment setTextAlignment:NSTextAlignmentLeft];
    [_lbComment setFont:[DYBShareinstaceDelegate DYBFoutStyle:15]];
    [_lbComment setText:content];
    [_lbComment setTextColor:ColorContentGray];
    [_lbComment setLineBreakMode:NSLineBreakByTruncatingTail];
    [_lbComment setMaxLineNum:2];
    [_lbComment setImgType:1];
    [_lbComment sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_lbComment.frame), 80)];
    [_lbComment replaceEmojiandTarget:NO];
    
    [self addSubview:_lbUserName];
    [self addSubview:_lbComment];
    
    RELEASE(_imgUserPortrait);
    RELEASE(_lbUserName);
    RELEASE(_lbComment);
    
    fHeight = CGRectGetMaxY(_lbComment.frame)+10;
    
    return fHeight;
}

#pragma mark- 动态的尾巴，含时间,位置和来自
-(float)DynamicTail:(NSString *)strTime Location:(NSString *)strLocation From:(NSString *)strFrom StartY:(float)fStartY backView:(UIView *)backView/*此动态的整体背景*/{
    float fHeight =20;
    NSString *_strTail = nil;
    
    NSString *min=[NSString stringWithFormat:@"%d",[NSString getDateComponentsByTimeStamp:[_dynamicStatus.time integerValue]].minute];
    if (min.length==1) {
        min=[NSString stringWithFormat:@"0%@",min];
    }
    
    strTime = [NSString stringWithFormat:@"%d:%@",[NSString getDateComponentsByTimeStamp:[_dynamicStatus.time integerValue]].hour,min];

    if ([strLocation length] == 0) {
        _strTail = [NSString stringWithFormat:@"%@ • %@", strTime, strFrom];
    }else{
        _strTail = [NSString stringWithFormat:@"%@ •　%@ • %@", strTime, strLocation, strFrom];
    }
    
    MagicUILabel *_lbComment = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(backView.frame)+10, fStartY+15, 255, fHeight)];
    [_lbComment setBackgroundColor:[UIColor clearColor]];
    [_lbComment setTextAlignment:NSTextAlignmentLeft];
    [_lbComment setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
    [_lbComment setTextColor:ColorGray];
    [_lbComment setText:_strTail];
    [_lbComment sizeToFit];
    [_lbComment setNumberOfLines:1];
    [_lbComment sizeToFitByconstrainedSize:CGSizeMake(255, 82)];
    
    [self addSubview:_lbComment];
    RELEASE(_lbComment);
    
    return /*fHeight+fStartY*/ CGRectGetMaxY(_lbComment.frame);
}

#pragma mark- 动态图片 合并到DynamicContentInfo里，不再使用
-(float)DynamicIMAGE:(NSArray *)arrIMAGE StartY:(float)fStartY{
    float fHeight = 0;
    NSInteger nIMAGECount  = [arrIMAGE count];
    
    for (int nIndex = 0; nIndex < nIMAGECount; nIndex ++) {
        MagicUIImageView *_imgDynamicIMAGE = [[MagicUIImageView alloc] initWithFrame:CGRectMake(65+70*nIndex, fStartY+15+nIndex/3*85, 60, 75) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleToFill stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        
        if (nIndex > 2) {
            [_imgDynamicIMAGE setFrame:CGRectMake(65+70*(nIndex-3), CGRectGetMinY(_imgDynamicIMAGE.frame), CGRectGetWidth(_imgDynamicIMAGE.frame), CGRectGetHeight(_imgDynamicIMAGE.frame))];
        }
        
        NSString *encondeUrl= [[arrIMAGE objectAtIndex:nIndex] stringByAddingPercentEscapesUsingEncoding];
        if ([NSURL URLWithString:encondeUrl] == nil) {
            [_imgDynamicIMAGE setImage:[UIImage imageNamed:@"no_pic.png"]];
        }else{
            _imgDynamicIMAGE._b_isShade=NO;
            [_imgDynamicIMAGE setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic.png"]];
            
        }
        
        RELEASE(_imgDynamicIMAGE);
        
        fHeight = CGRectGetMaxY(_imgDynamicIMAGE.frame);
    }
    
    return fHeight;
}

//#pragma mark- 点击跳转
//- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)tapGesture {
//    @try {
//        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
//        DLogInfo(@"%d", tappedView.tag);
//        
//        [self sendViewSignal:[DYBDynamicViewController DYNAMICDETAIL] withObject:/*[_dynamicStatus retain]*/ _dynamicStatus];
//    }
//    @catch (NSException *exception) {
//        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
//    }
//}
//
//- (void)didTapImageWithGesture:(UITapGestureRecognizer *)tapGesture {
//    @try {
//        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
//        DLogInfo(@"%d", tappedView.tag);
//        
//        [self sendViewSignal:[DYBDynamicViewController DYNAMICDIMAGEETAIL] withObject:[_dynamicStatus retain]];
//    }
//    @catch (NSException *exception) {
//        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
//    }
//}

//- (void)didTapCommentWithGesture:(UITapGestureRecognizer *)tapGesture {
//    @try {
//        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
//        DLogInfo(@"%d", tappedView.tag);
//        
//        [self sendViewSignal:[DYBDynamicViewController DYNAMICDETAILCOMMENT] withObject:[_dynamicStatus retain]];
//    }
//    @catch (NSException *exception) {
//        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
//    }
//}

//- (void)didTapLikeWithGesture:(UITapGestureRecognizer *)tapGesture {
//    @try {
//        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
//        DLogInfo(@"%d", tappedView.tag);
//        
////        [self sendViewSignal:[DYBDynamicViewController DYNAMICDETAILLIKE] withObject:[_dynamicStatus retain]];
//        
////        DYBDynamicDetailViewController *vc = [[DYBDynamicDetailViewController alloc] init:_dynamicStatus withStatus:2 bScroll:YES];
////        [[self superCon].navigationController pushViewController:vc animated:YES];
////        RELEASE(vc);
//        
//    }
//    @catch (NSException *exception) {
//        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
//    }
//}

#pragma mark- 展开|收缩day视图
-(void)spreadOrShrinkDayView
{
    if (!_imgV_SpreadDayViewBack) {//展开的day视图的蓝色背景
        UIImage *img=[UIImage imageNamed:@"grzy_10.png"];
        _imgV_SpreadDayViewBack = [[MagicUIImageView alloc] initWithFrame:CGRectMake(_v_day.frame.origin.x-5, _v_day.frame.origin.y, /*img.size.width/2*/0,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
//        [_imgV_headBack setNeedRadius:YES];
//        _imgV_headBack.center=CGPointMake(self.center.x, 0);
        [_imgV_SpreadDayViewBack addSignal:[UIView TAP] object:self];
        _imgV_SpreadDayViewBack.tag=2;
        RELEASE(_imgV_SpreadDayViewBack);
        
        {
            CGFloat w = img.size.width/2;
            _imgV_SpreadDayViewBack.image=[_imgV_SpreadDayViewBack.image stretchableImageWithLeftCapWidth:10 topCapHeight:0];
            _v_day.alpha=0;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                _imgV_SpreadDayViewBack.frame = CGRectMake(CGRectGetMinX(_imgV_SpreadDayViewBack.frame), CGRectGetMinY(_imgV_SpreadDayViewBack.frame),w, CGRectGetHeight(_imgV_SpreadDayViewBack.frame));
            }completion:^(BOOL b){
                {//太阳
                    UIImage *img=[UIImage imageNamed:@"grzy_9.png"];
                    MagicUIImageView *imgV = [[MagicUIImageView alloc] initWithFrame:CGRectMake(12 ,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_imgV_SpreadDayViewBack Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    //        [_imgV_headBack setNeedRadius:YES];
                    //        _imgV_headBack.center=CGPointMake(self.center.x, 0);
                    //            [_imgV_SpreadDayViewBack addSignal:[UIView TAP] object:self];
                    //            _imgV_SpreadDayViewBack.tag=2;
                    RELEASE(imgV);
                    
                    {//年月日
                        DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(imgV.frame.origin.x+imgV.frame.size.width+10, 0, 100,110)];
                        lb.backgroundColor=[UIColor clearColor];
                        lb.textAlignment=NSTextAlignmentLeft;
                        lb.font=[UIFont systemFontOfSize:13];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                        lb.text=[NSString stringWithFormat:@"%d.%d.%d",[NSString getDateComponentsByTimeStamp:[_dynamicStatus.time integerValue]].year,[NSString getDateComponentsByTimeStamp:[_dynamicStatus.time integerValue]].month,[NSString getDateComponentsByTimeStamp:[_dynamicStatus.time integerValue]].day];
                        lb.textColor=ColorWhite;
                        lb.numberOfLines=0;
                        lb.lineBreakMode=NSLineBreakByCharWrapping;
                        //        [_lb_content sizeToFitByconstrainedSize:CGSizeMake(200/*最宽*/, 1000)];
                        //        [_lb_content replaceEmojiandTarget:NO];
                        [_imgV_SpreadDayViewBack addSubview:lb];
                        //                _lb_content.FONT(@"0",@"1",@"30.f");
                        //                _lb_content.COLOR(@"4",@"1",ColorGray);
                        //                [_lb_content setNeedCoretext:YES];
                        [lb changePosInSuperViewWithAlignment:1];
                        
                        RELEASE(lb);
                    }
                }
            }];
        }
    }else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            _imgV_SpreadDayViewBack.frame = CGRectMake(CGRectGetMinX(_imgV_SpreadDayViewBack.frame), CGRectGetMinY(_imgV_SpreadDayViewBack.frame),0, CGRectGetHeight(_imgV_SpreadDayViewBack.frame));
        }completion:^(BOOL b){
            _v_day.alpha=1;
            REMOVEFROMSUPERVIEW(_imgV_SpreadDayViewBack);
        }];
        
    }
}


-(void)initDayView
{//创建左边day视图
    if(!_v_day){//
        UIImage *img=[UIImage imageNamed:@"grzy_4"];
        UIView *vDay=[[UIView alloc]initWithFrame:CGRectMake(35, 10, img.size.width/2, img.size.height/2)];
        _v_day=vDay;
//        vDay.center=CGPointMake(_vVerticalLine.center.x, self.center.y);
        [vDay setBackgroundColor:ColorCellSepL];
        vDay.layer.masksToBounds=YES;
        vDay.layer.cornerRadius=vDay.frame.size.width/2;
        [self addSubview:vDay];
        RELEASE(vDay);
        
        if(!_lbDay){
            _lbDay=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, vDay.frame.size.width,vDay.frame.size.height)];
            _lbDay.backgroundColor=[UIColor clearColor];
            _lbDay.textAlignment=NSTextAlignmentLeft;
            _lbDay.font=[UIFont systemFontOfSize:18];//[DYBShareinstaceDelegate DYBFoutStyle:18];
            _lbDay.text=[NSString stringWithFormat:@"%d",[NSString getDateComponentsByTimeStamp:[_dynamicStatus.time integerValue]].day];
            _lbDay.textColor=ColorBlack;
            _lbDay.numberOfLines=0;
            _lbDay.lineBreakMode=NSLineBreakByCharWrapping;
            [_lbDay sizeToFitByconstrainedSize:CGSizeMake(_lbDay.frame.size.width, _lbDay.frame.size.height)];
            //        [_lb_content replaceEmojiandTarget:NO];
            [vDay addSubview:_lbDay];
            _lbDay.tag=1;
            //                        _lb_content.FONT(@"0",@"1",@"30.f");
            //                        _lb_content.COLOR(@"4",@"1",ColorGray);
            //                        [_lb_content setNeedCoretext:YES];
            
            _lbDay.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",_lbDay.text.length] ,@"18.f");
//            _lb_content.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
            [_lb_content setNeedCoretext:YES];
            
            [_lbDay changePosInSuperViewWithAlignment:2];
            [_lbDay addSignal:[UIView TAP] object:self];
            RELEASE(self);//上边retain 了self
            [_lbDay setFrame:CGRectMake(CGRectGetMinX(_lbDay.frame), CGRectGetMinY(_lbDay.frame)+1, CGRectGetWidth(_lbDay.frame), CGRectGetHeight(_lbDay.frame))];
            RELEASE(_lbDay);
        }
        
        _vVerticalLine.center=CGPointMake(_v_day.center.x, self.center.y);

    }
}

#pragma mark- 顶踩动画
-(void)pushUp_stampAnimation:(user *)model
{
    if ([model isKindOfClass:[user class]]&& model.i_playTop_stampTag==1) {
        REMOVEFROMSUPERVIEW(_imgV_footMark);
        
        if (!_imgV_footMark) {
            UIImage *img=[UIImage imageNamed:@"ftz6.png"];
            MagicUIImageView *imgV = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0 ,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:0 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            _imgV_footMark=imgV;
            _imgV_footMark.hidden=YES;
            _imgV_footMark.transform = CGAffineTransformMakeScale(114, 114);
            RELEASE(imgV);
            _imgV_footMark.alpha = 0;
            _imgV_footMark.center=CGPointMake(self.center.x, 0);
        }
        
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _imgV_footMark.alpha = 1;
            _imgV_footMark.transform = CGAffineTransformMakeScale(1, 1);
            _imgV_footMark.hidden=NO;
        }completion:^(BOOL b){
            
            if (b) {
                model.i_playTop_stampTag=0;
                
                UIViewController *con=[self superCon];
                [con.view TheWaterLinesWaveEffect:self duration:0.5 selector:nil userInfo:nil type:@"rippleEffect" AnimationKey:nil subtype:kCATransitionFromLeft exchangeSubviewAtIndex:0 withSubviewAtIndex:0];
            }
            
        }];
    }

}


-(void)dealloc
{
//    if (_muA_allBackView) {
//        for (UIView *v in _muA_allBackView) {
//            [v removeAllSignal];
//        }
//        
//        RELEASEDICTARRAYOBJ(_muA_allBackView);
//    }
    
//    if (_muA_viewCoverLike) {
//        for (UIView *v in _muA_viewCoverLike) {
//            [v removeAllSignal];
//        }
//        
//        RELEASEDICTARRAYOBJ(_muA_viewCoverLike);
//    }
//    
//    if (_muA_viewCoverComment) {
//        for (UIView *v in _muA_viewCoverComment) {
//            [v removeAllSignal];
//        }
//        
//        RELEASEDICTARRAYOBJ(_muA_viewCoverComment);
//    }
    
//    if (_muA_allStatesModelInOneCell) {
//        for (status *model in _muA_allStatesModelInOneCell) {
//            [model release];
//        }
//    }
    
    if (_muA_allAddTapGestureView) {
        for (UIView *v in _muA_allAddTapGestureView) {
            [v removeAllSignal];
        }

        RELEASEDICTARRAYOBJ(_muA_allAddTapGestureView);
    }

    
    [_imgV_head removeAllSignal];
    [_v_sign removeAllSignal];
    [_imgV_SpreadDayViewBack removeAllSignal];
    [_lbDay removeAllSignal];
    
    [super dealloc];
    
}
@end
