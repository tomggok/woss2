//
//  Magic_UIPopView.h
//  MagicFramework
//
//  Created by NewM on 13-5-27.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+MagicViewSignal.h"
#import "Magic_ViewSignal.h"

typedef enum MagicpopViewType{
    MagicPOPALERTVIEWNOINDICATOR = 0,
    MagicPOPALERTVIEWINDICATOR = 1
}MagicpopViewType;

typedef enum MagicpopAlertIndicatorType{
    INDICATORLEFTTYPE = 0,
    INDICATORRIGHTTYPE = 1,
    INDICATORHEADTYPE = 2,
    INDICATORFOOTTYPE = 3
}MagicpopAlertIndicatorType;

@interface MagicUIPopAlertView : UIView
{
}
AS_SIGNAL(POPALERTHIDDEN)
@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) MagicpopViewType mode;
@property (nonatomic, assign) MagicpopAlertIndicatorType indicatorMode;
@property (nonatomic, retain) NSMutableArray *imgArray;
@property (nonatomic, assign) BOOL needSelfY;//是否需要自定义Y轴
@property (nonatomic, assign) CGFloat alertViewY;//设置Y轴的

//设置文字
- (void)setText:(NSString *)text;

- (void)alertViewShown;//显示

- (void)alertViewHidden;//隐藏

- (void)releaseAlertView;//释放

- (void)alertViewHiddenAndRelease;//隐藏并释放

- (void)alertViewAutoHidden:(NSTimeInterval)duration;//自动隐藏

- (void)alertViewAutoHidden:(NSTimeInterval)duration isRelease:(BOOL)isRelease;//自动隐藏并释放



@end
