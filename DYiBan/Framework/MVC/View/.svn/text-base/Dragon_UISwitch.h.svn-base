//
//  Dragon_UISwitch.h
//  DragonFramework
//
//  Created by zhangchao on 13-4-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dragon_ViewSignal.h"

typedef enum {
    DragonUISwitchSystem = 0,
    DragonUISwitchCustom = 1
    }DragonUISwitchType;

@interface DragonUISwitch : UIView
{

}
@property (nonatomic, assign)BOOL isOn;
@property (nonatomic, assign)DragonUISwitchType switchType;

AS_SIGNAL(SWITCHCHANGED)       //状态改变

- (id)initWithFrame:(CGRect)frame switchType:(DragonUISwitchType)type;

- (void)setButtonImgName:(NSArray *)imgArray;

@end
