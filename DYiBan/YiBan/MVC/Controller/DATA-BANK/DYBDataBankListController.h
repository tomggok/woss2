//
//  DYBDataBankController.h
//  DYiBan
//
//  Created by tom zeng on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "Magic_UITableView.h"
#import "DYBDtaBankSearchView.h"

   
@interface DYBDataBankListController : DYBBaseViewController<UIScrollViewAccessibilityDelegate,UIScrollViewDelegate>{


}
@property (nonatomic, retain) NSObject *sender;
@property (nonatomic, assign) MagicViewController *tabbarView;
@property (nonatomic, retain) NSMutableArray *arrayCellView;

-(id)initWithFrame:(CGRect)frame slideView:(UIView *)slideView;
+(DYBDataBankListController *)creatShareInstance;
-(void)refreshList;

AS_SIGNAL(OPERATIONTABBARHIDE)
AS_SIGNAL(OPEATTIONTABBARSHOW)
@end
