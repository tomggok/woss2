//
// SWSegmentedControl.h
// SWSegmentedControl
//
// Created by Sam Vermette on 26.10.10.
// Copyright 2010 Sam Vermette. All rights reserved.
//
// https://github.com/samvermette/SVSegmentedControl
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>
#import "Magic_UISegmentedThumb.h"

#import "Magic_ViewSignal.h"

@protocol MagicUISegmentedControlDelegate

- (void)segmentedControl:(MagicUISegmentedControl*)segmentedControl didSelectIndex:(NSUInteger)index;

@end

//////////////////////////////////////////////////////////////////

#pragma mark-
@protocol MagicUISegmentedControlDelegate;

@interface MagicUISegmentedControl : UIControl
{
    NSUInteger _i_lastSelectIndex;//上次选中的下标
}

AS_SIGNAL(SEGMENTCHANGED)

@property (nonatomic, copy) void (^changeHandler)(NSUInteger newIndex); // you can also use addTarget:action:forControlEvents:
@property (nonatomic, strong, readonly) MagicUISegmentedThumb *thumb;
@property (nonatomic, readwrite) NSUInteger selectedIndex; // default is 0
@property (nonatomic, readwrite) BOOL animateToInitialSelection; // default is NO
@property (nonatomic, readwrite) BOOL crossFadeLabelsOnDrag; // default is NO

@property (nonatomic, strong) UIColor *tintColor; // default is [UIColor grayColor]  背景色
@property (nonatomic, strong) UIImage *backgroundImage; // default is nil

@property (nonatomic, readwrite) CGFloat height; // default is 32.0
@property CGFloat LKWidth;
@property (nonatomic, readwrite) UIEdgeInsets thumbEdgeInset; // default is UIEdgeInsetsMake(2, 2, 3, 2)
@property (nonatomic, readwrite) UIEdgeInsets titleEdgeInsets; // default is UIEdgeInsetsMake(0, 10, 0, 10)
@property (nonatomic, readwrite) CGFloat cornerRadius; // default is 4.0

@property (nonatomic, strong) UIFont *font; // default is [UIFont boldSystemFontOfSize:15]
@property (nonatomic, strong) UIColor *textColor; // default is [UIColor grayColor];
@property (nonatomic, strong) UIColor *textShadowColor;  // default is [UIColor blackColor] 文字阴影色
@property (nonatomic, readwrite) CGSize textShadowOffset;  // default is CGSizeMake(0, -1)

// deprecated properties
@property (nonatomic, copy) void (^selectedSegmentChangedHandler)(id sender) DEPRECATED_ATTRIBUTE; // use changeHandler instead
@property (nonatomic, strong) UIColor *shadowColor DEPRECATED_ATTRIBUTE;  // use textShadowColor instead
@property (nonatomic, readwrite) CGSize shadowOffset DEPRECATED_ATTRIBUTE;  // use textShadowOffset instead
@property (nonatomic, unsafe_unretained) id<MagicUISegmentedControlDelegate> delegate DEPRECATED_ATTRIBUTE; // use addTarget:action:forControlEvents: instead
@property (nonatomic, readwrite) CGFloat segmentPadding DEPRECATED_ATTRIBUTE; // use titleEdgeInsets instead

@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, strong) NSMutableArray *_muA_BackBroundColorComponent;/*背景色数据,下标 0和1是上半部分的颜色和alpha,2和3是下半部分的颜色和alpha*/
@property (nonatomic, assign) BOOL _b_selectChange;//下标是否更新

- (id)initWithFrame:(CGRect)frame SectionTitles:(NSArray*)array ;
- (void)moveThumbToIndex:(NSUInteger)segmentIndex animate:(BOOL)animate;
+ (UIImage *) grayscaleImage: (UIImage *) image;
- (void)segmentedControlChangedValue:(MagicUISegmentedControl*)segmentedControl;

@end

