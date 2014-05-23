//
//  WOSPayViewController.m
//  WOS
//
//  Created by axingg on 14-5-22.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSPayViewController.h"
#import "WOSPayTableViewCell.h"


@interface WOSPayViewController ()

@end

@implementation WOSPayViewController

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
        [self.headview setTitle:@"确认付款"];
        

        
        [self.headview setTitleColor:[UIColor whiteColor]];
        [self setButtonImage:self.leftButton setImage:@"返回键"];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:40.0f/255 green:191.0f/255 blue:140.0f/255 alpha:1.0f]];

        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, self.headHeight + 20, 250.0, 30.0f)];
        [labelName setBackgroundColor:[UIColor clearColor]];
        [labelName setText:@"中国豆腐"];
        
        [labelName setTextColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        [self.view addSubview:labelName];
        RELEASEOBJ(labelName);
        
        
        UITableView *_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight + 50.0f, 320.0f, 100)];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setTag:101];
        [self.view addSubview:_tableView];
        RELEASEOBJ(_tableView);
        
        
        UILabel *labelSave = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(_tableView.frame) + CGRectGetMinY(_tableView.frame) + 5,320, 30.0f)];
        [labelSave setBackgroundColor:[UIColor clearColor]];
        [labelSave setText:@"优惠"];
        [self.view addSubview:labelSave];
        RELEASEOBJ(labelSave);
        
        
        UILabel *labelTotal1 = [[UILabel alloc]initWithFrame:CGRectMake(270.0f, CGRectGetHeight(_tableView.frame) + CGRectGetMinY(_tableView.frame) + 5, 50.0, 30.0f)];
        [labelTotal1 setBackgroundColor:[UIColor clearColor]];
        [labelTotal1 setText:@"128"];
        [self.view addSubview:labelTotal1];
        RELEASEOBJ(labelTotal1);
        
        
        
        UILabel *labelSaveNum = [[UILabel alloc]initWithFrame:CGRectMake(10.0f,CGRectGetHeight(labelTotal1.frame) + CGRectGetMinY(labelTotal1.frame) + 5, 250.0, 30.0f)];
        [labelSaveNum setBackgroundColor:[UIColor clearColor]];
        [labelSaveNum setText:@"10"];
        [self.view addSubview:labelSaveNum];
        RELEASEOBJ(labelSaveNum);
        
        
        UILabel *labelSave2 = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelSaveNum.frame) + CGRectGetMinY(labelSaveNum.frame) + 5, 250.0, 30.0f)];
        [labelSave2 setBackgroundColor:[UIColor clearColor]];
        [labelSave2 setText:@"总计"];
        [self.view addSubview:labelSave2];
        RELEASEOBJ(labelSave2);
        
        
        UILabel *labelName2 = [[UILabel alloc]initWithFrame:CGRectMake(270.0f, CGRectGetHeight(labelSaveNum.frame) + CGRectGetMinY(labelSaveNum.frame) + 5, 250.0, 30.0f)];
        [labelName2 setBackgroundColor:[UIColor clearColor]];
        [labelName2 setText:@"110"];
        
        [labelName2 setTextColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        [self.view addSubview:labelName2];
        RELEASEOBJ(labelName2);

        UILabel *labelUserFree = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelName2.frame) + CGRectGetMinY(labelName2.frame) + 5, 250.0, 30.0f)];
        [labelUserFree setBackgroundColor:[UIColor clearColor]];
        [labelUserFree setText:@"使用优惠券"];
 
        [self.view addSubview:labelUserFree];
        RELEASEOBJ(labelUserFree);
        
        UISwitch *switchFree = [[UISwitch alloc]initWithFrame:CGRectMake(270.0f, CGRectGetHeight(labelName2.frame) + CGRectGetMinY(labelName2.frame) + 5, 50.0f, 30.0f)];
        [switchFree addTarget:self action:@selector(doSwith:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:switchFree];
        RELEASEOBJ(switchFree);
        
        
        
        
        UITableView *_tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, CGRectGetHeight(switchFree.frame) + CGRectGetMinY(switchFree.frame) + 5, 320.0f, 60)];
        [_tableView1 setDataSource:self];
        [_tableView1 setDelegate:self];
        [_tableView1 setTag:102];
//        [self.view addSubview:_tableView1];
//        RELEASEOBJ(_tableView1);
        
        
        
        UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelName2.frame) + CGRectGetMinY(labelName2.frame) + 5, 50.0, 30.0f)];
        [labelAddr setBackgroundColor:[UIColor clearColor]];
        [labelAddr setText:@"地址"];
        
        [self.view addSubview:labelAddr];
        RELEASEOBJ(labelAddr);
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(40.0f, CGRectGetHeight(labelName2.frame) + CGRectGetMinY(labelName2.frame) + 5, 300.0f, 100.0f)];
        [textView setBackgroundColor:[UIColor grayColor]];
        
//        [self.view addSubview:textView];
//        RELEASEOBJ(textView);
        
        
        UIButton *btnEnter = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelName2.frame) + CGRectGetMinY(labelName2.frame) + 5 + 40, 40.0f, 40.0f)];
        [btnEnter setBackgroundColor:[UIColor redColor]];
        [btnEnter addTarget:self action:@selector(doEnterAddr) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnEnter];
        RELEASEOBJ(btnEnter);
        
        
        UIButton *btnMakeSuerOrder = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(textView.frame) + CGRectGetMinY(textView.frame) + 5 + 40, 40.0f, 40.0f)];
        [btnMakeSuerOrder setBackgroundColor:[UIColor redColor]];
        [btnEnter addTarget:self action:@selector(dobtnMakeSuerOrder) forControlEvents:UIControlEventTouchUpInside];
        [btnEnter setTitle:@"提交订单" forState:UIControlStateNormal];
        [self.view addSubview:btnMakeSuerOrder];
        RELEASEOBJ(btnMakeSuerOrder);
        
        

//        MagicUITableView *tabelViewList = [[MagicUITableView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, self.view.frame.size.height - self.headHeight)];
//        
//        [self.view addSubview:tabelViewList];
//        RELEASE(tabelViewList)
        
        
        
        
        
        //        MagicRequest *request = [DYBHttpMethod wosKitchenInfo_kitchenIndex:[_dictInfo objectForKey:@"kitchenIndex"] userIndex:SHARED.userId hotFoodCount:@"4" sAlert:YES receive:self];
        //        [request setTag:3];
        //
        
        
        
    }
    
    
    else if ([signal is:[MagicViewController WILL_APPEAR]]) {
        
        DLogInfo(@"rrr");
        
        
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
    
}


-(void)doSwith:(id)sender{


    UISwitch *s = (UISwitch *)sender;
    if (s.on) {
        
    }else {
    
    
    }
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 4;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"dd";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }else {
        
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
    }
    
//    [cell creatCell:nil];
    return cell;
    
    
    
}



//
//- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
//    
//    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
//        
//    {
//        
//        NSNumber *s = [NSNumber numberWithInteger:5];
//        
//        [signal setReturnValue:s];
//        
//    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
//        
//    {
//        
//        NSNumber *s = [NSNumber numberWithInteger:1];
//        
//        [signal setReturnValue:s];
//        
//    }
//    
//    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath
//        
//    {
//        
//        [signal setReturnValue:[NSNumber numberWithInteger:90]];
//        
//    }
//    
//    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
//        
//    {
//        [signal setReturnValue:nil];
//    }
//    
//    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
//        
//    {
//        
//        [signal setReturnValue:nil];
//        
//    }
//    
//    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
//        
//    {
//        
//        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
//        
//    }
//    
//    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell
//        
//    {
//        NSDictionary *dict = (NSDictionary *)[signal object];
//        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
//        
//        
//        WOSPayTableViewCell *cell = [[WOSPayTableViewCell alloc]init];
//        
//        
//        //        UITableView *tableView = [dict objectForKey:@"tableView"];
////        WOSOrderListCell *cell = [[WOSOrderListCell alloc]init];
////        [cell setBackgroundColor:ColorBG];
////        [cell creat:[arrayResult objectAtIndex:indexPath.row]];
//        [cell creatCell:nil];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [signal setReturnValue:cell];
//        
//    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
//        
//    {
//        
//        NSDictionary *dict = (NSDictionary *)[signal object];
//        
//        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
//        
//        
////        WOSOrderDetailViewController *detail = [[WOSOrderDetailViewController alloc]initWithFrame:self.drNavigationController.view.frame];
////        detail.dictInfo = [arrayResult objectAtIndex:indexPath.row];
////        [detail creatView:[arrayResult objectAtIndex:indexPath.row]];
////        
////        [detail setBackgroundColor:[UIColor clearColor]];
////        //        [detail setAlpha:0.9];
////        [self.drNavigationController.view addSubview:detail];
////        RELEASE(detail);
//        
//        
//        
//    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
//        
//        
//        
//        
//        
//    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
//        
//        
//        
//    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]) //刷新
//        
//    {
//        
//        //        MagicUIUpdateView *uptableview = (MagicUIUpdateView *)[signal object];
//        
//        
//        
//        
//        
//    }else if([signal is:[MagicUITableView TAbLEVIEWLODATA]]) //加载更多
//        
//    {
//        
//        
//        
//        
//        
//    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){ //上滑动
//        
//        
//        
//        //        [tbDataBank StretchingUpOrDown:0];
//        
//        //        [DYBShareinstaceDelegate opeartionTabBarShow:YES];
//        
//        
//        
//    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){ //下滑动
//        
//        
//        
//        //        [tbDataBank StretchingUpOrDown:1];
//        
//        //        [DYBShareinstaceDelegate opeartionTabBarShow:NO];
//        
//    }
//    
//    
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
