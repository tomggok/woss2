//
//  Magic_UISwitch.m
//  MagicFramework
//
//  Created by zhangchao on 13-4-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_UISwitch.h"
#import "UIView+MagicViewSignal.h"

@interface MagicUISwitch ()
{
    //MagicUISwitchSystem
    UISwitch *sw;
    
    //MagicUISwitchCustom
    MagicUIButton *button;//switchbutton
    NSArray *imgArray;
}

@end

@implementation MagicUISwitch
@synthesize switchType = _switchType;
@synthesize isOn = _isOn;
DEF_SIGNAL(SWITCHCHANGED)


- (void)dealloc
{
    
    [self cleanData];
    
    if (imgArray)
    {
        RELEASEOBJ(imgArray);
    }
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initSelf:MagicUISwitchSystem];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf:MagicUISwitchSystem];
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame switchType:(MagicUISwitchType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _switchType = type;
        [self initSelf:type];
    }
    return self;
}

- (void)initSelf:(MagicUISwitchType)type
{
    for (UIView *view in self.subviews)
    {
        RELEASEVIEW(view);
    }
    if (type == MagicUISwitchSystem)
    {
        if (!sw)
        {
            sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 27)];
            [self addSubview:sw];
            [sw addTarget:self
                   action:@selector(switchViewChanged:)
         forControlEvents:UIControlEventValueChanged];
        }
        sw.on = NO;
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 78, 28)];
    }else if (type == MagicUISwitchCustom)
    {
        if (!button)
        {
            button = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            [self addSubview:button];
            [button addTarget:self
                       action:@selector(switchViewChanged:)
             forControlEvents:UIControlEventTouchUpInside];
            self.isOn = NO;
        }
        
    }
    
}

- (void)setSwitchType:(MagicUISwitchType)switchType
{
    _switchType = switchType;
    [self cleanData];
    [self initSelf:switchType];
}

- (void)setButtonImgName:(NSArray *)_imgArray
{
    if (imgArray)
    {
        RELEASEOBJ(imgArray);
    }
    imgArray = [[NSArray alloc] initWithArray:_imgArray];
    [self setSwitchType:_switchType];
    self.isOn = _isOn;
}

- (void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    sw.on = _isOn;
    
    if (button)
    {
        if ([imgArray count] > 1)
        {
            if (_switchType == MagicUISwitchCustom)
            {
                if (_isOn)
                {
                    UIImage *img = [UIImage imageNamed:[imgArray objectAtIndex:1]];
                    [button setImage:img forState:UIControlStateNormal];
                    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, img.size.width/2, img.size.height/2)];
                    [button setFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2)];
                }else
                {
                    UIImage *img = [UIImage imageNamed:[imgArray objectAtIndex:0]];
                    [button setImage:img forState:UIControlStateNormal];
                    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, img.size.width/2, img.size.height/2)];
                    [button setFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2)];
                    
                }
                
            }
        }
    }
    
}

- (void)switchViewChanged:(id)sender
{
    self.isOn = !_isOn;
    [self sendViewSignal:[MagicUISwitch SWITCHCHANGED]];

}

- (void)cleanData
{
    if (button)
    {
        RELEASEVIEW(button);
    }
    
    if (sw)
    {
        RELEASEVIEW(sw);
    }
    
}

@end
