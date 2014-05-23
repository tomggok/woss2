//
//  DYBNaviView.h
//  DYiBan
//
//  Created by NewM on 13-8-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYBNaviView : UIView
{
}
//title的frame属性
@property (nonatomic, assign, readonly)CGRect titleFrame;

@property (nonatomic, retain) UIView *lineView;

//设置标题颜色
- (void)setTitleColor:(UIColor *)color;

//设置标题
- (void)setTitle:(NSString *)title;

//设置标题和大小
- (void)setTitle:(NSString *)title font:(UIFont *)font;

//设置左边view
- (void)setLeftView:(UIView *)leftView;

//设置右边view
- (void)setRightView:(UIView *)rightView;

//设置箭头
- (void)setTitleArrow;

//设置箭头旋转
- (void)setTitleArrowStatus:(BOOL)bReversal;

//文字中间加省略
- (void)setTitlelineBreakMode;
@end
