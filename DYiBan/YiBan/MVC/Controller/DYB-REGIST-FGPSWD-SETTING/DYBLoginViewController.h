//
//  DYBLoginViewController.h
//  DYiBan
//
//  Created by NewM on 13-8-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBInputView.h"
@interface DYBLoginViewController : DYBBaseViewController
@property(nonatomic,retain)MagicUIImageView *imLog;
@property(nonatomic,retain)DYBInputView *nameInput;
@property(nonatomic,retain)DYBInputView *passInput;
@property(nonatomic,retain)MagicUIButton *loginButton;
AS_SIGNAL(LOGINBUTTON)
AS_SIGNAL(REGISTBUTTON)
AS_SIGNAL(FORGETBUTTON)
AS_SIGNAL(ENTERDATABANK)
@end
