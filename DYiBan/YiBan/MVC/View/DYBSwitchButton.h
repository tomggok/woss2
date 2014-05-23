//
//  DYBSwitchButton.h
//  DYiBan
//
//  Created by Song on 13-9-5.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define LOCK_IMAGE_SUBVIEW 100

typedef void(^changeHandler)(BOOL isOn);
@interface DYBSwitchButton : UIControl <NSCoding>

@property(nonatomic, retain) UIImage *onImage NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;         //Currently this does nothing
@property(nonatomic, retain) UIImage *offImage NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;        //Currently this does nothing

@property(nonatomic, retain) UIColor *onTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIColor *tintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIColor *thumbTintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;


///Additional color options provided by KLSwitch only
@property(nonatomic, retain) UIColor *contrastColor;
@property(nonatomic, retain) UIColor *thumbBorderColor;


@property(nonatomic, getter=isOn) BOOL on;
@property(nonatomic, getter=isLocked) BOOL locked;

//Custom completion block initiated by value change (on/off)
@property(nonatomic, copy) changeHandler didChangeHandler;

//Percent (0.0 - 1.0) of the control to travel while panning before a switch toggle is activated
@property(nonatomic, assign) CGFloat panActivationThreshold;

//Set to true if you want to maintain 51x31 proportions, false if you want to set the frame to anything
@property(nonatomic, assign) BOOL shouldConstrainFrame;

//Initializers
- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame
   didChangeHandler:(changeHandler) didChangeHandler;

//Events
- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (void)setLocked:(BOOL)locked;

@end
