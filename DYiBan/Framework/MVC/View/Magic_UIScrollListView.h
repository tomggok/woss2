//
//  Magic_UIScrollListView.h
//  DYiBan
//
//  Created by NewM on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSHOWIMGKEY @"showImgKey"
#define kDEFAULTIMGKEY @"defaultImgKey"
#import "UIView+MagicViewSignal.h"
@interface MagicUIScrollListView : UIView
{

}

AS_SIGNAL(SCROLLVIEWNUM);

@property (nonatomic, retain)NSArray *imgArr;//图片列表

@property (nonatomic, assign)NSInteger selectIndex;//选择的图片
@end
