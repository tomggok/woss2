//
//  WOSOrderLastViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-12-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSOrderLastViewController.h"
#import "WOSCalculateOrder.h"
#import "JSONKit.h"
#import "JSON.h"


@interface WOSOrderLastViewController (){
    UIScrollView *viewBG1;
    UIView *viewBG;
    UITextView *textViewReply;
}

@end

@implementation WOSOrderLastViewController

@synthesize fTotalPrice =  _fTotalPrice,dictInfo = _dictInfo;
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

        [self.headview setTitle:@"确认订单"];
        [self.headview setTitleColor:[UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f]];

        [self setButtonImage:self.leftButton setImage:@"back"];
        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        viewBG = [[UIView alloc]initWithFrame:self.view.frame];
        [viewBG setCenter:CGPointMake(160.0f, self.view.center.y)];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        viewBG1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, self.view.frame.size.height - 44)];
        [viewBG1 setBackgroundColor:ColorBG];
        [self.view addSubview:viewBG1];
        RELEASE(viewBG1);
        
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 15, 280, 568 - 200)];
        [view1 setBackgroundColor:[UIColor whiteColor]];
        [viewBG1 addSubview:view1];
        RELEASE(view1);
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoveryFrame)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [viewBG1 addGestureRecognizer:tap];
        RELEASE(tap);
        
        [self.view setBackgroundColor:[UIColor clearColor]];

        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(30.0f,  30.0f, 200, 30)];
        [labelName setText:@"娄关山烤鸭店"];
        [viewBG1 addSubview:labelName];
        RELEASE(labelName);
        
        
        UILabel *priceTotal = [[UILabel alloc]initWithFrame:CGRectMake(200, 30, 100.0f, 30.0f)];
        [priceTotal setText:[NSString stringWithFormat: @"￥ %.1f",_fTotalPrice]];
        [priceTotal setBackgroundColor:[UIColor clearColor]];
        [priceTotal setTextColor:[UIColor redColor]];
        [viewBG1 addSubview:priceTotal];
        RELEASE(priceTotal);
        
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(30.0f, CGRectGetHeight(priceTotal.frame) + CGRectGetMidY(priceTotal.frame), 270, 1)];
        [imageView1 setBackgroundColor:[UIColor colorWithRed:222.0f/255 green:222.0f/255 blue:222.0f/255 alpha:1.0f]];
        [viewBG1 addSubview:imageView1];
        RELEASE(imageView1)
        
        UILabel *labelUserName = [[UILabel alloc]initWithFrame:CGRectMake(30, 44 + 10 + 30, 150.0f, 30.0f)];
        [labelUserName setText:@"收货人：Tom"];
        [labelUserName setBackgroundColor:[UIColor clearColor]];
        [viewBG1 addSubview:labelUserName];
        RELEASE(labelUserName);
        
        
        
        UILabel *phoneNUM = [[UILabel alloc]initWithFrame:CGRectMake(180, 44 + 10 + 30, 150.0f, 30.0f)];
        [phoneNUM setText:@"138172110110"];
        [phoneNUM setBackgroundColor:[UIColor clearColor]];
        [viewBG1 addSubview:phoneNUM];
        RELEASE(phoneNUM);
        
        
        UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(30,CGRectGetMinY(phoneNUM.frame) + CGRectGetHeight(phoneNUM.frame), 300.0f, 30.0f)];
        [labelAddr setText:@"上海市国康路100号21楼"];
        [labelAddr setBackgroundColor:[UIColor clearColor]];
        [viewBG1 addSubview:labelAddr];
        RELEASE(labelAddr);
        

        
        
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(30.0f, CGRectGetHeight(labelAddr.frame) + CGRectGetMidY(labelAddr.frame), 270, 1)];
        [imageView2 setBackgroundColor:[UIColor colorWithRed:222.0f/255 green:222.0f/255 blue:222.0f/255 alpha:1.0f]];
        [viewBG1 addSubview:imageView2];
        RELEASE(imageView2)
        
        
        UILabel *numPerple = [[UILabel alloc]initWithFrame:CGRectMake(30.0f, CGRectGetMinY(labelAddr.frame) + CGRectGetHeight(labelAddr.frame)  + 30, 150, 30)];
        [numPerple setText:@"用餐人数："];
        [numPerple setBackgroundColor:[UIColor clearColor]];
        [viewBG1 addSubview:numPerple];
        RELEASE(numPerple);
        
        WOSCalculateOrder *calculate = [[WOSCalculateOrder alloc]initWithFrame:CGRectMake(200.0f, CGRectGetMinY(labelAddr.frame) + CGRectGetHeight(labelAddr.frame)  + 35, 100, 10)];
        [viewBG1 addSubview:calculate];
        RELEASE(calculate);
        
        UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(30.0f, CGRectGetHeight(calculate.frame) + CGRectGetMidY(calculate.frame), 270, 1)];
        [imageView3 setBackgroundColor:[UIColor colorWithRed:222.0f/255 green:222.0f/255 blue:222.0f/255 alpha:1.0f]];
        [viewBG1 addSubview:imageView3];
        RELEASE(imageView3)
        
        textViewReply = [[UITextView alloc]initWithFrame:CGRectMake(20.0f + 20, CGRectGetMinY(calculate.frame) + CGRectGetHeight(calculate.frame)  + 30, 280 - 40, 100)];
        [textViewReply setBackgroundColor:[UIColor grayColor]];
        [textViewReply setDelegate:self];
        [viewBG1 addSubview:textViewReply];
        RELEASE(textViewReply);
        
        
        textViewReply.text = @"回复！";
        textViewReply.textColor = [UIColor lightGrayColor];
        
        UIImage *image1 = [UIImage imageNamed:@"button_l"];
        
        UIButton *btnNext = [[UIButton alloc]initWithFrame:CGRectMake((320 - image1.size.width/2)/2, CGRectGetHeight(view1.frame) + CGRectGetMinY(view1.frame)  + 20 , image1.size.width/2, image1.size.height/2)];
        [btnNext setImage:image1 forState:UIControlStateNormal];
        [btnNext setBackgroundColor:[UIColor redColor]];
        [self addlabel_title:@"确认下单" frame:btnNext.frame view:btnNext];
        [btnNext addTarget:self action:@selector(doOK) forControlEvents:UIControlEventTouchUpInside];
        [viewBG1 addSubview:btnNext];
        RELEASE(btnNext);
        
        [viewBG1 setContentSize:CGSizeMake(320.0f, 524)];
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
        
    }
}

-(void)doOK{


    
    MagicRequest *request = [DYBHttpMethod wosKitchenInfo_orderadd_userIndex:SHARED.userId  kitchenIndex:[_dictInfo objectForKey:@"kitchenIndex"] userAddrIndex:[NSString stringWithFormat:@"1"] persons:[NSString stringWithFormat:@"2"] remarks:[NSString stringWithFormat:@"eeeee"] dealsIndexs:nil foodIndexs:[NSString stringWithFormat:@"1"] countIndexs:@"1" sAlert:YES receive:self];
    [request setTag:3];

}

-(void)textViewDidBeginEditing:(UITextView *)textView{

    
    [UIView animateWithDuration:0.3 animations:^{
        [viewBG1 setCenter:CGPointMake(160.0f, self.view.center.y/2/2)];
        
    }];
    
    textView.text=@"";
    textView.textColor = [UIColor blackColor];

}

-(void)recoveryFrame{
    
    [textViewReply resignFirstResponder];

    [UIView animateWithDuration:0.3 animations:^{
        [viewBG1 setCenter:CGPointMake(160.0f, self.view.center.y + 30)];
    
    }];
    
    
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



- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
    }
}
//222  141

- (void)dealloc
{
    RELEASE(_dictInfo);
    [super dealloc];
}
@end
