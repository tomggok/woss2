//
//  WOSOrderDetailViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-12-24.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSOrderDetailViewController.h"
#import "WOSGoodFoodListCell.h"
#import "WOSTouchStar.h"
#import "WOSOrderCAICell.h"

@interface WOSOrderDetailViewController (){

    DYBUITableView *tbDataBank1;

}

@end

@implementation WOSOrderDetailViewController

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


-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    
    
    DLogInfo(@"name -- %@",signal.name);
    
    
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
        
    {

        
        [self.headview setTitle:@"订单详情"];
        
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        
        [self.view setBackgroundColor:ColorBG];
        [self setButtonImage:self.leftButton setImage:@"back"];
        
        
        
    }
    
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(10.0f, self.headHeight + 10.0f, 300.0f, CGRectGetHeight(self.view.frame) - self.headHeight - 10 -10 - 20)];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        UIImageView *imageViewIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 80, 70)];
        [imageViewIcon setBackgroundColor:[UIColor redColor]];
        [imageViewIcon setImage:[UIImage imageNamed:@"food1.png"]];
        [viewBG addSubview:imageViewIcon];
        RELEASE(imageViewIcon);
        
        UILabel *labelNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 3, 5, 100, 15)];
        [labelNum setBackgroundColor:[UIColor clearColor]];
        [labelNum setTextColor:[UIColor blackColor]];
        [labelNum setText:[NSString stringWithFormat:@"海底捞火锅"]];
        [viewBG addSubview:labelNum];
        RELEASE(labelNum);
        
    
        UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 3,  24, 150, 15)];
        [labelTime setTextColor:[UIColor blackColor]];
        [labelTime setBackgroundColor:[UIColor clearColor]];
        [labelTime setText:@"订单状态处理中"];
        [viewBG addSubview:labelTime];
        RELEASE(labelTime);
        
        
        
        UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 +3,  CGRectGetHeight(labelTime.frame) + 5 + 7 + CGRectGetMinY(labelTime.frame) , 100, 15)];
        [labelPrice setText:@"总额：￥93"];
        [labelPrice setTextColor:[UIColor colorWithRed:246/255.0f green:46/255.0f blue:9/255.0f alpha:1.0f]];
        [labelPrice setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelPrice];
        RELEASE(labelPrice);

//        
//        WOSTouchStar *touch = [[WOSTouchStar alloc]initWithFrame:CGRectMake(200.0f, 50.0f, 100.0f, 50.0f)];
//        [viewBG addSubview:touch];
//        RELEASE(touch);
//        
        
        UIImageView *Line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  CGRectGetHeight(labelPrice.frame) + CGRectGetMinY(labelPrice.frame)+10 +3 , 300, 0.5)];
        [Line1 setBackgroundColor:[UIColor clearColor]];
        [Line1 setImage:[UIImage imageNamed:@"class_dotline"]];
        [viewBG addSubview:Line1];
        RELEASE(Line1);
        

        
        UILabel *labelTIme= [[UILabel alloc]initWithFrame:CGRectMake(10,  CGRectGetHeight(Line1.frame) + 5 + 7 + CGRectGetMinY(Line1.frame) , 300, 22)];
        [labelTIme setText:@"订单时间：2013-12-11 10:01"];
        [labelTIme setTextColor:[UIColor blackColor]];
        [labelTIme setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelTIme];
        RELEASE(labelTIme);
        
        
        UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(10,  CGRectGetHeight(labelTIme.frame) + 5 + 7 + CGRectGetMinY(labelTIme.frame) , 300, 22)];
        [labelAddr setText:@"送餐地址：上海市区杨浦区国康路100号21楼"];
        [labelAddr setTextColor:[UIColor blackColor]];
        [labelAddr setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelAddr];
        RELEASE(labelAddr);
   
        
        UILabel *labelResque = [[UILabel alloc]initWithFrame:CGRectMake(10,  CGRectGetHeight(labelAddr.frame) + 5 + 7 + CGRectGetMinY(labelAddr.frame) , 300, 22)];
        [labelResque setText:@"响应时间：2013-12-12 10:01"];
        [labelResque setTextColor:[UIColor colorWithRed:246/255.0f green:46/255.0f blue:9/255.0f alpha:1.0f]];
        [labelResque setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelResque];
        RELEASE(labelResque);

        
        UIImageView *Line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  CGRectGetHeight(labelResque.frame) + 3 + 7 + CGRectGetMinY(labelResque.frame), 300, 0.5)];
        [Line2 setBackgroundColor:[UIColor clearColor]];
        [Line2 setImage:[UIImage imageNamed:@"class_dotline"]];
        [viewBG addSubview:Line2];
        RELEASE(Line2);
        
        
        
        tbDataBank1 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0.0f,  CGRectGetHeight(labelResque.frame) + 5 + 7 + CGRectGetMinY(labelResque.frame) + 2, 300.0f, 6*40) isNeedUpdate:YES];
        
        [tbDataBank1 setTableViewType:DTableViewSlime];
        
        [viewBG addSubview:tbDataBank1];
        
        RELEASE(tbDataBank1);
        
        [tbDataBank1 setBackgroundColor:[UIColor clearColor]];
                
        [viewBG setBackgroundColor:[UIColor whiteColor]];

    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
                
        DLogInfo(@"rrr");
        
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
    
}




- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSNumber *s = [NSNumber numberWithInteger:5];
        [signal setReturnValue:s];
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath
    {
        
        
        
        [signal setReturnValue:[NSNumber numberWithInteger:80]];
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
        //        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        
        
        WOSOrderCAICell *cell = [[WOSOrderCAICell alloc]init];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
//        WOShopDetailViewController *shop = [[WOShopDetailViewController alloc]init];
//        [self.drNavigationController pushViewController:shop animated:YES];
//        RELEASE(shop);
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]) //刷新
    {
        //        MagicUIUpdateView *uptableview = (MagicUIUpdateView *)[signal object];
        
        
    }else if([signal is:[MagicUITableView TAbLEVIEWLODATA]]) //加载更多
    {
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){ //上滑动
        
        //        [tbDataBank StretchingUpOrDown:0];
        //        [DYBShareinstaceDelegate opeartionTabBarShow:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){ //下滑动
        
        //        [tbDataBank StretchingUpOrDown:1];
        //        [DYBShareinstaceDelegate opeartionTabBarShow:NO];
    }
    
}




#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    
    [super dealloc];
}
@end
