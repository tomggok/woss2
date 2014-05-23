//
//  Magic_UIThirdView.h
//  MagicFramework
//
//  Created by NewM on 13-7-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    MagicUINomalView = 0,
    MagicUILeftView = 1,
    MagicUIRightView = 2,
    MagicUINoScroll = 3
}MagicUIShowType;

typedef enum {
    MagicScrollNomal = 0,
    MagicScrollLeft = 1,
    MagicScrollRight = 2
}MagicUIThirdScrollState;

@interface MagicUIThirdView : UIView<UIGestureRecognizerDelegate>
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

@property (nonatomic, assign)MagicUIShowType viewType;       //页面类型需要的形势

@property (nonatomic, assign, readonly)MagicUIThirdScrollState scrollState;


- (void)endMoveViewWithX:(CGFloat)xOffset;
- (void)oneViewSwipe:(UIPanGestureRecognizer *)sender;

@end
