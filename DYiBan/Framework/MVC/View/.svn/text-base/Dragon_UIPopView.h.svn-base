//
//  Dragon_UIPopView.h
//  DragonFramework
//
//  Created by NewM on 13-6-3.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+DragonViewSignal.h"
#import "Dragon_ViewSignal.h"
@interface DragonUIPopView : UIView
{
}

AS_SIGNAL(POPHIDDEN)
AS_SIGNAL(POPTOUCHEDOTHER)

@property (nonatomic, assign)BOOL needShadow;
//设置阴影颜色和透明
- (void)setShadowColor:(UIColor *)backColor alpha:(CGFloat)alpha;
//设置自定义view
- (void)setChildView:(UIView *)childView;
//显示
- (void)alertView;
//隐藏
- (void)hideView;
//释放
- (void)releaseSelf;
//隐藏并释放
- (void)autoHidenRelease;
@end
