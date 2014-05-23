//
//  WOSAddCommentViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-12-24.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSAddCommentViewController.h"
#import "WOSTouchStar.h"
#import "JSONKit.h"
#import "JSON.h"


@interface WOSAddCommentViewController (){
    UIScrollView *scrollView;
    MagicUITextView *textView;
    WOSTouchStar *touchStar;
}

@end

@implementation WOSAddCommentViewController
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


-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        [self.headview setTitle:@"添加评论"];
        
        [self.headview setTitleColor:[UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f]];
        [self.view setBackgroundColor:ColorBG];
        [self setButtonImage:self.leftButton setImage:@"back"];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 0, 320.0f, 480)];
        
        [self.view addSubview:scrollView];
        RELEASE(scrollView);
        
//        [self creatBar];
        
        
        UILabel *labelTouchStar = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 44 + 20, 250.0f, 40)];
        [labelTouchStar setText:@"点击小星星来打分吧:"];
        [labelTouchStar setTextColor:[UIColor whiteColor]];
        [labelTouchStar setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:labelTouchStar];
        RELEASE(labelTouchStar);
        
        
        
        touchStar = [[WOSTouchStar alloc]initWithFrame:CGRectMake(190.0f, 44 + 20+ 8 + 3, 100.0f, 40.0f)];
        [scrollView addSubview:touchStar];
        RELEASE(touchStar);
        
        
        
        UILabel *labelB = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 60.0f + 40 , 100, 40)];
        [labelB setText:@"输入评论:"];
        [labelB setTextColor:[UIColor whiteColor]];
        [labelB setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:labelB];
        [labelB release];
        
        UIImageView *imageViewTextBG =[[UIImageView alloc]initWithFrame:CGRectMake(10, 160- 4, 300, 170.0f)];
        [scrollView addSubview:imageViewTextBG];
        [imageViewTextBG setImage:[UIImage imageNamed:@"text_area"]];
        RELEASE(imageViewTextBG);
        
        
        textView = [[MagicUITextView alloc]initWithFrame:CGRectMake(10.0f, 60.0f + 40 + 60,300.0f, 170.0f)];
        [textView setBackgroundColor:[UIColor clearColor]];
        [textView setTextColor:[UIColor whiteColor]];
        [scrollView addSubview:textView];
        RELEASE(textView);
        
        UIButton *btnBack = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(textView.frame) + CGRectGetMinY(textView.frame)  + 30, 300, 44)];
        
        [scrollView addSubview:btnBack];
        [btnBack setBackgroundColor:[UIColor clearColor]];
        [btnBack setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [btnBack release];
        
        [btnBack addTarget:self action:@selector(addOK) forControlEvents:UIControlEventTouchUpInside];
        
        [self addlabel_title:@"提交评论" frame:btnBack.frame view:btnBack];
        
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
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

    MagicRequest *request = [DYBHttpMethod wosKitchenInfo_commentadd:[_dictInfo objectForKey:@"kitchenIndex"] orderIndex:@"2" userIndex:SHARED.userId commentType:@"1" starLevel:[NSString stringWithFormat:@"%d",touchStar.numStar] comment:textView.text sAlert:YES receive:self];
    [request setTag:2];

}

-(void)handleViewSignal_MagicUITextView:(MagicViewSignal *)signal{
    if ([signal isKindOf:[MagicUITextView TEXTVIEWSHOULDBEGINEDITING]]) {
        
        [scrollView setContentSize:CGSizeMake(320.0f, CGRectGetHeight(self.view.frame)*1.2)];
    }
    else if ([signal isKindOf:[MagicUITextView TEXTVIEWDIDENDEDITING]]){
        
        MagicUITextField *filed = (MagicUITextField *)[signal source];
        [filed resignFirstResponder];
        
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
                    
                    [self.drNavigationController popViewControllerAnimated:YES];
                    
                   
                    
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
                    
                    UIButton *btn = (UIButton *)[UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setTag:10];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    
    [super dealloc];
}
@end
