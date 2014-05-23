//
//  DYBDataBankShareEnterView.h
//  DYiBan
//
//  Created by tom zeng on 13-9-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//
#import "UIView+MagicCategory.h"
#import "DYBBaseView.h"
#import "DYBBaseViewController.h"
#import "DYBDataBankListCell.h"
@interface DYBDataBankShareEnterView : UIView


@property(nonatomic,assign) NSUInteger indexRow;
@property(nonatomic,retain) NSDictionary *dictFileInfo;
@property(nonatomic,retain) NSMutableArray *arrayInfo;

@property(nonatomic,retain) DYBDataBankListCell *cellDetail; //列表页面的cell
@property(nonatomic,retain) DYBDataBankListCell *cellDetailSearch; //搜索页面的cell
@property(nonatomic,retain) DYBBaseViewController *targetObj;

- (id)initWithFrame:(CGRect)frame target:(id)target info:(NSDictionary *)info arrayFolderList:(NSMutableArray *)array index:(NSUInteger)row;

@end
