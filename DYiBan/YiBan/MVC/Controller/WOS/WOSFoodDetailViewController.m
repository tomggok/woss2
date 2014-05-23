//
//  WOSFoodDetailViewController.m
//  WOS
//
//  Created by apple on 14-2-27.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSFoodDetailViewController.h"
#import "JSONKit.h"
#import "JSON.h"
#import "WOSMakeSureOrderListViewController.h"


@interface WOSFoodDetailViewController (){

    NSMutableArray *arrayAddorder;
}

@end

@implementation WOSFoodDetailViewController
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
        [self.headview setTitle:@"菜的详情"];
        
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        
        [self.view setBackgroundColor:ColorBG];
        [self setButtonImage:self.leftButton setImage:@"back"];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        
        MagicRequest *request = [DYBHttpMethod wosFoodInfo_foodIndex:_dictInfo sAlert:YES receive:self];
        [request setTag:3];
        
        
        
        
    }
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

-(void)creatView:(NSDictionary *)dict{

    UIImageView *iamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f,self.headHeight + 20, 200, 100)];
    NSURL *url = [NSURL URLWithString:[DYBShareinstaceDelegate addIPImage:[dict objectForKey:@"imgUrl"] ]];
    [iamgeView setImageWithURL:url];
    [iamgeView setFrame:CGRectMake(10.0f,self.headHeight + 20, 300, 200)];
    [iamgeView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:iamgeView ];
    RELEASE(iamgeView);
    
    UILabel *labeName = [[UILabel alloc]initWithFrame:CGRectMake(50.0f, CGRectGetHeight(iamgeView.frame) + CGRectGetMinY(iamgeView.frame) + 20,250.0f, 40.0f)];
    [labeName setText:[dict objectForKey:@"foodName"]];
    [labeName setTextColor:[UIColor whiteColor]];
    [self.view addSubview:labeName];
    [labeName release];
    
    UILabel *labePrice = [[UILabel alloc]initWithFrame:CGRectMake(120.0f, CGRectGetHeight(iamgeView.frame) + CGRectGetMinY(iamgeView.frame) + 20,250.0f, 40.0f)];
    [labePrice setText:[NSString stringWithFormat:@"单价： ￥%@/份",[dict objectForKey:@"foodPrice"]]];
    [labePrice setTextColor:[UIColor whiteColor]];
    [self.view addSubview:labePrice];
    [labePrice release];
    
    UIButton *btnBackR = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labePrice.frame) + CGRectGetMinY(labePrice.frame) + 20 + 10, 300, 44)];
    [btnBackR setBackgroundColor:[UIColor clearColor]];
    [btnBackR setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [btnBackR addTarget:self action:@selector(addRisgin) forControlEvents:UIControlEventTouchUpInside];
    [self addlabel_title:@"加入到购物车" frame:btnBackR.frame view:btnBackR];
    [self.view addSubview:btnBackR];
    [btnBackR release];

    
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

-(void)addRisgin{
//    WOSMakeSureOrderListViewController *make = [[WOSMakeSureOrderListViewController alloc]init];
//    
//    
//    [self.drNavigationController pushViewController:make animated:YES];
//    RELEASE(make);

   
    WOSMakeSureOrderListViewController *makeSure = [[WOSMakeSureOrderListViewController alloc]init];
    
    makeSure.arrayAddInfo = arrayAddorder;
//    makeSure.dictInfo = _dictInfo;
    [self.drNavigationController pushViewController:makeSure animated:YES];
    RELEASE(makeSure);

}
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
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
                    
//                    _dictInfo = dict;
//                    [DYBShareinstaceDelegate popViewText:@"收藏成功！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
//                    
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
                    [self creatView:dict];
                    arrayAddorder = [[NSMutableArray alloc]initWithObjects:dict, nil];
//                    dictResult = [[NSDictionary alloc]initWithDictionary:dict];
                    
//                    [self creatView:dict];
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


- (void)dealloc
{
    [_dictInfo release];
    [super dealloc];
}

@end
