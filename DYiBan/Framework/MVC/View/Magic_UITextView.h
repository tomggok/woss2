//
//  Magic_UITextView.h
//  MagicFramework
//
//  Created by NewM on 13-3-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+MagicViewSignal.h"
#import "Magic_ViewSignal.h"

@class MagicUITextViewAgent;
@interface MagicUITextView : UITextView
{

    NSString *_placeHolder;
    UIColor *_placeHolderColor;
    UILabel *_placeHolderLabel;
    NSUInteger  _maxLength;
    
    MagicUITextViewAgent *_agent;
}

AS_SIGNAL(TEXTVIEWSHOULDBEGINEDITING)//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
AS_SIGNAL(TEXTVIEWSHOULDENDEDITING)//- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
AS_SIGNAL(TEXTVIEWDIDBEGINEDITING)//- (void)textViewDidBeginEditing:(UITextView *)textView;
AS_SIGNAL(TEXTVIEWDIDENDEDITING)//- (void)textViewDidEndEditing:(UITextView *)textView;
AS_SIGNAL(TEXTVIEW)////- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
AS_SIGNAL(TEXTVIEWDIDCHANGE)//- (void)textViewDidChange:(UITextView *)textView;
AS_SIGNAL(TEXTVIEWDIDCHANGESELECTION)//- (void)textViewDidChangeSelection:(UITextView *)textView;
AS_SIGNAL(TEXT_OVERFLOW)//文字超长


@property (nonatomic, assign)BOOL active;
@property (nonatomic, retain)NSString *placeHolder;
@property (nonatomic, retain)UILabel *placeHolderLabel;
@property (nonatomic, retain)UIColor *placeHolderColor;
@property (nonatomic, assign)NSUInteger maxLength;
@property (nonatomic, assign)CGSize maxSize;

- (void)updatePlaceHolder;
-(void)sizeFitByText;

@end
