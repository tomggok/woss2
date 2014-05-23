//
//  WOSALLOrderViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-11-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSALLOrderViewController.h"
#import "WOSOrderCell.h"
#import "WOSMakeSureOrderListViewController.h"
#import "JSONKit.h"
#import "JSON.h"

@interface WOSALLOrderViewController (){
    
    DYBUITableView *tbDataBank1;
    UIButton *goShowOrderList;
    NSArray *arrayResult;
    NSArray *arrayFoodList;
    
    NSMutableArray *arrayAddorder;
    
}

@end

@implementation WOSALLOrderViewController
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
        //        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"海底捞牡丹江店"];
        
        [self setButtonImage:self.leftButton setImage:@"back"];
        [self setButtonImage:self.rightButton setImage:@"home"];
         [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        arrayFoodList = [[NSArray alloc]init];
        arrayAddorder = [[NSMutableArray alloc]init];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        MagicRequest *request = [DYBHttpMethod wosKitchenInfo_foodlist:[_dictInfo objectForKey:@"kitchenIndex"]sAlert:YES receive:self];
        [request setTag:3];
        
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, self.view.frame.size.height - self.headHeight)];
        [viewBG setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
        UIImage *image = [UIImage imageNamed:@"menu_inactive"];
       
        
        tbDataBank1 = [[DYBUITableView alloc]initWithFrame:CGRectMake(image.size.width/2, self.headHeight, 320.0f - 50, self.view.frame.size.height - self.headHeight  ) isNeedUpdate:YES];
        [tbDataBank1 setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:tbDataBank1];
               [tbDataBank1 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank1);
        
       
        
        
//        [self creatBar];
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}
-(void)goShowOrderListAction{

    WOSMakeSureOrderListViewController *makeSure = [[WOSMakeSureOrderListViewController alloc]init];
    
    makeSure.arrayAddInfo = arrayAddorder;
    makeSure.dictInfo = _dictInfo;
    [self.drNavigationController pushViewController:makeSure animated:YES];
    RELEASE(makeSure);
}

-(void)chooseTab:(id)sender{

    UIButton *btn = (UIButton *)sender;
    int btnTag = btn.tag;
    for (int i = 100; i<= 105; i++) {
        
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:i];
        UILabel *label = (UILabel *)[btn1 viewWithTag:1000];
        
       
       
        if (btnTag == i ) {
            
            [btn1 setSelected:YES];
            [label setTextColor:[UIColor colorWithRed:237.0f/255 green:95.0f/255 blue:40.0f/255 alpha:1.0f]];
            
        }else{
            
            [label setTextColor:[UIColor whiteColor]];
            [btn1 setSelected:NO];
        }
    }
    
    NSDictionary *dictResult = [arrayResult objectAtIndex:btn.tag - 100];
    arrayFoodList = [dictResult objectForKey:@"foodList"];
    [tbDataBank1 reloadData];
}

#pragma mark- 只接受UITableView信号
static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
//        NSDictionary *dict = (NSDictionary *)[signal object];
//        NSNumber *_section = [dict objectForKey:@"section"];
        NSNumber *s;
        
//        if ([_section intValue] == 0) {
            s = [NSNumber numberWithInteger:arrayFoodList.count];
//        }else{
//            s = [NSNumber numberWithInteger:[_arrStatusData count]];
//        }
        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
       
        NSNumber *s = [NSNumber numberWithInteger:50];
        [signal setReturnValue:s];

               
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
                
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
       
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        WOSOrderCell *cell = [[WOSOrderCell alloc]init];
        
        NSDictionary *dictInfoFood = [arrayFoodList objectAtIndex:indexPath.row];
        [cell creatCell:dictInfoFood];
        DLogInfo(@"%d", indexPath.section);
        
                
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
       
               
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
            
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
            }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }
    
    
    
}

-(void)creatBar{
    
    UIImage *image = [UIImage imageNamed:@"bottom_panel"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height -20 - image.size.height/2, image.size.width/2, image.size.height/2)];
    [imageView setImage:image];
//    [imageView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:imageView];
    [imageView setUserInteractionEnabled: YES];
    RELEASE(imageView);
    
    
    UILabel *labelTotalM = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, (image.size.height/2 - 30)/2, 150.0f, 30.0f)];
    [labelTotalM setText:@"合计：60.0元"];
    [imageView addSubview:labelTotalM];
    [labelTotalM setTextAlignment:NSTextAlignmentCenter];
    [labelTotalM setTextColor:[UIColor whiteColor]];
    [labelTotalM setBackgroundColor:[UIColor clearColor]];
    RELEASE(labelTotalM);
    
    UIImage *imageBtn = [UIImage imageNamed:@"button_m"];
    UIButton *btnDO = [[UIButton alloc]initWithFrame:CGRectMake(170.0f, (image.size.height/2 - imageBtn.size.height/2)/2, imageBtn.size.width/2, imageBtn.size.height/2)];
    [btnDO setTitle:@"结算" forState:UIControlStateNormal];
    [btnDO setImage:[UIImage imageNamed:@"button_m"] forState:UIControlStateNormal];
    [btnDO setImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
    [btnDO setBackgroundColor:[UIColor redColor]];
    [btnDO setTitle:@"结算" forState:UIControlStateNormal];
    [btnDO addTarget:self action:@selector(goShowOrderListAction) forControlEvents:UIControlEventTouchUpInside];
    [self addlabel_title:@"结算(2)" frame:btnDO.frame view:btnDO];
    [imageView addSubview:btnDO];
    RELEASE(btnDO);

    
    
}

-(void)addlabel_title:(NSString *)title frame:(CGRect)frame view:(UIView *)view{

    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
    [label1 setText:title];
    [label1 setTag:1000];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [view bringSubviewToFront:label1];
    [label1 setTextColor:[UIColor whiteColor]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label1];
    
    RELEASE(label1);
   }


-(void)creatRightBtn{

    
    UIImage *image = [UIImage imageNamed:@"menu_inactive"];
    for (int i = 0; i < arrayResult.count ; i++) {
        
        
        float offset = image.size.height/2;
        
        UIButton *btnHome = [[UIButton alloc]initWithFrame:CGRectMake(.0f, self.headHeight + 3 + offset * i, image.size.width/2, image.size.height/2)];
        [btnHome setImage:image forState:UIControlStateNormal];
        [btnHome setImage:[UIImage imageNamed:@"menu_active"] forState:UIControlStateSelected];
        [btnHome setTag:100 + i];
        [btnHome addTarget:self action:@selector(chooseTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btnHome];
        RELEASE( btnHome);

        
        [self addlabel_title:[[arrayResult objectAtIndex:i] objectForKey:@"foodTypeName"] frame:btnHome.frame view:btnHome];
    }
    
   

}

- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
        
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
    
        [self goShowOrderListAction];
    }
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
                    
                    _dictInfo = dict;
                    [DYBShareinstaceDelegate popViewText:@"收藏成功！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
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
                    
                    
                    UIImage *image = [UIImage imageNamed:@"menu_inactive"];
                    
                    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, image.size.width/2, self.view.frame.size.height - self.headHeight)];
                    [rightView setBackgroundColor:[UIColor colorWithRed:46.0f/255 green:46.0f/255 blue:46.0f/255 alpha:1.0f]];
                    [self.view addSubview:rightView];
                    RELEASE(rightView);
                    
                    arrayResult = [[NSArray alloc]initWithArray:[dict objectForKey:@"typeList"]];
                    [self creatRightBtn];
                    
                    
                   
                    
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setTag:100];
                    [self chooseTab:btn];
                    
                    
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
//WOSOrderCell DOORDER

- (void)handleViewSignal_WOSOrderCell:(MagicViewSignal *)signal{

    if ([signal is:[WOSOrderCell DOORDER]]) {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        [arrayAddorder addObject:dict];
        NSLog(@"-- %@",dict);
    }
}

//62 97
- (void)dealloc
{
    RELEASEDICTARRAYOBJ(arrayAddorder);
    RELEASE(arrayFoodList);
//    RELEASE(arrayResult);
    
    [super dealloc];
}
@end
