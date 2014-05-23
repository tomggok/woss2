//
//  WOSRegisterViewController.m
//  WOS
//
//  Created by apple on 14-5-11.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSRegisterViewController.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"



@interface WOSRegisterViewController (){

    DYBInputView * _phoneInputName;

}

@end

@implementation WOSRegisterViewController

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
        [self.headview setTitle:@"注册"];
        //        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self setButtonImage:self.leftButton setImage:@"返回键"];
        [self.view setBackgroundColor:ColorBG];
        [self.headview setBackgroundColor:[UIColor colorWithRed:40.0f/255 green:191.0f/255 blue:140.0f/255 alpha:1.0f]];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        UIImage *imageK = [UIImage imageNamed:@"框"];
        
        UIImageView *imageViewIcon = [[UIImageView alloc]initWithFrame:CGRectMake((320 - 0 - 60)/2 , self.headHeight + 20, 60.0f, 60.0f)];
        [imageViewIcon setImage:[UIImage imageNamed:@"log"]];
        [self.view addSubview:imageViewIcon];
        [imageViewIcon release];
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        //        arrayTitle = [[NSArray alloc]initWithObjects:@"告诉朋友",@"意见反馈",@"常用问题",@"关于",@"访问订餐网站", nil];
        
        
//        圆角矩形 
        
        UIImage *iamge1 = [UIImage imageNamed:@"圆角矩形 "];
        UIImageView *imageViewName2 = [[UIImageView alloc]initWithFrame:CGRectMake((320-imageK.size.width/2)/2 ,self.headHeight + 60 + 30, imageK.size.width/2, iamge1.size.height/2)];
        [imageViewName2 setImage:[UIImage imageNamed:@"圆角矩形 "]];
        [self.view addSubview:imageViewName2];
        RELEASE(imageViewName2);
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 100, 40)];
        [label1 setBackgroundColor:[UIColor clearColor]];
        [label1 setText:@"姓名："];
        
        
     DYBInputView   *input1 = [[DYBInputView alloc]initWithFrame:CGRectMake(60, 0, INPUTWIDTH, INPUTHEIGHT) placeText:@"填写姓名" textType:0];
        [input1.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor clearColor] CGColor]];
//        [input1.nameField setText:@""];
        [input1.nameField setTextColor:[UIColor whiteColor]];
        [input1 setBackgroundColor:[UIColor clearColor]];
        [imageViewName2 addSubview:input1];
        RELEASE(input1)
        
        
//        DYBInputView *  _phoneInputAddr = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2,self.headHeight + 60, INPUTWIDTH, INPUTHEIGHT)placeText:@"请输入注册时填写的电子邮箱" textType:0];
//        [_phoneInputAddr.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor clearColor] CGColor]];
//        [_phoneInputAddr.nameField setText:@"1"];
//        [_phoneInputAddr.nameField setTextColor:[UIColor whiteColor]];
//        [_phoneInputAddr setBackgroundColor:[UIColor clearColor]];
//        [self.view addSubview:_phoneInputAddr];
//        RELEASE(_phoneInputAddr);
       
        
        UIImageView *imageViewName = [[UIImageView alloc]initWithFrame:CGRectMake((320-imageK.size.width/2)/2, CGRectGetHeight(imageViewName2.frame) + CGRectGetMinY(imageViewName2.frame) + 10, imageK.size.width/2, imageK.size.height/2 )];
        [imageViewName setUserInteractionEnabled:YES];
        [imageViewName setImage:imageK];
        [self.view addSubview:imageViewName];
        RELEASE(imageViewName);
        
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 0.0f,  70 , imageK.size.height/2/2)];
        [labelName setText:@"密码："];
        [labelName setBackgroundColor:[UIColor clearColor]];
        [labelName setTextColor:[UIColor colorWithRed:40.0f/255 green:191.0f/255 blue:140.0f/255 alpha:1.0f]];
        [imageViewName addSubview:labelName];
        RELEASE(labelName);
        
        
        _phoneInputName = [[DYBInputView alloc]initWithFrame:CGRectMake(60, 0, INPUTWIDTH, INPUTHEIGHT) placeText:@"请填写密码" textType:0];
        [_phoneInputName.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor clearColor] CGColor]];
        [_phoneInputName.nameField setText:@"zxw1"];
        [_phoneInputName.nameField setTextColor:[UIColor whiteColor]];
        [_phoneInputName setBackgroundColor:[UIColor clearColor]];
        [imageViewName addSubview:_phoneInputName];
        RELEASE(_phoneInputName)
        
        UILabel *labelmima = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, imageK.size.height/2/2, 70 , imageK.size.height/2/2)];
        [labelmima setText:@"确认："];
        [labelmima setTextColor:[UIColor colorWithRed:40.0f/255 green:191.0f/255 blue:140.0f/255 alpha:1.0f]];
        [labelmima setBackgroundColor:[UIColor clearColor]];
        [imageViewName addSubview:labelmima];
        RELEASE(labelmima);
        
      DYBInputView*  _phoneInputAddr = [[DYBInputView alloc]initWithFrame:CGRectMake(60, imageK.size.height/2/2/2+ 15, INPUTWIDTH, INPUTHEIGHT) placeText:@"确认密码" textType:0];
        [_phoneInputAddr.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor clearColor] CGColor]];
        [_phoneInputAddr.nameField setText:@"zxw1"];
        [_phoneInputAddr.nameField setTextColor:[UIColor whiteColor]];
        [_phoneInputAddr setBackgroundColor:[UIColor clearColor]];
        [imageViewName addSubview:_phoneInputAddr];
        RELEASE(_phoneInputAddr);
        
        
        UIImageView *imageViewName22 = [[UIImageView alloc]initWithFrame:CGRectMake((320-imageK.size.width/2)/2 ,CGRectGetHeight(imageViewName.frame) + CGRectGetMinY(imageViewName.frame) + 10, imageK.size.width/2, iamge1.size.height/2)];
        [imageViewName22 setImage:[UIImage imageNamed:@"圆角矩形 "]];
        [self.view addSubview:imageViewName22];
        RELEASE(imageViewName22);
        
        UILabel *label11 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 100, 40)];
        [label11 setBackgroundColor:[UIColor clearColor]];
        [label11 setText:@"手机："];
        
        
        DYBInputView   *input11 = [[DYBInputView alloc]initWithFrame:CGRectMake(60, 0, INPUTWIDTH, INPUTHEIGHT) placeText:@"填写手机号码" textType:0];
        [input11.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor clearColor] CGColor]];
        //        [input1.nameField setText:@""];
        [input11.nameField setTextColor:[UIColor whiteColor]];
        [input11 setBackgroundColor:[UIColor clearColor]];
        [imageViewName22 addSubview:input11];
        RELEASE(input11)

        
        
        UIButton *btnBack= [[UIButton alloc]initWithFrame:CGRectMake((320 - 44)/2, CGRectGetHeight(imageViewName22.frame) + CGRectGetMinY(imageViewName22.frame) + 20, 44, 44)];
        [btnBack setBackgroundColor:[UIColor clearColor]];
        [btnBack setImage:[UIImage imageNamed:@"剪头"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(addOK) forControlEvents:UIControlEventTouchUpInside];
        //        [self addlabel_title:@"登陆" frame:btnBack.frame view:btnBack];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
