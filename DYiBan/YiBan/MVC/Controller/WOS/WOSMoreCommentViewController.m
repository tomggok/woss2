//
//  WOSMoreCommentViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-12-25.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSMoreCommentViewController.h"
#import "WOSGoodFoodListCell.h"
#import "WOSPLCell.h"
#import "WOSAddCommentViewController.h"

#import "JSONKit.h"
#import "JSON.h"


@interface WOSMoreCommentViewController (){

    int page ;
    int starLevel;
    NSArray *arrayResult;
    DYBUITableView *tbDataBank1;

}

@end

@implementation WOSMoreCommentViewController
@synthesize dictInfo = _dictInfo;
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
        [self.headview setTitle:@"更多评论"];
        
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        
        [self.view setBackgroundColor:ColorBG];
        [self setButtonImage:self.leftButton setImage:@"back"];
        [self setButtonImage:self.rightButton setImage:@"back"];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        starLevel = 1;
        [self creatBar];
        MagicRequest *request = [DYBHttpMethod wosKitchenInfo_commentkitchenlist:[_dictInfo objectForKey:@"kitchenIndex"]  starLevel:[NSString stringWithFormat:@"%d",0] page:[NSString stringWithFormat:@"%d",page] count:@"10" sAlert:YES receive:self];
        [request setTag:2];

        
        tbDataBank1 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight + 40, 320.0f, self.view.frame.size.height -  self.headHeight - 40) isNeedUpdate:NO];
        [tbDataBank1.footerView setHidden:YES];
        [tbDataBank1.headerView setHidden:YES];
        [tbDataBank1 setTableViewType:DTableViewSlime];
        [tbDataBank1 setSeparatorColor:[UIColor clearColor]];
        [self.view addSubview:tbDataBank1];
        
        RELEASE(tbDataBank1);
        
        [tbDataBank1 setBackgroundColor:[UIColor clearColor]];
        
        
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
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
        [signal setReturnValue:[NSNumber numberWithInteger:80]];
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
        
        
        static NSString *reuseIdentifier = @"reuseIdentifier";
        
        WOSPLCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        if (cell == nil) {
            cell = [[WOSPLCell alloc]init];
        }
        
        
        [cell creatCell:  [arrayResult objectAtIndex:indexPath.row]];
        [cell setBackgroundColor:ColorBG];

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





- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
        WOSAddCommentViewController *coment = [[WOSAddCommentViewController alloc]init];
        [self.drNavigationController pushViewController:coment animated:YES];
        RELEASE(coment);
    }
}


- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        //        JsonResponse *response = (JsonResponse *)receiveObj;
        if(request.tag == 2){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
                    arrayResult = [[NSArray alloc]initWithArray:[dict objectForKey:@"commentList"]];
                    
                    [tbDataBank1 reloadData];
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

-(void)creatBar{
    
    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, 40)];
    [view setTag:90];
    [view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:view];
    RELEASE(view);
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 0.0f, 50.0f, 40.0f)];
    [labelTitle setText:@"星级："];
//    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [labelTitle setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:labelTitle];
    RELEASE(labelTitle);
    
    
    for (int i = 0; i < 6; i++) {
        
        
        UIButton *labelOneStar = [[UIButton alloc]initWithFrame:CGRectMake(45 * i + 45, 0, 45, 40)];
        [labelOneStar addTarget:self action:@selector(dochoose:) forControlEvents:UIControlEventTouchUpInside];
        [labelOneStar setTag:i + 10];
        [labelOneStar.titleLabel setFont:[UIFont systemFontOfSize:14]];
        switch (i) {
            case 0:
                 [labelOneStar setTitle:@"全部" forState:UIControlStateNormal];
                [labelOneStar setTitleColor:ColorTextYellow forState:UIControlStateNormal];
                break;
            case 1:
                [labelOneStar setTitle:@"一星" forState:UIControlStateNormal];

                break;
            case 2:
                [labelOneStar setTitle:@"二星" forState:UIControlStateNormal];

                break;
            case 3:
                [labelOneStar setTitle:@"三星" forState:UIControlStateNormal];

                break;
            case 4:
                [labelOneStar setTitle:@"四星" forState:UIControlStateNormal];

                break;
            case 5:
                [labelOneStar setTitle:@"五星" forState:UIControlStateNormal];

                break;
                
            default:
                break;
        }
        [view addSubview:labelOneStar];
        RELEASE(labelOneStar);
        
        
        
        
    }
    
    
    
}

-(void)dochoose:(id)sender{

    UIButton *btn = (UIButton *)sender;
    
    UIView *view = [self.view viewWithTag:90];
    
    starLevel = btn.tag - 10;
    
    MagicRequest *request = [DYBHttpMethod wosKitchenInfo_commentkitchenlist:[_dictInfo objectForKey:@"kitchenIndex"]  starLevel:[NSString stringWithFormat:@"%d",starLevel] page:[NSString stringWithFormat:@"%d",page] count:@"10" sAlert:YES receive:self];
    [request setTag:2];
    
    for (int i = 10; i < 16; i ++) {
        UIButton *btnTouch = (UIButton *)[view viewWithTag:i];
        if (btn.tag == btnTouch.tag) {
            
            [btnTouch setTitleColor:ColorTextYellow forState:UIControlStateNormal];
       
        }else{
            
            [btnTouch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }
    
    }
}
- (void)dealloc
{
    RELEASE(_dictInfo);
    [super dealloc];
}
@end
