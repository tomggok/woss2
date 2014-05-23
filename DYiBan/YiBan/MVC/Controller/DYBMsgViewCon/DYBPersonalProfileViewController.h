//
//  DYBPersonalProfileViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "college_list_all.h"
@class user;
@class PagePickerModel;
//个人资料
@interface DYBPersonalProfileViewController : DYBBaseViewController
{
//    MagicUITableView *_tbv;
    PagePickerModel *_pickerModel;
    college_list_all *collegeList;
    MagicUITextField *nickTextField;
}
@property (nonatomic, assign)PagePickerModel *pickerModel;
@property (nonatomic,assign) user *model;
- (void)changPhone:(NSString *)phoneNum;
@end
