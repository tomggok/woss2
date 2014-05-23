//
//  DYBClassMemberViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBCallView.h"


//班级成员
@interface DYBClassMemberViewController : DYBBaseViewController
{
//    MagicUITableView *_tbv;
    NSMutableArray *_muA_data;
    MagicUISearchBar *_search;
    DYBCallView *_v_call;//打电话view
}

@property (nonatomic,copy) NSString *str_classID;

@end
