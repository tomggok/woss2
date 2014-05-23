//
//  DYBSetButton.h
//  DYiBan
//
//  Created by Song on 13-8-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"
#import "DYBSwitchButton.h"

@interface DYBSetButton : MagicUIButton
@property (nonatomic, retain)MagicUILabel *textLabel;
@property (nonatomic, retain)DYBSwitchButton *switchButton;
@property (nonatomic, retain)MagicUIImageView *arrowImv;
AS_SIGNAL(SWITCHBTN);//选择switch
- (CGFloat)getOrginx;
- (CGFloat)getOrginy;
- (CGFloat)getWidth;
- (CGFloat)getHeight;
- (CGFloat)getRightx;
- (CGFloat)getLowy;
- (id)initWithFrame:(CGRect)frame labelText:(NSString *)labelText isArrow:(BOOL)yesOn type:(int)type;
- (void)setStatus:(BOOL)status;
@end
