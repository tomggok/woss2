//
//  WOSTellMSGViewController.m
//  WOS
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSTellMSGViewController.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"




@interface WOSTellMSGViewController ()

@end

@implementation WOSTellMSGViewController

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
        [self.headview setTitle:@"意见反馈"];
        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self setButtonImage:self.leftButton setImage:@"back"];
        [self.view setBackgroundColor:ColorBG];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        //        arrayTitle = [[NSArray alloc]initWithObjects:@"告诉朋友",@"意见反馈",@"常用问题",@"关于",@"访问订餐网站", nil];
        
        
        UIImageView *tt = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, SEARCHBAT_HIGH + 44, 280.0f, self.view.frame.size.height - SEARCHBAT_HIGH - 44 - 260 )];
        
        UILabel *labeMIMA = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, self.headHeight+ 20, 100.0f, 40.0f)];
        [labeMIMA setText:@"反馈意见："];
        [labeMIMA setBackgroundColor:[UIColor clearColor]];
        [labeMIMA setTextColor:[UIColor whiteColor]];
        [self.view addSubview:labeMIMA];
        RELEASE(labeMIMA);
        
        
        
        UILabel *labeMIMA1 = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, self.headHeight+ 20 + 60, 100.0f, 40.0f)];
        [labeMIMA1 setText:@"反馈内容："];
        [labeMIMA1 setBackgroundColor:[UIColor clearColor]];
        [labeMIMA1 setTextColor:[UIColor whiteColor]];
        [self.view addSubview:labeMIMA1];
        RELEASE(labeMIMA1);
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10.0f, self.headHeight+ 20 + 60 + 50, 300.0f, 100.0f)];
        [textView setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:textView];
        RELEASE(textView);
        
        UILabel *labeMIMA2 = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, self.headHeight+ 20 + 60 + 120, 100.0f, 40.0f)];
        [labeMIMA2 setText:@"联系方式："];
        [labeMIMA2 setBackgroundColor:[UIColor clearColor]];
        [labeMIMA2 setTextColor:[UIColor whiteColor]];
        [self.view addSubview:labeMIMA2];
        RELEASE(labeMIMA2);
        
        DYBInputView *  _phoneInputAddr = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2,self.headHeight+ 20 + 60 + 120 + 60, INPUTWIDTH, INPUTHEIGHT)placeText:@"您的手机号码以方便联系" textType:0];
        [_phoneInputAddr.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor clearColor] CGColor]];
//        [_phoneInputAddr.nameField setText:@"1"];
        [_phoneInputAddr.nameField setTextColor:[UIColor whiteColor]];
        [_phoneInputAddr setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:_phoneInputAddr];
        RELEASE(_phoneInputAddr);
        
        
        
        
        
        
        
        UIImageView *imageViewName2 = [[UIImageView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2,self.headHeight+ 20 + 60 + 120 + 60, INPUTWIDTH, INPUTHEIGHT)];
        [imageViewName2 setImage:[UIImage imageNamed:@"input_bg"]];
        [self.view addSubview:imageViewName2];
        RELEASE(imageViewName2);
        
      
        
        
        UIButton *btnBack= [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(_phoneInputAddr.frame) + CGRectGetMinY(_phoneInputAddr.frame) + 20 + 10, 300, 44)];
        [btnBack setBackgroundColor:[UIColor clearColor]];
        [btnBack setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(addOK) forControlEvents:UIControlEventTouchUpInside];
        [self addlabel_title:@"提交" frame:btnBack.frame view:btnBack];
        [self.view addSubview:btnBack];
        [btnBack release];
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

-(void)addOK{
    
    
    
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


@end
