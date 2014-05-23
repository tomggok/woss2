//
//  DYBDataBankFileDetailViewController.h
//  DYiBan
//
//  Created by tom zeng on 13-9-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBDataBankShareViewController.h"
//@class DYBDataBankShareViewController;

@interface DYBDataBankFileDetailViewController : DYBBaseViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,retain) NSString *strFileURL;
@property (nonatomic,retain) NSDictionary *dictFileInfo;
@property (nonatomic,retain) id targetObj;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) int iPublicType;
@property (nonatomic,retain) DYBDataBankListCell *cellOperater;
@property (nonatomic,retain) DYBDataBankListCell *cellOperaterSearch;
@property (nonatomic,retain) NSMutableArray *arraySource;

AS_SIGNAL(OPEATTIONMORE)
AS_SIGNAL(NEWNAME)
AS_SIGNAL(DELFILE)
AS_SIGNAL(CHANGEINFO)
AS_SIGNAL(CANCELSHARE)


-(void)changeShareType;

@end
