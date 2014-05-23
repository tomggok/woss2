//
//  DYBSynchroViewController.h
//  DYiBan
//
//  Created by Song on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBSetButton.h"
@interface DYBSynchroViewController : DYBBaseViewController
@property(retain,nonatomic)MagicUIImageView *btnSelectT;
@property(retain,nonatomic)MagicUIImageView *btnSelectR;
@property(retain,nonatomic)DYBSetButton *btnSelect;

AS_SIGNAL(SYNCHROBUTTON)
- (void)setSynchYes:(int)tag;
@end
