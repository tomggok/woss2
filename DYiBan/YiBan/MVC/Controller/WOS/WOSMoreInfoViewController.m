//
//  WOSMoreInfoViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-11-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSMoreInfoViewController.h"
#import "Cell2.h"
#import "WOSTellMSGViewController.h"



@interface WOSMoreInfoViewController (){

    UITableView *tbDataBank1;
    NSArray *arrayTitle;

}

@end

@implementation WOSMoreInfoViewController

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
        [self.headview setTitle:@"更多"];
        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self setButtonImage:self.leftButton setImage:@"back"];
        [self.view setBackgroundColor:ColorBG];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        arrayTitle = [[NSArray alloc]initWithObjects:@"告诉朋友",@"意见反馈",@"常用问题",@"关于",@"访问订餐网站", nil];

        
        UIImageView *tt = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, SEARCHBAT_HIGH + 44, 280.0f, self.view.frame.size.height - SEARCHBAT_HIGH - 44 - 260 )];

        
        UIImage *imageNew = [[UIImage imageNamed:@"text_area"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.5, 10.5 , 10.5,10.5)];
        [tt setImage:imageNew];
//        [tt setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:tt];
        RELEASE(tt);
        
        
        tbDataBank1 = [[UITableView alloc]initWithFrame:CGRectMake(20.0f, SEARCHBAT_HIGH + 44, 280.0f, self.view.frame.size.height - SEARCHBAT_HIGH - 44 - 20 - 70 ) ];
        tbDataBank1.dataSource = self;
        tbDataBank1.delegate = self;
        [tbDataBank1 setScrollEnabled:NO];
        [self.view addSubview:tbDataBank1];
        RELEASE(tbDataBank1);
        [tbDataBank1 setBackgroundColor:[UIColor clearColor]];
        [tbDataBank1 setSeparatorColor:[UIColor clearColor]];
        
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}


#pragma mark - tableviewdelete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section/*第一次回调时系统传的section是数据源里section数量的最大值-1*/
{
            return arrayTitle.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell2";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.textLabel.text = [arrayTitle objectAtIndex:indexPath.row];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setTextColor:ColorGryWhite];
    UIImageView *imageViewSep = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 39, 280, 1)];
    [imageViewSep setImage:[UIImage imageNamed:@"个人中心_line"]];
    
    [cell addSubview:imageViewSep];
    RELEASE(imageViewSep);
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
        {
            WOSTellMSGViewController *more = [[WOSTellMSGViewController alloc]init];
            [self.drNavigationController pushViewController:more animated:YES];
            RELEASE(more);
            
        
        
        }
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
            
        default:
            break;
    }
    
}

- (void)dealloc
{
    
    [super dealloc]; 
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


@end
