//
//  DYBResetPassWordViewController.h
//  DYiBan
//
//  Created by Song on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBInputView.h"
@interface DYBResetPassWordViewController : DYBBaseViewController
@property(nonatomic,retain)DYBInputView *passwordInput;
@property(nonatomic,retain)DYBInputView *passwordInput2;
@property(nonatomic,retain)NSString *codeString;
@property(nonatomic,retain)NSString *loginName;
@property(nonatomic,retain)NSString *userId;
@end
