//
//  UITextView+Property.m
//  ShangJiaoYuXin
//
//  Created by cham on 13-5-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UITextView+Property.h"
#import <objc/runtime.h>
#import "UILabel+ReSize.h"
#import "UIView+MagicCategory.h"

@implementation UITextView (Property)

@dynamic _orign_contentInset,_orign_contentSize,_orign_font,lb_textLength;

static char c_orign_contentInset;
-(UIEdgeInsets )_orign_contentInset
{
    return [objc_getAssociatedObject(self, &c_orign_contentInset) UIEdgeInsetsValue];

}

-(void)set_orign_contentInset:(UIEdgeInsets)Inset
{
    objc_setAssociatedObject(self, &c_orign_contentInset, [NSValue valueWithUIEdgeInsets:Inset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_orign_contentSize;
-(CGSize )_orign_contentSize
{
    return [objc_getAssociatedObject(self, &c_orign_contentSize) CGSizeValue];

}

-(void)set_orign_contentSize:(CGSize)size
{
    objc_setAssociatedObject(self, &c_orign_contentSize, [NSValue valueWithCGSize:size], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_orign_font;
-(UIFont *)_orign_font
{
    return objc_getAssociatedObject(self, &c_orign_font);
    
}

-(void)set_orign_font:(UIFont *)f
{
    objc_setAssociatedObject(self, &c_orign_font, f, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_lb_textLength;
-(UILabel *)lb_textLength
{
    return objc_getAssociatedObject(self, &c_lb_textLength);
    
}

-(void)setLb_textLength:(UILabel *)lb
{
    objc_setAssociatedObject(self, &c_lb_textLength, lb, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark- 创建字数限制Lb
-(void)initLbTextLength:(CGRect)frame 
{
    self.lb_textLength = [[MagicUILabel alloc]initWithFrame:frame];
    self.lb_textLength._originFrame=CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
//    self.lb_textLength._originFrame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    self.lb_textLength.backgroundColor = [UIColor clearColor];
    self.lb_textLength.textColor = [UIColor blackColor];
//    self.lb_textLength.text = @"0/40";
    self.lb_textLength.textAlignment = NSTextAlignmentCenter;
    self.lb_textLength.font = [UIFont systemFontOfSize:11];
    
}

#pragma mark- 刷新字数限制Lb
-(void)freshLbTextLengthText:(NSString *)text
{
    self.lb_textLength.text=text;
    [self.lb_textLength sizeToFitByconstrainedSize:CGSizeMake(1000, 1000)];
}

@end
