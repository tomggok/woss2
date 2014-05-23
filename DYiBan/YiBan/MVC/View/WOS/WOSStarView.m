//
//  WOSStarView.m
//  DYiBan
//
//  Created by tom zeng on 13-12-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSStarView.h"

@implementation WOSStarView

- (id)initWithFrame:(CGRect)frame num:(int)num
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self creatStar:num];
    }
    return self;
}

-(void)creatStar:(int)num{

    UIImage *imageS = [UIImage imageNamed:@"22_06"];
    
    for (int i = 0; i < num; i++) {
        UIImageView *imageViewGood3 = [[UIImageView alloc]initWithFrame:CGRectMake(imageS.size.width/2 * i, 0,imageS.size.width/2, imageS.size.height/2)];
        [imageViewGood3 setBackgroundColor:[UIColor clearColor]];
        [imageViewGood3 setImage:[UIImage imageNamed:@"22_06"]];
        [self addSubview:imageViewGood3];
        RELEASE(imageViewGood3);
    }
    int hui = 5 - num;
    
    for (int j = 0; j< hui; j++) {
        UIImageView *imageViewGood3 = [[UIImageView alloc]initWithFrame:CGRectMake(imageS.size.width/2 * (num+ j), 0,imageS.size.width/2, imageS.size.height/2)];
        [imageViewGood3 setBackgroundColor:[UIColor clearColor]];
        [imageViewGood3 setImage:[UIImage imageNamed:@"22_07"]];
        [self addSubview:imageViewGood3];
        RELEASE(imageViewGood3);
    }

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
