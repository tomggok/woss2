//
//  Dragon_NavigationBar.m
//  ShangJiaoYuXin
//
//  Created by NewM on 13-5-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UINavigationBar.h"


@implementation DragonUINavigationBar
@synthesize navi;
@synthesize backBt = _backBt;
@synthesize isTop = _isTop;

DEF_SIGNAL(BUTTON_BACK)

- (void)dealloc
{
    RELEASEOBJ(_backBt)
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        _backBt = [[DragonUIButton alloc] initWithFrame:CGRectMake(15, 10, 10, 10)];
        [_backBt addSignal:[DragonUINavigationBar BUTTON_BACK] forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBt];

    }
    return self;
}

//设置返回按钮图片
- (void)setLeftBtImg:(UIImage *)img
{
    [_backBt setBackgroundImage:img forState:UIControlStateNormal];
    [_backBt setFrame:CGRectMake(15, (45-(img.size.height/2+3))/2, img.size.width/2+3, img.size.height/2+3)];
}

//设置返回点击之后按钮图片
- (void)setLeftBtImgTouched:(UIImage *)img
{
    [_backBt setBackgroundImage:img forState:UIControlStateHighlighted];

}

//设置右面view
- (void)setRightView:(UIView *)rightView
{
    [self addSubview:rightView];
}

- (void)setIsTop:(BOOL)isTop
{
    _isTop = isTop;
    if (_isTop)
    {
        [_backBt setHidden:YES];
        
    }else
    {
        [_backBt setHidden:NO];
    }
}


- (void)handleViewSignal_DragonUINavigationBar:(DragonViewSignal *)signal
{
    if ([signal is:[DragonUINavigationBar BUTTON_BACK]])
    {
        [navi popVCAnimated:YES];;
    }
}



@end
