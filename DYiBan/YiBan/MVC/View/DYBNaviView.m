//
//  DYBNaviView.m
//  DYiBan
//
//  Created by NewM on 13-8-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBNaviView.h"
#import "Magic_Device.h"

@interface DYBNaviView ()
{
    
    MagicUIImageView *_viewArrow;
    MagicUILabel *_label;
}
@property (nonatomic, assign)CGRect titleFrame;

@end
@implementation DYBNaviView
@synthesize titleFrame = _titleFrame,lineView=_lineView;

- (void)dealloc
{
    RELEASEVIEW(_label);
    RELEASEVIEW(_viewArrow);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    float y = 20;
    float height = 64;
    if ([MagicDevice sysVersion] < 7)
    {
        y = 0;
        height = 44;
    }
    frame = CGRectMake(0, 0, 320, height);
    self = [super initWithFrame:frame];
    if (self)
    {
        _label = [[MagicUILabel alloc] initWithFrame:CGRectMake(0, y, 20, 43)];
        [_label setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[MagicCommentMethod color:248 green:248 blue:248 alpha:1.f]];
        [self addSubview:_label];
        
        UIImage *imgArrow = [UIImage imageNamed:@"title_arrow.png"];
        _viewArrow = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, y, imgArrow.size.width/2, imgArrow.size.height/2)];
        [_viewArrow setImage:imgArrow];
        [_viewArrow setHidden:YES];
        [self addSubview:_viewArrow];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y + 44, 320, .5f)];
        [_lineView setBackgroundColor:[MagicCommentMethod color:204 green:204 blue:204 alpha:1.f]];
        [self addSubview:_lineView];
        RELEASE(_lineView);
        
        [self setBackgroundColor:[UIColor colorWithRed:96/255.0f green:96/255.0f  blue:96/255.0f  alpha:1.0f]];
    }
    return self;
}

- (void)setTitleColor:(UIColor *)color
{
    [_label setTextColor:color];
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title font:[DYBShareinstaceDelegate DYBFoutStyle:20.f]];
}

//文字中间加省略
- (void)setTitlelineBreakMode {
    
    _label.lineBreakMode = UILineBreakModeMiddleTruncation;
}


- (void)setTitle:(NSString *)title font:(UIFont *)font
{
    [_label setText:title];
    [_label setFont:font];
    
    CGSize fontSize = [title sizeWithFont:font];
    float viewWidth = CGRectGetWidth(self.frame);
    
    if (fontSize.width > 180)
    {
        fontSize.width = 180;
    }
    
    CGRect labelFrame = _label.frame;
    labelFrame.origin.x = (viewWidth - fontSize.width) / 2;
    labelFrame.size.width = fontSize.width;
    
    _label.frame = labelFrame;
    self.titleFrame = labelFrame;
}

- (void)setLeftView:(UIView *)leftView
{
    [self addSubview:leftView];
}

- (void)setRightView:(UIView *)rightView
{
    [self addSubview:rightView];
}

- (void)setTitleArrow{
    [_viewArrow setHidden:NO];
    [_viewArrow setFrame:CGRectMake(CGRectGetMaxX(_label.frame)+4, CGRectGetMidY(_label.frame), CGRectGetWidth(_viewArrow.frame), CGRectGetHeight(_viewArrow.frame))];
}

- (void)setTitleArrowStatus:(BOOL)bReversal{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (bReversal) {
        CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI*1 );
        [_viewArrow setTransform:rotate];
    }else{
        CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI*2 );
        [_viewArrow setTransform:rotate];
    }
    
    [UIView commitAnimations];
}

@end
