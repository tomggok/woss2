//
//  DYBPagePickerView.h
//  DYiBan
//
//  Created by Song on 13-9-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef k_tag_releaseBT
#define k_tag_releaseBT -1111 //渐变消失bt的tag
#endif

#ifndef k_tag_OKBT
#define k_tag_OKBT -1112 //确定bt的tag
#endif


typedef enum {
    PagePickerViewWithAreas = 0,//加载地区
    PagePickerViewWithDate = 1,//日期
    PagePickerViewWithCollege = 2,//学院
    PagePickerViewWithGetInSchool = 3,//进入学校年份
    
    PagePickerViewWithPageWhoCanSee = 4,//主页权限
    PagePickerViewWithBirthdayWhoCanSee = 5,//生日对谁可见
    PagePickerViewWithHometownWhoCanSee = 6,//家乡对谁可见
    PagePickerViewWithMobileWhoCansee=7,//手机对谁可见
    PagePickerViewWithNote=8//笔记日历

}PagePickerViewStyle;

//代理
@class DYBPagePickerView;
@protocol PagePickDelegate<NSObject>

@optional
- (void)pickerDidEnd:(DYBPagePickerView *)picker pagePickertype:(PagePickerViewStyle)type;
@end

@class PagePickerModel;
@class college_list_all;
@interface DYBPagePickerView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *_pickerView;
    
    PagePickerModel *_pageModel;//pickerviewModel
    
    
    BOOL isShowView;//页面是否显示
    
    //    NSString *birthday;//生日
    
}
@property (assign, nonatomic)id<PagePickDelegate>delegate;
@property (retain, nonatomic)UIPickerView *pickerView;
@property (assign, nonatomic)PagePickerViewStyle pickerStyle;
@property (retain, readonly, nonatomic)PagePickerModel *pageModel;
@property (retain, nonatomic)NSString *birthday;
@property (retain, nonatomic)college_list_all *collegeList;//学院
@property (nonatomic, assign)BOOL isShowView;//页面是否显示
//@property (nonatomic,retain) NSString *str_selectContent;//当前选择的内容
@property (nonatomic,retain) MagicUIButton *bt_Shade/*用于点开后遮罩键盘外的区域*/;
@property (nonatomic,retain) MagicUIButton *bt_Ok/*确定*/;


- (id)initWithdelegate:(CGRect)frame style:(PagePickerViewStyle)_pickerStyle delegate:(id<PagePickDelegate>)_delegate;
//显示
- (void)showInView:(UIView *)view initString:(NSString *)initString;
//消失
- (void)cancelPicker;
-(void)releaseSelf;
-(NSString *)result;

@end
