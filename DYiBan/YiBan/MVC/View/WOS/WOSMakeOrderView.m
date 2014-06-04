//
//  WOSMakeOrderView.m
//  WOS
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSMakeOrderView.h"
#import "WOSMakeOrderTableViewCell.h"
#import "AppDelegate.h"
#import "WOSPayViewController.h"
#import "WOSLogInViewController.h"


@implementation WOSMakeOrderView{

    NSMutableDictionary *dictOrder;
    UILabel *label1 ;

}
@synthesize nav,arrayResult;

- (id)initWithFrame:(CGRect)frame arrayWithData:(NSMutableArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.arrayResult = array;
        dictOrder = [[NSMutableDictionary alloc]init];
        [self getData]; //处理数据
        [self creatView];
    }
    return self;
}
-(void)creatView{
    
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIView *viewBG = [[UIView alloc]initWithFrame:self.frame];
    [viewBG setBackgroundColor:[UIColor blackColor]];
    [viewBG setAlpha:0.7];
    [self addSubview:viewBG];
    RELEASE(viewBG);

    
    UIImage *imageHidden = [UIImage imageNamed:@"退出结算"];
    UIButton *btnHidden = [[UIButton alloc]initWithFrame:CGRectMake(260.0f, 100.0f, imageHidden.size.width/2, imageHidden.size.height/2)];
    [btnHidden setBackgroundColor:[UIColor clearColor]];
    [btnHidden setImage:imageHidden forState:UIControlStateNormal];
    [btnHidden addTarget:self action:@selector(doHidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnHidden];
    RELEASEOBJ(btnHidden);
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0F, 305/2, 320.0F, self.frame.size.height - 305/2)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    RELEASE(view);
    
    NSString *shopName = [[NSUserDefaults standardUserDefaults]objectForKey:@"shopname"];
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, -10, 200.0f, 20.0f)];
    [labelName setCenter:CGPointMake(160.0f, 40/2)];
    [labelName setText:shopName];
    [view addSubview:labelName];
    RELEASE(labelName);
    
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 35.0, 200.0f, 20)];
    [labelTime setText:@"预计15分钟"];
    [labelTime setCenter:CGPointMake(160.0f, 75/2)];
    [labelTime setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:labelTime];
    RELEASE(labelTime);
    
    UITableView *_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 50.0f, 320.0f, self.frame.size.height - 100 - 305/2 - 70)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [view addSubview:_tableView];

    
    UIImage *image1 = [UIImage imageNamed:@"jiesuanyaunjiaojuxing"];
    UIButton *btnMakesure = [[UIButton alloc]initWithFrame:CGRectMake(230.0f, self.frame.size.height - 100.0f + 20, image1.size.width/2, image1.size.height/2)];
    [btnMakesure setBackgroundColor:[UIColor clearColor]];
    [btnMakesure setImage:image1 forState:UIControlStateNormal];
    [btnMakesure addTarget:self action:@selector(doMake) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMakesure];
    RELEASEOBJ(btnMakesure);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(250.0f, self.frame.size.height - 100.0f +7 + 20,100, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"结账"];
    [label setTextColor:[UIColor whiteColor]];
    [self addSubview:label];
    RELEASE(label);
    
    
    
   label1 = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, self.frame.size.height - 100.0f +7 + 20,150, 20)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setText:[NSString stringWithFormat:@"共计：%.02f元",[self getPrice] ]];
    [label1 setTextColor:[UIColor colorWithRed:40.0f/255 green:191.0f/255 blue:140.0f/255 alpha:1.0f]];
    [self addSubview:label1];
    RELEASE(label1);
    
}


-(float)getPrice{

    AppDelegate *appd = appDelegate;
    float data = 0;
    for (int i = 0; i < appd.arrayOrderList.count; i++) {
        
        NSDictionary *dict = [appd.arrayOrderList objectAtIndex:i];
        data = data + [[dict objectForKey:@"foodPrice"] floatValue];
    }
    return data;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return [dictOrder allKeys].count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"dd";
    WOSMakeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WOSMakeOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }else {
        
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
    }
    NSArray *array  = [dictOrder allValues];
    
    [cell creatCell:[array objectAtIndex:indexPath.row]];
    return cell;
    
    

}

-(void)handleViewSignal_WOSCalculateOrder:(MagicViewSignal *)signal{

    
 [label1 setText:[NSString stringWithFormat:@"共计：%.02f元",[self getPrice] ]];

}
-(void)getData{


    for (NSDictionary *dic in arrayResult) {
        
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
-(void)doMake{

    
    AppDelegate *appd = appDelegate;
    
    UIView *viewBtn = [appd.window viewWithTag:80800];
    
    if (viewBtn) {
        [viewBtn setHidden:YES];
    }
   
    if (SHARED.userId == nil) {
        
        WOSLogInViewController *login = [[WOSLogInViewController alloc]init];
        
        [nav pushViewController:login animated:YES];
        
        return;
    }
    


    WOSPayViewController *pagVC = [[WOSPayViewController alloc]init];
    [nav pushViewController:pagVC animated:YES];
    RELEASE(pagVC);
    
//    [self removeFromSuperview];
    
}

-(void)doHidden{
    AppDelegate *appd = appDelegate;
    
    UIView *viewBtn = [appd.window viewWithTag:80800];
    
    if (viewBtn) {
        [viewBtn setHidden:NO];
    }
    [self removeFromSuperview];

}



- (void)dealloc
{
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
