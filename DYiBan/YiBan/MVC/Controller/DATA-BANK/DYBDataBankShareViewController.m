//
//  DYBDataBankShareViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankShareViewController.h"
#import "DYBDataBankChildrenListViewController.h"
#import "DYBDataBankListController.h"
#import "scrollerData.h"
#import "DYBScroller.h"
#import "DYBDataBankShotView.h"
#import "DYBDataBankShareChooseView.h"
#import "DYBDataBankSelectBtn.h"
#import "DYBDynamicViewController.h"
#import "DYBMenuView.h"
#import "DYBDataBankTopRightCornerView.h"
#import "DYBHttpMethod.h"
#import "DYBSelectContactViewController.h"
#import "DYBDataBankEclassListsViewController.h"
#import "UITableView+property.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "UIView+MagicCategory.h"
#import "DYBDataBankShareEnterView.h"
#import "DYBSignViewController.h"
#import "DYBDataBankFileDetailViewController.h"
#import "DYBGuideView.h"

#define BARVIEWTAG   78
#define OPEARTIONTAG 999
#define RIGHTVIEWTAG 89
#define NORESULTVIEW 1000 

@interface DYBDataBankShareViewController (){

    MagicUITableView *tbDataBank;
    DYBDtaBankSearchView *searchView;

   
    int page;
    int num;
    int iRihgt;
    int goodRow;
    int badRow;
    int iRequestType; //共享切换的标记 0，我的共享，1共享给我，2公共
    BOOL bPullDown;
    int cancelShareIndex;
    
    NSString *strTarget;
    NSMutableArray *arrayCellView;
    NSMutableArray *arrayFolderList;
    
    MagicUIButton *chooseBtn[4];
    DYBMenuView *_tabMenu;
    DYBDataBankTopRightCornerView *rightView;

}

@end

@implementation DYBDataBankShareViewController

@synthesize imageFuzzy,showType = _showType,goodBtn = _goodBtn,badBtn = _badBtn;

DEF_SIGNAL(SWITCHDYBAMICBUTTON)
DEF_SIGNAL(MENUSELECT)
DEF_SIGNAL(CHOOSE)
DEF_SIGNAL(SHOWCHOOSE)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(float)getWidth:(int)index{

    switch (index) {
            
        case 0:
            return 0;
            break;
        case 1:
            return 168;
            break;
        case 2:
            return 168/2 + 152/2;

            break;
        case 3:
             return 168/2 + 152;
            break;
            DLogInfo(@"");
        default:
            break;
    }

    return 0;

}

-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
   
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]]) {
        
        [self setButtonImage:self.rightButton setImage:@"btn_sequence_def.png" setHighString:@"btn_sequence_hlt"] ;
    }
    
    if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        page = 1;
        num = 20;
        iRihgt = 1;
        goodRow = 0;
        badRow = 0;
        iRequestType = 0;
        cancelShareIndex = 0;
//        target：共享目标（U、好友；C、班级；D、学院；S、学校）大小写均可
        strTarget = [[NSString alloc]initWithString:@"U"];
        
        MagicRequest *request = [DYBHttpMethod share_formelist_target:strTarget order:@"1" num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@"" asc:@"2"  isAlert:NO receive:self];
        [request setTag:REQUESTTAG_FIRIST];

        self.showType = SomeoneShowToME;
        
        [self.view setBackgroundColor:[UIColor clearColor]];
        bPullDown = NO;
       
        // 滑动页面
        UIView *viewTopBar  = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH + 114/2)];
        
        [viewTopBar setTag:BARVIEWTAG];
        [viewTopBar setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:viewTopBar];
        RELEASE(viewTopBar);
        

        searchView = [[DYBDtaBankSearchView alloc]initWithFrame:CGRectMake(0.0f, .0f, 320.0f, SEARCHBAT_HIGH)];
        [searchView initView:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH) ];
        [viewTopBar addSubview:searchView];
        [searchView release];
        [searchView setBackgroundColor:[UIColor clearColor]];
        
        //分段button
        for (int i = 0; i <2 ; i++) {
                    
            UIImage *im = [UIImage imageNamed:@"2tabs_left_def"];
            
            chooseBtn[i] = [[MagicUIButton alloc]initWithFrame:CGRectMake(im.size.width/2 *i, searchView.frame.origin.y + searchView.frame.size.height , im.size.width/2, im.size.height/2)];
            [chooseBtn[i] setTag:i+1];
            [chooseBtn[i] addSignal:[DYBDataBankShareViewController CHOOSE] forControlEvents:UIControlEventTouchUpInside object:chooseBtn[i]];
            [viewTopBar addSubview:chooseBtn[i]];
            RELEASE(chooseBtn[i]);
            
            [chooseBtn[i] setBackgroundColor:[UIColor clearColor]];
            
            UILabel *labelBtnName = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f,CGRectGetWidth(chooseBtn[i].frame) , 114/2)];
            [labelBtnName setTextAlignment:NSTextAlignmentCenter];
            [labelBtnName setTag:88];
            [labelBtnName setBackgroundColor:[UIColor clearColor]];
            [chooseBtn[i] addSubview:labelBtnName];
            RELEASE(labelBtnName);
            chooseBtn[i].showsTouchWhenHighlighted=YES;
            
            switch (i+1) {
                case 1:{
                    [chooseBtn[i] setImage:[UIImage imageNamed:@"2tabs_left_def"] forState:UIControlStateNormal];
                    [chooseBtn[i] setImage:[UIImage imageNamed:@"2tabs_left_sel"] forState:UIControlStateSelected];
                    [chooseBtn[i] setSelected:YES];
                    
                    [labelBtnName setText:@"好友"];
                    [labelBtnName setTextColor:[UIColor whiteColor]];
                    
                }
                    break;
                case 2:{
                    [chooseBtn[i] setImage:[UIImage imageNamed:@"2tabs_right_def"] forState:UIControlStateNormal];
                    [chooseBtn[i] setImage:[UIImage imageNamed:@"2tabs_right_sel"] forState:UIControlStateSelected];
                    [chooseBtn[i] setSelected:NO];
                    [labelBtnName setText:@"班级"];
                    [labelBtnName setTextColor:ColorBlue];
                }
                    break;
                case 3:{
                    [chooseBtn[i] setImage:[UIImage imageNamed:@"4tabs_3_def"] forState:UIControlStateNormal];
                    [chooseBtn[i] setImage:[UIImage imageNamed:@"4tabs_3_sel"] forState:UIControlStateSelected];
                    [chooseBtn[i] setSelected:NO];
                    [labelBtnName setText:@"学院"];
                    [labelBtnName setTextColor:ColorBlue];
                }
                    break;
                case 4:{
                    [chooseBtn[i] setImage:[UIImage imageNamed:@"4tabs_4_def"] forState:UIControlStateNormal];
                    [chooseBtn[i] setImage:[UIImage imageNamed:@"4tabs_4_sel"] forState:UIControlStateSelected];
                    [chooseBtn[i] setSelected:NO];
                    [labelBtnName setText:@"学校"];
                    [labelBtnName setTextColor:ColorBlue];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        tbDataBank = [[MagicUITableView alloc]initWithFrame:CGRectMake(0.0f, viewTopBar.frame.origin.y + viewTopBar.frame.size.height , 320.0f, self.view.frame.size.height - viewTopBar.frame.origin.y - viewTopBar.frame.size.height -5)isNeedUpdate:YES];
                
        tbDataBank.v_headerVForHide = viewTopBar;
        [self.view addSubview:tbDataBank];
        tbDataBank.tableViewType = DTableViewSlime;
        [tbDataBank release];
        [tbDataBank setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [self.view bringSubviewToFront:viewTopBar];
        [viewTopBar bringSubviewToFront:searchView];
        
        arrayCellView = [[NSMutableArray alloc]init];
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        MagicUIButton *_btnSwichDybamic = [[MagicUIButton alloc] initWithFrame:CGRectMake(110, 0, 100, 44)];
        [_btnSwichDybamic addSignal:[DYBDataBankShareViewController SWITCHDYBAMICBUTTON] forControlEvents:UIControlEventTouchUpInside];
        [self.headview addSubview:_btnSwichDybamic];
        [_btnSwichDybamic setBackgroundColor:[UIColor clearColor]];
        [self.headview bringSubviewToFront:_btnSwichDybamic];
        RELEASE(_btnSwichDybamic);

        
        if ( self.showType == MEShowToSomeone) {
            
             [self.headview setTitle:@"我共享的"];
            
        }if ( self.showType == SomeoneShowToME) {
            
             [self.headview setTitle:@"共享给我"];
            
        }if ( self.showType == Commonality) {
         
             [self.headview setTitle:@"公共资源"];
        }
        
        
        [self.headview setTitleArrow];
        
    }else if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        if ( self.showType == SomeoneShowToME) {
            
            if (![[NSUserDefaults standardUserDefaults] stringForKey:@"DYBDataBankShareViewController"] || [[[NSUserDefaults standardUserDefaults] stringForKey:@"DYBDataBankShareViewController"] intValue]==0) {
                
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DYBDataBankShareViewController"];
                
                {
                    DYBGuideView *guideV=[[DYBGuideView alloc]initWithFrame:self.view.frame];
                    guideV.AddImgByName(@"databasehelp5", @"databasehelp4",nil);
                    [self.drNavigationController.view addSubview:guideV];
                    RELEASE(guideV);
                }
            }
        }
    }
}

#pragma makr -
#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        DYBUITabbarViewController *dync = [DYBUITabbarViewController sharedInstace];
        [dync scrollMainView:1];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
    
        [self hideTabMenu];
        
        UIView *view = [self.view viewWithTag:RIGHTVIEWTAG];
        if (!view) {
            
            NSArray *arrayType = [[NSArray alloc]initWithObjects:@"按时间",@"按类型",nil];
            DYBDataBankTopRightCornerView *rightV = [[DYBDataBankTopRightCornerView alloc]initWithFrame:CGRectMake(320.0f - 95, 40, 90, 99) arrayResult:arrayType target:self];
            [rightV setBackgroundColor:[UIColor clearColor]];
            
            [rightV setTag:RIGHTVIEWTAG];
            [self.view addSubview:rightV];
            RELEASE(rightV)
            RELEASE(arrayType);
            
        }else{
            
            if (view.hidden) {
                
                [view setHidden:NO];
                
            }else{
                [view setHidden:YES];
                
            }
        }
    }
}

-(BOOL)hideRightView{

    UIView *view = [self.view viewWithTag:RIGHTVIEWTAG];
    
    if (view) {
        
        if (!view.hidden) {
            
            [view setHidden:YES];
            return YES;
        }
        return NO;
    }
    return NO;
}


-(void)handleViewSignal_DYBDtaBankSearchView:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDtaBankSearchView FIRSTTOUCH]]) {
        
        DYBDtaBankSearchView *tt = (DYBDtaBankSearchView *)[signal object];
        [tt setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
        [self changeSearchBarFrame];
        
    }else if([signal is:[DYBDtaBankSearchView RECOVERBAR]]){
        
        DYBDtaBankSearchView *tt = (DYBDtaBankSearchView *)[signal object];
        [tt setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
        [self recoverSearchBar];
        
    }else if ([signal is:[DYBDtaBankSearchView BEGINEDITING]]){
        
        [self hideRightView];
        
    }
    else if ([signal is:[DYBDtaBankSearchView DELOBJ]]){
        
        NSString *url = (NSString *)[signal object];
        
        for (int i = 0; i < arrayFolderList.count ; i++) {
            
            NSDictionary *dict = [arrayFolderList objectAtIndex:i];
            
            NSString *strEncode = [dict objectForKey:@"file_urlencode"];
            if ([strEncode isEqualToString:url]) {
                
                [arrayFolderList removeObjectAtIndex:i];
                break;
            }
        }
        
        [self creatCell_type:1];
        
        
    }else if ([signal is:[DYBDtaBankSearchView NEWNAME]]){
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        NSDictionary *dictNEW = [dict objectForKey:@"dict"];
        NSString *url = [dict objectForKey:@"url"];
                
        for (int i = 0; i < arrayFolderList.count ; i++) {
            
            NSDictionary *dict = [arrayFolderList objectAtIndex:i];
            
            NSString *strEncode = [dict objectForKey:@"file_urlencode"];
            if ([strEncode isEqualToString:url]) {
                
                [arrayFolderList replaceObjectAtIndex:i withObject:dictNEW];
                break;
            }
        }
        
        [self creatCell_type:1];
        
    }else if ([signal is:[DYBDtaBankSearchView CANCELSHARE]]){
    
        NSString *url = (NSString *)[signal object];
    
        for (int i = 0; i < arrayFolderList.count ; i++) {
            
            NSDictionary *dict = [arrayFolderList objectAtIndex:i];
            
            NSString *strEncode = [dict objectForKey:@"file_urlencode"];
            if ([strEncode isEqualToString:url]) {
                [arrayFolderList removeObjectAtIndex:i];
                break;
            }
        }
        
        [self creatCell_type:1];
    
    }
}



#pragma SearchView Delegate
-(void)changeSearchBarFrame{
    
     [self hideRightView];
    
    
    UIView *barView = [self.view viewWithTag:BARVIEWTAG];
    [barView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, self.view.frame.size.height - 44)];
    
    [searchView setFrame:CGRectMake(0.0f, searchView.frame.origin.y, 320.0f, self.view.frame.size.height - 44)];
    [searchView setBackgroundColor:[UIColor clearColor]];
    [searchView.tbDataBank setFrame:CGRectMake(0.0f, SEARCHBAT_HIGH , 320.0f, searchView.frame.size.height - SEARCHBAT_HIGH)];
}

-(void)recoverSearchBar{
    
//    [self hideRightView];
    
    UIView *barView = [self.view viewWithTag:BARVIEWTAG];
    
    
    if ( self.showType == MEShowToSomeone) {
        
         [barView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH )];
        
    }if ( self.showType == SomeoneShowToME) {
        
         [barView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH + 114/2)];
        
    }if ( self.showType == Commonality) {
        
         [barView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH )];
    }
    
    [searchView setFrame:CGRectMake(0.0f, searchView.frame.origin.y, 320.0f, SEARCHBAT_HIGH)];
    [searchView setBackgroundColor:[UIColor clearColor]];
    [searchView.tbDataBank setHidden:YES];
    
}



-(NSString *)getStringTitle:(int)type{

    [arrayCellView removeAllObjects];
    [tbDataBank reloadData];
    
    [searchView hideKeyBoard];
    
    iRequestType = type;
    
    page = 1;
    
    [tbDataBank reloadData:NO];
    
    
    [tbDataBank StretchingUpOrDown:1];
    [DYBShareinstaceDelegate opeartionTabBarShow:NO];
    

    
    switch (type) {
        case 0:{
            
            [self hideButtonORNot:NO];
            
            self.showType = SomeoneShowToME;
            
            MagicRequest *request = [DYBHttpMethod share_formelist_target:@"U" order:@"1" num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@"" asc:@"2"  isAlert:YES receive:self];
            [request setTag:REQUESTTAG_FIRIST];
            return @"共享给我";
            
        }
            break;
        case 1:{
            // 去掉button
            
            iRihgt = 1;

            [self hideButtonORNot:YES];
            self.showType = MEShowToSomeone;
            MagicRequest *request = [DYBHttpMethod share_frommelist:@"1" num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@"" asc:@"2" isAlert:YES receive:self];
            [request setTag:REQUESTTAG_FIRIST];
            return @"我共享的";
        }
            break;
        case 2:{
            
            iRihgt = 1;

            [self hideButtonORNot:YES];
            self.showType = Commonality;
            MagicRequest *request = [DYBHttpMethod document_public_order:@"1" num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page]  keyword:@""  asc:@"2" isAlert:YES receive:self];
            [request setTag:REQUESTTAG_FIRIST];
            return @"公共资源";
        }
            break;
            
        default:
            break;
    }
    
    [tbDataBank StretchingUpOrDown:1];
    [DYBShareinstaceDelegate opeartionTabBarShow:NO];
    
    
    //    [tbDataBank StretchingUpOrDown:0];
    //    [DYBShareinstaceDelegate opeartionTabBarShow:YES];
    return @"共享给我";
}

-(void)hideButtonORNot:(BOOL)key{

    UIView *barView = [self.view viewWithTag:BARVIEWTAG];
    for (int i = 1; i <= 4; i++) {
        UIView *view = [barView viewWithTag:i];
        
        [view setHidden:key];
    }

    if (key) {
        
        [barView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH )];
        
    }else{
        [barView  setFrame:CGRectMake(0.0f, 44.0f, 320.0f, SEARCHBAT_HIGH + 114/2)];    
    }
    
    [tbDataBank setFrame:CGRectMake(0.0f, barView.frame.origin.y + barView.frame.size.height , 320.0f, self.view.frame.size.height - barView.frame.origin.y - barView.frame.size.height - 5 )];
}

-(void)handleViewSignal_DYBMenuView:(MagicViewSignal *)signal{

    if ([signal is:[DYBMenuView MENUSELECTCELL]]) {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *section = [dict objectForKey:@"section"];
        NSString *strType = [self getStringTitle:[section integerValue]];
        
        [self.headview setTitle:strType];
        [self initDYBMenuView];
    }
}

-(void)initDYBMenuView{

    
    [self hideRightView];
    
    if (!_tabMenu) {
        
        
        NSArray *_arrTitleLable =[[NSArray alloc]initWithObjects:@"共享给我",@"我共享的",@"公共资源", nil];
        _tabMenu = [[DYBMenuView alloc]initWithData:_arrTitleLable selectRow:0];
        [self.view addSubview:_tabMenu];
        
        RELEASE(_tabMenu);
        RELEASE(_arrTitleLable);
    }   
    
    if (bPullDown) {
            
        [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:self from:self target:_tabMenu];
        
    }else{
        
        [self sendViewSignal:[DYBMenuView MENUDOWN] withObject:self from:self target:_tabMenu];
    }
    
    [_tabMenu changeArrowStatus:!bPullDown];
    bPullDown = !bPullDown;

}

-(NSString *)getTarget:(int)tag{

    switch (tag) {
        case 1:
            return @"U";
            break;
        case 2:
            return @"C";
            break;
                   
        default:
            break;
    }

    return @"U";
}
-(void)handleViewSignal_DYBDataBankShareViewController:(MagicViewSignal *)signal{

    if ([signal is:[DYBDataBankShareViewController SWITCHDYBAMICBUTTON]]) {

        [self initDYBMenuView];
       
    }else if ([signal is:[DYBDataBankShareViewController MENUSELECT]]){
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSNumber *nSection = [dict objectForKey:@"section"];
        
        DLogInfo(@"%d", [nSection intValue]);
    }else if ([signal is:[DYBDataBankShareViewController CHOOSE]]){
        
        
        [self hideRightView];
        
        DLogInfo(@"obj --- %@",[signal object]);
        MagicUIButton *btn = (MagicUIButton *)[signal object];
        int tag = btn.tag;
        
        strTarget = [self getTarget:tag];

        int asc = 1;
        
        if (iRihgt == 1) {
            asc = 2;
        }else{
            asc = 1;
            
        }
        
        MagicRequest *request = [DYBHttpMethod share_formelist_target:strTarget order:[NSString stringWithFormat:@"%d",iRihgt] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@"" asc:[NSString stringWithFormat:@"%d",asc] isAlert:NO receive:self];
        [request setTag:REQUESTTAG_FIRIST];
        
        [self changeBtnColoer:tag];

    }
}

-(void)changeBtnColoer:(int)tag{
    
    for (int i = 1; i <= 4; i++) {
        
        UILabel *label = (UILabel *)[chooseBtn[i-1] viewWithTag:88];
        if (tag == i) {
            
            [chooseBtn[i-1] setSelected:YES];
            
            [label setTextColor:[UIColor whiteColor]];
        }else{
            
            [chooseBtn[i-1] setSelected:NO];
            
            [label setTextColor:ColorBlue];
        }
    }

}

-(void)handleViewSignal_DYBDataBankTopRightCornerView:(MagicViewSignal *)signal{

    if ([signal is:[DYBDataBankTopRightCornerView TOUCHSINGLEBTN]]) {
        
        NSString *strTag = (NSString *)[signal object];
        
//        iRihgt = [strTag integerValue];
        
        if ([strTag integerValue] == 1) {
            iRihgt = 1;
        }else{
            
            iRihgt = 3;
        }
        
        int asc = 1;
        
        if (iRihgt == 1) {
            asc = 2;
        }else{
        asc = 1;
        
        }
        
        page = 1;
        [self hideTabMenu];
        
        switch (iRequestType) {
            case 0:
            {
                MagicRequest *request = [DYBHttpMethod share_formelist_target:strTarget order:[NSString stringWithFormat:@"%d",iRihgt] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@"" asc:[NSString stringWithFormat:@"%d",asc]  isAlert:NO receive:self];
                [request setTag:REQUESTTAG_FIRIST];
                
            }
                break;
            case 1:
            {
                MagicRequest *request = [DYBHttpMethod share_frommelist:[NSString stringWithFormat:@"%d",iRihgt] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page]  keyword:@"" asc:[NSString stringWithFormat:@"%d",asc] isAlert:NO receive:self];
                [request setTag:REQUESTTAG_FIRIST];
                
            }
                break;
            case 2:
            {
                MagicRequest *request = [DYBHttpMethod document_public_order:[NSString stringWithFormat:@"%d",iRihgt] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@"" asc:[NSString stringWithFormat:@"%d",asc]  isAlert:YES receive:self];
                [request setTag:REQUESTTAG_FIRIST];
                
            }
                break;
                
            default:
                break;
        }
        
        UIView *viewBar = [self.view viewWithTag:RIGHTVIEWTAG];
        
        if (!viewBar.hidden && viewBar) {
            [viewBar setHidden:YES];
        }
    }

}

-(NSString *)getAsc:(NSString *)strkey{

    if ([strkey isEqualToString:@"1"]) {
        return @"1";
    }else if ([strkey isEqualToString:@"1"]){
    
    return @"2";
    }
return @"1";

}

-(void)hideTabMenu{

    [self sendViewSignal:[DYBMenuView MENUSHRINK] withObject:self from:self target:_tabMenu];
    [_tabMenu changeArrowStatus:NO];
    bPullDown = NO;

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self hideTabMenu];
    [self hideRightView];
    

}

#pragma mark- 只接受tbv信号
//static NSString *reuseIdentifier = @"reuseIdentifier";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSNumber *s = [NSNumber numberWithInteger:arrayCellView.count];
        [signal setReturnValue:s];
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath
    {
        
        
        
        [signal setReturnValue:[NSNumber numberWithInteger:CELLHIGHT]];
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        [signal setReturnValue:nil];
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
    {
        [signal setReturnValue:nil];
        
    }
    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
    {
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
    }
    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        DYBDataBankListCell *cell = [arrayCellView objectAtIndex:indexPath.row];
        
        
        if (indexPath.row%2 == 0) {
            [cell setSwipViewBackColor:[UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1.0f]];
        }else{
            [cell setSwipViewBackColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
            
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
        if (bPullDown) {
            [self hideTabMenu];
            [self hideRightView];
            return;
        }
        
        if ([self hideRightView]) {
            return;
        }
        
        
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        NSDictionary *dictResult = [arrayFolderList objectAtIndex:indexPath.row];
        
        
        BOOL isFolder = [[dictResult objectForKey:@"is_dir"] boolValue];
        if (!isFolder) {  
            
            BOOL bShow = [DYBShareinstaceDelegate noShowTypeFileTarget:self type:[dictResult objectForKey:@"type"]];
            
            if (!bShow) {
                return;
            }    
            
            DYBDataBankFileDetailViewController *showFile = [[DYBDataBankFileDetailViewController alloc]init];
            showFile.dictFileInfo = dictResult;
            showFile.index = indexPath.row;
            showFile.targetObj = self;
            showFile.cellOperater = [arrayCellView objectAtIndex:indexPath.row];
            showFile.iPublicType = self.showType;
            
            [self.drNavigationController pushViewController:showFile animated:YES];
            RELEASE(showFile);
            return ;
        }

    }else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])//滚动停止
    {
         [self hideTabMenu];
        
    }else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])
    {
         [self hideRightView];
    }
    else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])
    {
        DLogInfo(@"1111");
        
    }else if ([signal is:[MagicUITableView TABELVIEWBEGAINSCROLL]])
    {

    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){
        
        [tbDataBank StretchingUpOrDown:0];
        [DYBShareinstaceDelegate opeartionTabBarShow:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){
        
        [tbDataBank StretchingUpOrDown:1];
        [DYBShareinstaceDelegate opeartionTabBarShow:NO];
    }else if([signal is:[MagicUITableView TAbLEVIEWLODATA]])
    {
        
        page ++;
        
        int asc = 1;
        
        if (iRihgt == 1) {
            asc = 2;
        }else{
            asc = 1;
            
        }

        
        switch (self.showType) {
            case SomeoneShowToME:
            {
                MagicRequest *request = [DYBHttpMethod share_formelist_target:strTarget order:[NSString stringWithFormat:@"%d",iRihgt] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@"" asc:[NSString stringWithFormat:@"%d",asc] isAlert:NO receive:self];
                [request setTag:REQUESTTAG_MORE];
                
            }
                break;
            case MEShowToSomeone:
            {
                MagicRequest *request = [DYBHttpMethod share_frommelist:[NSString stringWithFormat:@"%d",iRihgt] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@"" asc: [NSString stringWithFormat:@"%d",asc] isAlert:NO receive:self];
                [request setTag:REQUESTTAG_MORE];
                
            }
                break;
            case Commonality:
            {
                MagicRequest *request = [DYBHttpMethod document_public_order:[NSString stringWithFormat:@"%d",iRihgt] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@"" asc:[NSString stringWithFormat:@"%d",asc] isAlert:YES receive:self];
                [request setTag:REQUESTTAG_MORE];
                
            }
                break;
                
            default:
                break;
        }
                
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])
    {
        
        int asc = 1;
        
        if (iRihgt == 1) {
            asc = 2;
        }else{
            asc = 1;
            
        }
        
        page = 1;
        
        switch (self.showType) {
            case SomeoneShowToME:
            {
                MagicRequest *request = [DYBHttpMethod share_formelist_target:strTarget order:[NSString stringWithFormat:@"%d",iRihgt] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@"" asc:[NSString stringWithFormat:@"%d",asc] isAlert:NO receive:self];
                [request setTag:REQUESTTAG_FIRIST];
                
            }
                break;
            case MEShowToSomeone:
            {
                MagicRequest *request = [DYBHttpMethod share_frommelist:[NSString stringWithFormat:@"%d",iRihgt] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@"" asc:[NSString stringWithFormat:@"%d",asc] isAlert:NO receive:self];
                [request setTag:REQUESTTAG_FIRIST];
                
            }
                break;
            case Commonality:
            {
                MagicRequest *request = [DYBHttpMethod document_public_order:[NSString stringWithFormat:@"%d",iRihgt] num:[NSString stringWithFormat:@"%d",num] page:[NSString stringWithFormat:@"%d",page] keyword:@"" asc:[NSString stringWithFormat:@"%d",asc] isAlert:NO receive:self];
                [request setTag:REQUESTTAG_FIRIST];
                
            }
                break;
                
            default:
                break;
        }
        
    }
}


- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    JsonResponse *response = (JsonResponse *)receiveObj;
    if(request.tag == REQUESTTAG_FIRIST){
    
        [arrayCellView removeAllObjects];
    
        if ([[response.data objectForKey:@"result"] boolValue])
        {
            DLogInfo(@"data ---- %@",response.data);
            NSArray *list=[response.data objectForKey:@"list"];
            
            RELEASEDICTARRAYOBJ(arrayFolderList);
            
            arrayFolderList = [[NSMutableArray alloc]initWithArray:list];
            [self creatCell_type:1];
            searchView.arrayResourcesList = arrayFolderList;
            searchView.iCellType = 1;
            searchView.iBtnType = self.showType;
            searchView.arrayViewCell = arrayCellView;
            searchView.strTarget = strTarget;
        }
        
        if (arrayCellView.count > 0) {
            
            UIView *view = [self.view viewWithTag:NORESULTVIEW];
            if (view) {
                [view removeFromSuperview];
            
            }
            
        }else{
        
            NSString *strHighMSG = nil;
            
            switch (self.showType) {
                case MEShowToSomeone:
                    strHighMSG =@"您还没有共享资料给别人，快去共享吧";
                    
                    break;
                case SomeoneShowToME:
                    strHighMSG =@"还没有资料共享给您，再等等吧";
                    break;
                case Commonality:
                    strHighMSG =@"试试将资料设为公开，好东西大家分享哦~";
                    break;
                    
                default:
                    break;
            }
        
            [self addNOresultImageView:strHighMSG];
        
        }
        
        BOOL bHaveNext = [[response.data objectForKey:@"havenext"] boolValue];
        
        if (bHaveNext == 1) {
            [tbDataBank reloadData:NO];
        }else{
            [tbDataBank reloadData:YES];
        }
        
    }else if (request.tag == BTNTAG_BAD){

        
        if ([[response.data objectForKey:@"result"] boolValue]) { //操作ok
            
            DYBDataBankListCell *cell = [arrayCellView objectAtIndex:badRow];
            [self opeaterCellObj:cell response:response opeaterIndex:goodRow];
                        
        }else{
        
            [self hideGoodeANDDadIMG:_badBtn];

        }
    }else if (request.tag == BTNTAG_GOOD){
        
        
        if ([[response.data objectForKey:@"result"] boolValue]) { //没有操作ok
            DYBDataBankListCell *cell = [arrayCellView objectAtIndex:goodRow];
            [self opeaterCellObj:cell response:response opeaterIndex:badRow];

        }else{
        
            [self hideGoodeANDDadIMG:_goodBtn];
        }
                
    }else if (request.tag == BTNTAG_CANCELSHARE){
    
         if ([[response.data objectForKey:@"result"] boolValue]) {
             
             [arrayFolderList removeObjectAtIndex:cancelShareIndex];
             [self creatCell_type:1];
         }
        
        NSString *strMSG = [response.data objectForKey:@"msg"];
        
        [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
         
    }else if (request.tag == REQUESTTAG_MORE){
        
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            NSArray *list=[response.data objectForKey:@"list"];
            
            [arrayFolderList addObjectsFromArray:list];
            searchView.arrayResourcesList = arrayFolderList;
            
            [self creatCell_type:1];
            searchView.arrayViewCell = arrayCellView;

            BOOL bHaveNext = [[response.data objectForKey:@"havenext"] boolValue];
            
            if (bHaveNext == 1) {
                [tbDataBank reloadData:NO];
            }else{
                [tbDataBank reloadData:YES];
            }
            
        }
    }
}

-(void)hideGoodeANDDadIMG:(UIButton *)btnOperater{

    UIView *opeationView = [self.view viewWithTag:OPEARTIONTAG];
    
    [UIView animateWithDuration:.5f animations:^{
        
        opeationView.alpha = .0f;
        
    } completion:^(BOOL finished) {
        
        [opeationView removeFromSuperview];
        [btnOperater setEnabled:YES];
        
    }];
}

-(void)opeaterCellObj:(DYBDataBankListCell *)cell response:(JsonResponse *)response opeaterIndex:(int)opeaterIndex{
    
    NSDictionary *dictNew = [response.data objectForKey:@"list"];
    
    if ([dictNew isKindOfClass:[NSNull class]]) {
        return;
    }
    cell.labelGood.text = [dictNew objectForKey:@"up"];
    cell.labelBad.text = [dictNew objectForKey:@"down"];
    
    UIButton *btnGood = (UIButton *)[cell viewWithTag:BTNTAG_GOOD];
    if ([[dictNew objectForKey:@"is_estimate_up"] boolValue] ) {
        
        [btnGood setEnabled:NO];
    }else{
        
        [btnGood setEnabled:YES];
    }
    
    UIButton *btnBad = (UIButton *)[cell viewWithTag:BTNTAG_BAD];
    
    if ([[dictNew objectForKey:@"is_estimate_down"] boolValue] ) {
        
        
        [btnBad setEnabled:NO];
    }else{
        
        [btnBad setEnabled:YES];
    }
    
    [arrayFolderList replaceObjectAtIndex:opeaterIndex withObject:dictNew];  //替换 array中的dict
    
    UIView *opeationView = [self.view viewWithTag:OPEARTIONTAG];
    
    [UIView animateWithDuration:.5f animations:^{
        
        opeationView.alpha = .0f;
        
    } completion:^(BOOL finished) {
        
        [opeationView removeFromSuperview];
//        [btnBad setEnabled:YES];
    }];
}

-(void)addNOresultImageView:(NSString *)strMsg{
    
    
    UIView *view = [self.view viewWithTag:NORESULTVIEW];
    if (!view) {
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0.0f,  SEARCHBAT_HIGH, 300.0f, 400.0f)];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setTag:NORESULTVIEW];
        [tbDataBank insertSubview:view atIndex:0];
        RELEASE(view);
        
        UIImage *image = [UIImage imageNamed:@"ybx_big.png"];
        float BearHeadStartX = (CGRectGetWidth(self.view.frame)-image.size.width/2)/2;
        float BearHeadStartY = (self.frameHeight-self.headHeight-image.size.height/2 - 70)/2-130;
        MagicUIImageView *viewBearHead = [[MagicUIImageView alloc] initWithFrame:CGRectMake(BearHeadStartX, BearHeadStartY - 44, image.size.width/2, image.size.height/2)];
        [viewBearHead setBackgroundColor:[UIColor clearColor]];
        [viewBearHead setImage:image];
        [view addSubview:viewBearHead];
        RELEASE(viewBearHead);
        
        MagicUILabel *labelMsg = [[MagicUILabel alloc]initWithFrame:CGRectMake((320 - 250)/2, viewBearHead.frame.size.height + viewBearHead.frame.origin.y + 15, 250.0f, 40.0f)];
        [labelMsg setText:strMsg];
        [labelMsg setTextColor:ColorGray];
        [labelMsg setFont:[DYBShareinstaceDelegate DYBFoutStyle:20]];
        [labelMsg setTextAlignment:NSTextAlignmentCenter];
        [labelMsg setNumberOfLines:2];
        [labelMsg setTag:909];
        [labelMsg setBackgroundColor:[UIColor clearColor]];
        [view addSubview:labelMsg];
        RELEASE(labelMsg);
        
    }else{
        
        UILabel *label = (UILabel *)[view viewWithTag:909];
        [label setText:strMsg];
        
    }    
}


-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankShotView LEFT]]) {
        
    }
    if ([signal is:[DYBDataBankShotView RIGHT]]) {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *type = [dict objectForKey:@"type"];
        NSNumber *row = [dict objectForKey:@"rowNum"];
        NSString *fileURL = [[arrayFolderList objectAtIndex:[row integerValue]]objectForKey:@"file_url"];
        switch ([type integerValue]) {
            case BTNTAG_DEL:{
                
                MagicRequest *request = [DYBHttpMethod document_deldoc_doc:fileURL indexDataBack:[NSString stringWithFormat:@"%@",row] isAlert:YES receive:self];
                
                [request setTag:BTNTAG_DEL];
                
            }
                break;
                
            case BTNTAG_CHANGE:
                
                break;
                
            case BTNTAG_RENAME:
                
                break;
            case BTNTAG_SHARE:
                
                break;
            case BTNTAG_CANCELSHARE:
            {
                cancelShareIndex = [row integerValue];
                NSString *strDoc = [[arrayFolderList objectAtIndex:[row integerValue]] objectForKey:@"file_path"];
                MagicRequest *request = [DYBHttpMethod document_share_doc:strDoc target:@"" isAlert:YES receive:self ];
                [request setTag:BTNTAG_CANCELSHARE];
            
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)handleViewSignal_DYBDataBankSelectBtn:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankSelectBtn TOUCHSIGLEBTN]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UIButton *btn = (UIButton *)[dict objectForKey:@"btn"];
        int row = [[dict objectForKey:@"row"] integerValue];
        
        DYBDataBankListCell *cell = [arrayCellView objectAtIndex:row]; //关闭 cell
        [cell closeCell];
        
        NSDictionary *dictInfo = [arrayFolderList objectAtIndex:row];
        switch (btn.tag) {
                
            case BTNTAG_SHARE:
                
            {
                
                DYBDataBankShareEnterView * shareView = [[DYBDataBankShareEnterView alloc]initWithFrame:CGRectMake(0.0f, 0.0f , 320.0f, self.drNavigationController.view.frame.size.height) target:self info:[arrayFolderList objectAtIndex:row] arrayFolderList:arrayFolderList index:row];
                shareView.cellDetail = [arrayCellView objectAtIndex:row];
                [self.drNavigationController.view addSubview:shareView];
                RELEASE(shareView);
                
            }
                break;
            case BTNTAG_CHANGE:
            {

                DYBDataBankChildrenListViewController *childr = [[DYBDataBankChildrenListViewController alloc]init];
                
                childr.dictInfo = [arrayFolderList objectAtIndex:row] ;
                childr.folderID = @"";
                
                if (self.showType == SomeoneShowToME) {
                    
                    childr.strChangeType = @"SHARE";
                }else{
                
                    childr.strChangeType = @"O";
                }
                childr.popController = self;
                childr.bChangeSave = YES;
                childr.strFromDir = [NSString stringWithFormat:@"%@",[[arrayFolderList objectAtIndex:row] objectForKey:@"file_path"]];
                childr.bChangeFolder = YES;
                
                [self.drNavigationController pushViewController:childr animated:YES];
                RELEASE(childr);
            }
                
                break;
            case BTNTAG_RENAME:
                
                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要删除吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_RENAME];
               
                break;
            case BTNTAG_DOWNLOAD:
                
                break;
            case BTNTAG_DEL:
            {
                
                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要删除吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",row]];
            }
                break;
            case BTNTAG_CANCELSHARE:
            {
            
            [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要取消共享吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_CANCELSHARE rowNum:[NSString stringWithFormat:@"%d",row]];
            
            }
                
                break;
            case BTNTAG_BAD:
            {
                
                badRow = row;
                [btn setEnabled:NO];
                _badBtn = btn;
                [self creatGoodANDBadIMG:@"cai"];
                MagicRequest *request = [DYBHttpMethod document_estimate_id:[dictInfo objectForKey:@"oid"] type:@"2" isAlert:NO receive:self];
                [request setTag:BTNTAG_BAD];
            }
                break;
            case BTNTAG_GOOD:
            {
                
                [self creatGoodANDBadIMG:@"ding"];
                goodRow = row;
                [btn setEnabled:NO];
                _goodBtn = btn;
                MagicRequest *request = [DYBHttpMethod document_estimate_id:[dictInfo objectForKey:@"oid"] type:@"1" isAlert:NO receive:self];
                [request setTag:BTNTAG_GOOD];
            }
                break;
            case BTNTAG_REPORT:
            {
                DYBSignViewController *vc = [[DYBSignViewController alloc]init];
                vc.bDataBank = YES;
                vc.dictInfo = dictInfo;
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);

            }
                break;
                
            default:
                break;
        }
    }
}

-(void)creatGoodANDBadIMG:(NSString *)strImgName{

    UIImageView *imageViewOperation = (UIImageView *)[self.view viewWithTag:OPEARTIONTAG];
    
    if (!imageViewOperation) {
        
        imageViewOperation = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0)];
        [imageViewOperation setTag:OPEARTIONTAG];
        [imageViewOperation setCenter:CGPointMake(320.0f/2, self.view.frame.size.height/2)];
        [imageViewOperation setImage:[UIImage imageNamed:strImgName]];
        [self.view addSubview:imageViewOperation];
        RELEASE(imageViewOperation);
    }else{
        
        [imageViewOperation setImage:[UIImage imageNamed:strImgName]];
    }
}

-(void)handleViewSignal_DYBDataBankListCell:(MagicViewSignal *)signal{

    if ([signal is:[DYBDataBankListCell FINISHSWIP]]) {
        [self hideRightView];
        
    }
}

-(void)handleViewSignal_DYBDataBankFileDetailViewController:(MagicViewSignal *)signal{

    if ([signal is:[DYBDataBankFileDetailViewController CANCELSHARE]]) {
        
        NSNumber *opeaterNum = (NSNumber *)[signal object];
        [arrayFolderList removeObjectAtIndex:[opeaterNum intValue]];
        [self creatCell_type:1];
    }

}

-(void)creatCell_type:(int)iType{

    [arrayCellView removeAllObjects];
    
    for (int i = 0; i < arrayFolderList.count; i++) {
        
        NSDictionary *dict = [arrayFolderList objectAtIndex:i];
        DYBDataBankListCell *cell = [[DYBDataBankListCell alloc] initWithFrame:CGRectZero object:nil];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [cell setIndexPath:indexPath];
        [cell setTb:tbDataBank];
        [cell setBtnType:self.showType];
        [cell setCellType:1];
        [cell initViewCell_dict:dict];
        [arrayCellView addObject:cell];
        [cell release];
        
    }
    
    RELEASEDICTARRAYOBJ(tbDataBank._muA_differHeightCellView)
    tbDataBank._muA_differHeightCellView = [[NSMutableArray alloc]initWithArray:arrayCellView];
    
    [tbDataBank reloadData];

}

- (void)dealloc
{
    RELEASE(strTarget);
    
    for (DYBDataBankListCell *view in arrayCellView ) { //强制释放array中的对象

        [view release];
        view  = nil;
    }
    
    RELEASEDICTARRAYOBJ(arrayCellView);
    RELEASEDICTARRAYOBJ(arrayFolderList);
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
