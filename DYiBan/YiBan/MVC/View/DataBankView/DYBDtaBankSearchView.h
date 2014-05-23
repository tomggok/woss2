//
//  DYBDtaBankSearchView.h
//  DYiBan
//
//  Created by tom zeng on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface DYBDtaBankSearchView : UIView<UISearchBarDelegate>
{
   
}

@property (nonatomic,retain) NSMutableArray *arrayResourcesList;
@property (nonatomic,retain) DYBUITableView *tbDataBank;
@property (nonatomic,retain) MagicUISearchBar *searchbar;
@property (nonatomic,retain) MagicViewController *VC;
@property (nonatomic,retain) UIView *slideHideView;
@property (nonatomic,retain) NSMutableArray *arrayViewCell;
@property (nonatomic,assign) int iCellType;
@property (nonatomic,assign) int iBtnType;
@property (nonatomic,assign) int iOrder;
@property (nonatomic,retain) UIButton *badBtn;
@property (nonatomic,retain) UIButton *goodBtn;
@property (nonatomic,retain) NSString *current_dir;
@property (nonatomic,retain) NSString *strTarget;

-(id)initWithFrame:(CGRect)frame slideView:(UIView *)slideView;
-(id)initWithFrame:(CGRect)frame object:(id)object;
-(void)hideKeyBoard;
-(void)initView:(CGRect)frame;

AS_SIGNAL(FIRSTTOUCH)
AS_SIGNAL(RECOVERBAR)
AS_SIGNAL(TOUCHSIGLEBTN)
AS_SIGNAL(BEGINEDITING)
AS_SIGNAL(NEWNAME)
AS_SIGNAL(DELOBJ)
AS_SIGNAL(CANCELSHARE)

@end
