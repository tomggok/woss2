//
//  DYBDataBankDownloadManageViewController.h
//  DYiBan
//
//  Created by tom zeng on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBDataBankListCell.h"
@interface DYBDataBankDownloadManageViewController : DYBBaseViewController<UIScrollViewAccessibilityDelegate,UIScrollViewDelegate>{
    
    //    id<DataBankListDelegate>delegate;
    
}
@property (nonatomic, retain)NSObject *sender;
@property (nonatomic, assign)MagicViewController *tabbarView;
@property (nonatomic, retain)NSMutableDictionary *dictCellDown;
@property (nonatomic, retain)DYBDataBankListCell *cellDown;
//@property (nonatomic, copy)NSDictionary *dictInsetInfo;
//@property (nonatomic, retain)NSString *strDownloadURL;

//@property(nonatomic,assign)id<DataBankListDelegate>delegate;
//@property(nonatomic,retain)UIImage *imageFuzzy;


+(DYBDataBankDownloadManageViewController *)shareDownLoadInstance;
-(void)insertCell:(NSDictionary *)dict;


AS_SIGNAL(SWITCHDYBAMICBUTTON)
AS_SIGNAL(SHOWCHOOSE)
AS_SIGNAL(MENUSELECT)
@end
