//
//  UIView+DragonCategory.h
//  DragonFramework
//
//  Created by NewM on 13-3-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(DragonCategory)

AS_SIGNAL(TAP)       //单击信号
AS_SIGNAL(PAN)       //拖动消息

@property (nonatomic,assign) CGRect _originFrame;
@property (nonatomic,assign) BOOL b_isStretchingUp/*是否已经上拉,用于 上下滑动时 隐藏 tbv上下的view*/, b_isStretching/*是否正在上下移动,用于 上下滑动时 隐藏 tbv上下的view*/;
@property (nonatomic,assign) UIView *v_headerVForHide/*在上拉时顶部需要隐藏的view*/,*v_footerVForHide/*在下拉时底部需要隐藏的view*/,*v_expandGestureArea/*扩展触摸区域*/;
@property (nonatomic,assign)  NSMutableArray *muA_signal;
@property (assign, nonatomic) CGFloat initialTouchPositionX;//用于拖动计算(初始拖动点)
@property (assign, nonatomic) CGFloat moveDir;//用于拖动计算(移动方向: 0:左 1:右)
@property (assign, nonatomic) CGFloat moveMax_x;//用于拖动计算(x能被移动的最大距离)

- (UIViewController *)viewController;

-(void)changePosInSuperViewWithAlignment:(NSUInteger)Alignment;

- (void)addSignal:(NSString *)signal object:(NSObject *)object;

- (void)addSignal:(NSString *)signal object:(NSObject *)object target:(id)target;
-(void)removeSignal:(NSString *)signal;

#pragma mark-上下滑动时自动隐藏自己上下需要隐藏的view
-(void)StretchingUpOrDown:(int)upOrDown/*0:up  1:down*/;

-(UIViewController *)superCon;

-(void)creatExpandGestureAreaView;

-(void)removeAllSignal;

-(void)setOriginFrame;

@end
