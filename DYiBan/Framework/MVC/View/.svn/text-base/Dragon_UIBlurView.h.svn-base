//
//  Dragon_UIBlurView.h
//  DragonFramework
//
//  Created by NewM on 13-8-14.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultBlurLevel   .3f
@interface DragonUIBlurView : DragonUIImageView
{
}
@property (nonatomic, assign)CGFloat blurLevel;//虚化程度
@property (nonatomic, assign)UIView *blurView;//被虚化的view

//读取缓存中superview
- (UIImage *)cutBlurImg:(CGRect)frame;
//截取view为图片
- (UIImage *)cutBlurImg:(UIView *)superView withRect:(CGRect)frame;

@end
