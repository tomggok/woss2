//

//  WOSPersonInfoViewController.m

//  DYiBan

//

//  Created by tom zeng on 13-11-28.

//  Copyright (c) 2013年 ZzL. All rights reserved.

//



#import "WOSPersonInfoViewController.h"

#import "WOSAddrViewController.h"

#import "WOSALLOrderViewController.h"

#import "WOSCollectViewController.h"

#import "WOSPersonInfoViewController.h"

#import "WOSPreferentialCardViewController.h"

#import "WOSMoreInfoViewController.h"
#import "WOSFindFoodViewController.h"
#import "Cell2.h"
#import "WOSLogInViewController.h"
#import "WOSOrderLostViewController.h"
#import "WOSFindMIMAViewController.h"
@interface WOSPersonInfoViewController (){
    
    
    
    DYBUITableView *tbDataBank1;
    
    NSArray *arrayTitle;
    
}



@end



@implementation WOSPersonInfoViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Custom initialization
        
    }
    
    return self;
    
}



-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    
    
    DLogInfo(@"name -- %@",signal.name);
    
    
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
        
    {
        
        //        [self.rightButton setHidden:YES];
        
        [self.headview setTitle:@"个人中心"];
        
        [self setButtonImage:self.leftButton setImage:@"back"];
        
        [self setButtonImage:self.rightButton setImage:@"more.png"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.view setBackgroundColor:ColorBG];
                
    }
    
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, self.headHeight + 10, 280, 300)];
        UIImage *imageNew = [[UIImage imageNamed:@"text_area"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.5, 10.5 , 10.5,10.5)];
        [imageView setImage:imageNew];
        [self.view addSubview:imageView];
        RELEASE(imageView);
            
        
        [self.rightButton setHidden:YES];
                
        [self.view setBackgroundColor:[UIColor clearColor]];
                
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(20.0f, self.headHeight + 10, 280, 300)];
        
        [viewBG setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:viewBG];
        
        RELEASE(viewBG);
                
        UIImageView *imageViewUserPhone = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 50.0f, 50.0f)];
        [imageViewUserPhone setImage:[UIImage imageNamed:@"food1"]];
        [viewBG addSubview:imageViewUserPhone];
        RELEASE(imageViewUserPhone);
        
        
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(imageViewUserPhone.frame) + CGRectGetWidth(imageViewUserPhone.frame), 5, 100, 20)];
        
        [labelName setText:@"tomgg"];
        
        [labelName setBackgroundColor:[UIColor clearColor]];
        
        [labelName setTextColor:ColorGryWhite];
        
        [viewBG addSubview:labelName];
        
        [labelName release];
            
        
        
        UILabel *labelTotal = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(imageViewUserPhone.frame) + CGRectGetWidth(imageViewUserPhone.frame), 25, 100, 30)];
        [labelTotal setBackgroundColor:[UIColor clearColor]];
        [labelTotal setText:@"积分：100"];
        
        [labelTotal setTextColor:ColorGryWhite];
        
        [viewBG addSubview:labelTotal];
        
        [labelTotal release];
        
          
        
        arrayTitle = [[NSArray alloc]initWithObjects:@"全部订单",@"地址簿",@"收藏夹",@"电子优惠券",@"找回密码", nil];
        tbDataBank1 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0.0f,  50 + 20, 280.0f, 6* 40) isNeedUpdate:NO];
        [tbDataBank1 setScrollEnabled:NO];
        [tbDataBank1.headerView setHidden:YES];
        [tbDataBank1.footerView setHidden:YES];
        [tbDataBank1 setSeparatorColor:[UIColor clearColor]];
        [tbDataBank1 setTableViewType:DTableViewSlime];
        [viewBG addSubview:tbDataBank1];
                
        RELEASE(tbDataBank1);
        
        [tbDataBank1 setBackgroundColor:[UIColor clearColor]];
        
        
        UIButton *btnBack = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(viewBG.frame) + CGRectGetMinY(viewBG.frame) + 20, 300, 44)];
        
        [self.view addSubview:btnBack];
        [btnBack setBackgroundColor:[UIColor clearColor]];
        
        [btnBack release];
        
        [btnBack addTarget:self action:@selector(backMan) forControlEvents:UIControlEventTouchUpInside];
        [btnBack setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [self addlabel_title:@"退出登陆" frame:btnBack.frame view:btnBack];

    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        
        
        DLogInfo(@"rrr");
        
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
 
        
    }
    
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



-(void)backMan{
    
    return;
    
    WOSLogInViewController *login = [[WOSLogInViewController alloc]init];
    [self.drNavigationController pushViewController:login animated:YES];
    RELEASE(login);
    
    
    
}









- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
    
    
    
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
        
    {
        
        NSNumber *s = [NSNumber numberWithInteger:arrayTitle.count];
        
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
        
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        static NSString *CellIdentifier = @"Cell2";
        
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc]init];
            
        }
        
        cell.textLabel.text = [arrayTitle objectAtIndex:indexPath.row];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:ColorGryWhite];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        
        UIImageView *imageViewSep = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 39, 280, 1)];
        [imageViewSep setImage:[UIImage imageNamed:@"个人中心_line"]];
        [cell addSubview:imageViewSep];
        RELEASE(imageViewSep);
        
        [signal setReturnValue:cell];
        
        
        
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
        
    {
        
        
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        
        switch (indexPath.row) {
                
            case 0:
                
            {
                
                WOSOrderLostViewController *order = [[WOSOrderLostViewController alloc]init];
                
                [self.drNavigationController pushViewController:order animated:YES];
                
                RELEASE(order);
                
            }
                
                break;
                
            case 1:
                
            {
                
                WOSAddrViewController *addr = [[WOSAddrViewController alloc]init];
                
                [self.drNavigationController pushViewController:addr animated:YES];
                
                RELEASE(addr);
                
            }
                
                break;
                
            case 2:
                
            {
                
                WOSCollectViewController *collect = [[WOSCollectViewController alloc]init];
                
                [self.drNavigationController pushViewController:collect animated:YES];
                
                RELEASE(collect);
                
            }
                
                break;
                
            case 3:
                
            {
                
                WOSPreferentialCardViewController *card = [[WOSPreferentialCardViewController alloc]init];
                
                [self.drNavigationController pushViewController:card animated:YES];
                
                RELEASE(card);
                
            }
                
                break;
                
            case 4:
                
            {
                
                WOSFindMIMAViewController *find = [[WOSFindMIMAViewController alloc]init];
                [self.drNavigationController pushViewController:find animated:YES];
                RELEASE(find);
                
            }
                
                break;
                
                
                
            default:
                
                break;
                
        }
        
        
        
        
        
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
        
        WOSMoreInfoViewController *more = [[WOSMoreInfoViewController alloc]init];
        
        [self.drNavigationController pushViewController:more animated:YES];
        
        RELEASE(more);
        
    }
    
}

- (void)dealloc

{
    
    [arrayTitle release];
    
    [super dealloc];
    
}



@end