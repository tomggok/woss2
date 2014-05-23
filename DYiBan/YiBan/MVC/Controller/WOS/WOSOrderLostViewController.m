//
//  WOSOrderLostViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-12-24.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSOrderLostViewController.h"
#import "Cell2.h"
#import "WOSGoodFoodListCell.h"
#import "WOSOrderListCell.h"
#import "WOSOrderDetailViewController.h"
#import "JSONKit.h"
#import "JSON.h"



@interface WOSOrderLostViewController (){

    DYBUITableView *tbDataBank1;
    NSMutableArray *arrayResult;
    int orderStatus;
}

@end

@implementation WOSOrderLostViewController

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
        
        [self.headview setTitle:@"订单管理"];
        
        
        
        [self.headview setTitleColor:[UIColor whiteColor]];
        [self setButtonImage:self.leftButton setImage:@"返回键"];
        [self.view setBackgroundColor:ColorBG];
        [self.headview setBackgroundColor:[UIColor colorWithRed:40.0f/255 green:191.0f/255 blue:140.0f/255 alpha:1.0f]];
    }
    
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {

        [self.rightButton setHidden:YES];
        
        
        
        [self.view setBackgroundColor:[UIColor clearColor]];

        orderStatus = 0;
        
        MagicRequest *request = [DYBHttpMethod wosKitchenInfo_orderList_userIndex:SHARED.userId page:@"0" count:[NSString stringWithFormat:@"%d",10] status:@"" sAlert:YES receive:self];
        [request setTag:3];
        
        tbDataBank1 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0.0f,  self.headHeight , 320.0f, self.view.frame.size.height - self.headHeight) isNeedUpdate:NO];
        
        [tbDataBank1 setSeparatorColor:[UIColor clearColor]];
        [tbDataBank1 setTableViewType:DTableViewSlime];
        [tbDataBank1 setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:tbDataBank1];
        RELEASE(tbDataBank1);        

    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {

        DLogInfo(@"rrr");
        
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
    
}

-(void)doSelect:(id)sender{

    UIButton *btn = (UIButton *)sender;
    for (int i = 10; i < 13; i++) {
        
        
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:i];
        if (i == btn.tag) {
            
            [btn1 setTitleColor:ColorTextYellow forState:UIControlStateNormal];
        }else{
            
            [btn1 setTitleColor:ColorGryWhite forState:UIControlStateNormal];
        }
    }
    
    MagicRequest *request = [DYBHttpMethod wosKitchenInfo_orderList_userIndex:SHARED.userId page:@"0" count:[NSString stringWithFormat:@"%d",btn.tag - 10] status:@"0" sAlert:YES receive:self];
    [request setTag:3];
    
    //        0/1/2/3：备餐中/送餐中/已收货/取消
}

-(void)backMan{
    
    
    
//    WOSLogInViewController *login = [[WOSLogInViewController alloc]init];
//    [self.drNavigationController pushViewController:login animated:YES];
//    RELEASE(login);
    
    
    
}


- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
        
    {
        
        NSNumber *s = [NSNumber numberWithInteger:arrayResult.count];
        
        [signal setReturnValue:s];

    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
        
    {
        
        NSNumber *s = [NSNumber numberWithInteger:1];
        
        [signal setReturnValue:s];

    }
    
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath
        
    {
        
        [signal setReturnValue:[NSNumber numberWithInteger:90]];
        
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
        WOSOrderListCell *cell = [[WOSOrderListCell alloc]init];
        [cell setBackgroundColor:ColorBG];
        [cell creat:[arrayResult objectAtIndex:indexPath.row]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
        
    {
                
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
           
        WOSOrderDetailViewController *detail = [[WOSOrderDetailViewController alloc]initWithFrame:self.drNavigationController.view.frame];
        detail.dictInfo = [arrayResult objectAtIndex:indexPath.row];
        [detail creatView:[arrayResult objectAtIndex:indexPath.row]];

        [detail setBackgroundColor:[UIColor clearColor]];
//        [detail setAlpha:0.9];
        [self.drNavigationController.view addSubview:detail];
        RELEASE(detail);
        
        
        
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



- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal

{
    
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
        
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
        
    {
        
    }
    
}




#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        //        JsonResponse *response = (JsonResponse *)receiveObj;
        if (request.tag == 2) {
            
            
            NSDictionary *dict = [request.responseString JSONValue];
            
//            if (dict) {
//                BOOL result = [[dict objectForKey:@"result"] boolValue];
//                if (!result) {
//                    
//                    
//                    self.DB.FROM(USERMODLE)
//                    .SET(@"userInfo", request.responseString)
//                    .SET(@"userIndex",[dict objectForKey:@"userIndex"])
//                    .INSERT();
//                    
//                    SHARED.userId = [dict objectForKey:@"userIndex"]; //设置userid 全局变量
//                    
//                    DYBUITabbarViewController *vc = [[DYBUITabbarViewController sharedInstace] init:self];
//                    
//                    [self.drNavigationController pushViewController:vc animated:YES];
//                    
//                }else{
//                    NSString *strMSG = [dict objectForKey:@"message"];
//                    
//                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
//                    
//                    
//                }
//            }
        }else if(request.tag == 3){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
//                    NSDictionary *dictResult = [dict objectForKey:@"orderList"];
                    arrayResult = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"orderList"]];
                    [tbDataBank1 reloadData];
//                    UIButton *btn = (UIButton *)[UIButton buttonWithType:UIButtonTypeCustom];
//                    [btn setTag:10];
//                    [self doChange:btn];
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
