//
//  Dragon_UITabBar.m
//  DragonFramework
//
//  Created by NewM on 13-6-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UITabBar.h"

@implementation DragonUITabBar

@synthesize delegate = _delegate;

@synthesize backgroundView = _backgroundView,buttons = _buttons;
DEF_SIGNAL(TOUCHEDBUTTON)

DEF_SIGNAL(TABBARBUTTON)

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_backgroundView];
        
        _buttons = [[NSMutableArray alloc] initWithCapacity:[imageArray count]];
        
        DragonUIButton *btn;
        CGFloat width = CGRectGetWidth(self.bounds) / [imageArray count];
        
        for (int i = 0; i < [imageArray count]; i++)
        {
            btn = [DragonUIButton buttonWithType:UIButtonTypeCustom];
            btn.showsTouchWhenHighlighted = YES;
            btn.tag = i;
            btn.frame = CGRectMake(width * i, 0, width, CGRectGetHeight(frame));
            
            DLogInfo(@"[[imageArray objectAtIndex:i] objectForKey:TABBARBUTDEFAULT] === %@", [[imageArray objectAtIndex:i] objectForKey:TABBARBUTDEFAULT]);
            [btn setImage:[[imageArray objectAtIndex:i] objectForKey:TABBARBUTDEFAULT]
                 forState:UIControlStateNormal];
            [btn setImage:[[imageArray objectAtIndex:i] objectForKey:TABBARBUTHIGHLIGHT]
                 forState:UIControlStateHighlighted];
            [btn setImage:[[imageArray objectAtIndex:i] objectForKey:TABBARBUTSELETED]
                 forState:UIControlStateSelected];
            [btn addSignal:[DragonUITabBar TOUCHEDBUTTON]
          forControlEvents:UIControlEventTouchUpInside];
            [_buttons addObject:btn];
            [self addSubview:btn];
            
        }
        
        
        
    }
    return self;
}

- (void)tabBarButtonClicked:(id)sender
{
    DragonUIButton *btn = sender;
    [self selectTabAtIndex:btn.tag];

    [self sendViewSignal:[DragonUITabBar TABBARBUTTON] withObject:[NSNumber numberWithInt:btn.tag] from:self target:_delegate];
}

- (void)selectTabAtIndex:(NSInteger)index
{
    for (int i = 0; i < [_buttons count]; i++)
    {
        DragonUIButton *b = [_buttons objectAtIndex:i];
        [b setSelected:NO];
        [b setUserInteractionEnabled:YES];
    }
    DragonUIButton *btn = [_buttons objectAtIndex:index];
    btn.selected = YES;
    btn.userInteractionEnabled = NO;

}

- (void)removeTabAtIndex:(NSInteger)index
{
    DragonUIButton *but = [[self buttons] objectAtIndex:index];
    [but removeFromSuperview];
    but = nil;
    
    [_buttons removeObjectAtIndex:index];
    
    CGFloat width = CGRectGetWidth(self.bounds) / [_buttons count];
    
    for (DragonUIButton *btn in _buttons)
    {
        if (btn.tag > index)
        {
            btn.tag --;
        }
        btn.frame = CGRectMake(width * btn.tag, 0, width, CGRectGetHeight(self.bounds));
    }
}

- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    CGFloat width = CGRectGetWidth(self.bounds) / ([_buttons count] + 1);
    for (DragonUIButton *b in _buttons)
    {
        if (b.tag >= index)
        {
            b.tag++;
        }
        b.frame = CGRectMake(width*b.tag, 0, width, CGRectGetHeight(self.bounds));
    }
    
    DragonUIButton *btn = [DragonUIButton buttonWithType:UIButtonTypeCustom];
    btn.showsTouchWhenHighlighted = YES;
    btn.tag = index;
    btn.frame = CGRectMake(width*index, 0, width, CGRectGetHeight(self.bounds));
    [btn setImage:[dict objectForKey:TABBARBUTDEFAULT]
         forState:UIControlStateNormal];
    [btn setImage:[dict objectForKey:TABBARBUTHIGHLIGHT]
         forState:UIControlStateHighlighted];
    [btn setImage:[dict objectForKey:TABBARBUTSELETED]
         forState:UIControlStateSelected];
    [btn addSignal:[DragonUITabBar TOUCHEDBUTTON]
  forControlEvents:UIControlEventTouchUpInside];
    [_buttons insertObject:btn atIndex:index];
    [self addSubview:btn];
    
}


- (void)handleViewSignal_DragonUITabBar:(DragonViewSignal *)signal
{
    if ([signal is:[DragonUITabBar TOUCHEDBUTTON]])
    {
        
        [self tabBarButtonClicked:[signal source]];
    }
}

- (void)setBackgroundImage:(UIImage *)img
{
    [_backgroundView setImage:img];
}

- (void)dealloc
{
    RELEASEOBJ(_backgroundView);
    RELEASEDICTARRAYOBJ(_buttons);
    [super dealloc];
}


@end
