//
//  WOSHomeViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-12-4.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSHomeViewController.h"
#import "WOSGoodFoodViewController.h"
#import "WOSALLOrderViewController.h"
#import "WOSPersonInfoViewController.h"
#import "LLSplitViewController.h"
#import "WOSGoodPriceViewController.h"
#import "WOSMapViewController.h"
#import "WOSThinkYouLikeViewController.h"
#import "WOSFindFoodViewController.h"
#import "WOSActivityDetailViewController.h"
#import "JSONKit.h"
#import "JSON.h"
#import "Magic_Device.h"
#import "WOSShopsListTableViewCell.h"
#import "WOSShopDetail1ViewController.h"

@interface WOSHomeViewController (){
    SGFocusImageFrame *bannerView;
    UIScrollView *scrollView;
    NSMutableArray *arrayResult;
}

@end

@implementation WOSHomeViewController


DEF_SIGNAL(TOUCHBUTTON)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
//    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        //        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"极食客"];
//        [self.headview setHidden:YES];
//        [self.leftButton setHidden:YES];
        [self setButtonImage:self.rightButton setImage:@"account"];
//        [self.imageViewHead setImage:[UIImage imageNamed:@"top"]];
//        [self.headview setBackgroundColor:[UIColor grayColor]];
        
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        
        [self.view setBackgroundColor:[UIColor colorWithRed:61.0f/255 green:61.0f/255  blue:61.0f/255  alpha:1.0f]];
        [self.view setBackgroundColor:[UIColor blackColor]];
        DYBUITabbarViewController *tabBatC = [DYBUITabbarViewController sharedInstace];
        
        [tabBatC hideTabBar:YES animated:NO];
                
        if ([MagicDevice sysVersion] >= 7)
        {
//            [self.view setFrame:CGRectMake(0,20 , 320.0f, 1000)];
            
            //       self.view.frame.origin.y = 20.0f;
        }

    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
//        [self.view setFrame:CGRectMake(0.0f, 120.0f + 40, 320.0f, self.view.frame.size.height + 120)];
        
        
        
        MagicRequest *request = [DYBHttpMethod wosKitchenInfo_activityList_count:@"4" sAlert:YES receive:self];
        [request setTag:3];
        
       scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight- 44, 320, self.view.frame.size.height+ 44 - self.headHeight + 44)];
        [scrollView setBackgroundColor:[UIColor colorWithRed:61.0f/255 green:61.0f/255  blue:61.0f/255  alpha:1.0f]];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:scrollView];
        RELEASE(scrollView);
        
        [self.rightButton setHidden:YES];
        
        
        MagicUITableView *tabelViewList = [[MagicUITableView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, self.view.frame.size.height - self.headHeight)];
        
        [self.view addSubview:tabelViewList];
        RELEASE(tabelViewList)
        
        
//        [self.view setBackgroundColor:[UIColor clearColor]];
        
//        [self creatBanner];
        
//         UIImage *image = [UIImage imageNamed:@"flash.png"];
//        
//        UIImage *imageGoodFood = [UIImage imageNamed:@"list.png"];
//        UIButton *btnGoodFood = [[UIButton alloc]initWithFrame:CGRectMake((320 - imageGoodFood.size.width/2)/2, 45 + image.size.height/2 , imageGoodFood.size.width/2, imageGoodFood.size.height/2)];
////        [btnGoodFood setTitle:@"美食大全" forState:UIControlStateNormal];
//        [btnGoodFood addTarget:self action:@selector(goodFood) forControlEvents:UIControlEventTouchUpInside];
//        [btnGoodFood setImage:imageGoodFood forState:UIControlStateNormal];
//        [btnGoodFood setImage:imageGoodFood forState:UIControlStateHighlighted];
//        [scrollView addSubview:btnGoodFood];
//        RELEASE(btnGoodFood);
//                
//        
//        UIImage *imageGoodPrice = [UIImage imageNamed:@"discount"];
//        UIButton *btnGoodPrice = [[UIButton alloc]initWithFrame:CGRectMake(8, CGRectGetHeight(btnGoodFood.frame) + CGRectGetMinY(btnGoodFood.frame) + 5 , imageGoodPrice.size.width/2, imageGoodPrice.size.height/2)];
//        //        [btnGoodFood setTitle:@"美食大全" forState:UIControlStateNormal];
//        [btnGoodPrice setImage:imageGoodPrice forState:UIControlStateNormal];
//        [btnGoodPrice setImage:imageGoodPrice forState:UIControlStateHighlighted];
//        [btnGoodPrice addTarget:self action:@selector(goodPrice) forControlEvents:UIControlEventTouchUpInside];
//        [scrollView addSubview:btnGoodPrice];
//        RELEASE(btnGoodPrice);
//        
//        
//        UIImage *imageGoodMap = [UIImage imageNamed:@"map"];
//        UIButton *btnGoodMap = [[UIButton alloc]initWithFrame:CGRectMake( CGRectGetWidth(btnGoodPrice.frame) + 8 + 7, CGRectGetHeight(btnGoodFood.frame) + CGRectGetMinY(btnGoodFood.frame) + 5 , imageGoodMap.size.width/2, imageGoodMap.size.height/2)];
//        //        [btnGoodFood setTitle:@"美食大全" forState:UIControlStateNormal];
//        [btnGoodMap addTarget:self action:@selector(mapViewController) forControlEvents:UIControlEventTouchUpInside];
//
//        [btnGoodMap setImage:imageGoodMap forState:UIControlStateNormal];
//        [btnGoodMap setImage:imageGoodMap forState:UIControlStateHighlighted];
//        [scrollView addSubview:btnGoodMap];
//        RELEASE(btnGoodMap);
//        
//        UIImage *imageGoodTuiJian = [UIImage imageNamed:@"recommend"];
//        UIButton *btnGoodTuiJian = [[UIButton alloc]initWithFrame:CGRectMake( CGRectGetWidth(btnGoodPrice.frame) + 8 + 7, CGRectGetHeight(btnGoodMap.frame) + CGRectGetMinY(btnGoodMap.frame) + 5 , imageGoodTuiJian.size.width/2, imageGoodTuiJian.size.height/2)];
//        //        [btnGoodFood setTitle:@"美食大全" forState:UIControlStateNormal];
//        [btnGoodTuiJian setImage:imageGoodTuiJian forState:UIControlStateNormal];
//        [btnGoodTuiJian setImage:imageGoodTuiJian forState:UIControlStateHighlighted];
//        [scrollView addSubview:btnGoodTuiJian];
//        RELEASE(btnGoodTuiJian);
//        
//        
//        UIImage *imageGoodSearch = [UIImage imageNamed:@"search"];
//        UIButton *btnGoodSearch = [[UIButton alloc]initWithFrame:CGRectMake( CGRectGetWidth(btnGoodPrice.frame) + 8 + 7 + CGRectGetWidth(btnGoodTuiJian.frame) + 5 + 3  , CGRectGetHeight(btnGoodMap.frame) + CGRectGetMinY(btnGoodMap.frame) + 5 , imageGoodSearch.size.width/2, imageGoodSearch.size.height/2)];
//        [btnGoodSearch addTarget:self action:@selector(searchFood) forControlEvents:UIControlEventTouchUpInside];
//        //        [btnGoodFood setTitle:@"美食大全" forState:UIControlStateNormal];
//        [btnGoodSearch setImage:imageGoodSearch forState:UIControlStateNormal];
//        [btnGoodSearch setImage:imageGoodSearch forState:UIControlStateHighlighted];
//        [scrollView addSubview:btnGoodSearch];
//        RELEASE(btnGoodSearch);
//        
//        
//        UIImage *imageYouLike = [UIImage imageNamed:@"guess"];
//        UIButton *btnYouLike = [[UIButton alloc]initWithFrame:CGRectMake( 8 , CGRectGetHeight(btnGoodPrice.frame) + CGRectGetMinY(btnGoodPrice.frame) + 5 , imageYouLike.size.width/2, imageYouLike.size.height/2)];
//        //        [btnGoodFood setTitle:@"美食大全" forState:UIControlStateNormal];
//        [btnYouLike addTarget:self action:@selector(youlike) forControlEvents:UIControlEventTouchUpInside];
//        [btnYouLike setImage:imageYouLike forState:UIControlStateNormal];
//        [btnYouLike setImage:imageYouLike forState:UIControlStateHighlighted];
//        [scrollView addSubview:btnYouLike];
//        RELEASE(btnYouLike);
//        
//        UIImage *imageNear = [UIImage imageNamed:@"nearby"];
//        UIButton *btnNear = [[UIButton alloc]initWithFrame:CGRectMake( 8  , CGRectGetHeight(btnYouLike.frame) + CGRectGetMinY(btnYouLike.frame) + 5 , imageNear.size.width/2, imageNear.size.height/2)];
//        //        [btnGoodFood setTitle:@"美食大全" forState:UIControlStateNormal];
//        [btnNear addTarget:self action:@selector(nearby) forControlEvents:UIControlEventTouchUpInside];
//
//        [btnNear setImage:imageNear forState:UIControlStateNormal];
//        [btnNear setImage:imageNear forState:UIControlStateHighlighted];
//        [scrollView addSubview:btnNear];
//        RELEASE(btnNear);
//        
//        UIImage *imagePeople = [UIImage imageNamed:@"nearbypeople"];
//        UIButton *btnPeople = [[UIButton alloc]initWithFrame:CGRectMake( CGRectGetWidth(btnGoodPrice.frame) + 8 + 7  , CGRectGetHeight(btnGoodSearch.frame) + CGRectGetMinY(btnGoodSearch.frame) + 5 , imagePeople.size.width/2, imagePeople.size.height/2)];
//        //        [btnGoodFood setTitle:@"美食大全" forState:UIControlStateNormal];
//        [btnPeople addTarget:self action:@selector(nearbyPeople) forControlEvents:UIControlEventTouchUpInside];
//        [btnPeople setImage:imagePeople forState:UIControlStateNormal];
//        [btnPeople setImage:imagePeople forState:UIControlStateHighlighted];
//        [scrollView addSubview:btnPeople];
//        RELEASE(btnPeople);
//        
//        
//        [scrollView setContentSize:CGSizeMake(320.0f, CGRectGetHeight(btnPeople.frame) + CGRectGetMinY(btnPeople.frame) + 20 )];
        
        [self creatTopBatView];
        
        [self creatBowwon2];
        [self creatBowwonView];
        
//        UIView *view11 = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 210, 320.0f, 40)];
//        [view11 setBackgroundColor:[UIColor redColor]];
//        [self.view addSubview:view11];
        
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}


#pragma mark- 接受tbv信号

static NSString *cellName = @"cellName";//

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSInteger section = [[dict objectForKey:@"section"] integerValue];
        
                    NSNumber *s = [NSNumber numberWithInteger:10];
            [signal setReturnValue:s];
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
          NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath  暂时把每个cell保存,后期有时间优化为只保存高度,返回cell时再异步计算cell的视图,目前刷新后所有cell的view都要重新创建
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        NSMutableArray *arr_curSectionForCell=nil;
        NSMutableArray *arr_curSectionForModel=nil;
        
       
        NSNumber *s = [NSNumber numberWithInteger:70];

        
            [signal setReturnValue:s];
        
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
    {
        
    }//
    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
    {
        
        [signal setReturnValue:[NSNumber numberWithFloat:0]];
        
    }
    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell  只返回显示的cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
//        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        
        WOSShopsListTableViewCell *cell = [[WOSShopsListTableViewCell alloc]init];
        [cell creatCell:nil];
        [signal setReturnValue:cell];
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        UITableView *tableview = [dict objectForKey:@"tableView"];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        WOSShopDetail1ViewController *detail = [[WOSShopDetail1ViewController alloc]init];
        [self.drNavigationController pushViewController:detail animated:YES];
        RELEASE(detail);
    }
    else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
    {
     
        
    }
    else if ([signal is:[MagicUITableView TABLESECTIONINDEXTITLESFORTABLEVIEW]])//右侧索引列表
    {
       
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
      
    
    }
    else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        
    }
    
    else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){//上滑
        
//        [_tbv StretchingUpOrDown:0];
//        [[DYBUITabbarViewController sharedInstace] hideTabBar:YES animated:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){//下滑
//        [_tbv StretchingUpOrDown:1];
//        [[DYBUITabbarViewController sharedInstace] hideTabBar:NO animated:YES];
        
    }
    else if ([signal is:[MagicUITableView TAbLEVIERELOADOVER]])//reload完毕
    {
        //        NSDictionary *dict = (NSDictionary *)[signal object];
        //        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        //        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        //        [_v_inputV.textV becomeFirstResponder];
    }
}



-(void)creatTopBatView{
    UIView *viewBar = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, 40.0f)];
    [viewBar setTag:1000];
    [viewBar setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:viewBar];
    
    float offset = 320/3;
    for (int i = 0; i < 3; i++) {
        
        UIButton *btnTouch = [[UIButton alloc]initWithFrame:CGRectMake(i * offset, 0.0f, offset, 40)];
        [btnTouch setTag:i + 10];
        [btnTouch setTitle:[self getTitle:i] forState:UIControlStateNormal];
        [btnTouch addTarget:self action:@selector(doSelect:) forControlEvents:UIControlEventTouchUpInside];
        [viewBar addSubview:btnTouch];
        RELEASE(btnTouch);
    }
    


}

-(NSString *)getTitle:(int)index{

    switch (index) {
        case 0:
        {
        
            return @"地址";
        
        }
            break;
        case 1:
        {
            
            return @"美食";
            
        }
            break;
        case 2:
        {
            
            return @"店铺";
            
        }
            break;
    

        default:
            break;
    }
    return nil;
}


-(void)creatBowwon2{

    UIView *viewBar = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 20 -40 - 40, 320.0f, 40.0f)];
    [viewBar setTag:10001];
    [viewBar setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:viewBar];
    
    float offset = 320/3;
    for (int i = 0; i < 3; i++) {
        
        UIButton *btnTouch = [[UIButton alloc]initWithFrame:CGRectMake(i * offset, 0.0f, offset, 40)];
        [btnTouch setTag:i + 10];
        [btnTouch setTitle:[self gettitle2:i] forState:UIControlStateNormal];
        [btnTouch addTarget:self action:@selector(doSelect1:) forControlEvents:UIControlEventTouchUpInside];
        [viewBar addSubview:btnTouch];
        RELEASE(btnTouch);
    }
    

}

-(void)doSelect1:(id)sender{

    UIView *viewBar = [self.view viewWithTag:10001];
    UIButton *btn = (UIButton *)sender;
    if (viewBar) {
        
        
        
        for (int i = 10; i < 13; i++) {
            
            UIButton *btn1 = (UIButton *)[viewBar viewWithTag:i];
            if ([btn1 isEqual:btn]) {
                [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }else{
                [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            
        }
        
    }


}

-(NSString *)gettitle2:(int)index{

    switch (index) {
        case 0:
        {
            
            return @"免运费";
            
        }
            break;
        case 1:
        {
            
            return @"折扣";
            
        }
            break;
        case 2:
        {
            
            return @"限时";
            
        }
            break;
            
            
        default:
            break;
    }
    return nil;


}

-(void)doSelect:(id)sender{

    UIView *viewBar = [self.view viewWithTag:1000];
   UIButton *btn = (UIButton *)sender;
    if (viewBar) {
        
      
        
        for (int i = 10; i < 13; i++) {
            
            UIButton *btn1 = (UIButton *)[viewBar viewWithTag:i];
            if ([btn1 isEqual:btn]) {
                [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }else{
            [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            
        }
        
    }


}

-(void)creatBowwonView{


    UIView *viewBowwonView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 40 - 20, 320.0f, 40)];
    [viewBowwonView setTag:100101];
    [viewBowwonView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:viewBowwonView];
    [viewBowwonView release];
    
    float offset = 320/4;
    for (int i = 0; i < 4; i++) {
        
        MagicUIButton *btnTouch = [[MagicUIButton alloc]initWithFrame:CGRectMake(i * offset, 0.0f, offset, 40)];
        [btnTouch setTag:i + 100];
        [btnTouch setTitle:[self getTitle1:i] forState:UIControlStateNormal];
        [btnTouch addTarget:self action:@selector(doSelectBowwon:) forControlEvents:UIControlEventTouchUpInside];
//        [btnTouch addSignal:[WOSHomeViewController TOUCHBUTTON] forControlEvents:UIControlEventTouchUpInside];
        [viewBowwonView addSubview:btnTouch];
        [btnTouch setBackgroundColor:[UIColor brownColor]];
        RELEASE(btnTouch);
    }
    
    
}
-(void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{


    if ([signal is:[WOSHomeViewController TOUCHBUTTON]]) {
        
        UIView *viewBar = [self.view viewWithTag:100101];
        UIButton *btn = (UIButton *)[signal source];
        if (viewBar) {
            
            for (int i = 100; i < 104; i++) {
                
                UIButton *btn1 = (UIButton *)[viewBar viewWithTag:i];
                if ([btn1 isEqual:btn]) {
                    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }else{
                    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                
                
            }
            
        }
    }
    
}

-(NSString *)getTitle1:(int)index{

    switch (index) {
        case 0:
        {
        
        return @"排序";
        }
            break;
        case 1:
        {
            
            return @"分类";
        }
            break;

        case 2:
        {
            
            return @"热门";
        }
            break;

        case 3:
        {
            
            return @"优惠";
        }
            break;

            
        default:
            break;
    }

}

-(void)doSelectBowwon:(id)sender{

    UIView *viewBar = [self.view viewWithTag:100101];
    UIButton *btn = (UIButton *)sender;
    if (viewBar) {
        
        
        
        for (int i = 100; i < 104; i++) {
            
            UIButton *btn1 = (UIButton *)[viewBar viewWithTag:i];
            if ([btn1 isEqual:btn]) {
                [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }else{
                [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            
        }
        
    }
}

-(void)creatBanner{
    
    //添加最后一张图 用于循环
    int length = arrayResult.count;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < length; i++)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"title%d",i],@"title" ,nil];
        [tempArray addObject:dict];
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
//    if (length > 1)
//    {
//        NSDictionary *dict = [tempArray objectAtIndex:length-1];
//        SGFocusImageItem *item = [[[SGFocusImageItem alloc] initWithDict:dict tag:-1] autorelease];
//        [itemArray addObject:item];
//    }
//    for (int i = 0; i < length; i++)
//    {
//        NSDictionary *dict = [tempArray objectAtIndex:i];
//        SGFocusImageItem *item = [[[SGFocusImageItem alloc] initWithDict:dict tag:i] autorelease];
//        [itemArray addObject:item];
//        
//    }
//    //添加第一张图 用于循环
//    if (length >1)
//    {
//        NSDictionary *dict = [tempArray objectAtIndex:0];
//        SGFocusImageItem *item = [[[SGFocusImageItem alloc] initWithDict:dict tag:length] autorelease];
//        [itemArray addObject:item];
//    }
//
//    [arrayResultTitle];
    NSMutableArray *arrayResultTitle = [[NSMutableArray alloc]init];

    
    
    NSMutableArray *arrayImage = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < arrayResult.count; i ++) {
        [arrayResultTitle addObject:@"6666"];
        [arrayImage addObject:[DYBShareinstaceDelegate addIPImage:[[arrayResult objectAtIndex:i] objectForKey:@"imgUrl"]]];

    }

    
    UIImage *image = [UIImage imageNamed:@"flash.png"];
    
    bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake((320-  image.size.width/2)/2, 44 + 5, image.size.width/2, image.size.height/2) delegate:self imageItems:itemArray isAuto:NO arrayStringTotal:arrayResultTitle arrayImage:arrayImage];
//    [bannerView setCenter:CGPointMake(160.0f, 100)];
//    [bannerView setArrayImage:arrayImage];
    bannerView.delegate = self;
    [bannerView scrollToIndex:1];
    [scrollView addSubview:bannerView];
    [bannerView release];
    RELEASE(arrayImage);
    RELEASE(arrayResultTitle);
}
-(void)goodPrice{

    WOSGoodPriceViewController *good = [[WOSGoodPriceViewController alloc]init];
    [self.drNavigationController pushViewController:good animated:YES];
    RELEASE(good);

}

-(void)goodFood{

    LLSplitViewController *goodFood = [LLSplitViewController getmainController];
    [self.drNavigationController pushViewController:goodFood animated:YES];
    RELEASE(goodFood);

}

-(void)mapViewController{

    WOSMapViewController *map = [[WOSMapViewController alloc]init];
    map.iType = 0;
    [self.drNavigationController pushViewController:map animated:YES];
    RELEASE(map);
}

-(void)youlike{
    WOSThinkYouLikeViewController *like = [[WOSThinkYouLikeViewController alloc]init];
    [self.drNavigationController pushViewController:like animated:YES];
    RELEASE(like);
}

-(void)nearby{
    
    WOSMapViewController *map = [[WOSMapViewController alloc]init];
    map.iType = 1;
    [self.drNavigationController pushViewController:map animated:YES];
    RELEASE(map);

}

-(void)nearbyPeople{

    WOSMapViewController *map = [[WOSMapViewController alloc]init];
    map.iType = 2;
    [self.drNavigationController pushViewController:map animated:YES];
    RELEASE(map);
}

-(void)searchFood{

    WOSFindFoodViewController *find = [[WOSFindFoodViewController alloc]init];
    [self.drNavigationController pushViewController:find animated:YES];
    RELEASE(find);

}

- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
//        DYBUITabbarViewController *dync = [DYBUITabbarViewController sharedInstace];
//        [dync scrollMainView:1];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
        WOSPersonInfoViewController *person = [[WOSPersonInfoViewController alloc]init];
        [self.drNavigationController pushViewController:person animated:YES];
        RELEASE(person);
        
        
    }
    
}


#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        
        if (request.tag == 2) {
            
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 3){
            
            NSDictionary *dict = [request.responseString JSONValue];
            arrayResult  = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"activityList"]];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
//                    [tableView1 reloadData];
                    [self creatBanner];
                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                }
            }
            
        } else{
            NSDictionary *dict = [request.responseString JSONValue];
            NSString *strMSG = [dict objectForKey:@"message"];
            
            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            
            
        }
    }
}


- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index{

    WOSActivityDetailViewController *detail = [[WOSActivityDetailViewController alloc]init];
    detail.dictInfo  = [arrayResult objectAtIndex:index];
    [self.drNavigationController pushViewController:detail animated:YES];
    RELEASE(detail);

}

- (void)dealloc
{
    
    [super dealloc];
}
@end
