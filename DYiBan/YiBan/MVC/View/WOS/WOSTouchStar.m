//
//  WOSTouchStar.m
//  DYiBan
//
//  Created by tom zeng on 13-12-20.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSTouchStar.h"

@implementation WOSTouchStar
@synthesize numStar;
- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self touchStar];
    }
    return self;
}
-(void)touchStar{

    
    UIImage *imageS = [UIImage imageNamed:@"22_07"];

    for (int i = 0; i < 5; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(imageS.size.width/2 * i, 0,imageS.size.width/2, imageS.size.height/2)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTag:i + 10];
        [btn setImage:imageS forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        RELEASE(btn);
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:12];
    [self touchTap:btn];
}

-(void)touchTap:(id)sender{

    
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    numStar = tag - 10 + 1;
    
    for (int i = 10;  i<= tag; i++) {
        UIButton *btnChange = (UIButton *)[self viewWithTag:i];
        if(btnChange){
            [btnChange setImage:[UIImage imageNamed:@"22_06"] forState:UIControlStateNormal];
        }
    }

    for (int i = tag+1 ; i< 15; i++) {
        UIButton *btnChange = (UIButton *)[self viewWithTag:i];
        if(btnChange){
            [btnChange setImage:[UIImage imageNamed:@"22_07"] forState:UIControlStateNormal];
        }
    }
    
}

@end
