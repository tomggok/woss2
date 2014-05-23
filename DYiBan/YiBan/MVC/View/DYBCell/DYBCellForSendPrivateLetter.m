//
//  DYBCellForSendPrivateLetter.m
//  DYiBan
//
//  Created by zhangchao on 13-9-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForSendPrivateLetter.h"
#import "chat.h"
#import "UITableView+property.h"
#import "UIView+MagicCategory.h"
#import "NSString+Count.h"
#import "UILabel+ReSize.h"
#import "UIImageView+WebCache.h"
#import "UITableViewCell+MagicCategory.h"
#import "target.h"
#import "RegexKitLite.h"
@implementation DYBCellForSendPrivateLetter
@synthesize _imagV_fail,_imgV_showImg,_lb_adress,_lb_content,_lb_time;

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
//    [self setFrame:CGRectMake(0, 0, self.frame.size.width, tbv._cellH)];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (data) {
        chat *model=data;
        model.indexRow = indexPath.row;
        switch ([model.ext.type intValue]) {
            case 1://正常lb和表情
            case 4://语音
            {
                if ([model.user_info.userid isEqualToString:SHARED.curUser.userid]) {//初始右侧自己的内容
                    
                    if (!_lb_content) {
                        _lb_content=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 200,0) target:(NSArray*)model.target];
                        _lb_content.backgroundColor=[UIColor clearColor];
                        _lb_content.textAlignment=NSTextAlignmentLeft;
                        _lb_content.font=[DYBShareinstaceDelegate DYBFoutStyle:17];
                        _lb_content.text=model.content;
                        _lb_content.textColor=ColorWhite;  //(model.view==0/*未读*/)?([MagicCommentMethod colorWithHex:@"0x333333"]):([MagicCommentMethod colorWithHex:@"0xaaaaaa"]);
//                        _lb_content.numberOfLines=0;
//                        _lb_content.lineBreakMode=NSLineBreakByCharWrapping;
                        
                    
                        if ([(NSArray*)model.target count] > 0) {
                            [_lb_content setTypeIndex:1];
                            [_lb_content replaceEmojiandTarget:YES];
                            [_lb_content sizeToFitByconstrainedSize:CGSizeMake(200/*最宽*/, 1000)];
                        }else {
                            [_lb_content sizeToFitByconstrainedSize:CGSizeMake(200/*最宽*/, 1000)];
                            [_lb_content replaceEmojiandTarget:NO];
                        }
                        
                        [self addSubview:_lb_content];
                        [_lb_content autoFrame];
                        [_lb_content changePosInSuperViewWithAlignment:1];
                        [_lb_content setFrame:CGRectMake(self.frame.size.width-15-10-_lb_content.frame.size.width, _lb_content.frame.origin.y, _lb_content.frame.size.width,_lb_content.frame.size.height)];
                        
                        RELEASE(_lb_content);
                    }
                    
                    if (!_v_Contentback) {
                        _v_Contentback=[[UIView alloc]initWithFrame:CGRectMake(0,0, _lb_content.frame.size.width+20, _lb_content.frame.size.height+20)];
                        _v_Contentback.backgroundColor=ColorBlue;
                        _v_Contentback.layer.masksToBounds=YES;
                        _v_Contentback.layer.cornerRadius=5;
                        
                        [self addSubview:_v_Contentback];
                        _v_Contentback.center=_lb_content.center;
                        RELEASE(_v_Contentback);
                        [self bringSubviewToFront:_lb_content];
                        
                        
                        {//右侧蓝色箭头
                            UIImage *img=[UIImage imageNamed:@"tail_blue"];
                            MagicUIImageView *imgV_Arrow=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_v_Contentback.frame)-img.size.width/2- floor(CGRectGetWidth(_v_Contentback.frame)/10), CGRectGetMaxY(_v_Contentback.frame), img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                            RELEASE(imgV_Arrow);
                            _imgV_ArrowR=imgV_Arrow;
                        }
                    }
                    
                    if (!_lb_time) {
                        _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                        _lb_time.backgroundColor=[UIColor clearColor];
                        _lb_time.textAlignment=NSTextAlignmentLeft;
                        _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                        _lb_time.text=((model.time)?([NSString transFormTimeStampToDateFormatter:model.time]):(model.str_time));
                        [_lb_time setNeedCoretext:NO];
                        _lb_time.textColor=Colortime;
                        _lb_time.numberOfLines=0;
                        
                        _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
                        [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_time.frame.origin.x, 100)];
                        
                        [self addSubview:_lb_time];
                        
                        [_lb_time setFrame:CGRectMake(_v_Contentback.frame.origin.x-10-_lb_time.frame.size.width, _lb_time.frame.origin.y, _lb_time.frame.size.width, _lb_time.frame.size.height)];
                        RELEASE(_lb_time);
                        _lb_time.hidden=!(model.SucessSend==1);
                    }
                    
                    if (!_imagV_fail) {
                        UIImage *imag = [UIImage imageNamed:@"send_fail.png"];
                        
                        _imagV_fail=[[MagicUIImageView alloc]initWithFrame:CGRectMake(_v_Contentback.frame.origin.x-10-imag.size.width/2, 15, imag.size.width/2, imag.size.height/2)];
                        NSDictionary *_dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:model, @"model", @"我是失败的-11111文字", @"type", nil];
                        [_imagV_fail addSignal:[UIView TAP] object:_dicInfo];
                        [_imagV_fail setImage:imag];
                        [self addSubview:_imagV_fail];
                        _imagV_fail.hidden= !_lb_time.hidden;
                        
                        RELEASE(_imagV_fail);
                        
                        
                    }
                    
                }else{//初始左侧对方的内容
                    if (!_lb_content) {
                        _lb_content=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(25, 0, 0,0) target:(NSArray*)model.target];
                        _lb_content.backgroundColor=[UIColor clearColor];
                        _lb_content.textAlignment=NSTextAlignmentLeft;
                        _lb_content.font=[DYBShareinstaceDelegate DYBFoutStyle:17];
                        _lb_content.text=model.content;
                        _lb_content.textColor=ColorBlack;
                        _lb_content.numberOfLines=0;
                        _lb_content.lineBreakMode=NSLineBreakByCharWrapping;
                        
                        
                        if ([(NSArray*)model.target count] > 0) {
                            [_lb_content setTypeIndex:1];
                            [_lb_content replaceEmojiandTarget:YES];
                            [_lb_content sizeToFitByconstrainedSize:CGSizeMake(200/*最宽*/, 1000)];
                        }else {
                            [_lb_content sizeToFitByconstrainedSize:CGSizeMake(200/*最宽*/, 1000)];
                            [_lb_content replaceEmojiandTarget:NO];
                        }
                        
                        [self addSubview:_lb_content];
                        [_lb_content autoFrame];
                        [_lb_content setNeedCoretext:YES];
                        
                        [_lb_content changePosInSuperViewWithAlignment:1];
                        
                        RELEASE(_lb_content);
                    }
                    
                    if (!_v_Contentback) {
                        _v_Contentback=[[UIView alloc]initWithFrame:CGRectMake(0,0, _lb_content.frame.size.width+20, _lb_content.frame.size.height+20)];
                        _v_Contentback.backgroundColor=BKGGray;
                        _v_Contentback.layer.masksToBounds=YES;
                        _v_Contentback.layer.cornerRadius=5;
                        
                        [self addSubview:_v_Contentback];
                        _v_Contentback.center=_lb_content.center;
                        RELEASE(_v_Contentback);
                        [self bringSubviewToFront:_lb_content];
                        
                        {//左侧箭头
                            UIImage *img=[UIImage imageNamed:@"tail_gray"];
                            MagicUIImageView *imgV_Arrow=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_v_Contentback.frame)+floor(CGRectGetWidth(_v_Contentback.frame)/10), CGRectGetMaxY(_v_Contentback.frame), img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                            RELEASE(imgV_Arrow);
                            _imgV_ArrowL=imgV_Arrow;
                        }
                    }
                    
                    if (!_lb_time) {
                        _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                        _lb_time.backgroundColor=[UIColor clearColor];
                        _lb_time.textAlignment=NSTextAlignmentLeft;
                        _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                        _lb_time.text=[NSString transFormTimeStampToDateFormatter:model.time];
                        [_lb_time setNeedCoretext:NO];
                        _lb_time.textColor=Colortime;
                        _lb_time.numberOfLines=0;
                        
                        _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
                        [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_time.frame.origin.x, 100)];
                        
                        [self addSubview:_lb_time];
                        
                        [_lb_time setFrame:CGRectMake(_v_Contentback.frame.origin.x+_v_Contentback.frame.size.width+10, _lb_time.frame.origin.y, _lb_time.frame.size.width, _lb_time.frame.size.height)];
                        RELEASE(_lb_time);
                        
                        _lb_time.hidden=!(model.SucessSend==1);

                    }
                }
                
                
                [self setFrame:CGRectMake(0, 0, self.frame.size.width, _v_Contentback.frame.size.height+20)];
                [_lb_content changePosInSuperViewWithAlignment:1];
                _v_Contentback.center=_lb_content.center;
                [_lb_time changePosInSuperViewWithAlignment:1];
                [_imgV_ArrowR setFrame:CGRectMake(CGRectGetMinX(_imgV_ArrowR.frame), CGRectGetMaxY(_v_Contentback.frame), CGRectGetWidth(_imgV_ArrowR.frame), CGRectGetHeight(_imgV_ArrowR.frame))];
                [_imgV_ArrowL setFrame:CGRectMake(CGRectGetMinX(_imgV_ArrowL.frame), CGRectGetMaxY(_v_Contentback.frame), CGRectGetWidth(_imgV_ArrowL.frame), CGRectGetHeight(_imgV_ArrowL.frame))];

                if (!_imagV_fail) {
                    UIImage *imag = [UIImage imageNamed:@"send_fail.png"];
                    
                    _imagV_fail=[[MagicUIImageView alloc]initWithFrame:CGRectMake(_v_Contentback.frame.origin.x+10+_v_Contentback.frame.size.width, 15, imag.size.width/2, imag.size.height/2)];
                    
                    NSDictionary *_dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:model, @"model", @"我是失败的-11111文字", @"type", nil];
                    [_imagV_fail addSignal:[UIView TAP] object:_dicInfo];
                    
                    [_imagV_fail setImage:imag];
                    [self addSubview:_imagV_fail];
                    _imagV_fail.hidden= !_lb_time.hidden;
                    RELEASE(_imagV_fail);
                }
                

            }
                break;
                
            case 2://定位
            {
                UIImage *img=[UIImage imageNamed:@"map_mini.png"];

                if ([model.user_info.userid isEqualToString:SHARED.curUser.userid]) {//右侧
                    
                    if (!_imgV_showImg) {
                        _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-15-5-img.size.width/2,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                        RELEASE(_imgV_showImg);

                    }
                    [_imgV_showImg setImgWithUrl:model.ext.img_url defaultImg:@"map_mini.png"];
                    
                    if (!_lb_adress) {
                        _lb_adress=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                        _lb_adress.backgroundColor=[UIColor clearColor];
                        _lb_adress.textAlignment=NSTextAlignmentLeft;
                        _lb_adress.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                        _lb_adress.text=model.ext.address;
                        [_lb_adress setNeedCoretext:NO];
                        _lb_adress.textColor=Colortime;
                        _lb_adress.numberOfLines=0;
                        
                        _lb_adress.lineBreakMode=NSLineBreakByTruncatingTail;
                        [_lb_adress sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_imgV_showImg.frame), CGRectGetHeight(_imgV_showImg.frame))];
                        _lb_adress.center=_imgV_showImg.center;
                        
                        [_imgV_showImg addSubview:_lb_adress];
                        [_lb_adress changePosInSuperViewWithAlignment:0];
                        [_lb_adress setFrame:CGRectMake(0, CGRectGetHeight(_imgV_showImg.frame)- _lb_adress.frame.size.height, _lb_adress.frame.size.width, _lb_adress.frame.size.height)];
                        RELEASE(_lb_adress);

                    }
                    
                    NSDictionary *_dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:model, @"model", @"我是成功的-11111定位", @"type", nil];
                    
                    [_imgV_showImg addSignal:[UIView TAP] object:_dicInfo];
                    
                    if (!_v_Contentback) {
                        _v_Contentback=[[UIView alloc]initWithFrame:CGRectMake(0,0, _imgV_showImg.frame.size.width+10, _imgV_showImg.frame.size.height+10)];
                        _v_Contentback.backgroundColor=ColorBlue;
                        _v_Contentback.layer.masksToBounds=YES;
                        _v_Contentback.layer.cornerRadius=5;
                        
                        [self addSubview:_v_Contentback];
                        _v_Contentback.center=_imgV_showImg.center;
                        RELEASE(_v_Contentback);
                        [self bringSubviewToFront:_imgV_showImg];
                        
                        {//右侧蓝色箭头
                            UIImage *img=[UIImage imageNamed:@"tail_blue"];
                            MagicUIImageView *imgV_Arrow=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_v_Contentback.frame)-img.size.width/2-floor(CGRectGetWidth(_v_Contentback.frame)/10), CGRectGetMaxY(_v_Contentback.frame), img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                            RELEASE(imgV_Arrow);
                            _imgV_ArrowR=imgV_Arrow;
                        }
                    }
                    
                    if (!_lb_time) {
                        _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                        _lb_time.backgroundColor=[UIColor clearColor];
                        _lb_time.textAlignment=NSTextAlignmentLeft;
                        _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                        _lb_time.text=((model.time)?([NSString transFormTimeStampToDateFormatter:model.time]):(model.str_time));
                        [_lb_time setNeedCoretext:NO];
                        _lb_time.textColor=Colortime;
                        _lb_time.numberOfLines=0;
                        
                        _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
                        [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_time.frame.origin.x, 100)];
                        
                        [self addSubview:_lb_time];
                        
                        [_lb_time setFrame:CGRectMake(_v_Contentback.frame.origin.x-10-_lb_time.frame.size.width, _lb_time.frame.origin.y, _lb_time.frame.size.width, _lb_time.frame.size.height)];
                        RELEASE(_lb_time);
                        _lb_time.hidden=!(model.SucessSend==1);

                    }
                    
                    [self setFrame:CGRectMake(0, 0, self.frame.size.width, _v_Contentback.frame.size.height+20)];
                    [_imgV_showImg changePosInSuperViewWithAlignment:1];
                    _v_Contentback.center=_imgV_showImg.center;
                    [_lb_time changePosInSuperViewWithAlignment:1];
                    
                    
                    if (!_imagV_fail) {
                        UIImage *imag = [UIImage imageNamed:@"send_fail.png"];
                        
                        _imagV_fail=[[MagicUIImageView alloc]initWithFrame:CGRectMake(_v_Contentback.frame.origin.x-10-imag.size.width/2, 15, imag.size.width/2, imag.size.height/2)];
                        
                        
                        NSDictionary *_dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:model, @"model", @"我是失败的-11111定位", @"type", nil];
                        
                        [_imagV_fail addSignal:[UIView TAP] object:_dicInfo];
                        
                        [_imagV_fail setImage:imag];
                        [self addSubview:_imagV_fail];
                        _imagV_fail.hidden= !_lb_time.hidden;
                        RELEASE(_imagV_fail);
                    }
                    
                    
                }else{//左侧
                    
                    if (!_imgV_showImg) {
                        _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(20,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                        RELEASE(_imgV_showImg);
                        [_imgV_showImg setImgWithUrl:model.ext.img_url defaultImg:@"map_mini.png"];
                    }
                    
                    if (!_lb_adress) {
                        
                        _lb_adress=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                        _lb_adress.backgroundColor=[UIColor clearColor];
                        _lb_adress.textAlignment=NSTextAlignmentLeft;
                        _lb_adress.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                        _lb_adress.text=model.ext.address;
                        [_lb_adress setNeedCoretext:NO];
                        _lb_adress.textColor=Colortime;
                        _lb_adress.numberOfLines=0;
                        
                        _lb_adress.lineBreakMode=NSLineBreakByTruncatingTail;
                        [_lb_adress sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_imgV_showImg.frame), CGRectGetHeight(_imgV_showImg.frame))];
                        _lb_adress.center=_imgV_showImg.center;
                        
                        [_imgV_showImg addSubview:_lb_adress];
                        [_lb_adress changePosInSuperViewWithAlignment:0];
                        [_lb_adress setFrame:CGRectMake(0, CGRectGetHeight(_imgV_showImg.frame)- _lb_adress.frame.size.height, _lb_adress.frame.size.width, _lb_adress.frame.size.height)];
                        
                        RELEASE(_lb_adress);
                    }
                    
                    NSDictionary *_dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:model, @"model", @"我是成功的-11111定位", @"type", nil];
                    [_imgV_showImg addSignal:[UIView TAP] object:_dicInfo];
                    
                    if (!_v_Contentback) {
                        _v_Contentback=[[UIView alloc]initWithFrame:CGRectMake(0,0, _imgV_showImg.frame.size.width+10, _imgV_showImg.frame.size.height+10)];
                        _v_Contentback.backgroundColor=BKGGray;
                        _v_Contentback.layer.masksToBounds=YES;
                        _v_Contentback.layer.cornerRadius=5;
                        
                        [self addSubview:_v_Contentback];
                        _v_Contentback.center=_imgV_showImg.center;
                        RELEASE(_v_Contentback);
                        [self bringSubviewToFront:_imgV_showImg];
                        
                        {//左侧蓝色箭头
                            UIImage *img=[UIImage imageNamed:@"tail_gray"];
                            MagicUIImageView *imgV_Arrow=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_v_Contentback.frame)+floor(CGRectGetWidth(_v_Contentback.frame)/10), CGRectGetMaxY(_v_Contentback.frame), img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                            RELEASE(imgV_Arrow);
                            _imgV_ArrowL=imgV_Arrow;
                        }
                    }
                    
                    if (!_lb_time) {
                        _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                        _lb_time.backgroundColor=[UIColor clearColor];
                        _lb_time.textAlignment=NSTextAlignmentLeft;
                        _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                        _lb_time.text=((model.time)?([NSString transFormTimeStampToDateFormatter:model.time]):(model.str_time));
                        [_lb_time setNeedCoretext:NO];
                        _lb_time.textColor=Colortime;
                        _lb_time.numberOfLines=0;
                        
                        _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
                        [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_time.frame.origin.x, 100)];
                        
                        [self addSubview:_lb_time];
                        
                        [_lb_time setFrame:CGRectMake(_v_Contentback.frame.origin.x+10+_v_Contentback.frame.size.width, _lb_time.frame.origin.y, _lb_time.frame.size.width, _lb_time.frame.size.height)];
                        RELEASE(_lb_time);
                        _lb_time.hidden=!(model.SucessSend==1);

                    }
                    
                    [self setFrame:CGRectMake(0, 0, self.frame.size.width, _v_Contentback.frame.size.height+20)];
                    [_imgV_showImg changePosInSuperViewWithAlignment:1];
                    _v_Contentback.center=_imgV_showImg.center;
                    [_lb_time changePosInSuperViewWithAlignment:1];
                    [_imgV_ArrowR setFrame:CGRectMake(CGRectGetMinX(_imgV_ArrowR.frame), CGRectGetMaxY(_v_Contentback.frame), CGRectGetWidth(_imgV_ArrowR.frame), CGRectGetHeight(_imgV_ArrowR.frame))];
                    [_imgV_ArrowL setFrame:CGRectMake(CGRectGetMinX(_imgV_ArrowL.frame), CGRectGetMaxY(_v_Contentback.frame), CGRectGetWidth(_imgV_ArrowL.frame), CGRectGetHeight(_imgV_ArrowL.frame))];
                    
                    if (!_imagV_fail) {
                        UIImage *imag = [UIImage imageNamed:@"send_fail.png"];
                        
                        _imagV_fail=[[MagicUIImageView alloc]initWithFrame:CGRectMake(_v_Contentback.frame.origin.x+10+_v_Contentback.frame.size.width, 15, imag.size.width/2, imag.size.height/2)];
                        
                        NSDictionary *_dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:model, @"model", @"我是失败的-11111定位", @"type", nil];
                        [_imagV_fail addSignal:[UIView TAP] object:_dicInfo];
                        
                        [_imagV_fail setImage:imag];
                        [self addSubview:_imagV_fail];
                        _imagV_fail.hidden= !_lb_time.hidden;
                        RELEASE(_imagV_fail);
                    }
                    
                }
                
                [_imgV_ArrowR setFrame:CGRectMake(CGRectGetMinX(_imgV_ArrowR.frame), CGRectGetMaxY(_v_Contentback.frame), CGRectGetWidth(_imgV_ArrowR.frame), CGRectGetHeight(_imgV_ArrowR.frame))];
                [_imgV_ArrowL setFrame:CGRectMake(CGRectGetMinX(_imgV_ArrowL.frame), CGRectGetMaxY(_v_Contentback.frame), CGRectGetWidth(_imgV_ArrowL.frame), CGRectGetHeight(_imgV_ArrowL.frame))];
                
            }
                break;
            case 3://图片
            {
                if ([model.user_info.userid isEqualToString:SHARED.curUser.userid]) {//右侧
                    UIImage *img=[UIImage imageNamed:@"img_loading_blue.png"];

                    if (!_imgV_showImg) {
                        _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-15-5-img.size.width/2,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:model.photoImage isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                        RELEASE(_imgV_showImg);
                        
                        
                        DLogInfo(@"======%@",model.ext.img_url);
                        
                        
                        NSDictionary *_dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:model, @"model", @"我是成功的-11111图片", @"type", nil];
                        
                        [_imgV_showImg addSignal:[UIView TAP] object:_dicInfo];
                        
                        RELEASE(_dicInfo);
                        
                        if (!model.photoImage) {
                            
                            [_imgV_showImg setImgWithUrl:model.ext.img_url defaultImg:no_pic_50];
                            
                        }else {
//                            [_imgV_showImg setImage:model.photoImage];
                        }
                        
                    }
                    
                    if (!_v_Contentback) {
                        _v_Contentback=[[UIView alloc]initWithFrame:CGRectMake(0,0, _imgV_showImg.frame.size.width+10, _imgV_showImg.frame.size.height+10)];
                        _v_Contentback.backgroundColor=ColorBlue;
                        _v_Contentback.layer.masksToBounds=YES;
                        _v_Contentback.layer.cornerRadius=5;
                        
                        [self addSubview:_v_Contentback];
                        _v_Contentback.center=_imgV_showImg.center;
                        RELEASE(_v_Contentback);
                        [self bringSubviewToFront:_imgV_showImg];
                        
                        {//右侧蓝色箭头
                            UIImage *img=[UIImage imageNamed:@"tail_blue"];
                            MagicUIImageView *imgV_Arrow=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_v_Contentback.frame)-img.size.width/2-floor(CGRectGetWidth(_v_Contentback.frame)/10), CGRectGetMaxY(_v_Contentback.frame)+42, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                            RELEASE(imgV_Arrow);
                            _imgV_ArrowR=imgV_Arrow;
                        }
                    }
                    
                    if (!_lb_time) {
                        _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                        _lb_time.backgroundColor=[UIColor clearColor];
                        _lb_time.textAlignment=NSTextAlignmentLeft;
                        _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                        _lb_time.text=((model.time)?([NSString transFormTimeStampToDateFormatter:model.time]):(model.str_time));
                        [_lb_time setNeedCoretext:NO];
                        _lb_time.textColor=Colortime;
                        _lb_time.numberOfLines=0;
                        
                        _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
                        [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_time.frame.origin.x, 100)];
                        
                        [self addSubview:_lb_time];
                        
                        [_lb_time setFrame:CGRectMake(_v_Contentback.frame.origin.x-10-_lb_time.frame.size.width, _lb_time.frame.origin.y, _lb_time.frame.size.width, _lb_time.frame.size.height)];
                        RELEASE(_lb_time);
                        _lb_time.hidden=!(model.SucessSend==1);

                    }
                    
                    [self setFrame:CGRectMake(0, 0, self.frame.size.width, _v_Contentback.frame.size.height+20)];
                    [_imgV_showImg changePosInSuperViewWithAlignment:1];
                    _v_Contentback.center=_imgV_showImg.center;
                    [_lb_time changePosInSuperViewWithAlignment:1];
                    
                    if (!_imagV_fail) {
                        UIImage *imag = [UIImage imageNamed:@"send_fail.png"];
                        
                        DLogInfo(@"======%@",model.ext.img_url);
                        
                        _imagV_fail=[[MagicUIImageView alloc]initWithFrame:CGRectMake(_v_Contentback.frame.origin.x-10-imag.size.width/2, 15, imag.size.width/2, imag.size.height/2)];
                        
                        NSDictionary *_dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:model, @"model", @"我是失败的-11111图片", @"type", nil];
                        [_imagV_fail addSignal:[UIView TAP] object:_dicInfo];
                        
                        [_imagV_fail setImage:imag];
                        [self addSubview:_imagV_fail];
                        _imagV_fail.hidden= !_lb_time.hidden;
                        
                        RELEASE(_imagV_fail);
                    }
                    
                    
                }else{//左侧
                    UIImage *img=[UIImage imageNamed:@"img_loading.png"];
                    
                    if (!_imgV_showImg) {
                        _imgV_showImg=[[MagicUIImageView alloc]initWithFrame:CGRectMake(20,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                        RELEASE(_imgV_showImg);
                        NSDictionary *_dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:model, @"model", @"我是成功的-11111图片", @"type", nil];
                        [_imgV_showImg addSignal:[UIView TAP] object:_dicInfo];
                        [_imgV_showImg setImgWithUrl:model.ext.img_url defaultImg:no_pic_50];
                    }
                    
                    if (!_v_Contentback) {
                        _v_Contentback=[[UIView alloc]initWithFrame:CGRectMake(0,0, _imgV_showImg.frame.size.width+10, _imgV_showImg.frame.size.height+10)];
                        _v_Contentback.backgroundColor=BKGGray;
                        _v_Contentback.layer.masksToBounds=YES;
                        _v_Contentback.layer.cornerRadius=5;
                        
                        [self addSubview:_v_Contentback];
                        _v_Contentback.center=_imgV_showImg.center;
                        RELEASE(_v_Contentback);
                        [self bringSubviewToFront:_imgV_showImg];
                        
                        {//左侧蓝色箭头
                            UIImage *img=[UIImage imageNamed:@"tail_gray"];
                            MagicUIImageView *imgV_Arrow=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_v_Contentback.frame)+floor(CGRectGetWidth(_v_Contentback.frame)/10), CGRectGetMaxY(_v_Contentback.frame)+42, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                            RELEASE(imgV_Arrow);
                            _imgV_ArrowL=imgV_Arrow;
                        }
                    }
                    
                    if (!_lb_time) {
                        _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                        _lb_time.backgroundColor=[UIColor clearColor];
                        _lb_time.textAlignment=NSTextAlignmentLeft;
                        _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:11];
                        _lb_time.text=((model.time)?([NSString transFormTimeStampToDateFormatter:model.time]):(model.str_time));
                        [_lb_time setNeedCoretext:NO];
                        _lb_time.textColor=Colortime;
                        _lb_time.numberOfLines=0;
                        
                        _lb_time.lineBreakMode=NSLineBreakByTruncatingTail;
                        [_lb_time sizeToFitByconstrainedSize:CGSizeMake(self.frame.size.width-_lb_time.frame.origin.x, 100)];
                        
                        [self addSubview:_lb_time];
                        
                        [_lb_time setFrame:CGRectMake(_v_Contentback.frame.origin.x+_v_Contentback.frame.size.width+10, _lb_time.frame.origin.y, _lb_time.frame.size.width, _lb_time.frame.size.height)];
                        RELEASE(_lb_time);
                        _lb_time.hidden=!(model.SucessSend==1);

                    }
                    
                    [self setFrame:CGRectMake(0, 0, self.frame.size.width, _v_Contentback.frame.size.height+20)];
                    [_imgV_showImg changePosInSuperViewWithAlignment:1];
                    _v_Contentback.center=_imgV_showImg.center;
                    [_lb_time changePosInSuperViewWithAlignment:1];
                    [_imgV_ArrowR setFrame:CGRectMake(CGRectGetMinX(_imgV_ArrowR.frame), CGRectGetMaxY(_v_Contentback.frame), CGRectGetWidth(_imgV_ArrowR.frame), CGRectGetHeight(_imgV_ArrowR.frame))];
                    [_imgV_ArrowL setFrame:CGRectMake(CGRectGetMinX(_imgV_ArrowL.frame), CGRectGetMaxY(_v_Contentback.frame), CGRectGetWidth(_imgV_ArrowL.frame), CGRectGetHeight(_imgV_ArrowL.frame))];

                }
                
                if (!_imagV_fail) {
                    UIImage *imag = [UIImage imageNamed:@"send_fail.png"];
                    
                    _imagV_fail=[[MagicUIImageView alloc]initWithFrame:CGRectMake(_v_Contentback.frame.origin.x+10+_v_Contentback.frame.size.width, 15, imag.size.width/2, imag.size.height/2)];
                    
                    NSDictionary *_dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:model, @"model", @"我是失败的-11111图片", @"type", nil];
                    [_imagV_fail addSignal:[UIView TAP] object:_dicInfo];
                    [_imagV_fail setImage:imag];
                    [self addSubview:_imagV_fail];
                    _imagV_fail.hidden= !_lb_time.hidden;
                    RELEASE(_imagV_fail);
                    
                }
                

                
            }
                break;
                
            default:
                break;
        }
        
    }

//{//分割线
//    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-1), self.frame.size.width, 0.5)];
//    [v setBackgroundColor:[MagicCommentMethod colorWithHex:@"0xeeeeee"]];
//    [self addSubview:v];
//    RELEASE(v);
//}
}

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range {
    return index > range.location && index < range.location+range.length;
}

- (void)highlightLinksWithIndex:(CFIndex)index {
    
    NSMutableAttributedString* attributedString = [self._lb_content.attributedText mutableCopy];
    
    for (NSTextCheckingResult *match in self.matches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:index inRange:matchRange]) {
                
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:matchRange];
            }
            else {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:matchRange];
            }
            
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
        }
    }
    
    self._lb_content.attributedText = attributedString;
}

-(void)dealloc
{
    [_imgV_showImg removeAllSignal];
    
    [super dealloc];
}
@end
