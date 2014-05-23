//
//  DYBForgetPassWordViewController.h
//  DYiBan
//
//  Created by Song on 13-8-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBInputView.h"
@interface DYBForgetPassWordViewController : DYBBaseViewController
@property(nonatomic,retain)DYBInputView *phoneInput;
@property(nonatomic,retain)DYBInputView *codeInput;
@property(nonatomic,retain)MagicUIButton *codeButton;
@property(nonatomic,retain)DYBInputView *loginPassInput;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)id father;
AS_SIGNAL(GETCODEBUTTON)
@end
