//
//  DYBBaseView.h
//  DYiBan
//
//  Created by NewM on 13-8-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYBBaseView : UIView
{}
@property (nonatomic, assign)UIView *blurSuperView;
@property (nonatomic, assign, readonly)CGFloat blurLevel;

//自定义截取图片
- (void)cutBlurImg:(UIView *)superView withRect:(CGRect)frame;
- (void)cutBlurImg:(CGRect)frame;

@end
