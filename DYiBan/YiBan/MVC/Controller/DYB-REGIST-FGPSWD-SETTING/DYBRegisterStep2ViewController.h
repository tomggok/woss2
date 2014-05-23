//
//  DYBRegisterStep2ViewController.h
//  DYiBan
//
//  Created by Song on 13-8-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBInputView.h"
#import "scrollerData.h"
@interface DYBRegisterStep2ViewController : DYBBaseViewController {
    
    DYBInputView *textInput[4];
    NSMutableArray *_schoollist_data;
}
AS_SIGNAL(CODEBUTTON)
AS_SIGNAL(JUMPBUTTON)
AS_SIGNAL(SCHOOLBUTTON)

@property(nonatomic,assign)BOOL back;
- (void)changeText:(NSString*)string scrollerData:(scrollerData*)scrollerData;
@end
