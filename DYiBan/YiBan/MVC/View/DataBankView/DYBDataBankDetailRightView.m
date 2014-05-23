//
//  DYBDataBankDetailRightView.m
//  DYiBan
//
//  Created by tom zeng on 13-11-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//
#import "DYBDataBankFileDetailViewController.h"




#import "DYBDataBankDetailRightView.h"


@implementation DYBDataBankDetailRightView
@synthesize dictFileInfo = _dictFileInfo,viewRight = _viewRight;


-(void)creatBTNMyShare:(UIView *)BGview{
    
    MagicUIButton *btnShare = [[MagicUIButton alloc]initWithFrame:CGRectMake(20.0f, 30.0f, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [btnShare setTag:BTNTAG_EDITSHARE];
    [btnShare addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnShare];
    [btnShare setBackgroundColor:[UIColor clearColor]];
    [btnShare setImage:[UIImage imageNamed:@"file_editshare_def"] forState:UIControlStateNormal];
    [BGview addSubview:btnShare];
    
    RELEASE(btnShare);
    
    MagicUIButton *btnZhuan = [[MagicUIButton alloc]initWithFrame:CGRectMake(132.0f, 30, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [btnZhuan setTag:BTNTAG_CANCELSHARE];
    [btnZhuan addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnZhuan];
    [btnZhuan setImage:[UIImage imageNamed:@"file_cancelshare_def"] forState:UIControlStateNormal];
    [BGview addSubview:btnZhuan];
    RELEASE(btnZhuan);
    
    NSString *strType = [[_dictFileInfo objectForKey:@"type"]lowercaseString];
    if ([strType isEqualToString:@"png"] ||[strType isEqualToString:@"jpg"]||[strType isEqualToString:@"bmp"]||[strType isEqualToString:@"gif"]) {
        
        MagicUIButton *btnRename = [[MagicUIButton alloc]initWithFrame:CGRectMake(244, 30, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
        [btnRename setTag:BTNTAG_SINGLE];
        [btnRename addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnRename];
        [btnRename setImage:[UIImage imageNamed:@"file_save_def.png"] forState:UIControlStateNormal];
        [BGview addSubview:btnRename];
        RELEASE(btnRename);
        
    }
}

-(void)creatBTNShareSomethingForMe:(UIView *)BGview{
    
    
    NSString *strType = [[_dictFileInfo objectForKey:@"type"]lowercaseString];
    if ([strType isEqualToString:@"png"] ||[strType isEqualToString:@"jpg"]||[strType isEqualToString:@"bmp"]||[strType isEqualToString:@"gif"]) {
        
        MagicUIButton *btnDown = [[MagicUIButton alloc]initWithFrame:CGRectMake(20.0f, 30.0f, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
        [btnDown addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnDown];
        [btnDown setTag:BTNTAG_SINGLE];
        [btnDown setImage:[UIImage imageNamed:@"file_save_def.png"] forState:UIControlStateNormal];
        [BGview addSubview:btnDown];
        RELEASE(btnDown);
        
    }
    
    
    MagicUIButton *btnZhuan = [[MagicUIButton alloc]initWithFrame:CGRectMake(132.0f, 30, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [btnZhuan setTag:BTNTAG_CHANGESAVE];
    [btnZhuan addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnZhuan];
    [btnZhuan setImage:[UIImage imageNamed:@"file_resave_def"] forState:UIControlStateNormal];
    [BGview addSubview:btnZhuan];
    RELEASE(btnZhuan);
    
}



-(void)creatBTNPublicSomething:(UIView *)BGview{
    
    MagicUIButton *btnShare = [[MagicUIButton alloc]initWithFrame:CGRectMake(20.0f, 30.0f, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [btnShare setTag:BTNTAG_GOOD];
    [btnShare addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnShare];
    [btnShare setBackgroundColor:[UIColor clearColor]];
    [btnShare setImage:[UIImage imageNamed:@"file_ding_def"] forState:UIControlStateNormal];
    [btnShare setImage:[UIImage imageNamed:@"file_ding_dis"] forState:UIControlStateDisabled];
    
    BOOL bGood = [[_dictFileInfo objectForKey:@"is_estimate_up"]boolValue];
    [btnShare setEnabled:!bGood];
    [BGview addSubview:btnShare];
    
    RELEASE(btnShare);
    
    MagicUIButton *btnZhuan = [[MagicUIButton alloc]initWithFrame:CGRectMake(132.0f, 30, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [btnZhuan setTag:BTNTAG_BAD];
    [btnZhuan addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnZhuan];
    [btnZhuan setImage:[UIImage imageNamed:@"file_cai_def"] forState:UIControlStateNormal];
    [btnZhuan setImage:[UIImage imageNamed:@"file_cai_dis"] forState:UIControlStateDisabled];
    [BGview addSubview:btnZhuan];
    RELEASE(btnZhuan);
    
    BOOL bcai = [[_dictFileInfo objectForKey:@"is_estimate_down"] boolValue];
    [btnZhuan setEnabled:!bcai];
    
    
    MagicUIButton *btnRename = [[MagicUIButton alloc]initWithFrame:CGRectMake(244, 30, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [btnRename setTag:BTNTAG_REPORT];
    [btnRename addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnRename];
    [btnRename setImage:[UIImage imageNamed:@"file_report_def"] forState:UIControlStateNormal];
    [btnRename setImage:[UIImage imageNamed:@"file_report_def"] forState:UIControlStateDisabled];
    [BGview addSubview:btnRename];
    RELEASE(btnRename);
    
    UIView *viewRight = _viewRight;
    [viewRight setFrame:CGRectMake(0.0f, -190 + 44, 320.0F, 115)];
    
    NSString *strType = [[_dictFileInfo objectForKey:@"type"]lowercaseString];
    if ([strType isEqualToString:@"png"] ||[strType isEqualToString:@"jpg"]||[strType isEqualToString:@"bmp"]||[strType isEqualToString:@"gif"]) {
        
        MagicUIButton *btnDown = [[MagicUIButton alloc]initWithFrame:CGRectMake(20.0f, 100, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
        [btnDown addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnDown];
        [btnDown setTag:BTNTAG_SINGLE];
        [btnDown setImage:[UIImage imageNamed:@"file_save_def.png"] forState:UIControlStateNormal];
        [BGview addSubview:btnDown];
        RELEASE(btnDown);
        
        [viewRight setFrame:CGRectMake(0.0f, -190 + 44, 320.0F, 190)];
        
    }
}

-(void)creatBTNCommentView:(UIView *)view{

    BOOL iPublic = [[_dictFileInfo objectForKey:@"is_public"] boolValue];
    
    MagicUIButton *btnShare = [[MagicUIButton alloc]initWithFrame:CGRectMake(20.0f, 30.0f, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [btnShare setTag:BTNTAG_SHARE];
    [btnShare addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnShare];
    [btnShare setBackgroundColor:[UIColor clearColor]];
    [btnShare setImage:[UIImage imageNamed:@"file_share_def"] forState:UIControlStateNormal];
    [btnShare setImage:[UIImage imageNamed:@"file_share_dis"] forState:UIControlStateDisabled];
    [btnShare setEnabled:!iPublic];
    [view addSubview:btnShare];
    
    RELEASE(btnShare);
    
    MagicUIButton *btnZhuan = [[MagicUIButton alloc]initWithFrame:CGRectMake(132.0f, 30, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [btnZhuan setTag:BTNTAG_CHANGE];
    [btnZhuan addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnZhuan];
    [btnZhuan setImage:[UIImage imageNamed:@"file_move_def"] forState:UIControlStateNormal];
    [btnZhuan setImage:[UIImage imageNamed:@"file_move_dis"] forState:UIControlStateDisabled];
    [btnZhuan setEnabled:!iPublic];
    [view addSubview:btnZhuan];
    RELEASE(btnZhuan);
    
    MagicUIButton *btnRename = [[MagicUIButton alloc]initWithFrame:CGRectMake(244, 30, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [btnRename setTag:BTNTAG_RENAME];
    [btnRename addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnRename];
    [btnRename setImage:[UIImage imageNamed:@"file_rename_def"] forState:UIControlStateNormal];
    [btnRename setImage:[UIImage imageNamed:@"file_rename_dis"] forState:UIControlStateDisabled];
    [btnRename setEnabled:!iPublic];
    [view addSubview:btnRename];
    RELEASE(btnRename);
    
    
    MagicUIButton *btnDown = [[MagicUIButton alloc]initWithFrame:CGRectMake(20.0f, 100, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [btnDown addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnDown];
    [btnDown setTag:BTNTAG_DOWNLOAD];
    [btnDown setImage:[UIImage imageNamed:@"file_offline_def"] forState:UIControlStateNormal];
    [btnDown setImage:[UIImage imageNamed:@"file_offline_dis"] forState:UIControlStateDisabled];
    [btnDown setEnabled:!iPublic];
    [view addSubview:btnDown];
    RELEASE(btnDown);
    
    
    MagicUIButton *btnSomething = [[MagicUIButton alloc]initWithFrame:CGRectMake(244, 100.0f, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [btnSomething setTag:BTNTAG_SINGLE];
    [btnSomething addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnSomething];
    
    NSString *strType = [[_dictFileInfo objectForKey:@"type"]lowercaseString];
    if ([strType isEqualToString:@"png"] ||[strType isEqualToString:@"jpg"]||[strType isEqualToString:@"bmp"]||[strType isEqualToString:@"gif"]) {
        
        [btnSomething setImage:[UIImage imageNamed:@"file_save_def.png"] forState:UIControlStateNormal];
        [view addSubview:btnSomething];
    }else{
        
        [btnSomething setImage:[UIImage imageNamed:@"file_save_dis"] forState:UIControlStateNormal];
        [btnSomething setEnabled:NO];
    }
    
    
    RELEASE(btnSomething);
    
    MagicUIButton *btnDEL = [[MagicUIButton alloc]initWithFrame:CGRectMake(132.0f, 100.0f, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [btnDEL setTag:BTNTAG_DEL];
    [btnDEL addSignal:[DYBDataBankFileDetailViewController OPEATTIONMORE] forControlEvents:UIControlEventTouchUpInside object:btnDEL];
    [btnDEL setImage:[UIImage imageNamed:@"file_del_def"] forState:UIControlStateNormal];
    [btnDEL setImage:[UIImage imageNamed:@"file_del_dis"] forState:UIControlStateDisabled];
    [btnDEL setEnabled:!iPublic];
    [view addSubview:btnDEL];
    RELEASE(btnDEL);



}

-(void)dealloc{

    RELEASE(_dictFileInfo);
    RELEASE(_viewRight);
    [super dealloc];

}

@end
