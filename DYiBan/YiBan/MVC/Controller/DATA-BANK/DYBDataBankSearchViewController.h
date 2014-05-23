//
//  DYBDataBankSearchViewController.h
//  DYiBan
//
//  Created by tom zeng on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBHttpMethod.h"
#import "DYBDataBankListCell.h"
#import "DYBSideSwipeTableViewCell.h"
#import "DYBDataBankListCell.h"
#import "Magic_UITableView.h"
#import "DYBDtaBankSearchView.h"


@interface DYBDataBankSearchViewController : DYBBaseViewController<UISearchBarDelegate>
-(void)setSearchViewFirstResponder;
@property (nonatomic,retain) NSMutableArray *arrayCellView;
AS_SIGNAL(SWITCHDYBAMICBUTTON)

+ (DYBDataBankSearchViewController *)creatShare;
@end
