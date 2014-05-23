//
//  DYBProgressView.h
//  DYiBan
//
//  Created by zhangchao on 13-11-14.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

//录音进度条
@interface DYBAudioProgressView : UIView

AS_SIGNAL(LoadDown)//完毕

@property (nonatomic,assign) CGRect FillRect;//被填充的区域
@property (nonatomic,retain) NSArray *A_color;//保存被填充的RGB和alpha颜色值
@property (nonatomic,assign) CGFloat MaxTime;//最大时长/秒

-(void)changeRect;

@end
