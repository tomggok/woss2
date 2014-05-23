//
//  DYBMyNotesViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-10-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBMenuView.h"
#import "DYBVariableTbvView.h"
#import "DYBPagePickerView.h"

//我的笔记页
@interface DYBMyNotesViewController : DYBBaseViewController <PagePickDelegate>
{
    MagicUISearchBar *_search;
    MagicUIButton *_bt_DropDown/*下拉按钮*/,*_bt_creatNote/*新建笔记*/,*_bt_date/*选日期*/;
    DYBMenuView *_tbv_dropDown;//下拉列表
    DYBVariableTbvView *_tbvView;//封装的公用tbv
//    NSMutableArray *_muA_AllNoteData/*所有笔记数据源*/,*_muA_favoriteNoteData/*星标笔记数据源*/;
//    NSIndexPath *_indexAfterRequest;//
    DYBPagePickerView *_pickerView;//
    int delnum;//删除的数量  （每次第一次打开 整体刷新 notes_list的页面的 时候 重置delnum为0，每在列表中动态删除一条笔记的时候，这个数字就+1，以此参数 避免 删除后 翻页漏数据的bug， ps: 可传0或者不传)
    
//    MagicUIImageView *_imgV_noDataTip;//无数据提示
//    MagicUILabel *_lb_noDataTip;//无数据提示
}

@property (nonatomic,assign) BOOL isGotoNewDote/*是否直接跳转到创建新笔记页*/;

@end
