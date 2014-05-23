//
//  Dragon_UITabBar.h
//  DragonFramework
//
//  Created by NewM on 13-6-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dragon_ViewSignal.h"

#define TABBARBUTDEFAULT    @"default"
#define TABBARBUTHIGHLIGHT  @"highlighted"
#define TABBARBUTSELETED    @"selected"

@interface DragonUITabBar : UIView
{
    UIImageView *_backgroundView;
    
    NSMutableArray *_buttons;
}
@property (nonatomic, assign)id delegate;

@property (nonatomic, retain)UIImageView *backgroundView;
@property (nonatomic, retain)NSMutableArray *buttons;
AS_SIGNAL(TOUCHEDBUTTON)

AS_SIGNAL(TABBARBUTTON)

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)removeTabAtIndex:(NSInteger)index;
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;
- (void)setBackgroundImage:(UIImage *)img;

@end
