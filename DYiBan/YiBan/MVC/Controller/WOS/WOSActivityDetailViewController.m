//
//  WOSActivityDetailViewController.m
//  WOS
//
//  Created by tom zeng on 14-2-21.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSActivityDetailViewController.h"
#import "JSONKit.h"
#import "JSON.h"
#import "WOSALLOrderViewController.h"

@interface WOSActivityDetailViewController (){

    NSDictionary *dicInfo;

}

@end

@implementation WOSActivityDetailViewController
@synthesize dictInfo;
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
        [self.headview setTitle:@"活动详情"];
        
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        
        [self.view setBackgroundColor:ColorBG];
        [self setButtonImage:self.leftButton setImage:@"back"];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.view setBackgroundColor:[UIColor clearColor]];
//        dicInfo = [[NSDictionary alloc]init];
        
        MagicRequest *request = [DYBHttpMethod wosKitchenInfo_activityInfo_Index:[dictInfo objectForKey:@"activityIndex"] sAlert:YES receive:self];
        [request setTag:3];
      
       
    }
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

-(void)creatView:(NSDictionary *)dict{

    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, self.headHeight + 10, 280, 200)];
    UIImage *imageNew = [[UIImage imageNamed:@"text_area"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.5, 10.5 , 10.5,10.5)];
    [imageView setImage:imageNew];
    [self.view addSubview:imageView];
    RELEASE(imageView);
    
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, self.headHeight + 20.0f, 100.0f, 40.0f)];
    [labelName setText:[dictInfo objectForKey:@"kitchenName"]];
    [labelName setTextColor:[UIColor whiteColor]];
    [self.view addSubview:labelName];
    RELEASE(labelName);
    
    UILabel *labelContent = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(labelName.frame) + CGRectGetMinY(labelName.frame), 100.0f, 40.0f)];
    [labelContent setText:[dictInfo objectForKey:@"activityTitle"]];
    [labelContent setTextColor:[UIColor whiteColor]];
    [self.view addSubview:labelContent];
    RELEASE(labelContent);
    
    UILabel *labelTime= [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(labelContent.frame) + CGRectGetMinY(labelContent.frame), 100.0f, 40.0f)];
    [labelTime setText:[dictInfo objectForKey:@"rrrrrrr"]];
    [labelTime setTextColor:[UIColor whiteColor]];
    [self.view addSubview:labelTime];
    RELEASE(labelTime);
    
    UIImageView *imageViewSep = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(labelContent.frame) + CGRectGetMinY(labelContent.frame), 280, 1)];
    [imageViewSep setImage:[UIImage imageNamed:@"个人中心_line"]];
    [self.view addSubview:imageViewSep];
    RELEASE(imageViewSep);
    
    float higt = [[dictInfo objectForKey:@""] sizeWithFont:[UIFont systemFontOfSize:12]].height;
    UILabel *labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(labelTime.frame) + CGRectGetMinY(labelTime.frame), 100.0f, 40.0f)];
    [labelDetail setText:[dictInfo objectForKey:@"comment"]];
    [labelDetail setTextColor:[UIColor whiteColor]];
    [self.view addSubview:labelDetail];
    RELEASE(labelDetail);
    
    
    
    
    
    
    UIButton *btnBack = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelDetail.frame) + CGRectGetMinY(labelDetail.frame) + 35+ 50, 300, 44)];
    [btnBack setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(addOK) forControlEvents:UIControlEventTouchUpInside];
    [self addlabel_title:@"立即点餐" frame:btnBack.frame view:btnBack];
    
    [self.view addSubview:btnBack];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    
    [btnBack release];

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

-(void)addOK{

    WOSALLOrderViewController *order = [[WOSALLOrderViewController alloc]init];
    order.dictInfo = dictInfo;
    [self.drNavigationController pushViewController:order animated:YES];
    RELEASE(order);


}

- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        //        JsonResponse *response = (JsonResponse *)receiveObj;
        if(request.tag == 3){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
//                    dictInfo = dict;
                    
                    [self creatView:dict];
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


- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
    }
}

@end
