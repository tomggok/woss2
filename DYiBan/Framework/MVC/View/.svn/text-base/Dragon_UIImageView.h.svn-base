//
//  Dragon_UIImageView.h
//  ShangJiaoYuXin
//
//  Created by NewM on 13-5-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+DragonViewSignal.h"
#import "UIImageView+Init.h"
#import "UIImageView+WebCache.h"


@interface DragonUIImageView : UIImageView <UIGestureRecognizerDelegate>
//{
//
//    NSMutableArray *_arr_actions;//保存信号数据
//}

//AS_SIGNAL(TAP)       //单击信号
@property (nonatomic, assign)BOOL needRadius;
@property (nonatomic, retain) NSString *strTag;

AS_SIGNAL(WEBDOWNSUCCESS)//图片下载成功
AS_SIGNAL(WEBDOWNFAIL)//图片下载失败

-(void)setImgWithUrl:(NSString *)url defaultImg:(NSString *)defaultImg;

@end
