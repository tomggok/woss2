//
//  WOSMapViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-12-25.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSMapViewController.h"
#import "MapViewController.h"
#import "JSONKit.h"
#import "JSON.h"
#import "WOShopDetailViewController.h"

@interface WOSMapViewController (){

    NSString *strStye; //1-已吃；2-附近；3-附近人在吃；4-猜你喜欢


}

@end

@implementation WOSMapViewController
@synthesize iType,dictMap = _dictMap,arrayXY;
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
        [self.headview setTitle:@"地图"];
        
        [self.headview setTitleColor:[UIColor whiteColor]];
        [self setButtonImage:self.leftButton setImage:@"返回键"];
        [self.view setBackgroundColor:[UIColor colorWithRed:244.0f/255 green:234.0f/255 blue:220.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:40.0f/255 green:191.0f/255 blue:140.0f/255 alpha:1.0f]];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        
        strStye = [[NSString alloc]init];
//        
//        if (iType == 3) {
//            
//            
//            NSArray *array = [NSArray arrayWithObjects:_dictMap, nil];
//
//            MapViewController*   _mapViewController = [[MapViewController alloc] init];
//            _mapViewController.delegate = self;
//            [self.view addSubview:_mapViewController.view];
//            [_mapViewController.view setFrame:CGRectMake(0.0f, self.headHeight  , 320.0f, self.view.bounds.size.height - self.headHeight)];
//            [_mapViewController resetAnnitations:array];
//            
//            return;
//            
//        }

        
       
        
        
               
//        MapViewController*   _mapViewController = [[MapViewController alloc] init];
//        _mapViewController.delegate = self;
//        [self.view addSubview:_mapViewController.view];
//        [_mapViewController.view setFrame:CGRectMake(0.0f, self.headHeight - 34 , 320.0f, self.view.bounds.size.height - self.headHeight)];
//        [_mapViewController resetAnnitations:array];
        
//        for (int i = 0; i< 3; i ++) {
//            
//            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0.0f + i*320/3 + i*1, self.headHeight, 320/3, 30)];
//            //            [btn1 setTitle:@"处理中" forState:UIControlStateNormal];
//            [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
//            [btn1 setTitleColor:ColorGryWhite forState:UIControlStateNormal];
//            switch (i) {
//                case 0:
//                    [btn1 setTitle:@"我已吃过" forState:UIControlStateNormal];
//                    if (iType == 0) {
//                         [btn1 setTitleColor:ColorTextYellow forState:UIControlStateNormal];
//                    }
//                   
//                    break;
//                case 1:
//                    [btn1 setTitle:@"附近美食" forState:UIControlStateNormal];
//                    if (iType == 1) {
//                        [btn1 setTitleColor:ColorTextYellow forState:UIControlStateNormal];
//                    }
//                    break;
//                case 2:
//                    [btn1 setFrame:CGRectMake(0.0f + i*320/3 + i *0.5 , self.headHeight, 320/3, 30)];
//                    [btn1 setTitle:@"附近的人在吃" forState:UIControlStateNormal];
//                    if (iType == 2) {
//                        [btn1 setTitleColor:ColorTextYellow forState:UIControlStateNormal];
//                    }
//                    break;
//                    
//                default:
//                    break;
//            }
//            
//            
//            [btn1 setBackgroundColor:[UIColor blackColor]];
//            [btn1 addTarget:self action:@selector(doSelect:) forControlEvents:UIControlEventTouchUpInside];
//            [btn1 setTag:10 + i];
//            [self.view addSubview:btn1];
//            RELEASE(btn1);
//            
//            
//            if (iType == 3) {
//                [btn1 setHidden:YES];
//            }
//            116.354583,39.982453
            
          
            
//        }
        
//        MagicRequest *request = [DYBHttpMethod wosMapList_userIndex:SHARED.userId gps:@"116.354583,39.982453" radius:@"10000" type:[NSString stringWithFormat:@"%d",iType + 1] sAlert:YES receive:self];
//        [request setTag:3];
        
        
        
        
        
        
        
        MapViewController*   _mapViewController = [[MapViewController alloc] initWithFrame:CGRectMake(0.0f, self.headHeight + 30 , 320.0f, self.view.bounds.size.height - self.headHeight)];
        _mapViewController.delegate = self;
        [self.view addSubview:_mapViewController];
        [_mapViewController resetAnnitations:arrayXY];
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

-(void)doSelect:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    for (int i = 10; i < 13; i++) {
        
        
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:i];
        if (i == btn.tag) {
            
            [btn1 setTitleColor:ColorTextYellow forState:UIControlStateNormal];
        }else{
            
            [btn1 setTitleColor:ColorGryWhite forState:UIControlStateNormal];
        }
    }
    
    
    MagicRequest *request = [DYBHttpMethod wosMapList_userIndex:SHARED.userId gps:@"116.354583,39.982453" radius:@"10000" type:[NSString stringWithFormat:@"%d",btn.tag + 1 - 10] sAlert:YES receive:self];
    [request setTag:3];
}



- (void)customMKMapViewDidSelectedWithInfo:(id)info
{
    NSLog(@"%@",info);
    
    WOShopDetailViewController *detail = [[WOShopDetailViewController alloc]init];
    detail.dictInfo = info;
    [self.drNavigationController pushViewController:detail animated:YES];
    RELEASE(detail);
    
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
                    
                    NSArray *gpsList = [dict objectForKey:@"kitchenList"];
//                    NSMutableArray *arryResult = [[NSMutableArray alloc]init];
//                    
//                    for (int i = 0; i < gpsList.count; i++) {
//                        
//                        NSString *strJINWEI = [[gpsList objectAtIndex:i] objectForKey:@"gps"];
//                        NSArray *arrayStr = [strJINWEI componentsSeparatedByString:@","];
//                        NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:[arrayStr objectAtIndex:0],@"latitude",[arrayStr objectAtIndex:1],@"longitude",nil];
//                        [arryResult addObject:dict1];
//                    }
                    
                    
                    MapViewController*   _mapViewController = [[MapViewController alloc] initWithFrame:CGRectMake(0.0f, self.headHeight + 30 , 320.0f, self.view.bounds.size.height - self.headHeight)];
                    _mapViewController.delegate = self;
                    [self.view addSubview:_mapViewController];
                    [_mapViewController resetAnnitations:gpsList];
                    
//                    _mapViewController.dic;
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



- (void)handleViewSignal_MapViewController:(MagicViewSignal *)signal{



}


- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
    }
}
- (void)dealloc
{
    
    [super dealloc];
}

@end
