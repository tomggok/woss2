//
//  Magic_UIButton.h
//  MagicFramework
//
//  Created by NewM on 13-3-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Magic_ViewSignal.h"

#define BTVIEWCLICKONETAG 9124

@class MagicUIButton;
@interface MagicUIButtonState : NSObject
{
    MagicUIButton *_button;
    UIControlState _state;
    
}

@property (nonatomic, assign)MagicUIButton *button;
@property (nonatomic, assign)UIControlState state;
@property (nonatomic, assign)NSString *title;
@property (nonatomic, assign)UIColor *titleColor;
@property (nonatomic, assign)UIColor *titleShadowColor;
@property (nonatomic, assign)UIImage *image;
@property (nonatomic, assign)UIImage *backgroundImage;

@end

@interface MagicUIButton : UIButton
{
    NSMutableArray *_arr_actions;
    UILabel *_label;
    UIEdgeInsets _inserts;
    
    MagicUIButtonState *_stateNormal;
    MagicUIButtonState *_stateHighlighted;
    MagicUIButtonState *_stateDisabled;
    MagicUIButtonState *_stateSelected;
    

}

AS_SIGNAL(TOUCH_DOWN)       //按下
AS_SIGNAL(TOUCH_DOWN_REPEAT)//长按
AS_SIGNAL(TOUCH_UP_INSIDE)  //抬起（击中）
AS_SIGNAL(TOUCH_UP_OUTSIDE) //抬起（未击中）
AS_SIGNAL(TOUCH_UP_CANCEL)  //撤销

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIColor *titleShadowColor;
@property (nonatomic, assign) UIEdgeInsets titleInsets;

@property (nonatomic, readonly) MagicUIButtonState *stateNormal;
@property (nonatomic, readonly) MagicUIButtonState *stateHighlighted;
@property (nonatomic, readonly) MagicUIButtonState *stateDisabled;
@property (nonatomic, readonly) MagicUIButtonState *stateSelected;

- (void)didTouchDown;
- (void)didTouchDownRepeat;
- (void)didTouchUpInside;
- (void)didTouchOutSide;
- (void)didTouchCancel;

- (void)addSignal:(NSString *)signal forControlEvents:(UIControlEvents)controlEvents;
- (void)addSignal:(NSString *)signal forControlEvents:(UIControlEvents)controlEvents object:(NSObject *)object;


//设置bt只点击一次
- (void)setNetClickOne;

@end
