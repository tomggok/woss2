//
//  WOSPreferentialCardViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-11-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSPreferentialCardViewController.h"
#import "JSONKit.h"
#import "JSON.h"
#import "WOSCardCell.h"


@interface WOSPreferentialCardViewController (){

  MagicUITableView * tableView1;
    NSMutableArray *arrayAddrList;
}

@end

@implementation WOSPreferentialCardViewController

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
-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        //        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"电子优惠券"];
        
        //         [self setButtonImage:self.rightButton setImage:@"btn_more_def"];
        [self setButtonImage:self.leftButton setImage:@"back"];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        UIView *viewBG = [[UIView alloc]initWithFrame:self.view.frame];
        [viewBG setBackgroundColor:ColorBG];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
//        [self.view setBackgroundColor:ColorBG];
        
        MagicRequest *request = [DYBHttpMethod wosKitchenInfo_medeals_userIndex:SHARED.userId kitchenIndex:nil sAlert:YES receive:self];
        [request setTag:3];
        
        tableView1 = [[MagicUITableView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight , 320,self.view.frame.size.height - self.headHeight)];
        [tableView1 setBackgroundColor:[UIColor clearColor]];
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
        NSNumber *s = [NSNumber numberWithInteger:arrayAddrList.count];
        [signal setReturnValue:s];
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath
    {
        
        
        
        [signal setReturnValue:[NSNumber numberWithInteger:100]];
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
        
        WOSCardCell *cell = [[[WOSCardCell alloc]init] autorelease];
        [cell setBackgroundColor:[UIColor colorWithRed:46/255 green:46/255 blue:46/255 alpha:1.0f]];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell creatCell:[arrayAddrList objectAtIndex:indexPath.row]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [signal setReturnValue:cell];
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
        return;
        
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
        //        JsonResponse *response = (JsonResponse *)receiveObj;
        if (request.tag == 2) {
            
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
                    //                    _dictInfo = dict;
                    //                    [DYBShareinstaceDelegate popViewText:@"收藏成功！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
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
                    
                    arrayAddrList = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"dealsList"]];
                    //                    [self creatView:dict];
                    [tableView1 reloadData];
                    //                    UIButton *btn = (UIButton *)[UIButton buttonWithType:UIButtonTypeCustom];
                    //                    [btn setTag:10];
                    //                    [self doChange:btn];
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

@end
