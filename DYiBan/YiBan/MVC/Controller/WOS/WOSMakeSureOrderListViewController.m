//
//  WOSMakeSureOrderListViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-12-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSMakeSureOrderListViewController.h"
#import "orderModel.h"
#import "WOSOrderLastViewController.h"
#import "WOSCalculateOrder.h"

@interface WOSMakeSureOrderListViewController (){
 
    DYBUITableView *tbDataBank1;
    NSMutableArray *arrayOrderList;
    NSMutableDictionary *dictInfoList;
    NSMutableDictionary *dictNum;

    UILabel *price;
    UILabel *priceServer;
//    UILabel *labelOrderotal;
    UILabel *priceTotal;
}

@end

@implementation WOSMakeSureOrderListViewController

@synthesize arrayAddInfo = _arrayAddInfo,dictInfo = _dictInfo;;

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
        //        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"购物车"];
        [self.headview setTitleColor:[UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f]];
//
//        [self setButtonImage:self.rightButton setImage:@"btn_more_def"];
        
        [self setButtonImage:self.leftButton setImage:@"back"];
        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        

        
        dictInfoList = [[NSMutableDictionary alloc]init];
        dictNum  = [[NSMutableDictionary alloc]init];
        
        for (int i = 0; i < _arrayAddInfo.count; i++) {
            
            NSDictionary *dict = [_arrayAddInfo objectAtIndex:i];
            NSString *strFoodIndex = [dict objectForKey:@"foodIndex"];
            
            [dictInfoList setValue:dict forKey:strFoodIndex];
            
            NSArray *allKeyNum = [dictNum allKeys];
            
            if ([allKeyNum containsObject:strFoodIndex]) {
                
                int num = [[dictNum objectForKey:strFoodIndex]integerValue] ;
                num ++ ;
                [dictNum setValue:[NSString stringWithFormat:@"%d",num] forKey:strFoodIndex];
                
            }else{
            
                [dictNum setValue:[NSString stringWithFormat:@"%d",1] forKey:strFoodIndex];
            }
            
        }
        
        
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setBackgroundColor:ColorBG];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 15, 280, self.view.frame.size.height - 200)];
        [view1 setBackgroundColor:[UIColor whiteColor]];
        [viewBG addSubview:view1];
        RELEASE(view1);
        
        
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 150.0, 40.0f)];
        [labelName setBackgroundColor:[UIColor clearColor]];
        [labelName setText:@"海底捞牡丹江店"];
        [view1 addSubview:labelName];
        RELEASE(labelName);

        
        UIImageView *iamgeView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44 + 10 , 280, 1)];
        [iamgeView1 setBackgroundColor:[UIColor clearColor]];
        [iamgeView1 setImage:[UIImage imageNamed:@"class_dotline"]];
        [view1 addSubview:iamgeView1];
        RELEASE(iamgeView1);
        
        
        arrayOrderList = [[NSMutableArray alloc]init];
        
        
        for (int i = 0; i < dictInfoList.allKeys.count; i++) {
            
            NSArray *arrayAllKey = dictInfoList.allKeys;
            NSString *foodIndex = [arrayAllKey objectAtIndex:i];
            
            NSDictionary *dict = [dictInfoList objectForKey:foodIndex];
            
            orderModel *order1 = [[orderModel alloc]init];
            order1.name = [dict objectForKey:@"foodName"];
            order1.num = [[dictNum objectForKey:[dict objectForKey:@"foodIndex"]] integerValue] ;
            order1.price = [[dict objectForKey:@"foodPrice"] integerValue];
            
            [arrayOrderList addObject:order1];
            
        }
               
        
        
        tbDataBank1 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0.0f,  44 + 20, 280, self.view.frame.size.height - SEARCHBAT_HIGH - 44 - 20 - 270 ) isNeedUpdate:YES];
        
        [view1 addSubview:tbDataBank1];
        [tbDataBank1 setSeparatorColor:[UIColor clearColor]];
        RELEASE(tbDataBank1);
        
        
        
        UIImageView *iamgeView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, 44 + 20 + CGRectGetHeight(tbDataBank1.frame)  + 10, 240, 1)];
        [iamgeView2 setBackgroundColor:[UIColor grayColor]];
        [view1 addSubview:iamgeView2];
        RELEASE(iamgeView2);
        
        [self creatLabel];
        
        UIImage *image1 = [UIImage imageNamed:@"button_l"];
        
        UIButton *btnNext = [[UIButton alloc]initWithFrame:CGRectMake((320 - image1.size.width/2)/2, CGRectGetHeight(view1.frame) + CGRectGetMinY(view1.frame)  + 20 , image1.size.width/2, image1.size.height/2)];
        [btnNext setImage:image1 forState:UIControlStateNormal];
        [btnNext setTitle:@"下一步" forState:UIControlStateNormal];
        [btnNext setBackgroundColor:[UIColor redColor]];
        
        [self addlabel_title:@"下一步" frame:btnNext.frame view:btnNext];
        
        [btnNext addTarget:self action:@selector(doNext) forControlEvents:UIControlEventTouchUpInside];
        [viewBG addSubview:btnNext];
        RELEASE(btnNext);
        
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

-(void)doNext{

    WOSOrderLastViewController *lastViewController = [[WOSOrderLastViewController alloc]init];
    lastViewController.fTotalPrice = priceTotal.text.floatValue;
    lastViewController.dictInfo = _dictInfo;
    [self.drNavigationController pushViewController:lastViewController animated:YES];
    RELEASE(lastViewController);

}

-(void)creatLabel{

    float totalPrice = 0;
    for (int i = 0; i < arrayOrderList.count;i ++ ) {
        int num = 0;
        orderModel *order = [arrayOrderList objectAtIndex:i];
            
            
            num = order.num;
        float fPrice = order.price;
        
        totalPrice = num * fPrice + totalPrice;
    }
   
    
    UILabel *labelOrder = [[UILabel alloc]initWithFrame:CGRectMake(120.0f, CGRectGetMinY(tbDataBank1.frame) + CGRectGetHeight(tbDataBank1.frame) + 100, 90.0f, 40.0f)];
    [labelOrder setText:@"菜品费用："];
    [labelOrder sizeToFit];
    [self.view addSubview:labelOrder];
    RELEASE(labelOrder);
    
    price = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelOrder.frame) + CGRectGetWidth(labelOrder.frame), CGRectGetMinY(tbDataBank1.frame) + CGRectGetHeight(tbDataBank1.frame) + 90, 90, 40)];
    price.text = [NSString stringWithFormat:@"%.1f",totalPrice];
    [self.view addSubview:price];
    RELEASE(price);
    
    UILabel *labelOrderServer = [[UILabel alloc]initWithFrame:CGRectMake(120.0f, CGRectGetMinY(labelOrder.frame) + CGRectGetHeight(labelOrder.frame) + 10, 100.0f, 40.0f)];
    [labelOrderServer setText:@"送餐费用："];
   
    [labelOrderServer sizeToFit];
    [self.view addSubview:labelOrderServer];
    RELEASE(labelOrderServer);
    
   priceServer = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelOrderServer.frame) + CGRectGetWidth(labelOrderServer.frame) , CGRectGetMinY(labelOrder.frame) + CGRectGetHeight(labelOrder.frame) + 0, 90, 40)];
//    [priceServer sizeToFit];
    [priceServer setText:@"12.0"];
    [self.view addSubview:priceServer];
    RELEASE(priceServer);


    UILabel *labelOrderTotal = [[UILabel alloc]initWithFrame:CGRectMake(120.0f, CGRectGetMinY(labelOrderServer.frame) + CGRectGetHeight(labelOrderServer.frame) + 10, 100.0f, 40.0f)];
    [labelOrderTotal setText:@"总计费用："];
    [self.view addSubview:labelOrderTotal];
    
    [labelOrderTotal sizeToFit];
    RELEASE(labelOrderTotal);
    
    priceTotal= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelOrderTotal.frame) + CGRectGetWidth(labelOrderTotal.frame) + 0, CGRectGetMinY(labelOrderServer.frame) + CGRectGetHeight(labelOrderServer.frame) + 3, 90, 30)];
    
    priceTotal.text = [NSString stringWithFormat:@"%.1f",priceServer.text.floatValue + price.text.floatValue];

    [priceTotal setTextColor:[UIColor redColor]];
    [self.view addSubview:priceTotal];
    RELEASE(priceTotal);


}


- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSNumber *s = [NSNumber numberWithInteger:arrayOrderList.count];
        [signal setReturnValue:s];
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath
    {
        
        
        
        [signal setReturnValue:[NSNumber numberWithInteger:40]];
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
        
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        [cell addSubview:[self creatCell:[arrayOrderList objectAtIndex:indexPath.row]]];
        
//        static NSString *CellIdentifier = @"Cell2";
//        Cell2 *cell = (Cell2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        if (!cell) {
//            cell = [[Cell2 alloc]init];
//        }
//        cell.titleLabel.text = [arrayTitle objectAtIndex:indexPath.row];
        
        [signal setReturnValue:cell];
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
              
        
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

-(UIView *)creatCell:(orderModel *)order{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 40.0f)];
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 5.0f, 100.0f, 20.0f)];
    [labelName setText:order.name];
    [view addSubview:labelName];
    RELEASE(labelName);
    
    
    WOSCalculateOrder *calculateView  = [[WOSCalculateOrder alloc]initWithFrame:CGRectMake( 120, 5.0f, 100.0f, 20.0f)];
    calculateView.name = order.name;
    calculateView.lableMid.text = [NSString stringWithFormat:@"%d",order.num];
    [view addSubview:calculateView];
    RELEASE(calculateView);

    
    UILabel *labelPrice= [[UILabel alloc]initWithFrame:CGRectMake(230, 5.0f, 100.0f, 20.0f)];
    [labelPrice setText:[NSString stringWithFormat:@"%.1f",order.price]];
    [view addSubview:labelPrice];
    RELEASE(labelPrice);

    return view;
}
-(void)addlabel_title:(NSString *)title frame:(CGRect)frame view:(UIView *)view{
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
    [label1 setText:title];
    [label1 setTag:100];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [view bringSubviewToFront:label1];
    [label1 setTextColor:[UIColor whiteColor]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label1];
    RELEASE(label1);
    
}
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
    }
}

//WOSCalculateOrder
- (void)handleViewSignal_WOSCalculateOrder:(MagicViewSignal *)signal
{

    if ([signal is:[WOSCalculateOrder DOADD]])
    {
        NSString *name = (NSString *)[signal object];
        float totalPrice = 0;
        for (int i = 0; i < arrayOrderList.count;i ++ ) {
            int num = 0;
            orderModel *order = [arrayOrderList objectAtIndex:i];
            if ([order.name isEqualToString:name]) {
                WOSCalculateOrder *o = [signal source];
                
                 num = [o.lableMid.text integerValue];
                order.num = num;
            }else{
            
                num = order.num;
            }
            float fPrice = order.price;
            
            totalPrice = num * fPrice + totalPrice;
        }
        price.text = [NSString stringWithFormat:@"%.1f",totalPrice];
        
        
        
    }else if ([signal is:[WOSCalculateOrder DOREDUCE]]){
        
       
        NSString *name = (NSString *)[signal object];
        float totalPrice = 0;
        for (int i = 0; i < arrayOrderList.count;i ++ ) {
            int num = 0;
            orderModel *order = [arrayOrderList objectAtIndex:i];
            if ([order.name isEqualToString:name]) {
                WOSCalculateOrder *o = [signal source];
                
                num = [o.lableMid.text integerValue];
                order.num = num;
            }else{ 
                
                num = order.num;
            }
            float fPrice = order.price;
            
            totalPrice = num * fPrice + totalPrice;
        }
        price.text = [NSString stringWithFormat:@"%.1f",totalPrice];
        
       
}
      priceTotal.text = [NSString stringWithFormat:@"%.1f",priceServer.text.floatValue + price.text.floatValue];
}

- (void)dealloc
{
    RELEASE(_arrayAddInfo);
    RELEASE(arrayOrderList);
    RELEASE(dictNum);
    RELEASE(dictInfoList);
    
    [super dealloc];
}
@end
