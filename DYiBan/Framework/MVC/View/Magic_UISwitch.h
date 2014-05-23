//
//  Magic_UISwitch.h
//  MagicFramework
//
//  Created by zhangchao on 13-4-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Magic_ViewSignal.h"

typedef enum {
    MagicUISwitchSystem = 0,
    MagicUISwitchCustom = 1
    }MagicUISwitchType;

@interface MagicUISwitch : UIView
{

}
@property (nonatomic, assign)BOOL isOn;
@property (nonatomic, assign)MagicUISwitchType switchType;

AS_SIGNAL(SWITCHCHANGED)       //状态改变

- (id)initWithFrame:(CGRect)frame switchType:(MagicUISwitchType)type;

- (void)setButtonImgName:(NSArray *)imgArray;

@end
