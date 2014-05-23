//
//  DYBBaseView.m
//  DYiBan
//
//  Created by NewM on 13-8-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"

@interface DYBBaseView ()
{
}
@property (nonatomic, assign)CGFloat blurLevel;

@end

@implementation DYBBaseView
{
//    MagicUIBlurView *blurView;
}

@synthesize blurLevel = _blurLevel;
@synthesize blurSuperView = _blurSuperView;

- (void)dealloc
{
//    RELEASEVIEW(blurView);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
//    if (blurView)
//    {
//        [blurView setFrame:self.frame];
//    }
}

//初始化blurview
- (void)initBlurView
{
//    if (!blurView)
//    {
//        blurView = [[MagicUIBlurView alloc] initWithFrame:self.frame];
//        
//        [self addSubview:blurView];
//        [self sendSubviewToBack:blurView];
//    }
}

- (void)cutBlurImg:(UIView *)superView withRect:(CGRect)frame
{
    [self initBlurView];
//    [blurView cutBlurImg:superView withRect:frame];
}

- (void)cutBlurImg:(CGRect)frame
{
//    [blurView cutBlurImg:frame];
}

- (void)setBlurSuperView:(UIView *)blurSuperView
{
    if (_blurSuperView == blurSuperView)
    {
        return;
    }
    
    [_blurSuperView release];
    _blurSuperView = [blurSuperView retain];
    
    [self initBlurView];
//    [blurView setBlurView:_blurSuperView];
    
}

- (void)setBlurLevel:(CGFloat)blurLevel
{
    _blurLevel = blurLevel;
    
    [self initBlurView];
//    [blurView setBlurLevel:_blurLevel];
}


@end
