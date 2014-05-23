//
//  Magic_UITextField.h
//  MagicFramework
//
//  Created by NewM on 13-3-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Magic_ViewSignal.h"
#import "UIView+MagicViewSignal.h"
@class MagicUITextFieldAgent;
@interface MagicUITextField : UITextField
{

    NSUInteger  _maxLength;
    MagicUITextFieldAgent *_agent;
}

@property (nonatomic, assign)BOOL active;
@property (nonatomic, assign)NSUInteger maxLength;
@property (nonatomic, assign)int type;

AS_SIGNAL(TEXT_OVERFLOW)//文字超长
AS_SIGNAL(TEXTFIELDSHOULDBEGINEDITING)// - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
AS_SIGNAL(TEXTFIELDDIDBEGINEDITING)//- (void)textFieldDidBeginEditing:(UITextField *)textField;
AS_SIGNAL(TEXTFIELDSHOULDENDEDITING)//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
AS_SIGNAL(TEXTFIELDDIDENDEDITING)//- (void)textFieldDidEndEditing:(UITextField *)textField;
AS_SIGNAL(TEXTFIELD)//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
AS_SIGNAL(TEXTFIELDSHOULDCLEAR)//- (BOOL)textFieldShouldClear:(UITextField *)textField;
AS_SIGNAL(TEXTFIELDSHOULDRETURN)//- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
