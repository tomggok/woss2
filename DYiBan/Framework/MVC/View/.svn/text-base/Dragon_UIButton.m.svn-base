//
//  Dragon_UIButton.m
//  DragonFramework
//
//  Created by NewM on 13-3-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UIButton.h"
#import "NSObject+KVO.h"
#import "UIView+DragonViewSignal.h"

@implementation DragonUIButtonState

@synthesize button = _button;
@synthesize state = _state;
@synthesize title,titleColor,titleShadowColor,image,backgroundImage;

- (void)setTitle:(NSString *)text
{
    [_button setTitle:text forState:_state];
    [_button setNeedsDisplay];
}

- (void)setTitleColor:(UIColor *)color
{
    [_button setTitleColor:color forState:_state];
    [_button setNeedsDisplay];
}

- (void)setTitleShadowColor:(UIColor *)color
{
    [_button setTitleColor:color forState:_state];
    [_button setNeedsDisplay];
}

- (void)setImage:(UIImage *)img
{
    [_button setImage:img forState:_state];
    [_button setNeedsDisplay];
}

- (void)setBackgroundImage:(UIImage *)img
{
    [_button setBackgroundImage:img forState:_state];
    [_button setNeedsDisplay];
}


@end

@interface DragonUIButton ()

- (void)initSelf;
- (void)initLabel;
- (void)didTouchDown;
- (void)didTouchDownRepeat;
- (void)didTouchUpInside;
- (void)didTouchOutSide;
- (void)didTouchCancel;
- (BOOL)checkEvent:(UIControlEvents)event;
@end

@implementation DragonUIButton
{
    BOOL ifSetNetClick;
}
DEF_SIGNAL(TOUCH_DOWN)       //按下
DEF_SIGNAL(TOUCH_DOWN_REPEAT)//长按
DEF_SIGNAL(TOUCH_UP_INSIDE)  //抬起（击中）
DEF_SIGNAL(TOUCH_UP_OUTSIDE) //抬起（未击中）
DEF_SIGNAL(TOUCH_UP_CANCEL)  //撤销

@synthesize titleColor,title,titleFont,titleInsets, titleShadowColor;
@synthesize stateNormal,stateDisabled,stateHighlighted,stateSelected;

- (id)init
{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeCenter;
    self.adjustsImageWhenDisabled = YES;
    self.adjustsImageWhenHighlighted = YES;
    
    if (!_arr_actions) {
        _arr_actions = [[NSMutableArray alloc] init];
    }
    
    [self addTarget:self action:@selector(didTouchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(didTouchDownRepeat) forControlEvents:UIControlEventTouchDownRepeat];
    [self addTarget:self action:@selector(didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(didTouchOutSide) forControlEvents:UIControlEventTouchUpOutside];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000

#undef UITextAlignmentCenter
#define UITextAlignmentCenter NSTextAlignmentCenter

#undef UILineBreakModeHeadTruncation
#define UILineBreakModeHeadTruncation NSLineBreakByTruncatingHead

#else

#undef UITextAlignmentCenter
#define UITextAlignmentCenter UITextAlignmentCenter

#undef UILineBreakModeHeadTruncation
#define UILineBreakModeHeadTruncation UILineBreakModeHeadTruncation


#endif

- (void)initLabel
{
    if (_label) {
        return;
    }
    
    _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont boldSystemFontOfSize:14.f];
    _label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _label.textAlignment = UITextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = [UIColor clearColor];
    _label.lineBreakMode = UILineBreakModeHeadTruncation;
    [self addSubview:_label];
    [_label release];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _label.frame = CGRectMake(.0f, .0f, frame.size.width, frame.size.height);
}
- (void)setTitleInsets:(UIEdgeInsets)insets
{
    _inserts = insets;
    
    CGRect frame = CGRectInset(self.bounds, insets.left, insets.top);
    frame.size.width -= insets.left;
    frame.size.height -= insets.top;
    frame.size.width -= insets.right;
    frame.size.height -= insets.bottom;
    
    _label.frame = frame;

}

- (UIColor *)titleShadowColor
{
    return _label.shadowColor;
}

- (void)setTitleShadowColor:(UIColor *)_titleShadowColor
{
    [self initLabel];
    _label.shadowColor = _titleShadowColor;
}

- (UIFont *)titleFont
{
    return _label.font;
}

- (void)setTitleFont:(UIFont *)_titleFont
{
    [self initLabel];
    _label.font = _titleFont;
}

- (NSString *)title
{
    return _label ? _label.text : @"";
}

- (void)setTitle:(NSString *)titleS
{
    [self initLabel];
    
    _label.text = titleS;
}

- (UIColor *)titleColor
{
    return _label ? _label.textColor : [UIColor clearColor];
}

- (void)setTitleColor:(UIColor *)titleColorC
{
    [self initLabel];
    
    _label.textColor = titleColorC;
}

- (DragonUIButtonState *)stateNormal
{
    if (!_stateNormal) {
        _stateNormal = [[DragonUIButtonState alloc] init];
        _stateNormal.button = self;
        _stateNormal.state = UIControlStateNormal;
    }
    return _stateNormal;
}

- (DragonUIButtonState *)stateHighlighted
{
    if (!_stateHighlighted) {
        _stateHighlighted = [[DragonUIButtonState alloc] init];
        _stateHighlighted.button = self;
        _stateHighlighted.state = UIControlStateHighlighted;
    }
    return _stateHighlighted;
}

- (DragonUIButtonState *)stateDisabled
{
    if (!_stateDisabled) {
        _stateDisabled = [[DragonUIButtonState alloc] init];
        _stateDisabled.button = self;
        _stateDisabled.state = UIControlStateDisabled;
    }
    return _stateDisabled;
}

- (DragonUIButtonState *)stateSelected
{
    if (!_stateSelected) {
        _stateSelected = [[DragonUIButtonState alloc] init];
        _stateSelected.button = self;
        _stateSelected.state = UIControlStateSelected;
    }
    return _stateSelected;
}

- (void)addSignal:(NSString *)signal forControlEvents:(UIControlEvents)controlEvents
{
    [self addSignal:signal forControlEvents:controlEvents object:nil];
}

- (void)addSignal:(NSString *)signal forControlEvents:(UIControlEvents)controlEvents object:(NSObject *)object
{
    if (!signal) {
        signal = @"";
    }
    
    NSNumber *event = [NSNumber numberWithInt:controlEvents];
    for (int i = 0; i < [_arr_actions count]; i++)
    {
        NSNumber *eventArr = [[_arr_actions objectAtIndex:i] objectAtIndex:0];
        if ([event isEqualToNumber:eventArr])
        {
            [_arr_actions removeObjectAtIndex:i];
        }
    }

    [_arr_actions addObject:[NSArray arrayWithObjects:event, signal, object, nil]];
}

- (void)didTouchDown
{
    if (![self checkEvent:UIControlEventTouchDown]) {
        [self sendViewSignal:[DragonUIButton TOUCH_DOWN]];
    }
}

- (void)didTouchDownRepeat
{
    if (![self checkEvent:UIControlEventTouchDownRepeat]) {
        [self sendViewSignal:[DragonUIButton TOUCH_DOWN_REPEAT]];
    }
}

- (void)didTouchUpInside
{
    if (![self checkEvent:UIControlEventTouchUpInside]) {
        [self sendViewSignal:[DragonUIButton TOUCH_UP_INSIDE]];
    }
}

- (void)didTouchOutSide
{
    if (![self checkEvent:UIControlEventTouchUpOutside]) {
        [self sendViewSignal:[DragonUIButton TOUCH_UP_OUTSIDE]];
    }
}

- (void)didTouchCancel
{
    if (![self checkEvent:UIControlEventTouchCancel]) {
        [self sendViewSignal:[DragonUIButton TOUCH_UP_CANCEL]];
    }
}

- (BOOL)checkEvent:(UIControlEvents)event
{
    for (NSArray *action in _arr_actions) {
        NSNumber *actionEvent = [action objectAtIndex:0];
        DLogInfo(@"[actionEvent intValue] & event === %d",[actionEvent intValue] & event);
        DLogInfo(@"event === %d", event);
        if ([actionEvent intValue] & event) {
            NSString *signal = [action objectAtIndex:1];
            NSObject *object = ([action count] >= 3) ? [action objectAtIndex:2] : nil;

            [self sendViewSignal:signal withObject:object from:self];
            return YES;
        }
    }
    return NO;
}

//设置bt只点击一次
- (void)setNetClickOne
{
    [self setTag:BTVIEWCLICKONETAG];
    ifSetNetClick = YES;
    [self setUserInteractionEnabled:NO];
}

- (void)dealloc
{
//    [self dealloc_observer];

    [_arr_actions removeAllObjects];
    [_arr_actions release];
    
    [_stateNormal release];
    [_stateHighlighted release];
    [_stateSelected release];
    [_stateDisabled release];
    
//    [self.titleLabel release];

    [super dealloc];
}


@end
