//
//  DYBDataBankReportViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-11-4.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankReportViewController.h"

@interface DYBDataBankReportViewController ()

@end

@implementation DYBDataBankReportViewController

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
       
        
    
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
       
        
    }
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
        
    }
}

-(void)creatView{

    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20.0f, 44 + 30, 20, 20)];
    [btn1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [btn1 setSelected:NO];
    [self.view addSubview:btn1];
    




}


#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    [self.view setUserInteractionEnabled:YES];
    JsonResponse *response = (JsonResponse *)receiveObj;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
