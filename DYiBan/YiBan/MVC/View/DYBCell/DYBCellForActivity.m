//
//  DYBCellForActivity.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForActivity.h"
#import "active.h"
#import "NSString+Count.h"
#import "UIImageView+WebCache.h"
#import "NSString+Count.h"
#import "DYBCustomLabel.h"
#import "UILabel+ReSize.h"
#import <QuartzCore/QuartzCore.h>

@implementation DYBCellForActivity

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    if (data){
        float fHeight = 0;
        active *active = data;
        
        fHeight = [self ActivityInfo:active.title begin_time:active.begin_time end_time:active.end_time];
        fHeight = [self ActivityIntroduction:active.introduction target:nil contentIMG:nil StartY:fHeight];
        
        fHeight = fHeight+10;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, fHeight-1, self.frame.size.width, .5f)];
        [lineView setBackgroundColor:ColorDivLine];
        [self addSubview:lineView];
        RELEASE(lineView);
        
        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), fHeight)];
    }
}

#pragma mark- 设置活动标题和时间
-(float)ActivityInfo:(NSString *)title begin_time:(NSString *)begin_time end_time:(NSString *)end_time{
   float fHeight = 50.0f;

    MagicUILabel *_lbTitle = [[MagicUILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 20)];
    [_lbTitle setBackgroundColor:[UIColor clearColor]];
    [_lbTitle setTextAlignment:NSTextAlignmentLeft];
    [_lbTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [_lbTitle setText:title];
    [_lbTitle setTextColor:ColorBlack];
    [_lbTitle setNumberOfLines:1];
    [_lbTitle setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self addSubview:_lbTitle];
    RELEASE(_lbTitle);
    
    if ([begin_time length] > 0) {
        begin_time = [self convertTime:begin_time];
    }
    
    if ([end_time length] > 0) {
        end_time = [self convertTime:end_time];
    }
    
    NSString *strTime = nil;
    
    if ([begin_time length] > 0 && [end_time length] > 0) {
        strTime = [NSString stringWithFormat:@"%@ 至 %@", begin_time, end_time];
    }else if ([begin_time length] > 0){
        strTime = [NSString stringWithFormat:@"%@ 开始", begin_time];
    }else if ([end_time length] > 0){
        strTime = [NSString stringWithFormat:@"%@ 结束", end_time];
    }
    
    
    MagicUILabel *_lbTime = [[MagicUILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_lbTitle.frame)-5, 200, 30)];
    [_lbTime setBackgroundColor:[UIColor clearColor]];
    [_lbTime setTextAlignment:NSTextAlignmentLeft];
    [_lbTime setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [_lbTime setText:strTime];
    [_lbTime setTextColor:ColorGray];
    [_lbTime setNumberOfLines:1];
    [_lbTime setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self addSubview:_lbTime];
    RELEASE(_lbTime);
    
   return fHeight;
}

#pragma mark- 设置活动内容介绍
-(float)ActivityIntroduction:(NSString *)ActivityContent target:(NSArray *)target contentIMG:(NSArray *)arrIMG StartY:(float)fStartY{
    float fHeight = 0.0f;
    
    DYBCustomLabel *_lbSelfContent = [[DYBCustomLabel alloc] initWithFrame:CGRectMake(15, 70, 290, 60) target:target];
    [_lbSelfContent setBackgroundColor:[UIColor clearColor]];
    [_lbSelfContent setTextAlignment:NSTextAlignmentLeft];
    [_lbSelfContent setFont:[DYBShareinstaceDelegate DYBFoutStyle:17]];
    [_lbSelfContent setText:ActivityContent];
    [_lbSelfContent setLineBreakMode:NSLineBreakByTruncatingTail];
//    [_lbSelfContent sizeToFitByconstrainedSize:CGSizeMake(290, 90)];
    [_lbSelfContent setFontFitToSize:CGSizeMake(290, 90)];
    if ([target count] > 0) {
        [_lbSelfContent replaceEmojiandTarget:YES];
    }else{
        [_lbSelfContent replaceEmojiandTarget:NO];
    }
    

    
    fHeight = CGRectGetMaxY(_lbSelfContent.frame);
    
    if ([ActivityContent length] == 0) {
        [_lbSelfContent setFrame:CGRectMake(55, 40, 0, 0)];
        fHeight = 50;
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
            
            RELEASE(_imgDynamicIMAGE);
            
            fHeight = CGRectGetMaxY(_imgDynamicIMAGE.frame);
        }
    }
    
    fHeight = CGRectGetMaxY(_lbSelfContent.frame)+10;
    
    [self addSubview:_lbSelfContent];
    RELEASE(_lbSelfContent);
    
    return fHeight;
}

- (NSString *)convertTime:(NSString *)strTime{
    NSString *strDate = nil;
    
    NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
    [df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    [df setDateFormat:@"yyyy-MM-dd"];//[inputFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];2010-08-03 22:46:01
    strDate = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:[strTime intValue]]];
    
    return strDate;
}


@end
