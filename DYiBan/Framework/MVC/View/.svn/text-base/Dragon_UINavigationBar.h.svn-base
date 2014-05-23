//
//  Dragon_NavigationBar.h
//  ShangJiaoYuXin
//
//  Created by NewM on 13-5-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dragon_NavigationController.h"

@interface DragonUINavigationBar : UIView
{
    DragonUIButton *_backBt;
    
    
}
AS_SIGNAL(BUTTON_BACK)

@property (nonatomic, retain, readonly)DragonUIButton *backBt;
@property (nonatomic, assign)DragonNavigationController *navi;
@property (nonatomic, assign)BOOL isTop;


- (void)setLeftBtImg:(UIImage *)img;//设置返回按钮图片
- (void)setLeftBtImgTouched:(UIImage *)img;//设置返回点击之后按钮图片
- (void)setRightView:(UIView *)rightView;//设置右面的view


@end
