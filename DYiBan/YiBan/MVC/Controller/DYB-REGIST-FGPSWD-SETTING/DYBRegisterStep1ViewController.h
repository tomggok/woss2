//
//  DYBRegisterStep1ViewController.h
//  DYiBan
//
//  Created by Song on 13-8-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBInputView.h"
@interface DYBRegisterStep1ViewController : DYBBaseViewController {
    
    DYBInputView *textInput[3];
    MagicUIButton *btnSex[3];
    int selectSex;
}
AS_SIGNAL(BOYBUTTON)
AS_SIGNAL(GIRLTBUTTON)
@end
