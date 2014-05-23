//
//  DYBUnreadMsgView.h
//  DYiBan
//
//  Created by zhangchao on 13-8-20.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"

//未读信息提示视图
@interface DYBUnreadMsgView : DYBBaseView
{
    MagicUIImageView *_imgV_back;
    MagicUILabel *_lb_nums;
}

- (id)initWithFrame:(CGRect)frame/*宽高可以随便传*/ img:(UIImage *)img nums:(NSString *)nums arrowDirect:(int)arrowDirect  /*箭头朝向,1:上(_lb_nums.frame.origin.y+3); 2:下(_lb_nums.frame.origin.y-3); 3:左(_lb_nums.frame.origin.x-3); 右:(_lb_nums.frame.origin.x+3)*/;
-(void)refreshByimg:(UIImage *)img nums:(NSString *)nums;

@end
