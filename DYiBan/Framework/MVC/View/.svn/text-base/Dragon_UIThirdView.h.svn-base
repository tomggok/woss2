//
//  Dragon_UIThirdView.h
//  DragonFramework
//
//  Created by NewM on 13-7-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DragonUINomalView = 0,
    DragonUILeftView = 1,
    DragonUIRightView = 2,
    DragonUINoScroll = 3
}DragonUIShowType;

typedef enum {
    DragonScrollNomal = 0,
    DragonScrollLeft = 1,
    DragonScrollRight = 2
}DragonUIThirdScrollState;

@interface DragonUIThirdView : UIView<UIGestureRecognizerDelegate>
{
    UIView *_firstView;
    UIView *_secondView;
    UIView *_thirdView;
}
@property (nonatomic, retain)UIView           *firstView;     //主页面
@property (nonatomic, retain)UIView           *secondView;    //左页面
@property (nonatomic, retain)UIView           *thirdView;     //右页面

@property (nonatomic, assign)float            viewDiffenceNum;//页面差值
@property (nonatomic, assign)float            leftWidth;      //左边页面要显示view大小
@property (nonatomic, assign)float            rightWidth;     //右边页面要显示view大小

@property (nonatomic, assign)DragonUIShowType viewType;       //页面类型需要的形势

@property (nonatomic, assign, readonly)DragonUIThirdScrollState scrollState;


- (void)endMoveViewWithX:(CGFloat)xOffset;
- (void)oneViewSwipe:(UIPanGestureRecognizer *)sender;

@end
