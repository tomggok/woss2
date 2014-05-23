//
//  Dragon_UIKeyboard.h
//  DragonFramework
//
//  Created by NewM on 13-5-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+Dragon_Notification.h"
#undef DEFAULT_KEYBOARD_HEIGHT
#define DEFAULT_KEYBOARD_HEIGHT 216.f

#undef UIKeyboardDidChangeFrameNotification
#define UIKeyboardDidChangeFrameNotification @"UIKeyboardDidChangeFrameNotification"

#undef UIKeyboardWillChangeFrameNotification
#define UIKeyboardWillChangeFrameNotification @"UIKeyboardWillChangeFrameNotification"

@interface DragonUIKeyboard : NSObject
{
    BOOL    _shown;//是否显示
    CGFloat _height;//键盘高度
    
    CGRect  _accessorFrame;//自定义view大小
    UIView  *_accessor;//自定义view
    
    NSTimeInterval          _animationDuration;//动画类型
    UIViewAnimationCurve    _animationCurve;//动画秒数
}

AS_NOTIFICATION(SHOWN)//keyboard出现
AS_NOTIFICATION(HIDDEN)//键盘收起
AS_NOTIFICATION(HEIGHT_CHANGED)//输入法切换（高度改变）

@property (nonatomic, readonly)BOOL     shown;
@property (nonatomic, readonly)CGFloat  height;

@property (nonatomic, readonly)NSTimeInterval       animationDuration;
@property (nonatomic, readonly)UIViewAnimationCurve animationCurve;

@property (nonatomic, assign)BOOL       accessorHidden;//是否隐藏自定义view在动画结束

+ (DragonUIKeyboard *)sharedInstace;

//自定义view
- (void)showAccessor:(UIView *)view animated:(BOOL)animated;
- (void)hideAccessor:(UIView *)view animated:(BOOL)animated;
- (void)updateAccessorAnimated:(BOOL)animated animations:(NSString *)animationID;

@end
