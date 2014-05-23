//
//  DYBGuideView.h
//  DYiBan
//
//  Created by zhangchao on 13-10-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

@class DYBGuideView;

typedef DYBGuideView*(^DYBGuideViewImg)(id key,...);


//引导图
@interface DYBGuideView : DYBBaseView

- (DYBGuideViewImg)AddImgByName;

@end
