//
//  DYBCellForNotesDetail.h
//  DYiBan
//
//  Created by zhangchao on 13-11-5.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYBCustomLabel.h"

@interface DYBCellForNotesDetail : UITableViewCell
{
    MagicUIScrollView *_scrV_Tip/*标签的背景滚动*/;
    MagicUIButton *_bt_AddTag/*添加标签*/,*_bt_del/*删除*/;
    MagicUITextView *_textView;
    MagicUIImageView *_imgV_show,*_imgV_voice/*喇叭*/;
    int _state;//0:正常状态 1:编辑状态
    MagicUILabel *_lb_addTag/*添加标签*/;
}

-(void)changeState:(int)state;
//-(void)refreshByType;
-(void)changeTextView:(int)i;
-(void)PlayOrStopAudio:(int)i;

@end
