//
//  DYBPageControl.m
//  DYiBan
//
//  Created by Song on 13-9-5.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBPageControl.h"

@interface DYBPageControl(private)  // 声明一个私有方法, 该方法不允许对象直接使用
- (void)updateDots;
@end

@implementation DYBPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImagePageStateNormal:(UIImage *)image {  // 设置正常状态点按钮的图片
    [self updateDots];
}


- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    [self updateDots];
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

- (void)updateDots { // 更新显示所有的点按钮
    
    NSArray *subview = self.subviews;  // 获取所有子视图
    for (NSInteger i = 0; i < [subview count]; i++)
    {
        if ([[subview objectAtIndex:i] isKindOfClass:[UIImageView class]]) {
            UIImageView *dot = [subview objectAtIndex:i];
            [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, 10, 10)];
            
            if (self.currentPage == i) {
                [dot setImage:[UIImage imageNamed:@"round01.png"]];
            }
            else{
                [dot setImage:[UIImage imageNamed:@"round02.png"]];
            }
        }
        
    }
}


- (void)dealloc { // 释放内存
    [super dealloc];
}


@end
