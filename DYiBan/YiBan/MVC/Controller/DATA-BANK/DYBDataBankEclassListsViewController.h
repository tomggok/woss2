//
//  DYBDataBankEclassListsViewController.h
//  DYiBan
//
//  Created by tom zeng on 13-9-3.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBDataBankListCell.h"
@interface DYBDataBankEclassListsViewController : DYBBaseViewController
@property (nonatomic,retain)NSString *docAddr;
@property (nonatomic,retain)NSDictionary *dictInfo;
@property (nonatomic,retain)DYBDataBankListCell *cellDetail;
@property (nonatomic,retain)DYBDataBankListCell *cellDetailSearch;
AS_SIGNAL(RIGHTSIGNAL)
@end
