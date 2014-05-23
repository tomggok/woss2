//
//  UITableViewCell+MagicCategory.h
//  DYiBan
//
//  Created by zhangchao on 13-8-27.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (MagicCategory)

@property (nonatomic,assign) NSIndexPath *index;//当前cell的下标
@property (nonatomic,assign) int i_type;//展示不同数据源类型
@property (nonatomic,assign) UITableView *tbv;//所在tbv
@property (nonatomic,assign) MagicJSONReflection *model;//对应的数据源模型

//恢复正常视图布局(比如关闭左划展开的cell)
-(void)resetContentView;
@end
