//
//  Magic_UIKeyboard.m
//  MagicFramework
//
//  Created by NewM on 13-5-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_UIKeyboard.h"

@interface MagicUIKeyboard ()
{
    UIColor *_accessorBackcolor;//自定义view的背景颜色
}

@end

@implementation MagicUIKeyboard
DEF_NOTIFICATION(SHOWN)//keyboard出现
DEF_NOTIFICATION(HIDDEN)//键盘收起
DEF_NOTIFICATION(HEIGHT_CHANGED)//输入法切换（高度改变）

@synthesize shown = _shown;
@synthesize height = _height;

@synthesize animationCurve = _animationCurve;
@synthesize animationDuration = _animationDuration;

@synthesize accessorHidden = _accessorHidden;

static MagicUIKeyboard *sharedInstace = nil;
+ (MagicUIKeyboard *)sharedInstace
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[MagicUIKeyboard alloc] init];
    });
    return sharedInstace;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _shown = NO;
        _height = DEFAULT_KEYBOARD_HEIGHT;
        
        _accessorFrame = CGRectZero;
        _accessor = nil;
        
        _accessorHidden = NO;
        
        [self observeNotification:UIKeyboardDidShowNotification];
        [self observeNotification:UIKeyboardDidHideNotification];
        [self observeNotification:UIKeyboardWillChangeFrameNotification];
    }
    return self;
}

- (void)handleNotification:(NSNotification *)notification
{
    BOOL animted = YES;
    
    NSDictionary *userInfo = (NSDictionary *)[notification userInfo];
    if (userInfo)
    {
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&_animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&_animationDuration];
    }
    
    if ([notification is:UIKeyboardDidShowNotification])
    {
        if (!_shown)
        {
            _shown = YES;
            [self postNotification:[MagicUIKeyboard SHOWN]];
        }
        
        NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        if (value)
        {
            CGRect keyboardEndFrame = [value CGRectValue];
            CGFloat keyboardHeight = keyboardEndFrame.size.height;
            
            if (keyboardHeight != _height)
            {
                _height = keyboardHeight;
                
                [self postNotification:[MagicUIKeyboard HEIGHT_CHANGED]];
                animted = NO;
            }
            
        }
    }else if ([notification is:UIKeyboardWillChangeFrameNotification])
    {
        NSValue *value1 = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
        NSValue *value2 = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        if (value1 && value2)
        {
            CGRect rect1 = [value1 CGRectValue];
            CGRect rect2 = [value2 CGRectValue];
            
            if (rect1.origin.y >= [UIScreen mainScreen].bounds.size.height)
            {
                if (!_shown)
                {
                    _shown = YES;
                    [self postNotification:[MagicUIKeyboard SHOWN]];
                }
                
                if (rect2.size.height != _height)
                {
                    _height = rect2.size.height;
                    [self postNotification:[MagicUIKeyboard HEIGHT_CHANGED]];
                }
            }else if (rect2.origin.y >= [UIScreen mainScreen].bounds.size.height)
            {
                if (rect2.size.height != _height)
                {
                    _height = rect2.size.height;
                    [self postNotification:[MagicUIKeyboard HEIGHT_CHANGED]];
                }
                
                if (_shown)
                {
                    _shown = NO;
                    [self postNotification:[MagicUIKeyboard HIDDEN]];
                }
            }
        }
    }else if ([notification is:UIKeyboardDidHideNotification])
    {
        if (_shown)
        {
            _shown = NO;
        }
        
        NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        if (value)
        {
            CGRect keyboardEndFrame = [value CGRectValue];
            
            CGFloat keyboardHeight = keyboardEndFrame.size.height;
            
            if (keyboardHeight != _height)
            {
                _height = keyboardHeight;
                
                animted = NO;
            }
        }
        
        [self postNotification:[MagicUIKeyboard HIDDEN]];
    }
    [self updateAccessorAnimated:animted animations:nil];
    
}

- (void)dealloc
{
    [self unobserveAllNotification];
    RELEASEOBJ(_accessor)
    [super dealloc];
}

- (void)showAccessor:(UIView *)view animated:(BOOL)animated
{
    if (_accessor)
    {
        _accessor = nil;
    }
    _accessor = [view retain];
    _accessorFrame = view.frame;
    _accessorBackcolor = view.backgroundColor;
    
    [self updateAccessorAnimated:animated animations:@"show"];
}

- (void)hideAccessor:(UIView *)view animated:(BOOL)animated
{
    if (_accessor == view)
    {
        [self updateAccessorAnimated:animated animations:@"hidden"];
    }
}

- (void)updateAccessorAnimated:(BOOL)animated animations:(NSString *)animationID
{

    if (!_accessor || !animationID)
    {
        return;
    }
    
    if (animated)
    {
        [UIView beginAnimations:animationID context:nil];
        [UIView setAnimationDuration:.25f];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDelegate:self];
    }
    
    if (_shown)
    {
        CGFloat containerHeight = _accessor.superview.bounds.size.height;
        CGRect newFrame = _accessorFrame;
        newFrame.origin.y = containerHeight - (_accessorFrame.size.height + _height);
        _accessor.frame = newFrame;
    }else
    {
        _accessor.frame = _accessorFrame;
        if (_accessorHidden)
        {
            [_accessor setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    if (animated)
    {
        [UIView commitAnimations];
    }
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim isEqual:@"hidden"] && flag)
    {
        if (_accessor && _accessor.layer)
        {
            [_accessor setHidden:_accessorHidden];
            [_accessor setBackgroundColor:_accessorBackcolor];
        }
        

    }
}



@end
