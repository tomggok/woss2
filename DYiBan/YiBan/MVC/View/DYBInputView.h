//
//  DYBInputView.h
//  DYiBan
//
//  Created by Song on 13-8-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYBInputView : UIView

@property (nonatomic, retain)MagicUITextField *nameField;
- (id)initWithFrame:(CGRect)frame placeText:(NSString *)placeText textType:(int)type;
- (CGFloat)getOrginx;
- (CGFloat)getOrginy;
- (CGFloat)getWidth;
- (CGFloat)getHeight;
- (CGFloat)getRightx;
- (CGFloat)getLowy;
@end
