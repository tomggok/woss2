//
//  WOSPayViewController.m
//  WOS
//
//  Created by axingg on 14-5-22.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSPayViewController.h"
#import "WOSPayTableViewCell.h"
#import "APPDELEGATE.h"
#import "WOSMakeSurePayTableViewCell.h"

@interface WOSPayViewController (){
    NSMutableDictionary *dictOrder;
    AppDelegate *appde;
}

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
    
//    dictOrder = [[NSMutableDictionary alloc]init];
  
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
          appde= appDelegate;
        [self.rightButton setHidden:YES];
        dictOrder = [[NSMutableDictionary alloc]init];
        
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, self.headHeight + 20, 250.0, 30.0f)];
        [labelName setBackgroundColor:[UIColor clearColor]];
        NSString *strName = [[NSUserDefaults standardUserDefaults]objectForKey:@"shopname"];
        [labelName setText:strName];
        
        [labelName setTextColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        [self.view addSubview:labelName];
        RELEASEOBJ(labelName);
        
        [self getData];
        
        UITableView *_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight + 50.0f, 320.0f, 200)];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setTag:101];
        [self.view addSubview:_tableView];
        RELEASEOBJ(_tableView);
        
        
//        UILabel *labelSave = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(_tableView.frame) + CGRectGetMinY(_tableView.frame) + 5,320, 30.0f)];
//        [labelSave setBackgroundColor:[UIColor clearColor]];
//        [labelSave setText:@"优惠"];
//        [self.view addSubview:labelSave];
//        RELEASEOBJ(labelSave);
//        
//        
//        UILabel *labelTotal1 = [[UILabel alloc]initWithFrame:CGRectMake(270.0f, CGRectGetHeight(_tableView.frame) + CGRectGetMinY(_tableView.frame) + 5, 50.0, 30.0f)];
//        [labelTotal1 setBackgroundColor:[UIColor clearColor]];
//        [labelTotal1 setText:@"128"];
//        [self.view addSubview:labelTotal1];
//        RELEASEOBJ(labelTotal1);
//        
//        
//        
//        UILabel *labelSaveNum = [[UILabel alloc]initWithFrame:CGRectMake(10.0f,CGRectGetHeight(labelTotal1.frame) + CGRectGetMinY(labelTotal1.frame) + 5, 250.0, 30.0f)];
//        [labelSaveNum setBackgroundColor:[UIColor clearColor]];
//        [labelSaveNum setText:@"10"];
//        [self.view addSubview:labelSaveNum];
//        RELEASEOBJ(labelSaveNum);
//        
//        
//        UILabel *labelSave2 = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelSaveNum.frame) + CGRectGetMinY(labelSaveNum.frame) + 5, 250.0, 30.0f)];
//        [labelSave2 setBackgroundColor:[UIColor clearColor]];
//        [labelSave2 setText:@"总计"];
//        [self.view addSubview:labelSave2];
//        RELEASEOBJ(labelSave2);
//        
//        
//        UILabel *labelName2 = [[UILabel alloc]initWithFrame:CGRectMake(270.0f, CGRectGetHeight(labelSaveNum.frame) + CGRectGetMinY(labelSaveNum.frame) + 5, 250.0, 30.0f)];
//        [labelName2 setBackgroundColor:[UIColor clearColor]];
//        [labelName2 setText:@"110"];
//        
//        [labelName2 setTextColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
//        [self.view addSubview:labelName2];
//        RELEASEOBJ(labelName2);
//
//        UILabel *labelUserFree = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelName2.frame) + CGRectGetMinY(labelName2.frame) + 5, 250.0, 30.0f)];
//        [labelUserFree setBackgroundColor:[UIColor clearColor]];
//        [labelUserFree setText:@"使用优惠券"];
// 
//        [self.view addSubview:labelUserFree];
//        RELEASEOBJ(labelUserFree);
//        
//        UISwitch *switchFree = [[UISwitch alloc]initWithFrame:CGRectMake(270.0f, CGRectGetHeight(labelName2.frame) + CGRectGetMinY(labelName2.frame) + 5, 50.0f, 30.0f)];
//        [switchFree addTarget:self action:@selector(doSwith:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:switchFree];
//        RELEASEOBJ(switchFree);
//        
//        
//        
//        
//        UITableView *_tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, CGRectGetHeight(switchFree.frame) + CGRectGetMinY(switchFree.frame) + 5, 320.0f, 60)];
//        [_tableView1 setDataSource:self];
//        [_tableView1 setDelegate:self];
//        [_tableView1 setTag:102];
////        [self.view addSubview:_tableView1];
////        RELEASEOBJ(_tableView1);
//        
//        
//        
//        UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelName2.frame) + CGRectGetMinY(labelName2.frame) + 5, 50.0, 30.0f)];
//        [labelAddr setBackgroundColor:[UIColor clearColor]];
//        [labelAddr setText:@"地址"];
//        
//        [self.view addSubview:labelAddr];
//        RELEASEOBJ(labelAddr);
//        
//        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(40.0f, CGRectGetHeight(labelName2.frame) + CGRectGetMinY(labelName2.frame) + 5, 300.0f, 100.0f)];
//        [textView setBackgroundColor:[UIColor grayColor]];
//        
////        [self.view addSubview:textView];
////        RELEASEOBJ(textView);
//        
//        
//        UIButton *btnEnter = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelName2.frame) + CGRectGetMinY(labelName2.frame) + 5 + 40, 40.0f, 40.0f)];
//        [btnEnter setBackgroundColor:[UIColor redColor]];
//        [btnEnter addTarget:self action:@selector(doEnterAddr) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btnEnter];
//        RELEASEOBJ(btnEnter);
//        
//        
//        UIButton *btnMakeSuerOrder = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(textView.frame) + CGRectGetMinY(textView.frame) + 5 + 40, 40.0f, 40.0f)];
//        [btnMakeSuerOrder setBackgroundColor:[UIColor redColor]];
//        [btnEnter addTarget:self action:@selector(dobtnMakeSuerOrder) forControlEvents:UIControlEventTouchUpInside];
//        [btnEnter setTitle:@"提交订单" forState:UIControlStateNormal];
//        [self.view addSubview:btnMakeSuerOrder];
//        RELEASEOBJ(btnMakeSuerOrder);
        
        

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
    
    
    return [dictOrder allKeys].count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"dd";
    WOSMakeSurePayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WOSMakeSurePayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }else {
        
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
    }
    
    NSArray *array = [dictOrder allValues];
    [cell creatCell:[array objectAtIndex:indexPath.row]];
    return cell;
    
    
    
}




-(void)getData{
    
 
    
    for (NSDictionary *dic in appde.arrayOrderList) {
        
        NSString *index = [dic objectForKey:@"foodIndex"];
        NSMutableArray *arrayTemp = [dictOrder objectForKey:index];
        if (!arrayTemp  ) { //不存在
            
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:dic];
            [dictOrder setValue:array forKey:index];
            RELEASE(array);
            
        }else{ //已经有了，
            
            [arrayTemp addObject:dic];
            [dictOrder setValue:arrayTemp forKey:index];
        }
        
    }
    
}


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
