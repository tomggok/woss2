//
//  WOSCalculateOrder.m
//  DYiBan
//
//  Created by tom zeng on 13-12-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSCalculateOrder.h"


@implementation WOSCalculateOrder{

   
}


@synthesize lableMid;

DEF_SIGNAL(DOREDUCE);
DEF_SIGNAL(DOADD);
@synthesize name;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), 120, 40)];
        [self creatView];
    }
    return self;
}

-(void)creatView{

    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 40.0f)];
    [view setBackgroundColor:[UIColor clearColor]];
    [self addSubview:view];
    RELEASE(view);
    
    UIImage *image1 = [UIImage imageNamed:@"number_substract"];
    UIButton *btnLeft = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, image1.size.width/2, image1.size.height/2)];
    [btnLeft setImage:image1 forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
    [btnLeft setTitle:@"-" forState:UIControlStateNormal];
    [btnLeft setTitle:@"-" forState:UIControlStateHighlighted];
//    [btnLeft setBackgroundColor:[UIColor redColor]];
    [btnLeft addTarget:self action:@selector(minusFood) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnLeft];
    RELEASE(btnLeft);
    
    
    UIImage *imageLabel = [UIImage imageNamed:@"number"];
    UIImageView *imageViewMid = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(btnLeft.frame), 0, imageLabel.size.width/2, imageLabel.size.height/2)];
    [imageViewMid setImage:imageLabel];
    [view addSubview:imageViewMid];
    RELEASE(imageLabel)
    
    lableMid = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, imageLabel.size.width/2, imageLabel.size.height/2)];
    [lableMid setText:@"0"];
    [lableMid setTextAlignment:NSTextAlignmentCenter];
    [lableMid setBackgroundColor:[UIColor clearColor]];
   
    [imageViewMid addSubview:lableMid];
    RELEASE(lableMid);
    
    UIImage *image2 = [UIImage imageNamed:@"number_substract_add"];
    UIButton *btnRight = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewMid.frame) + CGRectGetMinX(imageViewMid.frame), 0.0f, image2.size.width/2, image2.size.height/2)];
    [btnRight setImage:image2 forState:UIControlStateNormal];
    [btnRight setTitle:@"+" forState:UIControlStateNormal];
    [btnRight setTitle:@"+" forState:UIControlStateHighlighted]; 
//    [btnRight setBackgroundColor:[UIColor redColor]];
    [btnRight addTarget:self action:@selector(addFood) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnRight];
    RELEASE(btnRight);

    [view setFrame:CGRectMake(0.0f, 0.0f, CGRectGetMinX(btnRight.frame) + CGRectGetWidth(btnRight.frame), CGRectGetHeight(btnRight.frame))];
}


-(void)minusFood{
    
    int numFood = [lableMid.text integerValue];
    if (numFood == 0) {
        
    }else{
        
        numFood --;
    }
    
    lableMid.text = [NSString stringWithFormat:@"%d",numFood];
    [self sendViewSignal:[WOSCalculateOrder DOREDUCE] withObject:name from:self target:self.superview];
}

-(void)addFood{
    
    int numFood = [lableMid.text integerValue];
    numFood ++;
    lableMid.text = [NSString stringWithFormat:@"%d",numFood];
    
    [self sendViewSignal:[WOSCalculateOrder DOADD] withObject:name from:self target:self.superview];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
