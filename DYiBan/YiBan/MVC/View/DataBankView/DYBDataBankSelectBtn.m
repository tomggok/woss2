//
//  DYBDataBankSelectBtn.m
//  DYiBan
//
//  Created by tom zeng on 13-9-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankSelectBtn.h"
#import "Magic_UIButton.h"
#import "DYBDtaBankSearchView.h"



#define  DISTANCE_RIGHT 25

@implementation DYBDataBankSelectBtn{
    
    MagicUIButton *allBtn[5];
    MagicUIButton *goodBtn[4];
    
    
    BOOL _isSysFolder;

}

@synthesize showType = _showType,targetCell = _targetCell,sendMegTarget = _sendMegTarget;
@synthesize bFolder = _bFolder,touchCellIndexPath = _touchCellIndexPath;
@synthesize beginOrPause = _beginOrPause,bUserSelfFile = _bUserSelfFile;


DEF_SIGNAL(TOUCHBTN)
DEF_SIGNAL(TOUCHSIGLEBTN)

- (void)dealloc
{
    RELEASEOBJ(_touchCellIndexPath);
    RELEASEOBJ(_targetCell);
    
//    RELEASEOBJ(_sendMegTarget);
//    [_sendMegTarget release];
//    _sendMegTarget = nil;
    
    [super dealloc];
}

- (void)setTouchCellIndexPath:(NSIndexPath *)touchCellIndexPath
{
    [_touchCellIndexPath release];
    _touchCellIndexPath = [touchCellIndexPath retain];
}

-(id)initTarget:(id)target index:(NSIndexPath *)index{
    
    self = [super init];
    if (self) {
        _sendMegTarget = target;
        self.touchCellIndexPath = index;
        
    }
    return self;

}
-(UITableViewCell *)addBtnToCell:(UITableViewCell *)view type:(int)type{

    
     _showType = type;
    
    if (type == SYSTEMFOLDER) { //判断系统文件
        _isSysFolder = YES;
        _showType = 0;
    }else{
    
        _isSysFolder = NO;
    }
    self.targetCell = view;
   
    [self setupSideSwipeView];

    return _targetCell;

}
- (void)setupSideSwipeView
{
    
    
    switch (_showType) {
            
        case 0:
        {
            if (_bFolder) {
                [self creatFolderBtn];
            }else{
                [self creatAllBtn];
            }
        }
            break;
        case 1:
        {
           [self creatShareANDDELBtn];
                     
        }
            break;
        case 2:
        {
            [self creratShareBtn];
            
        }
            break;
        case 3:
        {
            [self creatGoodBtn];
            
        }
            break;
        case 4:
        {
            
            
             [self creatDELBtn];
             break;
        }
        case 5:
        {
            
            [self creatProgressBtn];
        }
            break;
            
        default:
            break;
    }
    
   
     
}

-(void)creatFolderBtn{
    
    id target = nil;
    if ([_sendMegTarget isKindOfClass:[DYBDtaBankSearchView class]]) {
        target = [DYBDtaBankSearchView class];
    }
    else{
        target = [DYBDataBankSelectBtn class];
        
    }
    
    MagicUIButton *shareBtn = [MagicUIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTag:BTNTAG_RENAME];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"file_rename_def"] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"file_rename_dis"] forState:UIControlStateDisabled];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:shareBtn,@"btn",[NSNumber numberWithInt:_touchCellIndexPath.row],@"row", nil];
    
    [shareBtn addSignal:[target TOUCHSIGLEBTN]  forControlEvents:UIControlEventTouchUpInside object:dict];
    [shareBtn setFrame:CGRectMake(80, (84 - CELL_BTN_HIGHT)/2, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
    [_targetCell addSubview:shareBtn];
    
    MagicUIButton *delBtn = [MagicUIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setTag:BTNTAG_DEL];
    [delBtn setBackgroundImage:[UIImage imageNamed:@"file_del_def"] forState:UIControlStateNormal];
    
    NSDictionary *dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:delBtn,@"btn",[NSNumber numberWithInt:_touchCellIndexPath.row],@"row", nil];
    
    [delBtn addSignal:[target TOUCHSIGLEBTN] forControlEvents:UIControlEventTouchUpInside object:dict1];
    [delBtn setFrame:CGRectMake((500 - CELL_BTN_WIDTH)/2, (84 - CELL_BTN_HIGHT)/2 , CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [delBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
    [_targetCell addSubview:delBtn];
    //    RELEASE(delBtn);
    RELEASE(dict1)
    RELEASE(dict);

    

}


-(void)creatAllBtn{
    
    for (int i = 0; i < 5; i++) {
       
        allBtn[i] = [MagicUIButton buttonWithType:UIButtonTypeCustom];
        [allBtn[i] setTag:BTNTAG_SHARE + i];
        MagicUIButton *btn = allBtn[i];
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:allBtn[i],@"btn",[NSNumber numberWithInt:_touchCellIndexPath.row],@"row", nil];
        
        id target = nil;
        if ([_sendMegTarget isKindOfClass:[DYBDtaBankSearchView class]]) {
            target = [DYBDtaBankSearchView class];
        }
        else{
            target = [DYBDataBankSelectBtn class];
        
        }
        [btn addSignal:[target TOUCHSIGLEBTN] forControlEvents:UIControlEventTouchUpInside object:dict];
        [allBtn[i] setFrame:CGRectMake(DISTANCE_RIGHT + i*(CELL_BTN_WIDTH + 8), (84 - CELL_BTN_HIGHT)/2, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
        
        switch (i) {
            case 0:{
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_share_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_share_dis"] forState:UIControlStateDisabled];
                [allBtn[i] setEnabled:!_bFolder];
            }
                break;
            case 1:
            {
                
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_move_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_move_dis"] forState:UIControlStateDisabled];

                [ allBtn[i] setEnabled:!_bFolder];
                
            }
                
                break;
            case 2:
            {
                
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_rename_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_rename_dis"] forState:UIControlStateDisabled];
                [allBtn[i] setEnabled:!_isSysFolder];
                
            }
                
                break;
            case 3:
            {
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_offline_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_offline_dis"] forState:UIControlStateDisabled];
                [allBtn[i] setEnabled:!_bFolder];
            }
                
                break;
            case 4:
            {
                
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_del_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_del_def"] forState:UIControlStateDisabled];
                [allBtn[i] setEnabled:!_isSysFolder];
            }
                break;
                
            default:
                break;
        }
        
        [_targetCell addSubview: allBtn[i]];
        RELEASE(allBtn[i]);
    }
}

-(void)forbidTouch{
    
    for (int i = 1; i <= 4 ; i++) {
        
        [allBtn[i] setSelected:NO];
    }
    
}

-(void)creratShareBtn{ //转存
    MagicUIButton *shareBtn = [MagicUIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTag:BTNTAG_CHANGE];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"file_resave_def"] forState:UIControlStateNormal];
    
     NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:shareBtn,@"btn",[NSNumber numberWithInt:_touchCellIndexPath.row],@"row", nil];

    id target = nil;
    if ([_sendMegTarget isKindOfClass:[DYBDtaBankSearchView class]]) {
        target = [DYBDtaBankSearchView class];
    }
    else{
        target = [DYBDataBankSelectBtn class];
        
    }
    
    [shareBtn addSignal:[target TOUCHSIGLEBTN]  forControlEvents:UIControlEventTouchUpInside object:dict];
    RELEASE(dict);
    [shareBtn setFrame:CGRectMake((320 - DISTANCE_RIGHT - CELL_BTN_WIDTH)/2 + DISTANCE_RIGHT, (84 - CELL_BTN_HIGHT)/2  , CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
    [_targetCell addSubview:shareBtn];
}

-(void)creatDELBtn{
    
    MagicUIButton *shareBtn = [MagicUIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTag:BTNTAG_DEL];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"file_del_def"] forState:UIControlStateNormal];
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:shareBtn,@"btn",[NSNumber numberWithInt:_touchCellIndexPath.row],@"row", nil];
    
    [shareBtn addSignal:[DYBDataBankSelectBtn TOUCHSIGLEBTN] forControlEvents:UIControlEventTouchUpInside object:dict];
    [shareBtn setBackgroundColor:[UIColor clearColor]];
    [shareBtn setFrame:CGRectMake((320 - DISTANCE_RIGHT - CELL_BTN_WIDTH)/2 + DISTANCE_RIGHT, (84 - CELL_BTN_HIGHT)/2  , CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];

    [_targetCell addSubview:shareBtn];
    RELEASE(dict);
}


-(void)creatShareANDDELBtn{
    
    id target = nil;
    if ([_sendMegTarget isKindOfClass:[DYBDtaBankSearchView class]]) {
        target = [DYBDtaBankSearchView class];
    }
    else{
        target = [DYBDataBankSelectBtn class];
        
    }
    
    MagicUIButton *shareBtn = [MagicUIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTag:BTNTAG_SHARE];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"file_editshare_def"] forState:UIControlStateNormal];

    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:shareBtn,@"btn",[NSNumber numberWithInt:_touchCellIndexPath.row],@"row", nil];
    
    [shareBtn addSignal:[target TOUCHSIGLEBTN]  forControlEvents:UIControlEventTouchUpInside object:dict];
    [shareBtn setFrame:CGRectMake(80, (84 - CELL_BTN_HIGHT)/2, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
    [_targetCell addSubview:shareBtn];
    
    MagicUIButton *delBtn = [MagicUIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setTag:BTNTAG_CANCELSHARE];
    [delBtn setBackgroundImage:[UIImage imageNamed:@"file_cancelshare_def"] forState:UIControlStateNormal];

    NSDictionary *dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:delBtn,@"btn",[NSNumber numberWithInt:_touchCellIndexPath.row],@"row", nil];
    
    [delBtn addSignal:[target TOUCHSIGLEBTN] forControlEvents:UIControlEventTouchUpInside object:dict1];
    [delBtn setFrame:CGRectMake((500 - CELL_BTN_WIDTH)/2, (84 - CELL_BTN_HIGHT)/2 , CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [delBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
    [_targetCell addSubview:delBtn];
//    RELEASE(delBtn);
    RELEASE(dict1)
    RELEASE(dict);
}

//重新设置bt的object
- (void)resetBtRow
{
    for (int i = 0; i < 3; i++)
    {
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:allBtn[i],@"btn",[NSNumber numberWithInt:_touchCellIndexPath.row],@"row",_targetCell,@"cell", nil];
        [allBtn[i] addSignal:[DYBDataBankSelectBtn TOUCHSIGLEBTN] forControlEvents:UIControlEventTouchUpInside object:dict];
        RELEASE(dict);
    }
}

-(void)creatProgressBtn{
    
    for (int i = 0; i < 3; i++) {
        allBtn[i] = [MagicUIButton buttonWithType:UIButtonTypeCustom];
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:allBtn[i],@"btn",[NSNumber numberWithInt:_touchCellIndexPath.row],@"row",_targetCell,@"cell", nil];
        
        [allBtn[i] addSignal:[DYBDataBankSelectBtn TOUCHSIGLEBTN] forControlEvents:UIControlEventTouchUpInside object:dict];
        RELEASE(dict);
        
        [allBtn[i] setFrame:CGRectMake(70 + i*CELL_BTN_WIDTH*1.6, (84 - CELL_BTN_HIGHT)/2, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
        [allBtn[i] setTag:BTNTAG_SHARE + i];
        
        [_targetCell addSubview: allBtn[i]];
        RELEASE(allBtn[i]);
        
        switch (i) {
            case 0:{
                if (!_beginOrPause)
                {
                
                //暂停
                
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_pause_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
                    
                MagicUIButton *ReStartDown = [[MagicUIButton alloc]initWithFrame:CGRectMake(70 + 0*CELL_BTN_WIDTH*1.5, (84 - CELL_BTN_HIGHT)/2, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
                NSDictionary *dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:ReStartDown,@"btn",[NSNumber numberWithInt:_touchCellIndexPath.row],@"row",_targetCell,@"cell", nil];
                [ReStartDown setBackgroundImage:[UIImage imageNamed:@"file_start_def"] forState:UIControlStateNormal];
                [ReStartDown setBackgroundImage:[UIImage imageNamed:@"file_start_def"] forState:UIControlStateDisabled];
                [ReStartDown addSignal:[DYBDataBankSelectBtn TOUCHSIGLEBTN] forControlEvents:UIControlEventTouchUpInside object:dict1];
                RELEASE(dict1)
                [ReStartDown setHidden:YES];
                [ReStartDown setTag:BTNTAG_RESTART];
                [_targetCell addSubview:ReStartDown];
                RELEASE(ReStartDown);
                
                }else{
                
                //开始下载
                
                    [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_start_def"] forState:UIControlStateNormal];
                    [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_start_def"] forState:UIControlStateDisabled];
                    [allBtn[i] setTag:BTNTAG_RESTART];
                    [allBtn[i] setHidden:NO];
                    
                    MagicUIButton *ReStartDown = [[MagicUIButton alloc]initWithFrame:CGRectMake(70 + 0*CELL_BTN_WIDTH*1.5, (84 - CELL_BTN_HIGHT)/2, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
                    NSDictionary *dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:ReStartDown,@"btn",[NSNumber numberWithInt:_touchCellIndexPath.row],@"row",_targetCell,@"cell", nil];
                    [ReStartDown setBackgroundImage:[UIImage imageNamed:@"file_pause_def"] forState:UIControlStateNormal];
                    [ReStartDown setBackgroundImage:[UIImage imageNamed:@"file_pause_def"] forState:UIControlStateDisabled];
                    [ReStartDown addSignal:[DYBDataBankSelectBtn TOUCHSIGLEBTN] forControlEvents:UIControlEventTouchUpInside object:dict1];
                    RELEASE(dict1)
                    [ReStartDown setHidden:YES];
                    [ReStartDown setTag:(BTNTAG_SHARE + i)];
                    [_targetCell addSubview:ReStartDown];
                    RELEASE(ReStartDown);
                }

            }
                break;
            case 1:
            {
                
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_restart_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_restart_def"] forState:UIControlStateDisabled];
            
            }
                
                break;
            case 2:
            {
                
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_del_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_del_def"] forState:UIControlStateDisabled];
    
            }
                
                break;
            
                
            default:
                break;
        }
        
        
    }    
}


-(void)creatGoodBtn{
    
    for (int i = 0; i < 4; i++) {
        allBtn[i] = [MagicUIButton buttonWithType:UIButtonTypeCustom];

        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:allBtn[i],@"btn",[NSNumber numberWithInt:_touchCellIndexPath.row],@"row", nil];
        
        id target = nil;
        if ([_sendMegTarget isKindOfClass:[DYBDtaBankSearchView class]]) {
            target = [DYBDtaBankSearchView class];
        }
        else{
            target = [DYBDataBankSelectBtn class];
            
        }
        
        [allBtn[i] addSignal:[target TOUCHSIGLEBTN]  forControlEvents:UIControlEventTouchUpInside object:dict];
        
        RELEASE(dict);
        [allBtn[i] setFrame:CGRectMake(50 + i*CELL_BTN_WIDTH*1.3, (84 - CELL_BTN_HIGHT)/2, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
        
        switch (i) {
            case 0:{
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_resave_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_resave_dis"] forState:UIControlStateDisabled];
                [allBtn[i] setTag:BTNTAG_CHANGE];
                [allBtn[i] setEnabled:!_bUserSelfFile]; //yes 
            }
                break;
            case 1:
            {
                [allBtn[i] setTag:BTNTAG_GOOD];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_ding_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_ding_dis"] forState:UIControlStateDisabled];
            }
                
                break;
            case 2:
            {
                [allBtn[i] setTag:BTNTAG_BAD];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_cai_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_cai_dis"] forState:UIControlStateDisabled];
                
            }
                
                break;
            case 3:
            {
                [allBtn[i] setTag:BTNTAG_REPORT];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_report_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_report_def"] forState:UIControlStateDisabled];
            }
                
                break;
           
                
            default:
                break;
        }
        
        [_targetCell addSubview: allBtn[i]];
        RELEASE(allBtn[i]);
    }
}



@end
