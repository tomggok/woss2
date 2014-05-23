//
//  DYBCellForDynamicStatus.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-27.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForDynamicStatus.h"
#import "UIImageView+WebCache.h"
#import "NSString+Count.h"
#import "DYBCustomLabel.h"
#import "UILabel+ReSize.h"
#import "comment.h"
#import "follow_list.h"
#import "action_list.h"
#import "DYBCustomLabel.h"
#import "DYBDynamicDetailViewController.h"

@implementation DYBCellForDynamicStatus

-(void)setContent:(id)data type:(int)type indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    if (data){
        float fHeight = 0;
        fadd = 0;
        
        if (indexPath.row != 0) {
            MagicUIImageView *imgSpLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(27, 0, 266, 1) backgroundColor:[UIColor clearColor] image:[UIImage imageNamed:@"sepline2.png"] isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            
            RELEASE(imgSpLine);
        }else{
            fadd = 8;
        }

        
        if (type == 2) {
            action_list *aclist = data;
            fHeight = [self DynamicLike:aclist.name time:aclist.time commenterPortraitURL:aclist.pic];
            _strUserName = aclist.name;
            _strUserID = aclist.userid;
        }else if(type == 1){
            comment *cmt = data;
            fHeight = [self DynamicCommetContent:cmt.user.name commenterPortraitURL:cmt.user.pic commentContent:cmt.content time:cmt.time targrt:nil];
            _strUserName = cmt.user.username;
            _strUserID = cmt.user.id;
        }else if(type == 3){
            follow_list *flw = data;
            fHeight = [self DynamicCommetContent:flw.user.name commenterPortraitURL:flw.user.pic commentContent:flw.content time:flw.time targrt:flw.target];
            _strUserName = flw.user.name;
            _strUserID = flw.user.id;
        }else{/*没有数据*/
            type = type -3;
            fHeight = [self DynamicNoData:type];
        }
        
        UIView *viewBKG = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 290, fHeight)];
        [viewBKG setBackgroundColor:BKGGray];
        [self addSubview:viewBKG];
        [self sendSubviewToBack:viewBKG];
        RELEASE(viewBKG);
        
        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), fHeight)];
    }
}

#pragma mark- 评论内容
-(float)DynamicCommetContent:(NSString *)commenterName commenterPortraitURL:(NSString *)portraitURL commentContent:(NSString *)content time:(NSString *)time targrt:(NSArray *)target{
    float fHeight = 0;
    
    MagicUIImageView *_imgUserPortrait = [[MagicUIImageView alloc] initWithFrame:CGRectMake(27, 8+fadd, 30, 30) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    [_imgUserPortrait setNeedRadius:YES];
    [_imgUserPortrait setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserWithGesture:)];
    [_imgUserPortrait addGestureRecognizer:tapGestureRecognizer];
    RELEASE(tapGestureRecognizer);
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
    
    time = [NSString transFormTimeStamp:[time intValue]];

    MagicUILabel *_lbTime = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-105, CGRectGetMinY(_lbUserName.frame), 80, 30)];
    [_lbTime setBackgroundColor:[UIColor clearColor]];
    [_lbTime setTextAlignment:NSTextAlignmentRight];
    [_lbTime setFont:[DYBShareinstaceDelegate DYBFoutStyle:12]];
    [_lbTime setText:time];
    [_lbTime setTextColor:ColorGray];
    [_lbTime setNumberOfLines:1];
    [_lbTime setLineBreakMode:NSLineBreakByTruncatingTail];
    
    DYBCustomLabel *_lbComment = [[DYBCustomLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgUserPortrait.frame)+8, CGRectGetMaxY(_lbUserName.frame)-3, 228, 30) target:target];
    [_lbComment setBackgroundColor:[UIColor clearColor]];
    [_lbComment setTextAlignment:NSTextAlignmentLeft];
    [_lbComment setFont:[DYBShareinstaceDelegate DYBFoutStyle:13]];
    [_lbComment setText:content];
    [_lbComment setTextColor:ColorContentGray];
    [_lbComment setNumberOfLines:0];
    [_lbComment sizeToFitByconstrainedSize:CGSizeMake(228, 100)];
    
    if ([target count] > 0) {
        [_lbComment replaceEmojiandTarget:YES];
    }else{
        [_lbComment replaceEmojiandTarget:NO];
    }
    
    
    [self addSubview:_lbUserName];
    [self addSubview:_lbTime];
    [self addSubview:_lbComment];
    
    RELEASE(_imgUserPortrait);
    RELEASE(_lbUserName);
    RELEASE(_lbTime);
    RELEASE(_lbComment);
    
    fHeight = CGRectGetMaxY(_lbComment.frame)+8;
    
    return fHeight;
}

-(float)DynamicLike:(NSString *)commenterName time:(NSString *)time commenterPortraitURL:(NSString *)portraitURL{
    float fHeight = 0;
    
    MagicUIImageView *_imgUserPortrait = [[MagicUIImageView alloc] initWithFrame:CGRectMake(27, 8+fadd, 30, 30) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    [_imgUserPortrait setNeedRadius:YES];
    [_imgUserPortrait setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserWithGesture:)];
    [_imgUserPortrait addGestureRecognizer:tapGestureRecognizer];
    RELEASE(tapGestureRecognizer);
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

    time = [NSString transFormTimeStamp:[time intValue]];
    
    MagicUILabel *_lbTime = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgUserPortrait.frame)+8, CGRectGetMaxY(_lbUserName.frame)-13, 228, 30)];
    [_lbTime setBackgroundColor:[UIColor clearColor]];
    [_lbTime setTextAlignment:NSTextAlignmentLeft];
    [_lbTime setFont:[DYBShareinstaceDelegate DYBFoutStyle:12]];
    [_lbTime setText:time];
    [_lbTime setTextColor:ColorGray];
    [_lbTime setNumberOfLines:1];
    [_lbTime setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self addSubview:_lbUserName];
    [self addSubview:_lbTime];
    
    RELEASE(_lbTime);
    RELEASE(_imgUserPortrait);
    RELEASE(_lbUserName);
    
    fHeight = CGRectGetMaxY(_imgUserPortrait.frame)+8;
    
    return fHeight;
}

- (float)DynamicNoData:(int)type{
    float fHeight = 43;
    
    UIImage *imgBear = [UIImage imageNamed:@"ybx_small.png"];
    MagicUIImageView *viewBear = [[MagicUIImageView alloc] initWithFrame:CGRectMake(105, 10, 25, 22)];
    [viewBear setBackgroundColor:[UIColor clearColor]];
    [viewBear setImage:imgBear];
    [self addSubview:viewBear];
    RELEASE(viewBear);
    
    NSString *str= nil;
    switch (type) {
        case 1:
            str = @"求评论";
            break;
        case 2:
            str = @"求赞";
            break;
        case 3:
            str = @"求转发";
            break;
    }
    
    MagicUILabel *lbWaring = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(viewBear.frame)+5, 10, 60, 22)];
    [lbWaring setTag:199];
    [lbWaring setBackgroundColor:[UIColor clearColor]];
    [lbWaring setFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
    [lbWaring setTextColor:ColorGray];
    [lbWaring setText:str];
    [self addSubview:lbWaring];
    RELEASE(lbWaring);
    
    
    

    return fHeight;
}

- (void)didTapUserWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
        DLogInfo(@"%d", tappedView.tag);
        
        NSDictionary *dicUser = [[NSDictionary alloc] initWithObjectsAndKeys:_strUserID, @"userid", _strUserName, @"username", nil];
        [self sendViewSignal:[DYBDynamicDetailViewController PERSONALPAGE] withObject:[dicUser retain]];
        RELEASE(dicUser);
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

@end
