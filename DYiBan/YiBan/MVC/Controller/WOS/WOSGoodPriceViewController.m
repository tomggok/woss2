//
//  WOSGoodPriceViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-12-24.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSGoodPriceViewController.h"
#import "WOSGoodFoodListCell.h"
#import "WOSALLOrderViewController.h"
#import "WOSGoodPriceCell.h"
#import "JSONKit.h"
#import "JSON.h"

@interface WOSGoodPriceViewController (){

    MagicUITableView *tableView1;
    NSMutableArray *arrayRestlut;
    int iType;
}

@end

@implementation WOSGoodPriceViewController

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
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        [self.headview setTitle:@"今日特价"];
        
        [self.headview setTitleColor:[UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f]];
        
        [self.view setBackgroundColor:ColorBG];
       [self setButtonImage:self.leftButton setImage:@"back"];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        iType = 0;
        
        for (int i = 0; i< 2; i ++) {
            
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0.0f + i*320/2 + i*1, self.headHeight, 320/2, 30)];
            //            [btn1 setTitle:@"处理中" forState:UIControlStateNormal];
            [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn1 setTitleColor:ColorGryWhite forState:UIControlStateNormal];
            switch (i) {
                case 0:
                    [btn1 setTitle:@"今日特价" forState:UIControlStateNormal];
                    if (iType == 0) {
                        [btn1 setTitleColor:ColorTextYellow forState:UIControlStateNormal];
                    }
                    
                    break;
                case 1:
                    [btn1 setTitle:@"热门推荐" forState:UIControlStateNormal];
                    if (iType == 1) {
                        [btn1 setTitleColor:ColorTextYellow forState:UIControlStateNormal];
                    }
                    break;
                case 2:
                    [btn1 setFrame:CGRectMake(0.0f + i*320/3 + i *0.5 , self.headHeight, 320/3, 30)];
                    [btn1 setTitle:@"附近的人在吃" forState:UIControlStateNormal];
                    if (iType == 2) {
                        [btn1 setTitleColor:ColorTextYellow forState:UIControlStateNormal];
                    }
                    break;
                    
                default:
                    break;
            }
            
            
            [btn1 setBackgroundColor:[UIColor blackColor]];
            [btn1 addTarget:self action:@selector(doSelect:) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTag:10 + i];
            [self.view addSubview:btn1];
            RELEASE(btn1);
            
        }
        
        
        MagicRequest *request = [DYBHttpMethod wosFoodInfo_foodDiscount_kitchenIndex:@"" discountDay:@"1" page:@"0" count:@"3" sAlert:YES receive:self];
        [request setTag:3];
        
        
        tableView1 = [[MagicUITableView alloc]initWithFrame:CGRectMake(0.0f, 30 + self.headHeight , 320,self.view.frame.size.height - 30 - self.headHeight)];
        [tableView1 setBackgroundColor:ColorBG];
        [tableView1 setSeparatorColor:[UIColor clearColor]];
        [self.view addSubview:tableView1];
        RELEASE(tableView1);
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}


- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSNumber *s = [NSNumber numberWithInteger:arrayRestlut.count];
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
        
        WOSGoodPriceCell *cell = [[WOSGoodPriceCell alloc]init];
        cell.targetObj = self;
        [cell creatView:[arrayRestlut objectAtIndex:indexPath.row]];
        [cell setBackgroundColor:ColorBG];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        WOSALLOrderViewController *shop = [[WOSALLOrderViewController alloc]init];
        shop.dictInfo = [arrayRestlut objectAtIndex:indexPath.row];
        [self.drNavigationController pushViewController:shop animated:YES];
        RELEASE(shop);
        
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
        [self.drNavigationController popViewControllerAnimated:YES];
        
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
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
    
    if (btn.tag == 10) {
        
        MagicRequest *request = [DYBHttpMethod wosFoodInfo_foodDiscount_kitchenIndex:@"" discountDay:@"1" page:@"0" count:@"3" sAlert:YES receive:self];
        [request setTag:3];
        [self.headview setTitle:@"今日特价"];

        
    }else{
    
        MagicRequest *request = [DYBHttpMethod wosFoodInfo_foodDiscount_kitchenIndex:@"" discountDay:@"1" page:@"0" count:@"3" sAlert:YES receive:self];
        [request setTag:3];
        
        [self.headview setTitle:@"热门推荐"];
    }
    
    
      UIView *viewB = [self.view viewWithTag:1000];
    if (viewB) {
        [viewB setHidden:YES];
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
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
                    //                    _dictInfo = dict;
                    //                    [DYBShareinstaceDelegate popViewText:@"收藏成功！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    //
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 3){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    arrayRestlut = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"foodList"]];
                    [tableView1 reloadData];
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
