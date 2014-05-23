//
//  DYBCallView.h
//  DYiBan
//
//  Created by zhangchao on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"
#import "friends.h"

#ifndef k_tag_bt_cancelViews
#define k_tag_bt_cancelViews -111 //取消按钮的tag
#endif

#ifndef k_tag_bt_ensurelViews
#define k_tag_bt_ensurelViews -112 //确认按钮的tag
#endif

//打电话view
@interface DYBCallView : DYBBaseView
{
    
}

@property (nonatomic,retain) MagicUIButton *bt_cancelViews;

- (id)initWithFrame:(CGRect)frame model:(friends *)model superV:(UIView *)superV;

@end
