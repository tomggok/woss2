//
//  ViewController.m
//  testlabel
//
//  Created by apple on 13-8-31.
//  Copyright (c) 2013年 tom. All rights reserved.
//

#import "LabelViewController.h"

@interface LabelViewController (){

    UILabel *tt;
    UILabel *tt1;
    int index;
    UIView *min;
    float frame_X;
    NSTimer *timer1;
    float frame_2;
    UIView *min2;
    NSTimer *timer2;
    CGSize sizeStr;
    int index2;
}

@end

@implementation LabelViewController
@synthesize strBanner = _strBanner;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initBlur];
        
//        self.isNeedBlur = NO;
//        [self viewDidLoad];
    }
    return self;
}

- (void)viewDidLoad
{
//    _strBanner = @"dfdfdfdfdfdfdfdfdfdf";
     sizeStr=[_strBanner sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(150, 40)];
    
    index = 0;
//    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(30.0f, 0.0f, 320.0f, 480.0f)];
    [view setTag:801];
    [self addSubview:view];
    
    [view release];
    [view setBackgroundColor:[UIColor redColor]];
    
    tt = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 50.0f)];
//    [view addSubview:tt];
//    [tt release];
    [tt setText:_strBanner];
    
	    
    min = [[UIView alloc]initWithFrame:CGRectMake(60.0f, 0.0f, sizeStr.width, 50.0f)];
    
    [min setTag:880];
    [view addSubview:min];
    [min setBackgroundColor:[UIColor yellowColor]];
    [min release];

    
    min2 = [[UIView alloc]initWithFrame:CGRectMake(260.0f, 0.0f, sizeStr.width, 50.0f)];
    frame_2 = 260;
    [min2 setTag:881];
    [view addSubview:min2];
    [min2 setBackgroundColor:[UIColor greenColor]];
    [min2 release];
    
    
    frame_X = 60.0;
    
        for (int j = 0; j < [tt.text length]; j++) {
            
            NSString *temp = [tt.text  substringWithRange:NSMakeRange(j, 1)];
            CGSize size=[temp sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(150, 40)];
            UILabel*  label = [[UILabel alloc] initWithFrame:CGRectMake(index,0,size.width,size.height)];
            [label setTag:j+1];
            label.text = temp;
            label.backgroundColor = [UIColor clearColor];
 
            if (index>= 10) {
                [label setHidden:YES];
//                [label setBackgroundColor:[UIColor brownColor]];
            }
            [min addSubview:label];
            [label release];

            index=index+size.width;

        }
    
    
    [min setFrame:CGRectMake(60.0f, 0.0f, index, 50.0f)];
    index2 = 0;
    for (int j = 0; j < [tt.text length]; j++) {
        NSString *temp = [tt.text  substringWithRange:NSMakeRange(j, 1)];
        CGSize size=[temp sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(150, 40)];
        UILabel*  label = [[UILabel alloc] initWithFrame:CGRectMake(index2,0,size.width,size.height)];
        [label setTag:j+1];
        label.text = temp;
        label.backgroundColor = [UIColor clearColor];
        
        

        [min2 addSubview:label];
        [label release];
        
        index2=index2+size.width;
        
    }
   [ min2 setFrame:CGRectMake(260.0f, 0.0f, index2, 50.0f)];

    
    if (self.frame.size.width > index ) {
        return;
    }
   timer1 = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(changeFrameX) userInfo:nil repeats:YES];
    timer2 = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(changei) userInfo:nil repeats:YES];
    [timer2 setFireDate:[NSDate distantFuture]];

}
    
 //}
-(void)changeFrameX{
    NSLog(@"6666666");
    frame_X --;
    [min setFrame:CGRectMake(frame_X , 0.0f, index, 50.0f)];

    UIView *view1  = [self viewWithTag:801];
    UIView *view2 = [view1 viewWithTag:880];
    for (UIView* view in [view2 subviews]) {
        if (view.frame.origin. x + frame_X <= 30) {
            [view setHidden:YES];
            NSLog(@"view ---- %@",view);
            NSLog(@"gggggg");
        }else if (view.frame.origin. x + frame_X <= sizeStr.width/2){
            
            [view setHidden:NO];
        }
    }
    
    if (min.frame.origin.x + min.frame.size.width <= 0) {
        
        [timer1 setFireDate:[NSDate distantFuture]];
        [timer2 setFireDate:[NSDate distantPast]];
        [min2 setFrame:CGRectMake(60.0f, 200.0f, index2, 50.0f)];
        frame_2 = 60;
        for (UIView *view in min2.subviews) {
            [view setHidden:NO];
        }
        
    }
}
-(void)changei{
    frame_2 --;
    [min2 setFrame:CGRectMake(frame_2 , 0.0f, index2, 50.0f)];
    
    UIView *view1  = [self viewWithTag:801];
    UIView *view2 = [view1 viewWithTag:881];
    for (UIView* view in [view2 subviews]) {
        if (view.frame.origin. x + frame_2 <= 30) {
            [view setHidden:YES];
            NSLog(@"view ---- %@",view);
            NSLog(@"gggggg");
        }
    }

    if (min2.frame.origin.x + min2.frame.size.width <= 0) {
        
        [timer2 setFireDate:[NSDate distantFuture]];
        [min setFrame:CGRectMake(60.0f, 0.0f, index, 50.0f)];
        frame_X = 60;
        for (UIView *view in min.subviews) {
            [view setHidden:NO];
        }
        [timer1 setFireDate:[NSDate distantPast]];
    }


}
-(void)repeatAnuimation{
    

    [UIView beginAnimations:@"show" context:nil];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:100000.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:2.5];
    frame_X --;
    [min setFrame:CGRectMake(frame_X , 200.0f, 200.0f, 50.0f)];
    
    UIView *view1  = [self viewWithTag:801];
    UIView *view2 = [view1 viewWithTag:880];
    for (UIView* view in [view2 subviews]) {
        if (view.frame.origin. x + frame_X <= 30) {
            [view setHidden:YES];
            NSLog(@"view ---- %@",view);
            NSLog(@"gggggg");
        }
    }

    
    [min setFrame:CGRectMake(-140.0f, 200.0f, 200.0f, 50.0f)];
    [UIView setAnimationsEnabled:YES];
    [UIView commitAnimations];
    
}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if([finished boolValue] == YES)//一定要判断这句话，要不在程序中当多个View刷新的时候，就可能出现动画异常的现象
    {
        //执行想要的动作
        
        
    }else{
        
    }
//    if (!stopAnimation) {
        [self repeatAnuimation];
//    }
    
    
}
- (void)didReceiveMemoryWarning
{
//    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
