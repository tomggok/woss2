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
#import "JSONKit.h"
#import "JSON.h"
#import "WOSOrderDetailTableViewCell.h"


@interface WOSOrderDetailViewController (){

    DYBUITableView *tbDataBank1;
    NSDictionary *dictResult;
    NSMutableArray *arrayResult;
}

@end

@implementation WOSOrderDetailViewController
@synthesize dictInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)creatView:(NSDictionary *)dict{
    [self setBackgroundColor:[UIColor clearColor]];
    dictResult = [[NSDictionary alloc]init];
    
  
    
    MagicRequest *request = [DYBHttpMethod wosFoodInfo_orderinfo_userIndex:SHARED.userId orderIndex:[dictInfo objectForKey:@"orderIndex"] sAlert:YES receive:self];
    [request setTag:3];
    
    
    
    UIView *viewBG = [[UIView alloc]initWithFrame:self.frame];
    [viewBG setBackgroundColor:[UIColor blackColor]];
    [viewBG setAlpha:0.8];
    [self addSubview:viewBG];
    RELEASE(viewBG);
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12, 48/2, 56/2, 56/2)];
    [btn addTarget:self action:@selector(doHidden) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"返回键"] forState:UIControlStateNormal];
    [self addSubview:btn];
    RELEASE(btn);
    
    UILabel *labelNum = [[UILabel alloc]initWithFrame:CGRectMake(146/2, 146/2, 100, 15)];
    [labelNum setBackgroundColor:[UIColor clearColor]];
    [labelNum setCenter:CGPointMake(160, 146/2 + 15)];
    [labelNum setTextColor:[UIColor colorWithRed:40.0f/255 green:191.0f/255 blue:140.0f/255 alpha:1.0f]];
    [labelNum setText:[dictInfo objectForKey:@"kitchenName"]];
    [labelNum setCenter:CGPointMake(160 + 20, 150/2 + 15)];
    [self addSubview:labelNum];
    RELEASE(labelNum);
    
    
    tbDataBank1 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0.0f,  CGRectGetHeight(labelNum.frame) + 5 + 7 + CGRectGetMinY(labelNum.frame) + 2, 300.0f, 6*40) isNeedUpdate:YES];
    [tbDataBank1 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tbDataBank1 setTableViewType:DTableViewSlime];
    [tbDataBank1 setBackgroundColor:[UIColor clearColor]];
    [self addSubview:tbDataBank1];
    
    RELEASE(tbDataBank1);
    
    [tbDataBank1 setBackgroundColor:[UIColor clearColor]];
    
    
    UIImageView *Line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  CGRectGetHeight(tbDataBank1.frame) + CGRectGetMinY(tbDataBank1.frame)+10 +3 , 300, 0.5)];
    [Line1 setBackgroundColor:[UIColor clearColor]];
    [Line1 setImage:[UIImage imageNamed:@"class_dotline"]];
    [viewBG addSubview:Line1];
    RELEASE(Line1);
    

    
    UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(456/2,  CGRectGetHeight(tbDataBank1.frame) + 5 + 7 + CGRectGetMinY(tbDataBank1.frame) + 4 , 100, 15)];
    
    NSString *strTotal = [[dictInfo objectForKey:@"totalSum"] stringValue];
    [labelPrice setText:[NSString stringWithFormat:@"￥ %@",strTotal]];
    [labelPrice setTextColor:[UIColor colorWithRed:246/255.0f green:46/255.0f blue:9/255.0f alpha:1.0f]];
    [labelPrice setTextColor:[UIColor whiteColor]];

    [labelPrice setBackgroundColor:[UIColor clearColor]];
    [self addSubview:labelPrice];
    RELEASE(labelPrice);
    
    
    
    
    
//    [viewBG setBackgroundColor:[UIColor whiteColor]];

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
        
        
        
        [signal setReturnValue:[NSNumber numberWithInteger:30]];
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
        
        
        
        WOSOrderDetailTableViewCell *cell = [[WOSOrderDetailTableViewCell alloc]init];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell creatCell:[arrayResult objectAtIndex:indexPath.row]];
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


- (void)didReceiveMemoryWarning
{
//    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    
    [super dealloc];
}



#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        if (request.tag == 3) {
            
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    dictResult = dict;
                    arrayResult = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"orderDetails"]];
                    
//                    [arrayAddrList removeObjectAtIndex:delIndex];
                    [tbDataBank1 reloadData];
                    
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }
    }
}

-(void)doHidden{

    [self removeFromSuperview];
    
}
@end
