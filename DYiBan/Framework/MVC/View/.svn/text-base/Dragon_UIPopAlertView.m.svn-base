//
//  Dragon_UIPopView.m
//  DragonFramework
//
//  Created by NewM on 13-5-27.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UIPopAlertView.h"

#undef MAXLAELWIDTH
#define MAXLAELWIDTH (20*10)
#undef MAXLAELHEIGHT
#define MAXLAELHEIGHT (20*5)

#undef HEADY
#define HEADY 10

#undef WITHTWOVIEW
#define WITHTWOVIEW 6

@interface DragonUIPopAlertView ()
{
    //alertMode
    UIView *_alertView;//弹出view
    UIView *_childAlertView;
    DragonUILabel *_label;//view上的label
    DragonUIImageView *_indicatorImgView;//句话view
    
    
    CGFloat _labelOriginX;
    CGFloat _labelOriginY;
}
@property (nonatomic, assign)CGFloat alertViewHeight;
@property (nonatomic, assign)CGFloat alertViewWidth;
@end
@implementation DragonUIPopAlertView
@synthesize alertViewHeight = _alertViewHeight,
            alertViewWidth = _alertViewWidth;
@synthesize mode = _mode,
            indicatorMode = _indicatorMode;

@synthesize delegate = _delegate;
@synthesize imgArray = _imgArray;

@synthesize needSelfY = _needSelfY, alertViewY = _alertViewY;

DEF_SIGNAL(POPALERTHIDDEN)

- (id)init
{
    CGRect mainFrame = MAINFRAME;
    return [self initWithFrame:mainFrame];
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect mainFrame = MAINFRAME;
    self = [super initWithFrame:mainFrame];
    if (self)
    {
        
        [self initSelf];
        
    }
    return self;
}

- (void)initSelf
{
    CGRect mainFrame = MAINFRAME;
    [self setFrame:mainFrame];
    
//    [self setUserInteractionEnabled:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    
    _indicatorMode = -1;
}

- (void)initAlertView
{
    if (!_alertView)
    {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self addSubview:_alertView];
        RELEASE(_alertView);
    }
    [_alertView setBackgroundColor:[UIColor clearColor]];
    [_alertView setHidden:YES];
    
    
    if (!_childAlertView)
    {
        _childAlertView = [[UIView alloc] initWithFrame:_alertView.frame];
        [_alertView addSubview:_childAlertView];
        RELEASE(_childAlertView);
    }
    [_childAlertView setTag:2];
    [_childAlertView setBackgroundColor:[UIColor blackColor]];
    [_childAlertView layer].cornerRadius = 5.f;
    [_childAlertView setAlpha:.9f];
    
    
    if (!_label)
    {
        _label = [[DragonUILabel alloc] initWithFrame:CGRectMake(10, 10, 20*10, 20*2)];
        _labelOriginX = _label.frame.origin.x;
        _labelOriginY = _label.frame.origin.y;
        [_alertView addSubview:_label];
        RELEASE(_label);
    }
    
    [_label setFont:[UIFont systemFontOfSize:16.f]];
    [_label setTextColor:[UIColor whiteColor]];
    [_label setBackgroundColor:[UIColor clearColor]];
    

}

- (void)initViewFrame
{
    [_label setFrame:CGRectMake(10, HEADY, 20*10, 20*2)];
    [_indicatorImgView setFrame:CGRectMake(8, 0, 16, 16)];
    
}

- (void)clearnSelf
{
    _alertView = nil;//弹出view
    _childAlertView = nil;
    _label = nil;//view上的label
    _indicatorImgView = nil;//句话view
    
}

#pragma mark - method
//设置popview的类型
- (void)setMode:(DragonpopViewType)mode
{

    _mode = mode;
    
    if (_mode == DRAGONPOPALERTVIEWNOINDICATOR || _mode == DRAGONPOPALERTVIEWINDICATOR)
    {
        [self initAlertView];
        if (_mode == DRAGONPOPALERTVIEWINDICATOR)
        {
            if (_indicatorMode == -1)
            {
                _indicatorMode = INDICATORHEADTYPE;
            }
            
            [self gifAnimation];
        }
        if (_label.text && _label.text.length > 0)
        {
            [self setText:_label.text];
        }else if(_label)
        {
            [self setText:@"正在加载..."];
        }
        
    }
    
}
//设置菊花位置
- (void)setIndicatorMode:(DragonpopAlertIndicatorType)indicatorMode
{
    [self initViewFrame];
    _indicatorMode = indicatorMode;
    if (_label.text && _label.text.length > 0)
    {
        [self setText:_label.text];
    }else if (_label)
    {
        [self setText:@"正在加载..."];
    }
    self.mode = DRAGONPOPALERTVIEWINDICATOR;
    
}

//设置文字
- (void)setText:(NSString *)text
{
    if (!_label)
    {
        [self setMode:DRAGONPOPALERTVIEWNOINDICATOR];
    }
    [_label setText:text];
    
    CGSize labelSize = [_label.text sizeWithFont:_label.font ];
    
    NSInteger number = 0;
    NSInteger width = labelSize.width;
    if (width % MAXLAELWIDTH == 0)
    {
        number = width/MAXLAELWIDTH;
    }else
    {
        number = width/MAXLAELWIDTH + 1;
    }
    
    if (number != 1)
    {
        labelSize.width = MAXLAELWIDTH;
        labelSize.height *= number;
        if (labelSize.height >= MAXLAELHEIGHT)
        {
            labelSize.height = MAXLAELHEIGHT;
        }
    
    }
    CHANGEFRAMESIZE(_label.frame, labelSize.width, labelSize.height)
    CHANGEFRAMEORIGIN(_label.frame, _labelOriginX, _labelOriginY)
    CGRect labelFrame = _label.frame;
    if (_mode == DRAGONPOPALERTVIEWINDICATOR)
    {
        if (_indicatorMode == INDICATORLEFTTYPE)
        {
            labelFrame = CGRectMake(labelFrame.origin.x + CGRectGetWidth(_indicatorImgView.frame)+_indicatorImgView.frame.origin.x,
                                    labelFrame.origin.y,
                                    labelSize.width,
                                    labelSize.height);
        }else if (_indicatorMode == INDICATORRIGHTTYPE || _indicatorMode == INDICATORFOOTTYPE)
        {
            labelFrame = CGRectMake(labelFrame.origin.x,
                                    labelFrame.origin.y,
                                    labelSize.width,
                                    labelSize.height);

        }else if (_indicatorMode == INDICATORHEADTYPE)
        {
            labelFrame = CGRectMake(labelFrame.origin.x,
                                    labelFrame.origin.y + CGRectGetHeight(_indicatorImgView.frame)+_indicatorImgView.frame.origin.y + WITHTWOVIEW,
                                    labelSize.width,
                                    labelSize.height);
        }
        
    }

    [_label setFrame:labelFrame];
    [_label setNumberOfLines:number];
    [_label setLineBreakMode:NSLineBreakByCharWrapping];
    
}

//alertviewheihtset方法
- (void)setAlertViewHeight:(CGFloat)alertViewHeight
{
    _alertViewHeight = alertViewHeight;
    
    [self setAlertCenter];
}

//alertviewwidthset方法
- (void)setAlertViewWidth:(CGFloat)alertViewWidth
{
    _alertViewWidth = alertViewWidth;
    
    if (_alertViewWidth > MAXLAELWIDTH) {
        _alertViewWidth = MAXLAELWIDTH + 20;
    }
    
    [self setAlertCenter];
}


//设置alertview一直在中间
- (void)setAlertCenter
{
    CGRect mainFrame = MAINFRAME;
    CGRect centerFrame = CGRectMake((CGRectGetWidth(mainFrame) - _alertViewWidth)/2,
                                    (CGRectGetHeight(mainFrame) - _alertViewHeight)/2,
                                    _alertViewWidth, _alertViewHeight);
    [_alertView setFrame:centerFrame];
    
    if (_needSelfY)
    {
        CGRect frame = _alertView.frame;
        frame.origin.y = _alertViewY;
        
        _alertView.frame = frame;
    }
    
    for (UIView *chView in _alertView.subviews)
    {
        if (chView.tag == 2)
        {
            chView.frame = CHANGEFRAMESIZE(chView.frame, _alertViewWidth, _alertViewHeight);
        }
    }
    
    if (_mode == DRAGONPOPALERTVIEWINDICATOR)
    {
        CGFloat indicatorX = _indicatorImgView.frame.origin.x;
        CGFloat indicatorY = (_alertView.frame.size.height - 16)/2;
        if (_indicatorMode == INDICATORRIGHTTYPE)
        {
            indicatorX = _label.frame.origin.x + _label.frame.size.width + 8;
        }else if (_indicatorMode == INDICATORHEADTYPE || _indicatorMode == INDICATORFOOTTYPE)
        {
            indicatorX = (CGRectGetWidth(_alertView.frame) - CGRectGetWidth(_indicatorImgView.frame)) / 2;
            if (_indicatorMode == INDICATORHEADTYPE)
            {
                indicatorY = HEADY;
            }else
            {
                indicatorY = CGRectGetHeight(_label.frame) + _label.frame.origin.y + WITHTWOVIEW;
            }
            
        }
        
        CHANGEFRAMEORIGIN(_indicatorImgView.frame,
                          indicatorX,
                          indicatorY);


    }
}

- (void)gifAnimation
{
    if (!_indicatorImgView)
    {
//        NSArray *imgArray = [NSArray arrayWithObjects:
//                             [UIImage imageNamed:@"gif1.png"],
//                             [UIImage imageNamed:@"gif2.png"],
//                             [UIImage imageNamed:@"gif3.png"],
//                             [UIImage imageNamed:@"gif4.png"],
//                             [UIImage imageNamed:@"gif5.png"],
//                             [UIImage imageNamed:@"gif6.png"],
//                             [UIImage imageNamed:@"gif7.png"],
//                             [UIImage imageNamed:@"gif8.png"],
//                             [UIImage imageNamed:@"gif9.png"],
//                             [UIImage imageNamed:@"gif10.png"],
//                             [UIImage imageNamed:@"gif11.png"],
//                             [UIImage imageNamed:@"gif12.png"],nil];
        
        NSArray *imgArray = nil;
        
        if (_imgArray)
        {
            imgArray = _imgArray;
        }else
        {
            imgArray = [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"1001.png"],
                        [UIImage imageNamed:@"1002.png"],
                        [UIImage imageNamed:@"1003.png"],
                        [UIImage imageNamed:@"1004.png"],
                        [UIImage imageNamed:@"1005.png"],
                        [UIImage imageNamed:@"1006.png"],
                        [UIImage imageNamed:@"1007.png"],
                        [UIImage imageNamed:@"1008.png"],
                        [UIImage imageNamed:@"1009.png"],
                        [UIImage imageNamed:@"1010.png"],
                        [UIImage imageNamed:@"1011.png"],
                        [UIImage imageNamed:@"1012.png"],
                        [UIImage imageNamed:@"1013.png"],
                        [UIImage imageNamed:@"1014.png"],
                        [UIImage imageNamed:@"1015.png"],
                        [UIImage imageNamed:@"1016.png"],
                        [UIImage imageNamed:@"1017.png"],
                        [UIImage imageNamed:@"1018.png"],nil];
        }
        
        _indicatorImgView = [[DragonUIImageView alloc] initWithFrame:CGRectMake(8, 0, 16, 16)];
        [_indicatorImgView setAnimationImages:imgArray];
        [_indicatorImgView setAnimationDuration:.5f];
        [_indicatorImgView startAnimating];
        [_alertView addSubview:_indicatorImgView];
//        [_indicatorImgView release];
        RELEASE(_indicatorImgView);
    }
}

#pragma mark - hadleView

- (void)alertViewShown
{
    if (_alertView)
    {
        CGFloat alertHeight = CGRectGetHeight(_label.frame);
        CGFloat alertWidth = CGRectGetWidth(_label.frame);
        if (_mode == DRAGONPOPALERTVIEWINDICATOR)
        {
            alertWidth += 20;
            if (_indicatorMode == INDICATORHEADTYPE || _indicatorMode == INDICATORFOOTTYPE)
            {
                if (_indicatorMode == INDICATORFOOTTYPE)
                {
                    alertHeight += (HEADY + WITHTWOVIEW*2);
                    alertHeight += ((CGRectGetHeight(_indicatorImgView.frame) + _indicatorImgView.frame.origin.y));
                }else
                {
                    alertHeight += HEADY + WITHTWOVIEW;
                    alertHeight += ((CGRectGetHeight(_indicatorImgView.frame) + _indicatorImgView.frame.origin.y));
                }
                
            }else
            {
                alertWidth += 20;
                alertHeight += 20;
            }
            
            
        }else
        {
            alertWidth += 20;
            alertHeight += 20;

            REMOVEFROMSUPERVIEW(_indicatorImgView);
        }
        
        [self setAlertViewHeight:alertHeight];
        [self setAlertViewWidth:alertWidth];
        
        [_alertView setHidden:NO];
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.5;
        
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        [_alertView.layer addAnimation:animation forKey:nil];
        
        UIWindow *win = [[UIApplication sharedApplication].windows lastObject];
        [win addSubview:self];
    }
    
    
}

- (void)alertViewHiddenAndRelease
{
    [self alertViewHidden];
    [self releaseAlertView];
}

- (void)alertViewHidden
{
    [UIView animateWithDuration:1.f animations:^{
        [_childAlertView setAlpha:0.f];
        [_alertView setAlpha:0.f];
    } completion:^(BOOL finished) {
        [_alertView setHidden:YES];
        [self sendViewSignal:[DragonUIPopAlertView POPALERTHIDDEN] withObject:nil from:self target:_delegate];
    }];
}

- (void)alertViewAutoHidden:(NSTimeInterval)duration
{
    [self alertViewAutoHidden:duration isRelease:NO];
}

- (void)alertViewAutoHidden:(NSTimeInterval)duration isRelease:(BOOL)isRelease
{
    [self setUserInteractionEnabled:YES];
    [self alertViewShown];
    [self performSelector:@selector(alertViewHidden)
               withObject:nil
               afterDelay:duration];
    
    if (isRelease)
    {
        [self performSelector:@selector(releaseAlertView)
                   withObject:nil
                   afterDelay:duration+1];

    }
}

- (void)releaseAlertView
{
    @synchronized(self)
    {
        if (_delegate && self)
        {
            RELEASEOBJ(_delegate)
            RELEASEVIEW(self);
        }
    }
}

- (void)dealloc
{
    if (_imgArray)
    {
        RELEASEDICTARRAYOBJ(_imgArray);
    }
    
    [super dealloc];
}
@end