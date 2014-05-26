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


@implementation WOSMakeOrderView{

    NSMutableDictionary *dictOrder;

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

    
    
    UIButton *btnHidden = [[UIButton alloc]initWithFrame:CGRectMake(260.0f, 100.0f, 60.0f, 30.0f)];
    [btnHidden setBackgroundColor:[UIColor redColor]];
    [btnHidden addTarget:self action:@selector(doHidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnHidden];
    RELEASEOBJ(btnHidden);
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0F, 305/2, 320.0F, self.frame.size.height - 305/2)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    RELEASE(view);
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 30.0f)];
    [labelName setCenter:CGPointMake(160.0f, 54/2)];
    [labelName setText:@"rtet"];
    [view addSubview:labelName];
    RELEASE(labelName);
    
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0, 200.0f, 30)];
    [labelTime setText:@"预计15min"];
    [labelTime setCenter:CGPointMake(160.0f, 65/2)];
    [view addSubview:labelTime];
    RELEASE(labelTime);
    
    UITableView *_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 50.0f, 320.0f, self.frame.size.height - 100)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [view addSubview:_tableView];

    
    UIButton *btnMakesure = [[UIButton alloc]initWithFrame:CGRectMake(270.0f, self.frame.size.height - 100.0f, 60.0, 30.0f)];
    [btnMakesure setBackgroundColor:[UIColor redColor]];
    [btnMakesure addTarget:self action:@selector(doMake) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMakesure];
    RELEASEOBJ(btnMakesure);
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
        [viewBtn setHidden:NO];
    }
   
    

    WOSPayViewController *pagVC = [[WOSPayViewController alloc]init];
    [nav pushViewController:pagVC animated:YES];
    RELEASEOBJ(nav);
    
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
