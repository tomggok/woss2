//
//  DYBRegisterStep3ViewController.h
//  DYiBan
//
//  Created by Song on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBInputView.h"
#import "scrollerData.h"
@interface DYBRegisterStep3ViewController : DYBBaseViewController {
    
    DYBInputView *textInput[4];
    NSMutableArray *_schoollist_data;
}
AS_SIGNAL(SCHOOLBUTTON)
- (void)changeText:(NSString*)string scrollerData:(scrollerData*)scrollerData;
@end
