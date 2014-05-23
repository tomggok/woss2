//
//  Magic_UIImageView.m
//  ShangJiaoYuXin
//
//  Created by NewM on 13-5-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_UIImageView.h"
#import "UIView+Gesture.h"
#import "NSString+Count.h"
#import "UIView+MagicCategory.h"

@implementation MagicUIImageView

@synthesize needRadius = _needRadius,strTag = _strTag;
//DEF_SIGNAL(TAP)       //单击消息
DEF_SIGNAL(WEBDOWNSUCCESS)//图片下载成功
DEF_SIGNAL(WEBDOWNFAIL)//图片下载失败

#pragma mark-通过url初始化img
-(void)setImgWithUrl:(NSString *)url defaultImg:(NSString *)defaultImg
{
    NSString *encondeUrl= [url stringByAddingPercentEscapesUsingEncoding];
    if ([NSURL URLWithString:encondeUrl] == nil) {
        [self setImage:[UIImage imageNamed:defaultImg]];
    }else
    {
        self._b_isShade=NO;
        [self setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:defaultImg]];
        
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_needRadius)
    {
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        if (width == height)
        {
            CALayer *lay = self.layer;
            [lay setMasksToBounds:YES];
            [lay setCornerRadius:width/2];
        }
    }
}

- (void)setNeedRadius:(BOOL)needRadius
{
    _needRadius = needRadius;
    if (needRadius)
    {
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        
        if (width == height)
        {
            CALayer *lay = self.layer;
            [lay setMasksToBounds:YES];
            [lay setCornerRadius:width/2];
        }
    }
}

NSString *sendType;
- (void)handleViewSignal_UIImageView:(MagicViewSignal *)signal
{
    if ([signal is:[UIImageView SDWEBIMGDOWNSUCCESS]]) {
        sendType = @"success";
        if ([self superview])
        {
            [self sendViewSignal:[MagicUIImageView WEBDOWNSUCCESS] withObject:self.image from:self target:[self superview]];
            sendType = @"";
        }
        
        
    }

}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if ([sendType isEqualToString:@"success"])
    {
        if ([self superview] && self.frame.size.height > 0 && self.frame.size.height > 0)
        {
//            [self sendViewSignal:[MagicUIImageView WEBDOWNSUCCESS] withObject:self.image from:self target:[self superview]];
        }
//
    }
    
    sendType = @"";

    
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
}


- (void)dealloc
{    
//    [_arr_actions removeAllObjects];
//    [_arr_actions release];
    
    [super dealloc];
}
@end
