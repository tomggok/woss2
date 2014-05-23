//
// SVSegmentedThumb.h
// SVSegmentedControl
//
// Created by Sam Vermette on 25.05.11.
// Copyright 2011 Sam Vermette. All rights reserved.
//
// https://github.com/samvermette/SVSegmentedControl
//

#import <UIKit/UIKit.h>

@class MagicUISegmentedControl;

//选中项
@interface MagicUISegmentedThumb : UIView

@property (nonatomic, strong) UIImage *backgroundImage; // default is nil;选中框的
@property (nonatomic, strong) UIImage *highlightedBackgroundImage; // default is nil;选中框的

@property (nonatomic, strong) UIColor *tintColor; // default is [UIColor grayColor] 选中框的背景色
@property (nonatomic, unsafe_unretained) UIColor *textColor; // default is [UIColor whiteColor]
@property (nonatomic, unsafe_unretained) UIColor *textShadowColor; // default is [UIColor blackColor]
@property (nonatomic, readwrite) CGSize textShadowOffset; // default is CGSizeMake(0, -1)
@property (nonatomic, readwrite) BOOL shouldCastShadow; // default is YES (NO when backgroundImage is set)

-(void)setTitleData:(id)title;
// deprecated properties
@property (nonatomic, unsafe_unretained) UIColor *shadowColor DEPRECATED_ATTRIBUTE; // use textShadowColor instead
@property (nonatomic, readwrite) CGSize shadowOffset DEPRECATED_ATTRIBUTE; // use textShadowOffset instead
@property (nonatomic, readwrite) BOOL castsShadow DEPRECATED_ATTRIBUTE; // use shouldCastShadow instead

@end
