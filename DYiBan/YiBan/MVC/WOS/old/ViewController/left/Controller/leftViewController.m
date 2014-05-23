    //
//  leftViewController.m
//  splitViewTest
//
//  Created by zeng tom on 12-10-8
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "leftViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "UserSettingMode.h"
//#import "CommonHelper.h"
//#import "Static.h"
//#import "Rrequest_Data.h"
//#import "HttpHelp.h"
#import "UserLoginModel.h"
//#import "YiBanLocalDataManager.h"
//#import "CommonHelper.h"
//#import "RegisetSchoolViewController.h"
//#import "SettingViewController.h"
#import "list.h"
#import "YiBanApp_list.h"
#import "UIImageView+WebCache.h"
#import "NSDictionary+JSON.h"
#import "Cell2.h"
#import "Cell1.h"
#import "LLSplitViewController.h"
#import "WOSGoodFoodViewController.h"
@implementation leftViewController{

    BOOL isOpen;
    NSMutableArray *_dataList;
    DYBUITableView *tbDataBank;

}
@synthesize labelName;
@synthesize imageViewUser;
@synthesize btnLogout;
@synthesize arrAppList,selectIndex;


static leftViewController *share = nil;
+(leftViewController *)share{
    if (!share) {
        share = [[leftViewController alloc] init];
    }
    return share;
}


-(void)showOtherView:(id)sender{
    //清空 动态页面

    
    UIButton *btn = nil;
    int tag = -1;
    if ([sender isKindOfClass:[UIButton class]]) {
        btn = (UIButton *)sender;
        tag = btn.tag;
    }else{
        tag = 2;
    }
    

//    LoginController *log = [LoginController creatLogin];
//    if ([log getController] == nil) {
//        [[LLSplitViewController getmainController]showViewController:[MainViewController share] animated:YES];
//    }
//    else{
//        [[log getController] showViewController:[MainViewController share] animated:YES];
//    }
    [self.view setUserInteractionEnabled:NO];
//    YBLogInfo(@"tag= %d 锁住了",tag);
    
       
//    if (tag == 0) {
//        [[MainViewController share] addViewOne];
//    }else if (tag == 1) {
//        [[MainViewController share] addViewTwo];
//        [btn setBackgroundImage:[UIImage imageNamed:@"leftmenu_news_b.png"] forState:UIControlStateNormal];
//    }
//    else if (tag == 2) {//主页
//
//        [[MainViewController share] addViewThree:NO user:nil];
//        [btn setBackgroundImage:[UIImage imageNamed:@"leftmenu_home_b.png"] forState:UIControlStateNormal];
//    }else if (tag == 3) {//好友
//
//        [[MainViewController share] addViewFour];
//        [btn setBackgroundImage:[UIImage imageNamed:@"leftmenu_friends_b.png"] forState:UIControlStateNormal];
//    }else if (tag == 4) {//找人
//
//        [[MainViewController share] addViewFive];
//        [btn setBackgroundImage:[UIImage imageNamed:@"leftmenu_find_b.png"] forState:UIControlStateNormal];
//    }else if (tag == 5) {//班级
//        [[MainViewController share] addViewSeven];
//        [btn setBackgroundImage:[UIImage imageNamed:@"leftmenu_class_b.png"] forState:UIControlStateNormal];
//    }else if (tag == 6){    
//        [[MainViewController share] addViewEight];
//    
//    }else if (tag == 7) {
//        [[MainViewController share] addViewNine];
//    }else if (tag == 10) {
//        [[MainViewController share] addVIewTen];
////        [btn setBackgroundImage:[UIImage imageNamed:@"leftmenu_class_b.png"] forState:UIControlStateNormal];
//    }
//    else{
//        if ([arrAppList count] > 0) {
//            list *app = [arrAppList objectAtIndex:tag-10001];
//            [self openApp:app.store_url AppSchemesURL:app.schemes_url];
////            [[CommonHelper shareInstance] playSound:5];
//        }
//    }
//
//
//    [self setButtonState:tag];
    [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timeForClick) userInfo:nil repeats:NO];//。2秒之后才能触发事件
}

- (void)timeForClick{
//    YBLogInfo(@"我已给解开了");
    [self.view setUserInteractionEnabled:YES];
}

-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        //        [self.rightButton setHidden:YES];
        //        [self.headview setTitle:@"极食客"];
        
        [self.headview setTitle:@"分类大全"];
        [self.headview setTitleColor:[UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f]];
        
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        
        [self.view setBackgroundColor:ColorBG];
        DYBUITabbarViewController *tabBatC = [DYBUITabbarViewController sharedInstace];
        
        [tabBatC hideTabBar:YES animated:NO];
        [self.leftButton setHidden:YES];
        
        
        
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        
        UIImageView *imageViewBG = [[UIImageView alloc]initWithFrame:self.view.frame];
        [imageViewBG setImage:[UIImage imageNamed:@"huidi"]];
        [imageViewBG setUserInteractionEnabled:YES];
        [self.view addSubview:imageViewBG];
        RELEASE(imageViewBG);
        
        
//        NSString *path  = [[NSBundle mainBundle] pathForResource:@"ExpansionTableTestData" ofType:@"plist"];
//        _dataList = [[NSMutableArray alloc] initWithContentsOfFile:path];
//        NSLog(@"%@",path);
//        
//        
//        NSString *path1  = [[NSBundle mainBundle] pathForResource:@"FoodList" ofType:@"plist"];
//      NSMutableDictionary *idataList = [[NSMutableDictionary alloc] initWithContentsOfFile:path1];
//        NSLog(@"%@",path1);
//        
//        tbDataBank.sectionFooterHeight = 0;
//        tbDataBank.sectionHeaderHeight = 0;
//        isOpen = NO;
//        
//        tbDataBank = [[DYBUITableView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, CGRectGetHeight(self.view.frame) - 100)];
//        [self.view addSubview:tbDataBank];
//        [tbDataBank setBackgroundColor:ColorBG];
//        [tbDataBank setSeparatorColor:[UIColor clearColor]];
//        RELEASE(tbDataBank);
        

        
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
//        [self performSelector:@selector(delay) withObject:nil afterDelay:10];
        
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
//        [self.headview setTitle:@"分类大全"];
//        [self.headview setTitleColor:[UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f]];
//        
//        [self setButtonImage:self.leftButton setImage:@"back"];
//        [self.headview setBackgroundColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0]];
    }
}

-(void)delay{

    [self.headview setTitle:@"分类大全"];
    [self.headview setTitleColor:[UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f]];
    
    [self setButtonImage:self.leftButton setImage:@"back"];
    [self.headview setBackgroundColor:[UIColor redColor]];

}


- (void)unVerifyUser{
    viewCover = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewCover setFrame:CGRectMake(0, 48, 320, 172)];
    [viewCover setBackgroundColor:[UIColor blackColor]];
    [viewCover setAlpha:0.7];
    [viewCover setUserInteractionEnabled:YES];
    [viewCover addTarget:self action:@selector(verifyAlert) forControlEvents:UIControlEventTouchUpInside];
    [leftList addSubview:viewCover];
}

- (void)removeVerifyWarning{
    [viewCover removeFromSuperview];
}


- (void)loadLocalApp{
    UIImageView *viewMyapp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myapp.png"]];
    [viewMyapp setFrame:CGRectMake(0, 220, 320, 33)];
    [viewMyapp setBackgroundColor:[UIColor clearColor]];
    [leftList addSubview:viewMyapp];
    [viewMyapp release];
    
   
}

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        int  section = [[dict objectForKey:@"section"] integerValue];
        
        int num = 1;
        if (isOpen) {
            if (self.selectIndex.section == section) {
                num =  [[[_dataList objectAtIndex:section] objectForKey:@"list"] count]+1;;
            }
        }else{
            num = 1;
        }
        
        [signal setReturnValue:[NSNumber numberWithInteger:num]];
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        
        
        NSNumber *s = [NSNumber numberWithInteger:_dataList.count];
        [signal setReturnValue:s];
        
        
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath
    {
        
        
        
        [signal setReturnValue:[NSNumber numberWithInteger:60]];
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
        UITableView *tableView  = [dict objectForKey:@"tableView"];
        UITableViewCell *sendCell = nil;
        
        if (isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
            static NSString *CellIdentifier = @"Cell2";
            Cell1 *cell = (Cell1*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (!cell) {
                cell = [[Cell1 alloc]init];
            }
            NSArray *list = [[_dataList objectAtIndex:self.selectIndex.section] objectForKey:@"list"];
            [cell setBackgroundColor:ColorBG];
            cell.titleLabel.text = [list objectAtIndex:indexPath.row-1];
            [cell setIconImage:5];
            
            sendCell = cell;
        }else
        {
            static NSString *CellIdentifier = @"Cell1";
            Cell1 *cell = (Cell1*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (!cell) {
                cell = [[Cell1 alloc]init];
                            }
            [cell setBackgroundColor:ColorBG];
            NSString *name = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"];
            cell.titleLabel.text = name;
            [cell setIconImage:indexPath.section];

            [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
            sendCell =  cell;
        }
        
        [sendCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:sendCell ];
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        if (indexPath.row == 0) {
            if ([indexPath isEqual:self.selectIndex]) {
                isOpen = NO;
                [self didSelectCellRowFirstDo:NO nextDo:NO];
                self.selectIndex = nil;
                
            }else
            {
                if (!self.selectIndex) {
                   self.selectIndex = indexPath;
                    [self didSelectCellRowFirstDo:YES nextDo:NO];
                    
                }else
                {
                    
                    [self didSelectCellRowFirstDo:NO nextDo:YES];
                }
            }
            
        }else
        {
            DLogInfo(@"_dataList --- >%@",_dataList);
            NSDictionary *dict = [_dataList objectAtIndex:indexPath.section];
            NSString *name = [dict objectForKey:@"name"];
            NSArray *lsit = [dict objectForKey:@"list"];
            NSString *classE = [lsit objectAtIndex:indexPath.row-1];
            [self reloadNewInfo:classE];

        }
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]) //刷新
    {
        //        MagicUIUpdateView *uptableview = (MagicUIUpdateView *)[signal object];
        
        
    }else if([signal is:[MagicUITableView TAbLEVIEWLODATA]]) //加载更多
    {
        
        //        MagicUIUpdateView *uptableview = (MagicUIUpdateView *)[signal object];
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){ //上滑动
        
        //        [tbDataBank StretchingUpOrDown:0];
        //        [DYBShareinstaceDelegate opeartionTabBarShow:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){ //下滑动
        
        //        [tbDataBank StretchingUpOrDown:1];
        //        [DYBShareinstaceDelegate opeartionTabBarShow:NO];
    }
    
}


-(void)reloadNewInfo:(NSString *)name{
    
    LLSplitViewController *split = [LLSplitViewController getmainController];
    [split showHomeView:YES];
    
    WOSGoodFoodViewController *goodFood = [WOSGoodFoodViewController creatObj];
    [goodFood reSetData:name];
    
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
  isOpen = firstDoInsert;
    
    Cell1 *cell = (Cell1 *)[tbDataBank cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [tbDataBank beginUpdates];
    
    int section = self.selectIndex.section;
    int contentCount = [[[_dataList objectAtIndex:section] objectForKey:@"list"] count];
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert)
    {   [tbDataBank insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }
	else
    {
        [tbDataBank deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }
    
	[rowToInsert release];
	
	[tbDataBank endUpdates];
    if (nextDoInsert) {
        isOpen = YES;
        self.selectIndex = [tbDataBank indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (isOpen) [tbDataBank scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}


-(void)backPop
{
    [self.drNavigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
//        [self.drNavigationController popToFirstViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    [super dealloc];
    [labelName release];
    [btnLogout release];
    [arrAppList release];
    [imageViewUser release];
}

- (void)releaseShare{
    share = nil;
}

@end
