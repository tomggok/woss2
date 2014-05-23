//
//  DYBDataBankChildrenListViewController.h
//  DYiBan
//
//  Created by tom zeng on 13-8-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//


#import "DYBDtaBankSearchView.h"
#import "DYBHttpMethod.h"
#import "DYBDataBankListCell.h"
#import "DYBSideSwipeTableViewCell.h"
#import "DYBDataBankListCell.h"
#import "DYBBaseViewController.h"

@interface DYBDataBankChildrenListViewController : DYBBaseViewController

@property (nonatomic,retain) NSString *folderID;
@property (nonatomic,retain) NSString *strTitle;
@property (nonatomic,assign) BOOL bChangeFolder;
@property (nonatomic,retain) NSString *strFromDir;
@property (nonatomic,retain) NSString *current_dir;
@property (nonatomic,retain) NSString *currentFile;
@property (nonatomic,assign) BOOL bChangeSave;
@property (nonatomic,retain) NSDictionary *dictInfo;
@property (nonatomic,retain) NSString *strChangeType;
@property (nonatomic,retain) id popController;
@property (nonatomic,retain) NSDictionary *dictChangeSave;
@property (nonatomic,retain) NSDictionary *dicFromInfo;
@property (nonatomic,assign) int iInfoID;
 
AS_SIGNAL(ADDFOLDER)
AS_SIGNAL(REFRESH)
AS_SIGNAL(SUCCESSCHANGEFOLDER)
@end
