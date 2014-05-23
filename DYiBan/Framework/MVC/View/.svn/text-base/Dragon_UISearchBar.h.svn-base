//
//  Dragon_UISearchBar.h
//  ShangJiaoYuXin
//
//  Created by zhangchao on 13-5-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dragon_ViewSignal.h"
#import "UIView+DragonViewSignal.h"

#ifndef k_tag_fadeBt
#define k_tag_fadeBt -113 //渐变消失bt的tag
#endif

#ifndef k_tag_CancelBt
#define k_tag_CancelBt -114 //取消bt的tag
#endif

@interface DragonUISearchBar : UISearchBar <UISearchBarDelegate>
{
    BOOL _isHideLeftView/*是否隐藏左边的视图*/;
    DragonUIButton *_bt_Shade/*用于点开搜索后遮罩键盘外的区域*/,*_bt_cancel;
}

AS_SIGNAL(BEGINEDITING) //第一次按下搜索框
AS_SIGNAL(CANCEL)
AS_SIGNAL(SEARCH) //按下搜索按钮
AS_SIGNAL(CHANGEWORD) //改变text
AS_SIGNAL(SEARCHING)//开始搜索

@property (nonatomic,assign) BOOL b_isSearching/*是否正在搜索*/;
@property (nonatomic,retain) DragonUIButton *bt_Shade/*用于点开搜索后遮罩键盘外的区域*/;

-(id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor placeholder:(NSString *)placeholder isHideOutBackImg:(BOOL)isHideOutBackImg isHideLeftView:(BOOL)isHideLeftView;
-(void)customBackGround:(UIImageView *)imgV;
-(void)beginSearch:(NSDictionary *)d/*要搜索的内容及tbv*/;
#pragma mark-重置所有section的数据源并刷新所有section的key
-(BOOL)cancelSearch;
-(void)initShadeBt;
-(void)initCancelBt:(UIImage *)normalImg HighlightedImg:(UIImage *)HighlightedImg;
-(void)releaseCancelBt;
-(void)releaseShadeBt;

@end
