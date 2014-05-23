//
//  UITextView+Property.h
//  ShangJiaoYuXin
//
//  Created by cham on 13-5-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Property)


@property (nonatomic,assign) UIEdgeInsets _orign_contentInset;//原始contentInset
@property (nonatomic,assign) CGSize _orign_contentSize;//原始contentSize
@property (nonatomic,assign) UIFont *_orign_font;//原始font
@property (nonatomic,assign) UILabel *lb_textLength;//字数限制lb

-(void)initLbTextLength:(CGRect)frame;
-(void)freshLbTextLengthText:(NSString *)text;

@end
