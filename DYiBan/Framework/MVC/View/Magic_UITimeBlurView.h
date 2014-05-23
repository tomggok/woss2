//
//  Magic_UITimeBlurView.h
//  MagicFramework
//
//  Created by NewM on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kDTimeBlurViewScreenshotCompression = 0.01;//图片压缩质量

static const CGFloat kDTimeBlurViewBlurLevel = .3f;//view虚化程度

static const CGFloat kDTimeBlurViewDefaultCornerRadius = 0.f;//设置虚化view的圆弧程度

static const CGFloat kDTimeBlurViewRenderFps = 30.f;//刷新频率

static const CGFloat kDTimeBlurTintColorAlpha = .1f;//虚化view的透明度

@interface MagicUITimeBlurView : UIView
{
}
@property (nonatomic, assign)BOOL renderStatic;
@property (nonatomic, retain)UIColor *tint;//todowithios7

@property (nonatomic, assign)CGFloat blurLevel;//设置虚化程度(最高等级为1.f最低0.f)
@property (nonatomic, assign)CGFloat tintColorAlpha;//虚化view的透明度



@end
