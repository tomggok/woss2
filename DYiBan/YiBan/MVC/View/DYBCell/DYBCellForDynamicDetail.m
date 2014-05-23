//
//  DYBCellForDynamicDetail.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForDynamicDetail.h"
#import "NSString+Count.h"
#import "UIImageView+WebCache.h"
#import "NSString+Count.h"
#import "DYBCustomLabel.h"
#import "UILabel+ReSize.h"
#import "DYBDynamicDetailViewController.h"

@implementation DYBCellForDynamicDetail
@synthesize strContent;

-(void)dealloc{
    [super dealloc];
    
    if (strContent) {
        RELEASE(strContent);
    }
}


-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    if (data){
        float fHeight = 0;
        _dynamicStatus = data;
        
        NSMutableArray *arrIMG = [[NSMutableArray alloc] initWithObjects:nil];
        
        if ([_dynamicStatus.pic_array count] > 0) {
            for (NSDictionary *pics in _dynamicStatus.pic_array) {
                [arrIMG addObject:[pics objectForKey:@"pic_s"]];
            }
        }
        
        fHeight = [self DynamicUserInfo:_dynamicStatus.user_info.name userPortraitURL:_dynamicStatus.user_info.pic time:_dynamicStatus.time Location:nil From:_dynamicStatus.from];
        fHeight = [self DynamicContentInfo:_dynamicStatus.content target:(NSArray*)_dynamicStatus.target user:_dynamicStatus.user_info contentIMG:arrIMG StartY:fHeight bShare:NO];
        
        if ([_dynamicStatus.isfollow isEqualToString:@"1"]) {
            
            if ([_dynamicStatus.status isKindOfClass:[status class]]) {
                
                if ([_dynamicStatus.status.pic_array count] > 0){
                    for (NSDictionary *pics in _dynamicStatus.status.pic_array) {
                        [arrIMG addObject:[pics objectForKey:@"pic_s"]];
                    }
                }
                
                fHeight = [self DynamicContentInfo:_dynamicStatus.status.content target:(NSArray*)_dynamicStatus.status.target user:_dynamicStatus.status.user_info contentIMG:arrIMG StartY:fHeight bShare:YES];
            }else{
                fHeight = [self DynamicDeleteWarning:fHeight];
            }
 
        }
        
        if ([arrIMG count] > 0) {
            RELEASEDICTARRAYOBJ(arrIMG);
        }
        
        fHeight = fHeight+15;
        
        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), fHeight)];
    }
}

#pragma mark- 设置动态列表用户头像和昵称
-(float)DynamicUserInfo:(NSString *)userName userPortraitURL:(NSString *)userPortraitURL time:(NSString *)strTime Location:(NSString *)strLocation From:(NSString *)strFrom{
    float fHeight = 80.0f;
    NSString *_strTail = nil;
    
    MagicUIImageView *_imgUserPortrait = [[MagicUIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    [_imgUserPortrait setNeedRadius:YES];
    [_imgUserPortrait setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserWithGesture:)];
    [_imgUserPortrait addGestureRecognizer:tapGestureRecognizer];
    RELEASE(tapGestureRecognizer);
    NSString *encondeUrl= [userPortraitURL stringByAddingPercentEscapesUsingEncoding];
    if ([NSURL URLWithString:encondeUrl] == nil) {
        [_imgUserPortrait setImage:[UIImage imageNamed:@"no_pic_50.png"]];
    }else
    {
        _imgUserPortrait._b_isShade=NO;
        [_imgUserPortrait setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic_50.png"]];
        
    }
    RELEASE(_imgUserPortrait);
    
    MagicUILabel *_lbUserName = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgUserPortrait.frame)+15, CGRectGetMinY(_imgUserPortrait.frame)+3, 200, 30)];
    [_lbUserName setBackgroundColor:[UIColor clearColor]];
    [_lbUserName setTextAlignment:NSTextAlignmentLeft];
    [_lbUserName setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [_lbUserName setText:userName];
    [_lbUserName setTextColor:ColorBlack];
    [_lbUserName setNumberOfLines:1];
    [_lbUserName setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self addSubview:_lbUserName];
    RELEASE(_lbUserName);
    
    strTime = [NSString transFormTimeStamp:[strTime intValue]];
    
    if ([strLocation length] == 0) {
        _strTail = [NSString stringWithFormat:@"%@ • %@", strTime, strFrom];
    }else{
        _strTail = [NSString stringWithFormat:@"%@ •　%@ • %@", strTime, strLocation, strFrom];
    }
    
    MagicUILabel *_lbComment = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgUserPortrait.frame)+15, CGRectGetMaxY(_lbUserName.frame), 255, fHeight)];
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
    
    return fHeight;
}

#pragma mark- 设置动态内容或转发内容 bShare判断：Yes为转发，NO为动态
-(float)DynamicContentInfo:(NSString *)dynamicContent target:(NSArray *)target user:(user *)user contentIMG:(NSArray *)arrIMG StartY:(float)fStartY bShare:(BOOL)bShare{
    float fHeight = 0.0f;
    UIImage *_imgDividingLine = [UIImage imageNamed:@"share_dotline.png"];
    
    if (bShare) {
        MagicUIImageView * _topDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(15, fStartY+15, 290, 2) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        [self addSubview:_topDividingLine];
        RELEASE(_topDividingLine);
        
        dynamicContent = [NSString stringWithFormat:@"转: @%@ %@", user.name, dynamicContent];
    }
    
    DYBCustomLabel *_lbSelfContent = [[DYBCustomLabel alloc] initWithFrame:CGRectMake(15, 80, 290, 100) target:target];
    [_lbSelfContent setBackgroundColor:[UIColor clearColor]];
    [_lbSelfContent setTextAlignment:NSTextAlignmentLeft];
    [_lbSelfContent setFont:[DYBShareinstaceDelegate DYBFoutStyle:17]];
    [_lbSelfContent setText:dynamicContent];
    
    if ([target count] > 0) {
        [_lbSelfContent replaceEmojiandTarget:YES];
    }else{
        [_lbSelfContent setLineBreakMode:NSLineBreakByTruncatingTail];
        [_lbSelfContent sizeToFit];
        [_lbSelfContent setNumberOfLines:0];
        [_lbSelfContent setFontFitToSize:CGSizeMake(290, 300)];
        [_lbSelfContent replaceEmojiandTarget:NO];
    }
    
    if (bShare == NO) {
        strContent =_lbSelfContent.text;
    }
    
    if (bShare) {
        [_lbSelfContent setFrame:CGRectMake(15, fStartY+25, 290, CGRectGetHeight(_lbSelfContent.frame))];
        [_lbSelfContent setTextColor:ColorGray];
        _lbSelfContent.COLOR(@"3", [NSString stringWithFormat:@"%d", [user.name length]+1],ColorBlue);
        _lbSelfContent.CLICK(@"3", [NSString stringWithFormat:@"%d", [user.name length]+1],ColorBlack, [NSString stringWithFormat:@"1|%@|%@", user.userid, user.name]);
    }else{
        [_lbSelfContent setTextColor:ColorBlack];
        fHeight = CGRectGetMaxY(_lbSelfContent.frame);
    }
    
    NSString *strWhitespace =nil;
    strWhitespace = [dynamicContent stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([dynamicContent length] == 0 || [strWhitespace length] == 0) {
        if (bShare){
            [_lbSelfContent setFrame:CGRectMake(15, fStartY+25, 0, 0)];
            fHeight = fStartY+25;
        }else{
            [_lbSelfContent setFrame:CGRectMake(15, 70, 0, 0)];
            fHeight = 50;
        }
    }
    
    if ([arrIMG count] > 0) {
        NSInteger nIMAGECount  = [arrIMG count];
        
        for (int nIndex = 0; nIndex < nIMAGECount; nIndex ++) {
            MagicUIImageView *_imgDynamicIMAGE = [[MagicUIImageView alloc] initWithFrame:CGRectMake(15+70*nIndex, CGRectGetMaxY(_lbSelfContent.frame)+15+nIndex/3*85, 60, 75) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleToFill stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            
            [_imgDynamicIMAGE setTag:nIndex];
            
            if (nIndex > 2) {
                [_imgDynamicIMAGE setFrame:CGRectMake(15+70*(nIndex-3), CGRectGetMinY(_imgDynamicIMAGE.frame), CGRectGetWidth(_imgDynamicIMAGE.frame), CGRectGetHeight(_imgDynamicIMAGE.frame))];
            }
            
            NSString *encondeUrl= [[arrIMG objectAtIndex:nIndex] stringByAddingPercentEscapesUsingEncoding];
            if ([NSURL URLWithString:encondeUrl] == nil) {
                [_imgDynamicIMAGE setImage:[UIImage imageNamed:@"no_pic.png"]];
            }else{
                _imgDynamicIMAGE._b_isShade=NO;
                [_imgDynamicIMAGE setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic.png"]];
                
            }
            
            [_imgDynamicIMAGE setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapImageWithGesture:)];
            [_imgDynamicIMAGE addGestureRecognizer:tapGestureRecognizer];
            RELEASE(tapGestureRecognizer);
            
            RELEASE(_imgDynamicIMAGE);
            
            fHeight = CGRectGetMaxY(_imgDynamicIMAGE.frame);
        }
    }
    
    if (bShare) {
        if ([arrIMG count] > 0) {
            MagicUIImageView *_bottomDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(15, fHeight+15, 290, 2) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            [self addSubview:_bottomDividingLine];
            RELEASE(_bottomDividingLine);
            fHeight = CGRectGetMaxY(_bottomDividingLine.frame);
        }else{
            MagicUIImageView *_bottomDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_lbSelfContent.frame)+10, 290, 2) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            [self addSubview:_bottomDividingLine];
            RELEASE(_bottomDividingLine);
            fHeight = CGRectGetMaxY(_lbSelfContent.frame)+10;
        }
    }
    
    [self addSubview:_lbSelfContent];
    RELEASE(_lbSelfContent);
    
    return fHeight;
}

#pragma mark- 动态被删除信息
-(float)DynamicDeleteWarning:(float)fStartY{
    float fHeight = 0.0f;
    UIImage *_imgDividingLine = [UIImage imageNamed:@"share_dotline.png"];
    
    MagicUIImageView * _topDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(15, fStartY+15, 290, 2) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    RELEASE(_topDividingLine);
    
    MagicUILabel *_lbSelfContent = [[MagicUILabel alloc] initWithFrame:CGRectMake(15, fStartY+30, 290, 60)];
    [_lbSelfContent setBackgroundColor:[UIColor clearColor]];
    [_lbSelfContent setTextAlignment:NSTextAlignmentLeft];
    [_lbSelfContent setFont:[DYBShareinstaceDelegate DYBFoutStyle:17]];
    [_lbSelfContent setText:@"该动态已被删除!"];
    [_lbSelfContent setTextColor:ColorGray];
    [_lbSelfContent sizeToFitByconstrainedSize:CGSizeMake(290, 90)];
    [self addSubview:_lbSelfContent];
    RELEASE(_lbSelfContent);
    
    fHeight = CGRectGetMaxY(_lbSelfContent.frame);
    
    MagicUIImageView *_bottomDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(15, fHeight+10, 290, 2) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    RELEASE(_bottomDividingLine);
    
    fHeight = CGRectGetMaxY(_bottomDividingLine.frame);
    
    return fHeight;
}


- (void)didTapImageWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
        DLogInfo(@"%d", tappedView.tag);
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", tappedView.tag], @"tag", _dynamicStatus, @"status", nil];
        [self sendViewSignal:[DYBDynamicDetailViewController DYNAMICDIMAGEETAIL] withObject:dic];
        RELEASE(dic);
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

- (void)didTapUserWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
        DLogInfo(@"%d", tappedView.tag);
        
        NSDictionary *dicUser = [[NSDictionary alloc] initWithObjectsAndKeys:_dynamicStatus.user_info.userid, @"userid", _dynamicStatus.user_info.name, @"username", nil];
        [self sendViewSignal:[DYBDynamicDetailViewController PERSONALPAGE] withObject:[dicUser retain]];
        RELEASE(dicUser);
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}
@end
