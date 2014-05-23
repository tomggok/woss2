//
//  Magic_UIUpdateView.h
//  DYiBan
//
//  Created by NewM on 13-8-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_INLINE CGFloat distansBetween(CGPoint p1, CGPoint p2)
{
    return sqrtf((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
}

typedef enum {
    DSlimeStateNormal,
    DSlimeStateShortening,
    DSlimeStateMiss
}DSlimeState;

typedef enum {
    DSlimeBlurShadow,
    DSlimeFillShadow
}DSlimeShaowType;

@interface DSlimeView : UIView
{
}
@property (nonatomic, assign) CGPoint startPoint, toPoint;
@property (nonatomic, assign) CGFloat viscous;//
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, retain) UIColor *bodyColor,*skinColor;

@property (nonatomic, assign) DSlimeShaowType shadowType;
@property (nonatomic, assign) CGFloat lineWith;
@property (nonatomic, assign) CGFloat shadowBlur;
@property (nonatomic, retain) UIColor *shadowColor;

@property (nonatomic, assign) BOOL missWhenApart;
@property (nonatomic, assign) DSlimeState state;

@property (nonatomic, assign)CGFloat refreshHeight;//滑动高度变成刷新（0默认，如果页面比较短建议传入.5f）

- (void)setPullApartTarget:(id)target action:(SEL)action;

@end

@class MagicUIUpdateView;
@protocol MagicUIUpdateViewDelegate <NSObject>

@optional
- (void)slimeRefreshStart:(MagicUIImageView *)refreshView;

@end
typedef void(^DUpdateBlock)(MagicUIUpdateView *sender);

typedef enum {
    DUpdateStateNomal = 1,
    DUpdateStateDownLoad =2,
    DUpdateStateUpLoad = 3,
    DUpdateStateUpLoadEnd = 4
}DUpdateState;

@interface MagicUIUpdateView : UIView
{
    MagicUIImageView *_refleshView;
    DSlimeView        *_slime;
}

@property (nonatomic, assign)BOOL loading;
@property (nonatomic, assign)DUpdateState updateState;

@property (nonatomic, retain, readonly)DSlimeView *slime;
@property (nonatomic, retain, readonly)MagicUIImageView *refleshView;

@property (nonatomic, copy)DUpdateBlock block;
@property (nonatomic, assign)id<MagicUIUpdateViewDelegate> delegate;
@property (nonatomic, readonly)UIActivityIndicatorView *activityIndicationView;
@property (nonatomic, assign)BOOL slimeMissWhenGoingBack;
@property (nonatomic, assign)CGFloat upInset;

- (void)scrollViewDidScroll;
- (void)scrollViewDidEndDraging;
- (void)setLoadingWithexpansion;//
- (void)endRefresh;

- (id)initWithHeight:(CGFloat)height;

@end
