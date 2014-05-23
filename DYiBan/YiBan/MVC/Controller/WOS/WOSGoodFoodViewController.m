//
//  WOSGoodFoodViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-12-4.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSGoodFoodViewController.h"
#import "WOSGoodFoodDownView.h"
#import "WOSPersonInfoViewController.h"
#import "WOSGoodFoodListCell.h"
#import "WOShopDetailViewController.h"
#import "leftViewController.h"
#import "LLSplitViewController.h"

#import "JSONKit.h"
#import "JSON.h"

@interface WOSGoodFoodViewController (){
    
    MagicUITableView *tbleView;
    WOSGoodFoodDownView *downView;
    UILabel *labelTopName;
    UILabel *labelTopName1;
    NSMutableArray *arrayInfoForCai;
    
    int page;
    int count;
}

@end

@implementation WOSGoodFoodViewController

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

static WOSGoodFoodViewController *shareStance = nil;
+(WOSGoodFoodViewController *)creatObj{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareStance == nil) {
            shareStance = [[WOSGoodFoodViewController alloc]init];
        }
    });
    return shareStance;
}

-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        //        [self.rightButton setHidden:YES];
              [self.headview setTitle:@"中餐"];
        [self.headview setTitleColor:[UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f]];
//        [self.headview setBackgroundColor:[UIColor redColor]];
        [self.view setBackgroundColor:ColorBG];
        
         [self setButtonImage:self.rightButton setImage:@"home 2"];
         [self setButtonImage:self.leftButton setImage:@"list 2"];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        page = 0;
        count = 2;
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        [self creatLeftTopView];
        
        [self creatRightTopView];
        
//        arrayInfoForCai = [[NSMutableArray alloc]init];
        
        MagicRequest *request = [DYBHttpMethod wosgoodFood_typeIndex:@"1" orderBy:@"1" page:@"0" count:@"4" orderType:@"1"  sAlert:YES receive:self];
        [request setTag:3];

        
        
        tbleView = [[MagicUITableView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight + 30, 320,self.view.frame.size.height - 74 ) isNeedUpdate:YES];
//        tableView setTableViewType:
        [tbleView setTableViewType:DTableViewSlime];
        [tbleView setBackgroundColor:ColorBG];
        [tbleView setSeparatorColor:[UIColor clearColor]];
        [self.view addSubview:tbleView];
        RELEASE(tbleView)
        
    }
    
    
    else if ([signal is:[MagicViewController WILL_APPEAR]]) {
          [self.navigationController.navigationBar setHidden:YES];
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}


-(void)reSetData:(NSString *)name{

    [self.headview setTitle:name];

    
    NSString *path1  = [[NSBundle mainBundle] pathForResource:@"FoodList" ofType:@"plist"];
    NSMutableDictionary *idataList = [[NSMutableDictionary alloc] initWithContentsOfFile:path1];

    NSString *strCode = [[idataList objectForKey:@"New item"] objectForKey:name];
    
    if (strCode) {
        
        MagicRequest *request = [DYBHttpMethod wosgoodFood_typeIndex:strCode orderBy:@"1" page:@"0" count:@"4" orderType:@"1"  sAlert:YES receive:self];
        [request setTag:3];
    }
    
}

-(void)creatRightTopView{

    UIButton *btnTop = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 160.0f, 30)];
    [btnTop addTarget:self action:@selector(showORHideDownView) forControlEvents:UIControlEventTouchUpInside];
    [btnTop setBackgroundColor:[UIColor colorWithRed:26/255.0f green:26/255.0f blue:26/255.0f alpha:1.0f]];
    [self.view addSubview:btnTop];
    RELEASE(btnTop);
    
    labelTopName = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 0.0f, 100.0f, 30.0f)];
    [labelTopName setTextColor:ColorGryWhite];
    [labelTopName setTag:90];
    [labelTopName setText:@"排序条件"];
    [labelTopName setBackgroundColor:[UIColor clearColor]];
    [btnTop addSubview:labelTopName];
    RELEASE(labelTopName);

    UIImage *image = [UIImage imageNamed:@"arrow_down"];
    UIImageView *imageViewRight = [[UIImageView alloc]initWithFrame:CGRectMake(120.0f, (30 - image.size.height/2)/2, image.size.width/2, image.size.height/2)];
    [imageViewRight setTag:910];
    [imageViewRight setImage:[UIImage imageNamed:@"arrow_down"]];
    [btnTop addSubview:imageViewRight];
    RELEASE(imageViewRight);

}


-(void)showORHideDownView{

//    return;
    
    if (!downView) {
        downView = [[WOSGoodFoodDownView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight + 30, 320.0, 200.0f)];
        
        [self.view addSubview:downView];
        RELEASE(downView);
        
//        UILabel *lableName = (UILabel *)[self.view viewWithTag:90];
//        [lableName setTextColor:[UIColor colorWithRed:210.0f/255 green:91.0f/255 blue:61.0f/255 alpha:1.0f]];
        
        UIImageView *imageViewDown = (UIImageView *)[self.view viewWithTag:91];
        [imageViewDown setImage:[UIImage imageNamed:@"arrowup"]];
        
    }else{
    
        if (downView.hidden) {
            
            [downView setHidden:NO];
            
//            UILabel *lableName = (UILabel *)[self.view viewWithTag:90];
//            [lableName setTextColor:[UIColor colorWithRed:210.0f/255 green:91.0f/255 blue:61.0f/255 alpha:1.0f]];
            
            UIImageView *imageViewDown = (UIImageView *)[self.view viewWithTag:91];
            [imageViewDown setImage:[UIImage imageNamed:@"arrowup"]];

        }else{
        
            [downView setHidden:YES];
            
//            UILabel *lableName = (UILabel *)[self.view viewWithTag:90];
//            [lableName setTextColor:ColorGryWhite];
            
            UIImageView *imageViewDown = (UIImageView *)[self.view viewWithTag:91];
            [imageViewDown setImage:[UIImage imageNamed:@"arrow_down"]];

        }
    }
   

}


-(void)creatLeftTopView{
    
    UIButton *btnTop = [[UIButton alloc]initWithFrame:CGRectMake(160.0f, self.headHeight, 160.0f, 30)];
    [btnTop addTarget:self action:@selector(showORHideDownView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTop];
    [btnTop setBackgroundColor:[UIColor colorWithRed:26/255.0f green:26/255.0f blue:26/255.0f alpha:1.0f]];
    RELEASE(btnTop);
    
    labelTopName1 = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 0.0f, 100.0f, 30.0f)];
    [labelTopName1 setTextColor:ColorGryWhite];
    [labelTopName1 setTag:92];
    [labelTopName1 setText:@"按价格"];
    [labelTopName1 setBackgroundColor:[UIColor clearColor]];
    [btnTop addSubview:labelTopName1];
    RELEASE(labelTopName1);
    
    UIImage *image = [UIImage imageNamed:@"arrow_down"];
    UIImageView *imageViewRight = [[UIImageView alloc]initWithFrame:CGRectMake(120.0f, (30 - image.size.height/2)/2,image.size.width/2, image.size.height/2)];
    [imageViewRight setTag:91];
    [imageViewRight setImage:[UIImage imageNamed:@"arrow_down"]];
    [btnTop addSubview:imageViewRight];
    RELEASE(imageViewRight);

}


-(void)sortPrice{

    if (downView) {
        [downView setHidden:YES];
        
        UILabel *lableName = (UILabel *)[self.view viewWithTag:90];
        [lableName setTextColor:ColorGryWhite];
        
        UIImageView *imageViewDown = (UIImageView *)[self.view viewWithTag:91];
        [imageViewDown setImage:[UIImage imageNamed:@"arrow_down"]];
    }


}



- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSNumber *s = [NSNumber numberWithInteger:arrayInfoForCai.count];
        [signal setReturnValue:s];
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath
    {
        
        
        
        [signal setReturnValue:[NSNumber numberWithInteger:100]];
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
        UITableView *tableView = [dict objectForKey:@"tableView"];
        static NSString *reuseIdentifier = @"reuseIdentifier";
        
        WOSGoodFoodListCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        if (cell == nil) {
            cell = [[WOSGoodFoodListCell alloc]init];
        }
        
        [cell initRow:[arrayInfoForCai objectAtIndex:indexPath.row]];
        [cell setBackgroundColor:ColorBG];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        WOShopDetailViewController *shop = [[WOShopDetailViewController alloc]init];
        shop.dictInfo = [arrayInfoForCai objectAtIndex:indexPath.row];
        [self.drNavigationController pushViewController:shop animated:YES];
        RELEASE(shop);
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]) //刷新
    {
        //        MagicUIUpdateView *uptableview = (MagicUIUpdateView *)[signal object];
        MagicRequest *request = [DYBHttpMethod wosgoodFood_typeIndex:@"1" orderBy:@"1" page:@"0" count:@"4" orderType:@"1"  sAlert:YES receive:self];
        [request setTag:3];
        
    }else if([signal is:[MagicUITableView TAbLEVIEWLODATA]]) //加载更多
    {
        MagicRequest *request = [DYBHttpMethod wosgoodFood_typeIndex:@"1" orderBy:@"1" page:@"0" count:@"8" orderType:@"1"  sAlert:YES receive:self];
        [request setTag:3];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){ //上滑动
        
        //        [tbDataBank StretchingUpOrDown:0];
        //        [DYBShareinstaceDelegate opeartionTabBarShow:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){ //下滑动
        
        //        [tbDataBank StretchingUpOrDown:1];
        //        [DYBShareinstaceDelegate opeartionTabBarShow:NO];
    }
    
}


- (void)handleViewSignal_WOSGoodFoodDownView:(MagicViewSignal *)signal{

    if ([signal is:[WOSGoodFoodDownView SELECTCELL]]) {
        
        NSString *title = (NSString *)[signal object];
        
        [labelTopName1 setText:title];
        
        UIView *view = [signal source];
        [view setHidden:YES];
        
        
    }else if ( [signal is:[WOSGoodFoodDownView SELECTCELLCAIXI]]){
    
        NSString *title = (NSString *)[signal object];
        [labelTopName1 setText:title];
    }

}


- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {

        LLSplitViewController *splite = [LLSplitViewController getmainController];
        [splite showLeftView:YES];

    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
        LLSplitViewController *splite = [LLSplitViewController getmainController];
        [splite backPop];
        
    }
}


- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        //        JsonResponse *response = (JsonResponse *)receiveObj;
         if(request.tag == 3){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
                    arrayInfoForCai = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"kitchenList"]];
                    [tbleView reloadData];
                    
                    BOOL bHaveNext = [[dict objectForKey:@"havenext"] boolValue];
                    
                    if (bHaveNext == 1) {
                        [tbleView reloadData:NO];
                    }else{
                        [tbleView reloadData:YES];
                    }

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



- (void)dealloc
{
    
    [super dealloc];
}
@end
