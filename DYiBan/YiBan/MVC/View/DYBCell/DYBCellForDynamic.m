//
//  DYBCellForDynamic.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForDynamic.h"
#import "NSString+Count.h"
#import "UIImageView+WebCache.h"
#import "NSString+Count.h"
#import "DYBCustomLabel.h"
#import "UILabel+ReSize.h"
#import "DYBDynamicViewController.h"
#import "comment_num_info.h"
#import "good_num_info.h"
#import <QuartzCore/QuartzCore.h>
#import "DYBActivityViewController.h"

@implementation DYBCellForDynamic

DEF_SIGNAL(QUICKFUNCTION)
DEF_SIGNAL(QUICKLIKE)
DEF_SIGNAL(QUICKCOMMENT)

-(void)dealloc{
//    RELEASE(_dynamicStatus);
    [super dealloc];
}

#pragma mark- 设置整体Cell
-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    if (data){        
        float fHeight = 0;
        _dynamicStatus = data;
        _nRow = indexPath.row;
        static float fTailHeight = 0;
        
        NSMutableArray *arrIMG = [[NSMutableArray alloc] initWithObjects:nil];
        
        if ([_dynamicStatus.pic_array count] > 0) {  
            for (NSDictionary *pics in _dynamicStatus.pic_array) {
                [arrIMG addObject:[pics objectForKey:@"pic_s"]];
            }
        }
        
        fHeight = [self DynamicUserInfo:_dynamicStatus.user_info.name userPortraitURL:_dynamicStatus.user_info.pic];
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
        
        fHeight = fHeight + [self DynamicTail:_dynamicStatus.time Location:_dynamicStatus.address From:_dynamicStatus.from StartY:fHeight];
        
        fTailHeight = fHeight+10;
        
        if ([_dynamicStatus.good_num intValue] > 0 && _dynamicStatus.type != 15) {
            
            float bHeightRec = fHeight;
            
            NSMutableArray *arrLikers = [[NSMutableArray alloc] init];
            
            for (good_num_info *likers in _dynamicStatus.good_num_info) {
                [arrLikers addObject:likers.name];
            }
            
            fHeight = [self DynamicLikers:arrLikers likerCount:_dynamicStatus.good_num StartY:fHeight+5];
            
            RELEASEDICTARRAYOBJ(arrLikers);
            
            UIView *viewCoverLike = [[UIView alloc] initWithFrame:CGRectMake(55, bHeightRec, 255, fHeight-bHeightRec)];
            [viewCoverLike setBackgroundColor:[UIColor clearColor]];
            [self addSubview:viewCoverLike];
            [self bringSubviewToFront:viewCoverLike];
            RELEASE(viewCoverLike);
            
            [viewCoverLike setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapLikeWithGesture:)];
            [viewCoverLike addGestureRecognizer:tapGestureRecognizer];
            RELEASE(tapGestureRecognizer);
            
            if ([_dynamicStatus.comment_num_info count] == 0){
                fHeight = fHeight-5;
            }
        }
        
        if ([_dynamicStatus.comment_num_info count] > 0) {
            
            if ([_dynamicStatus.good_num intValue] > 0 && _dynamicStatus.type != 15) {
                fHeight = fHeight - 10;
            }
            
            if ([_dynamicStatus.good_num intValue] > 0 && _dynamicStatus.type != 15) {
                MagicUIImageView *_imgDevingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(58, fHeight+13, 250, 1) backgroundColor:[UIColor clearColor] image:[UIImage imageNamed:@"comment_sepline.png"] isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                
                [self addSubview:_imgDevingLine];
                RELEASE(_imgDevingLine);
                
            }
            
            float bHeightRec = fHeight;
            
            NSMutableArray *arrComments = [[NSMutableArray alloc] init];
            
            for (comment_num_info *comments in _dynamicStatus.comment_num_info) {
                [arrComments addObject:comments.name];
            }
            
            fHeight = [self DynamicComments:arrComments commentCount:_dynamicStatus.comment_num StartY:fHeight+5];
            
            fHeight = fHeight+1;
            
            int nTotal = [_dynamicStatus.comment_num_info count];
                 
            for (int i = 0; i < nTotal; i++) {
                if (i == 2)
                    break;
                
                comment_num_info *comments = [_dynamicStatus.comment_num_info objectAtIndex:nTotal-i-1];
                fHeight = [self DynamicCommetContent:comments.name commenterPortraitURL:comments.pic commentContent:comments.comment StartY:fHeight];
            }
            
            RELEASEDICTARRAYOBJ(arrComments);
            
            UIView *viewCoverComment = [[UIView alloc] initWithFrame:CGRectMake(55, bHeightRec, 255, fHeight-bHeightRec)];
            [viewCoverComment setBackgroundColor:[UIColor clearColor]];
            [self addSubview:viewCoverComment];
            [self bringSubviewToFront:viewCoverComment];
            RELEASE(viewCoverComment);
            
            [viewCoverComment setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapCommentWithGesture:)];
            [viewCoverComment addGestureRecognizer:tapGestureRecognizer];
            RELEASE(tapGestureRecognizer);
        }
        
        if (fHeight > fTailHeight) {
            MagicUIImageView *viewBKG = [self DynamicLikeandCommentBackground:fTailHeight bottomHeight:fHeight+5];
            [self addSubview:viewBKG];
            [self sendSubviewToBack:viewBKG];
            RELEASE(viewBKG);
            
            fHeight = fHeight+10;
        }
           
        fHeight = fHeight+10;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, fHeight-1, self.frame.size.width, .5f)];
        [lineView setBackgroundColor:ColorDivLine];
        [self addSubview:lineView];
        RELEASE(lineView);

        [self setUserInteractionEnabled:YES];
        
        if (_dynamicStatus.type != 8) {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapLabelWithGesture:)];
            [self addGestureRecognizer:tapGestureRecognizer];
            RELEASE(tapGestureRecognizer);
        }
        
        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), fHeight)];
    }
}

#pragma mark- 设置动态列表用户头像和昵称
-(float)DynamicUserInfo:(NSString *)userName userPortraitURL:(NSString *)userPortraitURL{
    float fHeight = 50.0f;
    
    MagicUIImageView *_imgUserPortrait = [[MagicUIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    [_imgUserPortrait setNeedRadius:YES];
    [_imgUserPortrait setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserWithGesture:)];
    [_imgUserPortrait addGestureRecognizer:tapGestureRecognizer];
    RELEASE(tapGestureRecognizer);
    
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
    
    if (_dynamicStatus.type != 8) {
        UIImage *imgQuick = [UIImage imageNamed:@"quick_btn.png"];
        _btnQuick = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-15-imgQuick.size.width/2, 12, imgQuick.size.width/2, imgQuick.size.height/2)];
        [_btnQuick setBackgroundColor:[UIColor clearColor]];
        [_btnQuick setBackgroundImage:imgQuick forState:UIControlStateNormal];
        [_btnQuick addSignal:[DYBCellForDynamic QUICKFUNCTION] forControlEvents:UIControlEventTouchUpInside];
        [_btnQuick setSelected:NO];
        [self addSubview:_btnQuick];
//        RELEASE(_btnQuick);
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.0) {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQuick)];
            [_btnQuick addGestureRecognizer:tapGestureRecognizer];
            RELEASE(tapGestureRecognizer);
        }
        
    }
    
    return fHeight;
}

#pragma mark- 设置动态内容或转发内容 bShare判断：Yes为转发，NO为动态,只有转发或者非转发2种情况布局,转发时的最多布局为:内容+横虚线+转发内容+转发图片+横虚线+时间地点+赞和评论视图;  非转发的最多布局为:内容+图片+时间地点+赞和评论视图
-(float)DynamicContentInfo:(NSString *)dynamicContent target:(NSArray *)target user:(user *)user contentIMG:(NSArray *)arrIMG StartY:(float)fStartY bShare:(BOOL)bShare{
    float fHeight = 0.0f;
    UIImage *_imgDividingLine = [UIImage imageNamed:@"share_dotline.png"];
    
    if (bShare) {
        MagicUIImageView * _topDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(55, fStartY+15, 255, 2) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        RELEASE(_topDividingLine);
        
        dynamicContent = [NSString stringWithFormat:@"转: @%@ %@", user.name, dynamicContent];        
    }
    

    DYBCustomLabel *_lbSelfContent = [[DYBCustomLabel alloc] initWithFrame:CGRectMake(55, 50, 255, 60) target:target];
    [_lbSelfContent setBackgroundColor:[UIColor clearColor]];
    [_lbSelfContent setTextAlignment:NSTextAlignmentLeft];
    [_lbSelfContent setFont:[DYBShareinstaceDelegate DYBFoutStyle:17]];
    [_lbSelfContent setText:dynamicContent];
    
    if ([target count] > 0) {
        [_lbSelfContent setMaxLineNum:3];
        [_lbSelfContent setImgType:1];
//        [_lbSelfContent sizeToFitByconstrainedSize:CGSizeMake(255, 90)];
        [_lbSelfContent setFontFitToSize:CGSizeMake(255, 90)];
        [_lbSelfContent replaceEmojiandTarget:YES];
    }else
    {
        [_lbSelfContent setLineBreakMode:NSLineBreakByTruncatingTail];
        [_lbSelfContent setMaxLineNum:3];
        [_lbSelfContent setImgType:1];
        [_lbSelfContent setFontFitToSize:CGSizeMake(255, 90)];
        [_lbSelfContent replaceEmojiandTarget:NO];
    }

    if (bShare) {
        [_lbSelfContent setFrame:CGRectMake(55, fStartY+25, 255, CGRectGetHeight(_lbSelfContent.frame))];
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
            [_lbSelfContent setFrame:CGRectMake(55, fStartY+25, 0, 0)];
            fHeight = fStartY+25;
        }else{
            [_lbSelfContent setFrame:CGRectMake(55, 40, 0, 0)];
            fHeight = 50;
        }
    }
    
    if ([arrIMG count] > 0) {
        NSInteger nIMAGECount  = [arrIMG count];
        
        for (int nIndex = 0; nIndex < nIMAGECount; nIndex ++) {
            MagicUIImageView *_imgDynamicIMAGE = [[MagicUIImageView alloc] initWithFrame:CGRectMake(65+70*nIndex, CGRectGetMaxY(_lbSelfContent.frame)+15+nIndex/3*85, 60, 75) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleToFill stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            [_imgDynamicIMAGE setTag:nIndex];
            
            if (nIndex > 2) {
                [_imgDynamicIMAGE setFrame:CGRectMake(65+70*(nIndex-3), CGRectGetMinY(_imgDynamicIMAGE.frame), CGRectGetWidth(_imgDynamicIMAGE.frame), CGRectGetHeight(_imgDynamicIMAGE.frame))];
            }
            
            NSString *encondeUrl= [[arrIMG objectAtIndex:nIndex] stringByAddingPercentEscapesUsingEncoding];
            if ([NSURL URLWithString:encondeUrl] == nil) {
                [_imgDynamicIMAGE setImage:[UIImage imageNamed:@"no_pic.png"]];
            }else{
                _imgDynamicIMAGE._b_isShade=NO;
                [_imgDynamicIMAGE setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic.png"]];
                
            }
            
            [_imgDynamicIMAGE setUserInteractionEnabled:YES];
            
            if (_dynamicStatus.type != 8) {
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapImageWithGesture:)];
                [_imgDynamicIMAGE addGestureRecognizer:tapGestureRecognizer];
                 RELEASE(tapGestureRecognizer);
            }

            RELEASE(_imgDynamicIMAGE);
            
            fHeight = CGRectGetMaxY(_imgDynamicIMAGE.frame);
        }
    }
    
    if (bShare) {
        if ([arrIMG count] > 0) {
            MagicUIImageView *_bottomDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(55, fHeight+15, 255, 2) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            RELEASE(_bottomDividingLine);
            fHeight = CGRectGetMaxY(_bottomDividingLine.frame);
        }else{
            MagicUIImageView *_bottomDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(55, CGRectGetMaxY(_lbSelfContent.frame)+10, 255, 2) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            RELEASE(_bottomDividingLine);
            fHeight = CGRectGetMaxY(_lbSelfContent.frame)+10;
        }
    }  
    
    [self addSubview:_lbSelfContent];
    RELEASE(_lbSelfContent);
  
    return fHeight;
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
    
    MagicUIImageView *_iconLike = [[MagicUIImageView alloc] initWithFrame:CGRectMake(65, fStartY + 10, 20, 20) backgroundColor:[UIColor clearColor] image:_imgLike isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];

    
    _lbLikeCount = [[MagicUILabel alloc] initWithFrame:CGRectMake(247, CGRectGetMinY(_iconLike.frame)+4, 59, 25)];
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
    
    _lbLiker = [[MagicUILabel alloc] initWithFrame:CGRectMake(93, CGRectGetMinY(_iconLike.frame)-2, 125, 25)];
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

#pragma mark- 动态被删除信息
-(float)DynamicDeleteWarning:(float)fStartY{
    float fHeight = 0.0f;
     UIImage *_imgDividingLine = [UIImage imageNamed:@"share_dotline.png"];
    
    MagicUIImageView * _topDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(55, fStartY+15, 255, 2) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    RELEASE(_topDividingLine);

    MagicUILabel *_lbSelfContent = [[MagicUILabel alloc] initWithFrame:CGRectMake(55, fStartY+30, 255, 60)];
    [_lbSelfContent setBackgroundColor:[UIColor clearColor]];
    [_lbSelfContent setTextAlignment:NSTextAlignmentLeft];
    [_lbSelfContent setFont:[DYBShareinstaceDelegate DYBFoutStyle:17]];
    [_lbSelfContent setText:@"该动态已被删除!"];
    [_lbSelfContent setTextColor:ColorGray];
    [_lbSelfContent sizeToFitByconstrainedSize:CGSizeMake(255, 90)];
    [self addSubview:_lbSelfContent];
    RELEASE(_lbSelfContent);
    
    fHeight = CGRectGetMaxY(_lbSelfContent.frame);
    
    MagicUIImageView *_bottomDividingLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(55, fHeight+10, 255, 2) backgroundColor:[UIColor clearColor] image:_imgDividingLine isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    RELEASE(_bottomDividingLine);
    
    fHeight = CGRectGetMaxY(_bottomDividingLine.frame);

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
        _strComments = [_strComments stringByAppendingString:@"   "];
    }
    
    _strComments = [_strComments stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    MagicUIImageView *_iconComment = [[MagicUIImageView alloc] initWithFrame:CGRectMake(65, fStartY+14, 20, 20) backgroundColor:[UIColor clearColor] image:_imgComment isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    
    
    MagicUILabel *_lbCommentCount = [[MagicUILabel alloc] initWithFrame:CGRectMake(247, CGRectGetMinY(_iconComment.frame)+4, 59, 25)];
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

    MagicUILabel *_lbComment = [[MagicUILabel alloc] initWithFrame:CGRectMake(93, CGRectGetMinY(_iconComment.frame)-2, 125, 25)];
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
-(MagicUIImageView *)DynamicLikeandCommentBackground:(float)fStartY bottomHeight:(float)fBotomY{
    
    MagicUIImageView *_imgArrow = [[MagicUIImageView alloc] initWithFrame:CGRectMake(72, fStartY-4, 11, 4) backgroundColor:[UIColor clearColor] image:[UIImage imageNamed:@"icon_arrow_up.png"] isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    RELEASE(_imgArrow);

    MagicUIImageView *_BKGView = [[MagicUIImageView alloc] initWithFrame:CGRectMake(55, fStartY, 255, fBotomY - fStartY)];
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
    
    MagicUIImageView *_imgUserPortrait = [[MagicUIImageView alloc] initWithFrame:CGRectMake(65, fStartY+5, 30, 30) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    [_imgUserPortrait setNeedRadius:YES];
    
    NSString *encondeUrl= [portraitURL stringByAddingPercentEscapesUsingEncoding];
    if ([NSURL URLWithString:encondeUrl] == nil) {
        [_imgUserPortrait setImage:[UIImage imageNamed:@"no_pic_30b.png"]];
    }else{
        _imgUserPortrait._b_isShade=NO;
        [_imgUserPortrait setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic_30b.png"]];
        
    }
    
    MagicUILabel *_lbUserName = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgUserPortrait.frame)+8, CGRectGetMinY(_imgUserPortrait.frame)-8, 200, 30)];
    [_lbUserName setBackgroundColor:[UIColor clearColor]];
    [_lbUserName setTextAlignment:NSTextAlignmentLeft];
    [_lbUserName setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [_lbUserName setText:commenterName];
    [_lbUserName setTextColor:ColorBlack];
    [_lbUserName setNumberOfLines:1];
    [_lbUserName setLineBreakMode:NSLineBreakByTruncatingTail];
//    [_lbUserName sizeToFit];
    
    
    DYBCustomLabel *_lbComment = [[DYBCustomLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgUserPortrait.frame)+8, CGRectGetMaxY(_lbUserName.frame)-5, 200, 30)];
    
    DLogInfo(@"height === %f", _lbComment.frame.size.height);
    
    [_lbComment setBackgroundColor:[UIColor clearColor]];
    [_lbComment setTextAlignment:NSTextAlignmentLeft];
    [_lbComment setFont:[DYBShareinstaceDelegate DYBFoutStyle:13]];
    [_lbComment setText:content];
    [_lbComment setTextColor:ColorContentGray];
    [_lbComment setLineBreakMode:NSLineBreakByTruncatingTail];
    [_lbComment setMaxLineNum:2];
    [_lbComment setImgType:2];
    [_lbComment sizeToFitByconstrainedSize:CGSizeMake(200, 60)];
    [_lbComment replaceEmojiandTarget:NO];
    
    
    DLogInfo(@"height === %f", _lbComment.frame.size.height);
    
    [self addSubview:_lbUserName];
    [self addSubview:_lbComment];
    
    RELEASE(_imgUserPortrait);
    RELEASE(_lbUserName);
    RELEASE(_lbComment);
    
    fHeight = CGRectGetMaxY(_lbComment.frame)+5;

    return fHeight;
}

#pragma mark- 动态的尾巴，含时间,位置和来自
-(float)DynamicTail:(NSString *)strTime Location:(NSString *)strLocation From:(NSString *)strFrom StartY:(float)fStartY{
    float fHeight = 30;
    NSString *_strTail = nil;
    
    strTime = [NSString transFormTimeStamp:[strTime intValue]];
    
    if (_dynamicStatus.type == 8){
         _strTail = [NSString stringWithFormat:@"%@ 发布了通知", strTime];
        
    }else{
        if ([strLocation length] == 0) {
            _strTail = [NSString stringWithFormat:@"%@ • %@", strTime, strFrom];
        }else{
            _strTail = [NSString stringWithFormat:@"%@ •　%@ • %@", strTime, strLocation, strFrom];
        }
    }
    
    MagicUILabel *_lbComment = [[MagicUILabel alloc] initWithFrame:CGRectMake(55, fStartY+15, 255, fHeight)];
    [_lbComment setBackgroundColor:[UIColor clearColor]];
    [_lbComment setTextAlignment:NSTextAlignmentLeft];
    [_lbComment setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
    [_lbComment setText:_strTail];
    [_lbComment setTextColor:ColorGray];
    [_lbComment sizeToFit];
    [_lbComment setNumberOfLines:1];
    [_lbComment sizeToFitByconstrainedSize:CGSizeMake(255, 82)];
    
    [self addSubview:_lbComment];
    RELEASE(_lbComment);

    return fHeight;
}


-(void)tapQuick{
    [_btnQuick sendViewSignal:[DYBCellForDynamic QUICKFUNCTION]];
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

#pragma mark- 接受其他信号

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
float Degrees2Radians(float degrees) { return degrees * M_PI / 180; }

- (void)handleViewSignal_DYBCellForDynamic:(MagicViewSignal *)signal
{
    if ([signal is:[DYBCellForDynamic QUICKFUNCTION]]){
        MagicUIButton *btn = (MagicUIButton *)signal.source;
 
        UIImage *img = [UIImage imageNamed:@"bg_quickblock.png"];
  
        _viewQuick = [[MagicUIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)-img.size.width/2+22, CGRectGetMinY(btn.frame)-61, img.size.width/2, img.size.height/2)];
        [_viewQuick setBackgroundColor:[UIColor clearColor]];
        [_viewQuick setImage:img];
        [_viewQuick setTag:924];
        [_viewQuick setHidden:YES];
        [_viewQuick setUserInteractionEnabled:YES];
        [self addSubview:_viewQuick];
//        RELEASE(_viewQuick);
        
        
        [self removeQuickView:btn quickview:_viewQuick];
        
//        if (_btnQuickLike) {
//            REMOVEFROMSUPERVIEW(_btnQuickLike);
//        }
//        
//        if (_btnQuickCommment) {
//            REMOVEFROMSUPERVIEW(_btnQuickCommment);
//        }
        
        UIImage *imgLike = [UIImage imageNamed:@"quick_like_def.png"];
        _btnQuickLike = [[MagicUIButton alloc] initWithFrame:CGRectMake(2, 8, 54, 50)];
        [_btnQuickLike setBackgroundColor:[UIColor clearColor]];
        [_btnQuickLike setImage:imgLike forState:UIControlStateNormal];
        [_btnQuickLike addSignal:[DYBCellForDynamic QUICKLIKE] forControlEvents:UIControlEventTouchUpInside];
        [_viewQuick addSubview:_btnQuickLike];
        RELEASE(_btnQuickLike);
        
        UIImage *imgComment = [UIImage imageNamed:@"quick_comment_def.png"];
        _btnQuickCommment = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnQuickLike.frame)+6, 8, 44, 50)];
        [_btnQuickCommment setBackgroundColor:[UIColor clearColor]];
        [_btnQuickCommment setImage:imgComment forState:UIControlStateNormal];
        [_btnQuickCommment addSignal:[DYBCellForDynamic QUICKCOMMENT] forControlEvents:UIControlEventTouchUpInside];
        [_viewQuick addSubview:_btnQuickCommment];
        [_btnQuickCommment setSelected:NO];
        RELEASE(_btnQuickCommment);
        
        
        if (_dynamicStatus.type == 15) {
            [_btnQuickCommment setFrame:CGRectMake(38, 8, 44, 50)];
            [_btnQuickLike setHidden:YES];
        }
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.0) {
            UITapGestureRecognizer *tapGestureRecognizerLike = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQuickLike)];
            [_btnQuickLike addGestureRecognizer:tapGestureRecognizerLike];
            RELEASE(tapGestureRecognizerLike);
            
            UITapGestureRecognizer *tapGestureRecognizerComment = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQuickComment)];
            [_btnQuickCommment addGestureRecognizer:tapGestureRecognizerComment];
            RELEASE(tapGestureRecognizerComment);
        }
        
        CGAffineTransform rotate3 = CGAffineTransformMakeRotation( M_PI*0.5 );
        [_viewQuick setTransform:rotate3];
        
        CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI*2);
        CGAffineTransform rotate2 = CGAffineTransformMakeRotation( M_PI*1);

        if (btn.selected == NO) {
            [_viewQuick setHidden:NO];
            [_viewQuick setAlpha:0];
            
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.3f];
            
            [_viewQuick setFrame:CGRectMake(CGRectGetMaxX(btn.frame)-CGRectGetWidth(_viewQuick.frame)-44.5, CGRectGetMinY(btn.frame)-19, CGRectGetWidth(_viewQuick.frame), CGRectGetHeight(_viewQuick.frame))];
            [_viewQuick setTransform:rotate];
            [_viewQuick setAlpha:1];
            [btn setTransform:rotate2];

            [UIView commitAnimations];

        }else{
            [_viewQuick setHidden:YES];
            
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.3f];
            
            [btn setTransform:rotate];
            
            [UIView commitAnimations];
        } 

/*
        UIImage *img = [UIImage imageNamed:@"bg_quickblock.png"];
        CALayer *viewLay = [CALayer layer];
        viewLay.backgroundColor = [UIColor clearColor].CGColor;
        viewLay.contents = (id)img.CGImage;
        viewLay.position = CGPointMake(CGRectGetMaxX(btn.frame)-img.size.width/2-9, CGRectGetMinY(btn.frame)+9);
        viewLay.anchorPoint = CGPointMake(0.5, 0.5);
        
        [self.layer addSublayer:viewLay];
        
        CGFloat secAngle = Degrees2Radians(90);
        viewLay.transform = CATransform3DMakeRotation (secAngle+M_PI, 0, 0, 1);
 */
        [self bringSubviewToFront:btn];
        [self.superview bringSubviewToFront:self];
        
        btn.selected = !btn.selected;
    }else if ([signal is:[DYBCellForDynamic QUICKLIKE]]){
        [_btnQuick sendViewSignal:[DYBCellForDynamic QUICKFUNCTION]];
        
        MagicUIButton *btn = (MagicUIButton *)signal.source;
        
        if ([_dynamicStatus.isrec isEqualToString:@"1"]) {
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"您已赞过了。" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",2]];
            return;
        }
        
        [btn setUserInteractionEnabled:NO];
        
        MagicRequest *request = [DYBHttpMethod status_feedaction_id:[NSString stringWithFormat:@"%d", _dynamicStatus.id] action:@"1" type:@"1" isAlert:YES receive:self];
        request.tag = -1;
        
    }else if ([signal is:[DYBCellForDynamic QUICKCOMMENT]]){
        [_btnQuick sendViewSignal:[DYBCellForDynamic QUICKFUNCTION]];
        
        [_btnQuickCommment sendViewSignal:[DYBDynamicViewController DYNAMICCOMMENT] withObject:(id)_nRow];
        [_btnQuickCommment sendViewSignal:[DYBActivityViewController DYNAMICCOMMENT] withObject:(id)_nRow];
    }
}

-(void)tapQuickLike{
    [_btnQuickLike sendViewSignal:[DYBCellForDynamic QUICKLIKE]];
}

-(void)tapQuickComment{
    [_btnQuickCommment sendViewSignal:[DYBCellForDynamic QUICKCOMMENT]];
}


- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj{
    if ([request succeed]){
        if (request.tag == -1){/*初始化*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode)
            {
//                [_lbLikeCount setText:[NSString stringWithFormat:@"%d", [_lbLikeCount.text intValue]+1]];
//                [_lbLiker setText:[NSString stringWithFormat:@"%@ %@", SHARED.curUser.name, _lbLiker.text]];     
                 [self sendViewSignal:[DYBDynamicViewController DYNAMICREFRESH] withObject:(id)_nRow];
                _dynamicStatus.isrec = @"1";
            }
        }
    }else if ([request failed]){
        [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"没赞成功，请稍后再试！" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",1]];
    }
}

#pragma mark- 点击跳转
- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
        DLogInfo(@"%d", tappedView.tag);
        
        [self removeQuickViewWithoutFunction];
        
        [self sendViewSignal:[DYBDynamicViewController DYNAMICDETAIL] withObject:[_dynamicStatus retain]];
        [self sendViewSignal:[DYBActivityViewController DYNAMICDETAIL] withObject:[_dynamicStatus retain]];
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

- (void)didTapImageWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
        DLogInfo(@"%d", tappedView.tag);
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", tappedView.tag], @"tag", _dynamicStatus, @"status", nil];  
        [self sendViewSignal:[DYBDynamicViewController DYNAMICDIMAGEETAIL] withObject:dic];
        [self sendViewSignal:[DYBActivityViewController DYNAMICDIMAGEETAIL] withObject:dic];
        RELEASE(dic);
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

- (void)didTapCommentWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
        DLogInfo(@"%d", tappedView.tag);
        
        [self sendViewSignal:[DYBDynamicViewController DYNAMICDETAILCOMMENT] withObject:[_dynamicStatus retain]];
        [self sendViewSignal:[DYBActivityViewController DYNAMICDETAILCOMMENT] withObject:[_dynamicStatus retain]];
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

- (void)didTapLikeWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
        DLogInfo(@"%d", tappedView.tag);
        
        [self sendViewSignal:[DYBDynamicViewController DYNAMICDETAILLIKE] withObject:[_dynamicStatus retain]];
        [self sendViewSignal:[DYBActivityViewController DYNAMICDETAILLIKE] withObject:[_dynamicStatus retain]];
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
        [self sendViewSignal:[DYBDynamicViewController PERSONALPAGE] withObject:[dicUser retain]];
        [self sendViewSignal:[DYBActivityViewController PERSONALPAGE] withObject:[dicUser retain]];
        RELEASE(dicUser);
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

-(void)removeQuickView:(UIButton *)btn quickview:(MagicUIImageView *)quickview{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:btn, @"button", quickview, @"quick", nil];
    [self sendViewSignal:[DYBDynamicViewController REMOVEQUICK] withObject:dict];
    [self sendViewSignal:[DYBActivityViewController REMOVEQUICK] withObject:dict];
    RELEASE(dict);
}

-(void)removeQuickViewWithoutFunction{
    [self sendViewSignal:[DYBDynamicViewController REMOVEQUICK]];
    [self sendViewSignal:[DYBActivityViewController REMOVEQUICK]];
}

@end
