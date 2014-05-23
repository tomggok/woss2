//
//  UIViewController+AlertView.m
//  MagicFramework
//
//  Created by zhangchao on 13-4-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIViewController+AlertView.h"
#import "NSTimer+Create.h"

@implementation UIViewController (AlertView)

#pragma mark-创建一个提示框,并在多少秒后自动消失
-(void)CreatAnAlertViewWithTitle:(NSString *)title message:(NSString *)message /*delegate:(id)delegate*/ tag:(int)tag Selector:(SEL)Selector AfterTimeInterval:(NSTimeInterval)ti  userInfo:(id)userInfo repeats:(BOOL)repeats cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alert show];
    alert.tag=tag;
    if(userInfo)
        {
        userInfo=alert;
        }
    [alert release];

    if(Selector)
        {
        [NSTimer CreatAnTimeToCallAnFunctionBySelector:Selector AfterTimeInterval:ti /*target:delegate*/ userInfo:userInfo repeats:repeats isWantToHave:NO];
        }
}
@end
