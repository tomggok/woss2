//
//  Magic_UIAlertView.h
//  ShangJiaoYuXin
//
//  Created by NewM on 13-5-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagicUIAlertView : UIAlertView<UIAlertViewDelegate>


AS_SIGNAL(ALERTVIEW);
AS_SIGNAL(ALERTVIEWCANCEL);
AS_SIGNAL(WILLPRESENTALERTVIEW);
AS_SIGNAL(DIDPRESENTALERTVIEW);
AS_SIGNAL(ALERTVIEWWILLDISMISSWITHBUTTONINDEX);
AS_SIGNAL(ALERTVIEWDIDDISMISSWITHBUTTONINDEX);
AS_SIGNAL(ALERTVIEWSHOULDENABLEFIRSTOTHERBUTTON);
/*
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView;

- (void)willPresentAlertView:(UIAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(UIAlertView *)alertView;  // after animation

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

// Called after edits in any of the default fields added by the style
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;*/

@end
